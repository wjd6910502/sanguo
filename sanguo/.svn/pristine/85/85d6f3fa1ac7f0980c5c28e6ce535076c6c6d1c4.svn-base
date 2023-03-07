#include "matcher.h"
namespace GNET
{

Matcher Matcher::instance;
int Matcher::Load(const char* file,const char* in_code,const char* check_code,const char* table_code)
{
	char *in,*out,*buf,*input;
	const char *filecharset;
	size_t ilen, olen, flen;
	string line;


	if(!file || !file[0])
		file = "rolename.txt";
	if (access(file, R_OK) != 0)
	{
		snprintf(errormsg,128,"cannot open file %s for reading", file);
		return -1;
	}
	close();
	
	cinput = iconv_open("UTF8",in_code);
	if(cinput==CDINVALID)
	{
		snprintf(errormsg,128,"cannot allocates a conversion descriptor from %s to UTF8", in_code);
		return -1;
	}
	if(check_code && check_code[0])
	{
		cvalid = iconv_open(check_code,in_code );
		if(cinput==CDINVALID)
			fprintf(stderr, "Warning: cannot allocates a conversion descriptor form %s to %s\n", in_code, check_code);
	}
	if(table_code && table_code[0])
		filecharset = table_code;
	else
		filecharset = "GBK";

	std::ifstream ifs;
	ifs.open(file, std::ios::binary);
	ifs.seekg (0, std::ios::end);
	flen = ifs.tellg();
	ifs.seekg (0, std::ios::beg);
	if(flen==0)
	{
		fprintf(stderr, "Warning: %s is empty, sensitive words checking disabled\n", file);
		return 0;
	}
	if(!(input = new char[flen]))
	{
		snprintf(errormsg,128,"memory alloc failed");
		return -1;
	}
	ifs.read(input, flen);
	ifs.close();

	if(!(buf = new char[flen*4]))
	{
		snprintf(errormsg,128,"memory alloc failed");
		return -1;
	}
	in = input;
	if(*(unsigned char*)in==0xFF && *(unsigned char*)(in+1)==0xFE)
	{
		// 跳过字节顺序标记，配置表应为Little-Endian，这里没处理Big-Endian的情况
		in += 2;
		if(strcasecmp(filecharset, "UCS2"))
		{
			fprintf(stderr, "Warning: table_charset should be set to UCS2\n");
			filecharset = "UCS2";
		}

	}

	iconv_t cv;
	cv = iconv_open("UTF8",filecharset);
	if(cv==CDINVALID)
	{
		snprintf(errormsg,128,"cannot allocates a conversion descriptor from %s to UTF8", table_code);
		return -1;
	}
	out = buf;
	ilen = flen;
	olen = flen*4;
	int buflen = olen;
	if(iconv(cv,&in,&ilen,&out,&olen)>=0) // 将配置表转为utf8格式
	{
		buf[buflen-olen] = 0;
		std::istringstream iss(buf,std::istringstream::in);
		/* 默认排除:
		   \s\n\r\t等控制字符
		   U+007F: DEL
		   U+00A0: 无中断空格 
		   U+2002-U+200D 一堆各种特殊空格
		   U+3000: 象形字间隔
		 */

		pattern = "([\\s\\n\\r\\t\\x{2002}-\\x{200D}\\x{3000}\\x7f\\xA0])";
		while(std::getline(iss, line))
		{
			size_t offset = line.find_first_of("\r\n");
			if(offset!=std::string::npos)
				line.erase(offset);
			if(line.size()>0)
				pattern += "|(" + line + ")";//注意文件中是否存在括号，存在括号需要转义，否则文件无法生效
		}

		const char *error;
		int erroffset;
		regexp = pcre_compile(pattern.c_str(),PCRE_CASELESS|PCRE_UTF8,&error,&erroffset,0); 
		if(!regexp)
		{
			snprintf(errormsg,128,"regular expression compilation failed");
			return -1;
		}
	}
	else
		snprintf(errormsg,128,"faild to convert %s from %s to UTF8", file, filecharset);
	delete[] input;
	delete[] buf;
	iconv_close(cv);
	return regexp?0:-1;
}

}
