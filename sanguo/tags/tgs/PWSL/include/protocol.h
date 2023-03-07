/*
 *	��ͷ�ļ���Ҫʵ�����������ݣ�
 *	Э��Ļ��� class Procotol��Ϊ��������Э��������ϵ�Session�� class PSession ������һ�����Ӻ�һ��Э��Ĺ�����PManager�� 
 *	RPC/ProxyRPC�Ļ��� class TimerProtocol; RPC��ʱ�ʹ�������� class RpcTimeoutManager��
 *
 *	���ߣ����� ������
 *	�޸ģ������� ������ϵ������ȫ�䶯�������˹���ÿ��Manager��Э����ĸ����д�����д��� ���ļ�ֻ����GCC��ʹ��
 *	ʱ�䣺2009-07
 *	��˾������ʱ��
 *
*/
#ifndef __PROTOCOL_H_
#define __PROTOCOL_H_

#include <vector>
#include <set>
#include <hashmap.h>
#include <sstream>
#include "marshal.h"
#include "gnet_timer.h"
#include "mutex.h"
#include "threadpool.h"
#include "netsession.h"
#include "log.h"

namespace GNET
{

class PSession;
class PManager;
class ProtocolStubManager;
class IOMan;
class ActiveIO;
class PassiveIO;
class TimerProtocol;

typedef uint32_t PROTOCOL_TYPE;
typedef uint32_t SESSION_ID;
enum
{
	INVALID_SESSION_ID = 0
};

//ԭʼЭ�飬�������⴦����Զ���Э��
class RawProtocol 
{
public:
	virtual ~RawProtocol() {}
	virtual void Process(PManager *, SESSION_ID sid) = 0;	//Э��Ĵ�����
	virtual RawProtocol *Clone() const = 0;
	virtual int  PriorPolicy() const { return 0; }		//Э��Ĵ������ȼ����ɿ��г���������֤˳��, ��������Ч��˳�����GetSequence�ӿڡ� �ڼ���ģʽ�£���������ķ���ֵ������Sequence֮�á�
	virtual void Encode(Octets & os) const = 0;				//�������Э���������ϵ��ֽ�����ʲô����
	virtual const char *GetName() const { return "raw_protocol"; }//Э������ƣ��������ڵ������
	virtual void Destroy() { delete this; }
	virtual bool SizePolicy(size_t) const { return true; }	//Э���С�ļ��
	virtual int GetSequence() const { return -1;}		//�Ƿ���Ҫ��֤˳���� <0��ʾ��˳�򣬷�����˳���
	virtual std::string trace() const {return std::string();}	//Э������ݣ��������ڵ������
};

//��׼Э��
class Protocol : public Marshal
{
public:
	struct Data {
	/*	���DataӦ��ʵ�ֵĺ��� ��Щ������rpcgen�����Զ����ɣ��Զ����Э������Ҫ��д
		����ʵ����Ӧ��ʵ����ȷ�ĺ�����Ӱ���߼���
		PROTOCOL_TYPE GetType() const;								//����Э������
		GNET::Marshal::OctetsStream& marshal(GNET::Marshal::OctetsStream & os) const;		//���
		const GNET::Marshal::OctetsStream& unmarshal(const GNET::Marshal::OctetsStream &os);	//�����лָ�
		int PriorPolicy( ) const;								//���ȼ� 0��ʾ��ֱ����pollio�̴߳���
		bool SizePolicy(size_t size) const;							//��С�Ƿ�Ϸ�
		unsigned int MaxSize()	const;								//Data�������ܴ�С�Ƕ���
		
		��Ӱ���߼��ĺ�������Ӱ����־�����������Ϣ
		std::stringstream& trace(std::stringstream& os) const;					//dumpЭ��
		const char *GetName() const;								//Э���������������־��
		*/
	};
#ifdef __OLD_IOLIB_COMPATIBLE__
	typedef PROTOCOL_TYPE Type;			//�����Զ���
	typedef PManager Manager;			//�����Զ���
	Type type;
#endif
protected:
	Protocol() {}
	Protocol(PROTOCOL_TYPE type, ProtocolStubManager *stubman);
	Protocol(PROTOCOL_TYPE type);
	virtual ~Protocol(){}
public:
#ifdef __OLD_IOLIB_COMPATIBLE__
	virtual PROTOCOL_TYPE GetType() const { return type;}	//�����Դ���
	Protocol(const Protocol& rhs):type(rhs.type){}
	static ActiveIO*  Client(PManager * mananger);		//��Client��ʽ����manager
	static PassiveIO* Server(PManager * mananger);		//��Server��ʽ����manager
	static bool	  Dummy(PManager *manager);		//Dummy��ʽ����manager,���ַ�ʽ�£��������������������κζ˿ڣ�ֻ����AttachSession
	static ActiveIO*  Client(PManager * mananger,const NetSession::Config & cfg);	//��Client��ʽ����manager,ָ����ַ���˿ڵ�����
	static PassiveIO* Server(PManager * mananger,const NetSession::Config & cfg);	//��Server��ʽ����manager,ָ����ַ���˿ڵ�
#else
	virtual PROTOCOL_TYPE GetType() const= 0;		//Э�������
	Protocol(const Protocol& rhs){}
#endif

