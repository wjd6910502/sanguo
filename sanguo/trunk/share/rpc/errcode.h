#ifndef __GNET_ERRCODE_H
#define __GNET_ERRCODE_H

namespace GNET
{
	enum ErrCode {
		ERR_SUCCESS                = 0,  // �ɹ�
		ERR_TOBECONTINUE           = 1,  // �ɹ������һ��и�������δ�����꣬Ŀǰδ��

		ERR_INVALID_ACCOUNT        = 2,  // �ʺŲ�����
		ERR_INVALID_PASSWORD       = 3,  // �������
		ERR_TIMEOUT                = 4,  // ��ʱ
		ERR_INVALID_ARGUMENT       = 5,  // ��������
		ERR_FRIEND_SYNCHRONIZE     = 6,  // ������Ϣ���浽���ݿ�ʱ�޷�ͬ��
		ERR_SERVERNOTSUPPLY        = 7,  // �÷�������֧�ָ�����
		ERR_COMMUNICATION          = 8,  // ����ͨѶ����
		ERR_ACCOUNTLOCKED          = 9,  // ����ظ���½����ǰ�û���һ����½���ڱ�������������״̬
		ERR_MULTILOGIN             = 10, // ����ظ���½�����û�ѡ���Զ�����
		// keyexchange
		ERR_INVALID_NONCE          = 11, //��Ч��nonceֵ
		//logout
		ERR_LOGOUT_FAIL            = 12, //AUTH�ǳ�ʧ��
		//login Gameserver
		ERR_GAMEDB_FAIL            = 13, //��Ϸ��������ȡ��ҽ�ɫ��Ϣʧ��
		ERR_ENTERWORLD_FAIL        = 14, //��½��Ϸ������ʧ��
		ERR_EXCEED_MAXNUM          = 15, //��Ϸ�����������Ѵ�����
		ERR_IN_WORLD               = 16, //��ҽ�ɫ�Ѿ�������
		ERR_EXCEED_LINE_MAXNUM	   = 17, //���߽�ɫ���Ѵﵽ����
		ERR_INVALID_LINEID	   = 18, //û������ߺ�
		ERR_NO_LINE_AVALIABLE	   = 19, //û�п��õ���
		// deliver use
		ERR_DELIVER_SEND           = 21, // ת��ʧ��
		ERR_DELIVER_TIMEOUT        = 22, // ת����ʱ
		//account
		ERR_ACCOUNTEMPTY           = 23, //�ʻ�����
		ERR_ACCOUNTFORBID          = 24, //�ʺű�GameMaster�������������½
		ERR_INVALIDCHAR            = 25, //�����к��зǷ����ַ�
		// LoginCheck
		ERR_IP_LOCK		   = 26,
		ERR_ID_LOCK		   = 27,
		ERR_MATRIXFAILURE	   = 28,
		
		//player login
		ERR_LOGINFAIL              = 31, //��½��Ϸʧ��
		ERR_KICKOUT                = 32, //��������
		ERR_CREATEROLE             = 33, //������ɫʧ��
		ERR_DELETEROLE             = 34, //ɾ����ɫʧ��
		ERR_ROLELIST               = 35, //��ý�ɫ�б�ʧ��
		ERR_UNDODELROLE            = 36, //����ɾ����ɫʧ��
		ERR_SRVMAINTAIN            = 37, //������ά���У���ʱ���ܵ�½
		ERR_ROLEFORBID             = 38, //��ɫ��GM��ɱ���������½��Ϸ
		ERR_SERVEROVERLOAD         = 39, //�����������Ѵ�����
		ERR_ACKICKOUT              = 40, //������ҳ���������
		ERR_ROLEBACKED             = 20, //��ɫ���ݱ�����backdbd�У���δ�ָ�

		//DB retcode
		ERR_FAILED                 = 41, //һ�����
		ERR_EXCEPTION              = 42, //���ݿ��쳣
		ERR_NOTFOUND               = 43, //��¼δ�ҵ�
		ERR_INVALIDHANDLE          = 44, //�����Handle
		ERR_DUPLICATRECORD         = 45, //��¼����ظ�
		ERR_NOFREESPACE            = 46, //û��ʣ��ռ�
		ERR_VERIFYFAILED           = 47, //����У�����
		ERR_DUPLICATE_ROLEID       = 48, //��ɫid�ظ�
		ERR_AGAIN                  = 49, //���ݿⷱæ���Ժ�����
		ERR_DATAERROR              = 50, //���ݴ���
		
