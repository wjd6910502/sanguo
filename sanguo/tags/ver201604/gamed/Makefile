TOP_SRCDIR = ..

DEBUG_VERSION =	true

#XO_BUILDER  := $$LOGNAME@$(shell hostname)
#SVN_VERSION := $(shell svnversion -n)

CC  = ccache g++ -m64 -std=c++0x
LD  = ccache g++ -m64 -std=c++0x

INCLUDES = -I. -I$(TOP_SRCDIR) -I$(TOP_SRCDIR)/inl -I$(TOP_SRCDIR)/rpcdata -I$(TOP_SRCDIR)/common -I$(TOP_SRCDIR)/xinclude -I$(TOP_SRCDIR)/lua/include -I./DataPool -I./DataPool/include -I./Rsa 

#DEFINES = -Wall -D_GNU_SOURCE -D_FILE_OFFSET_BITS=64 -D__OLD_IOLIB_COMPATIBLE__ -D_XO_BUILDER_=$(XO_BUILDER) -D_SVN_VERSION_=$(SVN_VERSION)
DEFINES = -Wall -D_GNU_SOURCE -D_FILE_OFFSET_BITS=64 -D__OLD_IOLIB_COMPATIBLE__ -D_DEBUG -D_LINUX -D_X64 -DGXDLL_API_INDEPENDENT -fpermissive
#DEFINES = -Wall -D_GNU_SOURCE -D_FILE_OFFSET_BITS=64 -D__OLD_IOLIB_COMPATIBLE__ -D_DEBUG -D_LINUX -D_X64 -DGXDLL_API_INDEPENDENT -fpermissive -DENABLE_SECURITY
#DEFINES = -Wall -D_GNU_SOURCE -D_FILE_OFFSET_BITS=64 -D__OLD_IOLIB_COMPATIBLE__ -D_DEBUG -D_LINUX -D_X64 -DGXDLL_API_INDEPENDENT -fpermissive -DENABLE_SECURITY -DENABLE_RSA

EXES = gamed

ifeq ($(DEBUG_VERSION),true)
	DEFINES += -D_DEBUGINFO -D_DEBUG -g -ggdb -O0 $(SELF_DEBUG)
	LDFLAGS += -g -ggdb $(PROFLIB) -L$(TOP_SRCDIR)/lua/lib
else
	DEFINES += -O3 -D_DEBUGINFO -D_DEBUG $(SELF_DEBUG)
	LDFLAGS += $(PROFLIB) -L$(TOP_SRCDIR)/lua/lib
endif


OBJS = gateserver.o transserver.o udptransserver.o gamed.o state.o stubs.o playermanager.o script_wrapper.o structsbind.o gamedbclient.o luaenv.o mafiamanager.o message.o topmanager.o gcenterclient.o packagemanager.o noticemanager.o pvpmanager.o dbsavemanager.o pvpgameserver.o stungameclient.o stundeafserver.o uniquenameclient.o miscmanager.o

all : structsbind.cpp $(EXES)

$(EXES) : $(OBJS)  
	$(LD) $(LDFLAGS) -o $@ $(OBJS) -L../xlib -lio64 -llog64 -ldl -lpthread -lssl -llua64 -ltolua++64 -L. -ldatapool -lRsa
	#$(LD) $(LDFLAGS) -o $@ $(OBJS) -L../xlib -lio64 -llog64 -ldl -lpthread -lssl -lluajit -ltolua++64 -L. -ldatapool -lRsa

.cpp.o:
	$(CC) -c $(DEFINES) $(INCLUDES) $(CFLAGS) $< -o $@

%.o : %.cxx
	$(CC) -c $(DEFINES) $(INCLUDES) $(CFLAGS) $< -o $@

structsbind.cpp: structs.pkg
	../tools/tolua++ -o $@ $<
	../tools/post_tolua $@ >$@.tmp
	mv $@.tmp $@

structs.pkg: structs.xml forlua.pkg
	./structgen

.PHONY: clean
clean:
	rm -rf $(OBJS) $(EXES) structsbind.cpp structs.pkg structs.h

