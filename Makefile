CC = clang -mavx -O2 -S -std=c11 -Wall -Wextra -I include
CC4 = clang -mavx -O3 -S -std=c11 -Wall -Wextra -I include
Cxx = clang -mavx -O2 -S -std=c++11 -Wall -Wextra -I include

LinkLib = clang -g -lm -shared
LinkTest = clang++ -g

# bin/ is a bit of a misnomer since I'm really compiling to assembly instead of
# object files, so that I can see what the hell the compiler is actually up to.

bin/convert.s: src/convert.c include/convert.h
	$(CC4) src/convert.c -o bin/convert.s

bin/mean.s: src/mean.c include/mean.h include/convert.h
	$(CC4) src/mean.c -o bin/mean.s

bin/testing.s: src/testing.cc
	$(Cxx) src/testing.cc -o bin/testing.s

tests/bin/convert_test.s: tests/convert_test.c include/convert.h include/testing.h
	$(CC) tests/convert_test.c -o tests/bin/convert_test.s

tests/bin/convert_test: bin/testing.s bin/convert.s tests/bin/convert_test.s
	$(LinkTest) bin/testing.s bin/convert.s tests/bin/convert_test.s -o tests/bin/convert_test

tests/bin/mean_test.s: tests/mean_test.c include/mean.h include/testing.h
	$(CC) tests/mean_test.c -o tests/bin/mean_test.s

tests/bin/mean_test: bin/testing.s bin/convert.s bin/mean.s tests/bin/mean_test.s
	$(LinkTest) bin/testing.s bin/convert.s bin/mean.s tests/bin/mean_test.s -o tests/bin/mean_test
	
