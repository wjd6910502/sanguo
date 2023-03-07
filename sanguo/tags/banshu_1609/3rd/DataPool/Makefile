CC = g++ -m64 -std=c++0x -g -ggdb -fPIC
LD = g++ -m64 -std=c++0x -g -ggdb
CFLAGS = -D_DEBUG -D_LINUX -D_X64 -DGXDLL_API_INDEPENDENT -fpermissive

#CC = g++ -m32 -std=c++0x -g -ggdb
#LD = g++ -m32 -std=c++0x -g -ggdb
#CFLAGS = -D_DEBUG -D_LINUX -D_X86 -DGXDLL_API_INDEPENDENT -fpermissive

INCLUDES = -I. -I./include

OBJS = casemap.o clPathFile.o DataPoolBuildTime.o DataPool.o DataPoolIterator.o ecvt.o SmartStock.o clAllocator.o clString.o DataPoolCompiler.o DataPoolImpl.o DataPoolVariable.o GameDataPool.o smartstream.o clBuffer.o clFile.o clstd.o ASysThread.o AAssist.o AMemory.o AString.o AWString.o ALog.o AFile.o

all: exe libdatapool.so

exe: ${OBJS} main.o
	$(LD) $(LDFLAGS) -o $@ $(OBJS) main.o ./o/list.o -lpthread

libdatapool.so : ${OBJS}
	$(CC) -fPIC --shared -o $@ $(OBJS) ./o/list.o

.cpp.o:
	$(CC) -c $(DEFINES) $(INCLUDES) $(CFLAGS) $< -o $@

clean:
	rm -f *.o exe

