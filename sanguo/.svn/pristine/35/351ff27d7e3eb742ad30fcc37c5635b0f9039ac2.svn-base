#ifndef __GNET_REGISTERSERVER_HPP
#define __GNET_REGISTERSERVER_HPP

#include "protocol.h"

namespace GNET
{

class RegisterServer : public Protocol::Manager
{
	static RegisterServer instance;
	size_t		accumulate_limit;
	const Session::State *GetInitState() const;
	bool OnCheckAccumulate(size_t size) const { return accumulate_limit == 0 || size < accumulate_limit; }
	void OnAddSession(Session::ID sid);
	void OnDelSession(Session::ID sid);
public:
	static RegisterServer *GetInstance() { return &instance; }
	std::string Identification() const { return "RegisterServer"; }
	void SetAccumulate(size_t size) { accumulate_limit = size; }
	RegisterServer() : accumulate_limit(0) { }
};

};
#endif
