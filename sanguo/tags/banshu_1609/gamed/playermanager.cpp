#include <set>
#include "playermanager.h"
#include "gameprotocol.hpp"
#include "udpgameprotocol.hpp"
//#include "udps2cgameprotocols.hpp"
#include "transserver.hpp"
#include "udptransserver.hpp"
#include "script_wrapper.h"
#include "message.h"
#include "glog.h"
#include "pvpmanager.h"
#include "statistic_manager.h"
//#include "syncnetime.hpp"
#include "kickout.hpp"
//#include "udpsyncnettime.hpp"
#include "syncnetime.hpp"
#include "gamedbclient.hpp"
#include "pvpjoin.hrp"
#include "pvpenter.hpp"
#include "pvpleave.hpp"
#include "gcenterclient.hpp"
#include "pvpready.hpp"
#include "pvpcancle.hrp"
#include "pvpspeed.hpp"
#include "uniquenameclient.hpp"
#include "createrolename.hrp"
#include "createmafianame.hrp"
#include "changemafianame.hrp"
#include "pvpreset.hpp"
#include "getpvpvideo.hpp"
#include "delpvpvideo.hpp"
#include "NoLoadPlayer.h"
#include "matcher.h"
#include "gettextinspeech.hrp"
#include "sttclient.hpp"
#include "base64.h"
#include "audiencegetlist.hpp"
#include "audiencegetoperation.hpp"
#include "audienceleaveroom.hpp"

extern std::map<Octets, Octets> g_save_data_map;
extern __thread int64_t g_transaction_id;

