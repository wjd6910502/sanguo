
TOP_SRCDIR = ..

SINGLE_THREAD = false
DEBUG_VERSION = true

XO_BUILDER := $$LOGNAME@$(shell hostname)
SVN_VERSION := $(shell svnversion -n)

include ../mk/gcc.defs.mk

INCLUDES += -I$(TOP_SRCDIR)/storage -I$(TOP_SRCDIR)/include -I./tinyxml
CFLAGS += -g -ggdb -m32 #-O0 -O2
LDFLAGS += -m32
DEFINES += -DUSE_DB -DUSE_WDB -DUSE_LOGCLIENT -DMPPC_4WAY -DUSE_TRANSACTION -D_FILE_OFFSET_BITS=64 -D_XO_BUILDER_=$(XO_BUILDER) -D_SVN_VERSION_=$(SVN_VERSION) -DTIXML_USE_STL
ifeq ($(MAKECMDGOALS),release)
	DEFINES += -D_RELEASE_VERSION_
endif

OBJS = ../storage/storage.o ../storage/storagetool.o gactivecode.o gaccodeserver.o active_code_manager.o dbmgrdef.o state.o stubs.o
LISTOBJ = ../storage/storage.o 
.PHONY: release 

all : gactivecode

FILE = md5.new

SHARE_SOBJ = $(PERF_DIR)/i386/libperf.a

gactivecode : $(OBJS) $(SHAREOBJ) $(SHARE_SOBJ) $(LOGOBJ) $(LOGSTUB) 
	$(LD) $(LDFLAGS) -o $@ $(OBJS) $(SHAREOBJ) $(SHARE_SOBJ) $(LOGOBJ) $(LOGSTUB) -lcrypto -ldl
	rm -f md5.old
	$(if $(wildcard $(FILE)),mv -f md5.new md5.old)
	md5sum gactivecode $(OBJS) $(SHAREOBJ) $(SHARE_SOBJ) $(LOGOBJ) $(LOGSTUB)  > md5.new
	$(if $(wildcard $(FILE)),diff md5.old md5.new || true)

release : $(OBJS) $(SHAREOBJ) $(SHARE_SOBJ) $(LOGOBJ) $(LOGSTUB) 
	$(LD) $(LDFLAGS) -o gamedbd $(OBJS) $(SHAREOBJ) $(SHARE_SOBJ) $(LOGOBJ) $(LOGSTUB) -lcrypto -ldl

cashstat: $(SHAREOBJ) $(SHARE_SOBJ) ../storage/storage.o statistic.cpp
	$(LD) $(LDFLAGS) -D_REENTRANT_ -O2 -o $@ statistic.cpp $(SHAREOBJ) $(SHARE_SOBJ) ../storage/storage.o -I$(INCLUDES) -DUSE_WDB

include ../mk/gcc.rules.mk


