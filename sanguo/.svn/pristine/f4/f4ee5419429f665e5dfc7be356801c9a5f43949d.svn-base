CXX=g++ -m64
CXXFLAGS=-g -Wall -std=c++0x
INCLUDES=
LD=g++ -m64
LDFLAGS=-std=c++0x
DASM=objdump
DASMFLAGS=-dS
OBJS=
LIBS=-lpthread

all: udp_signature

udp_signature: main.o ${OBJS}
	${LD} ${LDFLAGS} -o $@ $< ${OBJS} ${LIBS}
	${DASM} ${DASMFLAGS} $@ >udp_signature.s

main.o: main.cpp
	${CXX} ${CXXFLAGS} ${INCLUDES} -c $<

clean:
	rm -f *.o udp_signature udp_signature.s
