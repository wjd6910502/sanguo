
#ifndef __GNET_GMCMD_ADDFORBIDWORD_HPP
#define __GNET_GMCMD_ADDFORBIDWORD_HPP

#include "localdefs.h"
#include "callid.hxx"
#include "state.hxx"


namespace GNET
{

class GMCmd_AddForbidWord : public GNET::Protocol
{
	#include "gmcmd_addforbidword"

	void Process(Manager *manager, Manager::Session::ID sid)
	{
		GLog::log(LOG_INFO, "gamed::GMCmd_AddForbidWord::Process, words=%.*s, session_id=%d", 
				(int)words.size(), (char*)words.begin(), session_id);

		GMCmd_AddForbidWord_Re resp;

#if 0
		std::string forbidword = std::string((char*)words.begin(), words.size());
		int locate = 0;
		locate = forbidword.find(" ");
		if(locate==-1)
		{
			int have_flag = 0;
			ForbidWordListIter iter = SGT_Misc::GetInstance()._miscdata._forbidword.SeekToBegin();
			Str* s = iter.GetValue();
			while(s!=NULL)
			{
				if(s->_value==forbidword)
				{
					have_flag = 1;
					break;
				}
				iter.Next();
				s = iter.GetValue();
			}

			if(have_flag==0)
			{
				Str sword;
				sword._value = forbidword;
				SGT_Misc::GetInstance()._miscdata._forbidword.PushBack(sword);
			}
		}
		else
		{
			forbidword += " ";
			while(locate!=-1)
			{
				std::string word = forbidword.substr(0, locate);

				int have_flag = 0;
				ForbidWordListIter iter = SGT_Misc::GetInstance()._miscdata._forbidword.SeekToBegin();
				Str* s = iter.GetValue();
				while(s!=NULL)
				{
					if(s->_value==word)
					{
						have_flag = 1;
						break;
					}
					iter.Next();
					s = iter.GetValue();
				}

				if(have_flag==0)
				{
					Str sword;
					sword._value = word;
					SGT_Misc::GetInstance()._miscdata._forbidword.PushBack(sword);
				}


				forbidword = forbidword.substr(locate+1, forbidword.size());
				locate = forbidword.find(" ");
			}

		}
#endif
		resp.retcode = 0;
		resp.session_id = session_id;
		manager->Send(sid, resp);
	}
};

};

#endif
