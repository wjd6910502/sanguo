#include <stdlib.h>
#include <stdio.h>
#include <memory.h>

#include "./Amrnb/interf_rom.h"

namespace  amrnb_enc
{
#include "./Amrnb/interf_enc.c"
#include "./Amrnb/sp_enc.c"
}

namespace  amrnb_dec
{
#include "./Amrnb/interf_dec.c"
#include "./Amrnb/sp_dec.c"
}

/*
#if defined(_WIN32)
#include <Windows.h>
#define DLL_API __declspec(dllexport)
#elif defined(_IOS)
#define DLL_API
#define WINAPI
#else
#define DLL_API
#define WINAPI
#endif
*/

static unsigned int const AMR_FRAME_SIZE = 160;
static unsigned int const amr_block_size[16] = { 12, 13, 15, 17, 19, 20, 26, 31, 5, 0, 0, 0, 0, 0, 0, 0 };	//������1����ʽ�ַ�
static unsigned int const AMR_MAX_BLOCK_SIZE = 32;

extern "C"
 unsigned int  AudioCode_CalcCompressSize(float const* pDataIn, unsigned int inDataSize, amrnb_enc::Mode mode)
{
	using namespace amrnb_enc;

	//����
	//int dtx = 0;

	unsigned int blockSize = amr_block_size[mode];
	unsigned int nFrames = (inDataSize + AMR_FRAME_SIZE - 1) / AMR_FRAME_SIZE;		//����һ֡��һ֡
	return nFrames * (1 + blockSize);
}

//pDataIn ��������Ƶ����. inSize: ���������. pBufferOut: ���Buffer. outSize: ����buffer��С(byte)������ʵ����������ݴ�С
//return: �ɹ�ʱ���� true
extern "C"
bool  AudioCode_Compress(float const* pDataIn, unsigned int inDataSize, unsigned char* pBufferOut, unsigned int& outSize, amrnb_enc::Mode mode)
{
	using namespace amrnb_enc;

	//����
	int dtx = 0;

	//����������
	void * encoder = Encoder_Interface_init(dtx);
	if (encoder == NULL)
		return false;

	unsigned int inPos = 0;
	unsigned int outPos = 0;
	unsigned int outBufferSize = outSize;

	//��������֡
	while (inPos < inDataSize && outPos < outBufferSize)
	{
		unsigned int nSamples = (inPos + AMR_FRAME_SIZE < inDataSize) ? AMR_FRAME_SIZE : (inDataSize - inPos);	//���ǲ���һ֡�����
		short frameDataData[AMR_FRAME_SIZE] = {};
		unsigned char frameSampleBuffer[AMR_MAX_BLOCK_SIZE]  = {};

		//float => short
		for (unsigned int i=0; i<nSamples; ++i)
		{
			float value = pDataIn[inPos + i];
			frameDataData[i] = (short)(value*(short)0x7fff);
		}

		unsigned int frameOutSize = Encoder_Interface_Encode(encoder, mode, frameDataData, frameSampleBuffer, 1);
		int writeSize = (outPos + frameOutSize <= outBufferSize) ? frameOutSize : outBufferSize - outPos;	//���ǲ���һ֡�����

		memcpy(pBufferOut + outPos, frameSampleBuffer, writeSize * sizeof(frameSampleBuffer[0]));

		inPos += nSamples;
		outPos += writeSize;
	}

	Encoder_Interface_exit(encoder);

	//ʵ���������
	outSize = outPos;

	return inPos == inDataSize;		//���ݶ����˾���ɹ�
}

extern "C"
 unsigned int  AudioCode_CalcDecompressSize(unsigned char const* pDataIn, unsigned int inDataSize)
{
	using namespace amrnb_dec;

	unsigned int inPos = 0;
	unsigned int outPos = 0;

	//��������֡
	while (inPos < inDataSize)		//������֡Ϊ��λ�������������� AMR_FRAME_SIZE ��������
	{
		//����֡�ĵ�һ�ֽڣ���ȷ��ģʽ������֡���ݳ���
		unsigned char formatChar = pDataIn[inPos];
		Mode dec_mode = (Mode)((formatChar >> 3) & 0x000F);
		unsigned readSize = amr_block_size[dec_mode];

		if (readSize == 0)
			break;
		if (inPos + 1 + readSize > inDataSize)	//����1֡��������(?)
			break;

		inPos += 1 + readSize;
		outPos += AMR_FRAME_SIZE;
	}

	return outPos;
}

//pDataIn ѹ������Ƶ����. inDataSize: ���ݴ�С(byte). pBufferOut: ���Buffer. outSize: ����buffer��С(sample)������ʵ������Ĳ�������С
//return: �ɹ�ʱ���� true
extern "C"
bool AudioCode_Decompress(unsigned char const* pDataIn, unsigned int inDataSize, float* pBufferOut, unsigned int& outSize)
{
	using namespace amrnb_dec;

	//����������
	void * decoder = Decoder_Interface_init();
	if (decoder == NULL)
		return false;

	unsigned int inPos = 0;
	unsigned int outPos = 0;
	unsigned int outBufferSize = outSize;

	//��������֡
	while (inPos < inDataSize && outPos + AMR_FRAME_SIZE <= outBufferSize)		//������֡Ϊ��λ�������������� AMR_FRAME_SIZE ��������
	{
		//����֡�ĵ�һ�ֽڣ���ȷ��ģʽ������֡���ݳ���
		unsigned char formatChar = pDataIn[inPos];
		Mode dec_mode = (Mode)((formatChar >> 3) & 0x000F);
		unsigned readSize = amr_block_size[dec_mode];

		if (readSize == 0)
			break;
		if (inPos + 1 + readSize > inDataSize)	//����1֡��������(?)
			break;

		short frameSampleBuffer[AMR_FRAME_SIZE]  = {};
		
		Decoder_Interface_Decode(decoder, (UWord8*)(pDataIn + inPos), frameSampleBuffer, 0);
		
		//short => float
		for (unsigned int i=0; i<AMR_FRAME_SIZE; ++i)
		{
			float value = (float)frameSampleBuffer[i] / 0x7fff;
			pBufferOut[outPos + i] = value;
		}

		inPos += 1 + readSize;
		outPos += AMR_FRAME_SIZE;
	}

	Decoder_Interface_exit(decoder);

	//ʵ���������
	outSize = outPos;

	return inPos == inDataSize;		//���ݶ����˾���ɹ�
}
