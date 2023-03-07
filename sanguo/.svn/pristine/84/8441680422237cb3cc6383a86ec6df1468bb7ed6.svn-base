#include "fastudpsession.h"
#include "udps2cgameprotocols.hpp"
#include "playermanager.h"
#include "commonmacro.h"
#include "glog.h"

namespace GNET
{

void FastUDPSession::Reset()
{
	_index_stub = 0;
	_data_map.clear();
	_time_map.clear();
	_received_index = 0;
	_need_send_ack = false;
}

void FastUDPSession::Send(const Octets& data, bool force)
{
	_index_stub++;
	_data_map[_index_stub] = data;
	if(force) TriggerSend(0); //这里retrans_time_ms填多少都一样，总有新数据要发的
}

void FastUDPSession::OnAck(int index_ack)
{
	//printf("FastUDPSession::OnAck, index_ack=%d\n", index_ack);
	auto it = _data_map.find(index_ack);
	if(it != _data_map.end()) _data_map.erase(_data_map.begin(), ++it);
	auto it2 = _time_map.find(index_ack);
	if(it2 != _time_map.end()) _time_map.erase(_time_map.begin(), ++it2);
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

void FastUDPSession::TriggerSend(int retrans_time_ms)
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

	_player->SendUDPProtocol(prot, 200);
	//_player->SendUDPProtocol(prot, 1000);
#else
	timeval tv;
	gettimeofday(&tv,NULL);
	int64_t now_micro = tv.tv_sec*1000000+tv.tv_usec;

	//判断是否要重传
	if(!_data_map.empty() && !_need_send_ack)
	{
//GLog::log(LOG_INFO, "PVPD::FastUDPSession::TriggerSend1, _role_id=%ld, retrans_time_ms=%d", _player->GetRoleId(), retrans_time_ms);
		int i = _data_map.rbegin()->first;
		auto it = _time_map.find(i);
		if(it != _time_map.end())
		{
//GLog::log(LOG_INFO, "PVPD::FastUDPSession::TriggerSend2, _role_id=%ld, retrans_time_ms=%d", _player->GetRoleId(), retrans_time_ms);
			//现存的所有数据都已经send过了，那本次send必然只能是纯粹的重传
			it = _time_map.begin();
			int64_t t = it->second;
			if(now_micro-t<retrans_time_ms*1000) return;
		}
	}

	UDPS2CGameProtocols prot;
	prot.index = 0;
	if(!_data_map.empty()) prot.index = _data_map.begin()->first;
	//printf("FastUDPSession::TriggerSend, prot.index=%d\n", prot.index);
	size_t sz = 0;
	for(auto it=_data_map.begin(); it!=_data_map.end(); ++it)
	{
		const Octets& dat = it->second;
		prot.protocols.push_back(dat);
		sz += dat.size();

		if(_time_map.find(it->first)==_time_map.end()) _time_map[it->first]=now_micro;

		if(sz > 1024) break; //TODO:
	}
	prot.index_ack = _received_index;
	_need_send_ack = false;

	//StatisticManager::GetInstance().IncUDPS2CCmdCount(prot.protocols.size());
	
	if(_player->GetPrevClientSendTime4PVP()==0)
		prot.client_send_time = 0;
	else
		prot.client_send_time = _player->GetPrevClientSendTime4PVP() + (now_micro-_player->GetPrevClientSendTime4PVPLocalTime())/1000;
	prot.server_send_time = (now_micro/1000)&0xffff;

	//signature
	Octets tmp;
	tmp.push_back(&prot.index, sizeof(prot.index));
	for(auto it=prot.protocols.begin(); it!=prot.protocols.end(); ++it)
	{
		tmp.push_back(it->begin(), it->size());
	}
	tmp.push_back(&prot.index_ack, sizeof(prot.index_ack));
	tmp.push_back(&prot.client_send_time, sizeof(prot.client_send_time));
	tmp.push_back(&prot.server_send_time, sizeof(prot.server_send_time));
	prot.signature = UDPSignature(tmp, _player->GetKey());

	_player->SendUDPProtocol(prot);
#endif
}

void FastUDPSession::Dump(std::vector<Octets>& datas)
{
	for(auto it=_data_map.begin(); it!=_data_map.end(); ++it)
	{
		datas.push_back(it->second);
	}
}

void FastUDPSession::Clear()
{
	_data_map.clear();
}

}

