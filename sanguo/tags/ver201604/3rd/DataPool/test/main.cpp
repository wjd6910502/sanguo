#include <cstdio>
#include <cstdlib>

#include "clstd.h"
#include "cltypes.h"
#include "gxBaseTypes.H"
#include "clAllocator.h"
#include "clString.H"
#include "clBuffer.H"
#include "GUnknown.H"
#include "clFile.H"
#include "GrapX.H"
#include "DataPool.H"
#include "DataPoolVariable.H"
#include "DataPoolIterator.h"
#include "GameDataPool.H"
//#include "clPathFile.h"



//DP dp;
//dp.Load("../elementdata.dpc");
//dp.AddKey("id", "role", "id");
//dp.

int main(int argc, char *argv[])
{
	DataPool *pool = 0;
	DataPool::CreateFromFileA(&pool, "../elementdata.dpc", DataPoolLoad_ReadOnly);
	//DataPool::CreateFromFileA(&pool, "/home/duxiaogang/SANGUO_ServerSVN/3rd/DataPool/elementdata.dpc", DataPoolLoad_ReadOnly);
	if(!pool)
	{
		printf("error 1\n");
		return 1;
	}

	DataPoolDict *dict = new DataPoolDict(pool);
	int i = dict->SetArrayKey("id", "role", "id");
	printf("i=%d\n", i);

	//way 1
	MOVariable var;
	pool->QueryByExpression("role", &var);
	if(!var.IsValid())
	{
		printf("error 2\n");
		return 1;
	}
	
	DataPool::LPCSTR _1 = 0;
	int _2 = 0;
	int index = dict->FindByKey("id", 29, &_1, &_2);
	if(index < 0)
	{
		printf("error 3\n");
		return 1;
	}

	MOVariable var2 = var[index];
	if(!var2.IsValid())
	{
		printf("error 4\n");
		return 1;
	}

	MOVariable var3 = var2.MemberOf("soulID");
	if(!var3.IsValid())
	{
		printf("error 5\n");
		return 1;
	}

	printf("%s %d %d\n", (const char*)var3.GetName(), (const char*)var3.GetTypeCategory(), var3.ToInteger());
	//printf("%s\n", (const char*)var3.ToStringA()); //FIXME:















	//way 2
	MOVariable var4;
	pool->QueryByExpression("role[0].soulID", &var4);
	printf("%s %d %d\n", (const char*)var4.GetName(), (const char*)var4.GetTypeCategory(), var4.ToInteger());













	//way 3
	DataPool *pool2 = 0;
	DataPool::CreateFromFileA(&pool2, "../anim.dpc", DataPoolLoad_ReadOnly);
	if(!pool2)
	{
		printf("error 6\n");
		return 1;
	}

	MOVariable var5;
	//pool2->QueryByExpression("animevent", &var5);
	//pool2->QueryByExpression("animevent.daqiao_bs_2", &var5);
	pool2->QueryByExpression("animevent.daqiao_bs_2.anim[1]", &var5);
	if(!var5.IsValid())
	{
		printf("error 6\n");
		return 1;
	}

	//MOVariable var6 = var5.MemberOf("daqiao_bs_2.anim[1].time");
	//MOVariable var6 = var5.MemberOf("anim[1].time");
	MOVariable var6 = var5.MemberOf("time");
	if(!var6.IsValid())
	{
		printf("error 7\n");
		return 1;
	}

	printf("%s %d %f\n", (const char*)var6.GetName(), (const char*)var6.GetTypeCategory(), var6.ToFloat());

	return 0;
}

