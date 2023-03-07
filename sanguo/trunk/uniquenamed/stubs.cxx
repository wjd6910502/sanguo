#ifdef WIN32
#include <winsock2.h>
#include "gncompress.h"
#else
//#include "binder.h"
#endif
#include "createrolename.hrp"
#include "changerolename.hrp"
#include "createmafianame.hrp"
#include "changemafianame.hrp"

namespace GNET
{

static CreateRoleName __stub_CreateRoleName (RPC_CREATEROLENAME, new CreateRoleNameArg, new CreateRoleNameRes);
static ChangeRoleName __stub_ChangeRoleName (RPC_CHANGEROLENAME, new ChangeRoleNameArg, new ChangeRoleNameRes);
static CreateMafiaName __stub_CreateMafiaName (RPC_CREATEMAFIANAME, new CreateMafiaNameArg, new CreateMafiaNameRes);
static ChangeMafiaName __stub_ChangeMafiaName (RPC_CHANGEMAFIANAME, new ChangeMafiaNameArg, new ChangeMafiaNameRes);
void make_compile_unit_stubs_o_md5sum_no_change_no_use_but_do_not_delete_it___for_uniquenamed() {} //�ǳ�ɽկ�Ľ�����±���md5sum���ֲ��������
};