	virtual void Process(PManager *, SESSION_ID sid) = 0;	//Э��Ĵ�����
	virtual Protocol *Clone() const = 0;
	virtual void Destroy() { delete this; }
	virtual int  PriorPolicy() const { return 0; }		//Э��Ĵ������ȼ����ɿ��г���������֤˳��, ��������Ч��˳�����GetSequence�ӿڡ� �ڼ���ģʽ�£���������ķ���ֵ������Sequence֮�á�
	virtual unsigned int MaxPolicySize() const {return 0;}	//����0��ʾδ��������encode�Ż�
	virtual bool SizePolicy(size_t) const { return true; }	//Э���С�ļ��
	virtual int GetSequence() const { return -1;}		//�Ƿ���Ҫ��֤˳���� <0��ʾ��˳�򣬷�����˳���
	virtual const char *GetName() const { return "noname"; }//Э������ƣ��������ڵ������
	virtual std::string trace() const {return std::string();}	//Э������ݣ��������ڵ������

	void Encode(Marshal::OctetsStream& os) const ;		 //��Э�������������� �⺯��ʵ���ϵ�����PManager�Ľӿ�

	class Exception 
	{
	public:
	 	enum ECODE 
		{ 
			GENERIC,	//ͨ�ô���δ֪����)
			STATE, 		//��ǰSession��State���������Э��
			SIZE, 		//�յ���Э�鳤�ȳ������������󳤶�
			TYPE, 		//�յ���δ֪��Э������
			UNMARSHAL,	//�ڽ���Э���unmarshalʱ����
		};

		ECODE code;		//�쳣����
		SESSION_ID sid;		//�����쳣��session
		PROTOCOL_TYPE type;	//�����쳣��Э������
		size_t size;		//�����쳣ʱ��size
		std::string state_name; //�����쳣ʱ��state����
		int loglevel;
		std::string msg;	//�����쳣��ʾ�Ĵ�������

		Exception():code(GENERIC),sid(0), type(0), size(0), loglevel(LOG_DEBUG){}
		Exception(ECODE code, SESSION_ID sid, PROTOCOL_TYPE type, size_t size, const char* state_name, int loglevel):
		code(code), sid(sid), type(type), size(size), state_name(state_name), loglevel(loglevel) {}
		Exception(const char * msg):code(GENERIC),sid(0), type(0), size(0), loglevel(LOG_DEBUG),msg(msg){}
		Exception(std::string msg):code(GENERIC),sid(0), type(0), size(0), loglevel(LOG_DEBUG),msg(msg){}


