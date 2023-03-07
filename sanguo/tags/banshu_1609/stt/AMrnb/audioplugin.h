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
static unsigned int const amr_block_size[16] = { 12, 13, 15, 17, 19, 20, 26, 31, 5, 0, 0, 0, 0, 0, 0, 0 };	//不含第1个格式字符
static unsigned int const AMR_MAX_BLOCK_SIZE = 32;

extern "C"
 unsigned int  AudioCode_CalcCompressSize(float const* pDataIn, unsigned int inDataSize, amrnb_enc::Mode mode)
{
	using namespace amrnb_enc;

	//设置
	//int dtx = 0;

	unsigned int blockSize = amr_block_size[mode];
	unsigned int nFrames = (inDataSize + AMR_FRAME_SIZE - 1) / AMR_FRAME_SIZE;		//不足一帧算一帧
	return nFrames * (1 + blockSize);
}

//pDataIn 单声道音频数据. inSize: 输入采样数. pBufferOut: 输出Buffer. outSize: 传入buffer大小(byte)，传出实际输出的数据大小
//return: 成功时返回 true
extern "C"
bool  AudioCode_Compress(float const* pDataIn, unsigned int inDataSize, unsigned char* pBufferOut, unsigned int& outSize, amrnb_enc::Mode mode)
{
	using namespace amrnb_enc;

	//设置
	int dtx = 0;

	//创建编码器
	void * encoder = Encoder_Interface_init(dtx);
	if (encoder == NULL)
		return false;

	unsigned int inPos = 0;
	unsigned int outPos = 0;
	unsigned int outBufferSize = outSize;

	//处理所有帧
	while (inPos < inDataSize && outPos < outBufferSize)
	{
		unsigned int nSamples = (inPos + AMR_FRAME_SIZE < inDataSize) ? AMR_FRAME_SIZE : (inDataSize - inPos);	//考虑不足一帧的情况
		short frameDataData[AMR_FRAME_SIZE] = {};
		unsigned char frameSampleBuffer[AMR_MAX_BLOCK_SIZE]  = {};

		//float => short
		for (unsigned int i=0; i<nSamples; ++i)
		{
			float value = pDataIn[inPos + i];
			frameDataData[i] = (short)(value*(short)0x7fff);
		}

		unsigned int frameOutSize = Encoder_Interface_Encode(encoder, mode, frameDataData, frameSampleBuffer, 1);
		int writeSize = (outPos + frameOutSize <= outBufferSize) ? frameOutSize : outBufferSize - outPos;	//考虑不足一帧的情况

		memcpy(pBufferOut + outPos, frameSampleBuffer, writeSize * sizeof(frameSampleBuffer[0]));

		inPos += nSamples;
		outPos += writeSize;
	}

	Encoder_Interface_exit(encoder);

	//实际输出长度
	outSize = outPos;

	return inPos == inDataSize;		//数据读完了就算成功
}

extern "C"
 unsigned int  AudioCode_CalcDecompressSize(unsigned char const* pDataIn, unsigned int inDataSize)
{
	using namespace amrnb_dec;

	unsigned int inPos = 0;
	unsigned int outPos = 0;

	//处理所有帧
	while (inPos < inDataSize)		//读入以帧为单位，因此输出长度是 AMR_FRAME_SIZE 的整数倍
	{
		//读出帧的第一字节，以确定模式，计算帧数据长度
		unsigned char formatChar = pDataIn[inPos];
		Mode dec_mode = (Mode)((formatChar >> 3) & 0x000F);
		unsigned readSize = amr_block_size[dec_mode];

		if (readSize == 0)
			break;
		if (inPos + 1 + readSize > inDataSize)	//不足1帧，数据损坏(?)
			break;

		inPos += 1 + readSize;
		outPos += AMR_FRAME_SIZE;
	}

	return outPos;
}

//pDataIn 压缩的音频数据. inDataSize: 数据大小(byte). pBufferOut: 输出Buffer. outSize: 传入buffer大小(sample)，传出实际输出的采样数大小
//return: 成功时返回 true
extern "C"
bool AudioCode_Decompress(unsigned char const* pDataIn, unsigned int inDataSize, float* pBufferOut, unsigned int& outSize)
{
	using namespace amrnb_dec;

	//创建解码器
	void * decoder = Decoder_Interface_init();
	if (decoder == NULL)
		return false;

	unsigned int inPos = 0;
	unsigned int outPos = 0;
	unsigned int outBufferSize = outSize;

	//处理所有帧
	while (inPos < inDataSize && outPos + AMR_FRAME_SIZE <= outBufferSize)		//读入以帧为单位，因此输出长度是 AMR_FRAME_SIZE 的整数倍
	{
		//读出帧的第一字节，以确定模式，计算帧数据长度
		unsigned char formatChar = pDataIn[inPos];
		Mode dec_mode = (Mode)((formatChar >> 3) & 0x000F);
		unsigned readSize = amr_block_size[dec_mode];

		if (readSize == 0)
			break;
		if (inPos + 1 + readSize > inDataSize)	//不足1帧，数据损坏(?)
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

	//实际输出长度
	outSize = outPos;

	return inPos == inDataSize;		//数据读完了就算成功
}