		//add friend
		ERR_ADDFRD_REQUEST         = 51, //�����Ϊ����
		ERR_ADDFRD_REFUSE          = 52, //�ܾ���Ϊ����
		ERR_ADDFRD_AGREE           = 53, //ͬ���Ϊ����

		ERR_COMMAND_COOLING        = 55, //����������ȴ��
		ERR_INSTANCE_OVERFLOW      = 56, //��¼ʧ��,������Ŀ�ﵽ����

		//game DB
		ERR_DATANOTFIND            = 60, //���ݲ�����
		
		//other
		ERR_GENERAL                = 61, //δ�����һ���Դ���
		ERR_OUTOFSYNC              = 62, //���ݲ�ͬ��
		ERR_PERMISSION_DENIED      = 63, //û��Ȩ��
		ERR_DATABASE_TIMEOUT       = 64, //���ݿⳬʱ
		ERR_UNAVAILABLE            = 65, //��ɫ�ѻ飬�޷�ɾ��
		ERR_CMDCOOLING             = 66, //����������ȴ��

		//Trade
		ERR_TRADE_PARTNER_OFFLINE  = 68, //�Է��Ѿ�����
		ERR_TRADE_AGREE            = 0,  //ͬ�⽻��
		ERR_TRADE_REFUSE           = 69, //�Է��ܾ�����
		ERR_TRADE_BUSY_TRADER      = 70, //trader �Ѿ��ڽ�����
		ERR_TRADE_DB_FAILURE       = 71, //��д���ݿ�ʧ��
		ERR_TRADE_JOIN_IN          = 72, //���뽻��ʧ�ܣ����׶����˫���Ѿ�����
		ERR_TRADE_INVALID_TRADER   = 73, //��Ч�Ľ�����
		ERR_TRADE_ADDGOODS         = 74, //���ӽ�����Ʒʧ��
		ERR_TRADE_RMVGOODS         = 75, //���ٽ�����Ʒʧ��
		ERR_TRADE_READY_HALF       = 76, //�ύ���һ�룬�ȴ��Է��ύ
		ERR_TRADE_READY            = 77, //�ύ���
		ERR_TRADE_SUBMIT_FAIL      = 78, //�ύʧ��
		ERR_TRADE_CONFIRM_FAIL     = 79, //ȷ��ʧ��
		ERR_TRADE_DONE             = 80, //�������
		ERR_TRADE_HALFDONE         = 81, //�������һ�룬�ȴ���һ��ȷ��
		ERR_TRADE_DISCARDFAIL      = 82, //ȡ������ʧ��
		ERR_TRADE_MOVE_FAIL        = 83, //�ƶ���Ʒʧ��
		ERR_TRADE_SPACE            = 84, //��Ʒ���ռ䲻��
		ERR_TRADE_SETPSSN          = 85, //���ý����߲Ʋ�����
		ERR_TRADE_ATTACH_HALF      = 86, //�ɹ�����һ��һ��������
		ERR_TRADE_ATTACH_DONE      = 87, //�ɹ���������������
		ERR_TRADE_PARTNER_FORBID   = 88, //���׶���GM������׹���
			
