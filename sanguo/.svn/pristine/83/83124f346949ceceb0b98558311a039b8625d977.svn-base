#ifndef _BASE_CURL_H_
#define _BASE_CURL_H_


#include <errno.h>
#include <stdlib.h>
//#include <string.h>
#include <string>
#include <map>
#include "multi.h"

#define MAX 10 /* number of simultaneous transfers */

extern CURLM* g_cm;
extern std::string url;

//TODO:
static size_t _call_back(char *data, size_t size, size_t count, void *stream)
{
  	std::string* pStream = static_cast<std::string *>(stream);
    (*pStream).append((char*)data,size*count); 
  
  	return size*count;
 }
 
class CURL_OBJ
{
public:
  std::string account;
  std::string content; 
  CURL* eh;

  CURL_OBJ(std::string act )
  { 
	    account = act;
		eh = curl_easy_init();
		if( eh != NULL)
		{
			curl_easy_setopt(eh, CURLOPT_WRITEFUNCTION, _call_back);
  			curl_easy_setopt(eh, CURLOPT_WRITEDATA, &content);


			curl_easy_setopt(eh, CURLOPT_HEADER, 0L);
  			curl_easy_setopt(eh, CURLOPT_URL, url.c_str());
  			curl_easy_setopt(eh, CURLOPT_PRIVATE, account.c_str());
  			curl_easy_setopt(eh, CURLOPT_VERBOSE, 0L);
				
			//register
			curl_multi_add_handle(g_cm, eh);
	    }
		else
			std::cout<<"init obj fault!!!!!!!!!"<<std::endl;
  }

  ~CURL_OBJ()
  {
	   std::cout<<"~CURL_OBJ()"<<std::endl;
	   if(eh != NULL)
	   {
	   	   curl_easy_cleanup(eh);
		   eh = NULL;
	   }
	   account.clear();
	   content.clear();
  }
};

extern std::map<std::string, CURL_OBJ* > g_mapobj;

#endif
