#ifndef _RBT_H_
#define _RBT_H_

#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <unistd.h>
#include <string>
#include <map>
#include <set>
#include <list>
#include <unordered_map>
#include <functional>
#include <algorithm>
#include <assert.h>

extern "C"
{
#include "lua.h"
#include "lualib.h"
#include "lauxlib.h"
}

class RBT
{
	enum LUA_TYPE
	{
		LUA_TYPE_NIL = 0,
		LUA_TYPE_OBJECT,
		LUA_TYPE_BOOLEAN,
		LUA_TYPE_NUMBER,
	};

	struct _lua_value_t
	{
		//_type==LUA_TYPE_OBJECT, _i64_value is key of RBT_refer_table
		LUA_TYPE _type;
		union
		{
			bool _b_value;
			int64_t _i64_value;
			double _f64_value;
		};

	public:
		_lua_value_t() { memset(this, 0, sizeof(*this)); }
	};

	typedef std::map<int, _lua_value_t, std::greater<int> > VT; //version=>value

	struct _node_t
	{
		VT _vt;
		_lua_value_t _v; //confirmed value
	};

	std::unordered_map<std::string, _node_t*> _map; //name=>_node_t

	static int _cur; //current tick
	static int _confirm; //confirmed tick
	static int _ref_index_stub;
	static std::set<_node_t*> _unconfirmed_set;

public:
	int Get(lua_State *l);
	int Put(lua_State *l);
	void Destroy(lua_State *l);

public:
	static int Create(lua_State *l);
	static void Reset();
	static void Next(bool confirmed);
	static void Confirm(lua_State *l);
	static void Rollback(lua_State *l);

private:
	static int AllocRefIndex() { return ++_ref_index_stub; }
	static int RBT_Index(lua_State *l);
	static int RBT_NewIndex(lua_State *l);
	static int RBT_GC(lua_State *l);
	static void DeleteFromLua(lua_State *l, const _lua_value_t& lv);
};

#endif //_RBT_H_