		//faction error code (101-200) 
		ERR_FC_NETWORKERR          = 101, //����������ͨѶ����
		ERR_FC_INVALID_OPERATION   = 102, //��Ч�Ĳ�������
		ERR_FC_OP_TIMEOUT          = 103, //������ʱ
		ERR_FC_CREATE_ALREADY      = 104, //����Ѿ���ĳ�����ɵĳ�Ա�������ٴ�������
		ERR_FC_CREATE_DUP          = 105, //���������ظ�
		ERR_FC_DBFAILURE           = 106, //���ݿ�IO����
		ERR_FC_NO_PRIVILEGE        = 107, //û����ز�����Ȩ��
		ERR_FC_INVALIDNAME         = 108, //����ʹ�ô�����
		ERR_FC_FULL                = 109, //��Ա����
		ERR_FC_APPLY_REJOIN        = 110, //�Ѿ���ĳ�����ɵĳ�Ա������ʧ��
		ERR_FC_JOIN_SUCCESS        = 111, //�ɹ��������
		ERR_FC_JOIN_REFUSE         = 112, //���뱻�ܾ�
		ERR_FC_ACCEPT_REACCEPT     = 113, //����׼������ɵ�����Ѿ��������
		ERR_FC_FACTION_NOTEXIST    = 114, //���ɲ�����or���û����������뱾����
		ERR_FC_NOTAMEMBER          = 115, //��Ҳ��Ǳ����ɵİ���
		ERR_FC_CHECKCONDITION      = 116, //�����������������SP�������ʽ𲻹�
		ERR_FC_DATAERROR           = 117, //�����������ʹ��󣬿ͻ����ύ�Ĳ���������ʽ����
		ERR_FC_OFFLINE             = 118, //��Ҳ�����
		ERR_FC_OUTOFSERVICE        = 119, //������ʱ������
		ERR_FC_INVITEELEVEL        = 120, //�����뷽���𲻹������ܼ���
		ERR_FC_PREDELSUCCESS       = 121, //���ɽ�ɢ�ɹ����������ʽ��ɢ
		ERR_FC_DISMISSWAITING      = 122, //�������ڽ�ɢ��
		ERR_FC_INVITEENOFAMILY     = 123, //��������û�м�����壬��������������
		ERR_FC_LEAVINGFAMILY       = 124, //���������뿪���岻�����죬���ܼ����µļ���  

		// AU New Error Code
		ERR_PHONE_LOCK             = 130, //�绰�ܱ�����������
		ERR_NOT_ACTIVED            = 131, //���������辭����ɵ��룬���ʺ�δ���
		ERR_ZONGHENG_ACCOUNT       = 132, //�ݺ��������ʺ�δ������ܵ�¼��Ϸ��
		ERR_STOPPED_ACCOUNT        = 133, //Ϊ���Ż����������أ�����ʺų�ʱ��δ��¼��Ϸ���ѱ����������ͷ���ϵ��
		ERR_LOGIN_TOO_FREQUENCY    = 134, //����2����ܵ��ʺţ�32����ֻ�ܵ�½һ��������Ϸ����������
		
		ERR_CHAT_CREATE_FAILED     = 151, //����ʧ��
		ERR_CHAT_INVALID_SUBJECT   = 152, //�Ƿ�����
		ERR_CHAT_ROOM_NOT_FOUND    = 153, //�����Ҳ�����
		ERR_CHAT_JOIN_REFUSED      = 154, //�������󱻾ܾ�
		ERR_CHAT_INVITE_REFUSED    = 155, //�������뱻�ܾ�
		ERR_CHAT_INVALID_PASSWORD  = 156, //�������������
		ERR_CHAT_INVALID_ROLE      = 157, //��ɫδ�ҵ�
		ERR_CHAT_PERMISSION_DENY   = 158, //û��Ȩ��
		ERR_CHAT_EXCESSIVE         = 159, //���������ҹ���
		ERR_CHAT_ROOM_FULL         = 160, //�����Ѵ�����
		ERR_CHAT_SEND_FAILURE      = 161, //����ʧ��

		//set custom data (201-210)
		ERR_NOFACETICKET           =   201, //û������ȯ
		