		void Log() const
		{
			static const char *errstr[] = {"generic", "state", "size","unknown type", "unmarshal"};
			Log::log(loglevel, "Protocol %s error. sid=%d,type=%d,size=%d,state=%s-'%s'",
				errstr[code], sid, type, size, state_name.c_str(), msg.c_str());
		}
	};
};

class SessionState
{
	typedef std::set<PROTOCOL_TYPE> Set;
	Set set;	//��״̬�������Э��
	Set ignore;	//�ڸ�״̬�£��յ�����Ҫ������Э�顣�յ��Ȳ���set�У��ֲ���ignore�е�Э�飬�ᱻ�Ͽ�.
	int timeout;
	std::string name;
	public:
	SessionState (PROTOCOL_TYPE *first, size_t len, int t = 0, const char* pname=NULL) : set(first, first+len),timeout(t)
	{ if (pname) name = pname;}
	SessionState (PROTOCOL_TYPE *first, PROTOCOL_TYPE *last, int t = 0, const char*pname = NULL) : set(first, last), timeout(t) 
	{ if (pname) name = pname;}
	bool IgnorePolicy(PROTOCOL_TYPE type) const {return ignore.find(type) != ignore.end();}
	bool TypePolicy(PROTOCOL_TYPE type) const { return set.find(type) != set.end(); } 
	bool TimePolicy(int t) const { return timeout <= 0 || t < timeout; }
	const char *GetName() const {return name.c_str();}
	void AddProtocol(PROTOCOL_TYPE type) { set.insert(type);}
public:
	void AddIgnore(PROTOCOL_TYPE t) {ignore.insert(t);} //�յ�����Э����Ҫ���� �˺������̰߳�ȫ ���߳�ģʽ���� ������޸��ຯ��ͬ��
	void AddIgnore(PROTOCOL_TYPE *first, size_t len) {ignore.insert(first, first +len);}
	void AddIgnore(const SessionState *state) {ignore.insert(state->set.begin(), state->set.end());}
	void DelIgnore(PROTOCOL_TYPE t) {ignore.erase(t);} //
	void ClearIgnore(PROTOCOL_TYPE t) {ignore.clear();} 
};

struct FDTransferPData;
class PManager
{
	friend class PSession;
	friend class RawSession;
protected:
	//��PSession�Ĺ���
	typedef abase::hash_map<SESSION_ID, PSession *> SessionMap;
	SessionMap _map;		//��ǰsession��MAP
	RWLock _locker_session_map;	//����Map�Ĳ�����
	SESSION_ID _session_id;		//��һ������Session�� ID���������ÿ��Manager����һ���ռ��
	NetSession::Config _config;	//ActiveIO,PassiveIO��NetSession����Ҫ������
	PassiveIO *_assoc_passiveio;	//��Manager��������PassiveIO
	IOMan * _ioman;
	bool _single_thread;
	Runnable *_check_session_task;	//���ڼ��session���ڹرպͳ�ʱ��task

	void AddSession(SESSION_ID sid, PSession *session);
	void DelSession(SESSION_ID sid, int status);
	void AbortSession(const SockAddr &sa, PSession *);
	PSession *GetSession(SESSION_ID sid);
	inline SESSION_ID NextSessionID();

	inline void ProcessProtocol(Protocol *p, SESSION_ID sid);
	inline void ProcessProtocol(RawProtocol *p, SESSION_ID sid);
	static void PostEncode(PROTOCOL_TYPE, size_t size, const char *pname, const char *content);
	bool __internal_init_1(IOMan * ioman, const NetSession::Config* spec_config = NULL);
	bool __internal_init_2(IOMan * ioman);
protected:
	GNET::ThreadPool * _th_pool;		//�̳߳ض���ָ��
public:
	int protocol_count;
#ifdef __OLD_IOLIB_COMPATIBLE__
	class Session
	{
		public:
		typedef SESSION_ID ID;
		typedef SessionState State;
	};
#endif
	PManager();
	virtual ~PManager();

	//��Server��Client��ʽ����PManager
	PassiveIO* InitServer(IOMan *ioman );		//��Server��ʽ����manager,����ĳ�˿ڣ������ֿ��ܻ᷵��NULL: 1.���ü���ʧ��(conf::GetInstanceδ����). 2.�˿��ѱ�ռ��
	ActiveIO*  InitClient(IOMan *ioman );		//��Client��ʽ����manager,����ĳ�˿ڣ����ü���ʧ�ܼ�socket����ʧ��ʱ�᷵��NULL
	bool	   InitDummy(IOMan *ioman );		//��Dummy��ʽ��manager,���ַ�ʽ�²������������������κζ˿ڣ�ֻ�����ⲿ����session(AttachSession)
	PassiveIO* InitCopy(IOMan * ioman, const PManager * src);	//��ԭ����һ��Manager�������úͼ����Ķ˿ڣ�ʹ����dup2������һ��fd�� �̳߳ز�����и���
	PassiveIO* InitServer(IOMan *ioman, const NetSession::Config &cfg);//���ض�������������Server��ʽ��Manager,�����ټ��������ļ�
	ActiveIO* InitClient(IOMan *ioman, const NetSession::Config &cfg); //���ض�������������Client��ʽ��Manager,�����ټ��������ļ�

