#ifndef __ACTIVESSLIO_H
#define __ACTIVESSLIO_H

#include <sys/types.h>
#include <sys/socket.h>
#include <sys/un.h>
#include <netinet/in.h>
#include <netinet/tcp.h>
#include <arpa/inet.h>
#include <unistd.h>
#include <errno.h>

#include "conf.h"
#include "pollio.h"
#include "netio.h"
#include "netsession.h"
#include <openssl/ssl.h>

/* SSL的PollIO, 用于Https或其它SSL链接*/
/* SSL协议工作流程：
服务器认证阶段：
1）客户端向服务器发送一个开始信息“Hello”以便开始一个新的会话连接；
2）服务器根据客户的信息确定是否需要生成新的主密钥，如需要则服务器在响应客户的“Hello”信息时将包含生成主密钥所需的信息；
3）客户根据收到的服务器响应信息，产生一个主密钥，并用服务器的公开密钥加密后传给服务器；
4）服务器恢复该主密钥，并返回给客户一个用主密钥认证的信息，以此让客户认证服务器。

用户认证阶段：
在此之前，服务器已经通过了客户认证，这一阶段主要完成对客户的认证。
经认证的服务器发送一个提问给客户，客户则返回（数字）签名后的提问和其公开密钥，从而向服务器提供认证。
*/

namespace GNET
{

struct SSLCTX_Info	//函数中传递CTX所使用的结构
{
	SSL_CTX *pctx;
	enum { FLAG_NEED_RELEASE = 0x1, FLAG_PASSIVE = 0x2, FLAG_DEBUG = 0x4,};
	int flag;
	SSLCTX_Info():pctx(0), flag(0){}
	SSLCTX_Info(SSL_CTX *ctx, int f): pctx(ctx), flag(f){}
};

class SSLIO : public NetIO
{
	enum {NONE, CONNECT, ACCEPT, READ, WRITE};
	SSL *pSSL;
	int pending_action;
	SSLCTX_Info ctx_info;
	void DoRead();
	void DoSend(bool is_repeat);
	void DoConnect();
	void DoAccept();
	void PollIn();
	void PollOut();
	void PollClose();

	static void trace_callback(const SSL *s, int where, int ret);

	virtual void BeforeRelease();

public:
	~SSLIO();
	SSLIO(int fd, NetSession *s,SSLCTX_Info info);
};


struct SSLCTX_Helper	//SSLCTX辅助生成
{
	SSL_METHOD *m_pmeth;
private:
	SSLCTX_Helper() 
	{
		SSL_library_init();
		SSL_load_error_strings();
		//m_pmeth = SSLv3_method();
		m_pmeth = TLSv1_method();
	}
public:
	//创建CTX，程序结束时，要在某个地方释放.
	//capath   证书列表所在路径, 凡是在这里的RootCA, 都是可信任的，对方用这里的CA，本端认为合法, 可以为空，谁都不信任
	//certfile 本次CTX所使用的证书(即经过CA验证签名的公钥) (本端使用)
	//keyfile  密钥文件(必须和证书匹配)
	static SSL_CTX * MakeCTX(const char *capath, const char *cafile, const char *certfile, const char *keyfile);

	//从内存中加载，要求CA, key都是DER格式。
	//openssl x509 -inform der -in aps.cer -out aps.pem  # CER本身就是DER格式。如果想要PEM,用此方式转。
	//openssl pkcs12 -in key.p12 -out key.pem   #p12到pem  从p12到pem
	//openssl rsa -in key.pem -inform PEM -out key.der -outform DER   从pem到der
	static SSL_CTX * MakeCTX_FromMem(unsigned char *ca, size_t ca_len, unsigned char *cert, size_t cert_len, unsigned char *key, size_t key_len);
	static void FreeCTX(SSL_CTX *pctx)
	{
		if (pctx) SSL_CTX_free(pctx);
	}
};

class ActiveSSLIO : public PollIO
{
	NetSession *assoc_session;
	SockAddr sa;
	SSLCTX_Info ctx_info;

	void PollIn()  { Close(); CheckConnectResult();}
	void PollOut() { Close(); CheckConnectResult();}
	virtual void BeforeRelease();

	ActiveSSLIO(int x, const SockAddr &saddr, const NetSession &s, SSLCTX_Info info);
	void CheckConnectResult();
	~ActiveSSLIO();
	static ActiveSSLIO *Open(IOMan * ioman, const NetSession &assoc_session, SSLCTX_Info info);
public:
	static ActiveSSLIO *Open(IOMan * ioman, const NetSession &assoc_session); 

	//由外部传入的SSL_CTX.
	//由于加载证书需要读盘， 不建议在服务器运行中，或重连服务器时再次加载证书
	//这时可以在程序启动时读好，再传入
	static ActiveSSLIO *Open(IOMan * ioman,const NetSession &assoc_session, SSL_CTX *pctx, int flag =0) 
	{
		if (pctx == NULL) return NULL;
		return Open(ioman, assoc_session, SSLCTX_Info(pctx, flag));
	}
};

class PassiveSSLIO : public PollIO
{
	NetSession *assoc_session;
	SSLCTX_Info ctx_info;
	void PollIn();
	PassiveSSLIO (int x, const NetSession &y, SSLCTX_Info info);
	virtual ~PassiveSSLIO ();
	static PassiveSSLIO *Open(IOMan * ioman, const NetSession &assoc_session, SSLCTX_Info info);
	static void PrintBindErrorAndExit(const char *ident, unsigned short port, int bind_errno)
	{
		printf ("%s bind port %d error: %s.\n", ident, port, strerror(bind_errno));
		exit(1);
	}
	virtual void BeforeRelease() {}
public:
	static PassiveSSLIO *Open(IOMan * ioman, const NetSession &assoc_session);
	
	//由外部传入的SSL_CTX.
	//对服务器而言，一般不需重新加载证书，也就不需重新读盘。
	//但为了保持和activesslio的一致性，仍然可以从外部传入
	static PassiveSSLIO *Open(IOMan * ioman, const NetSession &assoc_session, SSL_CTX *pctx, int flag = 0)
	{
		if (pctx == NULL) return NULL;
		return Open(ioman, assoc_session, SSLCTX_Info(pctx, flag | SSLCTX_Info::FLAG_PASSIVE));
	}
};

};

#endif
