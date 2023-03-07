#ifndef __GNET_UNIQUENAMESERVER_HPP
#define __GNET_UNIQUENAMESERVER_HPP

#include "protocol.h"

namespace GNET
{

class UniqueNameServer : public Protocol::Manager
{
	static UniqueNameServer instance;
	size_t		accumulate_limit;
	const Session::State *GetInitState() const;
	bool OnCheckAccumulate(size_t size) const { return accumulate_limit == 0 || size < accumulate_limit; }
	void OnAddSession(Session::ID sid);
	void OnDelSession(Session::ID sid);
public:
	static UniqueNameServer *GetInstance() { return &instance; }
	std::string Identification() const { return "UniqueNameServer"; }
	void SetAccumulate(size_t size) { accumulate_limit = size; }
	UniqueNameServer() : accumulate_limit(0) { }
};

};
#endif
