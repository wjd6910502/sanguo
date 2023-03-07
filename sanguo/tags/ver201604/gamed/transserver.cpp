
#include "transserver.hpp"
#include "state.hxx"

#include "transchallenge.hpp"
#include "commonmacro.h"
//#include "thread.h"
#include "glog.h"

namespace GNET
{

TransServer TransServer::instance;

const Protocol::Manager::Session::State* TransServer::GetInitState() const
{
	return &state_TransServer;
}

//class DelayTask: public Thread::Runnable
//{
//	int _sid;
//public:
//	DelayTask(int priority, int sid): Runnable(priority), _sid(sid) {}
//	void Run()
//	{
//		TransServer::GetInstance()->Close(_sid);
//		delete this;
//	}
//};

void TransServer::OnAddSession(Session::ID sid)
{
	GLog::log(LOG_INFO, "TransServer::OnAddSession, sid=%u, thread=%u", sid, (unsigned int)pthread_self());
	
	SessionInfo session;
	//_server_rand2
	Security *random = Security::Create(RANDOM);
	random->Update(session._server_rand2.resize(CONN_CONST_RAND2_SIZE));
	random->Destroy();

	TransChallenge prot;
	prot.server_rand2 = session._server_rand2;
	Send(sid, prot);
	
	Thread::Mutex::Scoped keeper(_session_map_lock);
	_session_map[sid] = session;
	
	//fprintf(stderr, "TransServer::OnAddSession, sid=%u, _server_rand2=%s\n", sid, B16EncodeOctets(session._server_rand2).c_str());
	//GNET::Thread::HouseKeeper::AddTimerTask(new DelayTask(1, sid), 5);
}

void TransServer::OnDelSession(Session::ID sid)
{
	GLog::log(LOG_INFO, "TransServer::OnDelSession, sid=%u, thread=%u", sid, (unsigned int)pthread_self());

	Thread::Mutex::Scoped keeper(_session_map_lock);
	_session_map.erase(sid);
}

bool TransServer::FindSession(Session::ID sid, Octets& server_rand2)
{
	Thread::Mutex::Scoped keeper(_session_map_lock);

	auto it = _session_map.find(sid);
	if(it == _session_map.end()) return false;
	server_rand2 = it->second._server_rand2;
	return true;
}

};
