#include <sys/types.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <sys/socket.h>
#include <netdb.h>
#include <arpa/inet.h>
#include <fcntl.h>
#include <sys/time.h>
#include <string>
#include <vector>
#include <map>
#include <set>

using namespace std;

inline int DJBHash(const string& data)
{
	unsigned int hash = 5381;
	//const char *p = (const char*)data.c_str();
	const unsigned char *p = (const unsigned char*)data.c_str(); //FIXME: c# byte
	for(size_t i=0; i<data.size(); i++)
	{   
		hash += (hash << 5) + p[i];
	}   
	return (hash&0x7fffffff);
}

inline int Signature(const string& data, const string& key)
{
	//本想用随机算法的，可是这是确定性的，够蛋疼
	//int hash = DJBHash(data);
	//return (16807*hash)%2147483647;

	//string tmp = data;
	//tmp += key;
	//return DJBHash(tmp);

	unsigned int hash = 5381;
	//const char *p = (const char*)data.c_str();
	const unsigned char *p = (const unsigned char*)data.c_str();
	for(size_t i=0; i<data.size(); i++)
	{   
		hash += (hash << 5) + p[i];
	}   
	p = (const unsigned char*)key.c_str();
	for(size_t i=0; i<key.size(); i++)
	{   
		hash += (hash << 5) + p[i];
	}   
	return (hash&0x7fffffff);
}

int main(int argc, char *argv[])
{
	for(auto i=0; i<10; i++)
	{
		string s;
		for(auto j=0; j<i; j++)
		{
			s.push_back('\0');
		}
		printf("%d %d %d\n", (int)s.size(), DJBHash(s), Signature(s, "0123456789"));
	}

	return 0;
}

