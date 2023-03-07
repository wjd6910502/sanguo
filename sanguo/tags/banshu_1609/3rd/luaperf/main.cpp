#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <unistd.h>
#include <time.h>
#include <sys/mman.h>

extern "C"
{
#include "lua.h"
#include "lualib.h"
#include "lauxlib.h"
#include "luajit.h"

//extern void* mcode_range_begin();
//extern void* mcode_range_end();
extern int mcode_pre_alloc();
}

#if 0
static int script_GetTime(lua_State *l)
{
	lua_pushinteger(l, (int)time(0));
	return 1;
}

static int script_Return0(lua_State *l)
{
	lua_pushinteger(l, 0);
	return 1;
}

static int script_CreateVersionTable(lua_State *l)
{
	*(int**)lua_newuserdata(l, sizeof(int*)) = new int;
	lua_newtable(l);
	lua_pushstring(l, "__index");
	lua_pushcfunction(l, script_Return0);
	lua_rawset(l, -3);
	lua_setmetatable(l, -2);
	return 1;
}
#endif

int main()
{
	lua_State *L = luaL_newstate();
	luaL_openlibs(L);
	printf("L=%p\n", L);

	//printf("begin=%p, end=%p\n", mcode_range_begin(), mcode_range_end());
	//void *begin = mcode_range_begin();
	//void *end = mcode_range_end();
	//while(begin+65536 < end)
	//{
	//	if(begin > 0)
	//	{
	//		void *p = mmap(begin, 65536, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0);
	//		if(p == begin)
	//		{
	//			printf("ok, p=%p\n", p);
	//		}
	//		else
	//		{
	//			munmap(p, 65536);
	//		}
	//		
	//	}
	//	begin += 65536;
	//}

	printf("mcode_pre_alloc=%d\n", mcode_pre_alloc());

	//luaJIT_setmode(L, 0, LUAJIT_MODE_ENGINE | LUAJIT_MODE_OFF);

	//lua_register(L, "API_GetTime", script_GetTime);
	//lua_register(L, "API_Return0", script_Return0);
	//lua_register(L, "API_CreateVersionTable", script_CreateVersionTable);

	//luaL_dostring(L, "require('jit.opt').start('sizemcode=524288','maxmcode=524288'); local count=0; for i=1,10000 do count=count+1.1 end; print(count)");
	luaL_dostring(L, "local count=0; for i=1,100000000 do count=count+1.1 end; print(count)");

	//int *p = new int;
	//void *p = mmap(0, 1024*1024, PROT_NONE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0);
	//printf("%p\n", p);

	//while(1)
	//{
	//	sleep(1);
	//}

	lua_close(L);
	return 0;
}

