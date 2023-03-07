#ifndef _HTTP_PROTOCOL_H
#define _HTTP_PROTOCOL_H

#include "protocol.h"
//HTTPЭ���ʵ��
//
//����ʵ�ֵ����ܽ��� http Э��Ŀͻ��˺ͷ�������manager.
//Ŀǰhttp serverֻ����GET����
//��������֪ͨ yangyanzhao00972@wanmei.com

namespace GNET {

class HttpProtocol : public RawProtocol
{
public:
	HttpProtocol() {}
	virtual void Init(std::string& firstline, std::map<std::string, std::string>&headers_, Octets& body_) =0;

	//URL�����ַ��� 	[A-Za-z0-9] | "-" | "_" | "." | "~" 
	//�����ַ��� 		"!" | "*" | "'" | "(" |  ")" | ";"  | ":"| "@" | "&" | "=" | "+" | "$" | "," | "/" | "?" | "#" | "[" | "]"
	//ת���ַ�:		"%" <HEX> <HEX>

	//���url����ĳ��Ƭ�ϲ��ǿ����ַ��еķ�Χ�������б���
	static std::string UrlEncode(const std::string& szToEncode);
	//���header�е�Content-type�� application/x-www-form-urlencoded, �ͱ�����н���
	static std::string UrlDecode(const std::string& szToDecode);
};

class HttpManager : public PManager
{
public:
	HttpManager(){}
	//�ڽ��ܵ��Է���Ϣʱ����Manager��������ʲô����Э�飬������Request����response
	//��server���ԣ�Ӧ�ô���Request�͵ģ���client��Ӧ����Response��
	virtual HttpProtocol * CreateHttpProtocol() const = 0;
	//���Э���ֽڣ���ֹ�Է������������ݹ���
	virtual size_t MaxProtocolSize() const {return 4*1024*1024;}

	PollIO* InitHttpServer(IOMan *ioman , bool is_ssl = false, const NetSession::Config * cfg = NULL);  //��Server��ʽ����manager,����ĳ�˿ڣ������ֿ��ܻ᷵��NULL: 1.���ü���ʧ��(conf::GetInstanceδ����). 2.�˿��ѱ�ռ��
	PollIO* InitHttpClient(IOMan *ioman , bool is_ssl = false, const NetSession::Config * cfg = NULL);  //��Client��ʽ����manager,����ĳ�˿ڣ����ü���ʧ�ܼ�socket����ʧ��ʱ�᷵��NULL
};


//HTTP����
class HttpRequest : public HttpProtocol
{
public:
	std::string method;	//��Ĭ��ΪGET
	std::string url;	//�������Դ
	std::string version;	//�汾�ţ���Ĭ��ΪHTTP/1.1
	Octets body;		//���������ݣ�����Ϊ��. ������Ƕ�������ʱ��������Content-Type
	std::map<std::string, std::string> headers; //ͷ����HTTP/1.1ʱ��������Host

	HttpRequest();
	virtual void Init(std::string& first_line_, std::map<std::string, std::string>& headers_, Octets& body_);
	virtual void Encode(Octets & os) const;
	virtual HttpRequest * Clone() const { return new HttpRequest(*this);}
	void dump()
	{
		Octets tmp;
		Encode(tmp);
		printf ("%.*s\n", (int)tmp.size(), (char*)tmp.begin());
	}
	virtual void Process(PManager *, SESSION_ID sid)  {}
};
//HTTP��Ӧ
class HttpResponse: public HttpProtocol
{
public:
	int status;
	Octets body;
	std::map<std::string, std::string> headers;
	HttpResponse():status(200){}
	virtual void Init(std::string& first_line_, std::map<std::string, std::string>& headers_, Octets& body_);
	virtual void Encode(Octets & os) const;
	virtual HttpResponse * Clone() const { return new HttpResponse(*this);}
	bool WillClose() const;
	static const char *Code2Str(int code);
	void dump()
	{
		Octets tmp;
		Encode(tmp);
		printf ("%.*s\n", (int)tmp.size(), (char*)tmp.begin());
	}
	virtual void Process(PManager *, SESSION_ID sid)  {}
};

//ʾ��, ������Ӧ��ʵ���Լ���Request������Response
//��HttpProtocol::Manager���̳У����ô�HttpProtocol::Manager��HttpClientManager
#if 0
class HttpClientManager : public HttpManager
{
	class MyHttpResponse : pubilc HttpResponse
	{
	public:
		virtual void Process(Manager *manager, Manager::Session::ID sid)
		{
			dump();
		}
	};
	virtual HttpProtocol * CreateProtocol() const {return new MyHttpResponse;}
	virtual std::string Identification() const { return std::string("WebClient"); }
	virtual void OnAddSession(Session::ID sid)
	{
		HttpRequest req;
		req.url= "/jasondev/cgi-bin/index.cgi";
		Send(sid, &req);
	}
	virtual void OnDelSession(Session::ID){}
public:
	HttpClientManager(){}
};

class HttpServerManager:public HttpManager
{
	class MyHttpRequest: public HttpRequest
	{
	public:
		virtual void Process(Manager *man, Manager::Session::ID sid)
		{
			HttpResponse r;
			r.status =200;
			r.body = "<html>Hello,world</html>\n";
			man->Send(sid, &r);
		}
	};
	virtual HttpProtocol * CreateProtocol() const { return new MyHttpRequest; }
	virtual std::string Identification() const { return std::string("WebServer"); }
	virtual void OnAddSession(Session::ID sid) { }
	virtual void OnDelSession(Session::ID) { printf ("OnDelSession\n"); }
public:
	HttpServerManager(){}
};
#endif

}

#endif
