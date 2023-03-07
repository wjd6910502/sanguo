#include "callid.hxx"

#ifdef WIN32
#include <winsock2.h>
#include "gnproto.h"
#include "gncompress.h"
#else
#include "protocol.h"
//#include "binder.h"
#endif

namespace GNET
{

static GNET::Protocol::Type _state_LaohuInformClient[] = 
{
	PROTOCOL_LAOHU_PAY_RE,
};

GNET::Protocol::Manager::Session::State state_LaohuInformClient(_state_LaohuInformClient,
						sizeof(_state_LaohuInformClient)/sizeof(GNET::Protocol::Type), 86400);

static GNET::Protocol::Type _state_Null[] = 
{
};

GNET::Protocol::Manager::Session::State state_Null(_state_Null,
						sizeof(_state_Null)/sizeof(GNET::Protocol::Type), 5);


};

