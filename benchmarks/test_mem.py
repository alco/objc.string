import subprocess
import sys


VALGRIND = """valgrind --tool=massif --time-unit=B --depth=3 --massif-out-file={0}.memory ./{0}"""


if __name__ == '__main__':
    subprocess.call(VALGRIND.format(sys.argv[1]), shell=True)