	void SetThreadPool(ThreadPool *pool) {_th_pool = pool;}		//��Manager������ĳ�̳߳�, ��manager�յ���Э�飬��������̳߳��е���Process��
	ThreadPool *GetThreadPool() {return _th_pool;}

	inline IOMan * GetIOMan() const { return _ioman;}

	//�޸�ĳһ��Session����������ʱ��Security
	bool SetISecurity(SESSION_ID sid, Security::Type type, const Octets &key);
	bool SetOSecurity(SESSION_ID sid, Security::Type type, const Octets &key);

	static void EncodeProtocol(const Protocol *, Marshal::OctetsStream& os);		 //��Э��������������
	static Protocol *DecodeProtocol(const Marshal::OctetsStream& is, PSession *s); 		//��һ�����н����Э��, ����Session��״̬
	Protocol *DecodeProtocol(const Marshal::OctetsStream& is) throw (Protocol::Exception); 	//��һ�����н����Э��

	void RawProcessProtocol(Protocol *, SESSION_ID sid);	//ֱ�Ӷ�Protocol����Process���Ჶ׽�쳣��
	void RawProcessProtocol(RawProtocol *, SESSION_ID sid);	//ֱ�Ӷ�Protocol����Process���Ჶ׽�쳣��
	//��session����һ��Э��
	bool Send(SESSION_ID id, const RawProtocol *protocol);
	bool Send(SESSION_ID id, const RawProtocol &protocol) { return Send(id, &protocol);}
	bool Send(SESSION_ID id, const Protocol *protocol, bool urg = false);
	bool Send(SESSION_ID id, const Protocol &protocol, bool urg = false) { return Send(id,&protocol,urg); }
	bool SendFD(SESSION_ID id, int fd, const Octets & o);
	bool SendFD(SESSION_ID id, int fd , const Protocol &protocol);	// for test...

	bool RawSend(SESSION_ID id, const Octets& o, bool urg = false); 	//��Session����һ��ԭʼ���ݣ�������ݱ����ܹ�����ȷ�Ľ���

	template<typename PDATA>
	static bool EncodeProtocolData(const PDATA & pdata, Marshal::OctetsStream& os)
	{
		//��Э�����ݽ��б��룬����os�ֽ�����, ��ʽΪ��
		//    [Э������]  [Э�鳤��] [����]
		//�°棬�Ż�����Э�鷢�� �����ٸ���һ�λ�����
		//��ѹ������Э�鳤�ȣ�Ȼ������ٶ�Э�鳤�Ƚ�������
		//��ҪProtocolData�ṩMaxSize()
		size_t size_policy = pdata.MaxSize();
		if(size_policy == 0) size_policy = 0x19999999;
		os << Marshal::Begin;
		os << CompactUINT(pdata.GetType());
		size_t offset = os.raw_size();
		os<< CompactUINT(size_policy);
		size_t offset2 = os.raw_size();
		pdata.marshal(os);
		size_t psize = os.raw_size() - offset2;
		if (psize <= size_policy)
		{
			os << SpecCompactUINT(offset, psize, size_policy);
			os << Marshal::Commit;
			if (PollIO::VerboseMode())
			{
				std::stringstream content;
				pdata.trace(content);
				PostEncode(pdata.GetType(), os.size(), pdata.GetName(),content.str().c_str());
			}
			return true;
		}
		os << Marshal::Rollback;
		Log::log(LOG_ERR,"FATAL, Protocol Size Excceed(type=%d,size=%d).", pdata.GetType(), psize);
		return false;
	}

