#ifndef _PWRD_H_
#define _PWRD_H_

#include <sys/poll.h>
#include <string>
#include <map>

#include <protocol.h>

enum PWRD_CONST
{
	PWRD_CONST_CMD_BUFF_SIZE			= 1000,
	PWRD_CONST_RESP_BUFF_SIZE			= 100000,
	PWRD_CONST_POLLFD_COUNT_MAX			= 100,
};

class PWRD
{
	enum SESSION_STATUS
	{
		SESSION_STATUS_READING_GM_CMD		= 0, //�ȴ�gm command
		SESSION_STATUS_WAITING_GAMED_RESP	= 1, //�ȴ�gamed�������
		SESSION_STATUS_SENDING_GM_RESP		= 2, //�ȴ����ͽ����gm
		SESSION_STATUS_ERROR			= 3, //�����ˣ�session�����������������κι���
	};
	enum SESSION_STATUS_TIMEOUT
	{
		SESSION_STATUS_READING_GM_CMD_TO	= 3,
		SESSION_STATUS_WAITING_GAMED_RESP_TO	= 10,
		SESSION_STATUS_SENDING_GM_RESP_TO	= 3,
	};

	struct Session //����gm������
	{
	public:
		int _id; //session id
		int _fd;
		int _status;
		time_t _timeout;
		char _cmd_buff[PWRD_CONST_CMD_BUFF_SIZE+1];
		int _cmd_buff_index; //������д����
		char _resp_buff[PWRD_CONST_RESP_BUFF_SIZE+1];
		int _resp_buff_index; //�Ѿ����͵�����
		int _resp_buff_count; //��β����
		std::string _resp_4_timeout; //gamed��ʱ������ʱ��gm�ķ���
		bool _no_more_data;

		Session();

		bool IsError() const { return (_status==SESSION_STATUS_ERROR); }
		bool NeedRead() const { return (_status==SESSION_STATUS_READING_GM_CMD); }
		bool NeedWrite() const { return (_status==SESSION_STATUS_SENDING_GM_RESP); }
		void OnRead();
		void OnWrite();
		void OnError(int err);
		void OnRecvResp(const char *resp); 
		void OnHeartbeat(time_t now);

	private:
		bool HaveWholeCmd() const;
		std::string Pop1Cmd(); //���������յ���cmd
		void TryProcessCmd();
		bool TryProcessXml(std::string cmd); //����xml
	};

	int _listen_fd;
	int _session_id_stub;
	std::map<int, Session*> _session_map; //id=>session
	std::map<int, Session*> _fd_session_map; //fd=>session
	time_t _prev_heartbeat;

	//��ʱ����
	pollfd _pollfd[PWRD_CONST_POLLFD_COUNT_MAX];
	int _pollfd_count;

	PWRD();

public:
	static PWRD& GetInstance()
	{
		static PWRD instance;
		return instance;
	}

	void Start(unsigned short port);
	void Update();
	void OnRecvResp(int sess_id, const char *resp);
	std::string Identification() const { return "PWRD"; }

private:
	void PreparePollFD();
};

#endif //_PWRD_H_
