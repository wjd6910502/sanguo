#ifndef _HTTP_PROTOCOL_H
#define _HTTP_PROTOCOL_H

#include "protocol.h"
//HTTP协议的实现
//
//这里实现的是能接收 http 协议的客户端和服务器的manager.
//目前http server只接收GET请求
//有问题请通知 yangyanzhao00972@wanmei.com

namespace GNET {

class HttpProtocol : public RawProtocol
{
public:
	HttpProtocol() {}
	virtual void Init(std::string& firstline, std::map<std::string, std::string>&headers_, Octets& body_) =0;

	//URL可用字符： 	[A-Za-z0-9] | "-" | "_" | "." | "~" 
	//保留字符： 		"!" | "*" | "'" | "(" |  ")" | ";"  | ":"| "@" | "&" | "=" | "+" | "$" | "," | "/" | "?" | "#" | "[" | "]"
	//转义字符:		"%" <HEX> <HEX>

	//如果url中有某个片断不是可用字符中的范围，请自行编码
	static std::string UrlEncode(const std::string& szToEncode);
	//如果header中的Content-type有 application/x-www-form-urlencoded, 就必须进行解码
	static std::string UrlDecode(const std::string& szToDecode);
};

class HttpManager : public PManager
{
public:
	HttpManager(){}
	//在接受到对方消息时，由Manager决定创建什么样的协议，决定是Request还是response
	//对server而言，应该创建Request型的，对client，应该是Response的
	virtual HttpProtocol * CreateHttpProtocol() const = 0;
	//最大协议字节，防止对方发过来的数据过大
	virtual size_t MaxProtocolSize() const {return 4*1024*1024;}

	PollIO* InitHttpServer(IOMan *ioman , bool is_ssl = false, const NetSession::Config * cfg = NULL);  //以Server方式启动manager,监听某端口，有两种可能会返回NULL: 1.配置加载失败(conf::GetInstance未调用). 2.端口已被占用
	PollIO* InitHttpClient(IOMan *ioman , bool is_ssl = false, const NetSession::Config * cfg = NULL);  //以Client方式启动manager,连接某端口，配置加载失败及socket创建失败时会返回NULL
};


//HTTP请求
class HttpRequest : public HttpProtocol
{
public:
	std::string method;	//已默认为GET
	std::string url;	//请求的资源
	std::string version;	//版本号，已默认为HTTP/1.1
	Octets body;		//附带的内容，可以为空. 当里边是二进制数时，必须有Content-Type
	std::map<std::string, std::string> headers; //头部，HTTP/1.1时，必须有Host

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
//HTTP回应
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

//示例, 派生类应该实现自己的Request，或者Response
//从HttpProtocol::Manager来继承，不用从HttpProtocol::Manager或HttpClientManager
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
