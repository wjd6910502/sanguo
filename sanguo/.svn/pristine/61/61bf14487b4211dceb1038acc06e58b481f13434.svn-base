#ifndef _COMMON_VAR_H_
#define _COMMON_VAR_H_
#include <map>
#include <vector>
#include <string>
#include <memory.h>
#include "pvpvideo"
#include "fightinfo"

using namespace GNET;
using namespace std;

struct package_gift
{
	int tid;
	int count;
};

extern std::map< int, std::vector<package_gift> > g_gift;

class SerializeManager
{

public:
	static string SerializePvpOperation(const std::vector<PvpVideo> &tmp);
	static string SerializeFightInfo(const std::vector<FightInfo> &tmp);
};





#endif
