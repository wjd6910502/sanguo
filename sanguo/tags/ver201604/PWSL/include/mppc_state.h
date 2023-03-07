/*
 *	������ʷ��mppcѹ����, ������ʽ�ͷ���ʽ����.  ���з���ʽ�Ǳ�׼��MPPCѹ���㷨����ʽ���ڼ����˽�����������ǷǱ�׼�㷨��
 *	���ߣ�������
 *	ʱ�䣺2009-06
 *	��˾������ʱ��
*/

#ifndef __MPPC_STATE_H
#define __MPPC_STATE_H

#include <stdint.h>
#include "byteorder.h" 
#include "octets.h"
#include "marshal.h"

namespace GNET
{
class mppc_state
{
public:
	mppc_state(bool is_compress);
	mppc_state(const mppc_state& rhs);

	bool StreamSave(Marshal::OctetsStream &os) const;
	bool StreamLoad(Marshal::OctetsStream &os);
	

	/** 
	* @brief ����ѹ��һ�������ֽڵĶ��������������ֽڡ����ڷ���ʽ��ѹ����
	* 
	* @param sourcelen	���볤��
	* 
	* @return �������µ��������
	*/
	static size_t compressBound( size_t sourcelen )
	{
		return (((sourcelen*9)/8)+1)+2+3;
	}
	enum ECODE {			//����ʽѹ��ʱ�Ĵ�����
		E_OK, 			//��ȷ
		E_UNKNOWN = -1, 	//δ֪
		E_DST_NO_ROOM = -2,	//Ŀ�껺�岻��
		E_HISTORY = -3,		//���õ��˱��������ʷ���򲻴��ڵ���ʷ)
	};

	/** 
	* @brief 	����ʽѹ�����ѹ
	* 
	* @param dest		Ŀ�껺��
	* @param destLen	���Ŀ�껺��ĳ��ȡ�ѹ��ʱ������compressBound�����ơ�
	* @param source		Դ
	* @param sourceLen	Դ�ĳ���
	* 
	* @return 	������ECODE. ѹ����ĳ��Ȼ�����destLen��
	*/
	int Update(unsigned char *dest, int *destLen, const unsigned char *source, int sourceLen);

	/** 
	* @brief 	��ʽѹ�����ѹ
	* 
	* @param in	����
	* 
	* @return 	����ᱻ����in�в�����
	*/
	Octets & StreamUpdate(Octets& in);
private:
	enum {CTRL_OFF_EOB =0, MAX_HIST_LEN = 8192, MAX_HASH_SIZE = 8192};
	unsigned char _hist[MAX_HIST_LEN];
	unsigned short _hash[MAX_HASH_SIZE];
	unsigned short _hist_len;
	bool _compress;

	unsigned char *AppendHistory(const unsigned char *buf, size_t size);
	void AppendHistoryRoll(const unsigned char *buf, size_t size);
	static inline unsigned short HASH( const unsigned char *x){ 
		return 	(((40543*(((((x)[0]<<4)^(x)[1])<<4)^(x)[2]))>>4) & (MAX_HASH_SIZE-1));
	}
	inline unsigned char * GetPredecitAddr (const unsigned char *s)
	{
		unsigned short idx = HASH(s);
		unsigned char *p= _hist + _hash[idx];
		_hash[idx] = (unsigned short) (s - &_hist[0]);
		return p;
	}
	static int CompressBuffer(mppc_state *state, const unsigned char *ibuf, unsigned char *obuf, int isize, int osize);
	static int DecompressBuffer(mppc_state* state, const unsigned char *ibuf, unsigned char *obuf, int isize, int osize);

	static inline void passbits(const unsigned int n, unsigned int& l, unsigned int& blen);
	static inline unsigned int fetch(const unsigned char *&buf, unsigned int& l);

	//��ʽѹ������Ҫ��
	unsigned char *_histptr;
	unsigned int _legacy_in_size;

	unsigned char* compress_block( unsigned char *obuf, size_t isize );
	Octets& CompressUpdate(Octets &in);
	Octets& CompressFinal(Octets &in);

	//��ѹ��ʽ����Ҫ��
	unsigned int _l, _adjust_l;
	Octets   _legacy_in;

	unsigned char *_rptr;
	unsigned char *_adjust_rptr;
	unsigned int _blen, _blen_total;
	bool passbits(const unsigned int n);
	unsigned int fetch();
	Octets& DecompressUpdate(Octets &in);
};
}
#endif
