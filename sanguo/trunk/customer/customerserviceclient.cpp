//#include "customer.cpp"
#include "customerserviceclient.hpp"
#include "state.hxx"
#include "customerrequest.hpp"

namespace GNET
{

CustomerServiceClient CustomerServiceClient::instance;

const Protocol::Manager::Session::State* CustomerServiceClient::GetInitState() const
{
	return &state_CustomerServiceClient;
}

void CustomerServiceClient::OnAddSession(Session::ID sid)
{
	Thread::Mutex::Scoped l(locker_state);
	if (conn_state)
	{
		Close(sid);
		return;
	}
	conn_state = true;
	this->sid = sid;

	cout << "CustomerServiceClient::OnAddSession" << endl;
	//在这里对参数进行处理
	{
		//<variable name="typ" type="int" attr="ref" comm="命令的类型"/>
		//<variable name="role_id" type="int64_t" attr="ref" comm="被操作的玩家"/>
		//<variable name="time" type="int" attr="ref" comm="禁言或者禁止登录的时间"/>
		//<variable name="notice" type="Octets" attr="ref" comm="全服公告"/>
		//<variable name="mail_id" type="int" attr="ref" comm="给玩家发送的邮件,如果配置了这个，那么下面的三个都不会生效"/>
		//<variable name="title" type="Octets" attr="ref" comm="邮件的标题"/>
		//<variable name="content" type="Octets" attr="ref" comm="邮件的内容"/>
		//<variable name="mail_item" type="std::vector&lt;Item&gt;" attr="ref" comm="邮件的附加物品"/>
		//1全服关闭，进行维护
		CustomerRequest command;
	cout << "CustomerServiceClient::OnAddSession" << endl;
		command.typ = typ;
	cout << "CustomerServiceClient::OnAddSession" << endl;
		if(command.typ == 1)
		{
	cout << "CustomerServiceClient::OnAddSession" << endl;
		}

		if(!CustomerServiceClient::GetInstance()->SendProtocol(&command))
		{
			cout << "send error" << endl;
		}

	}
}

void CustomerServiceClient::OnDelSession(Session::ID sid)
{
	Thread::Mutex::Scoped l(locker_state);
	conn_state = false;
}

void CustomerServiceClient::OnAbortSession(const SockAddr &sa)
{
	Thread::Mutex::Scoped l(locker_state);
	conn_state = false;
}

void CustomerServiceClient::OnCheckAddress(SockAddr &sa) const
{
}

};
