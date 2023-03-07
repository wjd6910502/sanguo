#include"./FTG/CBattle.h"
#include"reader.h"
#include"./FTG/CBattleInvoke.h"

bool JudgeOperation(int map_id, string brdinfo, string operation)
{
	lua_State* tt=lua_open();
	if(luaL_dofile(tt,brdinfo.c_str()))
	{	printf("do file btd.lua failed");
		return false ;
	}
	CBattle* pcbattle=CBattle::instance();
	ALPCSTR datapath=".";
	pcbattle->Awake((long)tt,NULL,1,true,false,datapath,1);
	pcbattle->LoadStageInfo(map_id);
	pcbattle->CreateLuaRole();
	pcbattle->Init();
	int i=0;
	vector<string> tmp1;
	vector<basedata> tmp2;
	readfromfile(operation.c_str(),tmp1);
	trans(tmp1,tmp2);
	auto p=tmp2.begin();
	int ticknum=1;
	while(p!=tmp2.end())
	{
		auto q=p->op.begin();
		for(;q!=p->op.end();++q)
		{
			pcbattle->ReceiveCommand(*q);
			cout<<*q<<"  ";
	
		}
		cout<<endl;
		int crc;
		pcbattle->luaMgr->CallLuaFunc("Battle.GetCRC",LUA_PARAMS());
		crc=pcbattle->Get_CRCValue();
		pcbattle->TickGame(1.0/30);
		//if(crc != p->crc)
		cout<<p->tick<<","<<crc<<","<<p->crc<<endl;
		++ticknum;
		++p;
	}
	pcbattle->ReleaseGame();
	return true;
}
