
TOP_SRCDIR = ..

DEBUG_VERSION = true

XO_BUILDER := $$LOGNAME$(shell hostname)
#SVN_VERSION := $(shell svnversion -n)

CC  = ccache g++ -m64 -std=c++0x
LD  = ccache g++ -m64 -std=c++0x

INCLUDES = -I. -I./include -I$(TOP_SRCDIR) -I$(TOP_SRCDIR)/inl -I$(TOP_SRCDIR)/rpcdata -I$(TOP_SRCDIR)/include -I$(TOP_SRCDIR)/common -I$(TOP_SRCDIR)/xinclude $(SELFINCLUDE)

DEFINES = -Wall -D_GNU_SOURCE -D_FILE_OFFSET_BITS=64 -D__OLD_IOLIB_COMPATIBLE__ -D_XO_BUILDER_=$(XO_BUILDER)

#-D_SVN_VERSION_=$(SVN_VERSION)

EXES = STT

DIR_LIB = ./libs
#ifdef LINUX64
LDFLAGS := -L$(DIR_LIB)/x64
#else
#LDFLAGS := -L$(DIR_LIB)/x86
#endif

ifeq ($(DEBUG_VERSION),true)
	DEFINES += -D_DEBUGINFO -D_DEBUG -g -ggdb -O0 $(SELF_DEBUG)
	LDFLAGS += -g -ggdb $(PROFLIB)
else
	DEFINES += -O3 -D_DEBUGINFO -D_DEBUG $(SELF_DEBUG)
	LDFLAGS += $(PROFLIB) 
endif

OBJS = sttserver.o stt.o state.o stubs.o messagemanager.o objectmanager.o

all :$(EXES)

FILE = md5.new

$(EXES) : $(OBJS)
	$(LD) $(LDFLAGS) -o $@ $(OBJS) -L../xlib -lio64 -llog64 -ldl -lpthread -lssl -lrt -lmsc -L.  
	rm -f md5.old
	$(if $(wildcard $(FILE)),mv -f md5.new md5.old)
	md5sum $(EXES) $(OBJS) ../xlib/libio32.so ../xlib/liblog32.so > md5.new
	$(if $(wildcard $(FILE)),diff md5.old md5.new || true)


.cpp.o:
	$(CC) -c $(DEFINES) $(INCLUDES) $(CFLAGS) $< -o $@

%.o : %.cxx
	$(CC) -c $(DEFINES) $(INCLUDES) $(CFLAGS) $< -o $@


.PHONY: clean 
clean:
	rm -rf $(OBJS) $(EXES)



