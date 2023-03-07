#ifdef WIN32
#include <winsock2.h>
#include "gncompress.h"
#else
//#include "binder.h"
#endif
#include "createrolename.hrp"

namespace GNET
{

static CreateRoleName __stub_CreateRoleName (RPC_CREATEROLENAME, new CreateRoleNameArg, new CreateRoleNameRes);
void make_compile_unit_stubs_o_md5sum_no_change_no_use_but_do_not_delete_it___for_uniquenamed() {} //非常山寨的解决重新编译md5sum保持不变的问题
};

