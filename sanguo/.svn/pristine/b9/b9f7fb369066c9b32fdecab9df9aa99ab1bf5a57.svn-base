#ifndef  _OBJECTMANAGER_HPP_
#define  _OBJECTMANAGER_HPP_

#include <iostream>
#include <map>
#include <algorithm>
#include "string.h"
#define MAX_SPEECH_SIZE 640*100
#define MAX_THREAD_NUM 100
#define MAX_DESTID_LEN 32

struct SpeechMsg
{
	int64_t _srcid;
	char _destid[MAX_DESTID_LEN];
	int _zoneid;
	int _time;
	int _chatype;
    unsigned char _speech[MAX_SPEECH_SIZE];
	unsigned int _speech_size;
	SpeechMsg()
	{
		_srcid = 0;
		_zoneid = 0;
		_time = 0;
		_chatype = 0;
		memset(_destid,'\0',MAX_DESTID_LEN);
		memset(_speech,'\0',MAX_SPEECH_SIZE);
		_speech_size = 0;
	}

	unsigned char* GetSpeech() { return _speech; }
	bool SetSpeech(unsigned char* speech, unsigned int len) 
	{ 
		if(len >= MAX_SPEECH_SIZE)
			return false;

		memcpy(_speech,speech,len);   
		return true;
	}

	char* GetDestId() { return _destid; }
	void SetdestId(char* destid) 
	{ 
		memcpy(_destid,destid,strlen(destid));   
	}

};


enum pool_status
{
	POOL_OBJECT_STATUS_FREE = 0, //自由的
	POOL_OBJECT_STATUS_INUSE = 1, //使用中

};

class map_value_finder
{

public:
		map_value_finder(int cmp_int):m_int(cmp_int) {}
		bool operator () ( const std::map<SpeechMsg*, int>::value_type &pair )
		{	
			return pair.second == m_int;	
		}

private:
		const int m_int;

};

class ObjectManager
{
protected:
	ObjectManager();
	~ObjectManager();
public:
	static ObjectManager *GetInstance() {return &instance;}

private:
	static ObjectManager instance;
	std::map<SpeechMsg*,int> m_poollist;	

public:
	SpeechMsg* allocMsg();
	//SpeechMsg* allocMsg1(); 	
	void setState(SpeechMsg* msg ,int st);
	void Staticdata();	
};
#endif
