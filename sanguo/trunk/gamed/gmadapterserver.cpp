#include <iconv.h>

#include "gmadapterserver.hpp"
#include "state.hxx"
#include "glog.h"

namespace GNET
{

GMAdapterServer GMAdapterServer::instance;

const Protocol::Manager::Session::State* GMAdapterServer::GetInitState() const
{
	return &state_GMAdapterServer;
}

void GMAdapterServer::OnAddSession(Session::ID sid)
{
}

void GMAdapterServer::OnDelSession(Session::ID sid)
{
}

void GMAdapterServer::ConvertToUtf8(std::string &str)
{

	int i = 0;
	int size = str.size();
	for(; i < size; )
	{
		char chr = str[i];
		if((chr & 0x80)==0)
		{
			++i;
		}
		else if((chr & 0xF8)==0xF8)
		{
			i+=5;
		}
		else if((chr & 0xF0)==0xF0)
		{
			i+=4;
		}
		else if((chr & 0xE0)==0xE0)
		{
			i+=3;
		}
		else if((chr & 0xC0)==0xC0)
		{
			i+=2;
		}
		else
			break;
	}
	if(i == size)
	{
		return;
	}

	char buf[1024];
	char *in, *out;
	size_t ilen, olen;
	iconv_t cvalid;
	cvalid = iconv_open("utf-8","gbk");
	if(cvalid==(iconv_t)(-1))
	{
		GLog::log(LOG_INFO, "wrong in iconv_open");
		return;
	}
	in = const_cast<char*>(str.c_str());
	out = buf;
	ilen = str.size();
	olen = 1024;

	//½«×Ö·û´®×ªÎªutf8±àÂë
	if(iconv(cvalid,&in,&ilen,&out,&olen)==(size_t)(-1))
	{
		return;
	}
	buf[1024-olen] = 0;

	str = buf;

	iconv_close(cvalid);
}
};
