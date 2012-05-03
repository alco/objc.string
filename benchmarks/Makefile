all: chain

CLANG_PERF=clang -O3 -framework Foundation bench.m ../objc.string/NSString+ObjCString.m ../objc.string/str_primitives.m
CLANG_MEM=clang -O0 -g -framework Foundation bench.m ../objc.string/NSString+ObjCString.m ../objc.string/str_primitives.m

chain:
	$(CLANG) -DTEST_FUNC=test_chain -o chain

nochain:
	$(CLANG) -DTEST_FUNC=test_nochain -o nochain

chain-mem: chain
	valgrind --tool=massif --time-unit=B --depth=3 --massif-out-file=chain.memory ./clang_test

nochain-mem: nochain
	valgrind --tool=massif --time-unit=B --depth=3 --massif-out-file=nochain.memory ./nochain

lowercase:
	$(CLANG_PERF) lowercase.m -o build/lowercase_perf

splice:
	$(CLANG_PERF) splice.m -o splice.bin

clean:
	rm -rf build
