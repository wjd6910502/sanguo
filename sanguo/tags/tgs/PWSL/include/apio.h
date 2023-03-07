/*
	�����������ӵ�ActiveIO�͵ȴ����ӵ�PassiveIO�� ����ActiveIO�������ӳɹ��Ժ�ת����ΪStreamIO�������ڲ������Session����PassiveIO���������ӽ���󣬴���һ��StreamIO�������ڲ�session��clone����
	���ߣ�δ֪
	�޸ģ�2009-07 ������
	��˾������ʱ��

*/


#ifndef __ACTIVEIO_PASSIVEIO_H
#define __ACTIVEIO_PASSIVEIO_H


#include "pollio.h"
#include "netio.h"

namespace GNET
{
class NetSession;
class ActiveIO : public PollIO
{
	enum Type { STREAM, DGRAM , STREAM_UNIX};
	Type _type;
	NetSession *_assoc_session;
	SockAddr _sa;

	void PollIn()  { Close(); } //��������������ġ�
	void PollOut() { Close(); CheckConnectResult();} //���յ�POLLOUT�¼�ʱ������������ʽ���ӵĽ��������, ���ɹ����

	ActiveIO(int fd, const SockAddr &saddr, const NetSession &s, Type t);
	void CheckConnectResult();  //����Ƿ����ӳɹ����ɹ��Ļ�������һ��StreamIO

	~ActiveIO() { }
	void BeforeRelease();
public:
	static ActiveIO *Open(IOMan*, const NetSession &assoc_session);
};

class PassiveIO : public PollIO
{
	enum Type { STREAM, DGRAM ,STREAM_UNIX};
	NetSession *_assoc_session;
	Type _type;
	DgramServerIO *_dgram_server_io;

	void Accept();

	void PollIn() { Accept();}  //�������ɶ��¼�ʱ���������µ����ӹ�����

	PassiveIO (int x, const NetSession &y, Type t);
	virtual ~PassiveIO ();

	void BeforeRelease() {}
public:
	static PassiveIO *Open(IOMan*, const NetSession &assoc_session);

	PassiveIO * Dup() {return new PassiveIO(dup(_fd), *_assoc_session, _type); }	//����һ����Ȼ��Register����IoMan��
};

};

#endif
