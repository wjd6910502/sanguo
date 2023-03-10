
#ifndef __GNET_GETIATEXTINSPEECHRE_HPP
#define __GNET_GETIATEXTINSPEECHRE_HPP

#include "localdefs.h"
#include "callid.hxx"
#include "state.hxx"


namespace GNET
{

class GetIATextInSpeechRe : public GNET::Protocol
{
	#include "getiatextinspeechre"

	void Process(Manager *manager, Manager::Session::ID sid)
	{
		
		//GLog::log(LOG_INFO, "GetIATextInSpeechRe  chat_type = %d, tt_content = %.*s, sh_content=%.*s ", chat_type,(int)text_content.size(),(char*)text_content.begin(),(int)speech_content.size(), (char*)speech_content.begin());
		//找到当前用户
		printf("****************************************************\n");
		printf("*****************getiatextinspeechre****************\n");
		printf("****************************************************\n");
		Player* player = CACHE::PlayerManager::GetInstance().FindByRoleId(src_id);
		if(player == NULL)
		{
			printf("cann't find role........");
			return;
		}

		//内部类型 chat_type: 0 代表公聊  1 代表私聊	
		std::string msg;
		switch(chat_type)
		{
			case 0 :
				msg = "10102:";
				break;
			case 1 :
				msg = "10101:";
				break;
			default :
				break;
		}
				
		Octets tt_context,sp_context;
		Base64Encoder::Convert(tt_context,text_content);
		Base64Encoder::Convert(sp_context,speech_content);
		
		char tt[32];
		snprintf(tt,sizeof(tt),"%d:",time);

		msg += tt;
		msg += std::string((char*)tt_context.begin(),tt_context.size());
		msg += ":";
		msg += std::string((char*)sp_context.begin(),sp_context.size());
		msg += ":";
		char cc[32];
		
				
			
		if( chat_type == 0 )
		{
			//printf("getiatextinspeechre.hpp channel = %s\n",cc);
			//这里channel 分出来type和channel type 代表语音1 应客户端要加一个
			int tmp_type = chat_channel/100;
			int tmp_channel = chat_channel%100;
			snprintf(cc,sizeof(cc),"%d:%d:",tmp_channel,tmp_type);
			msg += cc;

			MessageManager::GetInstance().Put(src_id, src_id, msg.c_str(), 0);		
		}	

		if( chat_type == 1 )
		{
			Octets destId;
			Base64Encoder::Convert( destId,dest_id);
			msg += std::string((char*)destId.begin(),destId.size());
			msg += ":";
			
			int tmp_type = chat_channel;
			snprintf(cc,sizeof(cc),"%d:",tmp_type);
			msg += cc;

			std::vector<int64_t> v;
			Int64  target((char *)dest_id.begin());	
			v.push_back(target);
			Int64  srcid(src_id);
			v.push_back(srcid);
	
			MessageManager::GetInstance().Put(src_id, src_id, msg.c_str(), 0 ,&v);
			//MessageManager::GetInstance().Put(target, target, msg.c_str(), 0 ,&v); 
		}		
	}
};

};

#endif