	template<typename PDATA>
	bool SendProtocolData(SESSION_ID id, const PDATA * pdata, bool urg = false)
	{
		return SendProtocolData(id, *pdata, urg);
	}

	template<typename PDATA>
	bool SendProtocolData(SESSION_ID id, const PDATA & pdata, bool urg = false)
	{
		Marshal::OctetsStream os;
		if (EncodeProtocolData(pdata, os))
		{
			return RawSend(id, os, urg);
		}
		return false;
	}

#ifdef __OLD_IOLIB_COMPATIBLE__
	bool Close(SESSION_ID id, int status=CLOSE_ACTIVE, int delay_secs =0) { return CloseSession(id, status, delay_secs);}
	bool ChangeState(SESSION_ID id, SessionState *state, bool strict = true){return ChangeSessionState(id, state, strict);}
	void SetVerbose(SESSION_ID sid, int priority){ SetSessionLogPriority(sid, priority);}
#endif
	bool CloseSession(SESSION_ID id, int status=CLOSE_ACTIVE, int delay_secs = 0); 		//�����ر�һ��session, delay_secs��ָ�ӳٶ೤ʱ��رգ���λΪ�룩
												//�ӳ��ڼ䣬��Session���������κ�Э�飬�����Է���Э��,�൱�ڵ���ر�
												//���ӳ��ڼ����Ӷϵ��������ӳ٣�ֱ�ӽ���ر�״̬��
	bool ChangeSessionState(SESSION_ID id, SessionState *state, bool strict = true); 	//�ı�һ��session��State, �ϸ��strict�����ζ�ŵ��յ�����state�ж����Э�飬���Session��
	virtual void CheckSessionTimePolicy() {}				//����������Session�Ƿ�ʱ, ����IO���ڲ��Ѿ����� IsStatePolicyEnable�������Ƿ��Զ����Timeout���������ֶ�������
	void __CheckSessionTimeout();						//����������Session�Ƿ�ʱ���ýӿ�ֻ��IO���ڲ����á�
	void SetSessionLogPriority(SESSION_ID sid, int priority); 		//����ĳ��Session��Log���ȼ�
	void SetSessionDelayMode(SESSION_ID id, bool nodelay);

	int DetachSession(SESSION_ID sid, FDTransferPData & data);		//��Session�ӹ�����������(�����OnDelSession)������һ��fd,����FDTransferPData���type��customdata������г�Ա �����κδ��󷵻�-1
	SESSION_ID AttachSession(int socket_fd);				//Ϊĳ��FD������Ӧ��Session����ע�ᵽManager��(�����OnAddSession)��
										//(�����fd����socket���Ѿ����رգ���ע��ʧ��,����INVALID_SESSION_ID) ���򷵻� Session ID
	SESSION_ID AttachSession(int fd, const FDTransferPData & data);		//Ϊĳ��FD������Ӧ��Session�����Ҹ���data�ָ�sessionԭ�е�״̬ ����ֵͬ��
	SESSION_ID AttachSession(const FDTransferPData & data);			//ͬ�ϣ����Զ���FDStubManager��Ѱ��ƥ���FD
	SESSION_ID GetCurSessionID() const;					//ȡ����ǰ��SessionIDֵ��ֻ���ο����ж�����ʹ�ã���Ҫ���ؼ��߼�
	

	virtual void OnAddSession(SESSION_ID) = 0; 				//��һ��Session��ʱ
	virtual void OnAddSession(SESSION_ID sid, int fd); 			//��fd�Ĵ򿪲�����
	//��Session���ر�ʱ
	virtual void OnDelSession(SESSION_ID) = 0;
	virtual void OnDelSession(SESSION_ID sid, int status) {  OnDelSession(sid); }

	//����ʧ��ʱ, ���ڿͻ���
	virtual void OnAbortSession(SESSION_ID) { }
	virtual void OnAbortSession(const SockAddr&) { }
	
	virtual void OnSetTransport(SESSION_ID sid, const SockAddr& local, const SockAddr& peer) { }
	virtual bool OnCheckAccumulate(size_t) const { return true; }
	
	virtual bool OnSend(SESSION_ID id, const Protocol *protocol) { return true; }
	virtual const SessionState *GetInitState() const = 0; 		//Session�ĳ�ʼstate

