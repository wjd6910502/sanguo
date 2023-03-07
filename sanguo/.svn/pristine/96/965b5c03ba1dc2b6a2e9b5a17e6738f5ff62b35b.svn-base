#include "gamedbmanager.h"

#include "conf.h"
#include "storage.h"
#include "dbbuffer.h"
#include "parsestring.h"
#include "conv_charset.h"

#include "log.h"
#include "gamedbserver.hpp"

namespace GNET
{
//	void GameDBManager::ReadConfig()
//	{
//		StorageEnv::Storage * pconfig  = StorageEnv::GetStorage("config");
//		Marshal::OctetsStream key, value;
//		StorageEnv::AtomTransaction txn;
//		key << 0;
//		if(pconfig->find(key,value,txn))
//		{
//			value >> config;
//		}
//		else
//		{
//			config.init_time = time(NULL);
//			config.open_time = 0;
//			config.import_time = 0;
//			pconfig->insert( key, Marshal::OctetsStream()<<config, txn );
//		}
//	}
//
//	bool GameDBManager::SetZoneid(int zid, int aid)
//	{
//		if(zoneid!=0 && zoneid!=zid)
//		{
//			Log::log( LOG_ERR, "DB::SetZoneid: zoneid=%d received from DS, no equal to local copy(%d).", zid, zoneid);
//			zoneid = -1; // DS重连后注册了一个不同的zoneid，设置为无效， 禁止创建角色
//			return false;
//		}
//		if(zid<=0)
//		{
//			Log::log( LOG_ERR, "DB::SetZoneid: invalid zoneid=%d received from DS.", zid);
//			zoneid = -1;
//			return false;
//		}
//		zoneid = zid;
//		areaid = aid;
//		return true;
//	}
//
//	void GameDBManager::OnCreateRole()
//	{
//		bool open = false;
//		// 新架设服务器启动后创建超过500个角色，即认为已经对外开放
//		if(config.open_time==0)
//		{
//			Thread::Mutex::Scoped l(locker);
//			create_count++;
//			open = create_count>500;
//		}
//		if(open)
//		{
//			StorageEnv::Storage * pconfig  = StorageEnv::GetStorage("config");
//			Marshal::OctetsStream key;
//			StorageEnv::AtomTransaction txn;
//			key << 0;
//
//			//config.open_time = time(NULL);
//			struct tm tm;
//			time_t now = time(0);
//			localtime_r(&now, &tm);
//			tm.tm_sec = 0;
//			tm.tm_min = 0;
//			tm.tm_hour = 0;
//			config.open_time = mktime(&tm);
//
//			pconfig->insert( key, Marshal::OctetsStream()<<config, txn );
//			SendDBServerInfo();
//		}
//	}
//	void GameDBManager::InitGUID()
//	{
//		guid = (int64_t)Timer::GetTime() * 0x100000000LL;
//		StorageEnv::Storage * plog  = StorageEnv::GetStorage("syslog");
//		Marshal::OctetsStream key, value;
//		StorageEnv::AtomTransaction txn;
//		key << guid;
//		printf("GUID start from %lld\n",guid);
//		while(plog->find(key,value,txn));
//		{
//			key.clear();
//			guid += 0x100000000LL;
//			key << guid;
//		}
//	}
//
//	bool GameDBManager::InitGameDB()
//	{
//		Conf* conf = Conf::GetInstance();
//		//get deleterole_timeout
//		deletetimeout = atoi( conf->find("gamedbd","role_delete_timeout").c_str() );
//		if(deletetimeout < 30)
//			deletetimeout = 30;
//			
//		Log::log( LOG_INFO, "InitGameDB:role_delete_timeout:%d\n",deletetimeout);
//
//		ReadConfig();
//
//		if(!EraseTimer::Instance()->Initialize())
//			return false;
//
//		InitGUID();
//		return true;
//	}
//
//	bool GameDBManager::CheckImport(const char* file, int &new_import_time)
//	{
//		int import_time = config.import_time;
//
//		std::ifstream ifs;
//		ifs.open(file);
//		if(ifs.is_open())
//		{
//			TiXmlDocument doc;
//			ifs >> doc;
//			TiXmlNode *node = doc.FirstChild();
//			while(node && node->Type() != TiXmlNode::COMMENT)
//				node = node->NextSibling();
//			const char* v = node->Value();
//			int version;
//			sscanf(v,"%*s%*d%d",&version);
//			if(version != import_time)
//			{
//				new_import_time = version;
//				ifs.close();
//				return true;
//			}
//			ifs.close();
//		}
//		return false;
//	}
//
//	void GameDBManager::UpdateImportTime(int new_time)
//	{
//		StorageEnv::Storage * pconfig  = StorageEnv::GetStorage("config");
//		Marshal::OctetsStream key;
//		StorageEnv::AtomTransaction txn;
//		key << 0;
//		config.import_time = new_time;
//		pconfig->insert( key, Marshal::OctetsStream()<<config, txn );
//		SendDBServerInfo();
//	}
//
//	void GameDBManager::SendDBServerInfo()
//	{
//		DBServerInfo prot;
//		prot.db_config = config;
//		GameDBServer::GetInstance()->Send2Delivery(prot);
//	}
//
//	int GameDBManager::GetDayOfOpen() const
//	{
//		if(config.open_time == 0) return 0;
//		int n = (Timer::GetTime()-config.open_time-1800/*留30分钟做保险吧*/)/86400+1;
//		if (n < 1) n = 1;
//		return n;
//	}
//
//	void GameDBManager::SetOpenTime(int t)
//	{
//		StorageEnv::Storage * pconfig  = StorageEnv::GetStorage("config");
//		Marshal::OctetsStream key;
//		StorageEnv::AtomTransaction txn;
//		key << 0;
//		config.open_time = t;
//		pconfig->insert( key, Marshal::OctetsStream()<<config, txn );
//		SendDBServerInfo();
//	}
//
//	void GameDBManager::AddCompensate(int seq,int begin,int end,int msgid,int item_tid,int create_early_than,int level_min,int duration,Octets subject,
//			Octets context)
//	{
//		CREATE_TRANSACTION(txnobj, txnerr, txnlog)
//		LOCK_TABLE(compensate)
//		START_TRANSACTION
//		{
//			Compensate cp;
//			cp.seq = seq;
//			cp.begin = begin;
//			cp.end = end;
//			cp.msgid = msgid;
//			cp.item_tid = item_tid;
//			cp.create_early_than = create_early_than;
//			cp.level_min = (unsigned char)level_min;
//			cp.subject = subject;
//			cp.context = context;
//			Marshal::OctetsStream key;
//			key << seq;
//			compensate->insert( key, Marshal::OctetsStream()<<cp, txnobj );
//
//			Log::formatlog("add_compensate","seq=%d:begin=%d:end=%d:msgid=%d:item_tid=%d:create_early_than=%d:level_min=%d:duration=%d",seq,begin,end,msgid,item_tid,create_early_than,level_min,duration);
//		}
//		END_TRANSACTION
//
//		if(txnerr)
//		{
//			Log::log( txnlog, "DB::AddCompensate: (%d) %s",txnerr,GamedbException::GetError(txnerr));
//		}
//	}
//
//	int GameDBManager::InnerAddCash(ruid_t roleid,int cash)
//	{
//		int ret = 0;
//		GRoleStatus st;
//		GRoleBase roleBase;
//		int64_t old_cash_total_add = 0;
//
//		CREATE_TRANSACTION(txnobj, txnerr, txnlog)
//		LOCK_TABLE(status)
//		LOCK_TABLE(base)
//		START_TRANSACTION
//		{
//			bool isForbid = false;	
//			Marshal::OctetsStream(base->find(Marshal::OctetsStream()<<roleid, txnobj)) >> roleBase;
//			std::vector<GRoleForbid>::iterator it;	
//			for(it = roleBase.forbid.begin(); it != roleBase.forbid.end(); it++)
//			{
//				if(it->type == GNET_FORBID_LOGIN)
//				{
//					if(it->createtime+180<Timer::GetTime() && it->createtime+it->time>Timer::GetTime())
//					{
//						isForbid = true;
//						break;
//					}
//				}
//			}
//			if(isForbid)
//			{
//				Marshal::OctetsStream(status->find(Marshal::OctetsStream()<<roleid, txnobj)) >> st;
//				old_cash_total_add = st.cash_total_add;
//				st.cash_total_add += cash;
//				if (st.cash_total_add < old_cash_total_add)
//					throw GamedbException(ERROR_DB_VERIFYFAILED);
//
//				status->insert(Marshal::OctetsStream()<<roleid, Marshal::OctetsStream()<<st, txnobj);
//				ret = cash;
//
//				Log::formatlog("inner_add_cash", "roleid=%lld:old_cash_total_add=%lld:cash_total_add=%lld",
//				               roleid, old_cash_total_add, st.cash_total_add);
//			}
//		}
//		END_TRANSACTION
//		
//		if(txnerr)
//		{
//			Log::log(txnlog, "DB::InnerAddCash, roleid=%lld, old_cash_total_add=%lld, cash_total_add=%lld, (%d) %s",
//			         roleid, old_cash_total_add, st.cash_total_add, txnerr, GamedbException::GetError(txnerr));
//		}
//
//		return ret;
//	}
//
//	int GameDBManager::AddCash4R(int64_t seq,ruid_t roleid,int cash,int rmb)
//	{
//		GRoleStatus st;
//		int64_t old_cash_total_add = 0;
//		int64_t old_cash_can_use = 0;
//		int64_t old_rmb_total_add = 0;
//
//		CREATE_TRANSACTION(txnobj, txnerr, txnlog)
//		LOCK_TABLE(order4r)
//		LOCK_TABLE(status)
//		START_TRANSACTION
//		{
//			Marshal::OctetsStream value;
//			if (order4r->find(Marshal::OctetsStream()<<seq, value, txnobj))
//				return 0;
//
//			Marshal::OctetsStream(status->find(Marshal::OctetsStream()<<roleid, txnobj)) >> st;
//			old_cash_total_add = st.cash_total_add;
//			old_cash_can_use = st.cash_can_use;
//			old_rmb_total_add = st.rmb_total_add;
//			st.cash_total_add += cash;
//			st.cash_can_use += cash;
//			st.rmb_total_add += rmb;
//			if (st.cash_total_add<old_cash_total_add || st.cash_can_use<old_cash_can_use || st.rmb_total_add<old_rmb_total_add)
//				throw GamedbException(ERROR_DB_VERIFYFAILED);
//
//			status->insert(Marshal::OctetsStream()<<roleid, Marshal::OctetsStream()<<st, txnobj);
//			order4r->insert(Marshal::OctetsStream()<<seq, Marshal::OctetsStream()<<roleid, txnobj);
//
//			Log::formatlog("add_cash_4_r", "seq=%lld:roleid=%lld:cash=%d:rmb=%d:old_cash_total_add=%lld:cash_total_add=%lld,old_cash_can_use=%lld,cash_can_use=%lld,old_rmb_total_add=%lld,rmb_total_add=%lld",
//			               seq, roleid, cash, rmb, old_cash_total_add, st.cash_total_add, old_cash_can_use, st.cash_can_use, old_rmb_total_add, st.rmb_total_add);
//			//TODO:
//			return 0;
//		}
//		END_TRANSACTION
//		
//		if(txnerr)
//		{
//			Log::log(txnlog, "DB::AddCash4R, seq=%lld, roleid=%lld, cash=%d, rmb=%d, (%d) %s",
//			         seq, roleid, cash, rmb, txnerr, GamedbException::GetError(txnerr));
//		}
//		return 1;
//	}
//
//	void GRoleBaseToDetail( const GRoleBase & base, GRoleDetail & detail )
//	{
//		detail.baseinfo.roleid = base.roleid;
//		detail.baseinfo.name = base.name;
//		detail.baseinfo.gender = base.gender;
//		detail.baseinfo.idphoto = base.idphoto;
//		detail.baseinfo.faceid = base.faceid;
//		detail.baseinfo.hairid = base.hairid;
//		detail.baseinfo.haircolor = base.haircolor;
//		detail.baseinfo.skincolor = base.skincolor;
//		detail.baseinfo.beardid = base.beardid;
//		detail.baseinfo.tattoo = base.tattoo;
//		detail.baseinfo.sharp = base.sharp;
//		detail.baseinfo.clothesid = base.clothesid;
//		detail.create_time = base.create_time;
//		detail.title = base.title;
//		detail.jointime = base.join_time;
//	}
//
	int GamedbException::ConvertError(int e)
	{
		switch(e)
		{
			case WDB_NOTFOUND:		return ERROR_DB_NOTFOUND;
			case WDB_OVERWRITE:		return ERROR_DB_OVERWRITE;
			case WDB_KEYSIZE_ZERO:		return ERROR_DB_NULLKEY;
		}
		return ERROR_DB_UNKNOWN;
	}
	const char* GamedbException::GetError(int e)
	{
		switch(e)
		{
			case ERROR_DB_NOTFOUND:        return "record not found";
			case ERROR_DB_OVERWRITE:       return "cannot overwrite";
			case ERROR_DB_NULLKEY:         return "key length is zero";
			case ERROR_DB_DECODE:          return "error occur while decoding record";
			case ERROR_DB_INVALIDINPUT:    return "argument verification failed";
			case ERROR_DB_UNKNOWN:         return "unknown error";
			case ERROR_DB_DISCONNECT:      return "db disconnected";
			case ERROR_DB_TIMEOUT:         return "timeout"; 
			case ERROR_DB_NOSPACE:         return "no space";
			case ERROR_DB_VERIFYFAILED:    return "verification failed";
			case ERROR_DB_CASHOVERFLOW:    return "cash overflow";
		}
		return "";
	}

};

