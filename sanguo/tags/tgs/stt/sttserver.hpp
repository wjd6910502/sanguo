#ifndef __GNET_STTSERVER_HPP
#define __GNET_STTSERVER_HPP

#include "protocol.h"
#include "glog.h"
namespace GNET
{

class STTServer : public Protocol::Manager
{
	static STTServer instance;
	size_t		accumulate_limit;
	const Session::State *GetInitState() const;
	bool OnCheckAccumulate(size_t size) const { return accumulate_limit == 0 || size < accumulate_limit; }
	void OnAddSession(Session::ID sid);
	void OnDelSession(Session::ID sid);
	
	std::map<int,Session::ID> _zone_map; //zoneid => sid  
	
public:
	static STTServer *GetInstance() { return &instance; }
	std::string Identification() const { return "STTServer"; }
	void SetAccumulate(size_t size) { accumulate_limit = size; }
	STTServer() : accumulate_limit(0) { }
	
	bool DispatchProtocol(int zoneid, const Protocol* p)
	{
		printf("dispatch data\n");
		std::map<int,Session::ID>::iterator it = _zone_map.find(zoneid);
		if(it == _zone_map.end())
			return true;
		printf("sessionid = %d\n",it->second);
		return Send(it->second, p);
	}

	void ZoneRegister(int zoneid, int sid)
	{
		_zone_map[zoneid] = sid;
	}
	
	void sendTextToclient()
	{

	}

};

};
#endif