namespace CACHE
{

unsigned int PlayerManager::_role_id_stub = (SERVER_CONST_ROLE_ID_BEGIN-1); //前面的role_id预留，给角色模板之类
unsigned int PlayerManager::_mafia_id_stub = 0;
Thread::Mutex PlayerManager::_role_id_stub_lock;
Thread::Mutex PlayerManager::_mafia_id_stub_lock;

bool Role::IsActiveRole() const
{
	return ((GNET::Timer::GetTime() - _last_active_time) < 60);
}

void Role::SendToClient(const std::string& v)
{
	_player->SendToClient(v);
}

void Role::SendUDPToClient(const std::string& v)
{
	_player->SendUDPToClient(v);
}

void Role::SendPVPJoin(int score)
{
	_player->SendPVPJoin(score);
}

void Role::SendPVPEnter(int flag)
{
	_player->SendPVPEnter(flag);
}

void Role::SendPVPReady()
{
	_player->SendPVPReady();
}

void Role::SendPVPLeave(int reason, int typ)
{
	_player->SendPVPLeave(reason, typ);
}

void Role::SendPVPCancle()
{
	_player->SendPVPCancle();
}

void Role::SendPVPSpeed(int speed)
{
	_player->SendPVPSpeed(speed);
}

void Role::SendPVPReset()
{
	_player->SendPVPReset();
}

void Role::GetPVPVideo(const std::string& v)
{
	_player->GetPVPVideo(v);
}

void Role::DelPVPVideo(const std::string& v)
{
	_player->DelPVPVideo(v);
}

void Role::SendSpeechToSTT(std::string dest_id, int chat_type, std::string speech)
{		
	_player->SendSpeechToSTT(dest_id, chat_type, speech);
}

void Role::AudienceGetAllList()
{
	_player->AudienceGetAllList();
}

void Role::AudienceGetRoomInfo(int room_id)
{
	_player->AudienceGetRoomInfo(room_id);
}

void Role::AudienceLeave(int room_id)
{
	_player->AudienceLeave(room_id);
}

void NetworkTime::Reset()
{ 
	_id++;
	_delay = 0; 
	_offset = 0; 
	_cnt = 10;
}

void NetworkTime::EstimateNTP(int id, int64_t delay, int64_t offset)
{
	if(id != _id) return;

	/*
	 时间估算算法
	 EstmatisedRTT = (1-x)*EstimatedRTT + x*SampleRTT
	*/
	if(_delay == 0) _delay = delay;
	if(_offset == 0) _offset = offset;
		
	_delay = (1-0.125)*_delay + 0.125*delay;
	if(_delay<=0) _delay=1;
	_offset = (1-0.125)*_offset + 0.125*offset;

	if(_cnt > 0)
	{
		Send();
		_cnt--;
	}
	else
	{
		GLog::log(LOG_INFO, "NetworkTime::EstimatedRTT, delay=%ld, offset=%ld", delay, offset);
	}
}

void NetworkTime::Sync2Client()
{
	Reset();
	Send();
	_cnt--;
}

void NetworkTime::Send()
{
	timeval ori;
	gettimeofday(&ori,NULL); //TODO: 替换掉
		
	//UDPSyncNetTime prot;
	SyncNetime prot;
	prot.id = _id;
	prot.orignate_time = ori.tv_sec*1000000 + ori.tv_usec;
	prot.offset = _offset;
	prot.delay = _delay;

	//_player->SendUDPProtocol(prot);
	_player->SendProtocol(prot);
}

bool Player::NeedDoReset(const Octets& device_id, int client_received_count) const
{
	//客户端设备换了
	if(device_id.size()==0 || device_id!=_last_device_id) return true;
	//历史不足以满足重传
	if(client_received_count+1 < _first_game_protocol_id) return true;
	//客户端收到的比服务器发过的还多，服务器重启了???
	if((unsigned int)client_received_count > _first_game_protocol_id+_game_protocol_history.size()-1) return true;

	return false;
}

void Player::OnContinue(bool reset)
{
	//fprintf(stderr, "Player::OnContinue, account=%s, reset=%d\n", B16EncodeOctets(_account).c_str(), reset);

	_can_send_game_protocol = true;

	if(reset)
	{
		_client_received_game_protocol_count = 0;
		atomic_set(&_server_received_game_protocol_count, 0);
		_first_game_protocol_id = 1;
		_game_protocol_history.clear();
		return;
	}

	//触发重传
	if((unsigned int)_client_received_game_protocol_count < _first_game_protocol_id+_game_protocol_history.size()-1)
	{
		timeval tv;
		gettimeofday(&tv,NULL);
		int64_t now_micro = tv.tv_sec*1000000+tv.tv_usec;

		auto it = _game_protocol_history.begin();
		auto i = 0;
		for(; it!=_game_protocol_history.end(); ++it, ++i)
		{
			if(_client_received_game_protocol_count < _first_game_protocol_id+i)
			{
				GameProtocol prot;
				prot.data = *it;
				prot.client_send_time = _prev_client_send_time_4_tcp + (now_micro-_prev_client_send_time_4_tcp_local_time)/1000;
				prot.server_send_time = (now_micro/1000)&0xffff;
				prot.reserved1 = 0;
				prot.reserved2 = 0;
				TransServer::GetInstance()->Send(_trans_sid, prot);
			}
		}
	}
}

void Player::UpdateUDPInfo(int net_type, const Octets& public_ip, unsigned short public_port, const Octets& local_ip, unsigned short local_port)
{
	_role._roledata._device_info._net_type = net_type;
	_role._roledata._device_info._public_ip = std::string((char*)public_ip.begin(), public_ip.size());
	_role._roledata._device_info._public_port = public_port;
	_role._roledata._device_info._local_ip = std::string((char*)local_ip.begin(), local_ip.size());
	_role._roledata._device_info._local_port = local_port;
}

void Player::SendGameProtocol(const Octets& data)
{
	timeval tv;
	gettimeofday(&tv,NULL);
	int64_t now_micro = tv.tv_sec*1000000+tv.tv_usec;

	GameProtocol prot;
	prot.data = data;
	prot.client_send_time = _prev_client_send_time_4_tcp + (now_micro-_prev_client_send_time_4_tcp_local_time)/1000;
	prot.server_send_time = (now_micro/1000)&0xffff;
	prot.reserved1 = 0;
	prot.reserved2 = 0;

	if(_can_send_game_protocol) TransServer::GetInstance()->Send(_trans_sid, prot);

	AddHistory(data);
}

void Player::SendUDPGameProtocol(const Octets& data)
{
	UDPGameProtocol prot;
	prot.id = (int64_t)_role._roledata._base._id;
	prot.data = data;

	Octets tmp;
	tmp.push_back(&prot.id, sizeof(prot.id));
	tmp.push_back(data.begin(), data.size());
	prot.signature = UDPSignature(tmp, _key1);

	prot.reserved1 = 0;
	prot.reserved2 = 0;

	UDPTransServer::GetInstance()->Send(_udp_trans_sid, prot);
}

void Player::OnTimer1s(time_t now)
{
	if((int64_t)_role._roledata._base._id == 0) return; //没创建角色前别心跳了
	if(!_role.IsActiveRole())
	{
		if(_role._roledata._status._online == 1)
		{
			char msg[100];
			snprintf(msg, sizeof(msg), "31:");
			MessageManager::GetInstance().Put(_role._roledata._base._id, _role._roledata._base._id, msg, 0);
		}
		return;
	}

	//NetTime_SyncServer2Client(); //同步服务器时间

	char msg[100];
	snprintf(msg, sizeof(msg), "10002:%lu:", now);
	MessageManager::GetInstance().Put(_role._roledata._base._id, _role._roledata._base._id, msg, 0);
}

void Player::Log(const char *v) const
{
	GLog::log(LOG_INFO, "===LUA LOG(%s, %.*s, %lu)===: thread=%u, %s", B16EncodeOctets(GetAccount()).c_str(), (int)GetAccount().size(),
			(char*)GetAccount().begin(), (int64_t)_role._roledata._base._id, (unsigned int)pthread_self(), v);
}

void Player::Err(const char *v) const
{
	fprintf(stderr, "\033[31m!!!LUA ERR(%s, %.*s, %lu)!!!: thread=%u, %s\033[0m\n", B16EncodeOctets(GetAccount()).c_str(), (int)GetAccount().size(),
	        (char*)GetAccount().begin(), (int64_t)_role._roledata._base._id, (unsigned int)pthread_self(), v);
	GLog::log(LOG_ERR, "!!!LUA ERR(%s, %.*s, %lu)!!!: thread=%u, %s", B16EncodeOctets(GetAccount()).c_str(), (int)GetAccount().size(),
	          (char*)GetAccount().begin(), (int64_t)_role._roledata._base._id, (unsigned int)pthread_self(), v);
}

void Player::SendToClient(const std::string& v)
{
	Octets data(v.c_str(), v.size());
	if(_in_transaction)
	{
		_transaction_game_protocols.push_back(data);
		return;
	}
	SendGameProtocol(data);
}

void Player::SendUDPToClient(const std::string& v)
{
	Octets data(v.c_str(), v.size());
	if(_in_transaction)
	{
		_transaction_udp_game_protocols.push_back(data);
		return;
	}
	SendUDPGameProtocol(data);
}

void Player::SendProtocol(Protocol& prot)
{
	TransServer::GetInstance()->Send(_trans_sid, prot);
}

void Player::SendUDPProtocol(Protocol& prot)
{
	UDPTransServer::GetInstance()->Send(_udp_trans_sid, prot);
}

void Player::SendMessage(const Int64& target, const std::string& v, int delay)
{
	Int64List extra_roles;
	Int64List extra_mafias;
	IntList extra_pvps;
	SendMessage(target, v, delay, extra_roles, extra_mafias, extra_pvps);
}

void Player::SendMessage(const Int64& target, const std::string& v, int delay, const Int64List& extra_roles, const Int64List& extra_mafias, const IntList& extra_pvps)
{
	//if((int64_t)target <= 0) return;

	std::vector<int64_t> vec;
	{
	const Int64List& er = extra_roles;
	auto it = er.SeekToBegin();
	auto id = it.GetValue();
	while(id)
	{
		vec.push_back(*id);
		it.Next();
		id = it.GetValue();
	}
	}
	std::vector<int64_t> vec2;
	{
	const Int64List& er = extra_mafias;
	auto it = er.SeekToBegin();
	auto id = it.GetValue();
	while(id)
	{
		vec2.push_back(*id);
		it.Next();
		id = it.GetValue();
	}
	}
	std::vector<int> vec3;
	{
	const IntList& er = extra_pvps;
	auto it = er.SeekToBegin();
	auto id = it.GetValue();
	while(id)
	{
		vec3.push_back(id->_value);
		it.Next();
		id = it.GetValue();
	}
	}
	Message msg(target, _role._roledata._base._id, v, delay, &vec, &vec2, &vec3);
	if(_in_transaction)
	{
		_transaction_messages.push_back(msg);
		return;
	}
	MessageManager::GetInstance().Put(msg);
}

void Player::SendMessageToAllRole(const std::string& v, int delay)
{
	SendMessage(SERVER_CONST_MESSAGE_TARGET_ACTIVE_ROLES, v, delay);
}

void Player::SendMessageToAllRole(const std::string& v, int delay, const Int64List& extra_roles, const Int64List& extra_mafias, const IntList& extra_pvps)
{
	SendMessage(SERVER_CONST_MESSAGE_TARGET_ACTIVE_ROLES, v, delay, extra_roles, extra_mafias, extra_pvps);
}

void Player::KickoutSelf(int reason)
{
	unsigned int old_sid = GetTransSid();
	Kickout prot;
	prot.reason = reason;
	TransServer::GetInstance()->Send(old_sid, prot);
	//TransServer::GetInstance()->Close(old_sid, CLOSE_ACTIVE, 1);
	TransServer::GetInstance()->Close(old_sid);
}

bool Player::IsValidRolename(const std::string& role_name)
{
	//把空格去掉
	size_t offset = role_name.find_first_of("\r\n\t\\");
	if(offset!=std::string::npos)
		return false;
	
	return Matcher::GetInstance()->Match((char*)role_name.c_str(),role_name.length())!=0;  
}

void Player::AllocRoleName(const char *name, int create_time, const char *errorinfo)
{
	if(!_in_transaction) return;

	class TF: public TransactionFunctionBase
	{
		CreateRoleNameArg *_arg;
		int _create_time;
	
	public:
		TF(CreateRoleNameArg *arg, int create_time): _arg(arg), _create_time(create_time) {}
	
		virtual void OnCancel()
		{
			delete _arg;
		}
		virtual void OnCommit()
		{
			CreateRoleName *rpc = (CreateRoleName*)Rpc::Call(RPC_CREATEROLENAME, _arg);
			rpc->_create_time = _create_time;
			UniqueNameClient::GetInstance()->SendProtocol(rpc);
			delete _arg;
		}
	};

	std::string tmp = name;
	
	CreateRoleNameArg *arg = new CreateRoleNameArg();
	arg->name = Octets((void*)tmp.c_str(), tmp.size());
	//arg.photo = photo;
	arg->account = _account;
	arg->errorinfo = Octets((void*)errorinfo, strlen(errorinfo));
		
	_transaction_functions.push_back(new TF(arg, create_time));
}

bool Player::OnAllocRoleName(Octets name, int create_time)
{
	if(_role._roledata._base._id != 0) return false;

	//可能已经失效
	if(_role._roledata._base._name != std::string((char*)name.begin(), name.size())) return false;
	if(_role._roledata._base._create_time != create_time) return false;

	_role._roledata._base._id = PlayerManager::GetInstance().AllocRoleId();

	std::vector<int64_t> extra_roles;
	for(int i=SERVER_CONST_SYSTEM_PLAYER_ROLE_ID_BEGIN; i<SERVER_CONST_SYSTEM_PLAYER_ROLE_ID_BEGIN+SERVER_CONST_SYSTEM_PLAYER_COUNT; i++)
	{
		extra_roles.push_back(i);
	}
	MessageManager::GetInstance().Put(_role._roledata._base._id, _role._roledata._base._id, "10001:0:", 0, &extra_roles); //CreateRoleResult

	return true;
}

bool Player::IsValidMafianame(const std::string& mafia_name)
{
	//把空格去掉
	size_t offset = mafia_name.find_first_of("\r\n\t\\");
	if(offset!=std::string::npos)
		return false;
	
	return Matcher::GetInstance()->Match((char*)mafia_name.c_str(),mafia_name.length())!=0;  
}

void Player::AllocMafiaName(const char *name, int create_time)
{
	if(!_in_transaction) return;

	class TF: public TransactionFunctionBase
	{
		CreateMafiaNameArg *_arg;
		int _create_time;
	
	public:
		TF(CreateMafiaNameArg *arg, int create_time): _arg(arg), _create_time(create_time) {}
	
		virtual void OnCancel()
		{
			delete _arg;
		}
		virtual void OnCommit()
		{
			CreateMafiaName *rpc = (CreateMafiaName*)Rpc::Call(RPC_CREATEMAFIANAME, _arg);
			rpc->_create_time = _create_time;
			UniqueNameClient::GetInstance()->SendProtocol(rpc);
			delete _arg;
		}
	};

	std::string tmp = name;
	
	CreateMafiaNameArg *arg = new CreateMafiaNameArg();
	arg->account = _account;
	arg->name = Octets((void*)tmp.c_str(), tmp.size());
	arg->roleid = _role._roledata._base._id;
		
	_transaction_functions.push_back(new TF(arg, create_time));
}

void Player::AllocMafiaChangeName(const char *name)
{
	if(!_in_transaction) return;

	class TF: public TransactionFunctionBase
	{
		ChangeMafiaNameArg *_arg;
	
	public:
		TF(ChangeMafiaNameArg *arg): _arg(arg) {}
	
		virtual void OnCancel()
		{
			delete _arg;
		}
		virtual void OnCommit()
		{
			ChangeMafiaName *rpc = (ChangeMafiaName*)Rpc::Call(RPC_CHANGEMAFIANAME, _arg);
			UniqueNameClient::GetInstance()->SendProtocol(rpc);
			delete _arg;
		}
	};

	std::string tmp = name;
	
	ChangeMafiaNameArg *arg = new ChangeMafiaNameArg();
	arg->account = _account;
	arg->name = Octets((void*)tmp.c_str(), tmp.size());
	arg->roleid = _role._roledata._base._id;
		
	_transaction_functions.push_back(new TF(arg));
}

void Player::restore(int transaction_id)
{
	if(transaction_id == _transaction_id)
	{
		auto it = _transaction_data.end();
		it = _transaction_data.find("_role");
		if(it != _transaction_data.end())
		{
			OctetsStream os(it->second);
			os._for_transaction = true;
			os >> _role;
			_role.cleanup();
		}
		else
		{
			_role.restore(transaction_id);
		}
	}
	else
	{
		_role.restore(transaction_id);
	}

	_transaction_id = 0;
	_transaction_data.clear();
}

void Player::cleanup()
{
	_transaction_id = 0;
	_transaction_data.clear();

	_role.cleanup();
}

void Player::BeginTransaction()
{
	if(_in_transaction) return;
	_in_transaction = true;

	_transaction_id = 0;
	_transaction_data.clear();

	_transaction_game_protocols.clear();
	_transaction_udp_game_protocols.clear();
	_transaction_messages.clear();
	_transaction_functions.clear();
}

void Player::CommitTransaction()
{
	if(!_in_transaction) return;
	_in_transaction = false;

	for(auto it=_transaction_game_protocols.begin(); it!=_transaction_game_protocols.end(); ++it)
	{
		SendGameProtocol(*it);
	}
	_transaction_game_protocols.clear();

	for(auto it=_transaction_udp_game_protocols.begin(); it!=_transaction_udp_game_protocols.end(); ++it)
	{
		SendUDPGameProtocol(*it);
	}
	_transaction_udp_game_protocols.clear();

	for(auto it=_transaction_messages.begin(); it!=_transaction_messages.end(); ++it)
	{
		MessageManager::GetInstance().Put(*it);
	}
	_transaction_messages.clear();

	for(auto it=_transaction_functions.begin(); it!=_transaction_functions.end(); ++it)
	{
		TransactionFunctionBase *tf = *it;
		tf->OnCommit();
		delete tf;
	}
	_transaction_functions.clear();
}

void Player::CancelTransaction()
{
	if(!_in_transaction) return;
	_in_transaction = false;

	restore(g_transaction_id);

	_transaction_game_protocols.clear();
	_transaction_udp_game_protocols.clear();
	_transaction_messages.clear();

	for(auto it=_transaction_functions.begin(); it!=_transaction_functions.end(); ++it)
	{
		TransactionFunctionBase *tf = *it;
		tf->OnCancel();
		delete tf;
	}
	_transaction_functions.clear();
}

void Player::AddHistory(const Octets& data)
{
	_game_protocol_history.push_back(data);
	if(_game_protocol_history.size() > CONN_CONST_SERVER_SEND_HISTORY_MAX)
	{
		_first_game_protocol_id++;
		_game_protocol_history.pop_front();
	}
}


void RoleIter::Next()
{
	if(_saved_tag != _map->Tag()) return;
	if(_it != _map->End()) _it++;
}

void RoleIter::Prev()
{
	if(_saved_tag != _map->Tag()) return;
	if(_it == _map->End()) return;
	if(_it == _map->Begin()) 
	{
		_it = _map->End();
		return;
	}
	--_it;
}

Role* RoleIter::GetValue()
{
	if(_saved_tag != _map->Tag()) return 0;
	if(_it == _map->End()) return 0;
	return _it->second;
}

void PlayerManager::OnTimer(int tick, time_t now)
{
	Thread::Mutex::Scoped keeper(_lock);

	//统计活跃玩家
	int prev_min = _cur_min;
	_cur_min = now/60;
	if(prev_min != _cur_min)
	{
		//新的分钟开始了
		_active_players_history[_cur_min%SERVER_CONST_ACTIVE_PLAYERS_HISTORY_MAX].clear();
		_active_players.clear();
		for(int i=_cur_min-10; i<_cur_min; i++)
		{
			int idx = i%SERVER_CONST_ACTIVE_PLAYERS_HISTORY_MAX;
			_active_players.insert(_active_players_history[idx].begin(), _active_players_history[idx].end());
		}
	}

	for(auto it=_map.begin(); it!=_map.end(); ++it)
	{
		Player *player = it->second;
		if(tick%SERVER_CONST_TICK_PER_SECOND == player->GetHash_NOLOCK()%SERVER_CONST_TICK_PER_SECOND)
		{
			player->OnTimer1s(now);
		}
	}
}

int64_t PlayerManager::AllocRoleId()
{
	Thread::Mutex::Scoped keeper(_role_id_stub_lock);
	return ++_role_id_stub;
}

int64_t PlayerManager::AllocMafiaId()
{
	Thread::Mutex::Scoped keeper(_mafia_id_stub_lock);
	return ++_mafia_id_stub;
}

Player* PlayerManager::FindByAccount(const Octets& account)
{
	Thread::Mutex::Scoped keeper(_lock);

	auto it = _map.find(account);
	if(it == _map.end()) return 0;
	return it->second;
}

const Player* PlayerManager::FindByAccount(const Octets& account) const
{
	Thread::Mutex::Scoped keeper(_lock);

	auto it = _map.find(account);
	if(it == _map.end()) return 0;
	return it->second;
}

Player* PlayerManager::FindByTransToken(const Octets& trans_token, bool active)
{
	Thread::Mutex::Scoped keeper(_lock);

	auto it = _map_by_trans_token.find(trans_token);
	if(it == _map_by_trans_token.end()) return 0;
	Player *player = it->second;
	if(active)
	{
		_active_players_history[_cur_min%SERVER_CONST_ACTIVE_PLAYERS_HISTORY_MAX].insert(player);
		_active_players.insert(player);
	}
	return player;
}

const Player* PlayerManager::FindByTransToken(const Octets& trans_token) const
{
	Thread::Mutex::Scoped keeper(_lock);

	auto it = _map_by_trans_token.find(trans_token);
	if(it == _map_by_trans_token.end()) return 0;
	return it->second;
}

Player* PlayerManager::FindByTransSid(unsigned int sid, bool active)
{
	Thread::Mutex::Scoped keeper(_lock);

	auto it = _map_by_trans_sid.find(sid);
	if(it == _map_by_trans_sid.end()) return 0;
	Player *player = it->second;
	if(active)
	{
		_active_players_history[_cur_min%SERVER_CONST_ACTIVE_PLAYERS_HISTORY_MAX].insert(player);
		_active_players.insert(player);
	}
	return player;
}

const Player* PlayerManager::FindByTransSid(unsigned int sid) const
{
	Thread::Mutex::Scoped keeper(_lock);

	auto it = _map_by_trans_sid.find(sid);
	if(it == _map_by_trans_sid.end()) return 0;
	return it->second;
}

Player* PlayerManager::FindByRoleId(int64_t id)
{
	Thread::Mutex::Scoped keeper(_lock);

	auto it = _map_by_role_id.find(id);
	if(it == _map_by_role_id.end()) return 0;
	Role *role = it->second;
	return role->_player;
}

const Player* PlayerManager::FindByRoleId(int64_t id) const
{
	Thread::Mutex::Scoped keeper(_lock);

	auto it = _map_by_role_id.find(id);
	if(it == _map_by_role_id.end()) return 0;
	const Role *role = it->second;
	return role->_player;
}

void PlayerManager::OnConnect(const Octets& account, const Octets& trans_token, const Octets& key1)
{
	Thread::Mutex::Scoped keeper(_lock);

	Player *player = 0;
	auto it = _map.find(account);
	if(it != _map.end()) player = it->second;
	if(!player)
	{
		player = new Player(account);
		if(!player) return;
		_map[account] = player;
		//TODO: 可能需要从db获取player/role数据
	}

	Thread::Mutex::Scoped keeper2(player->_lock);

	if(trans_token.size() > 0)
	{
		_map_by_trans_token.erase(player->GetTransToken());

		player->SetTransToken(trans_token);
		_map_by_trans_token[trans_token] = player;
	}
	player->SetKey1(key1);

	//fprintf(stderr, "PlayerManager::OnConnect, account=%s, trans_token=%s, key1=%s\n",
	//        B16EncodeOctets(account).c_str(), B16EncodeOctets(trans_token).c_str(), B16EncodeOctets(key1).c_str());
	player->NetTime_Reset();
}

void PlayerManager::OnTransConnect(Player *player, const Octets& device_id, int client_received_game_protocol_count, unsigned int sid)
{
	Thread::Mutex::Scoped keeper(_lock);
	Thread::Mutex::Scoped keeper2(player->_lock);

	unsigned int old_sid = player->GetTransSid();
	_map_by_trans_sid.erase(old_sid);
	Kickout prot;
	prot.reason = KICKOUT_REASON_MULTI_LOGIN;
	TransServer::GetInstance()->Send(old_sid, prot);
	//TransServer::GetInstance()->Close(old_sid, CLOSE_ACTIVE, 1);
	TransServer::GetInstance()->Close(old_sid);

	player->SetCanSendGameProtocol(false);
	player->SetLastDeviceId(device_id);
	player->SetClientReceivedGameProtocolCount(client_received_game_protocol_count);
	player->SetTransSid(sid);
	_map_by_trans_sid[sid] = player;

	player->ResetLatency();
	player->UpdateUDPInfo(0, Octets(), 0, Octets(), 0);

	//fprintf(stderr, "PlayerManager::OnTransConnect, account=%s, device_id=%s, client_received_game_protocol_count=%d, sid=%u\n",
	//        B16EncodeOctets(player->GetAccount()).c_str(), B16EncodeOctets(device_id).c_str(), client_received_game_protocol_count, sid);
}

void PlayerManager::OnDisconnect(const Octets& account)
{
	Player *player = FindByAccount(account);
	if(player)
	{
		Thread::Mutex::Scoped keeper2(player->_lock);
		player->SetDisconnect();
	}
}

void PlayerManager::GetActiveRoles(std::vector<int64_t>& roles) const
{
	Thread::Mutex::Scoped keeper(_lock);

	roles.reserve(_active_players.size());
	for(auto it=_active_players.begin(); it!=_active_players.end(); ++it)
	{
		const Player *player = *it;
		if((int64_t)player->_role._roledata._base._id==0) continue;
		roles.push_back(player->_role._roledata._base._id);
	}
}

Role* PlayerManager::Find(const Int64& k)
{
	//这里不需要lock, 因为单线程化
	auto it = _map_by_role_id.find(k);
	if(it == _map_by_role_id.end()) return 0;
	return it->second;
}

void PlayerManager::Load(Octets &key, Octets &value)
{
	std::string str_key  = std::string((char*)key.begin(),key.size());
	std::string account = "";
	const char *p = str_key.c_str();
	const char *q = strrchr(p, '_');
	if(q)
	{
		std::string s(q+1, p+str_key.size());
		account = s;
	}

	Player *tmp = new Player(Octets(account.c_str(),account.size()));

	Marshal::OctetsStream os(value);
	int db_version = 0;
	os >> db_version;
	int last_active_time = 0;
	os >> last_active_time;
	os._dbversion = db_version;
	tmp->unmarshal(os);
	//if( (GNET::Timer::GetTime() - last_active_time) > 15*24*60*60 )
	if( (GNET::Timer::GetTime() - last_active_time) < 3600*24 || (int64_t)tmp->_role._roledata._base._id < SERVER_CONST_ROLE_ID_BEGIN)
	//if( (GNET::Timer::GetTime() - last_active_time) < 10 || (int64_t)tmp->_role._roledata._base._id < SERVER_CONST_ROLE_ID_BEGIN)
	{
		tmp->UpdateActiveTime(last_active_time);
		_map[Octets(account.c_str(),account.size())] = tmp;

		if((int64_t)tmp->_role._roledata._base._id != 0)
		{
			_map_by_role_id[tmp->_role._roledata._base._id] = &tmp->_role;
		}
	}
	else
	{
		SGT_NoLoadPlayer::GetInstance().InsertData(account, tmp->_role._roledata._base._id);
		delete tmp;
	}
}

void PlayerManager::LoadPlayerInfo(Octets &key, Octets &value)
{
	Marshal::OctetsStream os(value);
	int db_version = 0;
	os >> db_version;
	os >> _role_id_stub;
	os >> _mafia_id_stub;
}

void PlayerManager::LoadRoleInfo(Octets &key, Octets &value)
{
	Thread::Mutex::Scoped keeper(_lock);
	std::string str_key  = std::string((char*)key.begin(),key.size());
	std::string account = "";
	const char *p = str_key.c_str();
	const char *q = strrchr(p, '_');
	if(q)
	{
		std::string s(q+1, p+str_key.size());
		account = s;
	}

	std::map<Octets, Player*>::iterator it = _map.find(Octets(account.c_str(),account.size()));
	if(it != _map.end())
	{
		Player* tmp = it->second;
		Thread::Mutex::Scoped keeper2(tmp->_lock);

		Marshal::OctetsStream os(value);
		int db_version = 0;
		os >> db_version;
		int last_active_time = 0;
		os >> last_active_time;
		os._dbversion = db_version;
		
		tmp->unmarshal(os);
		tmp->UpdateActiveTime_NOLOCK();

		GLog::log(LOG_INFO, "LoadRoleInfo find , role_id=%ld", (int64_t) tmp->_role._roledata._base._id);
		if((int64_t) tmp->_role._roledata._base._id != 0)
		{
			//_map[Octets(account.c_str(),account.size())] = tmp;
			_map_by_role_id[tmp->_role._roledata._base._id] = &tmp->_role;
			char msg[100];
			snprintf(msg, sizeof(msg), "22:");
			MessageManager::GetInstance().Put(tmp->_role._roledata._base._id, tmp->_role._roledata._base._id, msg, 0);
		}
	}
	else
	{
		Player *tmp = new Player(Octets(account.c_str(),account.size()));
		Marshal::OctetsStream os(value);
		int db_version = 0;
		os >> db_version;
		int last_active_time = 0;
		os >> last_active_time;
		os._dbversion = db_version;
		
		tmp->unmarshal(os);
		tmp->UpdateActiveTime_NOLOCK();
		_map[Octets(account.c_str(),account.size())] = tmp;

		GLog::log(LOG_INFO, "LoadRoleInfo not find , role_id=%ld", (int64_t) tmp->_role._roledata._base._id);
		if((int64_t) tmp->_role._roledata._base._id != 0)
		{
			_map_by_role_id[tmp->_role._roledata._base._id] = &tmp->_role;
			char msg[100];
			snprintf(msg, sizeof(msg), "22:");
			MessageManager::GetInstance().Put(tmp->_role._roledata._base._id, tmp->_role._roledata._base._id, msg, 0);
		}
	}
}

void PlayerManager::Save()
{
	//TODO: 单线程模式检测?

	Player * tmp_player = NULL;
	std::map<Octets, Player*>::iterator it = _map.begin();
	GNET::Marshal::OctetsStream value;
	int db_version = DB_VERSION;
	
	for(; it != _map.end(); it++)
	{
		value.clear();
		std::string key_str = "roleinfo_";
		Octets key = it->first;
		key_str += std::string((char*)key.begin(),key.size());
		tmp_player = it->second;
		
		//先把version版本号放进去
		value << db_version;
		value << tmp_player->_role._last_active_time;
		tmp_player->marshal(value);
		g_save_data_map[Octets(key_str.c_str(), key_str.size())] = value;
	}
	//在这里再把现在有多少玩家的数据保存起来，否则会造成玩家的ID错误
	std::string key_str = "playermanagerinfo";
	value.clear();
	value << db_version;
	value << _role_id_stub;
	value << _mafia_id_stub;

	g_save_data_map[Octets(key_str.c_str(), key_str.size())] = value;

}

void Player::NetTime_Sync2Client()
{
	if(!_in_transaction) return;

	class TF: public TransactionFunctionBase
	{
		Player *_player;
	public:
		TF(Player *player): _player(player) {}
		virtual void OnCancel() {}
		virtual void OnCommit() { _player->_network_time.Sync2Client(); }
	};

	_transaction_functions.push_back(new TF(this));
}

void PlayerManager::OnAllocRoleName(Octets account, Octets name, int create_time)
{
	Player *player = FindByAccount(account);
	if(player)
	{
		Thread::Mutex::Scoped keeper2(player->_lock);
		if(player->OnAllocRoleName(name, create_time))
		{
			_map_by_role_id[player->_role._roledata._base._id] = &player->_role;
			OnChanged();
		}
	}
}

void Player::UpdateLatency(unsigned short client_send_time, unsigned short server_send_time)
{
	Thread::Mutex::Scoped keeper(_latency_lock);

	timeval tv;
	gettimeofday(&tv,NULL);

	_prev_client_send_time_4_tcp = client_send_time;
	_prev_client_send_time_4_tcp_local_time = tv.tv_sec*1000000+tv.tv_usec;

	unsigned int now_ms = (_prev_client_send_time_4_tcp_local_time/1000)&0xffff;
	if(now_ms < server_send_time)
	{
		now_ms += 0x10000;
	}
	_latency.AddSample(now_ms-server_send_time);
	//GLog::log(LOG_INFO, "UpdateLatency, _latency.Get()=%d\n", _latency.Get());
}

void Player::ResetLatency()
{
	Thread::Mutex::Scoped keeper(_latency_lock);
	_latency.Reset();
}

int Player::GetLatency()
{
	Thread::Mutex::Scoped keeper(_latency_lock);
	return _latency.Get();
}

bool PlayerManager::LoadSystemPlayersFromFile(const char *path)
{
	//TODO:
	return false;
}

bool PlayerManager::SaveSystemPlayersToFile(const char *path)
{
	//TODO:
	return false;
}

bool PlayerManager::InitSystemPlayers()
{
	const Player* p = FindByRoleId(SERVER_CONST_SYSTEM_PLAYER_ROLE_ID_BEGIN);
	if(p) return true;

	if(LoadSystemPlayersFromFile("")) return true;

	//init
	for(int64_t rid=SERVER_CONST_SYSTEM_PLAYER_ROLE_ID_BEGIN; rid<SERVER_CONST_SYSTEM_PLAYER_ROLE_ID_BEGIN+SERVER_CONST_SYSTEM_PLAYER_COUNT; rid++)
	{
		char account[100];
		sprintf(account, "SYS%ld", rid);
		Octets o(account, strlen(account));

		Player *player = new Player(o);
		if(!player) return false;
		_map[o] = player;

		Role *role = &player->_role;
		role->_roledata._base._id = rid; //仅仅初始化了id/name, 其他部分需要在lua代码里处理
		role->_roledata._base._name = account;
		_map_by_role_id[rid] = role;

		OnChanged();
	}
	return true;
}

void Latency::Reset()
{
	memset(_samples, 0, sizeof(_samples));
	_index = 0;
	_prev_add_sample_time = 0;
}

void Latency::AddSample(int latency_ms)
{
	//printf("Latency::AddSample, latency_ms=%d\n", latency_ms);
	if(latency_ms>65000) return;

	_samples[_index%N] = latency_ms;
	_index++;

	timeval tv;
	gettimeofday(&tv,NULL);
	_prev_add_sample_time = tv.tv_sec*1000000+tv.tv_usec;
}

int Latency::Get()
{
	if(_index < N) return 0x7fffffff;

	std::set<int> maxM;
	for(int i=0; i<_index && i<N; i++)
	{
		if(maxM.size() < M)
		{
			maxM.insert(_samples[i]);
		}
		else
		{
			if(_samples[i] > *maxM.begin())
			{
				maxM.erase(maxM.begin());
				maxM.insert(_samples[i]);
			}
		}
	}

	timeval tv;
	gettimeofday(&tv,NULL);
	int64_t now_micro = tv.tv_sec*1000000+tv.tv_usec;

	int64_t latency = (now_micro-_prev_add_sample_time-_sample_interval_max)/1000;
	if(!maxM.empty() && latency<*maxM.begin())
	{
		latency = *maxM.begin();
	}
	return latency;
}

void CommandStat::Reset()
{
	memset(_samples, 0, sizeof(_samples));
	_index = 0;
}

void CommandStat::AddSample()
{
	_samples[_index%N] = time(0);
	_index++;
}

bool CommandStat::IsTooFast() const
{
	if(_index < N) return false;

	return (_samples[(_index-1)%N]-_samples[_index%N]<T);
}

void Player::ResetCommandStat()
{
	Thread::Mutex::Scoped keeper(_command_stat_lock);
	_command_stat.Reset();
}

void Player::OnRecvCommand()
{
	Thread::Mutex::Scoped keeper(_command_stat_lock);
	_command_stat.AddSample();
}

bool Player::IsClientCmdSendTooFast() const
{
	Thread::Mutex::Scoped keeper(_command_stat_lock);
	return _command_stat.IsTooFast();
}

template<typename T>
class TF_ToCenterRpc: public TransactionFunctionBase
{
	int _rpc_type;
	T *_arg;

public:
	TF_ToCenterRpc(int rpc_type, T *arg): _rpc_type(rpc_type), _arg(arg) {}

