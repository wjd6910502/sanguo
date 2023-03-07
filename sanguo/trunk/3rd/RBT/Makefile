CXX=g++ -m64
CXXFLAGS=-g -Wall -ansi -std=c++0x -O3
#CXXFLAGS=-g -Wall -ansi -std=c++0x
INCLUDES=-Iinclude
LD=g++ -m64
LDFLAGS=-O3
#LDFLAGS=
DASM=objdump
DASMFLAGS=-dS
OBJS=rbt.o
LIBS=-Llib -llua64 -ldl

all: test

test: main.o ${OBJS}
	${LD} ${LDFLAGS} -o $@ $< ${OBJS} ${LIBS}
	${DASM} ${DASMFLAGS} $@ >test.s

main.o: main.cpp rbt.h
	${CXX} ${CXXFLAGS} ${INCLUDES} -c $<

rbt.o: rbt.cpp rbt.h
	${CXX} ${CXXFLAGS} ${INCLUDES} -c $<

clean:
	rm -f *.o test test.s
