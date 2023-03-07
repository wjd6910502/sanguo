#include "script_wrapper.h"
#include <map>
#include <string>
#include <spinlock.h>
#include <interlocked.h>
#include <sys/time.h>
#include <unistd.h>
//#include <glog.h>

//#include "xfile.h"
//#include "log.h"

class LuaPerfMon
{
	const char *_func;
	timeval _begin;

public:
	LuaPerfMon(const char *func): _func(func)
	{
		gettimeofday(&_begin, 0);
	}
	~LuaPerfMon()
	{
		timeval tv;
		gettimeofday(&tv, 0);
		int64_t l = (tv.tv_sec-_begin.tv_sec)*1000000+(tv.tv_usec-_begin.tv_usec);
		//if(l > 10000) GLog::log(LOG_ERR,"脚本函数%s超时:%ld",_func, l);
		if(l > 100000) fprintf(stderr,"脚本函数%s超时:%ld",_func, l);
	}
};

LuaWrapper::LuaWrapper(lua_State* L) : __L(L),_stack_index(0),_num_result(0)
{
	if(__L)
	{
		_stack_index = lua_gettop(__L);
		//__PRINTF("LuaWrapper::LuaWrapper(lua_State* L) _stack_index=%d\n",_stack_index);
	}
}

LuaWrapper::~LuaWrapper()
{
	ResetStack();
}

bool LuaWrapper::gExec(const char* funcname,const LuaParameter& args,int ret_num)
{
	if(args.Size() > LUA_MAX_PARAM) return false;
	if(!__L) return false;
	LuaPerfMon mon(funcname);
	if(_num_result > 0) lua_pop(__L,_num_result);
	_num_result = -1;

	int index = lua_gettop(__L);
	lua_checkstack(__L,args.Size() + 1);
//	lua_getfield(__L,LUA_GLOBALSINDEX,funcname);
	lua_getglobal(__L,funcname);
	args.PushArgs(__L);
	if(lua_pcall(__L,args.Size(),ret_num,0))
	{
		//这里有错误 记录到result中
		_num_result = -1;
		_error = "Error when calling '";
		_error += funcname;
		_error += "':";
		_error += lua_tostring(__L,-1);
		lua_pop(__L,1);
		return false;
	}

	//将结果记录到Result中
	_num_result = lua_gettop(__L) - index;
	return true;
}

void LuaWrapper::PopResult() 
{
	if(!__L) return;
	if(_num_result > 0) lua_pop(__L,_num_result);
	_num_result = -1;
}

bool LuaWrapper::GetTable(int index, std::vector<double> &list)
{
	if(!lua_istable(__L,index)) return false;
	list.clear();
	int len = LUA_OBJLEN(__L,index);
	for( int i = 1; i <= len ; i ++)
	{
		lua_rawgeti(__L,index, i);
		double m = lua_tonumber(__L, -1);
		list.push_back(m);
		lua_pop(__L,1);
	}
	return true;
}

bool LuaWrapper::GetTable(int index, std::vector<int> &list)
{
	if(!lua_istable(__L,index)) return false;
	list.clear();
	int len = LUA_OBJLEN(__L,index);
	for( int i = 1; i <= len ; i ++)
	{
		lua_rawgeti(__L,index, i);
		int m = lua_tointeger(__L, -1);
		list.push_back(m);
		lua_pop(__L,1);
	}
	return true;
}

void LuaWrapper::ResetStack()
{
	if(__L)
	{
		lua_settop(__L,_stack_index);
	}
}

//全局性的cache
namespace 
{
	struct entry_t
	{
		void * data;
		size_t len;
	};

	int _lock = 0;
	int _ref = 0;
	std::map<std::string , entry_t> _cache;

	void * GetCache(const char* pathname, size_t *pLen)	
	{	
		void * rst = NULL;
		mutex_spinlock(&_lock);
		auto it = _cache.find(std::string(pathname));
		if(it != _cache.end())
		{
			*pLen = it->second.len;
			rst = it->second.data;
			interlocked_increment(&_ref);
		}
		mutex_spinunlock(&_lock);
		return rst;
	}

	void  PutCache(const char* pathname, void * data, size_t len)
	{	
		std::string name(pathname);
		mutex_spinlock(&_lock);
		auto it = _cache.find(name);
		if(it != _cache.end())
		{
			free(it->second.data);
			it->second.data = data;
			it->second.len = len;
		}
		else
		{
			entry_t ent;
			ent.data = data;
			ent.len = len;
			_cache[name] = ent;
		}
		mutex_spinunlock(&_lock);
	}

	void ReturnCache(void *)
	{
		//清除引用计数
		interlocked_decrement(&_ref);
	}

	void ClearCache()
	{
		while(true)
		{
			mutex_spinlock(&_lock);
			if(_ref == 0) break;
			mutex_spinunlock(&_lock);
			usleep(1);
		}
			
		for(auto it = _cache.begin(); it != _cache.end(); ++it)
		{
			free(it->second.data);
		}
		_cache.clear();
		mutex_spinunlock(&_lock);
	}
}

int XScriptLoad(lua_State * __L, const char * pathname)
{
#ifdef __XOM_USE_LUA_CACHE__
	size_t len;
	void * data= GetCache(pathname, &len);
	if(data)
	{
		//从缓存取得了数据，直接加载，并返回之
		//int rst = luaL_dostring(__L, (const char *)data);
		int rst = luaL_loadbuffer(__L, (const char *)data, len , pathname);
		if(!rst) rst =  lua_pcall(__L,0,LUA_MULTRET,0);		//改用loadbuffer ，这样支持bytecode
		ReturnCache(data);
		return rst;
	}


	char luac_path[1024];
	sprintf(luac_path, "%s.luac", pathname);
	//不在缓存中，加载一下
	data = XReadFile(luac_path, &len);
	if(!data)
	{
		//文件没有找到 再用原始路径找一下
		data = XReadFile(pathname, &len);
		if(!data) return -1006;
	}

	((char*)data)[len] = 0;	//将最后一个字节置成0， 成为一个0结尾的字符串， ReadFile会多分配一个字节
//	int rst = luaL_dostring(__L, (const char *)data);
	int rst = luaL_loadbuffer(__L, (const char *)data, len , pathname);
	if(!rst) rst =  lua_pcall(__L,0,LUA_MULTRET,0);		//改用loadbuffer ，这样支持bytecode
	PutCache(pathname, data,len);
	return rst;
#else
	return luaL_dofile(__L, pathname);
#endif
}


void  XScriptClearCache()
{
	ClearCache();
}

