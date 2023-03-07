#ifndef _ROLE_H_
#define _ROLE_H_

#include <string>
#include <map>
#include <list>

#include "octets.h"
#include "forlua.h"
#include "structs.h"

using namespace GNET;

namespace CACHE
{

class Player;
class Role: public GNET::Marshal
{
	int _transaction_id;
	std::map<std::string, GNET::Octets> _transaction_data;

public:
	RoleData _roledata;

	Role(Player *player): _transaction_id(0), _player(player), _last_active_time(0) {}

	virtual OctetsStream& marshal(OctetsStream &os) const
	{
		os << _roledata;
		return os;
	}
	virtual const OctetsStream& unmarshal(const OctetsStream &os)
	{
		os >> _roledata;
		return os;
	}

	void backup(const char *name, int transaction_id)
	{
		if(transaction_id != _transaction_id)
		{
			_transaction_id = transaction_id;
			_transaction_data.clear();
		}
		else if(_transaction_data.find(name) != _transaction_data.end())
		{
			return;
		}
	
		if(false)
		{
		}
		else if(strcmp(name, "_roledata") == 0)
		{
			_roledata.restore(transaction_id);

			OctetsStream os;
			os._for_transaction = true;
			os << _roledata;
			_transaction_data["_roledata"] = os;
		}
		else
		{
			abort();
		}
	}
	
	void restore(int transaction_id)
	{
		if(transaction_id == _transaction_id)
		{
			auto it = _transaction_data.end();
			it = _transaction_data.find("_roledata");
			if(it != _transaction_data.end())
			{
				OctetsStream os(it->second);
				os._for_transaction = true;
				os >> _roledata;
				_roledata.cleanup();
			}
			else
			{
				_roledata.restore(transaction_id);
			}
		}
		else
		{
			_roledata.restore(transaction_id);
		}
		_transaction_id = 0;
		_transaction_data.clear();
	}
	
	void cleanup()
	{
		_transaction_id = 0;
		_transaction_data.clear();
	
		_roledata.cleanup();
	}

public:
	Player *_player;
	int _last_active_time;

	//for lua
	bool IsActiveRole() const;

	void SendToClient(const std::string& v);
	void SendUDPToClient(const std::string& v);

	void SendPVPJoin(int score);
	void SendPVPEnter(int flag);
	void SendPVPReady();
	void SendPVPLeave(int reason, int typ);
	void SendPVPCancle();
	void SendPVPSpeed(int speed);
	void SendPVPReset();
	void GetPVPVideo(const std::string& v);
	void DelPVPVideo(const std::string& v);
	void SendSpeechToSTT(std::string dest_id, int type, std::string speech);
	void AudienceGetAllList();
	void AudienceGetRoomInfo(int room_id);
	void AudienceLeave(int room_id);
};

};

#endif //_ROLE_H_

