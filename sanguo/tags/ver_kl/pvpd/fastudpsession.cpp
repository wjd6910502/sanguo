#include "fastudpsession.h"
#include "udps2cgameprotocols.hpp"
#include "playermanager.h"

namespace GNET
{

void FastUDPSession::Reset()
{
	_index_stub = 0;
	_data_map.clear();
	_received_index = 0;
	_need_send_ack = false;
}

void FastUDPSession::Send(const Octets& data)
{
	_index_stub++;
	_data_map[_index_stub] = data;
	TriggerSend();
}

void FastUDPSession::OnAck(int index_ack)
{
	auto it = _data_map.find(index_ack);
	if(it != _data_map.end()) _data_map.erase(_data_map.begin(), ++it);
}

bool FastUDPSession::IsReceived(int index) const
{
	return (index<=_received_index);
}

void FastUDPSession::SetReceived(int index)
{
	assert(index==_received_index+1); //TODO: 
	//if(index != _received_index+1) return;
	_received_index = index;
}

void FastUDPSession::SendAck()
{
	_need_send_ack = true;
}

void FastUDPSession::TriggerSend()
{
	if(_data_map.empty() && !_need_send_ack) return;

#ifdef DELAY_MODE
	UDPS2CGameProtocols *prot = new UDPS2CGameProtocols();
	prot->index = 0;
	if(!_data_map.empty()) prot->index = _data_map.begin()->first;
	size_t sz = 0;
	for(auto it=_data_map.begin(); it!=_data_map.end(); ++it)
	{
		const Octets& dat = it->second;
		prot->protocols.push_back(dat);
		sz += dat.size();
		if(sz > 1024) break; //TODO:
	}
	prot->index_ack = _received_index;
	_need_send_ack = false;

	//StatisticManager::GetInstance().IncUDPS2CCmdCount(prot.protocols.size());

	_player->SendUDPProtocol(prot, 500);
	//_player->SendUDPProtocol(prot, 1000);
#else
	UDPS2CGameProtocols prot;
	prot.index = 0;
	if(!_data_map.empty()) prot.index = _data_map.begin()->first;
	size_t sz = 0;
	for(auto it=_data_map.begin(); it!=_data_map.end(); ++it)
	{
		const Octets& dat = it->second;
		prot.protocols.push_back(dat);
		sz += dat.size();
		if(sz > 1024) break; //TODO:
	}
	prot.index_ack = _received_index;
	_need_send_ack = false;

	//StatisticManager::GetInstance().IncUDPS2CCmdCount(prot.protocols.size());
	timeval tv;
	gettimeofday(&tv,NULL);
	int64_t now_micro = tv.tv_sec*1000000+tv.tv_usec;
	
	prot.client_send_time = _player->GetPrevClientSendTime4PVP() + (now_micro-_player->GetPrevClientSendTime4PVPLocalTime())/1000;
	prot.server_send_time = (now_micro/1000)&0xffff;

	_player->SendUDPProtocol(prot);
#endif
}

}