		//mail system (211-219)
		ERR_MS_DBSVR_INV        =   211,      //���ݿ���񲻿�����
		ERR_MS_MAIL_INV         =   212,      //�ʼ�������
		ERR_MS_ATTACH_INV       =   213,      //����ĸ�����Ϣ
		ERR_MS_SEND_SELF        =   214,      //��ֹ���Լ������ʼ�
		ERR_MS_ACCOUNTFROZEN    =   215,      //�ʺ��Ѿ�����
		ERR_MS_AGAIN            =   216,      //��ʱ������
		ERR_MS_BOXFULL          =   217,      //Ŀ����������
		// auction system(220-230)
		ERR_AS_MAILBOXFULL      =   220,      //�����������
		ERR_AS_ITEM_INV         =   221,      //�����������Ʒ��Ϣ
		ERR_AS_MARKET_UNOPEN    =   222,      //������δ���ţ�δ��ɳ�ʼ����
		ERR_AS_ID_EXHAUSE       =   223,      //�������þ�
		ERR_AS_ATTEND_OVF       =   224,      //������������ﵽ����
		ERR_AS_BID_LOWBID       =   225,      //���۹��;���ʧ��
		ERR_AS_BID_NOTFOUND     =   226,      //δ�ҵ��������¼�
		ERR_AS_BID_BINSUCCESS   =   227,      //һ�ڼ����
		ERR_AS_BID_UNREDEEMABLE =   228,      //�������
		ERR_AS_BID_INVALIDPRICE =   229,      //���ļ۸���ڰ�ȫ�趨
		// sell point system(231,241)
		ERR_SP_NOT_INIT         =   231,       //ϵͳû�г�ʼ�����
		ERR_SP_SPARETIME        =   232,       //ʣ��ʱ�䲻�����������
		ERR_SP_INVA_POINT       =   233,       //��Ч�Ĺ��۵�����������30Ԫ��������
		ERR_SP_EXPIRED          =   234,       //�õ㿨�Ѿ�����
		ERR_SP_DBNOTSYNC        =   235,       //Delivery��GameDBD������Ϣ��ͬ��
		ERR_SP_DBDEADLOCK       =   236,       //GameDBD����Э��ʱ��������
		ERR_SP_NOMONEY          =   237,       //����Ҳ���
		ERR_SP_INVA_STATUS      =   238,       //���������״̬
		ERR_SP_SELLING          =   239,       //�㿨�Ѿ���������״̬
		ERR_SP_ABORT            =   240,       //AU����Abort, Do not change, authd is hardcoded
		ERR_SP_COMMIT           =   241,       //AU����Commit, Do not change,authd is hardcoded
		ERR_SP_MONEYEXCEED      =   242,       //��Ǯ���ﵽ����
		ERR_SP_BUYSELF	        =   243,       //���ܹ����Լ����۵ĵ㿨
		ERR_SP_FORBID	        =   244,       //���۵㿨�����ѹر�
		ERR_SP_EXCESS	        =   245,       //��ֹ���Ƚ��׳����㿨, Do not change, authd is hardcoded

		// Battle System  260-280
		ERR_BS_INVALIDROLE      =   260,       //��ɫ��ݲ�����
		ERR_BS_FAILED           =   261,       //ʧ��
		ERR_BS_OUTOFSERVICE     =   262,       //������ʱ������
		ERR_BS_NEWBIE_BANNED    =   263,       //�������72Сʱ�ڲ���������ս
		ERR_BS_ALREADYSENT      =   264,       //���������Ѿ����͹�һ��
		ERR_BS_ALREADYBID       =   265,       //���ܶ�ξ���
		ERR_BS_NOTBATTLECITY    =   266,       //�õ�ͼû�п�����ս
		ERR_BS_PROCESSBIDDING   =   267,       //���ڴ�������������
		ERR_BS_BIDSELF          =   268,       //���ܶ��Լ�����ؾ���
		ERR_BS_BIDNOOWNERCITY   =   269,       //����ذ��ɲ��ܶ�������ؾ���
		ERR_BS_NOMONEY          =   270,       //���������
		ERR_BS_LEVELNOTENOUGH   =   271,       //���ɼ�����
		ERR_BS_RANKNOTENOUGH    =   272,       //������������
		ERR_BS_CREDITNOTENOUGH  =   273,       //�����Ѻö���������ս�����Ѻö�
		ERR_BS_CREDITLIMIT	=   274,       //�����ѺöȲ������Ҫ��

	};
	
	enum FS_ERR
	{
		ERR_FS_OFFLINE          =  1,     //��Ҳ�����
		ERR_FS_REFUSE           =  2,     //���ܾ�
		ERR_FS_TIMEOUT          =  3,     //��ʱ
		ERR_FS_NOSPACE          =  4,     //��ʣ��ռ�
		ERR_FS_NOFOUND          =  5,     //δ�ҵ�
		ERR_FS_ERRPARAM         =  6,     //��������
		ERR_FS_DUPLICATE        =  7,     //�ظ�
		ERR_FS_NOTINITIALIZED   =  8,     //�����б���δȡ��
	};
};

#endif

