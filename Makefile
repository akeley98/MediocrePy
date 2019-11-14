include cckiss/Makefile

default: bin/mediocre.so

MYFLAGS=-fPIC -mavx -D_POSIX_C_SOURCE=201112L -Wall -Wextra -Werror=int-conversion -Werror=incompatible-pointer-types -Werror=implicit-function-declaration -Wno-missing-field-initializers -g -O3
CXXARGS=$(MYFLAGS) -std=c++14
CARGS=$(MYFLAGS) -std=c99
CPPARGS=-I src/inline -I include

CC=clang
CXX=clang++
LinkLib = clang++ -fPIC -lm -lpthread -shared
LinkTest = clang++ -lpthread

# bin/ is a bit of a misnomer since I'm really compiling to assembly instead of
# object files, so that I can see what the hell the compiler is actually up to.

MEDIOCRE_OBJS=cckiss/src/combine.c.o cckiss/src/median.c.s cckiss/src/mean.c.s cckiss/src/input.cc.o

bin/mediocre.so: $(MEDIOCRE_OBJS)
	$(LinkLib) $(MEDIOCRE_OBJS) -o bin/mediocre.so

INPUT_TEST_OBJS=cckiss/tests/input_test.cc.s cckiss/src/testing.cc.o $(MEDIOCRE_OBJS)
bin/input_test: $(INPUT_TEST_OBJS)
	$(LinkTest) $(INPUT_TEST_OBJS) -o bin/input_test

MEAN_TEST_OBJS=cckiss/tests/mean_test.c.s cckiss/src/testing.cc.o $(MEDIOCRE_OBJS)
bin/mean_test: $(MEAN_TEST_OBJS)
	$(LinkTest) $(MEAN_TEST_OBJS) -o bin/mean_test

MEDIAN_TEST_OBJS=cckiss/tests/median_test.c.s cckiss/src/testing.cc.o $(MEDIOCRE_OBJS)
bin/median_test: $(MEDIAN_TEST_OBJS)
	$(LinkTest) $(MEDIAN_TEST_OBJS) -o bin/median_test

test: bin/mediocre.so
	python3 tests/python_tests.py
