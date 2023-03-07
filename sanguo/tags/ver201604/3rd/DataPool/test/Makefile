CC = g++ -m64 -std=c++0x -g -ggdb
LD = g++ -m64 -std=c++0x -g -ggdb
CFLAGS = -D_DEBUG -D_LINUX -D_X64 -DGXDLL_API_INDEPENDENT -fpermissive

#CC = g++ -m32 -std=c++0x -g -ggdb
#LD = g++ -m32 -std=c++0x -g -ggdb
#CFLAGS = -D_DEBUG -D_LINUX -D_X86 -DGXDLL_API_INDEPENDENT -fpermissive

INCLUDES = -I.. -I../include

OBJS = 

all: exe

exe: ${OBJS} main.o
	$(LD) $(LDFLAGS) -o $@ $(OBJS) main.o -L.. -ldatapool -lpthread

.cpp.o:
	$(CC) -c $(DEFINES) $(INCLUDES) $(CFLAGS) $< -o $@

clean:
	rm -f *.o exe

