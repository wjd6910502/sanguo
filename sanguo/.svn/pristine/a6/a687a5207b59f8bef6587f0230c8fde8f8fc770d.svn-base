
#include "statusserver.hpp"
#include "state.hxx"
#include "serverstatus.hpp"
#include "glog.h"

#include <fstream>
#include <string>
#include <sstream>
#include <iconv.h> 

namespace GNET
{

StatusServer StatusServer::instance;

int code_convert(char *inbuf, size_t inlen, char *outbuf, size_t outlen)  
{
	iconv_t cd;
	char** pin = &inbuf;
	char** pout = &outbuf;

	cd = iconv_open("utf-8", "gbk");
	if(cd == 0)	return -1;
	iconv(cd, pin, &inlen, pout, &outlen);
	iconv_close(cd);
	*pout = '\0';
	
	return 0; 
}

unsigned char text_utf8[] = {
  0xe6, 0xb8, 0xb8, 0xe6, 0x88, 0x8f, 0xe6, 0x9c, 0x8d, 0xe5, 0x8a, 0xa1,
  0xe5, 0x99, 0xa8, 0xe6, 0xad, 0xa3, 0xe5, 0x9c, 0xa8, 0xe7, 0xbb, 0xb4,
  0xe6, 0x8a, 0xa4, 0xe4, 0xb8, 0xad, 0xef, 0xbc, 0x8c, 0xe8, 0xaf, 0xb7,
  0xe7, 0xa8, 0x8d, 0xe5, 0x90, 0x8e, 0xe5, 0x86, 0x8d, 0xe6, 0x9d, 0xa5,
  0xe3, 0x80, 0x82, 0x0a
};

unsigned int text_utf8_len = 52; 

char dest[1024];

const Protocol::Manager::Session::State* StatusServer::GetInitState() const
{
	return &state_StatusServer;
}

void StatusServer::OnAddSession(Session::ID sid)
{
	GLog::log(LOG_INFO, "StatusServer::OnAddSession, sid=%u", sid);
	
	ServerStatus prot;
	prot.info = Octets(dest, strlen(dest)+1);
	Send(sid, prot);
}

void StatusServer::OnDelSession(Session::ID sid)
{
	GLog::log(LOG_INFO, "StatusServer::OnDelSession, sid=%u", sid);
}

void StatusServer::SetPrompt()
{
	std::ifstream in("text.gbk");
	std::stringstream buffer;
	buffer << in.rdbuf();
	std::string text(buffer.str());
//	std::cout << text << std::endl;

	memset(dest, 0, sizeof(dest));
	code_convert((char*)text.c_str(), text.length(), dest, 1024);//conv_charset.h 用这个里面的试下 加log
}

};
