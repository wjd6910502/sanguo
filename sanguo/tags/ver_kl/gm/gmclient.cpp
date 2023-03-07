
#include "gmclient.hpp"
#include "state.hxx"
#include "conf.h"
#include "parsestring.h"
#include "centercommand.hpp"

using namespace std;

namespace GNET
{

GMClient GMClient::instance;

const Protocol::Manager::Session::State* GMClient::GetInitState() const
{
	return &state_GMClient;
}

void GMClient::OnAddSession(Session::ID sid)
{
	Thread::Mutex::Scoped l(locker_state);
	if (conn_state)
	{
		Close(sid);
		return;
	}
	conn_state = true;
	this->sid = sid;
	
	Conf *conf = Conf::GetInstance(game_sys_file.c_str());
	{
		std::vector<std::string> zone_list;
		std::vector<std::string> link_list;
		std::vector<std::string> gs_list;

		std::vector<int> zone_list_int;
		std::vector<int> link_list_int;
		std::vector<int> gs_list_int;
       
		if( !ParseStrings( conf->find( GMClient::GetInstance()->Identification(), "zone_list" ), zone_list) )
		{
			cout << "zone_list Error" << endl;
			return;
		}
		else
		{
			std::vector<std::string>::iterator it = zone_list.begin();
			for (; it != zone_list.end(); ++it)
				zone_list_int.push_back(atoi(it->c_str()));
		}

		if( !ParseStrings( conf->find( GMClient::GetInstance()->Identification(), "link_list" ), link_list) )
		{
			cout << "link_list Error" << endl;
			return;
		}
		else
		{
			std::vector<std::string>::iterator it = link_list.begin();
			for (; it != link_list.end(); ++it)
				link_list_int.push_back(atoi(it->c_str()));
		}
		
		if( !ParseStrings( conf->find( GMClient::GetInstance()->Identification(), "gs_list" ), gs_list) )
		{
			cout << "gs_list Error" << endl;
			return;
		}
		else
		{
			std::vector<std::string>::iterator it = gs_list.begin();
			for (; it != gs_list.end(); ++it)
				gs_list_int.push_back(atoi(it->c_str()));
		}

		CenterCommand command;
		command.zone_list = zone_list_int;
		command.link_list = link_list_int;
		command.gs_list = gs_list_int;
		command.cmd = cmd;
		command.arg1 = Octets(arg[0].c_str(), arg[0].size()+1);
		command.arg2 = Octets(arg[1].c_str(), arg[1].size()+1);
		command.arg3 = Octets(arg[2].c_str(), arg[2].size()+1);
		command.arg4 = Octets(arg[3].c_str(), arg[3].size()+1);
		command.arg5 = Octets(arg[4].c_str(), arg[4].size()+1);
		command.arg6 = Octets(arg[5].c_str(), arg[5].size()+1);

		if( GMClient::GetInstance()->SendProtocol(&command) )
		{
		}
		else
		{
			cout << "send error" << endl;
		}

	}
}

void GMClient::OnDelSession(Session::ID sid)
{
	Thread::Mutex::Scoped l(locker_state);
	conn_state = false;
}

void GMClient::OnAbortSession(const SockAddr &sa)
{
	Thread::Mutex::Scoped l(locker_state);
	conn_state = false;
}

void GMClient::OnCheckAddress(SockAddr &sa) const
{
}

};
