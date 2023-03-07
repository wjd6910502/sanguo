#include "log.h"
#include <iostream>
#include <unistd.h>
#include "base64.h" 

extern "C"
{
	#include "qisr.h"
	#include "msp_cmn.h"
	#include "msp_errors.h"
	#define	BUFFER_SIZE	4096
	#define HINTS_SIZE  100

    std::string iat_GetText( std::string sessionid, unsigned char* p_pcm,unsigned int pcm_size,const char* session_begin_params)
	{
		const char*		session_id					=	NULL;
		char			rec_result[BUFFER_SIZE]		=	{NULL};	
		char			hints[HINTS_SIZE]			=	{NULL}; //hintsΪ�������λػ���ԭ�����������û��Զ���
		unsigned int	total_len					=	0; 
		int				aud_stat					=	MSP_AUDIO_SAMPLE_CONTINUE ;		//��Ƶ״̬
		int				ep_stat						=	MSP_EP_LOOKING_FOR_SPEECH;		//�˵���
		int				rec_stat					=	MSP_REC_STATUS_SUCCESS ;		//ʶ��״̬
		int				errcode						=	MSP_SUCCESS ;
		
		printf("\n��ʼ������д ...\n");
			
		session_id = QISRSessionBegin(NULL, session_begin_params, &errcode);
		
		if (MSP_SUCCESS != errcode)
		{
			printf("\nQISRSessionBegin failed! error code:%d\n", errcode);
			QISRSessionEnd(session_id, hints);
			return "";
		}
		
		long len = pcm_size;
		if (len <= 0)
		{
			printf("\nQISRSessionBegin input len Wrong\n");
			QISRSessionEnd(session_id, hints);
			return "";
		}
		aud_stat = MSP_AUDIO_SAMPLE_FIRST;

		printf(">");
		printf("----------------- timethread = %u sessindi = %s ppcm = %s\n",(unsigned int)pthread_self() ,session_id, p_pcm);
		int ret = QISRAudioWrite(session_id, (const void *)p_pcm, len, aud_stat, &ep_stat, &rec_stat);
		if (MSP_SUCCESS != ret)
		{
			printf("\nQISRAudioWrite failed! error code:%d\n", ret);
			QISRSessionEnd(session_id, hints);
			return "";
		}
			
		errcode = QISRAudioWrite(session_id, NULL, 0, MSP_AUDIO_SAMPLE_LAST, &ep_stat, &rec_stat);
		if (MSP_SUCCESS != errcode)
		{
			printf("\nQISRAudioWrite failed! error code:%d \n", errcode);
			QISRSessionEnd(session_id, hints);
			return "";
		}
		
		while (MSP_REC_STATUS_COMPLETE != rec_stat) 
		{	
			printf("\nQISRGetResult \n");
			const char *rslt = QISRGetResult(session_id, &rec_stat, 0, &errcode);
			if (MSP_SUCCESS != errcode)
			{
				printf("\nQISRGetResult failed, error code: %d\n", errcode);
				QISRSessionEnd(session_id, hints);
				return "";
			}
			if (NULL != rslt)
			{
				unsigned int rslt_len = strlen(rslt);
				total_len += rslt_len;
				if (total_len >= BUFFER_SIZE)
				{
					printf("\nno enough buffer for rec_result !\n");
					QISRSessionEnd(session_id, hints);
					return "";
				}
				strncat(rec_result, rslt, rslt_len);
			}
			usleep(150*1000); //��ֹƵ��ռ��cpu
			
		}
			
		//������Ϣ���ͻ���
		printf("\n������д����\n");
		printf("iat_gettext\n");
		printf("=============================================================\n");
		printf("%s\n",rec_result);
		printf("=============================================================\n");
		
		QISRSessionEnd(session_id, hints);
	
		return std::string(rec_result);
	}

	void GetAndSendTextToGamedMSP(std::string session_id,SpeechMsg* msg )
	{
		const char* session_begin_params	=	"sub = iat, domain = iat, language = zh_ch, accent = mandarin, sample_rate = 16000, result_type = plain, result_encoding = utf8";
		
		Octets speech_content;			
		Base64Encoder::Convert(speech_content,Octets((char*)msg->_speech,msg->_speech_size));

		/* *******************************************************************************
		 *
		 *	��ѹ���Ľӿ� �����ṩ
		 *
		 * *******************************************************************************/
		//��ѹ���Ľӿ�	
		unsigned char* speech = msg->GetSpeech();
		unsigned int spSize = msg->_speech_size;
		
		std::string result = "";
		unsigned int realLength =0;
		unsigned int decompressnum = AudioCode_CalcDecompressSize(speech,spSize);
		float* pf = (float*)malloc(sizeof(float)*(decompressnum));
		if(pf == NULL)
		{
			printf("*************** malloc defeat *************\n");
			return;
		}
	
		if ( AudioCode_Decompress(speech,spSize,pf,decompressnum) )
		{
			unsigned char* puc = (unsigned char *)malloc(sizeof(float)*decompressnum / 2);
			if(puc == NULL)
			{
				printf("*************** malloc defeat *************\n");
				return;
			}
	
			for (unsigned int i = 0; i < decompressnum; ++i)
			{
				short tmp = (short)(*(pf + i) * 32767);
				memcpy(puc + i*2, &tmp, sizeof(short));
			}											
			realLength = sizeof(float)*decompressnum / 2;

			result = iat_GetText(session_id, puc,realLength,session_begin_params);	
			
			free(puc);
			puc=NULL;
		}
		
		free(pf);
		pf = NULL;
	
	


		if(result == "")
		{
			//result = "Cannot Recognized";
		}

		//���ͽ����������
		GetIATextInSpeechRe res;
		res.src_id = msg->_srcid;
		res.dest_id =Octets(msg->_destid,strlen(msg->_destid));
		res.zone_id = msg->_zoneid;
		res.time = msg->_time;
		res.chat_type = msg->_chatype;
		res.chat_channel = msg->_chatchannel;
		//��base64����
		
		//Octets speech_content;			
		//Base64Encoder::Convert(speech_content,Octets((char*)msg->_speech,msg->_speech_size));

		res.speech_content = speech_content;	
		res.text_content = Octets(result.c_str(),result.size());
		STTServer::GetInstance()->DispatchProtocol(res.zone_id,&res);	
	}

}


