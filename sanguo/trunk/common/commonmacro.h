#ifndef _COMMON_MACRO_H_
#define _COMMON_MACRO_H_

#include <string>
#include <sys/time.h>
#include "octets.h"
#include "mutex.h"

enum SERVER_CONST
{
	SERVER_CONST_WORKER_THREAD_COUNT		=	12,
	SERVER_CONST_TICK_PER_SECOND			=	20,
	SERVER_CONST_TICK_MICROSEC			=	50000,
	SERVER_CONST_ACTIVE_PLAYERS_HISTORY_MAX		=	60,
	SERVER_CONST_MESSAGE_TARGET_ACTIVE_ROLES	=	-1,
	SERVER_CONST_MESSAGE_TARGET_ACTIVE_MAFIAS	=	-2,
	SERVER_CONST_SYSTEM_PLAYER_ROLE_ID_BEGIN	=	1,
	SERVER_CONST_SYSTEM_PLAYER_COUNT		=	10,
	SERVER_CONST_ROLE_ID_BEGIN			=	1000001,
	SERVER_CONST_LUA_MEMORY_MAX			=	100*1024*1024,
	SERVER_CONST_SAVE_INTERVAL			=	1*60,
	SERVER_CONST_GLOBAL_MESSAGE_COUNT		=	1000,
	SERVER_CONST_GLOBAL_MESSAGE_LENGTH_MAX		=	1000,
	SERVER_CONST_ROLE_NAME_CHARATER_NUM    = 6,
};

enum CONN_CONST
{
	CONN_CONST_RAND1_SIZE				=	32,
	CONN_CONST_RAND2_SIZE				=	32,
	CONN_CONST_TRANS_TOKEN_SIZE			=	32,
	CONN_CONST_TRANS_SALT_SIZE			=	32,
	CONN_CONST_WAIT_TRANS_CHALLENGE_COUNT_MAX	=	10,
	CONN_CONST_PASSWORD_SIZE_MIN			=	32,
	CONN_CONST_CLIENT_SEND_HISTORY_MAX		=	100,
	CONN_CONST_SERVER_SEND_HISTORY_MAX		=	1000,
};

enum ERR_CODE
{
	ERR_CODE_OK					=	0,
	ERR_CODE_WRONG_ACCOUNT_OR_PASSWORD		=	1,
	ERR_CODE_WRONG_TRANS_TOKEN			=	2,
	ERR_CODE_WRONG_KEY1				=	3,
	ERR_CODE_WRONG_VERSION				=	4,	//版本错误，客户端直接回到登陆界面去更新，就不要一直给服务器发包了
	ERR_CODE_CLOSE_SERVER				=	5,	//服务器已经关闭。暂时无法登录
};

enum KICKOUT_REASON
{
	KICKOUT_REASON_MULTI_LOGIN			=	1,
	KICKOUT_REASON_TOO_MUCH_COMMAND			=	2,
};

enum CENTER_COMMAND
{
	CENTER_BEGIN					=	1,
	CENTER_END					=	500,

	GAMED_BEGIN					=	501,
	GAMED_SEND_SERVER_GIFT				=	502,
	GAMED_SEND_ROLE_GIFT				=	503,
	GAMED_CLEAR_ROLE_GIFT				=	504,
	GAMED_END					=	1000,

	GAMEDBD_BEGIN					=	1001,
	GAMEDBD_FIND_ROLE				=	1002,
	GAMEDBD_END					=	1500,

};

enum SERVER_STATE
{
	SERVER_STATE_BEGIN				=	1,
	SERVER_STATE_LOADING                            =       2,
	SERVER_STATE_LOADING_END                        =       3,
	SERVER_STATE_RUNNING                            =       4,
	SERVER_STATE_CLOSED                             =       5,
};

inline char _i2c(unsigned char i)
{
	const char *_table = "0123456789abcdef";
	if (i < 16) return _table[i];
	return '0';
}
inline char _i2C(unsigned char i)
{
	const char *_table = "0123456789ABCDEF";
	if (i < 16) return _table[i];
	return '0';
}
inline GNET::Octets& B16Encode(GNET::Octets& o, bool tolower)
{
	GNET::Octets dst;
	dst.resize(o.size()*2);
	unsigned char *src_data = (unsigned char*)o.begin();
	char *dst_data = (char*)dst.begin();
	for (unsigned int i=0; i<o.size(); i++)
	{
		if(tolower)
		{
			dst_data[2*i] = _i2c(src_data[i]>>4);
			dst_data[2*i+1] = _i2c(src_data[i]&0x0f);
		}
		else 
		{
			dst_data[2*i] = _i2C(src_data[i]>>4);
			dst_data[2*i+1] = _i2C(src_data[i]&0x0f);
		}
	}
	o.swap(dst);
	return o;
}
//inline void PrintOctets(const char *prefix, const GNET::Octets& o)
//{
//	GNET::Octets _o = o;
//	B16Encode(_o, false);
//	fprintf(stderr, "%s%.*s\n", prefix, (int)_o.size(), (char*)_o.begin());
//}
inline std::string B16EncodeOctets(const GNET::Octets& o)
{
	GNET::Octets _o = o;
	B16Encode(_o, false);
	return std::string((char*)_o.begin(), _o.size());
}

inline int DJBHash(const GNET::Octets& o)
{
	unsigned int hash = 5381;
	//const char *p = (const char*)o.begin();
	const unsigned char *p = (const unsigned char*)o.begin(); //FIXME: for c# byte
	for(size_t i=0; i<o.size(); i++)
	{
		hash += (hash << 5) + p[i];
	}
	return (hash&0x7fffffff);
}

//很简单的签名算法
inline int UDPSignature(const GNET::Octets& data, const GNET::Octets& key)
{
	unsigned int hash = 5381;
	const unsigned char *p = (const unsigned char*)data.begin();
	for(size_t i=0; i<data.size(); i++)
	{
		hash += (hash << 5) + p[i];
	}
	p = (const unsigned char*)key.begin();
	for(size_t i=0; i<key.size(); i++)
	{
		hash += (hash << 5) + p[i];
	}
	return (hash&0x7fffffff);
}

class MyScoped
{
        GNET::Mutex2 *mx; 
	MyScoped& operator= (const MyScoped& rhs);
public:
        ~MyScoped () { if(mx) mx->Unlock(); }
        explicit MyScoped(GNET::Mutex2& m) : mx(&m) { mx->Lock(); }
        void Detach() { mx = NULL; }
        void Unlock() { mx->Unlock();}
        void Lock() {mx->Lock();}
	MyScoped(const MyScoped& rhs)
	{
		if(this != &rhs)
		{
			MyScoped& rhs2 = (MyScoped&)rhs;
			mx = rhs2.mx;
			rhs2.mx = 0;
		}
	}
};     

extern int time_offset;
inline time_t NowWithoutOffset() { return time(0); } //用于和游戏无关的机制
inline time_t Now() { return time(0)+time_offset; } //带偏移量，用于游戏内容
inline int64_t NowUS() //带偏移量(微秒us)，用于游戏内容
{
	timeval tv;
	gettimeofday(&tv,NULL);
	int64_t now_micro = (tv.tv_sec+time_offset)*(int64_t)1000000+tv.tv_usec;
	return now_micro;
}
inline bool InBigLock() { return true; } //TODO:

#endif //_COMMON_MACRO_H_

