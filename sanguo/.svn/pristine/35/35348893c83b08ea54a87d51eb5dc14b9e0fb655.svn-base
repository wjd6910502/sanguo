
#include "registerserver.hpp"
#include "state.hxx"
#include <iostream>
namespace GNET
{

RegisterServer RegisterServer::instance;

const Protocol::Manager::Session::State* RegisterServer::GetInitState() const
{
	return &state_RegisterServer;
}

void RegisterServer::OnAddSession(Session::ID sid)
{
	std::cout<<"onaddssion<<<<<<<<<<<"<<std::endl;
}

void RegisterServer::OnDelSession(Session::ID sid)
{
}

};