	virtual void OnCancel()
	{
		delete _arg;
	}
	virtual void OnCommit()
	{
		Rpc *rpc = Rpc::Call(_rpc_type, _arg);
		GCenterClient::GetInstance()->SendProtocol(rpc);
		delete _arg;
	}
};
template<typename T> TF_ToCenterRpc<T>* CreateTF_ToCenterRpc(int rpc_type, T *arg) { return new TF_ToCenterRpc<T>(rpc_type, arg); }

void Player::SendPVPJoin(int score)
{
	if(!_in_transaction) return;

	PvpJoinArg *arg = new PvpJoinArg();
	arg->roleid = _role._roledata._base._id;
	arg->zoneid = g_zoneid;
	arg->pvpinfo = Octets((void*)_role._roledata._pvp._pvpcenterinfo.c_str(), _role._roledata._pvp._pvpcenterinfo.size());
	arg->score = score;
	arg->elo_score = _role._roledata._pvp_info._elo_score;
	arg->exe_version = Octets((void*)_role._roledata._client_ver._exe_ver.c_str(), _role._roledata._client_ver._exe_ver.size());
	arg->data_version = Octets((void*)_role._roledata._client_ver._data_ver.c_str(), _role._roledata._client_ver._data_ver.size());
	arg->key = GetKey1();

	_transaction_functions.push_back(CreateTF_ToCenterRpc(RPC_PVPJOIN, arg));
}

template<typename T>
class TF_ToCenterProtocol: public TransactionFunctionBase
{
	T *_prot;

public:
	TF_ToCenterProtocol(T *prot): _prot(prot) {}

