import re

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

CLANG_MEM = """clang -O0 -g -xobjective-c -framework Foundation bench.m ../objc.string/NSString+ObjCString.m ../objc.string/str_primitives.m -o build/{} -"""
CLANG_PERF= """clang -O3 -xobjective-c -framework Foundation bench.m ../objc.string/NSString+ObjCString.m ../objc.string/str_primitives.m -o build/{} -"""


def parse(string):
    defs, data = string.split('///')

    lines = filter(bool, [x.strip() for x in data.splitlines()])

    # First line -- the input and control strings
    input_str, control_str = ["@" + x.strip() for x in lines[0].split('->')]

    # Second line -- stock method
    stock_name, stock_fptr = lines[1].split(',')
    stock_name = "@" + stock_name
    stock_name_raw = re.match(r'@"(.+)"', stock_name).group(1)

    # Third line -- test function name
    name = "@" + lines[2]
    prog_name = re.match(r'"(.+)"', lines[2]).group(1) + '_'

    # Remaining lines -- function pointers
    fptrs = lines[3:]

    files = []
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
    import subprocess
    import sys

    with open(sys.argv[1]) as in_file:
        files = parse(in_file.read())

    print files[0][1]
    print "Compiling %s..." % files[0][0]
    p = subprocess.Popen(CLANG_PERF.format(files[0][0]), shell=True, stdin=subprocess.PIPE)
    p.communicate(input=files[0][1])

    for name, f in files[1]:
        print "Compiling %s..." % name
        p = subprocess.Popen(CLANG_MEM.format(name), shell=True, stdin=subprocess.PIPE)
        p.communicate(input=f)
