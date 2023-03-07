
#ifndef _HTTP_GET_REQUEST_H_
#define _HTTP_GET_REQUEST_H_

#include <string>
#include <map>
#include <cstdlib>
#include "httpprotocol.h"

#define GetQuery(query) \
do { \
	_GetQuery(_query_map, #query, query); \
} while(0)

#define AddResult(result) \
do { \
	_AddResult(json_body, #result, result); \
} while(0)

#define AddResultNOComma(result) \
do { \
	_AddResultNOComma(json_body, #result, result); \
} while(0)

namespace GNET {

typedef std::map<std::string, std::string> QUERY_MAP;

void _GetQuery(const QUERY_MAP& map, const char *name, int& value);
void _GetQuery(const QUERY_MAP& map, const char *name, int64_t& value);
void _GetQuery(const QUERY_MAP& map, const char *name, std::string& value);

void _AddResult(std::string& json_body, const char *name, const int& value);
void _AddResult(std::string& json_body, const char *name, const int64_t& value);
void _AddResult(std::string& json_body, const char *name, const std::string& value);

void _AddResultNOComma(std::string& json_body, const char *name, const int& value);
void _AddResultNOComma(std::string& json_body, const char *name, const int64_t& value);
void _AddResultNOComma(std::string& json_body, const char *name, const std::string& value);

void _HttpOutPut(std::string json_body);
void _ParseString(const char* src, std::map<std::string,std::string>& _query_map);
};

#endif //_HTTP_GET_REQUEST_H_