	//�յ�δ֪��Э���
	virtual bool CheckUnknownProtocol(SESSION_ID , PROTOCOL_TYPE , unsigned int ) { return false; }
	virtual void DispatchUnknownProtocol(SESSION_ID , PROTOCOL_TYPE , const Marshal::OctetsStream & ) { }

	virtual void OnRecvSocket(PSession * session, Octets addr, int socket);	//��session������Unix Domain ���ӽ��յ���һ��socket��session���Ѿ������socket�ĺϷ��ԣ�
										//���������Ĭ��ʵ���ǵ�����FDStubManager::Register��������Լ�����ʵ�֣��������ش˺���
										//addr�����socket�ı��ص�ַ�˿�+�ⲿ��ַ�˿ڣ�����δ���������ݵ�ʹ��
										//�����������session����״̬�£���PollIO�̵߳��õģ���˲�Ҫʹ�÷������ݺ������ܹ�ֱ�Ӻͼ��ʹsession�����Ĺ���

	virtual void OnSessionException(const Protocol::Exception& e)  //ĳ��Session�����쳣��e�а����˷����쳣ʱ��һЩ������Ϣ
	{ 
		e.Log(); 
		CloseSession (e.sid, CLOSE_EXCEPTION); 
	}
	virtual bool IsStatePolicyEnable() const {return true;}			//�Խ��յ���Э��"����"��"״̬"�Ƿ������,�Լ��Ƿ����״̬��ʱ��
										//˫��������ʱΪtrue��������ʱ���Է���false
										//Ϊfalseʱ������յ���manager�޹ص�δ֪Э�飬�ᴥ����δ֪Э�顱���쳣����Ȼ���ԶϿ���
	virtual bool IsTrustable() const {return false;}			//��Manager�����е�Session�Ƿ��ǿ��ŵ�, ������ָ�ͱ�manager��������Щsession������ͼ�����ƭ��
										//���ŵĻ�����Щ�ڲ��ļ���ſ�һ�������ֻ���ڲ�����Ż����ÿ��š�
	virtual std::string Identification() const = 0;				//��Manager��Config�ļ��еı�ʶ
	virtual void OnCheckAddress(SockAddr &) const { } 			//����Ϊ��InitServer��InitClient��Manager���󶨻�ʹ�õ�IP��ַ�˿�

	virtual bool LoadSessionConfig(NetSession::Config &cnf) 		//����Manager�����ã�ΪActiveIO��PassiveIO���ò���, ��InitXXXϵ��ʹ��ʱ���á�����ѡ�񲻴�conf����ȡ
	{
		return cnf.Load(Identification().c_str());
	}
	virtual const ProtocolStubManager * GetStubManager() const; 		//�����������Ĵ��������, �ڼ���ģʽ�£�����ȫ�ֹ�����������IO�£�����Ҫ��д���������

public:
	//����FD�ĺ�����link�����ӿͻ��˵��ⲿmanager, tunnel�������ڲ���������manager, tunnel_sid�Ƕ�ӦUnixDomain��session��
	//		fd_trans_p_type�����û������Э��ţ��û���Ҫ�Լ�ע�����Э��Ų���ȷ����ַ�, customdata���û��Զ�������ݣ��ᷢ�͵�tunnel������һ�ˣ��������д���
	//		tunnelĿ�Ķ˻��յ����fd��Э�� fd_trans_p_type(ʵ��������һ��FDTransferPData(FDTransferProtocol) �û���Ҫ�ֶ�ע��fd_trans_p_type�Ͷ�Ӧ�Ĵ�����
	//		tunnelĿ�Ķ˻����յ�fd��Ȼ�����addrΪkey,fd Ϊvalue������FDStubManager�У�Ȼ���յ�Э��FDTransferPData����ʱӦ��data�е�addr�ҵ�ָ����fd��Ȼ��ʹ��Attach���ܹ�������Ҫ�����Manager�ϡ�
	//		����AttachSessionʱ������õ�Register ���������̵���OnAddSession
	static bool TransferFD(PManager *link, SESSION_ID link_sid, PManager * tunnel, SESSION_ID tunnel_sid, PROTOCOL_TYPE fd_trans_p_type, const Octets & customdata);
	//�ڷַ�Э�鵽�̳߳���֮ǰ�������ٴ��޸����ȼ���˳��š���ţ���������rpcalls.xml�е�Ϊ׼, ������ʹ�õ��̳߳ء�
	//sequence��groupΪ-1ʱ����ʾû��˳��Ż���š�
	//priorΪ0ʱ����ֱ�Ӵ��� sequence��group��С��0ʱ�������ThreadPool��PolicyAddTask
	//��groupС��0ʱ��group_seq������
	//ע�⣺1.����ProxyRpc���ԣ�SendManager��RecvManager����ͬһ��Э��Ĵ���Ӧ����ȫ��ͬ
	//	2.��Э���Process��Rpc��Client��Server��OnTimeout,�Լ�Proxy��PostProcess,Delivery,OnTimeout��������ʱ���Ѿ����˺��ʵ��̳߳���
	virtual void TranslateProtocolAttr(const Protocol *p, SESSION_ID sid, GNET::ThreadPool* &thpool, int & prior, int & sequence, int & group, int & group_seq) {}
};

class ProtocolStubManager
{
	typedef abase::hash_map<PROTOCOL_TYPE, abase::pair<Protocol*, bool> > StubMap;
	StubMap _map;
public:
	ProtocolStubManager() {}
	~ProtocolStubManager();

