MYFLAGS = -mavx2 -mfma -D_POSIX_C_SOURCE=201112L -Wall -Wextra -Werror=int-conversion -Werror=incompatible-pointer-types -Werror=implicit-function-declaration -Wno-missing-field-initializers -g

# Change these commands if you want to change the C and C++ compilers.
CC = clang $(MYFLAGS) -fPIC -O2 -S -std=c99 -I include -I src/inline
CC4 = clang $(MYFLAGS) -fPIC -O3 -S -std=c99 -I include -I src/inline
Cxx = clang++ $(MYFLAGS) -fPIC -O2 -S -std=c++11 -I include -I src/inline
LinkLib = clang++ -fPIC -lm -lpthread -shared
LinkTest = clang++ -lpthread
EXOCC = exocc

# bin/ is a bit of a misnomer since I'm really compiling to assembly instead of
# object files, so that I can see what the hell the compiler is actually up to.

bin/mediocre.so: bin/combine.s bin/input.s bin/mean.s bin/median.s bin/exo_file.s
	$(LinkLib) bin/combine.s bin/input.s bin/mean.s bin/median.s -o bin/mediocre.so



bin/combine.s: src/combine.c include/mediocre.h src/inline/combinedebug.h
	$(CC) src/combine.c -o bin/combine.s

# bin/input.s takes up like 90% of the compile time and 90% of the space in the # final .so file, but I NEED the delicious C++ templates!
bin/input.s: src/input.cc include/mediocre.h
	$(Cxx) src/input.cc -o bin/input.s

bin/mean.s: src/mean.c include/mediocre.h src/inline/sigmautil.h exo_file/exo_file.h src/inline/maybe_fma.h
	$(CC4) src/mean.c -o bin/mean.s

bin/median.s: src/median.c include/mediocre.h src/inline/sigmautil.h exo_file/exo_file.h
	$(CC4) src/median.c -o bin/median.s

bin/testing.s: src/testing.cc
	$(Cxx) src/testing.cc -o bin/testing.s

bin/input_test.s: tests/input_test.cc include/mediocre.h include/mediocre.hpp src/inline/testing.h
	$(Cxx) tests/input_test.cc -o bin/input_test.s

bin/mean_test.s: tests/mean_test.c include/mediocre.h src/inline/testing.h src/inline/maybe_fma.h
	$(CC) tests/mean_test.c -o bin/mean_test.s

bin/median_test.s: tests/median_test.c include/mediocre.h src/inline/testing.h
	$(CC) tests/median_test.c -o bin/median_test.s


exo_file/exo_file.h: src/gen.py
	$(EXOCC) -o exo_file --stem exo_file src/gen.py

bin/exo_file.s: exo_file/exo_file.h
	$(CC4) exo_file/exo_file.c -o bin/exo_file.s


bin/input_test: bin/input_test.s bin/combine.s bin/input.s bin/mean.s bin/testing.s bin/exo_file.s
	$(LinkTest) bin/input_test.s bin/combine.s bin/input.s bin/mean.s bin/testing.s bin/exo_file.s -o bin/input_test

bin/mean_test: bin/mean_test.s bin/combine.s bin/mean.s bin/testing.s bin/exo_file.s
	$(LinkTest) bin/mean_test.s bin/combine.s bin/mean.s bin/testing.s bin/exo_file.s -o bin/mean_test

bin/median_test: bin/median_test.s bin/combine.s bin/median.s bin/testing.s bin/exo_file.s
	$(LinkTest) bin/median_test.s bin/combine.s bin/median.s bin/testing.s bin/exo_file.s -o bin/median_test
