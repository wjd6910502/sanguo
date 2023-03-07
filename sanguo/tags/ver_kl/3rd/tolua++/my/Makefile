# makefile for tolua executable

TOLUAEXE = bin/tolua++

LIBS = -ltolua++64 -llua64 -lm -ldl

EXE = test

all: $(EXE)

test:  main.o test.o testbind.o
	g++ -o $@ main.o test.o testbind.o -Llib $(LIBS)

.cpp.o:
	g++ -c -Iinclude -o $@ $<

testbind.cpp: test.pkg
	$(TOLUAEXE) -o $@ $<
	./bin/tolua++ -o $@ $<

clean:
	rm -f test
	rm -f *.o 
	rm -f testbind.*

