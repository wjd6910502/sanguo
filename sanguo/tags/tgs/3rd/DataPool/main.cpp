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
//#include "GameDataPool.H"
//#include "clPathFile.h"

int main(int argc, char *argv[])
{
	DataPool *elementdata = 0;
	DataPool::CreateFromFileA(&elementdata, "./elementdata.dpc", DataPoolLoad_ReadOnly);

	MOVariable var;
	elementdata->QueryByExpression("role", &var);
	if(var.IsValid())
	{
		printf("ok\n");
	}

	return 0;
}