	bool InsertStub(Protocol*);			//����Э����(�ɵ������ͷŴ��)
	bool InsertStub(PROTOCOL_TYPE type, Protocol*);	//��������������Protocol���ڹ��죬�в��ܵ���GetType()ʱ(�ɵ������ͷŴ��)
	bool InsertStub2(PROTOCOL_TYPE type, Protocol*);	//�������������StubManager���ͷ�
	const Protocol *GetStub(PROTOCOL_TYPE type) const; 	//��ȡ���
	Protocol * CreateProtocol(PROTOCOL_TYPE type) const; 	//����һ��Э��

	static ProtocolStubManager * GetGlobalStub();	//���ּ����Զ��ṩ��ȫ�ִ��
};

class FDStubManager		//���ڴ���FD����ʱά�����ݽṹ�����ڴ�������fd���ֲܷ��ڶ��Manager��������FDStubManager��ȫ�ֵ�
{
	static FDStubManager _manager;
	typedef std::pair<int,time_t> FD_ELEMENT;
	typedef std::map<Octets, FD_ELEMENT > MAP;
	MAP _fd_map;
	time_t _last_checktimeout;

	GNET::Mutex _locker;
public:
	enum
	{
		CHECK_INTERVAL = 10,	//ÿ����������һ�γ�ʱ
		CHECK_TIMEOUT = 30,	//30�볬ʱʱ�䣬Ӧ���Ѿ��㹻��
	};
	static FDStubManager & GetInstance() { return _manager;}

	FDStubManager():_last_checktimeout(0) {}

	void Register(Octets addr, int fd);				//����һ��fd
	int FindAndGet(Octets addr);					//ȡ��һ��fd
	void CheckTimeout(int timeout);					//��鳬ʱ	�����ڵ��ã��ڲ����ʱ�����������ÿ10�������������һ��

};

struct FDTransferPData  : public Protocol::Data
{
	PROTOCOL_TYPE type;
	Octets addr;
	Octets o_plainbuf;
	Octets o_outputbuf;
	Octets o_securebuf;
	Octets i_securebuf;
	Octets custom_buf;

public:
	FDTransferPData():type((PROTOCOL_TYPE)-1) {}	//Ĭ����һ����Ч��type 
	FDTransferPData(PROTOCOL_TYPE type):type(type) {}

	PROTOCOL_TYPE GetType() const { return type;}
	GNET::Marshal::OctetsStream& marshal(GNET::Marshal::OctetsStream & os) const
	{
		os << addr << o_plainbuf << o_outputbuf << o_securebuf << i_securebuf << custom_buf;
		return os;
	}

