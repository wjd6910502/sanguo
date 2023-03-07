#ifndef __MPPC_H
#define __MPPC_H

#include <sys/types.h>


namespace GNET
{

class mppc
{
public:
	static size_t compressBound( size_t sourcelen );

	static int compress( unsigned char *dest, int *destLen, const unsigned char *source, int sourceLen ); //ѹ�����ɹ�ʱ����0. destLenΪѹ����ĳ���
	static int uncompress( unsigned char *dest, int *destLen, const unsigned char *source, int sourceLen);//��ѹ���ɹ�ʱ����0

	static int compress2( unsigned char *dest, int *destLen, const unsigned char *source, int sourceLen );//ѹ�����Ὣ���밴8192��С��Ƭ
	static int uncompress2( unsigned char *dest, int *destLen, const unsigned char *source, int sourceLen);//��ѹ��compress2ѹ��������buffer
};

}

#endif
