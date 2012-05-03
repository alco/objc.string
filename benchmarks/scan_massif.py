def scan(string):
    target_str = 'mem_heap_B='
    index = string.find('heap_tree=peak')
    target = string.rfind(target_str, 0, index)
    linebreak = string.find('\n', target, index)
    return string[target+len(target_str):linebreak]


if __name__ == '__main__':
    import sys

    with open(sys.argv[1]) as in_file:
        data = in_file.read()
    print '%s KB' % (int(scan(data)) / 1000.0)

