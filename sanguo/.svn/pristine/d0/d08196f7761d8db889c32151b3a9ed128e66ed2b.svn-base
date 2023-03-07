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
		//Base64Encoder::Convert(tmp[index].first_operation, first_operation_out);
		//Base64Encoder::Convert(tmp[index].second_operation, second_operation_out);
		snprintf(msg, sizeof(msg), "%d:%.*s:%.*s:", tmp[index].tick, (int)tmp[index].first_operation.size(),(char*)tmp[index].first_operation.begin(),
			(int)tmp[index].second_operation.size(),(char*)tmp[index].second_operation.begin());
		result += msg;
	}
	return result;
}

std::string SerializeManager::SerializeFightInfo(const std::vector<FightInfo> &tmp)
{
	std::string result;
	char msg[1024];
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
