MYFLAGS = -g -mavx -D_POSIX_C_SOURCE=201112L -Wall -Wextra -Werror=int-conversion -Werror=incompatible-pointer-types -Werror=implicit-function-declaration -Wno-missing-field-initializers

CC = clang $(MYFLAGS) -fPIC -O2 -S -std=c11 -I include -I src/inline
CC4 = clang $(MYFLAGS) -fPIC -O3 -S -std=c11 -I include -I src/inline
Cxx = clang $(MYFLAGS) -fPIC -O2 -S -std=c++11 -I include -I src/inline

LinkLib = clang -fPIC -lm -lpthread -shared
LinkTest = clang++ -lpthread

# bin/ is a bit of a misnomer since I'm really compiling to assembly instead of
# object files, so that I can see what the hell the compiler is actually up to.

bin/MediocrePy.so: bin/MediocrePy.s bin/convert.s bin/loaderthread.s bin/mean.s bin/median.s bin/strideloader.s
	$(LinkLib) bin/MediocrePy.s bin/convert.s bin/loaderthread.s bin/mean.s bin/median.s bin/strideloader.s -o bin/MediocrePy.so

bin/mediocre.so: bin/combine.s bin/mean.s bin/median.s
	$(LinkLib) bin/combine.s bin/mean.s bin/median.s -o bin/mediocre.so
	
bin/combine.s: src/combine.c include/mediocre.h
	$(CC) src/combine.c -o bin/combine.s

bin/mean.s: src/mean.c include/mediocre.h src/inline/sigmautil.h
	$(CC4) src/mean.c -o bin/mean.s
	
bin/median.s: src/median.c include/mediocre.h src/inline/sigmautil.h
	$(CC4) src/median.c -o bin/median.s
	
bin/MediocrePy.s: src/MediocrePy.c include/loaderfunction.h include/mean.h include/median.h src/inline/strideloader.h
	$(CC) src/MediocrePy.c -o bin/MediocrePy.s
	
bin/strideloader.s: src/strideloader.c src/inline/strideloader.h include/loaderfunction.h
	$(CC4) src/strideloader.c -o bin/strideloader.s

bin/testing.s: src/testing.cc
	$(Cxx) src/testing.cc -o bin/testing.s

tests/bin/mean_test.s: tests/mean_test.c include/mediocre.h src/inline/testing.h
	$(CC) tests/mean_test.c -o tests/bin/mean_test.s
	
tests/bin/median_test.s: tests/median_test.c include/mediocre.h src/inline/testing.h
	$(CC) tests/median_test.c -o tests/bin/median_test.s

tests/bin/mean_test: tests/bin/mean_test.s bin/combine.s bin/mean.s bin/testing.s
	$(LinkTest) tests/bin/mean_test.s bin/combine.s bin/mean.s bin/testing.s -o tests/bin/mean_test
	
tests/bin/median_test: tests/bin/median_test.s bin/combine.s bin/median.s bin/testing.s
	$(LinkTest) tests/bin/median_test.s bin/combine.s bin/median.s bin/testing.s -o tests/bin/median_test
	
	
