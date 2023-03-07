#include <set>
#include <sstream>
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
#include "changerolename.hrp"
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
#include "yuezhanbegin.hpp"
#include "YueZhan_Info.h"
#include "pvpdanmu.hpp"
#include "pvppause_re.hpp"
#include "verficationoperation.hpp"
#include "verificationgameserver.hpp"
#include "roleinforegister.hpp"
#include "registerclient.hpp"
#include "GlobalMessage.h"
#include "gmadapterserver.hpp"
#include "gmcmd_getchar_re.hpp"
#include "gmcmd_mailitemtoplayer_re.hpp"
#include "gmcmd_mailtoplayer_re.hpp"
#include "guseactivecode.hrp"
#include "gaccodeclient.hpp"
#include "laohuinformserver.hpp"
#include "laohu_pay_re.hpp"

extern GNET::Thread::Mutex2 g_save_data_lock;
extern std::map<Octets, Octets> g_save_data_map;
extern std::set<Octets> g_player_should_save_set;
//extern std::map<Octets, Octets> g_save_data_map2;
//extern GNET::Thread::Mutex2 g_save_data_ing_lock;
//extern std::map<Octets, Octets> g_save_data_map_ing;

extern __thread int64_t g_transaction_id;

namespace CACHE
{

unsigned int PlayerManager::_role_id_stub = (SERVER_CONST_ROLE_ID_BEGIN-1); //前面的role_id预留，给角色模板之类
unsigned int PlayerManager::_mafia_id_stub = 0;
Thread::Mutex2 PlayerManager::_role_id_stub_lock("PlayerManager::_role_id_stub_lock");
Thread::Mutex2 PlayerManager::_mafia_id_stub_lock("PlayerManager::_mafia_id_stub_lock");

bool Role::IsActiveRole() const
{
	return ((NowWithoutOffset()-_last_active_time) < 60);
}

void Role::SendToClient(const std::string& v)
{
	_player->SendToClient(v);
}

void Role::SendToClientFirst(const std::string& v)
{
	_player->SendToClientFirst(v);
}

void Role::NewSendToClientList()
{
	_player->NewSendToClientList();
}

void Role::SendUDPToClient(const std::string& v)
{
	_player->SendUDPToClient(v);
}

void Role::SendPVPJoin(int score, char vs_robot, int wait_max_before_vs_robot)
{
	_player->SendPVPJoin(score, vs_robot, wait_max_before_vs_robot);
}

void Role::SendOperation(int map_id, std::string operation, std::string role_info, int battle_ver)
{
	_player->SendOperation(map_id, operation, role_info, battle_ver);
}

void Role::SendPVPEnter(int flag)
{
	_player->SendPVPEnter(flag);
}

void Role::SendPVPReady()
{
	_player->SendPVPReady();
}

void Role::SendPVPLeave(int reason, int typ, int score, int duration)
{
	_player->SendPVPLeave(reason, typ, score, duration);
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

void Role::SendSpeechToSTT(std::string dest_id, int chat_type, int channel, std::string speech)
{		
	_player->SendSpeechToSTT(dest_id, chat_type, channel, speech);
}

void Role::SendRoleInfoToRegister(std::string name, int level, int photo)
{	
	_player->SendRoleInfoToRegister(name, level, photo);	
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

void Role::SendYueZhanBegin(int room_id)
{
	_player->SendYueZhanBegin(room_id);
}

void Role::SendPvpDanMu(int pvp_id, std::string video_id, int tick, std::string danmu_info)
{
	_player->SendPvpDanMu(pvp_id, video_id, tick, danmu_info);
}

void Role::SendPVPPauseRe(int pvp_id)
{
	_player->SendPVPPauseRe(pvp_id);
}

int Role::GetActiveCodeType(const std::string& code)
{
	 return _player->GetActiveCodeType(code);
}

void Role::IsValidActiveCode(const std::string& code)
{
	_player->IsValidActiveCode(code);
}

int Role::GetBornTime() const
{
	time_t t = _roledata._base._create_time;
	struct tm tm;
	localtime_r(&t, &tm);
	tm.tm_hour = 0;
	tm.tm_min = 0;
	tm.tm_sec = 0;
	return mktime(&tm);
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
	int64_t now_micro = NowUS();
		
	//UDPSyncNetTime prot;
	SyncNetime prot;
	prot.id = _id;
	prot.orignate_time = now_micro;
	prot.offset = _offset;
	prot.delay = _delay;
	if(_player->GetPrevClientSendTime4TCP()==0)
		prot.client_send_time = 0;
	else
		prot.client_send_time = _player->GetPrevClientSendTime4TCP() + (now_micro-_player->GetPrevClientSendTime4TCPLocalTime())/1000;
	prot.server_send_time = (now_micro/1000)&0xffff;

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
	_can_receive_protocol = true;
	_prev_client_send_time_4_tcp = 0;

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
		int64_t now_micro = NowUS();

		auto it = _game_protocol_history.begin();
		auto i = 0;
		for(; it!=_game_protocol_history.end(); ++it, ++i)
		{
			if(_client_received_game_protocol_count < _first_game_protocol_id+i)
			{
				GameProtocol prot;
				prot.data = *it;
				if(_prev_client_send_time_4_tcp==0)
					prot.client_send_time = 0;
				else
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

void Player::UpdateDeviceInfo(const Octets& device_id)
{
	std::string s = (char*)device_id.begin();
	std::map<std::string, std::string> device_info;
	int locate = -1;
	locate = s.find("\n");
	while(locate!=-1)
	{
		std::string tmp = s.substr(0, locate-1), tmp1, tmp2;
		s = s.substr(locate+1, s.size());
		locate = tmp.find(":");
		tmp1 = tmp.substr(0, locate-1);
		tmp2 = tmp.substr(locate+1, tmp.size());
		device_info[tmp1] = tmp2;
		locate = s.find("\n");
	}
	_role._roledata._device_info._device_model = device_info["deviceType"];
	_role._roledata._device_info._device_sys = device_info["operatingSystem"];
	_role._roledata._device_info._device_ram = atoi(device_info["systemMemorySize"].c_str());
	_role._roledata._device_info._mac = device_info["deviceUniqueIdentifier"];
	_role._roledata._status._account = std::string((char*)_account.begin(), _account.size());
	if(_role._roledata._device_info._device_sys.find("iOS")!=std::string::npos)
	{
		_role._roledata._device_info._os = 1;
	}
	else if(_role._roledata._device_info._device_sys.find("Android")!=std::string::npos)
	{
		_role._roledata._device_info._os = 2;
	}

}

void Player::SendGameProtocol(const Octets& data)
{
	int64_t now_micro = NowUS();

	GameProtocol prot;
	prot.data = data;
	if(_prev_client_send_time_4_tcp==0)
		prot.client_send_time = 0;
	else
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
	//这里是没有锁的
	if((int64_t)_role._roledata._base._id == 0) return; //没创建角色前别心跳了

	if(!_role.IsActiveRole())
	{
		if(_role._roledata._status._online == 1)
		{
			_do_cleanup = true; //避免内存占用过大，下线时清一下

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

void Player::BILog(const char *v) const
{
	GLog::log(LOG_NOTICE, "===LUA LOG(%s, %.*s, %lu)===: %s", B16EncodeOctets(GetAccount()).c_str(), (int)GetAccount().size(),
	          (char*)GetAccount().begin(), (int64_t)_role._roledata._base._id, v);
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
		if(_transaction_game_protocols.empty())
		{
			std::list<GNET::Octets> list;
			_transaction_game_protocols.push_back(list);
		}
		auto it = _transaction_game_protocols.rbegin();
		it->push_back(data);
		return;
	}
	SendGameProtocol(data);
}

void Player::SendToClientFirst(const std::string& v)
{
	Octets data(v.c_str(), v.size());
	if(_in_transaction)
	{
		if(_transaction_game_protocols.empty())
		{
			std::list<GNET::Octets> list;
			_transaction_game_protocols.push_back(list);
		}
		auto it = _transaction_game_protocols.rbegin();
		it->push_front(data);
		return;
	}
	SendGameProtocol(data);
}

void Player::NewSendToClientList()
{
	if(_in_transaction)
	{
		std::list<GNET::Octets> list;
		_transaction_game_protocols.push_back(list);
	}
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
	if((int64_t)target<=0) return;

	__SendMessage(target, v, delay, extra_roles, extra_mafias, extra_pvps);
}

void Player::__SendMessage(const Int64& target, const std::string& v, int delay, const Int64List& extra_roles, const Int64List& extra_mafias, const IntList& extra_pvps)
{
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

void Player::_SendMessageToAllRole(const std::string& v, int delay)
{
	Int64List extra_roles;
	Int64List extra_mafias;
	IntList extra_pvps;

	__SendMessage(SERVER_CONST_MESSAGE_TARGET_ACTIVE_ROLES, v, delay, extra_roles, extra_mafias, extra_pvps);
}

void Player::_SendMessageToAllRole(const std::string& v, int delay, const Int64List& extra_roles, const Int64List& extra_mafias, const IntList& extra_pvps)
{
	__SendMessage(SERVER_CONST_MESSAGE_TARGET_ACTIVE_ROLES, v, delay, extra_roles, extra_mafias, extra_pvps);
}

void Player::SendMessageToAllRole(const std::string& v, const int checksum)
{
	if(_in_transaction)
	{
		Serialized m;
		m._str = v;
		m._checksum = checksum;
		_transaction_to_all_role_messages.push_back(m);
		return;
	}
	SGT_GlobalMessage::GetInstance().Put_NOLOCK(v.c_str(), checksum);
}

void Player::SendCommandToAllRole(const std::string& v, const int checksum)
{
	if(_in_transaction)
	{
		Serialized c;
		c._str = v;
		c._checksum = checksum;
		_transaction_to_all_role_commands.push_back(c);
		return;
	}
	SGT_GlobalMessage::GetInstance().PutCmd_NOLOCK(v.c_str(), checksum);
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

int Player::GetLengthUtf8(char const* str)
{
	int cnt = 0;
	while(*str != '\0')
	{   
		if(*str & (1 << 7)) 
		{   
			if(*str & (1 << 6)) 
			{   
				if(*str & (1 << 5)) 
 				{   
					if(*str & (1 << 4)) 
					{   
						cnt++;str += 4;
						continue;
					}  
					cnt++;str += 3;
					continue;
				}   
				cnt++;str += 2;
				continue;
			}   
		}   
		cnt++;str += 1;
		continue;
	}
	return cnt;
}

bool Player::IsValidRolename(const std::string& role_name)
{
	//把空格去掉
	size_t offset = role_name.find_first_of("\r\n\t\\");
	if(offset!=std::string::npos)
		return false;

	if(GetLengthUtf8(role_name.c_str()) < 1 || GetLengthUtf8(role_name.c_str()) > SERVER_CONST_ROLE_NAME_CHARATER_NUM)
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

void Player::AllocRoleChangeName(const char *name)
{
	if(!_in_transaction) return;

	class TF: public TransactionFunctionBase
	{
		ChangeRoleNameArg *_arg;
	
	public:
		TF(ChangeRoleNameArg *arg): _arg(arg) {}
	
		virtual void OnCancel()
		{
			delete _arg;
		}
		virtual void OnCommit()
		{
			ChangeRoleName *rpc = (ChangeRoleName*)Rpc::Call(RPC_CHANGEROLENAME, _arg);
			UniqueNameClient::GetInstance()->SendProtocol(rpc);
			delete _arg;
		}
	};

	std::string tmp = name;
	
	ChangeRoleNameArg *arg = new ChangeRoleNameArg();
	arg->name = Octets((void*)tmp.c_str(), tmp.size());
	arg->roleid = _role._roledata._base._id;		

	_transaction_functions.push_back(new TF(arg));
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
		//TODO:
#if 1
		extra_roles.push_back(i);
#endif
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

void Player::restore(int64_t transaction_id)
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
	_transaction_to_all_role_messages.clear();
	_transaction_to_all_role_commands.clear();
}

void Player::CommitTransaction()
{
	//TODO: exception?
	if(!_in_transaction) return;
	_in_transaction = false;

	for(auto it=_transaction_game_protocols.begin(); it!=_transaction_game_protocols.end(); ++it)
	{
		for(auto im=it->begin(); im!=it->end(); ++im)
		{
			SendGameProtocol(*im);
		}
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

	for(auto it=_transaction_to_all_role_messages.begin(); it!=_transaction_to_all_role_messages.end(); ++it)
	{
		SGT_GlobalMessage::GetInstance().Put_NOLOCK(it->_str.c_str(), it->_checksum);
	}
	_transaction_to_all_role_messages.clear();

	for(auto it=_transaction_to_all_role_commands.begin(); it!=_transaction_to_all_role_commands.end(); ++it)
	{
		SGT_GlobalMessage::GetInstance().PutCmd_NOLOCK(it->_str.c_str(), it->_checksum);
	}
	_transaction_to_all_role_commands.clear();

	_dirty = true;

	if(_do_cleanup)
	{
		cleanup();
		_do_cleanup = false;
	}
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

	_transaction_to_all_role_messages.clear();
	_transaction_to_all_role_commands.clear();

	if(_do_cleanup)
	{
		cleanup();
		_do_cleanup = false;
	}
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
	Thread::Mutex2::Scoped keeper(_active_players_lock);

	//统计活跃玩家
	int prev_min = _cur_min;
	_cur_min = now/60;
	if(prev_min != _cur_min)
	{
		//新的分钟开始了
		_active_players_history_index++;
		_active_players_history[_active_players_history_index%SERVER_CONST_ACTIVE_PLAYERS_HISTORY_MAX].clear();
		_active_players.clear();
		//_local_active_players.clear();
		for(int i=_active_players_history_index-3; i<_active_players_history_index; i++)
		{
			if(i<0) continue;
			int idx = i%SERVER_CONST_ACTIVE_PLAYERS_HISTORY_MAX;
			_active_players.insert(_active_players_history[idx].begin(), _active_players_history[idx].end());
			//_local_active_players.insert(_active_players_history[idx].begin(), _active_players_history[idx].end());
		}
	}

	//for(auto it=_map.begin(); it!=_map.end(); ++it)
	for(auto it=_active_players.begin(); it!=_active_players.end(); ++it)
	//for(auto it=_local_active_players.begin(); it!=_local_active_players.end(); ++it)
	{
		//Player *player = it->second;
		Player *player = *it;
		if(tick%SERVER_CONST_TICK_PER_SECOND == player->GetHash_NOLOCK()%SERVER_CONST_TICK_PER_SECOND)
		{
			player->OnTimer1s(now);
		}
	}
}

int64_t PlayerManager::AllocRoleId()
{
	Thread::Mutex2::Scoped keeper(_role_id_stub_lock);
	int64_t zoneid = g_zoneid;
	return ((zoneid<<48) | (++_role_id_stub));
}

int64_t PlayerManager::AllocMafiaId()
{
	Thread::Mutex2::Scoped keeper(_mafia_id_stub_lock);
	return ++_mafia_id_stub;
}

Player* PlayerManager::FindByAccount(const Octets& account)
{
	Thread::RWLock2::RDScoped keeper(_lock);

	auto it = _map.find(account);
	if(it == _map.end()) return 0;
	return it->second;
}

const Player* PlayerManager::FindByAccount(const Octets& account) const
{
	Thread::RWLock2::RDScoped keeper(_lock);

	auto it = _map.find(account);
	if(it == _map.end()) return 0;
	return it->second;
}

Player* PlayerManager::FindByTransToken(const Octets& trans_token, bool active)
{
	Player *player = 0;
	{
		Thread::RWLock2::RDScoped keeper(_lock);

		auto it = _map_by_trans_token.find(trans_token);
		if(it == _map_by_trans_token.end()) return 0;
		//Player *player = it->second;
		player = it->second;
	}
	if(active)
	{
		Thread::Mutex2::Scoped keeper(_active_players_lock);

		_active_players_history[_active_players_history_index%SERVER_CONST_ACTIVE_PLAYERS_HISTORY_MAX].insert(player);
		_active_players.insert(player);
	}
	return player;
}

const Player* PlayerManager::FindByTransToken(const Octets& trans_token) const
{
	Thread::RWLock2::RDScoped keeper(_lock);

	auto it = _map_by_trans_token.find(trans_token);
	if(it == _map_by_trans_token.end()) return 0;
	return it->second;
}

Player* PlayerManager::FindByTransSid(unsigned int sid, bool active)
{
	Player *player = 0;
	{
		Thread::RWLock2::RDScoped keeper(_lock);

		auto it = _map_by_trans_sid.find(sid);
		if(it == _map_by_trans_sid.end()) return 0;
		player = it->second;
	}
	if(active)
	{
		Thread::Mutex2::Scoped keeper(_active_players_lock);

		_active_players_history[_active_players_history_index%SERVER_CONST_ACTIVE_PLAYERS_HISTORY_MAX].insert(player);
		_active_players.insert(player);
	}
	return player;
}

const Player* PlayerManager::FindByTransSid(unsigned int sid) const
{
	Thread::RWLock2::RDScoped keeper(_lock);

	auto it = _map_by_trans_sid.find(sid);
	if(it == _map_by_trans_sid.end()) return 0;
	return it->second;
}

Player* PlayerManager::FindByRoleId(int64_t id)
{
	Thread::RWLock2::RDScoped keeper(_map_by_role_id_lock);

	auto it = _map_by_role_id.find(id);
	if(it == _map_by_role_id.end()) return 0;
	Role *role = it->second;
	return role->_player;
}

const Player* PlayerManager::FindByRoleId(int64_t id) const
{
	Thread::RWLock2::RDScoped keeper(_map_by_role_id_lock);

	auto it = _map_by_role_id.find(id);
	if(it == _map_by_role_id.end()) return 0;
	const Role *role = it->second;
	return role->_player;
}

void PlayerManager::OnConnect(const Octets& account, const Octets& trans_token, const Octets& key1)
{
	Thread::RWLock2::WRScoped keeper(_lock);

	Player *player = 0;
	auto it = _map.find(account);
	if(it != _map.end()) player = it->second;
	if(!player)
	{
		player = new Player(account);
		if(!player) return;
		_map[account] = player;

		player->UpdateActiveTime_NOLOCK(); //免得立刻被清除
	}

	Thread::Mutex2::Scoped keeper2(player->_lock);

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
	Thread::RWLock2::WRScoped keeper(_lock);
	Thread::Mutex2::Scoped keeper2(player->_lock);

	unsigned int old_sid = player->GetTransSid();
	_map_by_trans_sid.erase(old_sid);
	Kickout prot;
	prot.reason = KICKOUT_REASON_MULTI_LOGIN;
	TransServer::GetInstance()->Send(old_sid, prot);
	//TransServer::GetInstance()->Close(old_sid, CLOSE_ACTIVE, 1);
	TransServer::GetInstance()->Close(old_sid);

	player->SetCanSendGameProtocol(false);
	player->SetCanReceiveProtocol(false);
	player->SetLastDeviceId(device_id);
	player->SetClientReceivedGameProtocolCount(client_received_game_protocol_count);
	player->SetTransSid(sid);
	_map_by_trans_sid[sid] = player;

	player->ResetLatency();
	player->ResetUDPLatency();
	player->UpdateUDPInfo(0, Octets(), 0, Octets(), 0);
	player->UpdateDeviceInfo(device_id);

	//fprintf(stderr, "PlayerManager::OnTransConnect, account=%s, device_id=%s, client_received_game_protocol_count=%d, sid=%u\n",
	//        B16EncodeOctets(player->GetAccount()).c_str(), B16EncodeOctets(device_id).c_str(), client_received_game_protocol_count, sid);
}

void PlayerManager::OnDisconnect(const Octets& account)
{
	Player *player = FindByAccount(account);
	if(player)
	{
		Thread::Mutex2::Scoped keeper2(player->_lock);
		player->SetDisconnect();
	}
}

void PlayerManager::GetActiveRoles(std::vector<int64_t>& roles) const
{
	Thread::Mutex2::Scoped keeper(_active_players_lock);

	roles.reserve(_active_players.size());
	for(auto it=_active_players.begin(); it!=_active_players.end(); ++it)
	{
		const Player *player = *it;
		if((int64_t)player->_role._roledata._base._id==0) continue;
		roles.push_back(player->_role._roledata._base._id);
	}
}

int PlayerManager::GetRoleCount() const
{
	Thread::RWLock2::RDScoped keeper(_lock);
	return _map.size();
}

int PlayerManager::GetActiveRoleCount() const
{
	Thread::Mutex2::Scoped keeper(_active_players_lock);
	return _active_players.size();
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
	//if(g_server_state!=SERVER_STATE_LOADING) return; //TODO: assert
	assert(g_server_state==SERVER_STATE_LOADING);

	std::string str_key  = std::string((char*)key.begin(),key.size());
	std::string account = "";
	const char *p = str_key.c_str();
	//const char *q = strrchr(p, '_'); //FIXME: 你大爷
	const char *q = strchr(p, '_');
	assert(q!=0);
	{
		//std::string s(q+1, p+str_key.size());
		std::string s(q+1);
		account = s;
	}
	Octets account_o(account.c_str(), account.size());

	//Player *tmp = new Player(Octets(account.c_str(),account.size()));
	Player *tmp = new Player(account_o);

	Marshal::OctetsStream os(value);
	int db_version = 0;
	os >> db_version;
	int last_active_time = 0;
	os >> last_active_time;
	os._dbversion = db_version;
	//try
	//{
	tmp->unmarshal(os);
	//}
	//catch(...)
	//{
	//	GLog::log(LOG_ERR, "PlayerManager::Load, unmarshal, account=%s", account.c_str());
	//}

	{
	Thread::RWLock2::WRScoped keeper(_lock);
	Thread::RWLock2::WRScoped keeper2(_map_by_role_id_lock);

	if(_map.find(account_o)!=_map.end()) return; //不允许重复加载

	if((NowWithoutOffset()-last_active_time)<3600*24*1 || (int64_t)tmp->_role._roledata._base._id<SERVER_CONST_ROLE_ID_BEGIN)
	{
		tmp->UpdateActiveTime(last_active_time);
		//_map[Octets(account.c_str(),account.size())] = tmp;
		_map[account_o] = tmp; //FIXME: 大量的0 id玩家会进来

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
}

void PlayerManager::LoadPlayerInfo(Octets &key, Octets &value)
{
	//TODO: lock
	Thread::Mutex2::Scoped keeper(_role_id_stub_lock);
	Thread::Mutex2::Scoped keeper2(_mafia_id_stub_lock);

	Marshal::OctetsStream os(value);
	int db_version = 0;
	os >> db_version;
	os >> _role_id_stub;
	os >> _mafia_id_stub;
}

void PlayerManager::LoadRoleInfo(Octets &key, Octets &value)
{
	Thread::RWLock2::WRScoped keeper(_lock);
	Thread::RWLock2::WRScoped keeper2(_map_by_role_id_lock);

	std::string str_key  = std::string((char*)key.begin(),key.size());
	std::string account = "";
	const char *p = str_key.c_str();
	const char *q = strchr(p, '_');
	assert(q!=0);
	{
		std::string s(q+1);
		account = s;
	}
	Octets account_o(account.c_str(), account.size());

	Player *player = 0;
	std::map<Octets, Player*>::iterator it = _map.find(account_o);
	if(it != _map.end())
	{
		player = it->second;
		if((int64_t)player->_role._roledata._base._id != 0)
		{
			GLog::log(LOG_ERR, "PlayerManager::LoadRoleInfo, exist, account=%s", account.c_str());
			return;
		}
	}
	else
	{
		player = new Player(account_o);
		_map[account_o] = player;
	}

	Marshal::OctetsStream os(value);
	int db_version = 0;
	os >> db_version;
	int last_active_time = 0;
	os >> last_active_time;
	os._dbversion = db_version;
	player->unmarshal(os);
	player->UpdateActiveTime_NOLOCK();

	assert((int64_t)player->_role._roledata._base._id!=0);
	_map_by_role_id[player->_role._roledata._base._id] = &player->_role;
	//char msg[100];
	//snprintf(msg, sizeof(msg), "22:");
	//MessageManager::GetInstance().Put(player->_role._roledata._base._id, player->_role._roledata._base._id, msg, 0);

	GLog::log(LOG_INFO, "PlayerManager::LoadRoleInfo, account=%s", account.c_str());
}

void PlayerManager::Save()
{
#if 0
	//TODO: 单线程模式检测?
	//FIXME: 不能只处理_active_players

	//修改一下，后面修改成只存储活跃玩家的数据
	Player * tmp_player = NULL;
	std::map<Octets, Player*>::iterator it = _map.begin();
	std::set<Player*>::iterator it_set = _active_players.begin();
	GNET::Marshal::OctetsStream value;
	int db_version = DB_VERSION;

	//这里需要注意一下了，就是保存的时间间隔一定要比活跃变成非活跃的时间短，否则的话会造成一些活跃玩家的数据没有保存就变成了非活跃的玩家
	//后面可以看一下，在关服的时候，进行一次所有玩家的存储。也可以避免这个问题的。
	for(; it_set != _active_players.end(); it_set++)
	{
		it = _map.find((*it_set)->GetAccount());
		if(it != _map.end())
		{
			value.clear();
			std::string key_str = "roleinfo_";
			Octets key = it->first;
			key_str += std::string((char*)key.begin(),key.size());
			tmp_player = it->second;
			if((int64_t)tmp_player->_role._roledata._base._id == 0 || tmp_player->IsDirty() == false)
				continue;
			//先把version版本号放进去
			value << db_version;
			value << tmp_player->_role._last_active_time;
			tmp_player->marshal(value);
			g_save_data_map[Octets(key_str.c_str(), key_str.size())] = value;
			tmp_player->ClearDirty();
		}
	}
	//在这里再把现在有多少玩家的数据保存起来，否则会造成玩家的ID错误
	std::string key_str = "playermanagerinfo";
	value.clear();
	value << db_version;
	value << _role_id_stub;
	value << _mafia_id_stub;

	g_save_data_map[Octets(key_str.c_str(), key_str.size())] = value;
#endif
	//in big lock
	//让所有dirty palyer去Save自己，这样可以避免save单线程化过久
	//所有玩家都可能需要保存，即使非_active_players
	//TODO: 单线程模式检测?
	//TODO: 关服处理，其实也不太重要，等几分钟即可

	time_t now_without_offset = NowWithoutOffset();
	//for(auto it=_map.begin(); it!=_map.end(); it++)
	auto it=_map.begin();
	while (it!=_map.end())
	{
		Player *p = it->second;
		++it;

#if 0
		if(!p->IsDirty() && now_without_offset-p->_role._last_active_time>3600)
		{
			int64_t roleid = p->_role._roledata._base._id;
			if(roleid>0 && roleid<SERVER_CONST_ROLE_ID_BEGIN) continue;

			if(roleid!=0) SGT_NoLoadPlayer::GetInstance().InsertData(p->GetStrAccount(), p->_role._roledata._base._id);
			_map.erase(p->GetAccount()); //TODO: 安全吗?
			_map_by_trans_token.erase(p->GetTransToken());
			_map_by_trans_sid.erase(p->GetTransSid());
			for(auto i=0; i<SERVER_CONST_ACTIVE_PLAYERS_HISTORY_MAX; ++i)
			{
				_active_players_history[i].erase(p);
			}
			_active_players.erase(p);
			_map_by_role_id.erase(p->_role._roledata._base._id);
			delete p;

			continue;
		}
#endif
		if(((int64_t)p->_role._roledata._base._id)==0 || !p->IsDirty())
		{
			continue;
		}
		//p->ClearDirty();
		p->SetDoSave();
		g_player_should_save_set.insert(p->GetAccount());
	}

	//管理器数据
	//在这里再把现在有多少玩家的数据保存起来，否则会造成玩家的ID错误
	GNET::Marshal::OctetsStream value;
	int db_version = DB_VERSION;
	std::string key_str = "playermanagerinfo";
	value.clear();
	value << db_version;
	value << _role_id_stub;
	value << _mafia_id_stub;

	g_save_data_map[Octets(key_str.c_str(), key_str.size())] = value;
}

void PlayerManager::Save2()
{
	//in big lock
	//有部分玩家(例如非活跃玩家)，没有机会自己进行Save，所以需要最终统一Save下，补漏
	std::set<Octets> tmp_set;
	tmp_set.swap(g_player_should_save_set); //DoSave会写g_player_should_save_set
	for(auto it_acc=tmp_set.begin(); it_acc!=tmp_set.end(); it_acc++)
	{
		auto it = _map.find(*it_acc);
		if(it != _map.end())
		{
			Player *p = it->second;
			p->DoSave();
		}
	}
}

void Player::DoSave()
{
	assert(_dirty && _do_save);
	_dirty = false;
	_do_save = false;

	std::string key_str = "roleinfo_";
	key_str += std::string((char*)_account.begin(),_account.size());
	//先把version版本号放进去
	GNET::Marshal::OctetsStream value;
	int db_version = DB_VERSION;
	value << db_version;
	value << _role._last_active_time;
	marshal(value);

	{
	Thread::Mutex2::Scoped keeper(g_save_data_lock);

	g_save_data_map[Octets(key_str.c_str(), key_str.size())] = value;
	g_player_should_save_set.erase(_account);
	}
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

	Thread::RWLock2::WRScoped keeper(_map_by_role_id_lock);

	if(player)
	{
		Thread::Mutex2::Scoped keeper2(player->_lock);
		if(player->OnAllocRoleName(name, create_time))
		{
			_map_by_role_id[player->_role._roledata._base._id] = &player->_role;
			OnChanged();
		}
	}
}

void Player::UpdateLatency(unsigned short client_send_time, unsigned short server_send_time)
{
	Thread::Mutex2::Scoped keeper(_latency_lock);

	_prev_client_send_time_4_tcp = client_send_time;
	_prev_client_send_time_4_tcp_local_time = NowUS();

	if(server_send_time==0) return;

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
	Thread::Mutex2::Scoped keeper(_latency_lock);
	_latency.Reset();
}

int Player::GetLatency()
{
	Thread::Mutex2::Scoped keeper(_latency_lock);
	return _latency.Get();
}

void Player::UpdateUDPLatency(unsigned short client_send_time, unsigned short server_send_time)
{
	Thread::Mutex2::Scoped keeper(_latency_lock);

	_prev_client_send_time_4_udp = client_send_time;
	_prev_client_send_time_4_udp_local_time = NowUS();

	if(server_send_time==0) return;

	unsigned int now_ms = (_prev_client_send_time_4_udp_local_time/1000)&0xffff;
	if(now_ms < server_send_time)
	{
		now_ms += 0x10000;
	}
	//GLog::log(LOG_INFO, "UpdateUDPLatency, latency=%d\n", now_ms-server_send_time);
	_udp_latency.AddSample(now_ms-server_send_time);
	//GLog::log(LOG_INFO, "UpdateLatency, _udp_latency.Get()=%d\n", _udp_latency.Get());
}

void Player::ResetUDPLatency()
{
	Thread::Mutex2::Scoped keeper(_latency_lock);
	_udp_latency.Reset();
}

int Player::GetUDPLatency()
{
	Thread::Mutex2::Scoped keeper(_latency_lock);
	return _udp_latency.Get();
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
	_samples.clear();
	_prev_add_sample_time = 0;
}

void Latency::AddSample(int latency_ms)
{
	//printf("Latency::AddSample, latency_ms=%d\n", latency_ms);

	//if(latency_ms>65000) return;
	if(latency_ms>65000) latency_ms=1;

	timeval tv;
	gettimeofday(&tv,NULL);
	_prev_add_sample_time = tv.tv_sec*1000000+tv.tv_usec;

	_samples.insert(std::make_pair(tv.tv_sec, latency_ms));

	if(_samples.size()>TIME_MAX*30) Get(); //保险，防止保存的采样数据过多
}

int Latency::Get()
{
	if(_samples.size()<TIME_MIN*1) return -1; //采样总数太少

	timeval tv;
	gettimeofday(&tv,NULL);
	int now = tv.tv_sec;

	if(_samples.begin()->first>now-TIME_MIN) return -1; //采样时间太短

	auto it_max = _samples.upper_bound(now-TIME_MAX);
	_samples.erase(_samples.begin(), it_max); //过于久远的样本可以删掉了

	int M = _samples.size()*TOP/100;
	if(M<1) M=1;

	std::set<int> maxM;
	for(auto it=_samples.begin(); it!=_samples.end(); ++it)
	{
		int latency = it->second;
		if((int)maxM.size() < M)
		{
			maxM.insert(latency);
		}
		else
		{
			if(latency > *maxM.begin())
			{
				maxM.erase(maxM.begin());
				maxM.insert(latency);
			}
		}
	}

	int64_t now_micro = tv.tv_sec*1000000+tv.tv_usec;
	int64_t latency = (now_micro-_prev_add_sample_time-_sample_interval_max)/1000;
	if(!maxM.empty() && latency<*maxM.begin())
	{
		latency = *maxM.begin();
	}
	return latency;

	//TODO: 延迟分布是否均匀
}

void CommandStat::Reset()
{
	memset(_samples, 0, sizeof(_samples));
	_index = 0;
}

void CommandStat::AddSample()
{
	_samples[_index%N] = NowWithoutOffset();
	_index++;
}

bool CommandStat::IsTooFast() const
{
	if(_index < N) return false;

	return (_samples[(_index-1)%N]-_samples[_index%N]<T);
}

void Player::ResetCommandStat()
{
	Thread::Mutex2::Scoped keeper(_command_stat_lock);
	_command_stat.Reset();
}

void Player::OnRecvCommand()
{
	Thread::Mutex2::Scoped keeper(_command_stat_lock);
	_command_stat.AddSample();
}

bool Player::IsClientCmdSendTooFast() const
{
	Thread::Mutex2::Scoped keeper(_command_stat_lock);
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

void Player::SendPVPJoin(int score, char vs_robot, int wait_max_before_vs_robot)
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
	arg->pvp_ver = _role._roledata._client_ver._pvp_ver;
	arg->win_count = _role._roledata._pvp_info._win_flag;
	arg->vs_robot = vs_robot;
	arg->wait_max_before_vs_robot = wait_max_before_vs_robot;

	_transaction_functions.push_back(CreateTF_ToCenterRpc(RPC_PVPJOIN, arg));
}

void Player::SendOperation(int map_id, std::string operation, std::string role_info, int battle_ver)
{
	VerficationOperation prot;
	prot.stage_id = map_id;
	prot.hero_info = role_info;
	prot.operation = operation;
	bool flag = VerificationGameServer::GetInstance()->SendProtocol(prot, battle_ver);
	if(flag)
	{
		GLog::log(LOG_INFO, "GAMED::SendOperation Success");
	}
	else
	{
		GLog::log(LOG_INFO, "GAMED::SendOperation Failed");
	}
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

void Player::SendPVPLeave(int reason, int typ, int score, int duration)
{
	if(!_in_transaction) return;

	PvpLeave *pro = new PvpLeave();
	pro->roleid = _role._roledata._base._id;
	pro->index = _role._roledata._pvp._id;
	pro->reason = reason;
	pro->typ = typ;
	pro->score = score;
	pro->duration = duration;

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

/* chat_type 类型代表 0: 公聊  1: 私聊 */
void Player::SendSpeechToSTT(std::string dest_id, int chat_type, int channel, std::string speech)
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
			printf("SendSpeechToSTT OnCommit\n");
			GetTextInSpeech *rpc = (GetTextInSpeech*)Rpc::Call(RPC_GETTEXTINSPEECH, _arg);
			STTClient::GetInstance()->SendProtocol(rpc);
			delete _arg;
		}
	};

	printf("SendSpeechToSTT\n");
	GetTextInSpeechArg *arg = new GetTextInSpeechArg();
	arg->src_id = (int64_t)_role._roledata._base._id;
	arg->dest_id = Octets(dest_id.c_str(),dest_id.size());
	arg->zone_id = g_zoneid;
	arg->time = Now();
	arg->chat_type = chat_type;
	arg->chat_channel = channel;
	//这里如果直接转化不行 可以让前端base64编码之后发过来在解码
	//printf("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@\n");
	//printf("PREBase64Decoder convert speech_content = %s",speech.c_str());
	//Octets speech_content;
	//Base64Decoder::Convert(speech_content,Octets(speech.c_str(),speech.size()));
	arg->speech_content = Octets(speech.c_str(),speech.size());
	//printf("Base64Decoder convert speech_content = %.*s",(int)speech_content.size(),(char*)speech_content.begin());

	_transaction_functions.push_back(new TF(arg));
}

void Player::SendRoleInfoToRegister(std::string name, int level, int photo)
{	
	printf("SendRoleInfoToRegister ~~~~~~~~~~~~~~\n");
	RoleinfoRegister *pro = new RoleinfoRegister();
	pro->account = _account; 
	pro->name = Octets(name.c_str(),name.size());
	pro->zone_id = g_zoneid;
	pro->level = level;
	pro->photo = photo;

	RegisterClient::GetInstance()->SendProtocol(pro);
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

void Player::SendYueZhanBegin(int room_id)
{
	if(!_in_transaction) return;
	
	Octets tmp_creater, tmp_joiner;

	YueZhanData *info = NULL;
	bool result = SGT_YueZhan_Info::GetInstance().GetRoomInfo(room_id, info);
	if(result == false)
	{
		return;
	}

	YueZhanBegin *pro = new YueZhanBegin();
	pro->create_roleid = (int64_t)info->_create_id;
	pro->create_pvpinfo = Octets((void*)info->_create_info.c_str(), info->_create_info.size());
	Base64Decoder::Convert(tmp_creater, Octets((void*)info->_create_key1.c_str(), info->_create_key1.size()));
	pro->create_key = tmp_creater;
	
	pro->join_roleid = (int64_t)info->_join_id;
	pro->join_pvpinfo = Octets((void*)info->_join_info.c_str(), info->_join_info.size());
	Base64Decoder::Convert(tmp_joiner, Octets((void*)info->_join_key1.c_str(), info->_join_key1.size()));
	pro->join_key = tmp_joiner;
	
	pro->zoneid = g_zoneid;
	pro->exe_version = Octets((void*)_role._roledata._client_ver._exe_ver.c_str(), _role._roledata._client_ver._exe_ver.size());
	pro->data_version = Octets((void*)_role._roledata._client_ver._data_ver.c_str(), _role._roledata._client_ver._data_ver.size());
	pro->room_id = room_id;
	pro->pvp_ver = info->_pvp_ver;

	_transaction_functions.push_back(CreateTF_ToCenterProtocol(pro));
}

void Player::SendPvpDanMu(int pvp_id, std::string video_id, int tick, std::string danmu_info)
{
	if(!_in_transaction) return;

	PvpDanMu *pro = new PvpDanMu();
	pro->role_id = (int64_t)_role._roledata._base._id;
	pro->role_name = Octets((void*)_role._roledata._base._name.c_str(), _role._roledata._base._name.size());
	pro->zone_id = g_zoneid;
	pro->pvp_id = pvp_id;
	pro->video_id = atoll(video_id.c_str());
	pro->tick = tick;
	pro->danmu_info = Octets((void*)danmu_info.c_str(), danmu_info.size());

	_transaction_functions.push_back(CreateTF_ToCenterProtocol(pro));
}

void Player::SendPVPPauseRe(int pvp_id)
{
	if(!_in_transaction) return;

	PVPPause_Re *pro = new PVPPause_Re();
	pro->id = pvp_id;
	pro->fighter = (int64_t)_role._roledata._base._id;

	_transaction_functions.push_back(CreateTF_ToCenterProtocol(pro));
}

void Player::SendLaohuPayRe(int retcode, const std::string& order, int amount, const std::string& ext, int sid)
{
	//直接发
	Laohu_Pay_Re prot;
	prot.retcode = retcode;
	prot.account = _account;
	prot.order = Octets((void*)order.c_str(), order.size());
	prot.amount = amount;
	prot.ext = Octets((void*)ext.c_str(), ext.size());
	prot.zoneid = g_zoneid;

	LaohuInformServer::GetInstance()->Send(sid, prot);
}

int Player::GetActiveCodeType(const std::string& code)
{
	return GUseActiveCode::ParseType((char*)code.c_str(), 4);
}

void Player::IsValidActiveCode(const std::string& code)
{
	if(!_in_transaction) return;

	class TF: public TransactionFunctionBase
	{
		GUseActiveCodeArg *_arg;

	public:
		TF(GUseActiveCodeArg *arg): _arg(arg) {}

		virtual void OnCancel()
		{
			delete _arg;
		}

		virtual void OnCommit()
		{
			GUseActiveCode *rpc = (GUseActiveCode*)Rpc::Call(RPC_GUSEACTIVECODE, _arg);
			GACCodeClient::GetInstance()->SendProtocol(rpc);
			delete _arg;
		}
	};

	GUseActiveCodeArg *arg = new GUseActiveCodeArg();
	std::string tmp = code;
	arg->code = Octets((void*)tmp.c_str(), tmp.size());
	arg->roleid = _role._roledata._base._id;
	arg->zoneid = g_zoneid;
	_transaction_functions.push_back(new TF(arg));
}


void Player::GMCmdGetCharReply(const GMCmdGetCharRe resp, int session_id, unsigned int sid)
{
	GMCmd_GetChar_Re prot;

	prot.retcode = 0;
	prot.roleid = resp.roleid;
	prot.rolename = Octets((void*)resp.rolename.c_str(), resp.rolename.size());
	prot.session_id = session_id;
	prot.zoneid = resp.zoneid;
	prot.level = resp.level;
	prot.sex = resp.sex;
	prot.createtime = Octets((void*)resp.createtime.c_str(), resp.createtime.size());
	prot.lastlogintime = Octets((void*)resp.lastlogintime.c_str(), resp.lastlogintime.size());
	prot.ip =  Octets((void*)resp.ip.c_str(), resp.ip.size());
	prot.exp = resp.exp;	//FIX ME
	prot.mafianame = Octets((void*)resp.mafianame.c_str(), resp.mafianame.size());
	prot.yuanbao = resp.yuanbao;
	prot.money = resp.money;
	prot.bdyuanbao = resp.bdyuanbao;
	prot.vip = resp.vip;
	prot.account = _account;
	prot.totalcash = resp.totalcash;
	prot.zhanli = resp.zhanli;

	GMAdapterServer::GetInstance()->Send(sid, prot);
}

void Player::GMCmdMailItemToPlayerReply(int session_id, unsigned int sid)
{
	GMCmd_MailItemToPlayer_Re prot;

	prot.retcode = 0;
	prot.session_id = session_id;

	GMAdapterServer::GetInstance()->Send(sid, prot);
}

void Player::GMCmdMailToPlayerReply(int retcode, int session_id, unsigned int sid)
{
	GMCmd_MailToPlayer_Re prot;

	prot.retcode = retcode;
	prot.session_id = session_id;
	if(retcode != 0){
		const char *desc = "mailid not exist";
		prot.desc = Octets(desc, strlen(desc));
	}

	GMAdapterServer::GetInstance()->Send(sid, prot);
}

void PlayerManager::Shutdown()
{
	for(auto it=_map.begin(); it!=_map.end(); ++it)
	{
		Player *p = it->second;
		delete p;
	}
	_map.clear();
	_map_by_trans_token.clear();
	_map_by_trans_sid.clear();

	for(auto i=0; i<SERVER_CONST_ACTIVE_PLAYERS_HISTORY_MAX; ++i)
	{
		_active_players_history[i].clear();
	}
	_active_players.clear();

	_map_by_role_id.clear();
	//TODO:
}

};

