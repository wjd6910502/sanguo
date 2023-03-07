/*
 *		RPCͷ�ļ�����
 *		���ߣ�δ֪
 *		�޸ģ�������
 *		ʱ�䣺2009-07
 *		��˾������ʱ��
 *
 */
#ifndef __RPC_H_
#define __RPC_H_

#include "protocol.h"

namespace GNET {

class Rpc : public TimerProtocol
{
public:
	struct Data : public Marshal
	{
		virtual ~Data() { }
		virtual Data *Clone() const = 0;
		virtual void Destroy() { delete this; }
		virtual Data& operator = (const Data &rhs) { return *this; }
	};
	union AuxData
	{
		int i;
		int save_sid;
		int id[2];
		uint32_t u32;
		uint64_t u64;
		void *ptr;
	};
	typedef unsigned int XID;
public:
	AuxData _auxdata;	//���ظ������ݣ����ڱ���һЩ��Ϣ����rpc���÷���ʱ����������Щ��Ϣ�������ݲ��ᱻmarshal�����͡�
	Data *argument;		//���õĲ���
	Data *_result;		//���
	unsigned int _xid;	//�������ֲ�ͬ��Rpcʵ��, ���һλ��ʾ�������ǻ�Ӧ
public:
	inline static bool IsRequest(unsigned int xid) { return xid & 0x80000000; }
	inline static void SetRequest(unsigned int& xid) {xid |= 0x80000000;}
	inline static void ClrRequest(unsigned int& xid) {xid &= 0x7FFFFFFF;}

	Rpc(){}
	Rpc(PROTOCOL_TYPE type, ProtocolStubManager *stubman, Data* arg, Data *res):
		TimerProtocol(type, stubman),argument(arg), _result(res){}
	Rpc(PROTOCOL_TYPE type, Data* arg, Data *res):TimerProtocol(type, ProtocolStubManager::GetGlobalStub()),argument(arg), _result(res){}
	Rpc(Data *arg, Data *res):argument(arg), _result(res) { }
        Rpc(const Rpc &rhs) : TimerProtocol(rhs), argument(rhs.argument->Clone()), _result(rhs._result->Clone()),
				_xid(rhs._xid){}
	virtual ~Rpc()
	{
		argument->Destroy();
		_result->Destroy();
	}
	static Rpc *Call(PROTOCOL_TYPE type, const Data *arg, PManager *manager);
	static Rpc *Call(PROTOCOL_TYPE type, const Data &arg, PManager *manager) { return Call(type, &arg,manager); }

	static Rpc *Call(PROTOCOL_TYPE type, const Data *arg);						// ���ֵ��õļ�����
	static Rpc *Call(PROTOCOL_TYPE type, const Data &arg) { return Call(type, &arg); }		// ���ֵ��õļ�����
private:
	virtual OctetsStream& marshal(OctetsStream &os) const;
	virtual const OctetsStream& unmarshal(const OctetsStream &os);
	virtual void Process(PManager *manager, SESSION_ID sid);	//Э��Ĵ������������Ƿ�����������Server��Client
	virtual void Server(Data *argument, Data *result, PManager *manager, SESSION_ID sid) { Server(argument,result); } //���ܷ��Ĵ���
	virtual void Client(Data *argument, Data *result, PManager *manager, SESSION_ID sid) { Client(argument,result); } //�յ�����Ľ��
	virtual void Server(Data *argument, Data *result) {  }
	virtual void Client(Data *argument, Data *result) {  }
	virtual void OnTimeout() { OnTimeout(argument); }
	virtual void OnTimeout(Data *argument) { }	//��ʱ
};

}
#endif