	virtual void OnCancel()
	{
		delete _prot;
	}
	virtual void OnCommit()
	{
		GCenterClient::GetInstance()->SendProtocol(_prot);
		delete _prot;
	}
};
template<typename T> TF_ToCenterProtocol<T>* CreateTF_ToCenterProtocol(T *prot) { return new TF_ToCenterProtocol<T>(prot); }

void Player::SendPVPEnter(int flag)
{
	if(!_in_transaction) return;

	PvpEnter *pro = new PvpEnter();
	pro->roleid = _role._roledata._base._id;
	pro->index = _role._roledata._pvp._id;
	pro->flag = flag;

	_transaction_functions.push_back(CreateTF_ToCenterProtocol(pro));
}

void Player::SendPVPReady()
{
	if(!_in_transaction) return;

	PvpReady *pro = new PvpReady();
	pro->roleid = _role._roledata._base._id;
	pro->index = _role._roledata._pvp._id;

	_transaction_functions.push_back(CreateTF_ToCenterProtocol(pro));
}

void Player::SendPVPLeave(int reason, int typ)
{
	if(!_in_transaction) return;

	PvpLeave *pro = new PvpLeave();
	pro->roleid = _role._roledata._base._id;
	pro->index = _role._roledata._pvp._id;
	pro->reason = reason;
	pro->typ = typ;

	_transaction_functions.push_back(CreateTF_ToCenterProtocol(pro));
}

void Player::SendPVPCancle()
{
	if(!_in_transaction) return;

	PvpCancleArg *arg = new PvpCancleArg();
	arg->roleid = _role._roledata._base._id;

	_transaction_functions.push_back(CreateTF_ToCenterRpc(RPC_PVPCANCLE, arg));
}

void Player::SendPVPSpeed(int speed)
{
	if(!_in_transaction) return;

	PvpSpeed *pro = new PvpSpeed();
	pro->roleid = _role._roledata._base._id;
	pro->speed = speed;
	pro->index = _role._roledata._pvp._id;

	_transaction_functions.push_back(CreateTF_ToCenterProtocol(pro));
}

void Player::SendPVPReset()
{
	if(!_in_transaction) return;

	PvpReset *pro = new PvpReset();
	pro->roleid = _role._roledata._base._id;
	pro->index = _role._roledata._pvp._id;

	_transaction_functions.push_back(CreateTF_ToCenterProtocol(pro));
}

void Player::GetPVPVideo(const std::string& v)
{
	if(!_in_transaction) return;

	GetPvpVideo *pro = new GetPvpVideo();
	pro->roleid = _role._roledata._base._id;
	pro->zoneid = g_zoneid;
	pro->video_id = Octets((void*)v.c_str(), v.size());

	_transaction_functions.push_back(CreateTF_ToCenterProtocol(pro));
}

void Player::DelPVPVideo(const std::string& v)
{
	if(!_in_transaction) return;

	DelPvpVideo *pro = new DelPvpVideo();
	pro->roleid = _role._roledata._base._id;
	pro->video_id = Octets((void*)v.c_str(), v.size());

	_transaction_functions.push_back(CreateTF_ToCenterProtocol(pro));
}

void Player::SendSpeechToSTT(std::string dest_id, int chat_type, std::string speech)
{
	if(!_in_transaction) return;

	class TF: public TransactionFunctionBase
	{
		GetTextInSpeechArg *_arg;
	
	public:
		TF(GetTextInSpeechArg *arg): _arg(arg) {}
	
		virtual void OnCancel()
		{
			delete _arg;
		}
		virtual void OnCommit()
		{
			GetTextInSpeech *rpc = (GetTextInSpeech*)Rpc::Call(RPC_GETTEXTINSPEECH, _arg);
			STTClient::GetInstance()->SendProtocol(rpc);
			delete _arg;
		}
	};

	//printf("SendSpeechToSTT\n");
	GetTextInSpeechArg *arg = new GetTextInSpeechArg();
	arg->src_id = (int64_t)_role._roledata._base._id;
	arg->dest_id = Octets(dest_id.c_str(),dest_id.size());
	arg->zone_id = g_zoneid;
	arg->time = time(NULL);
	arg->chat_type = chat_type;
	//这里如果直接转化不行 可以让前端base64编码之后发过来在解码
	//printf("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@\n");
	//printf("PREBase64Decoder convert speech_content = %s",speech.c_str());
	//Octets speech_content;
	//Base64Decoder::Convert(speech_content,Octets(speech.c_str(),speech.size()));
	arg->speech_content = Octets(speech.c_str(),speech.size());
	//printf("Base64Decoder convert speech_content = %.*s",(int)speech_content.size(),(char*)speech_content.begin());

	_transaction_functions.push_back(new TF(arg));
}

void Player::AudienceGetAllList()
{
	if(!_in_transaction) return;

	AudienceGetList *pro = new AudienceGetList();
	pro->roleid = _role._roledata._base._id;
	pro->zoneid = g_zoneid;

	_transaction_functions.push_back(CreateTF_ToCenterProtocol(pro));
}

void Player::AudienceGetRoomInfo(int room_id)
{
	if(!_in_transaction) return;

	AudienceGetOperation *pro = new AudienceGetOperation();
	pro->roleid = _role._roledata._base._id;
	pro->zoneid = g_zoneid;
	pro->room_id = room_id;

	_transaction_functions.push_back(CreateTF_ToCenterProtocol(pro));
}

void Player::AudienceLeave(int room_id)
{
	if(!_in_transaction) return;

	AudienceLeaveRoom *pro = new AudienceLeaveRoom();
	pro->roleid = _role._roledata._base._id;
	pro->room_id = room_id;

	_transaction_functions.push_back(CreateTF_ToCenterProtocol(pro));
}

};

