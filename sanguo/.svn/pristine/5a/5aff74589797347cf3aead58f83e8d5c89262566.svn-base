
#include "http_get_request.h"

namespace GNET {

void _GetQuery(const QUERY_MAP& map, const char *name, int& value)
{
	QUERY_MAP::const_iterator it = map.find(name);
	if (it != map.end()) value = atoi(it->second.c_str());
}

void _GetQuery(const QUERY_MAP& map, const char *name, int64_t& value)
{
	QUERY_MAP::const_iterator it = map.find(name);
	if (it != map.end()) value = atoll(it->second.c_str());
}

void _GetQuery(const QUERY_MAP& map, const char *name, std::string& value)
{
	QUERY_MAP::const_iterator it = map.find(name);
	if (it != map.end()) value = it->second;
}

void _AddResult(std::string& json_body, const char *name, const int& value)
{
	if (json_body != "{") json_body += ",";
	json_body += "\"";
	json_body += name;
	json_body += "\":\"";
	char buf[128];
	snprintf(buf, sizeof(buf), "%d\"", value);
	json_body += buf;
}

void _AddResult(std::string& json_body, const char *name, const int64_t& value)
{
	if (json_body != "{") json_body += ",";
	json_body += "\"";
	json_body += name;
	json_body += "\":\"";
	char buf[128];
	snprintf(buf, sizeof(buf), "%ld\"", value);
	json_body += buf;
}

void _AddResult(std::string& json_body, const char *name, const std::string& value)
{
	if (json_body != "{") json_body += ",";
	json_body += "\"";
	json_body += name;
	json_body += "\":\"";
	json_body += value;
	json_body += "\"";
}

void _AddResultNOComma(std::string& json_body, const char *name, const int& value)
{
	json_body += "\"";
	json_body += name;
	json_body += "\":\"";
	char buf[128];
	snprintf(buf, sizeof(buf), "%d\"", value);
	json_body += buf;
}

void _AddResultNOComma(std::string& json_body, const char *name, const int64_t& value)
{
	json_body += "\"";
	json_body += name;
	json_body += "\":\"";
	char buf[128];
	snprintf(buf, sizeof(buf), "%ld\"", value);
	json_body += buf;
}

void _AddResultNOComma(std::string& json_body, const char *name, const std::string& value)
{
	json_body += "\"";
	json_body += name;
	json_body += "\":\"";
	json_body += value;
	json_body += "\"";
}

void _HttpOutPut(std::string json_body)
{
	std::cout<<"Content-type:text/html\r\n\r\n";
	std::cout<<"<html>\n";
	std::cout<<"<head>\n";
	//std::cout<<"<title>tetstst</title>\n";
	std::cout<<"</head>\n";
	std::cout<<"<body>\n";	
	std::cout<<json_body;
	std::cout<<"</body>\n";
	std::cout<<"</html>\n";

}

void _ParseString(const char* src, std::map<std::string,std::string>& _query_map)
{  
	if(src == NULL)
		return;
		
	const char *p = src;
	while (p)
	{	
		if(*p == '&')
			p++;
		const char *q = strchr(p, '=');
		if (!q) return; //Err
		const char *r = strchr(p, '&');
		if (r && r<q) return; //Err
		std::string n(p, q-p);
		q++;
		std::string v(q, r ? (r-q) : strlen(q));
		_query_map[HttpProtocol::UrlDecode(n)] = HttpProtocol::UrlDecode(v);
		p = r;
	}        	
}

};

