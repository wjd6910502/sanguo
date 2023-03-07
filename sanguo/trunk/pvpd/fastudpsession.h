#ifndef _FAST_UDP_SESSION_H_
#define _FAST_UDP_SESSION_H_

#include <map>
#include <vector>
#include "octets.h"

namespace GNET
{

class Player;

class FastUDPSession
{
	Player *_player;

	int _index_stub;
	std::map<int,Octets> _data_map; //index=>data for send
	std::map<int,int64_t> _time_map; //index=>time of first send
	int _received_index; //c2s方向已经收到的最大index
	bool _need_send_ack;

public:
	FastUDPSession(Player *player): _player(player), _index_stub(0), _received_index(0), _need_send_ack(false) {}

	void Reset();
	void Send(const Octets& data, bool force);
	void OnAck(int index_ack);
	bool IsReceived(int index) const;
	void SetReceived(int index);
	void SendAck();
	void TriggerSend(int retrans_time_ms);
	void Dump(std::vector<Octets>& datas);
	void Clear();
};

}

#endif //_FAST_UDP_SESSION_H_

