#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <unistd.h>

extern "C"
{
#include "lua.h"
#include "lualib.h"
#include "lauxlib.h"
}

#include "rbt.h"

static int script_GetTime(lua_State *l)
{
	lua_pushinteger(l, (int)time(0));
	return 1;
}

static int script_RBT_Create(lua_State *l)
{
	return RBT::Create(l);
}

static int script_RBT_Reset(lua_State *l)
{
	RBT::Reset();
	return 0;
}

static int script_RBT_Next(lua_State *l)
{
	int n = lua_gettop(l);
	if(n != 1) return 0;

	bool confirmed = lua_toboolean(l, 1);

	RBT::Next(confirmed);
	return 0;
}

static int script_RBT_Confirm(lua_State *l)
{
	RBT::Confirm(l);
	return 0;
}

static int script_RBT_Rollback(lua_State *l)
{
	RBT::Rollback(l);
	return 0;
}

int main()
{
	lua_State *L = luaL_newstate();
	luaL_openlibs(L);

	lua_register(L, "API_GetTime", script_GetTime);

	lua_register(L, "API_RBT_Create", script_RBT_Create);
	lua_register(L, "API_RBT_Reset", script_RBT_Reset);
	lua_register(L, "API_RBT_Next", script_RBT_Next);
	lua_register(L, "API_RBT_Confirm", script_RBT_Confirm);
	lua_register(L, "API_RBT_Rollback", script_RBT_Rollback);

	if (luaL_dofile(L,"test.lua"))
	{
		fprintf(stderr, "error, luaL_dofile(test.lua)\n");
		return -1;
	}

	lua_close(L);
	return 0;
}

