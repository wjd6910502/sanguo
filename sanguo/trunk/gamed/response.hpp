
#ifndef __GNET_RESPONSE_HPP
#define __GNET_RESPONSE_HPP

#include "localdefs.h"
#include "callid.hxx"
#include "state.hxx"

#include "authresult.hpp"
#include "commonmacro.h"
//#include "connection.h"
#include "gateserver.hpp"
#include "transserver.hpp"
#include "udptransserver.hpp"
#include "authresult.hpp"
#include "playermanager.h"
#include "rsa.h" 
#include "glog.h" 
#include "stungameclient.hpp"
#include "Version_Info.h"
#include "laohu_checktoken.hpp"
#include "laohuproxyclient.hpp"

namespace GNET
{

class Response : public GNET::Protocol
{
	#include "response"

	void Process(Manager *manager, Manager::Session::ID sid)
	{
		GLog::log(LOG_INFO, "Response::Process, sid=%u, thread=%u, client_rand1_encoded=%s, account_encoded=%s, password_encoded=%s, client_id=%.*s, exe_ver=%.*s, res_ver=%.*s\n",
		          sid, (unsigned int)pthread_self(), B16EncodeOctets(client_rand1_encoded).c_str(), B16EncodeOctets(account_encoded).c_str(),
		          B16EncodeOctets(password_encoded).c_str(), (int)client_id.size(), (char*)client_id.begin(), (int)exe_ver.size(),
		          (char*)exe_ver.begin(), (int)res_ver.size(), (char*)res_ver.begin());

//{
//AuthResult prot;
//prot.retcode = ERR_CODE_WRONG_VERSION;
//manager->Send(sid, prot);
//return;
//}

#if 0
		{
			std::string ver_key = std::string((char*)client_id.begin(), client_id.size());
			std::string exe_str = std::string((char*)exe_ver.begin(), exe_ver.size());
			std::string res_str = std::string((char*)res_ver.begin(), res_ver.size());
			SGT_Version_Info version_info = SGT_Version_Info::GetInstance();
			VersionDataList *version_list = version_info._data._version_info.Find(ver_key);

			if(version_list == NULL)
			{
				return;
			}

			if(version_list->Size() == 0)
			{
				return;
			}
			
			VersionDataListIter version_iter = version_list->SeekToBegin();
			VersionData *last_ver, *version_data = version_iter.GetValue();
			bool ver_flag = false;
			while(version_data != NULL)
			{
				last_ver = version_data;
				if(version_data->_exe_ver == exe_str && version_data->_res_ver == res_str)
				{
					ver_flag = true;
					break;
				}
				version_iter.Next();
				version_data = version_iter.GetValue();
			}

			if(ver_flag == false)
			{
				ver_flag = true;
				std::vector<int> cur_res_ver, result_res_ver;
				int cur_exe_ver = atoi(exe_str.c_str());
				int result_exe_ver = atoi(version_data->_exe_ver.c_str());

				if(result_exe_ver > cur_exe_ver)
				{
					ver_flag = false;
				}

				//��res_ver���зָ�
				char *p = NULL, *outer_ptr = NULL;
				p = strtok_r((char *)res_str.c_str(), ".", &outer_ptr);
				while(p)
				{
					cur_res_ver.push_back(atoi(p));
					p = strtok_r(NULL, ".", &outer_ptr);
				}

				p = NULL;
				outer_ptr = NULL;
				p = strtok_r((char*)version_data->_res_ver.c_str(), ".", &outer_ptr);
				while(p)
				{
					result_res_ver.push_back(atoi(p));
					p = strtok_r(NULL, ".", &outer_ptr);
				}
				
				if(cur_res_ver.size() != result_res_ver.size())
				{
					ver_flag = false;
				}
	
				for(int size = 0; size < (int)cur_res_ver.size(); size++)
				{
					if(cur_res_ver[size] > result_res_ver[size])
					{
						break;
					}
					else if(cur_res_ver[size] < result_res_ver[size])
					{
						ver_flag = false;
						break;
					}
				}
			
				if(ver_flag == false)
				{
					AuthResult prot;
					prot.retcode = ERR_CODE_WRONG_VERSION;
					manager->Send(sid, prot);
					return;
				}
			}
		}
#endif
		
#ifdef ENABLE_RSA
		Octets prikey;
		prikey.push_back(RSA_D,strlen(RSA_D)+1);
		Octets client_rand1 = rsa_decode(prikey,client_rand1_encoded);
#else
		Octets client_rand1 = client_rand1_encoded;
#endif
		//fprintf(stderr, "-------client_rand1=%s,  client_rand1_encoded=%s\n", B16EncodeOctets(client_rand1).c_str(),B16EncodeOctets(client_rand1_encoded).c_str());

		if(client_rand1.size() != CONN_CONST_RAND1_SIZE) return;

		Octets server_rand1;
		Octets trans_token;
		//if(!GateServer::GetInstance()->FindSession(sid, status, server_rand1, trans_token)) return;
		if(!GateServer::GetInstance()->FindSessionAndChangeStatus(sid, GateServer::SESSION_STATUS_WAITING_RESPONSE, GateServer::SESSION_STATUS_PROCESSING_RESPONSE, server_rand1, trans_token)) return;

		//_key1
		Octets _key1;
		_key1.resize(CONN_CONST_RAND1_SIZE);
		for(auto i=0; i<CONN_CONST_RAND1_SIZE; ++i)
		{
			((unsigned char*)_key1.begin())[i] = ((unsigned char*)server_rand1.begin())[i]^((unsigned char*)client_rand1.begin())[i];
		}
		//enc_key, dec_key
		Octets dec_key(_key1.begin(), CONN_CONST_RAND1_SIZE/2);
		//Octets enc_key((unsigned char*)_key1.begin()+CONN_CONST_RAND1_SIZE/2, CONN_CONST_RAND1_SIZE/2);
		//_enc_sec1/_dec_sec1
		//Security *_enc_sec1 = Security::Create(ARCFOURSECURITY);
		//_enc_sec1->SetParameter(enc_key);
		Security *_dec_sec1 = Security::Create(ARCFOURSECURITY);
		_dec_sec1->SetParameter(dec_key);
		//TODO: SDKVerify
		Octets account = account_encoded;
		_dec_sec1->Update(account);
		Octets password = password_encoded;
		_dec_sec1->Update(password);
		_dec_sec1->Destroy();
		//strip
		//int password_len = 0;
		//for(; password_len<(int)password.size() && ((unsigned char*)password.begin())[password_len]; password_len++);
		//Octets password_new = Octets(password.begin(), password_len);
		//compare
		//Octets da("duxiaogang", strlen("duxiaogang"));
		//Octets dp("123456", strlen("123456"));
		//if(account!=da || password_new!=dp)
		//if(account.size()==0 || password_new!=dp)
		if(account.size()==0 || password.size()==0)
		{
			AuthResult prot;
			prot.retcode = ERR_CODE_WRONG_ACCOUNT_OR_PASSWORD;
			manager->Send(sid, prot);
			return;
		}

//#define _LAOHU_
#ifdef _LAOHU_
		Laohu_CheckToken check_prot;
		check_prot.account = account;
		check_prot.token = password;
		check_prot.client_sid = sid;
		check_prot._key1 = _key1;
		LaohuProxyClient::GetInstance()->SendProtocol(check_prot);

		GateServer::GetInstance()->FindSessionAndChangeStatus(sid, GateServer::SESSION_STATUS_PROCESSING_RESPONSE, GateServer::SESSION_STATUS_WAITING_CHECKTOKEN_RE, server_rand1, trans_token);
#else
		//GateServer::GetInstance()->MapAccount(account, sid); //TODO:
		//Auth OK
		CACHE::PlayerManager::GetInstance().OnConnect(account, trans_token, _key1);

		AuthResult prot;
		prot.retcode = 0;
		prot.trans_ip = TransServer::GetInstance()->GetPublicAddress();
		prot.trans_port = 65536-TransServer::GetInstance()->GetPublicPort(); //TODO:
		prot.udp_trans_ip = UDPTransServer::GetInstance()->GetPublicAddress();
		prot.udp_trans_port = 65536-UDPTransServer::GetInstance()->GetPublicPort();
		prot.stund_ip = STUNGameClient::GetInstance()->GetStundPublicAddress();
		prot.stund_port = STUNGameClient::GetInstance()->GetStundPublicPort();
		prot.trans_token = trans_token;

		//sign
		Octets tmp;
		tmp.push_back(&prot.retcode, sizeof(prot.retcode));
		tmp.push_back(prot.trans_ip.begin(), prot.trans_ip.size());
		tmp.push_back(&prot.trans_port, sizeof(prot.trans_port));
		tmp.push_back(prot.udp_trans_ip.begin(), prot.udp_trans_ip.size());
		tmp.push_back(&prot.udp_trans_port, sizeof(prot.udp_trans_port));
		tmp.push_back(prot.stund_ip.begin(), prot.stund_ip.size());
		tmp.push_back(&prot.stund_port, sizeof(prot.stund_port));
		tmp.push_back(prot.trans_token.begin(), prot.trans_token.size());
		prot.signature = UDPSignature(tmp, _key1);

		manager->Send(sid, prot);

		GLog::log(LOG_INFO, "Response::Process, sid=%u, thread=%u, account=%.*s\n",
		          sid, (unsigned int)pthread_self(), (int)account.size(), (char*)account.begin());

		GateServer::GetInstance()->FindSessionAndChangeStatus(sid, GateServer::SESSION_STATUS_PROCESSING_RESPONSE, GateServer::SESSION_STATUS_OK, server_rand1, trans_token);
#endif
	}
};

};

#endif
