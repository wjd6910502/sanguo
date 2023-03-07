TOP_SRCDIR = ../..

CC  = ccache g++ -m64 -std=c++0x
LD  = ccache g++ -m64 -std=c++0x


INCLUDES = -I. -I$(TOP_SRCDIR) -I$(TOP_SRCDIR)/inl -I$(TOP_SRCDIR)/rpcdata -I$(TOP_SRCDIR)/common -I$(TOP_SRCDIR)/xinclude $(SELFINCLUDE) -I$(TOP_SRCDIR)/lua/include  

DEFINES = -Wall -D_GNU_SOURCE -D_FILE_OFFSET_BITS=64 -D__OLD_IOLIB_COMPATIBLE__ -D_DEBUG -D_LINUX -D_X64 -DGXDLL_API_INDEPENDENT

OBJS = bignum.o rsa16.o

all:  test libRsa.so

test: ${OBJS} main.o
	$(LD) $(LDFLAGS) -o $@ $(OBJS) main.o  -L../../xlib -lio64 -llog64 -ldl -lssl 

libRsa.so : ${OBJS}
	$(CC) -fPIC --shared -o $@ ./bignum.c ./rsa16.c -L../../xlib -lio64 -llog64 -ldl  

.cpp.o:
	$(CC) -c $(DEFINES) $(INCLUDES) $(CFLAGS) $< -o $@

clean:
	rm -f *.o exe



