/*
		����ʵ��ʹ�õ�NetIO���ͣ��ֱ�֧��Stream(TCP)��Dgram(UDP)��
		���ߣ�δ֪
		�޸ģ�2009-06-16 ���� ������֯�˴���ṹ�����󲿷ִ����ƶ�����Դ�ļ��� ͬʱ��StreamIO��PollOut�����˳��׵��޸� ��ͼ�����ڴ渴��/�ƶ� �ͼ�����ʱ�䡣
		��˾������ʱ��
*/

#ifndef __NETIO_H
#define __NETIO_H

#include <stdio.h>
#include <unistd.h>
#include <string>
#include <stdlib.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <map>

#include "octets.h"
#include "pollio.h"

namespace GNET
{

struct SockAddr
{
	Octets addr;
public:	
	SockAddr() {}
	template<typename T> SockAddr(const T &sa) : addr(&sa, sizeof(sa)) { }
	SockAddr(const SockAddr &rhs) : addr(rhs.addr) { }
	socklen_t GetLen() const { return addr.size(); }

	bool operator < (SockAddr & rhs) const { return addr < rhs.addr;}
	template<typename T> operator T* () { addr.resize(sizeof(T)); return (T *)addr.begin(); }
	template<typename T> operator const T* () const { return (const T *)addr.begin(); }
};

enum { 
	CLOSE_ONRECV  	= 0x10000, // �Զ˵���close�����ر�
	CLOSE_ONRESET 	= 0x20000, // ���ӱ��Զ�reset
	CLOSE_ONSEND  	= 0x30000, // ����ʱ��������
	CLOSE_ACTIVE  	= 0x40000, // ���������ر�����
	CLOSE_ONERROR 	= 0x50000, // Э���������״̬����
	CLOSE_TIMEOUT 	= 0x60000, // Session״̬��ʱ
	CLOSE_EXPIRE  	= 0x70000, // ��������TTL��ʱ�����ر�
	CLOSE_EXCEPTION = 0x80000, // ����Э��ʱ�����쳣
	CLOSE_DETACH	= 0x90000, // SESSION��Detach��ȥ
};

class NetSession;
class NetIO : public PollIO
{
protected:
	NetSession *session;
	NetIO(int fd, NetSession *s);

	virtual size_t IOWaitSize() const;
	virtual int WriteThrough(const void *buf, size_t size, const SockAddr *dest = NULL);
	virtual void OnWeakClose(NetSession * session) {}
};

class StreamIO : public NetIO
{
	virtual void PollIn();
	virtual void PollOut();
	virtual void PollClose();
	virtual void OnRegister();
	virtual void BeforeRelease();
	inline int SendOBuffer(Octets & obuf, size_t & obuffer_size);
public:
	~StreamIO();
	StreamIO(int fd, NetSession *s);
};

class UnixIO : public NetIO	//֧���ļ����������ݵ�IO
{
	virtual void PollIn();
	virtual void PollOut();
	virtual void PollClose();
	virtual void OnRegister();
	virtual void BeforeRelease();
	virtual bool CanTransferFD() const { return true;}
public:
	~UnixIO();
	UnixIO(int fd, NetSession *s);
};

class DgramClientIO : public NetIO
{
	SockAddr peer;
	virtual void PollIn();
	virtual void PollOut();
	virtual void OnRegister();
	virtual void BeforeRelease();
public:
	~DgramClientIO();
	DgramClientIO(int fd, NetSession *s, const SockAddr &sa);
};

class DgramServerIO : public NetIO
{
	struct compare_SockAddr
	{
		bool operator() (const SockAddr &sa1, const SockAddr &sa2) const
		{
			const struct sockaddr_in *s1 = sa1;
			const struct sockaddr_in *s2 = sa2;

			return	s1->sin_addr.s_addr < s2->sin_addr.s_addr  ||
				(s1->sin_addr.s_addr == s2->sin_addr.s_addr && s1->sin_port < s2->sin_port);
		}
	};
	typedef std::map<SockAddr, NetSession *, compare_SockAddr> Map;
	Map map;
	int _associate_closing;

	void PollIn();
	void PollOut();
	virtual void BeforeRelease();

	virtual int WriteThrough(const void * buf, size_t size, const SockAddr * dest);
	virtual void OnWeakClose();
public:
	~DgramServerIO();
	DgramServerIO(int fd, NetSession *s);
};

/*
class DgramSvrIOAdapter : public NetIO
{
	DgramServerIO * _parentIO;
	void PollIn() {}
	void PollOut() {}
	virtual void BeforeRelease() {}	
	int WriteThrough(const void * buf, size_t size, const SockAddr * dest);
public:
	~DgramSvrIOAdapter();
	DgramSvrIOAdapter(DgramServerIO * parent, NetSession *s);
};
*/

};

#endif
