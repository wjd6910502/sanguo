#ifndef __GNET_LAOHUINFORMSERVER_HPP
#define __GNET_LAOHUINFORMSERVER_HPP

#include "protocol.h"

namespace GNET
{

class LaohuInformServer : public Protocol::Manager
{
	static LaohuInformServer instance;
	size_t		accumulate_limit;
	const Session::State *GetInitState() const;
	bool OnCheckAccumulate(size_t size) const { return accumulate_limit == 0 || size < accumulate_limit; }
	void OnAddSession(Session::ID sid);
	void OnDelSession(Session::ID sid);
public:
	static LaohuInformServer *GetInstance() { return &instance; }
	std::string Identification() const { return "LaohuInformServer"; }
	void SetAccumulate(size_t size) { accumulate_limit = size; }
	LaohuInformServer() : accumulate_limit(0) { }
};

};
#endif
