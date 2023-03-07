#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <unistd.h>
#include <time.h>

extern "C"
{
#include "lua.h"
#include "lualib.h"
#include "lauxlib.h"
#include "luajit.h"
}


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

int main()
{
	lua_State *L = luaL_newstate();
	luaL_openlibs(L);

	//luaJIT_setmode(L, 0, LUAJIT_MODE_ENGINE | LUAJIT_MODE_OFF);
	//luaJIT_setmode(L, 0, LUAJIT_MODE_ENGINE | LUAJIT_MODE_FLUSH);

	lua_register(L, "API_GetTime", script_GetTime);
	lua_register(L, "API_Return0", script_Return0);
	lua_register(L, "API_CreateVersionTable", script_CreateVersionTable);

	if (luaL_dofile(L,"write.lua"))
	{
		fprintf(stderr, "error, luaL_dofile(write.lua)\n");
		return -1;
	}

	lua_close(L);
	return 0;
}

