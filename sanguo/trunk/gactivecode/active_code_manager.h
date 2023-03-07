
#ifndef _ACTIVE_CODE_MANAGER_H_
#define _ACTIVE_CODE_MANAGER_H_

namespace GNET
{
	
#define KEY_LEN 16
#define KEY_SPLIT 4
#define KEY_TYPE_LEN 4
#define KEY_NUMB_LEN 4

class ActiveCodeManager
{
public:
	static ActiveCodeManager& GetInstance()
	{
		static ActiveCodeManager _instance;
		return _instance;
	}
	
	/*
	 * n一个激活码可以使用n次
	 *
	 */
	bool MakeActiveCode(unsigned short type, int count, unsigned short numb);
	bool InsertActiveCode(const char * path, short type);
	char ConvertChar(char c);

	char hex_value_char(int i);
	bool EncodeType(int type, char* encode, int len);
	int hex_char_value(char c);
	int ParseType(const char* activecode, int len);

};

};

#endif /*_ACTIVE_CODE_MANAGER_H_*/

