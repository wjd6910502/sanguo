#ifndef __MATCHER_H
#define __MATCHER_H
#include <iconv.h>
#include <string>
#include <iostream>
#include <fstream>
#include <sstream>

#if __GNUC__ <4
	#include <pcre/pcre.h>
#else
	#include <pcre.h>
#endif

#include "thread.h"

namespace GNET
{
#define CDINVALID ((iconv_t)-1)
	using std::string;
	class Matcher
	{
		static Matcher instance;
		iconv_t cinput;
		iconv_t cvalid;
		char errormsg[128];

		string pattern;
		pcre *regexp;

		void close()
		{
			if(cinput!=CDINVALID)
				iconv_close(cinput);
			if(cvalid!=CDINVALID)
				iconv_close(cvalid);
			if(regexp)
				pcre_free(regexp);
			cinput = CDINVALID;
			cvalid = CDINVALID;
			regexp = NULL;
		}

	public:
		Matcher() : cinput(CDINVALID), cvalid(CDINVALID), regexp(NULL)
		{
			errormsg[0] = 0;
		}
		~Matcher()
		{
			close();
		}
		static Matcher *GetInstance()
		{
			return &instance; 
		}
		const char* GetError() { return errormsg; }
		int Load(const char* file,const char* in_code="UCS2",const char* check_code="GB2312",const char* table_code="GBK");
		int Match(char* str, int len)
		{	
			char buf[256];
			char *in, *out;
			size_t ilen, olen;

			if(!regexp)
				return 0;
			if(cvalid!=CDINVALID)
			{
				// 检查输入串能否正确转化为check_code
				//cvalid = iconv_open("utf-8","GBK");
				in = str;
				out = buf;
				ilen = len;
				olen = 256;
				//if(iconv(cvalid,&in,&ilen,&out,&olen)==(size_t)(-1))
				//	return -2;
			}
			in = str;
			out = buf;
			ilen = len;
			olen = 256;
			// 将输入字符串转为utf8编码
			//iconv(cinput,&in,&ilen,&out,&olen);
			//return pcre_exec( regexp, NULL, buf, 256-olen, 0, 0, NULL, 0) >= 0 ? -1 : 0; 
		

			//测试怎么匹配上去的
			int ovector[30];
			int rc = pcre_exec( regexp, NULL, str, len, 0, 0, ovector, 30);
			if (rc < 0)
			{
				return -1;
			}
			return 0;


			//for(int i = 0; i < rc; i++)
			//{
			//	char* substring_start = str + ovector[2*i];
			//	int substring_length = ovector[2*i+1] - ovector[2*i];
			//	fprintf(stderr,"HAS MATCH.............%2d:%.*s\n",i,substring_length,substring_start);	
			//}
			// fprintf(stderr,"HAS MATCH.............overtor = %s",ovector);
					
		}
		
	};

};
#endif
