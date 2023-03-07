#ifndef _MAFIA_MANAGER_H_
#define _MAFIA_MANAGER_H_

#include <string>
#include <map>

#include "forlua.h"
#include "structs.h"
#include "thread.h"
#include "mutex.h"
#include "transaction.h"

using namespace GNET;

namespace CACHE
{

class Mafia: public GNET::Marshal, public TransactionBase
{
public:
	Int64 _id;
	std::string _name;
	int _flag;
	std::string _announce;
	int _level;
	int _activity;
	Int64 _boss_id;
	std::string _boss_name;
	MafiaMemberMap _member_map;

	Mafia(): _flag(0), _level(0), _activity(0), _in_transaction(false) {}

	virtual OctetsStream& marshal(OctetsStream &os) const
	{
		os << _id;
		os << _name;
		os << _flag;
		os << _announce;
		os << _level;
		os << _activity;
		os << _boss_id;
		os << _boss_name;
		os << _member_map;
		return os;
	}
	virtual const OctetsStream& unmarshal(const OctetsStream &os)
	{
		os >> _id;
		os >> _name;
		os >> _flag;
		os >> _announce;
		os >> _level;
		os >> _activity;
		os >> _boss_id;
		os >> _boss_name;
		os >> _member_map;
		return os;
	}

	void backup(const char *name, int transaction_id) {}
	void restore(int transaction_id) {}
	void cleanup() {}

public:
	mutable Thread::Mutex _lock;

	bool _in_transaction;
	GNET::Octets _transaction_data;

	virtual void BeginTransaction();
	virtual void CommitTransaction();
	virtual void CancelTransaction();
	void Load(Octets &key, Octets &value);
	void Save();
};

class MafiaMap;
class MafiaMapIter
{
	MapIter<Int64, Mafia, std::map<Int64, Mafia>::iterator, MafiaMap> _rep;

public:
	MafiaMapIter(std::map<Int64, Mafia>::iterator it, void *map, int tag): _rep(it, map, tag) {}

	void Next() { _rep.Next(); }
	Mafia* GetValue() { return _rep.GetValue(); }
};
class MafiaMap: public GNET::Marshal
{
	Map<Int64, Mafia, std::map<Int64, Mafia>::iterator, MafiaMapIter> _rep;

public:
	MafiaMap(): _rep(this) {}
	MafiaMap(const MafiaMap& rhs): _rep(rhs._rep) { _rep.SetShell(this); }
	virtual ~MafiaMap() {}

	MafiaMap& operator= (const MafiaMap& rhs)
	{
		_rep = rhs._rep;
		_rep.SetShell(this);
		return *this;
	}

	void OnChanged() { _rep.OnChanged(); }
	int Tag() const { return _rep.Tag(); }
	std::map<Int64, Mafia>::iterator End() { return _rep.End(); }

	int Size() const { return _rep.Size(); }

	Mafia* Find(const Int64& k) { return _rep.Find(k); }
	void Insert(const Int64& k, const Mafia& v) { _rep.Insert(k, v); }
	void Delete(const Int64& k) { _rep.Delete(k); }
	void Clear() { _rep.Clear(); }

	MafiaMapIter SeekToBegin() const { return _rep.SeekToBegin(); }
	MafiaMapIter Seek(const Int64& k) const { return _rep.Seek(k); }
	MafiaMapIter SeekToLast() const { return _rep.SeekToLast(); }

	virtual GNET::Marshal::OctetsStream& marshal(GNET::Marshal::OctetsStream &os) const { return _rep.marshal(os); }
	virtual const GNET::Marshal::OctetsStream& unmarshal(const GNET::Marshal::OctetsStream &os) { return _rep.unmarshal(os); }
};

class MafiaManager
{
	MafiaMap _map;

	mutable Thread::Mutex _lock;

private:
	MafiaManager() {}

public:
	static MafiaManager& GetInstance()
	{
		static MafiaManager _instance;
		return _instance;
	}

	Mafia* Find(const Int64& k);
	void Insert(const Int64& k, const Mafia& v);
	void Delete(const Int64& k);
	void Load(Octets &key, Octets &value);
	void Save();

	//for lua
	MafiaMap& GetMap() { return _map; } //_map只在big锁状态下才会传给lua，此时系统处于单线程模式，无所谓锁不锁
};

}

inline CACHE::Mafia* API_GetLuaMafia(void *r) { return (CACHE::Mafia*)r; }

#endif //_MAFIA_MANAGER_H_