	const GNET::Marshal::OctetsStream& unmarshal(const GNET::Marshal::OctetsStream &os)
	{
		os >> addr >> o_plainbuf >> o_outputbuf >> o_securebuf >> i_securebuf >> custom_buf;
		return os;
	}

	int PriorPolicy( ) const {return 110;}	//����һ�����֣��������������FDTransferProtocol����
	bool SizePolicy(size_t size) const {return true;}
	unsigned int MaxSize() const {return 0x19999999;}
		
	std::stringstream& trace(std::stringstream& os) const { os << "FDTransferPData:NULL"; return os;}
	const char *GetName() const { return "FDTransferPData";}
};

//FDTransferProtocolģ�壬�����Ҫ����FD�����ڽ��ն˴����������ش��ಢ�ֶ����ע�����
class FDTransferProtocol : public Protocol
{
protected:
	FDTransferPData  _data;
public:

	FDTransferProtocol(){}
	FDTransferProtocol(PROTOCOL_TYPE type, ProtocolStubManager *stubman):Protocol(type, stubman){ _data.type = type;}
	FDTransferProtocol(PROTOCOL_TYPE type):Protocol(type){ _data.type = type;}
	FDTransferProtocol(const FDTransferProtocol &rhs) : _data(rhs._data){}

	PROTOCOL_TYPE GetType() const {return _data.GetType();}
	OctetsStream& marshal(OctetsStream & os) const { return _data.marshal(os); }
	const OctetsStream& unmarshal(const OctetsStream &os) { return _data.unmarshal(os); }
	const char * GetName() const { return _data.GetName(); }
	std::string trace() const { std::stringstream os; return _data.trace(os).str();}
	int PriorPolicy() const { return _data.PriorPolicy();}
	bool SizePolicy(size_t size) const { return _data.SizePolicy(size); }
};

class TimerProtocol: public Protocol
{
protected:
	Timer _timer;
public:
	TimerProtocol(){}
	TimerProtocol(PROTOCOL_TYPE type, ProtocolStubManager *stubman):Protocol(type, stubman){}
	TimerProtocol(PROTOCOL_TYPE type):Protocol(type){}
	TimerProtocol(const TimerProtocol& rhs):Protocol(rhs){ _timer.Reset();}
	virtual ~TimerProtocol() {}
	virtual void OnTimeout() =0;
	virtual bool TimePolicy(int t) const {return t <5;}
	bool  CheckTime() const { return TimePolicy(_timer.Elapse());}
};

class ChannelProtocol : public Protocol         //ͨ��Э��, ��Э���а�������һ����Э��
{
public:
	ChannelProtocol() {}
	ChannelProtocol(PROTOCOL_TYPE type, ProtocolStubManager *stubman):Protocol(type,stubman){}
	ChannelProtocol(PROTOCOL_TYPE type):Protocol(type) {}

	typedef std::set<PROTOCOL_TYPE> PSET;
	virtual const PSET& GetProtocolSet() const = 0;		//��ͨ��Э�������������Э���б�
	virtual Octets& GetChannelData() = 0;			//Э������(��Э�����������)��д���麯����ϣ����ԭIO���rpcgen���ݣ����ѱ���������

	void SetupChannelData(const Protocol &p) {SetupChannelData(&p);}        //������Э��
	void SetupChannelData(const Protocol *p)
	{
		const PSET & Set = GetProtocolSet();
		ASSERT(Set.find(p->GetType()) != Set.end());

		Marshal::OctetsStream os;
		PManager::EncodeProtocol(p,os);
		GetChannelData() = os;
	}
	template<typename PDATA>
	void SetupChannelPData(const PDATA &pdata)		//��ProtocolData�ķ�ʽ������Э��
	{
		Marshal::OctetsStream os;
		PManager::EncodeProtocolData(pdata, os);
		GetChannelData() = os;
	}
	bool CheckChannelData();				//�����Э�������Ƿ�Ϸ���Э�������Ƿ������������Э���б��У�,���ݴ���ʱ����false,���һ��log
	Protocol *DecodeChannelData(PManager *manager);		//����ͨ��Э�����ݣ�������Э����󣬸���Э����ʹ��������Destroy�����ݸ�ʽ����ʱ�᷵��NULL,�����һ��log
};
}

#endif

