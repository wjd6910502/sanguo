AR  = ar
CPP = ccache g++
CC  = ccache g++
#CC = icpc -w -xN 
LD  = g++
#LD  = icpc -w -xN
#RM  = rm

IO_DIR = $(TOP_SRCDIR)/io
CO_DIR = $(TOP_SRCDIR)/new_common
PERF_DIR = $(TOP_SRCDIR)/perf
LOG_DIR = $(TOP_SRCDIR)/logclient

INCLUDES = -I. -I$(TOP_SRCDIR) -I$(IO_DIR) -I$(CO_DIR) -I$(PERF_DIR) -I$(TOP_SRCDIR)/rpc -I$(TOP_SRCDIR)/inl -I$(TOP_SRCDIR)/rpcdata

SHARESRC = $(IO_DIR)/pollio.cpp $(IO_DIR)/protocol.cpp $(IO_DIR)/security.cpp $(IO_DIR)/rpc.cpp $(IO_DIR)/proxyrpc.cpp \
			$(CO_DIR)/thread.cpp $(CO_DIR)/conf.cpp $(CO_DIR)/timer.cpp $(CO_DIR)/itimer.cpp $(CO_DIR)/octets.cpp 

LOGSRC  = $(LOG_DIR)/logclientclient.cpp $(LOG_DIR)/logclienttcpclient.cpp $(LOG_DIR)/log.cpp $(LOG_DIR)/glog.cpp
LOGSTUBSRC = $(LOG_DIR)/stubs.cxx $(LOG_DIR)/state.cxx

SHARE_SOBJ = $(PERF_DIR)/libperf.a

ifeq ($(SINGLE_THREAD),true)
	DEFINES = -Wall -D_GNU_SOURCE -D_FILE_OFFSET_BITS=64#-mcpu=pentium4
	SHAREOBJ := $(SHARESRC:%.cpp=%.o)
	LOGOBJ := $(LOGSRC:%.cpp=%.o) 
	LOGSTUB := $(LOGSTUBSRC:%.cxx=%.o) 
else
	DEFINES = -Wall -D_GNU_SOURCE -pthread -D_REENTRANT_ -D_FILE_OFFSET_BITS=64#-mcpu=pentium4 
	LDFLAGS = -pthread 
	SHAREOBJ := $(SHARESRC:%.cpp=%_m.o)
	LOGOBJ := $(LOGSRC:%.cpp=%_m.o)
	LOGSTUB := $(LOGSTUBSRC:%.cxx=%_m.o) 
endif

ifeq ($(DEBUG_VERSION),true)
	DEFINES += -D_DEBUGINFO -D_DEBUG 
else
	DEFINES += 
endif

