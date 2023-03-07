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

#include "base64.h"

#define BUF_LEN_DEF	1024
static int script_Base64_enc(lua_State *l)
{
	int n = lua_gettop(l);
	if(n != 1) return 0;

	const char *in = lua_tostring(l, 1);
	int in_len = strlen(in);

	if(in_len > BUF_LEN_DEF)
	{
		char *out = new char[in_len*2];
		base64_encode((unsigned char*)in, in_len, out);
		lua_pushstring(l, out);
		delete out;
	}
	else
	{
		char buf[BUF_LEN_DEF*2];
		char *out = buf;
		base64_encode((unsigned char*)in, in_len, out);
		lua_pushstring(l, out);
	}
	return 1;
}
static int script_Base64_dec(lua_State *l)
{
	int n = lua_gettop(l);
	if(n != 1) return 0;

	const char *in = lua_tostring(l, 1);
	int in_len = strlen(in);

	if(in_len > BUF_LEN_DEF)
	{
		unsigned char *out = new unsigned char[in_len];
		int out_len = base64_decode((char*)in, in_len, out);
		out[out_len] = 0;
		lua_pushstring(l, (const char*)out);
		delete out;
	}
	else
	{
		unsigned char buf[BUF_LEN_DEF];
		unsigned char *out = buf;
		int out_len = base64_decode((char*)in, in_len, out);
		out[out_len] = 0;
		lua_pushstring(l, (const char*)out);
	}
	return 1;
}
#undef BUF_LEN_DEF

int main()
{
	lua_State *L = luaL_newstate();
	luaL_openlibs(L);

	lua_register(L, "API_Base64_enc", script_Base64_enc);
	lua_register(L, "API_Base64_dec", script_Base64_dec);

	if (luaL_dofile(L,"test.lua"))
	{
		fprintf(stderr, "error, luaL_dofile(test.lua)\n");
		return -1;
	}

	lua_close(L);
	return 0;
}

