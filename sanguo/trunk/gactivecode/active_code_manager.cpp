#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <cstring>
#include <unistd.h>
#include "security.h"
#include "commonmacro.h"
#include "math.h"

#include "dbmgrdef.h"
#include "active_code_manager.h"
#include <map>

namespace GNET
{
	
static char N2C(char c)
{
	if (c>='A' && c<='F') return c;

	const char *buf = "GHJKLMNPRS";
	if (c<'0' || c>'9') c = '0';
	return buf[c-'0'];
}

bool ActiveCodeManager::MakeActiveCode(unsigned short type, int count, unsigned short numb)
{
	int fd = open("/dev/urandom", O_RDONLY);
	if (fd < 0) return false;

	const int rlen = 128;
	char rbuf[rlen+20];
	memset(rbuf, 0, sizeof(rbuf));
	if (read(fd, rbuf, rlen) != rlen)
	{
		close(fd);
		return false;
	}
	close(fd);
	
	char tchar[KEY_TYPE_LEN];
	memset(tchar,0,KEY_TYPE_LEN);
	EncodeType(type,tchar,KEY_TYPE_LEN);
	
	FILE *fp = fopen("codes.txt", "w+");
	if (!fp) return false;

	CREATE_TRANSACTION(txnobj, txnerr, txnlog)
	LOCK_TABLE(codes)
	START_TRANSACTION
	{
		int count_bak = count;
		int i = 0;
		while (count > 0)
		{
			Security *md5 = Security::Create(MD5HASH);
			sprintf(rbuf+rlen, "%d", i++);
			Octets o(rbuf, sizeof(rbuf));
			md5->Update(o);
			Octets digest;
			md5->Final(digest);
			md5->Destroy();
			B16Encode(digest, false);
			
			Octets key = Octets(digest.begin(), KEY_LEN);
			char *ct = (char*)key.begin();
				
			for (int j=0; j<KEY_LEN; j++)
			{	if(j<KEY_SPLIT)
					ct[j] = N2C(tchar[j]);
				else
					ct[j] = N2C(ct[j]);
			}	
			
			Octets value;
			if (!codes->find(key, value, txnobj))
			{
				unsigned short use_count = numb; 	
		
				codes->insert(key, Marshal::OctetsStream()<<use_count, txnobj);
				count--;
				//printf("%.*s-%.*s-%.*s-%.*s\n", 4, (char*)key.begin(), 4, (char*)key.begin()+4, 4, (char*)key.begin()+8, 4, (char*)key.begin()+12 );
				//fprintf(fp, "%.*s-%.*s-%.*s-%.*s\n", 4, (char*)key.begin(), 4, (char*)key.begin()+4, 4, (char*)key.begin()+8, 4, (char*)key.begin()+12 );
				fprintf(fp, "%.*s\n", key.size(), (char*)key.begin() );
				printf("%.*s\n",key.size(),(char*)key.begin());
			}
		}
		Log::formatlog("MakeActiveCode", "type=%d, count=%d, use_count =%d\n", type, count_bak, numb);
		fclose(fp);
		fp = NULL;
	}
	END_TRANSACTION
	if(txnerr)
	{
		if(fp)
		{
			fclose(fp);
			fp = NULL;
		}
		Log::log(txnlog, "MakeActiveCode: (%d) %s.", txnerr,GamedbException::GetError(txnerr));
	}

	return true;
}

bool ActiveCodeManager::InsertActiveCode(const char *path, short type)
{
	FILE *fp = fopen(path, "r+");
	if(!fp)
		return false;

	CREATE_TRANSACTION(txnobj, txnerr, txnlog)
	LOCK_TABLE(codes)
	START_TRANSACTION
	{
		int count_bak = 0;
		char buff[30];
		const char * tmp1 = "wmsyjnh";
		memset(buff,0,sizeof(buff));
		while (fgets(buff, 30, fp))
		{
			Octets key;
			if(memcmp(buff,tmp1,strlen(tmp1)) == 0)
			{
				for(unsigned int i=0; i < strlen(tmp1); i++)
				{
					char c = tmp1[i];
					key.insert(key.end(), &c, sizeof(c));
				}
			}
			else
			{
				//去掉非法字符
				for (unsigned int i=0; i < 30; i++)
				{
					char c = ConvertChar(buff[i]);
					if (c) 
						key.insert(key.end(), &c, sizeof(c));
				}
			}
			Octets value;
			if (!codes->find(key, value, txnobj))
			{
				count_bak++;
				bool used = 0;
				codes->insert(key, Marshal::OctetsStream()<<used, txnobj);
			}
		}
		Log::formatlog("InsertActiveCode", "type=%d, count=%d\n", type, count_bak);
		fclose(fp);
		fp = NULL;
	}
	END_TRANSACTION
	if(txnerr)
	{
		if(fp)
		{
			fclose(fp);
			fp = NULL;
		}
		Log::log(txnlog, "InsertActiveCode: (%d) %s.", txnerr,GamedbException::GetError(txnerr));
	}

	return true;

}

char ActiveCodeManager::ConvertChar(char c)
{
	switch (c)
	{
		case 'A':
		case 'B':
		case 'C':
		case 'D':
		case 'E':
		case 'F':
		case 'G':
		case 'H':
		case 'J':
		case 'K':
		case 'L':
		case 'M':
		case 'N':
		case 'P':
		case 'R':
		case 'S':
			return c;
		case 'a':
		case 'b':
		case 'c':
		case 'd':
		case 'e':
		case 'f':
		case 'g':
		case 'h':
		case 'j':
		case 'k':
		case 'l':
		case 'm':
		case 'n':
		case 'p':
		case 'r':
		case 's':
			return c+('A'-'a');
		default:
			return 0;
	}
}

char ActiveCodeManager::hex_value_char(int i)
{
	static char hexchar[] = "0123456789ABCDEFG";
	if(i >= 16 || i < 0)
		return hexchar[16]; 

	return hexchar[i]; 	
}

bool ActiveCodeManager::EncodeType(int type,char* encode, int len)
{
	if(encode == NULL)
		return false;
	
	if(type >= 65535 || type < 0)
		return false;

	for(int j = len - 1; j >= 0; j--)
	{
		encode[j] = hex_value_char(type%16);
		type=type/16;
	}
	return true;
}

int ActiveCodeManager::hex_char_value(char c)
{
	//const char *buf = "GHJKLMNPRS";
	static std::map<char,int> buf;
	buf.insert(std::make_pair('G',0));
	buf.insert(std::make_pair('H',1)); 
	buf.insert(std::make_pair('J',2)); 
	buf.insert(std::make_pair('K',3)); 
	buf.insert(std::make_pair('L',4)); 
	buf.insert(std::make_pair('M',5)); 
	buf.insert(std::make_pair('N',6)); 
	buf.insert(std::make_pair('P',7)); 
	buf.insert(std::make_pair('R',8)); 
	buf.insert(std::make_pair('S',9)); 
	
	if(c >= 'a' && c <= 'f')
		return  ((c - 'a' + 10)&0xFF);
	else if(c >= 'A' && c <= 'F')
		return ((c - 'A' + 10)&0xFF);
	else 
	{
		if (buf.find(c) != buf.end())
			return (buf[c]&0xFF);
		else
		{
			std::cout<<"不存在的类型"<<std::endl;
			return 0;
		}
	}

	return 0;
}

int ActiveCodeManager::ParseType(const char* activecode, int len)
{
	int t = 0;
 	int k = 0; 		
    for(unsigned int i =0; i < strlen(activecode); i++)
    {  
    	if(k >= len)
    		break;
    	char c = ConvertChar(activecode[i]);
    	if(c)
    	{	
    		t += (int)pow(16,len-i-1)*hex_char_value(c);	
    		k++;	
    	}
    }
	return t;
}

};

