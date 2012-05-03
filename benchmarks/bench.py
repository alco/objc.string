import argparse
import re
import os
import sys

sys.path.insert(0, './utils')
import codegen


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description="Benchmark generator/compiler/runner")
    parser.add_argument('file', nargs='*', help="Benchmark functions to build")
    parser.add_argument('--all', action='store_true', help="Build all benchmark functions")
    parser.add_argument('--mem-only', action='store_true', help="Build only memory benchmarks")
    parser.add_argument('--perf-only', action='store_true', help="Build only performance benchmarks")
    args = parser.parse_args()

    if not (args.all or args.file):
        print "Specify at least one file or pass the --all flag\n"
        print parser.format_usage()
        exit(1)

    if args.all:
        # Discover all .m files in the current directory
        files = [x for x in os.listdir('.') if x.endswith('.m')]
        files.remove('bench.m')
    else:
        files = args.file

    codegen.compile_files(files, args.mem_only, args.perf_only)
