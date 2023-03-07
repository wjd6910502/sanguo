/*
	base64.h
	���ߣ� κ�� 
	�޸ģ�����
	���ܣ� base64��/���뺯��
	���ڣ� 2001-10
	�޸����ڣ�2002-1-17  ���˱�û�б�֮��,�����Ķ�����
*/

#ifndef __base64_h__
#define __base64_h__

/////////////////////////////////////////////////////////////////////////////
// codec
/////////////////////////////////////////////////////////////////////////////
// ���룺__in�е��ַ���һ����4��������
// ���ؽ��볤��
int	base64_decode(char *__in, int __inlen, unsigned char *__out);

// ���룺__out�ĳ���һ����4��������, ���Զ�0��β
// ���ر��볤��
int	base64_encode(unsigned char *__in, int __inlen, char *__out);

#endif	// EOF __base64_h__
#ifndef __BASE64_H__
#define __BASE64_H__
#include "octets.h"

namespace GNET
{

class Base64Encoder
{
public:
	static size_t encodeBound( size_t sourcelen ) 
	{ 
		return (sourcelen+2)/3*4; 
	}
	Base64Encoder(){ }
	Base64Encoder(const Base64Encoder &rhs){ }
	Octets& Update(Octets& in) 
	{ 
		Octets out;
		out.resize(encodeBound(in.size())+1); //��Ϊ�±ߵĺ�����0��β�ģ�����Ҫ��1
		size_t len = base64_encode((unsigned char*)in.begin(), in.size(), (char*)out.begin());
		out.resize(len);
		return in.swap(out);
	}
	static void Convert(Octets& out, const Octets& in) 
	{ 
		out.resize(encodeBound(in.size())+1);
		size_t len =base64_encode((unsigned char*)in.begin(), in.size(), (char*)out.begin());
		out.resize(len);
	}
};

class Base64Decoder
{
public:
	static size_t decodeBound( size_t sourcelen ) { return sourcelen*3/4+4; }
	Base64Decoder(){ }
	Base64Decoder(const Base64Decoder &rhs){ }
	Octets& Update(Octets &in) 
	{ 
		Octets out;
		out.reserve(decodeBound(in.size()));
		size_t len = base64_decode((char *)in.begin(), in.size(), (unsigned char*)out.begin());
		out.resize(len);
		return in.swap(out);
	}
	static void Convert(Octets& out, const Octets& in) 
	{ 
		out.resize(decodeBound(in.size()));
		size_t len=base64_decode((char *)in.begin(), in.size(), (unsigned char*)out.begin());
		out.resize(len);
	}
};
}

#endif	
