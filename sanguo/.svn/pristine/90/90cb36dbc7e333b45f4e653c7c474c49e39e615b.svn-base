#ifndef __GNET_GMADAPTERSERVER_HPP
#define __GNET_GMADAPTERSERVER_HPP

#include "protocol.h"

namespace GNET
{

class GMAdapterServer : public Protocol::Manager
{
	static GMAdapterServer instance;
	size_t accumulate_limit;
	const Session::State *GetInitState() const;
	bool OnCheckAccumulate(size_t size) const { return accumulate_limit == 0 || size < accumulate_limit; }
	void OnAddSession(Session::ID sid);
	void OnDelSession(Session::ID sid);
public:
	static GMAdapterServer *GetInstance() { return &instance; }
	std::string Identification() const { return "GMAdapterServer"; }
	void SetAccumulate(size_t size) { accumulate_limit = size; }
	GMAdapterServer() : accumulate_limit(0) { }

	void ConvertToUtf8(std::string &in);
};

};
#endif
