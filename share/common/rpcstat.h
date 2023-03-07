
#ifndef _RPC_STAT_H_
#define _RPC_STAT_H_

#include <vector>
#include <map>
#include <algorithm>

#define RESERVE_SIZE	10000

namespace GNET
{

class RpcStat
{
public:
	struct StatInfo
	{
		unsigned int _type;
		struct timeval _begin;
		struct timeval _end;
	};
	typedef std::vector<StatInfo> StatInfoVec;

private:
	struct Node
	{
		unsigned int _type;
		size_t _count;
		int64_t _total_time; //micro sec
		size_t _max_time;

		Node(): _type(0), _count(0), _total_time(0), _max_time(0) {}

		void Add(const StatInfo& info)
		{
			_type = info._type;
			_count += 1;
			size_t t = (info._end.tv_sec-info._begin.tv_sec)*1000000 + info._end.tv_usec-info._begin.tv_usec;
			_total_time += t;
			if (t > _max_time)
				_max_time = t;
		}

		bool operator< (const Node& rhs) //优先于的意思
		{
			return _count>rhs._count;
		}
	};
	typedef std::map<unsigned int, Node> NodeMap;
	typedef std::vector<Node> NodeVec;

	Thread::Mutex _locker;
	std::vector<StatInfo> _infos;

public:
	RpcStat(): _locker("share::rpcstat::_locker")
	{
		_infos.reserve(RESERVE_SIZE);
	}
	static RpcStat& Instance()
	{
		static RpcStat _instance;
		return _instance;
	}

	void AddInfo(const StatInfo& info)
	{
		Thread::Mutex::Scoped l(_locker);
		_infos.push_back(info);
	}
	void ResetAndDump()
	{
		StatInfoVec infos;
		{
			Thread::Mutex::Scoped l(_locker);
			infos.swap(_infos);
			_infos.reserve(RESERVE_SIZE);
		}
		Dump(infos);
	}

private:
	void Dump(const StatInfoVec& infos)
	{
		//起始时刻
		//struct timeval begin;
		//struct timeval end;
		Node all; //所有协议: 平均时间/最大时间
		NodeMap map; //TopN协议: 平均时间/最大时间
		NodeVec vec;

		for (StatInfoVec::const_iterator it=infos.begin(), ie=infos.end(); it!=ie; ++it)
		{
			const StatInfo& si = *it;
			all.Add(si);
			map[si._type].Add(si);
		}

		//按协议次数排序
		vec.reserve(map.size());
		for (NodeMap::const_iterator it=map.begin(), ie=map.end(); it!=ie; ++it)
			vec.push_back(it->second);
		NodeVec::iterator im = vec.end();
		if (vec.size() > 10)
			im = vec.begin() + 10;
		std::partial_sort(vec.begin(), im, vec.end());

		if (all._count > 0)
			Log::log(LOG_STAT, "RPC_STAT, all type, count=%u, avg_time=%lld, max_time=%u", all._count, all._total_time/all._count, all._max_time);
		size_t n = 0;
		for (NodeVec::const_iterator it=vec.begin(), ie=vec.end(); it!=ie && n<10; ++it, ++n)
		{
			const Node& nd = *it;
			if (nd._count > 0)
				Log::log(LOG_STAT, "RPC_STAT, type=%u, count=%u, avg_time=%lld, max_time=%u", nd._type, nd._count, nd._total_time/nd._count, nd._max_time);
		}
	}
};

class RpcStatKeeper
{
	RpcStat::StatInfo _info;

public:
	RpcStatKeeper(unsigned int type)
	{
		_info._type = type;
		gettimeofday(&_info._begin, 0);
	}
	~RpcStatKeeper()
	{
		gettimeofday(&_info._end, 0);
		RpcStat::Instance().AddInfo(_info);
	}
};

};

#endif /*_RPC_STAT_H_*/

