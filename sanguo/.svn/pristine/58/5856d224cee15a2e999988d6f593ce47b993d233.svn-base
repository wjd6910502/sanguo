#ifndef __GNET_GAMEDBSERVER_HPP
#define __GNET_GAMEDBSERVER_HPP

#include "protocol.h"

namespace GNET
{

class GameDBServer : public Protocol::Manager
{
	static GameDBServer instance;
	size_t		accumulate_limit;
	const Session::State *GetInitState() const;
	bool OnCheckAccumulate(size_t size) const { return accumulate_limit == 0 || size < accumulate_limit; }
	void OnAddSession(Session::ID sid);
	void OnDelSession(Session::ID sid);
public:
	static GameDBServer *GetInstance() { return &instance; }
	std::string Identification() const { return "GameDBServer"; }
	void SetAccumulate(size_t size) { accumulate_limit = size; }
	GameDBServer() : accumulate_limit(0) { }

	void DispatchProtocol(Session::ID sid,const Protocol& p) { DispatchProtocol(sid,&p); }
	void DispatchProtocol(Session::ID sid,const Protocol* p);
};

};
#endif
