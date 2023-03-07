#include "noticemanager.h"

namespace CACHE
{
NoticeManager::NoticeManager()
{
	time_t now = Timer::GetTime();
	struct tm tmp;
	localtime_r(&now, &tmp);
	tmp.tm_hour = 0;
	tmp.tm_min = 0;
	tmp.tm_sec = 0;
	update_time = mktime(&tmp) + 60*60*24;
	Initialize();
}

NoticeManager::~NoticeManager()
{
	_notice_map.Clear();
}

bool NoticeManager::Initialize()
{
	IntervalTimer::Attach(this, (1000000*60) / IntervalTimer::Resolution());
	return true;
}

bool NoticeManager::Update()
{
	time_t now = Timer::GetTime();
	struct tm tmp;
	localtime_r(&now, &tmp);

	NoticeMapIter it = _notice_map.SeekToBegin();
	Notice *value;
	for(; (value=it.GetValue()); it.Next())
	{
		if(value->_weekday != 0)
		{
			if((value->_weekday == tmp.tm_wday%7) && value->_hour == tmp.tm_hour && value->_minute == tmp.tm_min && value->_count < value->_max_count)
			{
				//这是代表时间到了,并且次数没有达到
				value->_minute = value->_minute + value->_interval;
				if(value->_minute >= 60)
				{
					value->_minute = value->_minute%60;
					value->_hour++;
					value->_hour = value->_hour%24;
				}
				value->_count++;
				SendNotice(value->_notice);
			}
		}
		else
		{
			if(value->_hour == tmp.tm_hour && value->_minute == tmp.tm_min && value->_count < value->_max_count)
			{
				//这是代表时间到了,并且次数没有达到
				value->_minute = value->_minute + value->_interval;
				if(value->_minute >= 60)
				{
					value->_minute = value->_minute%60;
					value->_hour++;
					value->_hour = value->_hour%24;
				}
				value->_count++;
				SendNotice(value->_notice);
			}
		}
	}
	if( now > update_time )
	{
		it = _notice_map.SeekToBegin();
		for(; (value=it.GetValue()); it.Next())
		{
			if(value->_type == 1)
			{
				value->_count = 0;
			}
		}
		tmp.tm_hour = 0;
		tmp.tm_min = 0;
		tmp.tm_sec = 0;
		update_time = mktime(&tmp) + 60*60*24;
	}
	return true;
}

void NoticeManager::Load()
{
}

void NoticeManager::Insert(Notice notice)
{
	NoticeMapIter it = _notice_map.SeekToBegin();
	int key = 0;
	Notice *value;
	for(; (value=it.GetValue()); it.Next())
	{
		if(value->_notice_id > key)
			key = value->_notice_id;
	}
	_notice_map.Insert(++key, notice);
}

void NoticeManager::SendNotice(std::string notice)
{
}

};
