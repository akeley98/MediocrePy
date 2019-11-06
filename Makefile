MYFLAGS = -mavx -D_POSIX_C_SOURCE=201112L -Wall -Wextra -Werror=int-conversion -Werror=incompatible-pointer-types -Werror=implicit-function-declaration -Wno-missing-field-initializers -Wno-implicit-fallthrough -g

# Change these commands if you want to change the C and C++ compilers.
CC = clang $(MYFLAGS) -g -pg -fPIC -O2 -c -std=gnu99 -I include -I src/inline
CC4 = clang $(MYFLAGS) -g -pg -fPIC -O3 -c -std=gnu99 -I include -I src/inline
Cxx = g++ $(MYFLAGS) -g -pg -fPIC -O2 -c -std=gnu++11 -I include -I src/inline
LinkLib = g++ -g -pg -fPIC -lm -pthread -lpthread -shared
LinkTest = g++ -g -pg -pthread -lpthread

# bin/ is a bit of a misnomer since I'm really compiling to assembly instead of
# object files, so that I can see what the hell the compiler is actually up to.

bin/mediocre.so: bin/combine.o bin/input.o bin/mean.o bin/median.o
	$(LinkLib) bin/combine.o bin/input.o bin/mean.o bin/median.o -o bin/mediocre.so



bin/combine.o: src/combine.c include/mediocre.h src/inline/combinedebug.h
	$(CC) src/combine.c -o bin/combine.o

# bin/input.o takes up like 90% of the compile time and 90% of the space in the # final .so file, but I NEED the delicious C++ templates!
bin/input.o: src/input.cc include/mediocre.h
	$(Cxx) src/input.cc -o bin/input.o

bin/mean.o: src/mean.c include/mediocre.h src/inline/sigmautil.h
	$(CC4) src/mean.c -o bin/mean.o

bin/median.o: src/median.c include/mediocre.h src/inline/sigmautil.h
	$(CC4) src/median.c -o bin/median.o



bin/testing.o: src/testing.cc
	$(Cxx) src/testing.cc -o bin/testing.o

bin/input_test.o: tests/input_test.cc include/mediocre.h include/mediocre.hpp src/inline/testing.h
	$(Cxx) tests/input_test.cc -o bin/input_test.o

bin/mean_test.o: tests/mean_test.c include/mediocre.h src/inline/testing.h
	$(Cxx) tests/mean_test.c -o bin/mean_test.o

bin/median_test.o: tests/median_test.c include/mediocre.h src/inline/testing.h
	$(CC) tests/median_test.c -o bin/median_test.o

bin/input_test: bin/input_test.o bin/combine.o bin/input.o bin/mean.o bin/testing.o
	$(LinkTest) bin/input_test.o bin/combine.o bin/input.o bin/mean.o bin/testing.o -o bin/input_test

bin/mean_test: bin/mean_test.o bin/combine.o bin/mean.o bin/testing.o
	$(LinkTest) bin/mean_test.o bin/combine.o bin/mean.o bin/testing.o -o bin/mean_test

bin/median_test: bin/median_test.o bin/combine.o bin/median.o bin/testing.o
	$(LinkTest) bin/median_test.o bin/combine.o bin/median.o bin/testing.o -o bin/median_test


