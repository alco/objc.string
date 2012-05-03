import collections
import os
import re
import subprocess


TEMPLATE_MEM = """
int main()
{{
    @autoreleasepool {{
        def_mem_bench({}, {}, {}, {}, {});
    }}
    return 0;
}}
"""

TEMPLATE_PERF = """
int main()
{{
    @autoreleasepool {{
        def_bench({}, {}, {}, {}, {});
    }}
    return 0;
}}
"""

#CLANG_MEM = """clang -O0 -g -xobjective-c -framework Foundation bench.m ../objc.string/NSString+ObjCString.m ../objc.string/str_primitives.m -o build/{} -"""
#CLANG_PERF= """clang -O3 -xobjective-c -framework Foundation bench.m ../objc.string/NSString+ObjCString.m ../objc.string/str_primitives.m -o build/{} -"""
CLANG_MEM = """clang -c -O0 -g -xobjective-c -o {}.o -"""
CLANG_PERF = """clang -c -O3 -xobjective-c -o {}.o -"""
CLANG_LINK_PERF = """clang -framework Foundation bench.o NSString+ObjCString.o str_primitives.o build/tmp/{0}.o -o build/{0}"""


def compile_files(files, mem_only=False, perf_only=False):
    out_path = 'build/tmp'
    try:
        os.makedirs(out_path)
    except OSError:
        pass

    for filename in files:
        with open(filename) as in_file:
            targets = parse(in_file.read())


        if not targets:
            print '------------------'
            print '*** Badly formatted file: %s' % filename
            print '------------------'
            continue

        if perf_only or not mem_only:
            perf_filename = targets[0][0]
            perf_contents = targets[0][1]
            path = os.path.join(out_path, perf_filename)

            print "Compiling %s to %s..." % (perf_filename, out_path)
            p = subprocess.Popen(CLANG_PERF.format(path), shell=True, stdin=subprocess.PIPE)
            p.communicate(input=perf_contents)

            print "Linking..."
            subprocess.call(CLANG_LINK_PERF.format(perf_filename), shell=True)

            print "Running 3 times..."
            outputs = []
            for i in range(3):
                p = subprocess.Popen([os.path.join('build', perf_filename)], stderr=subprocess.PIPE)
                outputs.append(p.communicate()[1])

            result = collections.OrderedDict()
            for run in outputs:
                lines = run.splitlines()
                for line in lines:
                    stars_index = line.find('***')
                    average_index = line.find('Average')
                    if stars_index >= 0:
                        key = line[stars_index:]
                        if not (key in result):
                            result[key] = 0
                    elif average_index >= 0:
                        result[key] += int(re.match(r'.+?(\d+).+', line[average_index:]).group(1))

            for k, v in result.items():
                print k
                print '    Average iteration time = %s ns' % (v/3)


        if mem_only or not perf_only:
            for name, contents in targets[1]:
                path = os.path.join(out_path, name)
                print "Compiling %s to %s..." % (name, out_path)
                p = subprocess.Popen(CLANG_MEM.format(path), shell=True, stdin=subprocess.PIPE)
                p.communicate(input=contents)


def parse(contents):
    try:
        defs, data = contents.split(r'// *** \\')
    except ValueError:
        return

    lines = filter(bool, [x.strip() for x in data.splitlines()])

    # First line -- the input and control strings
    input_str, control_str = ["@" + x.strip() for x in lines[0].split('->')]

    # Second line -- stock method
    if lines[1] != 'NULL':
        stock_name, stock_fptr = lines[1].split(',')
        stock_name = "@" + stock_name
        stock_name_raw = re.match(r'@"(.+)"', stock_name).group(1)
    else:
        stock_name = None
        stock_fptr = "NULL"

    # Third line -- test function name
    name = "@" + lines[2]
    prog_name = re.match(r'"(.+)"', lines[2]).group(1) + '_'

    # Remaining lines -- function pointers
    fptrs = lines[3:]

    files = []
    if stock_name:
        files.append((prog_name + stock_name_raw, defs + TEMPLATE_MEM.format(input_str, control_str, stock_name, stock_fptr, 0)))

    for fptr in fptrs:
        files.append((prog_name + fptr, defs + TEMPLATE_MEM.format(input_str, control_str, name, fptr, 0)))
        files.append((prog_name + fptr + "_chain", defs + TEMPLATE_MEM.format(input_str, control_str, name, fptr, 1)))


    funs = []
    for f in fptrs:
        funs.append(f)
        funs.append('@"%s"' % f)
    funs.append("NULL")
    funs = ",".join(funs)

    perf_file = (prog_name + "perf", defs + TEMPLATE_PERF.format(name, stock_fptr, input_str, control_str, funs))

    return perf_file, files


if __name__ == '__main__':
    import sys

    with open(sys.argv[1]) as in_file:
        files = parse(in_file.read())

    try:
        os.makedirs('build/tmp')
    except OSError:
        pass

    print "Compiling %s..." % files[0][0]
    p = subprocess.Popen(CLANG_PERF.format(files[0][0]), shell=True, stdin=subprocess.PIPE)
    p.communicate(input=files[0][1])

    for name, f in files[1]:
        print "Compiling %s..." % name
        p = subprocess.Popen(CLANG_MEM.format(name), shell=True, stdin=subprocess.PIPE)
        p.communicate(input=f)
