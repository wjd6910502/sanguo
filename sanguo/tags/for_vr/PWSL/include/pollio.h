/*
		POLL IO ���ṩ��һ��ʹ��EPOLL��·���ý������ӹ���Ľӿڡ�
		����: ����
		��˾������ʱ��
		���ڣ�2009-06-08

2011-06-16�޸ģ� 
		������Ӧ�ò���ӳٹ��ܣ����ڱ���ǳ���İ����͡� Ĭ������ӳٹ����ǹرյġ� 
		����Session��Ӧ�õ���Manager��  SetSessionDelayMode �����������磺 manager.SetSessionDelayMode(session_id, false);
		����ӳ�������ȫ�ֲ������Ե�������ʱ��ʱ������ݰ��Ĵ�С��ֵ��ʹ�����º����������� ioman.SetDelayThreshold(50,500); ���ֵӦ��ֻ�ڳ�ʼ��ʱ���á�
*/


#ifndef __GNET_IOMAN_POLLIO_H
#define __GNET_IOMAN_POLLIO_H
#include "marshal.h"
#include "ASSERT.h"

namespace GNET
{

class PollIO;
class IOManImp;
class IOMan			//IO������
{
	IOManImp * _imp;
	friend class PollIO;
	friend class StreamIO;
	friend class SSLIO;
	void UpdateIOEventMask(PollIO * io, int mask1);		//���ڲ�ʹ�ã����治Ҫ��
public:
	Marshal::OctetsStream input_data;	//use in protocol.cpp

	struct IO_EVENT_T 
	{
		struct CONTROL_T
		{
			int mask1;
			int mask2;
			bool update;
		}control[2];

		IO_EVENT_T()
		{
			control[0].mask1 = 0;
			control[0].mask2 = 0;
			control[0].update = false;
			control[1].mask1 = 0;
			control[1].mask2 = 0;
			control[1].update = false;
		}
	};


	IOMan();
	~IOMan();

	PollIO* Register(PollIO *io, bool init_permit_recv, bool init_permit_send);
	int Init(bool single_thread);
	void WakeUp();
	void Poll(int timeout);
	bool IsSingleThread();
	unsigned int GetPollCount();	//ȡ�ص���poll�Ĵ���
	void Fini();			//��IOMan������������ע���PollIO����. ע�⣬���Ӧ���������ã���Ҫ��timer,threadpoolͣ���ٵ���
	bool IsFinalizing();		//�Ƿ���������(�ڵ�����Fini�����ֵ�᷵��true)
	void SetDelayThreshold(int milisecond, uint32_t size = 500);	//����������delayģʽ��IO�������ӳٶ�ý��з��ͣ����ֵ����С��20���롣 size ��һ���ֽ����ƣ����һ�η��ͺ��ۼƳ�����ô�����ݣ������ͼ��ǰ���� 
public:
	static IOMan _man;	//Ϊ����ģʽ׼���ģ�ƽʱҲ������
};

struct SockAddr;
class PollIO			//IO�Ļ��࣬һ�㲻ֱ��ʹ�ã�NetIO �����̳ж���
{
protected:
	IOMan * _parent;			//���IO�����Ǹ�IO Man
private:
	int  _cur_event;			//��ǰҪ֪ͨ���¼������������IOMan����ά��
	bool _tcp_nodelay;			//�Ƿ����ڲ�ִ������tcp_delay�Ĳ��� ,�����false�������һЩ�ӳٺͻ��ۡ�����Ϊ�˱���Nagle�㷨�����Ĳ��ɿص���ʱ�Ϳ���TCP_NODELAY��ĸߴ���ռ�ã��Ӷ������һ��ƽ����� Ĭ��ֵΪtrue
	struct IOMan::IO_EVENT_T _event_notify;	//Ҫ�޸ĵ������¼���ϣ����������io�����޸ģ�IOmanʹ��
	struct timeval _send_timeval;		//���һ�η������ݵ�ʱ���


	virtual void PollIn()  = 0;
	virtual void PollOut() {}
	virtual void PollClose() {}
	virtual void BeforeRelease() = 0;
	virtual void CommitRelease() {delete this;}
	virtual size_t IOWaitSize() const { return 0;}	//����Ϊ���ж����ֽڵȴ����� 

	virtual void OnRegister() {}

	friend class IOMan;
	friend class IOManImp;
public:
	virtual bool CanTransferFD() const { return false;}
	virtual int WriteThrough(const void * buf, size_t size, const SockAddr * dest = NULL) {return -1;}      //����protocol session ֱдʹ�� StreamIO�� DgramDummyIOʵ����
	virtual void OnWeakClose() {}

protected:
	int _fd;		//���ӵ��ļ�����������PollIO�Ĺ��캯������������������Ϊ������IO

	virtual ~PollIO();
	PollIO(int fd);

	void InnerClose(); 	//�ڲ��ر�ʵ��

public:	

	inline int GetFD() { return _fd;}	//ע�⣬ ������TCP/UDP/UNIX socket

	void PermitRecv();
	void PermitSend();
	void ForbidRecv();
	void ForbidSend();
	virtual void Close();		//Ĭ�ϵ��õ�InnerClose�� DgramServerDummyIO���õļ�ʵ��

	inline void SetDelayMode(bool nodelay) { _tcp_nodelay = nodelay; }
	inline bool GetDelayMode() const { return _tcp_nodelay;}

	static bool CompatibleMode();	//���IO��ӿڼ���ģʽ
	static bool VerboseMode();	//�д�����Ϣ���ģʽ

#ifdef __OLD_IOLIB_COMPATIBLE__
	static void WakeUp()
	{
		IOMan::_man.WakeUp();
	}
	static int Init(bool single_thread_mode)
	{
		if (!CompatibleMode()) 
		{
			ASSERT(false && "��ʹ�õ�IO��̬�ⲻ֧�ּ���ģʽ������");
		}
		return IOMan::_man.Init(single_thread_mode);
	}

	static void Poll(int t)
	{
		IOMan::_man.Poll(t);
	}
#endif
};

};

#endif

