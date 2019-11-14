cckiss/run : cckiss/cckiss.cc
	$(CXX) -std=c++14 -O2 -Wall -Wextra cckiss/cckiss.cc -o cckiss/run

.cckiss.PHONY :
	@echo -n ""

cckiss/make-B-hack:
	touch cckiss/make-B-hack

cckiss/%.c.s : .cckiss.PHONY cckiss/run cckiss/make-B-hack
	cckiss/run $@ $(CC) .cckiss.CPPARGS $(CPPARGS) .cckiss.CXXARGS $(CARGS)

cckiss/%.c.o : .cckiss.PHONY cckiss/run cckiss/make-B-hack
	cckiss/run $@ $(CC) .cckiss.CPPARGS $(CPPARGS) .cckiss.CXXARGS $(CARGS)

cckiss/%.s : .cckiss.PHONY cckiss/run cckiss/make-B-hack
	cckiss/run $@ $(CXX) .cckiss.CPPARGS $(CPPARGS) .cckiss.CXXARGS $(CXXARGS)

cckiss/%.o : .cckiss.PHONY cckiss/run cckiss/make-B-hack
	cckiss/run $@ $(CXX) .cckiss.CPPARGS $(CPPARGS) .cckiss.CXXARGS $(CXXARGS)

cckiss/Makefile:
	@echo -n ""
