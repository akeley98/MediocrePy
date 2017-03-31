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

bin/mediocre.so: bin/convert.s bin/loaderthread.s bin/mean.s bin/median.s
	$(LinkLib) bin/convert.s bin/loaderthread.s bin/mean.s bin/median.s -o bin/mediocre.so

# I want to throw away the convert.c code away so badly.
bin/convert.s: src/convert.c include/convert.h
	$(CC4) src/convert.c -o bin/convert.s
	
bin/loaderthread.s: src/loaderthread.c include/loaderfunction.h src/inline/loaderthread.h
	$(CC) src/loaderthread.c -o bin/loaderthread.s

bin/mean.s: src/mean.c include/mean.h include/convert.h include/loaderfunction.h src/inline/loaderthread.h src/inline/sigmautil.h
	$(CC4) src/mean.c -o bin/mean.s
	
bin/median.s: src/median.c include/median.h include/convert.h include/loaderfunction.h src/inline/loaderthread.h src/inline/sigmautil.h
	$(CC4) src/median.c -o bin/median.s
	
bin/MediocrePy.s: src/MediocrePy.c include/loaderfunction.h include/mean.h include/median.h src/inline/strideloader.h
	$(CC) src/MediocrePy.c -o bin/MediocrePy.s
	
bin/strideloader.s: src/strideloader.c src/inline/strideloader.h include/loaderfunction.h
	$(CC4) src/strideloader.c -o bin/strideloader.s

bin/testing.s: src/testing.cc
	$(Cxx) src/testing.cc -o bin/testing.s
	
tests/bin/convert_test.s: tests/convert_test.c include/convert.h src/inline/testing.h
	$(CC) tests/convert_test.c -o tests/bin/convert_test.s

tests/bin/convert_test: bin/testing.s bin/convert.s tests/bin/convert_test.s
	$(LinkTest) bin/testing.s bin/convert.s tests/bin/convert_test.s -o tests/bin/convert_test

tests/bin/mean_test.s: tests/mean_test.c include/mean.h src/inline/testing.h
	$(CC) tests/mean_test.c -o tests/bin/mean_test.s
	
tests/bin/median_test.s: tests/median_test.c include/median.h src/inline/testing.h
	$(CC) tests/median_test.c -o tests/bin/median_test.s

tests/bin/mean_test: bin/testing.s bin/convert.s bin/mean.s tests/bin/mean_test.s bin/loaderthread.s
	$(LinkTest) bin/testing.s bin/convert.s bin/mean.s tests/bin/mean_test.s bin/loaderthread.s -o tests/bin/mean_test
	
tests/bin/median_test: bin/testing.s bin/convert.s bin/median.s tests/bin/median_test.s bin/loaderthread.s
	$(LinkTest) bin/testing.s bin/convert.s bin/median.s tests/bin/median_test.s bin/loaderthread.s -o tests/bin/median_test
	
	
