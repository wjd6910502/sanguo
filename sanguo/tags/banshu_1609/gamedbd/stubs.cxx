#ifdef WIN32
#include <winsock2.h>
#include "gncompress.h"
#else
//#include "binder.h"
#endif
#include "dbloaddata.hrp"
#include "dbloadroledata.hrp"
#include "dbsavedata.hrp"
#include "centercommand.hpp"
#include "centercommandre.hpp"

namespace GNET
{

static DBLoadData __stub_DBLoadData (RPC_DBLOADDATA, new DBLoadDataArg, new DBLoadDataRes);
static DBLoadRoleData __stub_DBLoadRoleData (RPC_DBLOADROLEDATA, new DBLoadRoleDataArg, new DBLoadRoleDataRes);
static DBSaveData __stub_DBSaveData (RPC_DBSAVEDATA, new DBSaveDataArg, new DBSaveDataRes);
static CenterCommand __stub_CenterCommand((void*)0);
static CenterCommandRe __stub_CenterCommandRe((void*)0);
void make_compile_unit_stubs_o_md5sum_no_change_no_use_but_do_not_delete_it___for_gamedbd() {} //非常山寨的解决重新编译md5sum保持不变的问题
};

