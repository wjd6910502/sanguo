/*
 *	����Э������ļ���ģ�飬NetSession�а����˼��ܺͽ��ܵ����ģ��
 *	���ߣ�δ֪
 *	�޸ģ�2009-07 ������ ���������ڷ���ѹ�����ܵļ�����
 *	��˾������ʱ��
 */


#ifndef __ONLINEGAME_SECURITY_H__
#define __ONLINEGAME_SECURITY_H__

#include <map>
#include <assert.h>
#include "octets.h"
#include "marshal.h"

namespace GNET
{
enum { 
	RANDOM = 0, 
	NULLSECURITY = 1, 
	ARCFOURSECURITY = 2, 
	MD5HASH = 3, 
	HMAC_MD5HASH = 4, 
	COMPRESS_MPPC = 5,			//MPPC������ʷ״̬��
	UNCOMPRESS_MPPC = 6,
	SHA1HASH = 7,
	COMPRESS_ZLIB = 8,			//ZLIB����ʽ��
	UNCOMPRESS_ZLIB = 9,
	COMPRESS_STREAM_MPPC = 12,		//MPPC��ʽ����ʷ
	UNCOMPRESS_STREAM_MPPC = 13,
	RC4_MPPC_STREAM_COMPRESS = 14,		//�Ѿ���װ�õ�rc4 +ѹ�� ����������
	RC4_MPPC_STREAM_UNCOMPRESS = 15,
	TWOLEVEL_SECURITY = 16,			//�ڲ�ʹ��
	CC_SECURITY 	= 17,			//�ڲ�ʹ��
	UNCC_SECURITY 	= 18,			//�ڲ�ʹ��
	AES_CTR_SECURITY = 19,

	COMPRESSARCFOURSECURITY = 14,
	DECOMPRESSARCFOURSECURITY = 15,
};

class Octets;
class TwoLevelSecurity;
class Security
{
public:
	typedef unsigned int Type;
protected:
	Type type;
	virtual ~Security() { }
	Security(Type t) : type(t)
	{
	}
public:
	Security(const Security &rhs): type(rhs.type)
	{
	}
	inline Type GetType() const { return type;}
	virtual void SetParameter(const Octets &) { }
	virtual void GetParameter(Octets &) { }
	virtual bool SetExraParameter(int type, const Octets &) { return true; }		//���ö���Ĳ�����Ŀǰֻ��AES_CTR�õ��ˣ�����AES_CTR:type 0 Ӧ����16�ֽ�counter, type 1:Ӧ����16�ֽ�iv �������������������
	virtual Octets& Update(Octets &) = 0;
	virtual void Update(void *o, size_t o_size) { assert(false); }
	virtual Octets& Final(Octets &o) { return o; }
	virtual void Final (void *o, size_t o_size) { }
	virtual Security *Clone() const = 0;
	virtual void Destroy() { delete this; }
	static Security* Create(Type type);

	static Security * MakeCompressCrypt(Type compress, Type crypt);
	static Security * MakeUnCompressDeCrypt(Type decompress, Type decrypt);

	static Security * MakeStreamCompressCrypt(Type compress, Type crypt);
	static Security * MakeUnStreamCompressDeCrypt(Type decompress, Type decrypt);

	static Security * LinkSecurity(Security * first, Security * second, bool encode_or_decode/*true:encode, false:decode*/);	//����һ���ʺϷ���ѹ���ͷ�����ܵ� �������ܶ���
	static Security * StreamLinkSecurity(Security * first, Security * second);							//����һ���ʺ���ѹ���������ܵ� �������ܶ���

	static float GetCompressRatio(uint64_t *src_len = NULL, uint64_t *dest_len = NULL);	//��ȡѹ����

	//Security��Save& Load�����ڲ�ʹ�ã���Ϊ��Щ���벻���쳣��ȫ�ģ�����Ҫ�ڸ߲㱣֤��ȷ��
	void Save(Marshal::OctetsStream & os)
	{
		os << type;
		OnSave(os);
	}
	static Security * Load(Marshal::OctetsStream & os) 
	{
		Type type;
		os >> type;
		Security * sec = Create(type);
		sec->OnLoad(os);
		return sec;
	}

	virtual void OnSave(Marshal::OctetsStream & os) const =0;
	virtual void OnLoad(Marshal::OctetsStream & os) = 0;

};

class NullSecurity : public Security
{
	Security *Clone() const { return new NullSecurity(*this); }
public:
	NullSecurity():Security(NULLSECURITY){ }
	NullSecurity(Type type) : Security(type) { }
	NullSecurity(const NullSecurity &rhs) : Security(rhs) { }
	inline Octets& Update(Octets &o) { return o; }
	virtual void OnSave(Marshal::OctetsStream & os) const {}
	virtual void OnLoad(Marshal::OctetsStream & os) {}
};


class TwoLevelSecurity : public Security
{
protected:
	Security *_first;
	Security *_second;

	Security * Clone() const{ return new TwoLevelSecurity(*this);}
public:
	TwoLevelSecurity(Type t):Security(t),_first(NULL),_second(NULL) {}	//���ڴ��л��Ĵ������ڲ�ʹ����
	TwoLevelSecurity(Type t1, Type t2);
	TwoLevelSecurity(const TwoLevelSecurity& rhs):Security(rhs),_first(rhs._first->Clone()), _second(rhs._second->Clone()) {}
	TwoLevelSecurity(Security* t1, Security* t2):Security(TWOLEVEL_SECURITY) { _first = t1; _second = t2;}
	virtual ~TwoLevelSecurity()
	{
		_first->Destroy();
		_second->Destroy();
	}
	virtual Octets& Update(Octets &o)
	{
		//ֻ��t1,t2��������ʽ�㷨��Ҫ�󣬲ſ���������
		_first->Update(o);
		_first->Final(o);

		_second->Update(o);
		_second->Final(o);
		return o;
	}
	void SetParameter(const Octets &param)
	{
		_first->SetParameter(param);
		_second->SetParameter(param);
	}
	virtual void OnSave(Marshal::OctetsStream & os) const 
	{
		_first->Save(os);
		_second->Save(os);
	}
	virtual void OnLoad(Marshal::OctetsStream & os) 
	{
		ASSERT(_first ==NULL && _second == NULL);
		_first = Load(os);
		_second = Load(os);
	}
};

}

#endif

