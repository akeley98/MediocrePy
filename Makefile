CC = clang -mavx -O2 -S -std=c11 -Wall -Wextra -I include
CC4 = clang -mavx -O3 -S -std=c11 -Wall -Wextra -I include
Cxx = clang -mavx -O2 -S -std=c++11 -Wall -Wextra -I include

LinkLib = clang -lm -shared
LinkTest = clang++

bin/convert_test: bin/testing.s bin/convert.s tests/convert_test.s
	$(LinkTest) bin/testing.s bin/convert.s tests/convert_test.s -o bin/convert_test

bin/testing.s: src/testing.cc
	$(Cxx) src/testing.cc -o bin/testing.s

bin/convert.s: src/convert.c include/convert.h
	$(CC4) src/convert.c -o bin/convert.s

tests/convert_test.s: tests/convert_test.c include/convert.h include/testing.h
	$(CC) tests/convert_test.c -o tests/convert_test.s

