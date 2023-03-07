
#include "gcenterserver.hpp"
#include "state.hxx"

namespace GNET
{

GCenterServer GCenterServer::instance;

const Protocol::Manager::Session::State* GCenterServer::GetInitState() const
{
	return &state_GCenterServer;
}

void GCenterServer::OnAddSession(Session::ID sid)
{
}

void GCenterServer::OnDelSession(Session::ID sid)
{
}

void GCenterServer::BroadcastToAllServer(const Protocol* p)
{
	for(std::map<int,Session::ID>::iterator it=_zone_map.begin(); it!=_zone_map.end(); ++it)
	{
		if(it->first == _kuafu_zoneid) continue; //FIXME: 不把跨服战场zone当正常服
		Send(it->second, p);
	}
}

void GCenterServer::BroadcastToAllServer(Protocol* p)
{
	for(std::map<int,Session::ID>::iterator it=_zone_map.begin(); it!=_zone_map.end(); ++it)
	{
		if(it->first == _kuafu_zoneid) continue; //FIXME: 不把跨服战场zone当正常服
		Send(it->second, p);
	}
}

bool GCenterServer::DispatchProtocol(int zoneid,const Protocol* p)
{
	std::map<int,Session::ID>::iterator it = _zone_map.find(zoneid);
	if(it == _zone_map.end()) 
		return true;
	return  Send(it->second, p);
}

void GCenterServer::ZoneRegister(int zoneid, int sid)
{
	_zone_map[zoneid] = sid;
}

bool GCenterServer::DispatchProtocolBySid(int sid,const Protocol* p)
{
	return Send(sid, p);
}

};
