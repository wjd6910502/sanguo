#include "common_var.h"
#include "base64.h"

std::map< int,std::vector<package_gift> > g_gift;

void InitGift()
{
	package_gift tmp;
	std::vector<package_gift> gift_second;
	tmp.tid = 1111;
	tmp.count = 3;
	gift_second.push_back(tmp);
	tmp.tid = 2222;
	tmp.count = 3;
	gift_second.push_back(tmp);
	tmp.tid = 3333;
	tmp.count = 3;
	gift_second.push_back(tmp);
	tmp.tid = 4444;
	tmp.count = 3;
	gift_second.push_back(tmp);

	g_gift[1001] = gift_second;
}

std::string SerializeGift( std::vector<package_gift> tmp)
{
	std::string result;
	char msg[64];
	snprintf(msg, sizeof(msg), "%d:", (int)tmp.size());
	result = msg;

	for(unsigned int index = 0; index < tmp.size(); index++)
	{
		memset(msg, 0, sizeof(msg));
		snprintf(msg, sizeof(msg), "%d:%d:", tmp[index].tid, tmp[index].count);
		result += msg;
	}
	return result;
}

std::string SerializeManager::SerializePvpOperation(const std::vector<PvpVideo> &tmp)
{
	std::string result;
	char msg[1024];
	snprintf(msg, sizeof(msg), "%d:", (int)tmp.size());
	result = msg;

	std::string fight1,fight2;
	for(unsigned int index = 0; index < tmp.size(); index++)
	{
		//Octets first_operation_out;
		//Octets second_operation_out;
		memset(msg, 0, sizeof(msg));
		//Base64Encoder::Convert(first_operation_out, tmp[index].first_operation);
		//Base64Encoder::Convert(second_operation_out, tmp[index].second_operation);
		//snprintf(msg, sizeof(msg), "%d:%.*s:%.*s:", tmp[index].tick, (int)first_operation_out.size(),(char*)first_operation_out.begin(),
		//	(int)second_operation_out.size(),(char*)second_operation_out.begin());
		snprintf(msg, sizeof(msg), "%d:%.*s:%.*s:", tmp[index].tick, (int)tmp[index].first_operation.size(),(char*)tmp[index].first_operation.begin(),
			(int)tmp[index].second_operation.size(),(char*)tmp[index].second_operation.begin());
		result += msg;
	}
	return result;
}

std::string SerializeManager::SerializeFightInfo(const std::vector<FightInfo> &tmp)
{
	std::string result;
	char msg[4096];
	snprintf(msg, sizeof(msg), "%d:", (int)tmp.size());
	result = msg;

	//在这里拼字符串的时候要注意了，因为第二个和第三个是之前已经弄好的串，所以在这里就不可以加:了，否则会出问题的
	std::string fight1,fight2;
	for(unsigned int index = 0; index < tmp.size(); index++)
	{
		memset(msg, 0, sizeof(msg));
		snprintf(msg, sizeof(msg), "%d:%.*s%.*s", tmp[index].room_id, 
			(int)tmp[index].fight1_info.size(),(char*)tmp[index].fight1_info.begin(),
			(int)tmp[index].fight2_info.size(),(char*)tmp[index].fight2_info.begin());
		result += msg;
	}
	return result;
}

std::string SerializeManager::SerializeDanMuInfo(const std::vector<DanMuInfo> &tmp)
{
	std::string result;
	char msg[1024];
	snprintf(msg, sizeof(msg), "%d:", (int)tmp.size());
	result = msg;

	//这里需要稍微注意一下，因为role_id是int64_t类型的，所以需要用字符串来存储
//	std::string role_id, role_name, danmu_info;
	int tick;
	Octets role_id, role_name, danmu;
	for(unsigned int index = 0; index < tmp.size(); index++)
	{
		memset(msg, 0, sizeof(msg));
		snprintf(msg, sizeof(msg), "%ld", tmp[index].role_id);
		//result += msg;
		string role_str = msg;
		Base64Encoder::Convert(role_id, Octets((void*)role_str.c_str(), role_str.size()));
		result += std::string((char*)role_id.begin(), role_id.size());
		result += ":";

		memset(msg, 0, sizeof(msg));
		tick = tmp[index].tick;
		Base64Encoder::Convert(role_name,tmp[index].role_name);
		result += std::string((char*)role_name.begin(), role_name.size());
		result += ":";

		snprintf(msg, sizeof(msg), "%d:", tick);
		result += msg;
		
		Base64Encoder::Convert(danmu,tmp[index].danmu);
		result += std::string((char*)danmu.begin(), danmu.size());
		result += ":";
	}
	return result;
}
