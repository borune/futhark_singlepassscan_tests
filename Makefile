FUTHARK = ~/.local/bin/futhark
# SIZES = 524288
SIZES = 1 7 13 42 8704 32768 524288 1048576
# 65536 131072 262144 524288 1048576 16777216
# 33 1024 1025 2048 8704

# all: compile compile-scanomap_2-opencl dump-scanomap_2 test
all: compile test-simple test-scanomap

allcuda: compile compile-simple-cuda dump-cuda test-cuda

compile:
	cd ../futhark && stack install --fast

test-simple:
	$(FUTHARK) test --backend=opencl simple.fut

test-scanomap:
	$(FUTHARK) test --backend=opencl scanomap.fut

# compile-scanomap_2-opencl:
# 	$(FUTHARK) opencl tests/scan/scanomap_2.fut

benchit:
	$(FUTHARK) bench --backend=cuda --runs=1 scan-bench.fut

benchcl:
	$(FUTHARK) bench --backend=opencl --runs=1 scan-bench.fut

compare:
	$(FUTHARK) c compare.fut
	cat data/[100000000]i32.in data/scan-bench:scanplus-[100000000]i32.out | ./compare


compile-simple-opencl:
	$(FUTHARK) opencl simple.fut

compile-simple-cuda:
	$(FUTHARK) cuda tests/scan/simple.fut

run-simple:
	echo "[1,2,3,4,5,6,7,8]" | ./tests/scan/simple

dump-scanomap_2:
	./tests/scan/scanomap_2 --dump-opencl tests/scan/scanomap_2-kernel.c

gpu-simple:
	$(FUTHARK) dev --gpu tests/scan/simple.fut > tests/scan/simple.gpu

gpu-seg:
	$(FUTHARK) dev --gpu tests/scan/seg-scan.fut > tests/scan/seg.gpu

dump-fused:
	$(FUTHARK) dev --gpu tests/intragroup/scan0.fut > tests/intragroup/scan0.gpu
	# ./tests/intragroup/scan0 --dump-opencl tests/intragroup/scan0-kernel.c

dump-simple:
	./simple --dump-opencl simple-kernel.c

# compare:
# 	futhark opencl compare.fut

load-simple: compare
	./simple --load-opencl simple-kernel.c < kA-131072.data > result-131072.data
	cat kA-131072.data result-131072.data | ./compare

test:
	$(FUTHARK) test --backend=opencl tests/scan/scanomap_2.fut


test-cuda: $(SIZES:%=kA-%.data)
	$(FUTHARK) test --backend=cuda tests/scan/scanomap_2.fut

kA-%.data:
	futhark dataset --i32-bounds=-10000:10000 -g [$*]i32 > $@

ntest: $(SIZES:%=kA-%.data)
	$(FUTHARK) test --backend=cuda tests/scan/n-tests.fut


compile64:
	$(FUTHARK) opencl tests/scan/scan64.fut
dump-64:
	./tests/scan/scan64 --dump-opencl tests/scan/scan64.fut > tests/scan/scan64-kernel.c
load-64:
	./tests/scan/simple --load-opencl tests/scan/scan64-kernel.c < tests/scan/kA-131072.data


compilescanmap:
	$(FUTHARK) opencl tests/scan/scan32map32.fut
dump-scanmap:
	./tests/scan/scan64 --dump-opencl tests/scan/scan32map32.fut > tests/scan/scan32map32-kernel.c
load-scanmap:
	./tests/scan/simple --load-opencl tests/scan/scan32map32-kernel.c < tests/scan/kA-131072.data
