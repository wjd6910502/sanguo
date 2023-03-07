#ifndef __GNET_COMMONMACRO_H
#define __GNET_COMMONMACRO_H
// Define macros shared by SwordNet and SwordGame
#include "octets.h"
#include "thread.h"
#include <sys/types.h>
#include <stdint.h>
#include <string>
#include <map>

#ifndef RUID_TYPE
#define RUID_TYPE
typedef int64_t ruid_t;
#endif

namespace GNET
{
//#define MAILBOX_SYSTEM_MAX	(10 * 1024)
//#define MAILBOX_PLAYER_MAX	(5 * 1024)
#define MAX_MAIL_COUNT		500
#define MAX_SYSTEM_MAIL_COUNT	100
#define MAX_PLAYER_MAIL_COUNT	100
#define MAX_MAIL_ATTACHED_ITEM_COUNT (6)
#define DEFAULT_SYSTEM_MAIL_LIFETIME (3*24*60*60)
#define DEFAULT_PLAYER_MAIL_LIFETIME (7*24*60*60)
#define ERROR_SUCCESS           0
#define AC_STATUS_ONGAME        5
#define AC_DELIVERY_CLIENT      1
#define INVALID_MIRROR_ID	0xFF
#define BANGHUI_CREATE_MONEY    200
#define BANGHUI_CREATE_FREE_COUNT 20
enum INSTANCE_TYPE
{
	INSTANCE_SOLO       = 0,	// ¸öÈË¸±±¾
	INSTANCE_ROUTINE    = 1,	// »î¶¯¸±±¾
	INSTANCE_TEAM       = 2,	// ³£¹æ¸±±¾
	INSTANCE_GM         = 3,	// GM³¢ÊÔ¸ú×Ù½øÈë
	INSTANCE_BATTLE     = 4,	// Õ½³¡¸±±¾
	INSTANCE_BASE       = 5,	// °ïÅÉ»ùµØ
	INSTANCE_FACTION    = 6,	// °ïÅÉ¸±±¾
	INSTANCE_FACTION_TEAM=7,	// °ïÅÉ×é¶Ó¸±±¾
	INSTANCE_TOURNAMENT = 8,	// ÍÅÌå¾ºÈü¸±±¾
	INSTANCE_DUEL       = 9,	// ÇÐ´è¸±±¾
	INSTANCE_BIWU       = 10,	// ±ÈÎä¸±±¾
	INSTANCE_BANGHUIZHAN= 11,	// °ï»áÕ½¸±±¾

	INSTANCE_TYPE_COUNT,
};
enum SPEC_TYPE			//¸±±¾·ÖÀà
{
	SPEC_CELEB		= 1,		//ÃûÈËÌôÕ½
	SPEC_BATTLE		= 2,		//Õ½³¡
	SPEC_TYPE_COUNT,
};

enum CHANGEWORD_MODE
{
	MODE_CHANGELINE		= 0,
	MODE_ENTERINSTANCE	= 1,
	MODE_LEAVEINSTANCE	= 2,
	MODE_INSTANCE2INSTANCE	= 3,
	MODE_CHANGE_ZONE	= 4,
};

enum JOIN_INSTANCE_TYPE
{
	JIT_PATICIPATE	= 0,	//²ÎÓë¸±±¾
	JIT_GM		= 1,	//GM¸úËæ½øÈë¸±±¾
	JIT_LOGIN	= 2,	//Ö±½ÓµÇÂ¼²ÎÓë¸±±¾
};

enum PLAYER_LOST_CONNECTION_MODE
{
	PLCM_RECONNECT		= 0,	//ÆÕÍ¨Âß¼­,¸±±¾ÖÐÊ¹ÓÃ¶ÏÏßÖØÁ¬
	PLCM_NO_RECONEC		= 1,	//¸±±¾ÖÐÒ²²»ÔÙÊ¹ÓÃ¶ÏÏßÖØÁ¬
	PLCM_KEEP_CONNECT	= 2,	//¶ÏÏßºó±£³ÖÒ»ÖÂÁ¬½Ó£¬Ö±µ½Ä£Ê½¸Ä±ä

	PLCM_COUNT,
};

enum TITLE_MASK
{
	TITLE_FACTIONMASTER    = 0x0004,
	TITLE_TEAMLEADER       = 0x0040,
	TITLE_SECTMENTOR       = 0x0080,
};
enum MAIL_STATUS
{
	MAIL_STATUS_ATTACHED   = 0x01,   // ÓÐ¸½¼þ
	MAIL_STATUS_READ       = 0x02,   // ÒÑ¶Á
	MAIL_STATUS_RESERVED   = 0x04,   // ±£Áô
	MAIL_STATUS_PROCESSED  = 0x08,   // ÒÑ´¦ÀíµÄÓÊ¼þ£¬±ÈÈç¼ÓºÃÓÑÇëÇó£¬Í¨ÖªµÈ
	MAIL_STATUS_TO_DELETE  = 0x10,   // ¿É×Ô¶¯É¾³ýµÄÓÊ¼þ, Ò»°ãÓÃÓÚ·¢½±
	MAIL_CANNOT_MERGE_MASK = ~(MAIL_STATUS_READ | MAIL_STATUS_PROCESSED), // MASKÊÇ»áÓ°ÏìÓÊ¼þºÏ²¢µÄÎ»µÄ¼¯ºÏ
};
enum MAIL_DBMODE
{
	MAIL_DBMODE_DIRTY      = 0x01,   // ´ý±£´æÓÊ¼þ
	MAIL_DBMODE_DELETED    = 0x02,   // ±»É¾³ý
	MAIL_DBMODE_SAVING     = 0x04,   // ÕýÔÚ±£´æ
};

enum
{

	REPLAY_TYPE_ARENA	= 0,
	REPLAY_TYPE_BIWU	= 1,

	ARENA_REPLAY_COUNT	= 1,	//×î¶à±£´æ¼¸³¡¾º¼¼³¡ÌôÕ½Êý¾Ý
	BIWU_REPLAY_COUNT	= 1,	//×î¶à±£´æ¼¸³¡±ÈÎäÊý¾Ý
};

enum MAIL_CATEGORY
{
	MAIL_CATEGORY_PLAYER   = 0,     // ÆÕÍ¨Íæ¼ÒÓÊ¼þ
	MAIL_CATEGORY_TASK     = 1,     // ÈÎÎñ·¢ËÍÓÊ¼þ
	MAIL_CATEGORY_MESSAGE  = 2,     // Íæ¼ÒÁôÑÔ
	MAIL_CATEGORY_REQUEST  = 3,     // ¸ñÊ½ÓÊ¼þ£­ÇëÇó
	MAIL_CATEGORY_INFORM   = 4,     // ¸ñÊ½ÓÊ¼þ£­Í¨Öª
	//ÕâÐ©XOMÃ»ÓÐÊ¹ÓÃ
	MAIL_CATEGORY_GIFT     = 5,     // ÀñÎïÓÊ¼þ
	MAIL_CATEGORY_STOCK    = 6,     // Ôª±¦½»Ò×ÕË»§È¡Ç®ÓÊ¼þ
	MAIL_CATEGORY_HOME     = 7,     // ¼ÒÔ°ÏµÍ³È¡ÎïÆ·ÓÊ¼þ
	MAIL_CATEGORY_LOSTFOUND= 8,     // ¸±±¾ÖÐÃ»À´µÃ¼°·¢µÄ¶«Î÷
	MAIL_CATEGORY_MALL_BUY = 9,     // ÉÌ³Ç¹ºÎïÓÊ¼þ
	MAIL_CATEGORY_MALL_PRESENT = 10,// ÉÌ³ÇÔùËÍÓÊ¼þ
	MAIL_CATEGORY_AUCTION  = 11,	// ÅÄÂôÏµÍ³ÓÊ¼þ
	MAIL_CATEGORY_WEBMAIL  = 12,    // Ò³Ãæ·¢½±¹¤¾ß
	//XOMÐÂÔö
	MAIL_CATEGORY_REWARD   = 21,    // ÏµÍ³·¢½±
	MAIL_CATEGORY_COMPENSATE= 22,   // ÏµÍ³²¹³¥

	//CATEGORY_MAIL_HIDDEN   = 0x40,  // Òþ²ØÓÊ¼þ£¬²»»á·¢¸ø¿Í»§¶Ë
	CATEGORY_MAIL_SYSTEM   = 0x80,  // À´×ÔÏµÍ³µÄÓÊ¼þ×î¸ßÎ»ÖÃ 1
};
#define IS_SYSTEM_MAIL(category)        (((category)&CATEGORY_MAIL_SYSTEM)!=0)
#define IS_PLAYER_MAIL(category)        (((category)&CATEGORY_MAIL_SYSTEM)==0)
#define CMP_CATEGORY(self,other)        (((self)&0x3f)==((other)&0x3f))

enum DB_DATA_MASK
{
	DBDATA_BASIC           = 0x01,
	DBDATA_CASH            = 0x02,
	DBDATA_POCKET          = 0x04,
	DBDATA_STORE           = 0x08,
	DBDATA_TASK            = 0x10,
	DBDATA_ALL             = (DBDATA_BASIC|DBDATA_CASH|DBDATA_POCKET|DBDATA_STORE|DBDATA_TASK),

	DBDATA_ROAM            = 0x20,
};

enum{
	CHAT_SYSTEM_TASK       = 0,  //ÈÎÎñÏµÍ³
	CHAT_SYSTEM_MARRIAGE   = 1,  //»éÒöÏµÍ³
	CHAT_SYSTEM_DROP       = 2,  //µôÂäÎïÆ·Í¨Öª
};


enum SPEAK_ID_TYPE
{
	SIT_ROLEID	= 0,	//Íæ¼Ò½ÇÉ«id
	SIT_FACTIONID	= 1,	//°ïÅÉid
};

enum PRIVATE_CHANNEL
{
	WHISPER_NORMAL	= 0,	//·ÇºÃÓÑ
	WHISPER_NORMALRE,	//·ÇºÃÓÑ×Ô¶¯»Ø¸´
	WHISPER_FRIEND,		//ºÃÓÑ
	WHISPER_FRIEND_RE,	//ºÃÓÑ×Ô¶¯»Ø¸´
	WHISPER_USERINFO,	//ºÃÓÑÏà¹ØÐÅÏ¢
	WHISPER_GM, 		//ÔÚÏß¿Í·þ
	WHISPER_MAX
};

// FORMAT_MAILÓÃÓÚMailHeader.msgid¶¨Òå£¬ÒòÎª»á´æµ½Êý¾Ý¿âÖÐ£¬Òò´Ë²»ÄÜËæ±ãÐÞ¸Ä£¬Ò»°ãÖ»ÄÜÐÂÔö£¬²»ÄÜÐÞ¸Ä»òÉ¾³ýÒÑÓÐ¶¨Òå
enum FORMAT_MAIL
{
	FORMAT_MAIL_FRIENDINVITE  = 1,  // ÑûÇë³ÉÎªºÃÓÑ
	FORMAT_MAIL_FRIENDAGREE   = 2,  // Í¬ÒâºÃÓÑÉêÇë
	//ÕâÐ©XOMÃ»ÓÐÊ¹ÓÃ
	FORMAT_MAIL_RENEGE        = 3,  // ±»»Ú»é
	FORMAT_MAIL_DIVORCE       = 4,  // ±»Àë»é
	FORMAT_MAIL_FAMILY_EXPEL  = 5,  // ±»¿ª³ý³ö½áÒå
	FORMAT_MAIL_FAMILY_DISMISS= 6,  // ËùÔÚ½áÒå½âÉ¢
	FORMAT_MAIL_SECT_EXPEL    = 7,  // ±»Ê¦ÃÅ¿ª³ý
	FORMAT_MAIL_SECT_QUIT     = 8,  // ÅÑÀëÊ¦ÃÅ
	FORMAT_MAIL_FACTION_INVITE= 9,  // ÑûÇë¼ÓÈë°ïÅÉ
	FORMAT_MAIL_SECT_GRADUATE_AWARD = 10, // Í½µÜ³öÊ¦¶ÔÊ¦¸¸µÄ½±Àø
	FORMAT_MAIL_TIZI_ERASE		= 11,	//Ìâ×Ö±»²Á³öÍ¨Öª
	//XOMÐÂÔö
	FORMAT_MAIL_WORLD_BOSS			= 21,  //²ÎÓëÊÀ½çbossÕ½½±Àø
	FORMAT_MAIL_WORLD_BOSS_HERO		= 22,  //ÊÀ½çbossÕ½Ö÷Á¦½±Àø
	FORMAT_MAIL_WORLD_BOSS_HERO_BANGHUI	= 23,  //ÊÀ½çbossÕ½Ö÷Á¦°ï»á½±Àø
	//100Ö®Ç°¸ø²ß»®½Å±¾ÓÃÁË
	FORMAT_MAIL_COMPENSATE_ROUTINE		= 101,  //·þÎñÆ÷ÀýÐÐÎ¬»¤²¹³¥
	FORMAT_MAIL_COMPENSATE_TEMP1		= 102,  //·þÎñÆ÷ÁÙÊ±Î¬»¤²¹³¥(Ð¡)
	FORMAT_MAIL_COMPENSATE_TEMP2		= 103,  //·þÎñÆ÷ÁÙÊ±Î¬»¤²¹³¥(ÖÐ)
	FORMAT_MAIL_COMPENSATE_TEMP3		= 104,  //·þÎñÆ÷ÁÙÊ±Î¬»¤²¹³¥(´ó)
	FORMAT_MAIL_TOP_LEVEL			= 105,  //¿ª·þ³å°ñµÈ¼¶½±Àø
	FORMAT_MAIL_TOP_FIGHTCAPACITY		= 106,  //¿ª·þ³å°ñÕ½Á¦½±Àø
	FORMAT_MAIL_CLIENT_NOT_FREE		= 107,  //ÊÕ·Ñ°æ¿Í»§¶Ë½±Àø
	FORMAT_MAIL_FOR_IOS_TEST_PLAYER		= 108,  //ios²»É¾µµ²âÊÔÓÃ»§»ØÀ¡Àñ°ü
};

enum FORMAT_MAIL_RESPONSE
{
	MAIL_REQUEST_ACCEPT = 0,
	MAIL_REQUEST_REFUSE = 1,
};

#define DBMASK_PUT_SYNC  (DBDATA_BASIC|DBDATA_CASH|DBDATA_POCKET|DBDATA_STORE)
#define DBMASK_PUT_ALL   (DBDATA_BASIC|DBDATA_CASH|DBDATA_POCKET|DBDATA_STORE|DBDATA_TASK)
#define DBMASK_PUT_SYNC_TIMEOUT (DBMASK_PUT_ALL&(~DBDATA_POCKET))

enum COMMON_DATA
{
	COMMON_DATA_WEATHER	= 7,       //³¡¾°ÌìÆøÖÖ×Ó
	COMMON_DATA_WEDDING	= 8,       //»éÀñÔ¤Ô¼
	COMMON_DATA_PROSPERITY	= 9,       //·±ÈÙ¶È
	COMMON_DATA_RANDOMSEED	= 10,      //Ëæ»úÖÖ×Ó
	COMMON_DATA_ALLIANCEWAR	= 11,      //ÃËÖ÷Õ½
	COMMON_DATA_WOO		= 12,      //Çó°®
	COMMON_DATA_MASK_BITS	= 16,      //Ç°×º×óÒÆÎ»Êý
	COMMON_DATA_MASK	= 0xFFFF,  //Êý¾ÝÃÉ°å
};

enum COMMON_DATA_VERSION
{
	WEATHER_VERSION		= 0x01,	//³¡¾°ÌìÆø°æ±¾ºÅ
	WEDDING_VERSION		= 0x01,	//»éÀñÔ¤Ô¼°æ±¾ºÅ
	PROSPERITY_VERSION	= 0x01,	//·±ÈÙ¶È°æ±¾ºÅ
	RANDOMSEED_VERSION	= 0x01, //Ëæ»úÖÖ×Ó°æ±¾ºÅ
	ALLIANCEWAR_VERSION	= 0x02,	//ÃËÖ÷Õ½°æ±¾ºÅ
	WOO_VERSION		= 0x02, //Çó°®°æ±¾ºÅ
};

enum AUTHD_ERROR
{
	AUERR_INVALID_ACCOUNT      = 2,   //ÕÊºÅ²»´æÔÚ
	AUERR_INVALID_PASSWORD     = 3,   //ÃÜÂë´íÎó
	AUERR_LOGOUT_FAIL          = 12,  //AUTHµÇ³öÊ§°Ü
	AUERR_PHONE_LOCK           = 130, //µç»°ÃÜ±£´¦ÓÚËø¶¨ÖÐ
	AUERR_NOT_ACTIVED          = 131, //±¾·þÎñÆ÷Ðè¾­¼¤»î·½¿ÉµÇÈë£¬¸ÃÕÊºÅÎ´¼¤»î¡£
	AUERR_ZONGHENG_ACCOUNT     = 132, //×ÝºáÖÐÎÄÍøÕÊºÅÎ´¾­¼¤»î²»ÄÜµÇÂ¼ÓÎÏ·¡£
	AUERR_STOPPED_ACCOUNT      = 133, //ÎªÁËÓÅ»¯·þÎñÆ÷¸ºÔØ£¬Òò¸ÃÕÊºÅ³¤Ê±¼äÎ´µÇÂ¼ÓÎÏ·£¬ÒÑ±»·â½û£¬ÇëÓë¿Í·þÁªÏµ¡£
	AUERR_LOGIN_FREQUENT	   = 134, //ÄúµÇÂ¼Æµ·±£¬ÇëÉÔºóÖØÐÂµÇÂ¼
};

enum UNIQUE_NAME_ERROR
{
	// general
	UNAME_ERR_SUCCESS         = 0, 
	UNAME_ERR_UNKNOWN         = -1, 
	UNAME_ERR_MARSHAL         = -2,
	UNAME_ERR_NOTFOUND        = -3, 

	// db
	UNAME_ERR_DB_NOTFOUND     = -4, 
	UNAME_ERR_DB_UNKNOWN      = -5,

	// rolename/name 
	UNAME_ERR_NOFREENAMESPACE = -6, 
	UNAME_ERR_DUPLICATENAME   = -7,
	UNAME_ERR_INCONSISTENT    = -8,
};

enum TRANSACTION_RESULT
{
	TRANSACTION_CLOSED	= 0,   // ½»Ò×ÒÑ¹Ø±Õ
	TRANSACTION_SUCCESS	= 1,   // ½»Ò×³É¹¦Íê³É
	TRANSACTION_FAILED	= 2,   // ½»Ò×Ê§°Ü
	TRANSACTION_TIMEOUT	= 3,   // GSÔÚÔ¤¶¨Ê±¼äÄÚÎ´È·ÈÏ½»Ò×½á¹û£¬¹é»¹ÎïÆ·
	TRANSACTION_UNKNOWN	= 4,   // GSÎ´ÊÕµ½½»Ò×µÄÖ´ÐÐ½á¹û
};

enum SWORD_ERRCODE
{
	ERROR_GENERAL                  = 9,     // Í¨ÓÃ´íÎó£¬ÍµÀÁ²»Ïë¼Ó´íÎóÂëÓÃÕâ¸ö
	ERROR_INVALID_PASSWORD         = 10,    // ÕÊºÅ»òÕßÃÜÂë´íÎó
	ERROR_MULTILOGIN               = 11,    // ÕÊºÅÒÑ¾­µÇÂ¼
	ERROR_PHONE_LOCK               = 12,    // µç»°ÃÜ±£´¦ÓÚËø¶¨ÖÐ
	ERROR_NOT_ACTIVATED            = 13,    // ±¾·þÎñÆ÷Ðè¾­¼¤»î·½¿ÉµÇÈë£¬¸ÃÕÊºÅÎ´¼¤»î¡£
	ERROR_ZONGHENG_ACCOUNT         = 14,    // ×ÝºáÖÐÎÄÍøÕÊºÅÎ´¾­¼¤»î²»ÄÜµÇÂ¼ÓÎÏ·¡£
	ERROR_FROZEN_ACCOUNT           = 15,    // ÎªÁËÓÅ»¯·þÎñÆ÷¸ºÔØ£¬Òò¸ÃÕÊºÅ³¤Ê±¼äÎ´µÇÂ¼ÓÎÏ·£¬ÒÑ±»·â½û£¬ÇëÓë¿Í·þÁªÏµ¡£
	ERROR_AUTHD_UNKNOWN            = 16,    // Î´ÖªAUTHD´íÎó
	ERROR_SERVER_CLOSED            = 17,    // ·þÎñÆ÷ÕýÔÚÎ¬»¤ÖÐ
	ERROR_SERVER_OVERLOAD          = 18,    // ·þÎñÆ÷ÈËÊý´ïµ½ÉÏÏÞ
	ERROR_BANNED_ACCOUNT           = 19,    // ÕÊºÅ±»½ûÖ¹µÇÂ¼
	ERROR_AUTHD_TIMEOUT            = 20,    // ÕÊºÅ·þÎñÆ÷ÈÏÖ¤³¬Ê±
	ERROR_PROXY_SEND               = 21,    // ProxyRpc×ª·¢Ê§°Ü
	ERROR_GM_KICKOUT               = 22,    // ¿Í·þÌßÈË
	ERROR_FORCE_LOGIN              = 23,    // ÕÊºÅ´ÓÆäËûµØ·½µÇÂ¼
	ERROR_AUTHD_KICKOUT            = 24,    // ÕÊºÅ·þÎñÆ÷ÌßÈË
	ERROR_ACCOUNT_FORBID           = 25,    // ÕÊºÅ±»·â½û
	ERROR_INVLAID_ACCOUNT          = 26,    // ÕÊºÅÊý¾Ý´íÎó
	ERROR_DB_LISTROLE              = 27,    // ´ÓÊý¾Ý¿â¶ÁÈ¡½ÇÉ«ÐÅÏ¢Ê§°Ü
	ERROR_LOGIN_PENDING            = 28,    // µÈ´ýÉÏ´ÎµÇÂ¼ÍË³ö
	ERROR_LOGIN_STATE              = 29,    // ÕÊºÅ×´Ì¬²»ÕýÈ·£¬µÇÂ¼Ê§°Ü
	ERROR_FORBID_IGNORE            = 30,    // ÒÑ¾­´æÔÚ¸ü³¤µÄÍ¬Àà·â½û¼ÇÂ¼
	ERROR_INVALID_SCENE            = 31,    // scene²»´æÔÚ
	ERROR_LOGINFREQUENT_USBKEY2    = 32,    // °ó¶¨¶þ´úÉñ¶ÜµÄÍ¨ÐÐÖ¤ÔÚ32ÃëÖ®ÄÚÖ»ÄÜµÇÂ½Ò»´Î¡£
	ERROR_GACD_KICKOUT             = 33,    // ·´Íâ¹ÒÏµÍ³ÌßÈË
	ERROR_MATRIX_FAILURE           = 34,    // ÃÜ±£ÑéÖ¤Ê§°Ü
	ERROR_NOT_IN_WHITELIST 	       = 35, 	// ²»ÔÚglinkdµÄ°×Ãûµ¥ÖÐ
	ERROR_IWEB_VERSION	       = 36,	// IWEB°æ±¾²»Ò»ÖÂ

	ERROR_DB_NOTFOUND              = 100,   // ¼ÇÂ¼Î´ÕÒµ½
	ERROR_DB_OVERWRITE             = 101,   // ²»ÄÜ¸²¸ÇÒÑÓÐ¼ÇÂ¼
	ERROR_DB_NULLKEY               = 102,   // ´íÎóµÄkey³¤¶È
	ERROR_DB_DECODE                = 103,   // ¼ÇÂ¼Êý¾Ý½âÂë´íÎó
	ERROR_DB_UNKNOWN               = 104,   // Î´ÖªÊý¾Ý¿â´íÎó
	ERROR_DB_INVALIDINPUT          = 105,   // ÇëÇó²ÎÊýÐ£ÑéÊ§°Ü
	ERROR_DB_CREATEROLE            = 106,   // ´´½¨½ÇÉ«Ê§°Ü
	ERROR_DB_DISCONNECT            = 107,   // ·þÎñÆ÷ÄÚ²¿´íÎó
	ERROR_DB_TIMEOUT               = 108,   // ·þÎñÆ÷ÄÚ²¿´íÎó
	ERROR_DB_NOSPACE               = 109,   // ·þÎñÆ÷ÉÏÃ»ÓÐÊ£Óà¿Õ¼ä
	ERROR_DB_VERIFYFAILED          = 110,   // Êý¾ÝÐ£ÑéÊ§°Ü
	ERROR_DB_CASHOVERFLOW          = 111,   // Ôª±¦½ð¶îÒÑ´ïÉÏÏÞ
	ERROR_DB_EXCEPTION             = 112,   // Êý¾Ý¿âÒì³£

	ERROR_ROLELIST_FULL            = 150,   // ±¾ÕÊºÅ²»ÄÜ´´½¨¸ü¶à½ÇÉ«
	ERROR_INVALID_NAME             = 151,   // Ãû×ÖÖÐº¬ÓÐ·Ç·¨×Ö·û
	ERROR_UNAMED_DISCONNECT        = 152,   // ²»ÄÜÁ¬½Óµ½Ãû×Ö·þÎñÆ÷£¬ÇëÉÔºî
	ERROR_UNAMED_NAMEUSED          = 153,   // ¸ÃÃû×ÖÒÑ¾­±»Ê¹ÓÃ
	ERROR_GAMEDBD_NAMEUSED         = 154,   // ¸ÃÃû×ÖÒÑ¾­±»Ê¹ÓÃ
	ERROR_ROLELIST_TIMEOUT         = 155,   // »ñµÃ½ÇÉ«ÁÐ±í³¬Ê±
	ERROR_NAME_WRONG_LEN           = 156,   // Ãû×ÖÌ«³¤»òÌ«¶Ì
	ERROR_VALID_PRO 	       = 157,   // µ±Ç°Ö°ÒµÉÐÎ´¿ª·Å£¬¾´ÇëÆÚ´ý

	ERROR_CMD_COOLING              = 200,   // ÃüÁî´¦ÓÚÀäÈ´ÖÐ
	ERROR_CMD_INVALID              = 201,   // ½ÇÉ«×´Ì¬´íÎó
	ERROR_DATA_EXCEPTION           = 202,   // Êý¾ÝÒì³£
	ERROR_DATA_LOADING             = 203,   // ÕýÔÚ¶ÁÈ¡Êý¾Ý
	ERROR_LINE_UNAVAILABLE         = 204,   // Ã»ÓÐ¿ÉÓÃµÄÏßÂ·
	ERROR_LINE_NOTFOUND            = 205,   // Ñ¡ÔñµÄÏßÂ·²»´æÔÚ
	ERROR_LINE_FULL                = 206,   // ¸ÃÏßÂ·Íæ¼ÒÊýÒÑ¾­´ïµ½ÉÏÏÞ
	ERROR_SERVER_NETWORK           = 207,   // ÍøÂçÍ¨ÐÅ´íÎó
	ERROR_ROLE_BANNED              = 208,   // ½ÇÉ«±»½ûÖ¹µÇÂ¼
	ERROR_ROLE_UNAVAILABLE         = 209,   // ½ÇÉ«²»ÄÜµÇÂ¼
	ERROR_ROLE_LOGINFAILED         = 210,   // µÇÂ¼ÓÎÏ··þÎñÆ÷Ê§°Ü
	ERROR_ROLE_MULTILOGIN          = 211,   // ½ÇÉ«ÒÑ¾­ÔÚÓÎÏ··þÎñÆ÷ÖÐ
	ERROR_ROLE_NOTFOUND            = 212,   // ½ÇÉ«²»´æÔÚ
	ERROR_INVALID_DATA             = 213,   // ÊÕµ½¿Í»§¶Ë·¢ËÍµÄ´íÎóÊý¾Ý
	ERROR_GS_DISCONNECTED          = 214,   // ·þÎñÆ÷ÄÚ²¿´íÎó
	ERROR_GS_DROPPLAYER            = 215,   // ÓÎÏ··þÎñÆ÷¶Ï¿ªÓÃ»§Á¬½Ó
	ERROR_CLIENT_SEND              = 216,   // ¿Í»§¶Ë½ÓÊÕÊý¾Ý³ö´í
	ERROR_CLIENT_RECV              = 217,   // ¿Í»§¶Ë·¢ËÍÊý¾Ý³ö´í
	ERROR_CLIENT_CLOSE             = 218,   // ¿Í»§¶ËÖ÷¶¯¹Ø±ÕÁ¬½Ó
	ERROR_CLIENT_TIMEOUT           = 219,   // ¿Í»§¶ËÁ¬½Ó³¬Ê±
	ERROR_CLIENT_INVALIDDATA       = 220,   // ¿Í»§¶ËÊÕµ½²»ÕýÈ·µÄÐ­Òé
	ERROR_CLIENT_DECODE            = 221,   // ¿Í»§¶ËÊÕµ½´íÎóµÄÐ­ÒéÊý¾Ý
	ERROR_ROLE_DELETED	       = 222,	// ½ÇÉ«ÒÑ¾­±»É¾³ý
	ERROR_SERVER_CLOSING	       = 223,	// ·þÎñÆ÷¼´½«¹Ø±Õ
	ERROR_WAIT_CONNECTION          = 224,	// ¶ÏÏßÖØÁ¬µÈ´ý

	ERROR_PLAYER_OFFLINE           = 301,   // Íæ¼Ò²»ÔÚÏß
	ERROR_TEAM_FULL                = 302,   // ¶ÓÎéÒÑÂú
	ERROR_TEAM_PLAYERINTEAM        = 303,   // Íæ¼ÒÒÑ¾­¼ÓÈë¶ÓÎé
	ERROR_TEAM_REFUSED             = 304,   // ¶Ô·½¾Ü¾ø×é¶ÓÑûÇë
	ERROR_TEAM_NOTFOUND            = 305,   // ¶ÓÎé²»´æÔÚ
	ERROR_TEAM_DENIED              = 306,   // Ã»ÓÐ¶Ó³¤È¨ÏÞ
	ERROR_TEAM_LEADEROFFLINE       = 307,   // ¶Ó³¤Ã»ÓÐÔÚÏß
	ERROR_TEAM_NOTONLINE           = 308,   // ²»ÔÚÏß¶ÓÔ±²»ÄÜ³ÉÎª¶Ó³¤
	ERROR_TEAM_DUPLICATE           = 309,   // ÖØ¸´·¢²¼¶ÓÎéÕÐÈËÐÅÏ¢
	ERROR_MAIL_BOXFROZEN           = 310,   // ¶Ô·½ÓÊÏä¶³½á
	ERROR_MAIL_BOXFULL             = 311,   // ¶Ô·½ÓÊÏäÒÑÂú
	ERROR_MAIL_NOTFOUND            = 312,   // ÓÊ¼þÃ»ÓÐÕÒµ½
	ERROR_MAIL_NOATTACHMENT        = 313,   // ¸½¼þÃ»ÓÐÕÒµ½
	ERROR_FRIEND_LISTFULL          = 320,   // ºÃÓÑÊýÁ¿´ïµ½ÉÏÏÞ
	ERROR_FRIEND_REFUSED           = 321,   // ¶Ô·½¾Ü¾øºÃÓÑÑûÇë
	ERROR_FRIEND_LOADING           = 322,   // ºÃÓÑÊý¾ÝÔÝÊ±²»¿ÉÓÃ
	ERROR_FRIEND_BLACKLISTFULL     = 323,   // ºÚÃûµ¥ÈËÊý´ïµ½ÉÏÏÞ
	ERROR_FRIEND_TIMEOUT           = 324,   // ¼ÓºÃÓÑ³¬Ê±
	ERROR_SECT_OFFLINE             = 330,   // Íæ¼Ò²»ÔÚÏß
	ERROR_SECT_UNAVAILABLE         = 331,   // ¶Ô·½ÒÑ¾­°ÝÊ¦
	ERROR_SECT_FULL                = 332,   // Í½µÜÊýÁ¿ÒÑ¾­´ïµ½ÉÏÏÞ
	ERROR_SECT_REFUSE              = 333,   // ¶Ô·½¾Ü¾øÁËÄãµÄÊÕÍ½ÑûÇë
	ERROR_SECT_INVALIDLEVEL        = 334,   // ¶Ô·½¼¶±ð²»Âú×ãÒªÇó
	ERROR_SECT_COOLING             = 335,   // Ò»ÌìÖ»ÄÜÕÐÊÕÒ»µÜ×Ó
	ERROR_SECT_DBERROR             = 336,   // ±£´æÊý¾ÝÊ§°Ü
	ERROR_SECT_NOTFOUND            = 337,   // ²éÕÒ²»µ½Ê¦ÃÅÐÅÏ¢
	ERROR_SECT_NONINSIDER          = 338,   // Íæ¼Ò²»ÊôÓÚ±¾Ê¦ÃÅ
	ERROR_TRANSACTION_PENDING      = 342,   // ½ÇÉ«Êý¾Ý´¦ÓÚÊÂÎñ×´Ì¬ÖÐ£¬ÔÝÊ±²»ÄÜ·¢ÆðÐÂµÄÊÂÎñ
	ERROR_TEAM_CLIENT_REFUSEED     = 343,   // ¶Ô·½¾Ü¾ø(¶Ô·½¿Í»§¶ËÔ­Òò)
	ERROR_TEAM_CANT_BE_LEADER      = 344,   // ×Ô¼ºÃ»¶ÓÎé£¬µ«¶Ô·½ÓÐ¶ÓÎé£¬ËùÒÔÎÞ·¨½¨ÐÂ¶ÓÎé³ÉÎª¶Ó³¤

	ERROR_TOP_LIST_ACTIVE          = 370,	// ±ÈÎäÅÅÃûÏµÍ³Î´¿ªÆô
	ERROR_MAX_FIGHT_RANK           = 371,	// Íæ¼ÒÅÅÃû³¬³ö×î¸ßÅÅÃû
	ERROR_WRONG_ADVERSARY          = 372,	// Ñ¡ÔñÁË´íÎóµÄ¶ÔÊÖ
	ERROR_ROLE_IN_BATTLE           = 373,	// Íæ¼ÒÕýÔÚ½ÓÊÜÌôÕ½
	ERROR_BATTLE_TIME_OUT          = 374,	// ÌôÕ½³¬Ê±
	ERROR_TOP_MIN_LEVEL            = 375,	// Íæ¼ÒÃ»ÓÐµ½´ïÌôÕ½µÈ¼¶
	ERROR_GET_REWARD               = 376,	// Íæ¼ÒÒÑ¾­ÁìÁË½±Àø
	ERROR_MAIL_FORCEDELETE         = 377,   // ²»ÄÜÉ¾³ýÓÐ¸½¼þµÄÓÊ¼þ

	ERROR_GS_LOADTIMEOUT           = 400,   // Êý¾Ý¿â¶ÁÈ¡³¬Ê±
	ERROR_GS_LOADEXCEPTION         = 401,   // Êý¾Ý¿â¶ÁÈ¡Ê§°Ü
	ERROR_GS_INVALIDDATA           = 402,   // ·Ç·¨µÄ½ÇÉ«Êý¾Ý
	ERROR_GS_INVALIDPOSITION       = 403,   // ½ÇÉ«´¦ÔÚ´íÎóµÄÎ»ÖÃ
	ERROR_GS_INVALIDWORLD          = 404,   // ÊÀ½çÀàÐÍ´íÎó
	ERROR_GS_MULTILOGIN            = 405,   // Íæ¼ÒÒÑ¾­´¦ÓÚµÇÈë×´Ì¬
	ERROR_GS_LOADFAILED            = 406,   // ¼ÓÔØÍæ¼ÒÊý¾ÝÊ§°Ü
	ERROR_GS_OVERLOADED            = 407,   // ±¾Ïß´ïµ½ÈËÊýÉÏÏÞ
	ERROR_GS_INVALIDSTATE          = 408,   // Íæ¼Ò×´Ì¬´íÎó
	ERROR_GS_DROPDELIVERY          = 409,   // GSÓëDS¶Ï¿ªÁ¬½Ó£¬Á¬½Ó»Ö¸´ÖÐ
	ERROR_MARRY_GENDER             = 410,   // ÐÔ±ð´íÎó
	ERROR_MARRY_NOT_SINGLE         = 411,   // »éÒö×´Ì¬´íÎó
	ERROR_MARRY_COOLTIME           = 412,   // »éÒöÀäÈ´ÖÐ
	ERROR_MARRY_WRONG_LEVEL        = 413,   // ÈËÎï¼¶±ð²»¹»
	ERROR_MARRY_REJECTED           = 414,   // ¶Ô·½¾Ü¾ø
	ERROR_MARRY_ITEM               = 415,   // È±ÉÙÎïÆ·
	ERROR_VOTE_VOTING              = 416,   // ÒÑ¾­ÔÚÍ¶Æ±ÖÐ
	ERROR_MARRY_NOT_2PERSON        = 417,   // ×é³ÉÔ±²»ÊÇ2¸öÈË
	ERROR_MARRY_NOT_ENGAGED        = 418,   // Î´¶©»é
	ERROR_MARRY_AMITY              = 419,   // ºÃ¸Ð¶È²»¹»
	ERROR_MARRY_POSITION           = 420,   // ×é³ÉÔ±²»ÔÚÒ»¿é
	ERROR_MARRY_NOT_TEAMLEADER     = 421,   // ÉêÇëÕß²»ÊÇ×é³¤
	ERROR_VOTE_FAILED              = 422,   // Í¶Æ±½á¹ûÎ´Í¨¹ý
	ERROR_FAMILY_LACK_OF_MONEY     = 423,   // È±ÉÙ²Ù×÷ËùÐèÒªµÄ½ðÇ®
	ERROR_TEAM_OFFLINE             = 424,   // ×é¶ÓÖÐÓÐ³ÉÔ±²»ÔÚÏß
	ERROR_FAMILY_DIFF_LINE         = 425,   // ×é¶ÓÖÐÓÐ³ÉÔ±²»ÔÚÍ¬Ò»ÌõÏß
	ERROR_FAMILY_LEVEL_LIMIT       = 426,   // ×é¶ÓÖÐÓÐ³ÉÔ±µÈ¼¶²»¹»
	ERROR_FAMILY_FRIENDLY_LIMIT    = 427,   // ×é¶ÓÖÐÓÐ³ÉÔ±Ö®¼äµÄºÃ¸Ð¶È²»¹»
	ERROR_FAMILY_MENTOR_LIMIT      = 428,   // ×é¶ÓÖÐ´æÔÚÊ¦Í½¹ØÏµ
	ERROR_FAMILY_HAS_FAMILY        = 429,   // ×é¶ÓÖÐÓÐ³ÉÔ±ÒÑ¾­ÔÚÄ³¸ö½áÒåÖÐ
	ERROR_FAMILY_COOLTIME          = 430,   // ×é¶ÓÖÐÓÐ³ÉÔ±´¦ÓÚ½áÒåÀäÈ´ÆÚ
	ERROR_FAMILY_BAD_NAME          = 431,   // ²»ºÏ·¨µÄÃû×Ö
	ERROR_FAMILY_DUP_NAME          = 432,   // ÖØ¸´µÄÃû×Ö
	ERROR_FAMILY_NOT_TEAMLEADER    = 433,   // ²Ù×÷ÈË²»ÊÇ×é³¤
	ERROR_FAMILY_MEMBER_LIMIT      = 434,   // ÈËÊý³¬¹ý½áÒåÉÏÏÞ
	ERROR_FAMILY_LEADER_NO_FAMILY  = 435,   // ×é³¤²»ÊÇ½áÒå³ÉÔ±
	ERROR_FAMILY_NOT_ALL_ONLINE    = 436,   // ²»ÊÇËùÓÐ½áÒå³ÉÔ±¶¼ÔÚÏß
	ERROR_FAMILY_NO_NEW_MEMBER     = 437,   // Ã»ÓÐÒªÐÂ¼ÓÈëµÄ³ÉÔ±
	ERROR_FAMILY_NO_ITEM           = 439,   // È±ÉÙ²Ù×÷ËùÐèÎïÆ·
	ERROR_FAMILY_NOT_MEMBER        = 440,   // ×é¶ÓÖÐÓÐ²»ÊÇ½áÒå³ÉÔ±
	ERROR_FAMILY_NEED_MORE_MEMBER  = 441,   // ÐèÒª¸ü¶àµÄ½áÒå³ÉÔ±ÔÚ×é¶ÓÖÐ
	ERROR_INSTANCE_NOTFOUND        = 442,   // ¸±±¾Ã»ÓÐÕÒµ½
	ERROR_VOTE_TIMEOUT             = 443,   // Í¶Æ±³¬Ê±
	ERROR_LOST_CONNECTION          = 444,   // Ê§È¥Óë¿Í»§¶ËµÄÁ¬½Ó
	ERROR_TRUSTEE_DUPLICATE        = 445,   // ÖØ¸´µÄÊÜÍÐÈË
	ERROR_TRUSTEE_COUNT_LIMIT      = 446,   // ÊÜÍÐÈËÊý³¬¹ýÉÏÏÞ
	ERROR_TRUSTEE_NOTFOUND         = 447,   // ÍÐ¹Ü¹ØÏµ²»´æÔÚ
	ERROR_TRUSTEE_SELF             = 448,   // ²»ÄÜÖ¸¶¨×Ô¼ºÕÊºÅÏÂµÄ½ÇÉ«ÎªÊÜÍÐÈË
	ERROR_TRUSTEE_PERMISSION       = 449,   // ÊÜÍÐÈËÃ»ÓÐ²Ù×÷È¨ÏÞ
	ERROR_TRUSTOR_ONLINE           = 450,   // Î¯ÍÐÈËÕýÔÚÓÎÏ·ÖÐ
	ERROR_FRIEND_BUFF_INVALID      = 451,   // ·¢ËÍÈËÃ»ÓÐÕâ¸ö¼¼ÄÜ»òÕß¼¶±ð²»¶Ô
	ERROR_FRIEND_BUFF_SEND1_COOL   = 452,   // ·¢ËÍÀäÈ´ÖÐ
	ERROR_FRIEND_BUFF_SEND2_COOL   = 453,   // ÒÑ´ïµ½ÈÕ·¢ËÍÉÏÏÞ
	ERROR_FRIEND_BUFF_RECV_COOL    = 454,   // ½ÓÊÕÀäÈ´ÖÐ
	ERROR_FRIEND_BUFF_NOT_REMOTE   = 455,   // ·ÇÔ¶³Ì¼¼ÄÜ
	ERROR_FAMILY_VOTE_ERROR        = 456,   // ·¢Æð½áÒåÄÚÍ¶Æ±Ê§°Ü
	ERROR_FAMILY_VOTE_VOTING       = 457,   // ÓÐÍ¬ÑùµÄ½áÒåÄÚÍ¶Æ±ÕýÔÚ½øÐÐ
	ERROR_FAMILY_VOTE_VOTING_MAX   = 458,   // ´ïµ½Í¬Ê±ÔÊÐí½øÐÐµÄ½áÒåÄÚÍ¶Æ±ÉÏÏÞÁË
	ERROR_FAMILY_VOTE_VOTED        = 459,   // ¸öÈËÒÑ¾­Í¶¹ýÆ±ÁË
	ERROR_FAMILY_POSITION          = 460,   // ×éÔ±Ã»ÓÐÔÚÒ»¿é
	ERROR_MARRY_NOTINONETEAM       = 461,   // ·òÆÞ²»ÔÚÍ¬Ò»×é
	ERROR_MARRY_NOT_SPOUSE         = 462,   // Ò»·½²»ÊÇÁíÒ»·½µÄÅäÅ¼
	ERROR_FAMILY_VOTE_START        = 463,   // ÒòÄ³²Ù×÷¶ø¿ªÊ¼Í¶Æ±ÁË£¬Êµ¼ÊÉÏ²»ÊÇ´íÎó£¬ÊÇÒ»¸öÖÐ¼ä×´Ì¬
	ERROR_MARRY_NOT_MARRIED        = 464,   // Î´½á»é
	ERROR_STOCK_CLOSED             = 465,   // Ôª±¦½»Ò×ÕË»§ÒÑ¹Ø±Õ
	ERROR_STOCK_ACCOUNTBUSY        = 466,   // Ôª±¦ÕË»§Ã¦
	ERROR_STOCK_INVALIDINPUT       = 467,   // ·Ç·¨ÊäÈë
	ERROR_STOCK_OVERFLOW           = 468,   // Ôª±¦»ò½ðÇ®ÊýÖµÒç³ö
	ERROR_STOCK_DATABASE           = 469,   // Êý¾Ý¿â´íÎó
	ERROR_STOCK_NOTENOUGHCASH      = 470,   // Ôª±¦²»×ã
	ERROR_STOCK_MAXCOMMISSION      = 471,   // ³¬¹ý×î´ó¹Òµ¥Êý
	ERROR_STOCK_NOTFOUND           = 472,   // Î´ÕÒµ½Ïà¹Ø¼ÇÂ¼
	ERROR_STOCK_CASHLOCKED         = 473,   // Ôª±¦½»Ò×ÒÑËø¶¨
	ERROR_STOCK_CASHUNLOCKFAILED   = 474,   // Ôª±¦½»Ò×½âËøÊ§°Ü
	ERROR_STOCK_NOFREEMONEY        = 475,   // ÎÞ¿ÉÈ¡³ö½ðÇ®
	ERROR_STOCK_NOTENOUGHMONEY     = 476,   // °ü¹ü½ðÇ®²»×ã
	ERROR_SECT_QUIT_COOLING        = 477,   // ÅÑÊ¦ÀäÈ´
	ERROR_SECT_EXPEL_COOLING       = 478,   // ¿ª³ýÍ½µÜÀäÈ´
	ERROR_SECT_RECOMMENDED         = 479,   // ÒÑ¾­ÊÇ¸ÃÊ¦¸¸µÄ¼ÇÃûµÜ×ÓÁË
	ERROR_SECT_TEACH_COOLING       = 480,   // ½ñÌìÒÑ¾­½Ì¹ýÁË
	ERROR_SECT_NOCONSULT           = 481,	// Çë½ÌµÄ»ú»áÓÃ¹âÁË
	ERROR_SECT_NOT_VICE_MENTOR     = 482,	// ±»Çë½ÌÕß²»ÊÇ¼ÇÃûÊ¦¸¸
	ERROR_SECT_UPGRADE_LIMIT       = 483,	// Ê¦µÂ²»¹»£¬ÎÞ·¨Éý¼¶×ÚÊ¦µÈ¼¶
	ERROR_FRIEND_CANNOT_BLACK      = 484,	// ÌØÊâ×éÖÐµÄºÃÓÑÎÞ·¨¼ÓÈëµ½ºÚÃûµ¥
	ERROR_SECT_RELATION            = 485,	// ÎÞÇ×ÓÑ¹ØÏµ£¬ÎÞ·¨ÍÆ¼öÍ½µÜ
	ERROR_SECT_NOT_DISCIPLE        = 486,	// Ö»ÄÜ¹ÄÀøÎ´³öÊ¦Í½µÜ
	ERROR_HOME_NOTLOADED           = 487,   // ¼ÒÔ°Êý¾ÝÎ´¼ÓÔØ
	ERROR_HOME_COOLING             = 488,   // ÃüÁîÀäÈ´ÖÐ
	ERROR_HOME_TIMEOUT             = 489,   // ³¬Ê±
	ERROR_HOME_LOCKED              = 490,   // Ëø¶¨×´Ì¬£¬²Ù×÷½øÐÐÖÐ
	ERROR_HOME_UNMARSHAL           = 491,   // ½âÂëÊý¾Ý³ö´í
	ERROR_HOME_INVALIDINPUT        = 492,   // ÊäÈëÊý¾Ý·Ç·¨
	ERROR_HOME_INVALIDSTATE        = 493,   // ·Ç·¨×´Ì¬
	ERROR_HOME_PERMISSION          = 494,   // ÎÞ²Ù×÷È¨ÏÞ
	ERROR_HOME_OFFLINE             = 495,   // Íæ¼Ò²»ÔÚÏß
	ERROR_HOME_NOTFRIEND           = 496,   // ²»ÊÇºÃÓÑ
	ERROR_HOME_NOSEED              = 497,   // ÖÖ×Ó»òÓ×ÊÞ²»´æÔÚ
	ERROR_HOME_NOENOUGHPRODUCEPOINT= 498,   // Éú²úµã²»×ã
	ERROR_HOME_AMBUSH_FULL         = 499,   // Âñ·üÈËÊýÒÑÂú
	ERROR_HOME_STOREHOUSE_FULL     = 500,   // ²Ö¿âÒÑÂú
	ERROR_HOME_AMBUSHING           = 501,   // ÒÑ´¦ÓÚÂñ·ü×´Ì¬
	ERROR_HOME_NOFREEPRODUCTS      = 502,   // Ã»ÓÐ¿ÉÊÕ»ñ/ÍµÇÔµÄ²úÎï£¨ÍµÇÔÊ±ÓÐ±£Áô¸öÊýÏÞÖÆ£©
	ERROR_HOME_STEALSELF           = 503,   // ²»ÄÜÍµ×ÔÒÑ
	ERROR_HOME_STEALAGAIN          = 504,   // ÔÙ´ÎÍµÇÔ
	ERROR_HOME_STEALCAUGHT         = 505,   // ÍµÇÔ±»×¥
	ERROR_HOME_FRUITPROTECTED      = 506,   // ¹ûÊµ´¦ÓÚ²ÉÕª±£»¤ÆÚ
	ERROR_HOME_PRODUCESKILL        = 507,   // ËùÐèÉú²ú¼¼ÄÜ»ò¼¼ÄÜµÈ¼¶²»·ûºÏÒªÇó
	ERROR_HOME_NOTENOUGHPACKSPACE  = 508,   // ·Ç°²È«Çø»ò°ü¹ü¿Õ¼ä²»×ã£¬ÎïÆ·ÒÑ¾­´æÈëÏµÍ³ÓÊ¼þÖÐ£¬Çë×ÔÐÐÈ¡³ö
	ERROR_HOME_NO_ENOUGH_FORAGE    = 509,   // ËÇÁÏ²»×ã
	ERROR_HOME_TOO_MANY_FORAGE     = 510,   // ËÇÁÏ¹ý¶à
	ERROR_HOME_INVALID_ACTION      = 511,   // ·Ç·¨²Ù×÷
	ERROR_HOME_PLOT_NOT_FREE       = 512,   // µØ¿é·Ç¿Õ
	ERROR_HOME_CAPACITY            = 513,   // ³¬¹ýÈÝÁ¿ÏÞÖÆ
	ERROR_HOME_PLOT_INACTIVE       = 514,   // µØ¿éÎ´¿ª·Å
	ERROR_HOME_PLOT_BLESSED        = 515,   // µØ¿éÒÑ±»Æí¸£
	ERROR_FACTION_BAD_NAME         = 516,   // ·Ç·¨Ãû
	ERROR_FACTION_DUP_NAME         = 517,   // ÖØÃû
	ERROR_FACTION_MONEY            = 518,   // Ç®²»¹»
	ERROR_FACTION_SERVER           = 519,   // ·þÎñÆ÷ÄÚ²¿´íÎó
	ERROR_FACTION_FULL             = 520,   // °ïÅÉÈËÊý´ïµ½ÉÏÏÞ
	ERROR_FACTION_PERMISSION       = 521,   // Ã»ÓÐÈ¨ÏÞ
	ERROR_FACTION_REFUSED          = 522,   // ¶Ô·½¾Ü¾ø
	ERROR_FACTION_LEVEL_MAX        = 523,   // ÒÑ¾­Éýµ½×î¸ß¼¶
	ERROR_FACTION_COST             = 524,   // Éý¼¶ËùÐè×ÊÔ´²»×ã
	ERROR_FACTION_TMP_MEMBER       = 525,   // ¹ÒÃû³ÉÔ±²»ÄÜÈÎÃâ
	ERROR_FACTION_UNAVAILABLE      = 526,   // Ö°Î»ÓÐÈË
	ERROR_FACTION_SUBFACTION       = 527,   // ·Ö¶æ×´Ì¬²»¶Ô
	ERROR_FACTION_SPOUSE           = 528,   // ÒòÅäÅ¼ÓÐÖ°Îñ¶ø²»ÄÜÈÎÃâ
	ERROR_FACTION_WRONG_POSITION   = 529,   // ÎÞÐ§Ö°Î»
	ERROR_FACTION_EXPEL_COOLING    = 530,   // ÌßÈËÀäÈ´
	ERROR_FACTION_HAS_FACTION      = 531,   // ±»¼ÓÕßÒÑ¾­ÓÐ°ïÅÉ
	ERROR_GRADE_INVALIDLEVEL       = 532,   // Íæ¼Ò²»ÔÚÈÎºÎÍ¬µÈ¼¶ÆµµÀÖÐ
	ERROR_SHARE_EXPIRE             = 533,   // ×£¸£¹ýÆÚÊ§Ð§	
	ERROR_SHARE_FULL               = 534,   // ·ÇºÃÓÑ×£¸£ÒÑÂú
	ERROR_SHARE_GRADE              = 535,   // µÈ¼¶Çø¼ä²»·û
	ERROR_SHARE_AGAIN              = 536,   // ÒÑ¾­×£¸£¹ýÁË
	ERROR_SHARE_SELF               = 537,   // ²»ÄÜ×£¸£×Ô¼º
	ERROR_SHARE_INVALID            = 538,   // ÎÞÐ§µÄ×£¸£
	ERROR_DEL_ROLE_FAMILY          = 539,   // ÒÑ½áÒåµÄ½ÇÉ«²»ÄÜÉ¾³ý
	ERROR_DEL_ROLE_FACTION         = 540,   // ¼ÓÈë°ïÅÉµÄ½ÇÉ«²»ÄÜÉ¾³ý
	ERROR_DEL_ROLE_DISCIPLE        = 541,   // Î´³öÊ¦µÄ½ÇÉ«²»ÄÜÉ¾³ý
	ERROR_DEL_ROLE_MENTOR          = 542,   // ÒÑÊÕÍ½µÄ½ÇÉ«²»ÄÜÉ¾³ý
	ERROR_DEL_ROLE_MARRIAGE        = 543,   // ÒÑ½á»éµÄ½ÇÉ«²»ÄÜÉ¾³ý
	ERROR_INVENTORY_FULL           = 544,   // °ü¹üÒÑÂú
	ERROR_INVENTORY_BIND_MONEY_FULL= 545,   // ÒøÆ±Ð¯´øÊýÒÑ´ïÉÏÏÞ
	ERROR_INVENTORY_TRADE_MONEY_FULL=546,   // Òø×ÓÐ¯´øÊýÒÑ´ïÉÏÏÞ
	ERROR_HOME_BLESS_NO_CHANCES    = 547,   // ÎÞÆí¸£»ú»á
	ERROR_HOME_CLOSED              = 548,   // ¼ÒÔ°Ä£¿éÎ´¿ªÆô
	ERROR_SECT_FAMILY              = 549,   // ½áÒå¹ØÏµ²»ÄÜ°ÝÊ¦
	ERROR_SNS_QUALITY              = 550,   // Ã»ÓÐ×Ê¸ñ·¢´ËÕ÷ÓÑÐÅÏ¢
	ERROR_SNS_EXISTED              = 551,   // ÒÑ¾­·¢¹ý´ËÕ÷ÓÑÐÅÏ¢ÁË
	ERROR_SNS_NOTFOUND             = 552,   // ÕÒ²»µ½Õ÷ÓÑÐÅÏ¢
	ERROR_FAMILY_CREATE_WAIT       = 553,   // ´´½¨½áÒå/Ìí¼Ó³ÉÔ±²Ù×÷»¹ÔÚµÈ´ý¶ÓÔ±·´À¡
	ERROR_FAMILY_APPLY             = 554,	// ½áÒåÆäËû³ÉÔ±ÒÑ¾­ÉêÇë
	ERROR_LESS_LEVEL               = 555,	// Íæ¼ÒµÈ¼¶Ì«µÍ
	ERROR_GREATER_LEVEL            = 556,	// Íæ¼ÒµÈ¼¶¹ý¸ß
	ERROR_NO_FAMILY                = 557,	// Íæ¼Ò²»ÊôÓÚÈÎºÎ½áÒå
	ERROR_IN_ALLIANCE_WAR          = 558,	// ÃËÖ÷Õ½½øÐÐÖÐ
	ERROR_ALLIANCE_MONEY           = 559,	// ÃËÖ÷½ð²»×ã
	ERROR_CANNOT_SPECTATE          = 560,	// ²»ÄÜ½øÐÐ¹ÛÕ½
	ERROR_ALLIANCE_CANNT_APPLY     = 561,	// ÏÖÔÚ²»ÄÜÉêÇëÃËÖ÷Õ½
	ERROR_ALLIANCE_MAX_FAMILY      = 562,	// ÉêÇë²ÎÕ½µÄ½áÒå´ïµ½ÉÏÏÞ
	ERROR_FAMILY_LEAGUE            = 563,	// ÃËÖ÷ËùÔÚ½áÒå
	ERROR_ALLIANCE_CANNT_START     = 564,	// ÃËÖ÷Õ½ÉÐÎ´¿ªÊ¼
	ERROR_ALLIANCE_WAR_NO_APPLY    = 565,	// Ã»ÓÐÉêÇëÃËÖ÷Õ½
	ERROR_FAMILY_IN_ALLIANCE_WAR   = 566,	// ½áÒåÕýÔÚÃËÖ÷Õ½ÖÐ£¬²»ÄÜÍ¶Æ±
	ERROR_NOT_LEAGUE               = 567,	// Ã»ÓÐÃËÖ÷È¨ÏÞ
	ERROR_LEAGUE_MONEY_LIMIT       = 568,	// ÃËÖ÷È¡Ç®Êý´ïµ½ÉÏÏÞ
	ERROR_LEAGUE_COOLDOWN          = 569,	// ÃËÖ÷È¨ÏÞÀäÈ´Ê±¼äÄÚ
	ERROR_FACTION_LEVEL_MIN        = 570,	// ¹ó°ï¹æÄ£Ì«Ð¡£¬²»×ãÒÔ¿ª×ÚÁ¢ÅÉ¡£
	ERROR_FACTION_BASE_MONEY       = 571,	// Õâ¿ÉÊÇ½ü°ÙÄ¶µÄÒ»Õû¿éµØÄØ£¬ÇøÇø**Ôª±¦£¬¿ÉÕæ²»Ëã¹ó
	ERROR_FACTION_BASE_ERROR       = 572,	// ²»ºÃÒâË¼£¬ÕâÖÜÎ§µÄµØÆ¤¶¼±»ÆäËûÎäÁÖÍæ¼Ò¹ºÂòÁË
	ERROR_FACTION_TEAM             = 573,	// ÔÚ½­ºþÀïÃ»µãÅóÓÑ£¬½¨Á¢°ï»á¿É²»ÊÇºÃÍæµÄ
	ERROR_FACTION_MEMBER_LESS_LEVEL= 574,	// ´´½¨¶ÓÎéÖÐÆäËûÍæ¼ÒµÈ¼¶¹ýµÍ
	ERROR_FACTION_MEMBER_FRIEND    = 575,	// ´´½¨°ïÅÉ»¥ÎªºÃÓÑ£¬ÇÒºÃÓÑ¶È´ïµ½ÒªÇó
	ERROR_FACTION_NOT_READY        = 576,	// °ïÅÉÊý¾ÝÎ´×¼±¸ºÃ
	ERROR_FACTION_MERGEREQ_INVALID = 577,	// °ïÅÉºÏ²¢ÇëÇóÊ§°Ü
	ERROR_FACTION_STATUS_CANNOTDO  = 578,	// °ïÅÉµ±Ç°×´Ì¬²»ÄÜ½øÐÐ´Ë²Ù×÷
	ERROR_FACTION_MERGEREQ_AGREE   = 579,	// ¶Ô·½Í¬ÒâºÏ°ï
	ERROR_FACTION_MERGEREQ_DISAGREE= 580,	// ¶Ô·½²»Í¬ÒâºÏ°ï
	ERROR_FACTION_MERGEVOTE_FAILED = 581,   // ·¢ÆðÍ¶Æ±Ê§°Ü
	ERROR_FACTION_DB_WAIT          = 582,	// Êý¾Ý¿âÃ¦£¬ÔÝÊ±ÎÞ·¨·þÎñ
	ERROR_FACTION_STATE            = 583,	// °ïÅÉ×´Ì¬²»´í´íÎó
	ERROR_FACTION_MAX_COUNT        = 584,	// °ïÅÉÊýÒÑÂú£¬²»ÄÜ´´½¨ÐÂ°ïÅÉ
	ERROR_FACTION_TIMEOUT          = 585,	// °ïÅÉ½¨Á¢³¬Ê±
	ERROR_FACTION_INVALID_DATA     = 586,	// °ïÅÉÊý¾Ý´íÎó
	ERROR_FACTION_ITEM             = 587,   // ÎïÆ·²»Æë
	ERROR_FACTION_NOTFOUND         = 588,	// Ã»ÓÐÕÒµ½ÏàÓ¦µÄ°ïÅÉ
	ERROR_FACTION_NO_BASE          = 589,	// °ïÅÉÃ»ÓÐ»ùµØ
	ERROR_FACTION_MAX_SUB          = 590,	// °ïÅÉ·Ö¶æÊýÒÑÂú
	ERROR_FACTION_GETPARA	       = 591,	// »ñÈ¡°ïÅÉÐ­Òé²ÎÊý´íÎó	
	ERROR_FACTION_DOWORKCOOLDOWN   = 592,	// »¹Î´ÀäÈ´£¬²»ÄÜ´ò¹¤
	ERROR_FACTION_DOWORKSTATUS     = 593,	// µ±Ç°×´Ì¬²»ÄÜ´ò¹¤
	ERROR_ROLE_NOFACTION           = 594,	// Íæ¼ÒÃ»ÓÐ¼ÓÈë°ïÅÉ
	ERROR_FACTION_APPLIED          = 595,	// ÒÑ¾­ÉêÇë
	ERROR_FACTION_INMERGE	       = 596,	// °ïÅÉÒÑ¾­ÔÚºÏ²¢¹ý³ÌÖÐ
	ERROR_FACTION_MERGEVOTE_NOTPASS= 597,	// ºÏ²¢Í¶Æ±Î´Í¨¹ý
	ERROR_FACTION_MERGEVOTE_WAIT   = 598,	// ºÏ²¢Í¶Æ±Í¨¹ý£¬´ý¶Ô·½°ïÅÉÍ¶Æ±È·ÈÏ
	ERROR_FACTION_VOTE_OPEN        = 599,	// Í¶Æ±¿ªÍ¨Ê§°Ü
	ERROR_FACTION_MERGE_MAX        = 600,	// ºÏ²¢ÈËÊý¹ý¶à
	ERROR_FACTION_SUB_COOLDOWN     = 601,	// ½â³ý·Ö¶æÀäÈ´Ê±¼ä
	ERROR_FACTION_CONTRIBUTAION    = 602,	// °ïÅÉ½¨Éè¶È²»×ã
	ERROR_FACTION_CLUB             = 603,	// °ïÅÉÐ­×÷Öµ²»×ã
	ERROR_FACTION_INVALIDHIREREQ   = 604,	// ·Ç·¨´ò¹¤ÇëÇó
	ERROR_FACTION_APPLYCOOLDOWN    = 605,	// ÉêÇë¼ÓÈë°ïÅÉÀäÈ´
	ERROR_FACTION_STOREFULL	       = 606,	// °ïÅÉ²Ö¿âÒÑÂú
	ERROR_FACTION_REBELTIMEFAILED  = 607,	// ´ÛÈ¨Ê±¼ä²»·ûºÏÌõ¼þ
	ERROR_FACTION_SUB_FACTION      = 608,	// ÒÑ¾­ÔÚÕâ¸ö°ï½¨Á¢ÁË·Ö¶æ
	ERROR_FACTION_TEMPLATE	       = 609,	// °ïÅÉÄ£°åÊý¾Ý²»ÕýÈ·
	ERROR_FACTION_BASE_ACTIVITY    = 610,	// °ïÅÉ»ùµØ½«ÒòÎª»îÔ¾¶È²»×ã¹Ø±Õ
	ERROR_FACTION_BASE_CLOSED      = 611,	// °ïÅÉ»ùµØ¹Ø±Õ
	ERROR_FACTION_BASE_MEMBERS     = 612,	// °ïÅÉ»ùµØ½«ÒòÎª³ÉÔ±²»×ã¹Ø±Õ
	ERROR_FACTION_ACTIVITYOPEN     = 613,   // °ïÅÉÓÐ»î¶¯ÒÑ¾­¿ªÆô
	ERROR_FACTION_ACTIVITYEND      = 614,   // °ïÅÉÓÐ»î¶¯ÒÑ¾­½áÊø
	ERROR_FAMILY_CALL_MISS         = 615,	// ÓÐ³ÉÔ±ÔÚÌØÊâÇøÓòÎÞ·¨ÏìÓ¦½áÒåÕÙ¼¯
	ERROR_STOCK_TXNCOOLING         = 616,   // ÊÂÎñ²Ù×÷ÀäÈ´ÖÐ

	ERROR_TEAM_IN_INSTANCE         = 630,	// ¶ÓÎéÒÑ¾­¿ªÆôÁËÒ»¸ö¸±±¾
	ERROR_NOT_ENOUGH_MEMBER        = 631,	// ¶ÓÎéÈËÊý²»×ã
	ERROR_CREATE_INSTANCE          = 632,	// ´´½¨¸±±¾Ê§°Ü
	ERROR_INSTANCE_TIME            = 633,   // ¸±±¾·µ»ØÊ±¼äÏÞÖÆ
	ERROR_INSTANCE_BOARD           = 634,	// ¸±±¾°æÃæÏÞÖÆ
	ERROR_INSTANCE_CLOSE           = 635,	// ¸±±¾¹Ø±Õ
	ERROR_INSTANCE_PLAYER_CANCEL   = 636,	// Íæ¼Ò×Ô¼º¹Ø±Õ¹ÜÀíÃæ°å
	ERROR_INSTANCE_MAX_TIMES       = 637,	// Íæ¼Ò³¬¹ý½øÈë¸±±¾´ÎÊýÉÏÏÞ

	ERROR_HOME_NO_FREE_SPACE       = 640,	// ¼ÒÔ°µØÍ¼ÒÑÂú
	ERROR_HOME_INTERNAL            = 641,   // ¼ÒÔ°ÄÚ²¿´íÎó
	ERROR_HOME_EXIST               = 642,	// ÒÑÓÐ¼ÒÔ°
	ERROR_HOME_NO_HOME             = 643,	// Ã»ÓÐ¼ÒÔ°
	ERROR_HOME_SCENE               = 644,	// ¼ÒÔ°µØÍ¼´íÎó
	ERROR_HOME_BUILD_POINT         = 645,	// ½¨Éè¶È²»×ã
	ERROR_HOME_RESOURCE            = 646,	// ×ÊÔ´²»×ã
	ERROR_HOME_DUPLICATE           = 647,	// ÖØ¸´
	ERROR_HOME_LEVEL               = 648,	// ¼ÒÔ°»òÕß½¨ÖþµÈ¼¶´íÎó

	ERROR_FCITY_NOKINGAPPLYSUCCESS = 659,	//ÎÞÁúÍ·µØÍ¼ÉêÇë·Ö¶æ³É¹¦
	ERROR_FCITY_DB_CORRUPT	       = 660,	//Êý¾Ý¿âÒ»ÖÂÐÔ´íÎó
	ERROR_FCITY_DB_SUBADD_EXIST    = 661,	//¸Ã°ïÔÚ±¾µØÍ¼ÒÑ¾­ÓÐ·Ö¶æ»ò×Ü¶æ
	ERROR_FCITY_SERVER	       = 662,	//°ïÅÉÊÆÁ¦·þÎñÆ÷´íÎó
	ERROR_FCITY_APPLYEXIST	       = 663,	//¸Ã°ïÅÉµÄ·Ö¶æÉêÇëÒÑ¾­´æÔÚ
	ERROR_FCITY_APPLYFULL          = 664,	//ÊÆÁ¦µØÍ¼·Ö¶æÐÅÏ¢ÒÑÂú
	ERROR_FCITY_NOTFOUND           = 665,	//°ïÅÉÊÆÁ¦µØÍ¼²»´æÔÚ
	ERROR_FCITY_SUBEXIST           = 666,	//¸Ã·Ö¶æÒÑ¾­´æÔÚ
	ERROR_FCITY_SUBNOTEXIST        = 667,	//¸ÃµØÍ¼²»´æÔÚ¸Ã·Ö¶æ
	ERROR_FCITY_MAINEXIST          = 668,	//¸Ã×Ü¶æÒÑ¾­´æÔÚ
	ERROR_FCITY_MAINNOTEXIST       = 669,	//¸ÃµØÍ¼²»´æÔÚ¸Ã×Ü¶æ
	ERROR_FACTION_CITYEXIST        = 670,	//¸Ã°ïÒÑÓÐ´ËÊÆÁ¦µØÍ¼
	ERROR_FACTION_CITYNOTEXIST     = 671,	//¸Ã°ïÃ»ÓÐ¸ÃÊÆÁ¦µØÍ¼
	ERROR_FACTION_CITYFULL         = 672,	//¸Ã°ïÊÆÁ¦µØÍ¼ÊýÁ¿ÒÑÂú
	ERROR_FACTION_INVALIDCITYNUM   = 673,	//°ïÅÉÒÑÓÐµÄÊÆÁ¦µØÍ¼ÊýÄ¿²»ºÏ·¨
	ERROR_FACTION_INITCITY         = 674,	//³õÊ¼ÊÆÁ¦µØÍ¼
	ERROR_FCITY_AUCPRICE_LESS      = 675,	//³ö¼ÛÌ«ÉÙ
	ERROR_FCITY_AUCTIONCLOSE       = 676,	//ÅÄÂô½áÊø
	ERROR_FCITY_DB_RELOAD	       = 677,	//ÐèÒªÖØµ¼Êý¾Ý
	ERROR_FACTION_AUCTIONPOINT_LESS = 678,	//¾ºÅÄµãÌ«ÉÙÁË
	ERROR_FACTION_APDONATED	       = 679,	//Ã¿ÌìÖ»ÄÜ¾èÒ»´Î
	ERROR_FACTION_APMASTERNAME     = 680,	//ÊÜÒæ·½°ïÖ÷Ãû²»Ïà·ûºÏ
	ERROR_FCITY_SUBFULL	       = 681,	//ÊÆÁ¦µØÍ¼·Ö¶æÒÑÂú
	ERROR_FCITY_MAINFULL	       = 682,	//ÊÆÁ¦µØÍ¼×Ü¶æÒÑÂú
	ERROR_FCITY_NOTOPEN	       = 683,	//ÊÆÁ¦µØÍ¼Î´¿ª·Å
	ERROR_FCITY_NOTINAUC	       = 684,	//ÊÆÁ¦µØÍ¼µ±Ç°Ã»ÓÐ´¦ÓÚÅÄÂô×´Ì¬ÖÐ
	ERROR_FCITY_WEIGHTVALID	       = 685,	//ÊÆÁ¦µØÍ¼ÉèÖÃÈ¨ÖØÊý¾Ý²»ºÏ·¨
	ERROR_FCITY_SUBINPROTECT       = 686,	//¸Ã·Ö¶æ´¦ÓÚ±£»¤ÆÚ²»ÄÜÉ¾³ý
	ERROR_FCITY_AUCPRICE_TWICE     = 687,	//ÊÆÁ¦µØÍ¼¾ºÅÄ°ïÅÉÖØ¸´³ö¼Û
	ERROR_FACTION_CITYCONSLESS     = 688,	//¿ªÍØÊÆÁ¦Ê±½¨Éè¶È²»¹»
	ERROR_FCITY_FACTIONFULL	       = 689,	//ÊÆÁ¦µØÍ¼¿ÉÈÝÄÉµÄ°ïÅÉÊýÒÑÂú
	ERROR_FCITY_POWERLESS	       = 690,	//ÊÆÁ¦µØÍ¼¿ª·ÅËùÐèÒªµÄÐÂÊÆÁ¦²»¹»
	ERROR_FACTION_NOMAIN	       = 691,	//×Ü¶æ°áÇ¨Ê±£¬Ô´ÊÆÁ¦µØÍ¼Ã»ÓÐ×Ü¶æ
	ERROR_FACTION_NOSUB	       = 692,	//×Ü¶æ°áÇ¨Ê±£¬Ä¿µÄÊÆÁ¦µØÍ¼Ã»ÓÐ·Ö¶æ
	ERROR_FACTION_AUCNOBASE        = 693,	//Ã»ÓÐ»ùµØµÄ°ïÅÉ²»ÔÊÐí¾ºÅÄ
	ERROR_TEAM_MEMBER_TOO_FAR      = 694,	//¶ÓÎé³ÉÔ±ÀëµÄÌ«Ô¶
	ERROR_FACTION_NOTNEARCITY      = 695,	//·ÇÁÙ½üÊÆÁ¦µØÍ¼£¬²»ÄÜÉêÇë

	ERROR_AUCTION_PRICE            = 700,	//ÅÄÂô¼Û¸ñ²»Âú×ãÌõ¼þ
	ERROR_AUCTION_TYPE             = 701,	//ÅÄÂôÀàÐÍ²»Âú×ãÌõ¼þ
	ERROR_AUCTION_NONE             = 702,	//µ±Ç°Ã»ÓÐÅÄÂô
	ERROR_AUCTION_NOT_START        = 703,	//ÅÄÂôÎ´¿ªÆô
	ERROR_AUCTION_BID_TWICE        = 704,	//ÖØ¸´³ö¼Û

	ERROR_MINGXING_EMPTY           = 711,	//Ã»ÓÐ¸ÃÃ÷ÐÇ»òÕßÃ÷ÐÇÃ»ÓÐÐÎÏó±¸·Ý
	ERROR_MINGXING_NO_CHANGE       = 712,	//Ã÷ÐÇÐÎÏóÃ»ÓÐ±ä»¯

	ERROR_LIST_END			= 721,	//µ½´ïÁÐ±í½áÎ²
	ERROR_LIST_WRONG_TYPE		= 722,	//ÁÐ±íÀàÐÍ´íÎó
	ERROR_LIST_ABATE_DATA		= 723,	//Ê§Ð§Êý¾Ý
	ERROR_WRONG_KEY			= 724,	//Ë÷Òý²éÑ¯´íÎó

	ERROR_ENOUGH_REPU		= 730,	//Ã»ÓÐ×ã¹»µÄ²ÐÒ³
	ERROR_WRONG_ENEMY		= 731,	//Ñ¡ÔñµÄ¶ÔÊÖ²»´æÔÚ

	ERROR_DST_ZONE_DISCONNECT	= 740,	//ÂþÓÎÄ¿±ê·þÎñÆ÷ÎÞ·¨Á¬½Ó
	ERROR_ZONE_NOT_REGISTER		= 741,	//µ±Ç°·þÎñÆ÷Ã»ÓÐ×¢²á
	ERROR_HUB_SERVER_DISCONNECT	= 742,	//ÂþÓÎÄ¿±ê·þÎñÆ÷ÎÞ·¨Á¬½ÓHUB·þÎñÆ÷
	ERROR_WRONG_ZONE_ROAM		= 743,	//Ä¿±ê·þÎñÆ÷´íÎó
	ERROR_ROAM_TIMEOUT		= 744,	//ÂþÓÎ³¬Ê±
	ERROR_ROAM_ROLE_NOTFOUND	= 745,	//ÂþÓÎ½ÇÉ«Êý¾Ý²éÕÒÊ§°Ü
	ERROR_ROAM_WRONG_STATUS		= 746,	//´íÎóµÄ½ÇÉ«×´Ì¬
	ERROR_ROAM_DECODE		= 747,	//ÂþÓÎ½ÇÉ«Êý¾Ý¼ÓÔØ´íÎó
	ERROR_ROAM_GENERAL		= 748,	//ÂþÓÎÍ¨ÓÃ´íÎó
	ERROR_ROAM_KICKOUT		= 749,	//ÂþÓÎ×´Ì¬´íÎó£¬Ìßµô
	ERROR_ROAM_SPECIAL_CMD		= 750,	//Í¨ÖªGSÏÂÏß£¬ÇÒ²»´æÅÌ
	ERROR_ROAM_SAVE_STATUS		= 751,	//ÂþÓÎ½ÇÉ«ÕýÔÚÏÂÏß
	ERROR_ROAM_NETWORK		= 752,	//ÍøÂç´íÎó£¬¿ÉÄÜÐèÒªÖØÐÂ´æÅÌ
	ERROR_ROAM_STATUS		= 753,	//Íæ¼ÒÕýÔÚÂþÓÎ×´Ì¬
	ERROR_WRONG_DST_ZONE		= 754,	//Ñ¡ÔñÁË´íÎóµÄ·þÎñÆ÷
	ERROR_WRONG_HUB_PROTOCOL	= 755,	//´íÎóµÄ¿ç·þÐ­Òé
	ERROR_ROLEID_STATUS		= 756,	//Íæ¼ÒÊý¾Ý´íÎó
	ERROR_HUB_TIMEOUT		= 757,	//¿ç·þ×ª·¢Êý¾Ý³¬Ê±
	ERROR_ROAM_RECONNECT		= 758,	//¿ç·þÁ¬½Ó¶Ï¿ªÖØÁ¬
	ERROR_ROAM_OTHER_ROLE		= 759,	//µÇÂ½ÁËÆäËû½ÇÉ«

	ERROR_TIGUAN_ALREADY		= 780,	//½ñÌìÒÑ¾­Ìß¹ýÁË
	ERROR_TIGUAN_ING		= 781,	//Ä¿±ê°ïÅÉÕýÔÚ±»ÌßÖÐ
	ERROR_TIGUAN_NOT_KING		= 782,	//Ä¿±ê°ïÅÉ·ÇÁúÍ·
	ERROR_TIGUAN_NOT_FULL		= 783,	//Ä¿±ê³ÇÊÐ×Ü¶æÎ´Âú
	ERROR_TIGUAN_CANT_ENTER		= 784,	//Ä¿±ê»ùµØÕýÔÚÌß¹Ý£¬ÎÞ·¨½øÈë
	ERROR_TIGUAN_SRCNOMAIN		= 785,	//Ìß¹Ý·½ÔÚÔ´ÊÆÁ¦µØÍ¼Ã»ÓÐ×Ü¶æ
	ERROR_TIGUANED_SRCNOMAIN	= 786,	//±»Ìß¹Ý·½ÔÚÔ´ÊÆÁ¦µØÍ¼Ã»ÓÐ×Ü¶æ
	ERROR_TIGUAN_DSTNOSUB		= 787,	//Ìß¹Ý·½ÔÚÄ¿µÄÊÆÁ¦µØÍ¼Ã»ÓÐ·Ö¶æ
	ERROR_TIGUANED_DSTNOSUB		= 788,	//±»Ìß¹Ý·½ÔÚÄ¿µÄÊÆÁ¦µØÍ¼Ã»ÓÐ·Ö¶æ
	ERROR_TIGUAN_SUB_NOTNEARCITY	= 789,	//Ìß¹Ý·½ÊÆÁ¦µØÍ¼Í¬ÉêÇëÍ¨ÐÐµÄÊÆÁ¦µØÍ¼²»½ÓÈÀ
	ERROR_TIGUANED_SUB_DSTNOTKING	= 790,	//±»Ìß¹Ý·½²»ÊÇÉêÇëÍ¨ÐÐµÄÊÆÁ¦µØÍ¼µÄÁúÍ·
	ERROR_TIZI_HASEXIST		= 791,	//Í¿Ñ»°åÉÏÒÑ¾­ÓÐÄÚÈÝ
	ERROR_TIZI_NOTEXIST		= 792,	//Í¿Ñ»°åÉÏÃ»ÓÐÄÚÈÝ
	ERROR_FACTION_TIZINOTTIGUAN	= 793,	//¹ó°ï²»ÊÇÌß¹Ý·¢ÆðÕß£¬²»ÄÜÌâ×Ö
	ERROR_TIGUANED_NODST		= 794,	//±»Ìß¹Ý·½µÄ×Ü¶æÎÞ´¦¿É°áÁË
	ERROR_FACTION_TIZICOOLDOWN	= 795,	//Ìâ×ÖÀäÈ´

	ERROR_MATCH_DISABLE             = 811,  //Æ¥Åä¹¦ÄÜÒÑ¹Ø±Õ
	ERROR_MATCH_ING                 = 812,  //[¶ÓÎéÓÐ]Íæ¼ÒÒÑ¾­ÔÚÆ¥ÅäÖÐÁË
	ERROR_MATCH_NO_TEAM             = 813,  //×é¶ÓÆ¥Åäµ«Ã»ÓÐ¶ÓÎé
	ERROR_MATCH_NOT_TEAM_LEADER     = 814,  //×é¶ÓÆ¥ÅäÐèÒª¶Ó³¤·¢Æð
	ERROR_MATCH_WRONG_POS           = 815,  //±ØÐëÔÚ ´óÊÀ½ç+°²È«Çø ²ÅÄÜÆ¥Åä
	ERROR_MATCH_CANT_ENTER          = 816,  //²»Âú×ã½ø¸±±¾µÄÌõ¼þ
	ERROR_MATCH_OFFLINE             = 817,  //¶ÓÎéÖÐÓÐÍæ¼Ò²»ÔÚÏß
	ERROR_MATCH_TEAM_PROF           = 818,  //¶ÓÎéÖÐÒÑÓÐÖØ¸´Ö°Òµ
	ERROR_MATCH_FULL_TEAM           = 819,  //ÒÑÂúÔ±¶ÓÎé¾Í±ðÀ´²óºÍÁË
	ERROR_MATCH_NOT_OPEN		= 820,  //»î¶¯Ê±¼äÃ»¿ª

	ERROR_ADD_CASH_REPEAT		= 831,  //ÖØ¸´µÄAddCashÃüÁî
	ERROR_MUCH_PENDING_ORDER	= 832,  //Î´Íê³É³äÖµÌ«¶à

	ERROR_INVALID_ACTIVE_CODE	= 841,  //ÎÞÐ§¼¤»îÂë
	ERROR_USED_ACTIVE_CODE		= 842,  //Ê¹ÓÃ¹ýµÄ¼¤»îÂë
	ERROR_USER_NEED_ACTIVE		= 843,  //ÕÊºÅÐèÒª¼¤»î
	ERROR_CLOSE_DELETE_ROLE         = 844,  //É¾ºÅ¹¦ÄÜÒÑ¾­¹Ø±Õ£¬ÎÞ·¨É¾³ý½ÇÉ«




	ERROR_HAVE_BANGHUI         	= 900,  //ÒÑ¾­ÓÐ°ï»áÁË£¬ÎÞ·¨ÉêÇëÆäÓà°ï»á
	ERROR_APPLY_BANGHUI_MAX         = 901,  //ÉêÇë°ï»áµÄ¸öÈË´ïµ½ÁËÉÏÏÞ
	ERROR_APPLY_BANGHUI_WRONG       = 902,  //°ï»á²»´æÔÚ
	ERROR_NOT_IN_APPLY_BANGHUI      = 903,  //²»ÔÚÕâ¸ö°ïÅÉµÄÉêÇëÁÐ±í
	ERROR_DONOT_HAVE_BANGHUI        = 904,  //Ã»ÓÐ°ï»á
	ERROR_DONOT_HAVE_YOU_INBANGHUI  = 905,  //ÄãËùÔÚµÄ°ï»á³ÉÔ±ÀïÃæÃ»ÓÐÄã
	ERROR_DONOT_HAVE_POWER          = 906,  //Ã»ÓÐ°ï»áÈ¨ÏÞ
	ERROR_BANGHUI_FULL	        = 907,  //°ïÅÉÈËÊýÂúÁË£¬ÎÞ·¨¼ÓÈË
	ERROR_NOT_IN_BANGHUI            = 908,  //ÒÑ¾­²»ÔÚÉêÇëÁÐ±íÖÐÁË
	ERROR_DONOT_IN_YOUR_BANGHUI    	= 909,  //²»ÔÚÄãµÄ°ï»áÀïÃæ
	ERROR_DONOT_FIND_BANGHUI        = 910,  //Ã»ÓÐ·ûºÏÄã²éÕÒÌõ¼þµÄ°ï»á
	ERROR_CANNOT_CREATE_BANGHUI     = 911,  //ÒÑ¾­ÓÐ°ï»áÁË£¬ÎÞ·¨´´½¨°ï»á
	ERROR_YOU_NOTIN_BANGHUI         = 912,  //ÄãÃ»ÓÐ°ï»á
	ERROR_NOTIN_APPLY               = 913,  //Äã²»ÊÇÕâ¸ö°ï»áµÄÉêÇë³ÉÔ±
	ERROR_HAVE_IN_APPLY             = 914,  //ÄãÒÑ¾­ÊÇÕâ¸ö°ï»áµÄÉêÇë³ÉÔ±ÁË
	ERROR_NOTICE_TOO_LONG           = 915,  //¹«¸æÉèÖÃÌ«³¤
	ERROR_BANGHUI_NUM_FULL          = 916,  //°ïÅÉÊýÁ¿´ïµ½ÉÏÏÞ
	ERROR_BANGHUI_NOT_IN_MANAGER    = 917,  //¹ÜÀíÆ÷ÖÐÃ»ÓÐ°ï»áID
	ERROR_BANGHUI_CAN_NOT_DELETE    = 918,  //µ±Ç°ÓÐ°ï»áÎÞ·¨É¾ºÅ
	ERROR_BANGHUI_HAVE_BANGHUI_APPLY  = 919,  //ÒÑ¾­ÓÐ°ï»áÁË
	ERROR_BANGHUI_INVITE_NOTONLINE  = 920,  //±»ÑûÇëµÄÍæ¼Ò²»ÔÚÏß
	ERROR_BANGHUI_CANNOT_INVITE     = 921,  //ÄãÎÞ·¨ÑûÇë±ðÈË¼ÓÈë°ï»á
	ERROR_BANGHUI_INVITE_HAVE       = 922,  //±ðÑûÇëµÄÍæ¼ÒÓÐ°ï»áÁË
	ERROR_BANGHUI_HAVE_INVITED      = 923,  //ÒÑ¾­ÑûÇëÁËÕâ¸öÍæ¼Ò
	ERROR_BANGHUI_DEFUSE_INVITE     = 924,  //¾Ü¾øÑûÇë
	ERROR_BANGHUI_NOT_IN_INVITE     = 925,  //Ã»ÓÐ±»ÑûÇë
	ERROR_BANGHUI_INVITE_HAVE_BANGHUI     = 926,  //ÄãÒÑ¾­ÓÐ°ï»áÁË£¬ÎÞ·¨ÔÙ´Î½ÓÊÜÑûÇë
	ERROR_BANGHUI_NAME_TOO_LONG     = 927,  //°ï»áÃû×ÖÌ«³¤
	ERROR_BANGHUI_LEVEL_TOO_LOW     = 928,  //µÈ¼¶²»×ã
	ERROR_BANGHUI_INVITE_LEVEL_LOW  = 929,  //±»ÑûÇëµÄÈËµÈ¼¶²»×ã
	ERROR_BANGHUI_NAME_INVILAD      = 930,  //°ï»áµÄÃû×Ö·Ç·¨
	ERROR_BANGHUI_NAME_SAME         = 931,  //Õâ¸ö°ï»áÒÑ¾­´æÔÚ£¬Çë»»Ò»¸öÃû×Ö
	ERROR_BANGHUI_YUANBAO_LESS      = 932,  //Ôª±¦²»×ã
	ERROR_BANGHUI_OPERATOR_FAST     = 933,  //²Ù×÷Ì«¿ì
	ERROR_BANGHUI_FUBANGZHU_MAX     = 934,  //¸±°ïÖ÷ÈËÊý´ïµ½ÉÏÏÞ
	ERROR_BANGHUI_IS_FUBANGZHU      = 935,  //ÒÑ¾­ÊÇ¸±°ïÖ÷ÁË
	ERROR_BANGHUI_IS_BANGZHONG      = 936,  //ÒÑ¾­ÊÇ°ïÖÚÁË
	ERROR_BANGHUI_LEAVE_CD          = 937,  //Àë¿ªÉÏÒ»¸ö°ï»á²»×ã22Ð¡Ê±£¬»¹ÎÞ·¨¼ÓÈëÐÂµÄ°ï»á
	ERROR_BANGHUI_TOP_LIST_LAST     = 938,  //°ï»áÅÅÐÐ°ñ´ïµ½×îºóÒ»Ò³ÁË
	ERROR_BANGHUI_APPLY_IS_FULL     = 939,  //°ï»áÅÅÐÐ°ñ´ïµ½×îºóÒ»Ò³ÁË
	ERROR_BANGHUI_NOT_IN_TIGUAN_TIME     = 940,  //µ±Ç°²»ÔÚ¿ÉÒÔÌß¹ÝµÄÊ±¼äÖ®ÄÚ
	ERROR_BANGHUI_CREATE_72_HOURS_ATT     = 941,  //ÄãµÄ°ï»á½¨Á¢Ê±¼ä²»×ã72Ð¡Ê±
	ERROR_BANGHUI_CREATE_72_HOURS_DEF     = 942,  //ÄãÌß¹ÝµÄ°ï»á½¨Á¢Ê±¼ä²»×ã72Ð¡Ê±
	ERROR_BANGHUI_TIGUAN_NUM_MAX     = 943,  //Ìß¹ÝÊýÁ¿´ïµ½ÉÏÏÞ
	ERROR_BANGHUI_TIGUAN_REPEATED    = 944,  //ÄãÒÑ¾­¶Ô±ðµÄ°ï»á½øÐÐÁËÌß¹Ý
	ERROR_BANGHUI_TIGUAN_NOT_IN_TIME = 945,  //²»ÔÚÌß¹ÝÊ±¼äÄÚ
	ERROR_BANGHUI_TIGUAN_NO_DEFENCE  = 946,  //Ã»ÓÐ°ï»áÌß¹ÝÄãÃÇ
	ERROR_BANGHUI_TIGUAN_NO_ATTACK   = 947,  //ÄãÃÇÃ»ÓÐ¶Ô±ðµÄ°ï»á½øÐÐÌß¹Ý
	ERROR_BANGHUI_TIGUAN_JOIN_TIME   = 948,  //¼ÓÈë°ï»á²»×ãÒ»Ìì£¬²»¿ÉÒÔ½øÐÐÌß¹Ý
	ERROR_BANGHUI_TIGUAN_DEFENCE_FULL   = 949,  //°ï»á·ÀÓùµÄÈËÊýÒÑ¾­´ïµ½ÉÏÏÞ
	ERROR_BANGHUI_TIGUAN_ATTACK_FULL   = 950,  //°ï»á½ø¹¥µÄÈËÊýÒÑ¾­´ïµ½ÉÏÏÞ

	ERROR_ARENA_NO_COST_CHANCE	= 951,  //¾º¼¼³¡ÊÕ·ÑÌôÕ½´ÎÊýÒÑ¾­ÓÃ¹â
	ERROR_ARENA_OUT_OF_CASH		= 952,  //Ôª±¦²»×ãÒÔÖ§¸¶¾º¼¼³¡ÊÕ·ÑÌôÕ½
	ERROR_ARENA_NOT_VIP		= 953,  //vipµÈ¼¶²»×ã£¬²»ÄÜ¹ºÂò¾º¼¼³¡ÊÕ·Ñ´ÎÊý
	ERROR_DB_MAIL_ITEM_EXIST        = 954,  //ÓÊ¼þ·¢ËÍ½±Àø£¬µ¥ºÅÒÑ¾­´æÔÚ

	ERROR_SERVER_PREPARING		= 961,	//·þÎñÆ÷Î´¿ª·Å(¿Í»§¶ËÊÕµ½»á¶Ï¿ªÁ¬½Ó)

	ERROR_BANGHUI_TIGUAN_DISMISS   = 990,  //Ìß¹ÝÆÚ¼ä²»¿ÉÒÔ½âÉ¢°ï»á
	ERROR_BANGHUI_TIGUAN_JOINING   = 991,  //Ìß¹ÝÕýÔÚ½øÐÐÖÐ
	ERROR_BANGHUI_AUTO_APPLY_NO    = 992,  //Ò»¼üÉêÇëÃ»ÓÐÉêÇëµ½°ï»á

	ERROR_SERVER_STATUS1		= 1001,  //ÉÐÎ´¿ª·þ£¬Çë12µãÔÙÀ´
	ERROR_SERVER_STATUS2		= 1002,  //ÉÐÎ´¿ª·þ£¬ÇëÉÔºòÔÙÀ´
	ERROR_SERVER_STATUS3		= 1003,  //Î¬»¤ÖÐ
};

enum
{
	PLAYER_GENDER_MALE = 0, // ÄÐÐÔ
	PLAYER_GENDER_FEMALE = 1, // Å®ÐÔ
};

enum VOTE_RESULT
{
	VOTE_RE_AGREE = 0, // Í¬Òâ
	VOTE_RE_DISAGREE = 1, // ²»Í¬Òâ
	VOTE_RE_MUTE = 2, // ÆúÈ¨
};

enum PLAYER_MESSAGE_ID
{
	PMID_PEEK_YOUR_PROFILE	= 1, // ÓÐÈËÔÚ²é¿´ÄãµÄÃûÆ¬
	PMID_FAMILY_CREATE	= 2, // ½¨Á¢½áÒå
	PMID_FAMILY_ADD		= 3, // ½áÒå¼ÓÈË
	PMID_FAMILY_CHANGENAME  = 4, // ½áÒå¸ÄÃû
	PMID_FAMILY_NICKNAME	= 5, // ¸Ä¸öÈË½áÒåÃû
	PMID_FAMILY_EXPEL	= 6, // ½áÒå¿ªÈË
	PMID_MARRIAGE_MARRY	= 7, // ½á»é³É¹¦
	PMID_MARRIAGE_PROPOSE	= 8, // ¶©»é³É¹¦
	PMID_HOME_ACTION	= 9, // ¼ÒÔ°²Ù×÷
	PMID_PEEK_YOUR_EQUIP	= 10,//ÓÐÈË²é¿´ÄãµÄ×°±¸
	PMID_HOME_BUY		= 11,//»ñÈ¡¼ÒÔ°³É¹¦
};

enum GROUP_SERVER_ID
{
	GSI_INVALID		= 0,	//²»¿ÉÓÃ
	GSI_FACTION_MASTER	= 1,	//°ïÖ÷Èº

	GSI_COUNT,
};

enum REPUTATION_ID
{
	REPUID_CHARM		= 0,	// Éç½»÷ÈÁ¦
	REPUID_FAME		= 1,	// Éç½»ÃûÍû
	REPUID_SECT		= 2,	// Ê¦µÂ
	REPUID_LIVE		= 3,	// Éú»îÃûÍû
	REPUID_WULIN		= 4,	// ÎäÁÖÉùÍû
	REPUID_PK		= 5,	// PKÉùÍû
	REPUID_DISPLAY_MAX	= 16,	// ×î¶à¿É¼û
	REPUID_SECT_HIDE	= 16,	// Ê¦µÂÏà¹Ø£¬Òþ²Ø
	REPUID_FACTION_CONTRIBUTION = 22,	// °ïÅÉ¹±Ï×¶ÈÀÛ¼ÆÖµ
	REPUID_FACTION_CONTRIBUTION2 = 23,	// °ïÅÉ¹±Ï×¶Èµ±Ç°Öµ
	REPUID_PROF_OFFSET	= 25,	// ´ËÊýÖµ+ÃÅÅÉid¾ÍÊÇÃÅÅÉ¹±Ï×ÖµµÄindex£¬ÈçÉÙÁÖÊÇ26
	REPUID_FUZHOU		= 37,	//¸£ÖÝ³ÇÉùÍû
	REPUID_HENGSHAN		= 38,	//ºâÉ½³ÇÉùÍû
	REPUID_LUOYANG		= 39,	//ÂåÑô³ÇÉùÍû
	REPUID_GENEROUS		= 43,	// ÉÆÖµ
	REPUID_BATTLE_MONEY	= 44,	// ¾º¼¼±Ò
	//51 - 90 ÎäÑ§²ÐÒ¶
	REPUID_FACTION_CREATE_START = 95,	// °ïÅÉ´´½¨ºóÔö¼ÓÉùÍû·¶Î§
	REPUID_FACTION_CREATE_END = 104,	// °ïÅÉ´´½¨ºóÔö¼ÓÉùÍû·¶Î§
	REPUID_JUEWEI		= 110,	// ¾ôÎ»ÅÅÃûÉùÍû

	REPUID_SWEEP_DAILY_FREE = 161,	//µ±ÈÕÃâ·Ñ´³¹Ø´ÎÊý
	REPUID_SWEEP_DAILY_CASH	= 162,	//µ±ÈÕ¸¶·Ñ´³¹Ø´ÎÊý
	REPUID_SWEEP_HISTORY 	= 163,	//´³¹ØÀúÊ·×î´ó°æÃæ
	REPUID_ZONE_RENOWN_USED	= 171,	// ÊÀ½çÍþÃû	ÀÛ¼ÆÖµ
	REPUID_ZONE_RENOWN	= 172,	// ÊÀ½çÍþÃû	µ±Ç°Öµ
	REPUID_ZONE_ROAM_MONEY	= 173,	// ÂþÓÎÊÀ½ç²Æ¸»
	REPUID_ZONE_ROAM_TIME	= 174,	// ÂþÓÎÊ±¼ä
	REPUID_ZONE_KILLS	= 177,	// ±¾´ÎÂþÓÎÁ¬ÐøÉ±ÈËÊý»òÕßÁ¬ÐøÉ±ÂþÓÎÕßÊý
	REPUID_ZONE_ALL_KILLS	= 178,	// ±¾´ÎÂþÓÎ×ÜÉ±ÈËÊý
	REPUID_ZONE_MAX_KILLS	= 179,	// ±¾´ÎÂþÓÎ×î¸ßÁ¬É±Êý
	REPUID_YUHANG		= 192,	// Óàº¼ÉùÍû
	REPUID_NANJIANG		= 193,	// ÄÏ½®ÉùÍû

	REPUID_MAX		= 256,	// ×î¶à
};

enum REPUTATION_CONSTANT
{
	REPUTATION_VERSION	= 0x03,
	MIN_REPUTATION_VALUE	= 0,
	MAX_REPUTATION_VALUE	= 200000000,
	FORCE_INT		= 0x7fffffff,
};

inline bool IsDeliverReputation(unsigned short id) //deliver¸ºÔð±£´æµÄÉùÍû
{
	if(id >= 51 && id <= 90) return true;	//ÎäÑ§²ÐÒ³
	return false;
}

inline bool IsGsReputation(unsigned short id) //gs¸ºÔð±£´æµÄÉùÍû
{
	if(IsDeliverReputation(id)) return false;
	return true;
}

//NOTE: ÉùÍû²»ÄÜÔÚÔÂÇåºÍ·ÇÔÂÇåÖ®¼äÒ¡°Ú, Òª´æÅÌµÄ!
inline bool IsMonthClearReputation(unsigned short id) //ÔÂÇåÉùÍûÁÐ±í
{
	if(id == GNET::REPUID_JUEWEI)
		return true;
	return false;
}

inline bool IsPeriodReputation(unsigned short id) //ÔÂÇåÈÕÇåµÈÀàÐÍµÄÉùÍû
{
	if (IsMonthClearReputation(id))
		return true;
	//...
	return false;
}

inline int GetMonthClearReputationDelay(unsigned short id)
{
	if(id == GNET::REPUID_JUEWEI)
		return (6-1)*86400 + 0*3600 + 0*0; //¾ôÎ»ÉùÍûÃ¿ÔÂ6ÈÕ0µã0·ÖÇåÁã
	return 0;
}

// ½áÒåÄÚÍ¶Æ±
enum FAMILY_VOTE_REASON
{
	FAMILY_VOTE_RS_CHANGE_NAME = 0,	// ¸Ä½áÒåÃû
	FAMILY_VOTE_RS_EXPEL_MEMBER,	// ¿ª³ý³ÉÔ±
	FAMILY_VOTE_RS_GLAD_BIRTH,	// ³ÉÔ±ÉúÈÕ£¨ÒÔÏÂ²»ÊÇÍ¶Æ±¶øÊÇÏ²ÊÂ£©
	FAMILY_VOTE_RS_GLAD_MARRY,	// ³ÉÔ±½á»é
	FAMILY_VOTE_RS_GLAD_FACTION,	// ³ÉÔ±½¨Á¢°ïÅÉ
	FAMILY_VOTE_RS_GLAD_TOP,	// ³ÉÔ±ÉÏÅÅÐÐ°ñ
	FAMILY_VOTE_RS_COUNT,	// ÀíÓÉÊý
};
enum FAMILY_VOTE_STATUS
{
	FAMILY_VOTE_ST_VOTING = 0,	// Í¶Æ±ÖÐ
	FAMILY_VOTE_ST_AGREED = 1,	// Í¶Æ±½áÊø£¬Í¨¹ý
	FAMILY_VOTE_ST_DISAGREED = 2,	// Í¶Æ±½áÊø£¬¾Ü¾ø
	FAMILY_VOTE_ST_GLAD = 3,	// Ï²ÊÂ£¬²»ÊÇÍ¶Æ±
};
enum FAMILY_VOTE_EVENT
{
	FAMILY_VOTE_EVT_NEW = 0,	// ¿ªÊ¼ÐÂÍ¶Æ±
	FAMILY_VOTE_EVT_REPLY = 1,	// ÓÐÈËÍ¶Æ±
	FAMILY_VOTE_EVT_END = 2,	// Í¶Æ±½áÊø
	FAMILY_VOTE_EVT_DEL = 3,	// É¾³ýÌõÄ¿
};
enum TITLE_INDEX
{
	TITLE_INDEX_NULL = 0,	// ²»Ê¹ÓÃtitle
	TITLE_INDEX_MARRIAGE_GROOM = 1,	// ¸øÐÂÀÉµÄ³ÆºÅ£¬±ÈÈç***µÄÏà¹«
	TITLE_INDEX_MARRIAGE_BRIDE = 2,	// ¸øÐÂÄïµÄ³ÆºÅ£¬±ÈÈç***µÄÄï×Ó
	TITLE_INDEX_FAMILY = 3,	// Ê¹ÓÃ½áÒåtitle
	TITLE_INDEX_SECT = 4,	// Ê¹ÓÃÊ¦Í½title
	TITLE_INDEX_FACTION_POS = 5,	// Ê¹ÓÃ°ïÅÉÖ°Î»title
	TITLE_INDEX_FACTION_TI = 6,	// Ê¹ÓÃ°ïÅÉÈÙÓþÉí·Ýtitle

	TITLE_INDEX_NORMAL_BEGIN = 1000,	// ÆÕÍ¨titleµÄÆðÊ¼id
};

enum SECT_STATUS
{
	SECT_STATUS_NULL = 0,	// »¹Ã»ÓÐ°ÝÊ¦
	SECT_STATUS_DISCIPLE = 1,	// µ±Í½µÜÁË
	SECT_STATUS_GRADUATE = 2,	// ³öÊ¦ÁË
	SECT_STATUS_MENTOR = 3,	// ÊÕÍ½ÁË£¬¼´Ê¹ÓÐÊ¦¸µÒ²ÊÇ³öÊ¦×´Ì¬
};

enum SECT_QUIT_REASON
{
	SECT_QUIT_REASON_EXPEL = 0,	// ±»ÇýÖð
	SECT_QUIT_REASON_QUIT = 1,	// ÅÑÊ¦
	SECT_QUIT_REASON_GRADUATE = 2,	// ³öÊ¦
};

enum
{
	SECT_DISCIPLE_LEVEL_LIMIT = 50,	// Í½µÜµÈ¼¶ÉÏÏÞ
	SECT_MENTOR_LEVEL_LIMIT = 50,	// Ê¦¸¸µÈ¼¶ÏÂÏÞ
	SECT_VICE_MENTOR_MAX = 6,	// Í½µÜ×î¶àÓÐ¼¸¸ö¼ÇÃûÊ¦¸¸
	SECT_OFFLINE_SAFE_TIME = 72 * 3600,	// ¶à¾Ã²»ÉÏÏß¿É±»ÎÞÔðÈÎ¿ª³ý
	SECT_TEACH_AMITY = 20,		// ½ÌÍ½µÜ»¥ÏàÔö¼ÓÓÑºÃ¶È
	SECT_CONSULT_AMITY = 3,		// Çë½Ì¼ÇÃûÊ¦¸¸Ôö¼ÓÓÑºÃ¶È
	SECT_CONSULT_REPUTATION = 5,	// Çë½Ì¼ÇÃûÊ¦¸¸Ôö¼ÓÉÆÖµ
};

enum
{
	// ÐÞ¸ÄºÃÓÑ·Ö×é id Ê±±ØÐëÐÞÄ FriendManager::ValidUserGroup/ValidSysGroup
	FRIEND_GROUP_SPOUSE = 0x8000,	// ½á»é
	FRIEND_GROUP_FAMILY = 0x4000,	// ½áÒå
	FRIEND_GROUP_SECT = 0x2000,	// Ê¦Í½×é£ºÊ¦¸¸¡¢¼ÇÃûÊ¦¸¸¡¢µÜ×Ó

	FRIEND_GROUP_SYS_MASK = 0xff00,
	FRIEND_GROUP_USER_MASK = 0x00ff,
};

enum BUFF_ADD_REASON
{
	BUFF_ADD_BY_FAMILY_CREATE = 0,	// ½áÒå³É¹¦
	BUFF_ADD_BY_SECT_QUIT = 1,	// ÅÑÀëÊ¦ÃÅ
	BUFF_ADD_BY_SECT_EXPEL = 2,	// Öð³öµÜ×Ó
	BUFF_ADD_BY_SECT_ENCOURAGE1 = 3,	// Ê¦¸¸¹ÄÀøµÜ×Ó
	BUFF_ADD_BY_SECT_ENCOURAGE2 = 4,	// ¼ÇÃûÊ¦¸¸¹ÄÀøµÜ×Ó
};

enum TITLE_ADD_REASON
{
	TITLE_ADD_BY_SECT_EXPEL = 0,	// Öð³öµÜ×Ó
	TITLE_ADD_BY_HOME_STEAL_CAUGHT = 1, // ¼ÒÔ°ÍµÇÔ±»×¥
};

enum ALLOC_NAME_CATEGORY
{
	ALLOC_FACTION_NAME = 1,
	ALLOC_BANGHUI_NAME = 2,
};

enum PLAYER_FACTION_STATE
{
	PAS_ACTIVITY		= 0x01,	// »îÔ¾
	PAS_FACTION_ACTIVITY	= 0x02,	// °ïÅÉ»îÔ¾
	PAS_LEAVE_FACTION	= 0x04,	// Àë¿ª°ïÅÉ (ds->gs)

	PAS_JOIN_FACTION	= 0x20,	// ¼ÓÈë°ïÅÉ (ds->gs)

	PAS_GS_MASK		= 0,
	PAS_DS_MASK		= PAS_ACTIVITY | PAS_FACTION_ACTIVITY | PAS_LEAVE_FACTION | PAS_JOIN_FACTION,
};

enum FACTION_DS_SYNC_MASK
{
	FDSM_MEMBER		= 0x01,	//Í¬²½Íæ¼ÒÊý¾Ý
	FDSM_LEVEL		= 0x02,	//µÈ¼¶
	FDSM_VALUE		= 0x04,	//ÆÕÍ¨Êý¾Ý
	FDSM_SUBFACTION		= 0x08,	//·Ö¶æÊý¾Ý
	FDSM_PARTNER		= 0x10,	//ºÏ×÷°ïÅÉÊý¾Ý
	FDSM_CLOSEBASE		= 0x20,	//ÍêÈ«¹Ø±Õ»ùµØ
	FDSM_VOLATILITY		= 0x40,	//°ïÅÉÒ×±äÊôÐÔ
};

enum FACTION_REBEL_STATUS
{
	FRS_SUCCESS		= 0x01, // Ôì·´³É¹¦
	FRS_FAILED		= 0x02, // Ôì·´Ê§°Ü£¬ÓÉÓÚÍ¶Æ±²»Í¨¹ý
	FRS_REBEL		= 0x03, // ÓÐÈËÔì·´
	FRS_STOP		= 0x04, // Æ½ÅÑ³É¹¦£¬ÓÉÓÚÓÐÈËÒ»Æ±·ñ¾ö
};

enum FACTION_BASE_NOENTER_TYPE
{
	FBCT_BASECLOSE		= 1,	//»ùµØ¹Ø±Õ
	FBCT_NOBASE		= 2,	//Ã»ÓÐ»ùµØ
};

enum FACTION_COLLECTLEADER_TYPE
{
	FCT_PUSHLEADER	= 0,	//¸´ÔÓÍÆËÍÐÅÏ¢´¦ÀíµÄÏà¹ØÁìµ¼
	FCT_MASTER	= 1,	//°ïÖ÷
	FCT_LEADER_CANADD = 2,	//ÓÐÑûÇëÈ¨ÏÞµÄÁìµ¼

	FCT_COUNT,
};

enum FACTION_COLLECTLEADER_STATUS
{
	FCS_ALL		= 0,	//È«²¿ÐÅÏ¢£¬²»¹ÜÔÚÏßÓë·ñ
	FCS_OFFLINE	= 1,	//ÀëÏßÁìµ¼
	FCS_ONLINE	= 2,	//ÔÚÏßÁìµ¼
};

enum
{
	FACTION_MAX_NAME_LEN		= 16,			//°ïÅÉ×î³¤Ãû×Ö
	FACTION_BASE_COST		= 20000,	// »ñÈ¡°ïÅÉ»ùµØ·ÑÓÃ
	FACTION_EXT_ROOM_COST		= 0,		// °ïÅÉÉý¼¶Ïá·¿·ÑÓÃ
	FACTION_MEMBER_PER_PAGE		= 8,		// ÏÔÊ¾°ïÅÉ³ÉÔ±Ê±Ã¿Ò³ÏÔÊ¾ÊýÁ¿
	FACTION_LEVEL_MAX		= 9,		// °ïÅÉ×î¸ßµÈ¼¶
	FACTION_VALUE_TRANSFER		= 80,		// °ïÅÉ»ù±¾ÊôÐÔ×ªÒÆ °Ù·Ö±È
	FACTION_DOMAIN_TRANSFER_DIFF	= 10,		// °ïÅÉ²úÒµ²»Í¬Ê±ÊýÖµ×ªÒÆ °Ù·Ö±È
	FACTION_DOMAIN_TRANSFER_SAME	= 40,		// °ïÅÉ²úÒµÏàÍ¬Ê±ÊýÖµ×ªÒÆ °Ù·Ö±È
	FACTION_ACTIVE_CONSUME_COUNT	= 5,		// °ïÅÉ¼¤»îËùÐèÒªµÄÎïÆ·ÊýÁ¿
	FACTION_BASE_RENT_PER_LEVEL	= 100000,	// °ï»á»ùµØÃ¿µÈ¼¶ÐèÒª×â½ð
	FACTION_SUB_MAX			= 3,		// °ïÅÉ×î¶à·Ö¶æÊý
	FACTION_TEMP_MEMBER_LEVEL	= 12,		// ÕýÊ½³ÉÔ±µÈ¼¶ãÐÖµ
	FACTION_NICKNAME_MAX_SIZE	= 12,		// °ïÅÉêÇ³Æ×î´ó×Ö½ÚÊý
	FACTION_ANNOUNCE_MAX_SIZE	= 256,		// °ïÅÉÐûÑÔ×î´ó×Ö½ÚÊý
	FACTION_MONEY_PER_CON		= 1000000,	// Ã¿¾èÔù¶àÉÙÇ®¿ÉÒÔ»ñÈ¡5µã°ï¹±
	FACTION_BASE_MIN_ACTIVITY	= 20,		// °ïÅÉ»ùµØ¿ªÆô»îÔ¾¶ÈÏÂÏÞ
	FACTION_BASE_MIN_MEMBERS	= 10,		// °ïÅÉ»ùµØ¿ªÆôÈËÊýÏÂÏÞ
	FACTION_BASE_MIN_MONEY		= 0,		// °ïÅÉ»ùµØ¿ªÆô×Ê½ðÏÂÏÞ
	FACTION_JOIN_MINLEVEL		= 12,		// ¼ÓÈë°ïÅÉÐèÒªµÄ×îÐ¡µÈ¼¶
	FACTION_OWNCITY_MAX		= 17,           // Ã¿¸ö°ïÅÉ×î¶àÓµÓÐ17ÊÆÁ¦µØÍ¼ 
	FACTION_BASE_TACTIVITY_TIME	= 72 * 60 * 60,		//ÏÂÏÞ³ÖÐøÊ±¼ä
	FACTION_BASE_MEMBERS_TIME	= 72 * 60 * 60,		//ÏÂÏÞ³ÖÐøÊ±¼ä
	FACTION_BASE_MONEY_TIME		= 3 * 60 * 60,		//ÏÂÏÞ³ÖÐøÊ±¼ä
	FACTION_BASE_RENT_FREE_TIME	= 7 * 24 * 60 * 60,	// °ïÅÉ»ùµØµÚÒ»ÖÜ×â½ðÃâ·Ñ
	FACTION_BASE_RENT_TIME		= 12 * 60 * 60,		// °ï»á»ùµØ×â½ðÖÜÆÚ
	FACTION_SUBFACTION_COOLDOWN	= 24 * 60 * 60,		// É¾³ý·Ö¶æÀäÈ´Ê±¼ä
	FACTION_MEMBER_ACTIVITY		= 3 * 24 * 60 * 60,	// °ïÅÉ»îÔ¾Íæ¼Ò¶¨Òå£¬ÉÏÏßÊ±¼ä
};

//Ê¹ÓÃconst int ¿ÉÒÔ±ãÓÚÔËÐÐÊ±ÐÞ¸Ä²âÊÔ, Ö»ÄÜµ±×ö¾Ö²¿±äÁ¿¸Ä±ä


enum FACTION_MERAGE_MEMBER_OP
{
	FMMO_ADD	= 0,	//Ìí¼Ó
	FMMO_DEL	= 1,	//É¾³ý
	FMMO_OK		= 2, 	//È·¶¨
	FMMO_ALL	= 3,	//»ñÈ¡
	FMMO_SELF	= 4,	//Ìí¼Ó¸öÈË
};

enum FACTION_UPGRADE_TYPE
{
	FUT_NONE	= 0,
	FUT_LEVEL	= 1,	//Éý¼¶µÈ¼¶
	FUT_BASE	= 2,	//¿ª×Ú½¨ÅÉ
	FUT_ACTIVE	= 3,	//¼¤»î°ïÅÉ
	FUT_EXT_ROOM	= 4,	//Éý¼¶Ïá·¿
	FUT_BASE_ACTIVE	= 5,	//ÖØÐÂ¼¤»î»ùµØ
};

enum FACTION_BUILDING_TYPE
{
	DSEXP_FACTIONBLD_PLACE_SPECIAL2 = 8,	//EXP_FACTIONBLD_PLACE_SPECIAL2
	DSEXP_FACTIONBLD_PLACE_SPECIAL3 = 9,	//EXP_FACTIONBLD_PLACE_SPECIAL3
	DSEXP_FACTIONBLD_PLACE_SPECIAL4 = 10,	//EXP_FACTIONBLD_PLACE_SPECIAL4
};

enum FACTION_STATUS	// °ïÅÉ×´Ì¬
{
	FS_NORMAL	= 0,	// Õý³£
	//FS_REBEL	= 1,	// Ôì·´ÖÐ
	FS_MERGEREQ	= 2,	// ºÏ²¢ÇëÇó
	FS_MERGEVOTE	= 3,	// ºÏ²¢Í¶Æ±
	FS_MERGEVOTEEND = 4,	// Í¶Æ±½áÊø
	FS_MERGESTART	= 5,	// ¿ªÊ¼ºÏ²¢,Ëø¶¨°ïÅÉ²Ù×÷
	FS_CLEAR_DATA	= 6,	// GSLoad used,ÐÂÊý¾Ý
	FS_MERGEPRESTART= 7,	// ºÏ²¢Ë«·½ÄÜ¹»¿ªÊ¼ºÏ²¢Ê±(»¹Î´ºÏ²¢)µÄ×´Ì¬
};

enum FACTION_POSITION	// °ïÅÉÖ°Î»
{
	FP_NONE = 0,		// °ïÖÚ
	// ¶ÀÁ¢Ö°Î»
	FP_MASTER = 1,		// °ïÖ÷
	FP_VICEMASTER1 = 2,	// ¸±°ïÖ÷
	FP_VICEMASTER2 = 3,
	FP_VICEMASTER3 = 4,
	FP_HUFA1 = 11,		// »¤·¨
	FP_HUFA2 = 12,
	FP_ZHANGLAO1 = 21,	// ³¤ÀÏ
	FP_ZHANGLAO2 = 22,
	FP_ZHANGLAO3 = 23,
	FP_ZHANGLAO4 = 24,
	FP_SUBMASTER 	= 31,	// ·Ö¶æÖ÷
	//ÈËÊýÏÞÖÆ
	FP_BEAUTY	= 42,	// °ï»¨
	FP_TALKER	= 43,	// »°ßë
	FP_KNOW_ALL	= 44,	// °ÙÊÂÍ¨
	FP_GOOD_GUY	= 45,	// ÀÏºÃÈË
	FP_ELITE	= 46,	// ¾«Ó¢
	FP_S_PET_TUTOR	= 47,	// Ê×Ï¯ÃÅÍ½µ¼Ê¦
	FP_S_CHEMIST	= 48,	// Ê×Ï¯Ò©Ê¦
	FP_S_COOK	= 49,	// Ê×Ï¯³øÊ¦
	FP_S_STONE_TUTOR= 50,	// Ê×Ï¯½ðÊ¯Ê¦
	FP_S_WOOD_TUTOR	= 51,	// Ê×Ï¯Ä¾Ê¦
	FP_S_CLOTH_TUTOR= 52,	// Ê×Ï¯²¼Ê¦
	FP_S_SOCIALITE	= 53,	// Ê×Ï¯Éç½»Ê¦
	FP_PET_TUTOR	= 54,	// ¸ß¼¶ÃÅÍ½µ¼Ê¦
	FP_CHEMIST	= 55,	// ¸ß¼¶Ò©Ê¦
	FP_COOK		= 56,	// ¸ß¼¶³øÊ¦
	FP_STONE_TUTOR	= 57,	// ¸ß¼¶½ðÊ¯Ê¦
	FP_WOOD_TUTOR	= 58,	// ¸ß¼¶Ä¾Ê¦
	FP_CLOTH_TUTOR	= 59,	// ¸ß¼¶²¼Ê¦
	FP_SOCIALITE	= 60,	// ¸ß¼¶Éç½»Ê¦
	FP_UNDERGRADUATE= 61,	// ÐÂÊÖ¸¨µ¼Ô±
	FP_GRADUATE	= 62,	// ½ø½×¸¨µ¼Ô±
	FP_DOCTOR	= 63,	// ÀÏÊÖ¸¨µ¼Ô±

	// ¸½ÊôÖ°Î»
	FP_MASTER_SPOUSE = 101,		// °ïÖ÷ÅäÅ¼
	FP_VICEMASTER_SPOUSE = 102,	// ¸±°ïÖ÷ÅäÅ¼
	FP_MASTER_TRUSTED = 103,	// °ïÖ÷Ç×ÐÅ
	FP_HUFA_TRUSTED = 104,		// »¤·¨Ç×ÐÅ
	FP_ZHANGLAO_TRUSTED = 105,	// ³¤ÀÏÇ×ÐÅ
	FP_SUBMASTER_TRUSTED = 106,	// ·Ö¶æÖ÷Ç×ÐÅ


	FP_UNKNOWN = 255,	// ·Ç±¾°ïÅÉ³ÉÔ±
};

enum FACTION_TITLE // °ïÅÉÈÙÓþÉí·Ý
{
	FTI_NONE = 0,	// °ïÖÚ
	FTI_1 = 1,	// 1½×³ÉÔ±
	FTI_2 = 2,	// 2½×³ÉÔ±
	FTI_3 = 3,	// 3½×³ÉÔ±
	FTI_4 = 4,	// 4½×³ÉÔ±
	FTI_5 = 5,	// 5½×³ÉÔ±
	FTI_6 = 6,	// 6½×³ÉÔ±
	FTI_7 = 7,	// 7½×³ÉÔ±
	FTI_8 = 8,	// 8½×³ÉÔ±
	FTI_9 = 9,	// 9½×³ÉÔ±
	FTI_10 = 10,	// 10½×³ÉÔ±
	FTI_TMP = 101,	// ¹ÒÃû³ÉÔ±
};

enum FACTION_SUB_NAME
{
	FSN_NONE	= 0,	// ¿Õ
	FSN_1		= 1,	// ÇàÁú
	FSN_2		= 2,	// °×»¢
	FSN_3		= 3,	// ÖìÈ¸
	FSN_4		= 4,	// ÐþÎä
	FSN_5		= 5,	// ¾ªÔÆ
	FSN_6		= 6,	// ÐãÔÂ
	FSN_7		= 7,	// ÇÙÐÄ
	FSN_8		= 8,	// Éñ²ß
	FSN_9		= 9,	// ¿ªÌì
	FSN_10		= 10,	// ÅüµØ
	FSN_11		= 11,	// ÖðÈÕ
	FSN_12		= 12,	// ±¼ÔÂ
	FSN_13		= 13,	// Ç¬À¤
	FSN_14		= 14,	// Ìì»ú
	FSN_15		= 15,   // ÉñÍ¾
	FSN_16		= 16,	// °ÔÒµ

};

enum FACTION_ADD_MONEY_TYPE
{
	FAMT_NORMAL	= 0,	//Í¨ÓÃ
	FAMT_TASK	= 1,	//ÈÎÎñ
	FAMT_CONTRI	= 2,	//¾èÔù

	FAMT_CONTRI_RE	= 101,	//¾èÔù³É¹¦
};

enum FACTION_DEC_MONEY_TYPE
{
	FDMT_UPGRADE = 0,	//Éý¼¶

	FAMT_COUNT,
};

enum FACTION_THING	// °ïÅÉÈ¨ÏÞ²Ù×÷
{
//DSÏà¹Ø²Ù×÷
	FT_ADD		= 1,	// ¼Ó³ÉÔ±
	FT_UPGRADE	= 2,	// °ïÅÉÉý¼¶
	FT_ANNOUNCE	= 3,	// ÐÞ¸ÄÐûÑÔ
	FT_ABDICATE	= 4,	// ´«Î»
	FT_REBEL1	= 5,	// 7Ìì´ÛÎ»
	FT_SUPPRESS	= 6,	// ·´¶Ô7Ìì´ÛÎ»
	FT_REBEL2	= 7,	// 15Ìì´ÛÎ»
	FT_RESIGN	= 8,	// ´ÇÖ°
	FT_EXPEL	= 9,	// ¿ª³ý
	FT_QUIT		= 10,	// ÍË³ö
	FT_OP_MERGE	= 11,	// Ñ¡ÔñºÏ²¢³ÉÔ±ÁÐ±í
	FT_MERGE_OK	= 12,	// È·ÈÏºÏ²¢³ÉÔ±ÁÐ±í
	FT_APPLY_SUB	= 13,	// ÉêÇë·Ö¶æ
	FT_OP_SUB	= 14,	// ½¨Á¢¡¢É¾³ý·Ö¶æ
	FT_SUBCITYAPPLY = 15,	// ÉêÇëÊÆÁ¦·¶Î§
	FT_SUBCITYAPPLYDEAL = 16,// ´¦ÀíÊÆÁ¦ÉêÇë	
	FT_AUCTION_OFFERPRICE = 17,// ÁúÍ·¾º¼Û
	FT_MAINCITYOPER = 18,	// ×Ü¶æ´¦Àí
	FT_SUBRESET	= 19,	// ·Ö¶æÉèÖÃ
	FT_CONTRI_MONEY = 20,	// ¾èÇ®
	FT_BASE_ACTIVE	= 21,	//ÖØÐÂ¼¤»îÒÑ¾­¹Ø±ÕµÄ»ùµØ
	FT_SETTIGUAN	= 22,	//ÉèÖÃÍæ¼ÒÕ½¶·¶Ó
	FT_TIGUAN	= 23,	//·¢ÆðÌß¹Ý

//GSÏà¹Ø²Ù×÷
	FT_STORE	= 50,	// ²Ù×÷»ùµØ²Ö¿â
	FT_UPGRADE_BUILD = 51,	// Éý¼¶»ùµØ½¨Öþ
	FT_GET_WELWARE	= 52,	// »ñÈ¡¸£Àû
	FT_HIREINFO	= 53,	// ÕÐ¹¤ÐÅÏ¢¹ÜÀí
	FT_OPENACTIVITY	= 54,	// ´ò¿ª»î¶¯
	FT_GET_SALARY	= 55,	// Áì¹¤×Ê
	FT_GET_BONUS	= 56,	// Áì¹©·î
	FT_COREMSG	= 57,	// ²Ù×÷ºËÐÄÏûÏ¢²Ö¿â
	FT_NORMALMSG	= 58,	// ²Ù×÷Ð¡µÀÏûÏ¢²Ö¿â
	FT_TREASURE	= 59,	// ²Ù×÷±¦Îï²Ö¿â
	FT_TREASURE_TRAP = 60,	// ±¦Îï»ú¹Ø²Ù×÷
	FT_CONTRI_ITEM	= 61,	// ¾èÎïÆ·
	FT_PARTY	= 62,	// ÓÃ°ïÅÉ×Ê½ð´ò¿ªÑç»á
	FT_DELACTIVITY	= 63,	// É¾³ý»î¶¯
	FT_GET_MONEYTASK= 64,	// »ñÈ¡·¢Á¸ÈÎÎñ
};

enum FACTION_GETTYPE//»ñÈ¡°ïÅÉ·½Ê½
{
	FG_GLOBLEGET = 0,	//ÎÞÉ¸Ñ¡Ìõ¼þ£¬Ö±½Ó°´ÕÕ°ïÅÉID»ñÈ¡
	FG_HAVEBASE = 1,	//ÓÐ°ïÅÉ»ùµØ
	FG_NOBASE = 2,		//Ã»ÓÐ°ïÅÉ»ùµØ
};

enum FACTION_INVITE_TYPE //°ïÅÉ³ÉÔ±ÑûÇë·½Ê½
{
	FIT_PUSH = 1,	//ÏµÍ³ÍÆËÍ
	FIT_INVITE = 2,	//Íæ¼ÒÖ÷¶¯ÑûÇë
};

enum FACTION_MERGE_REQ
{
	FMR_AGREE = 1, //Í¬ÒâºÏ²¢
	FMR_DISAGREE = 2,//²»Í¬ÒâºÏ²¢
};

enum FACTION_SYNC_HIREINFO_TYPE
{
	FSHT_CHANGE = 0,
	FSHT_UPDATE = 1,
	FSHT_INIT = 2,
};

enum FACTION_SYNC_HIREINFO_RESULT
{
	FSHR_SUCCESS = 0,
	FSHR_FAILED = 1,
	FSHR_TIMEOUT = 2,
};

enum FACTION_VOTE_RESULT
{
	FVR_DEFAULT = 0,//³õÊ¼»¯Öµ£¬Î´¾ö×´Ì¬
	FVR_PASS = 1,//Í¨¹ý
	FVR_NOTPASS = 2,//Ã»ÓÐÍ¨¹ý
};

enum FACTION_ACTIVITY_RESULT
{
	FAR_SUCCESS = 0,
	FAR_NOTALLOW = 1,
	FAR_CLUBLESS = 2,
	FAR_TIMEOUT = 3,
	FAR_SERVERERROR = 4,
	FAR_ACTIVITYLESS = 5,
	FAR_WARMLESS = 6,
	FAR_INSTANCEEXIST = 7,
};

enum FACTION_ACTIVITY_STATUS_MODE
{
	FASM_READY	= 0,	// »î¶¯Ô¤±¸¿ªÊ¼
	FASM_ON		= 1,	// »î¶¯¿ªÆôÖÐ
	FASM_OFF	= 2,	// »î¶¯½áÊø
	FASM_ON_OFF	= 3,	// ¿ªÆôºó×Ô¶¯½áÊø£¬²»ÐèÒªÔÚ½áÊøÊ±ÔÙÍ¨Öª¿Í»§¶ËÁË
};

enum FACTION_ACTIVITY_TYPE
{
	FAT_ACTIVITY	= 0, //»î¶¯
	FAT_PARTY	= 1, //Ñç»á
	FAT_LVUPCELE	= 2, //Éý¼¶Çìµä
	FAT_AUCTION	= 3, //¾º±ê
};

enum FACTION_RECORD_THING_TYPE
{
	FRTT_AUCPOINT_DONATE	= 1,	//¾èÔù¾º±êµã
	FRTT_AUCPOINT_RECEIVE	= 2,	//½ÓÊÜ¾º±êµã
	FRTT_CITY_ADD		= 3,	//Ôö¼ÓÊÆÁ¦µØÍ¼
	FRTT_CITY_DEL		= 4,	//É¾³ýÊÆÁ¦µØÍ¼
	FRTT_MAIN_EXCHANGE	= 5,	//°áÇ¨×Ü¶æ
	FRTT_TIGUAN		= 6,	//Ìß¹Ý
	FRTT_BE_TIGUAN		= 7,	//±»Ìß¹Ý
};

enum FACTION_TEAM_STATUS_TYPE
{
	FTST_TIGUAN	= 0,

	FTST_MAX,
};

enum FACTION_TEAM_STATUS_MASK
{
	FTSM_TIGUAN	= 1 << FTST_TIGUAN,
};

enum FACTIONCITY_SAVE_TYPE
{
	FCST_KING	= 0x00000001,
	FCST_SUBADD	= 0x00000002,
	FCST_SUBDEL	= 0x00000004,
	FCST_BASIC	= 0x00000008,
	FCST_APPLY	= 0x00000010,
	FCST_INITAUCTION = 0x00000020,
	FCST_CLEARAUCTION = 0x00000040,
	FCST_TOTALPOINT = 0x00000080,
};

enum FACTIONCITY_INIT_CITY
{
	FIC_FUZHOU	= 68, 
	FIC_HENGSHAN	= 67, 
};

enum FACTIONCITY_SUB_OPER_TYPE
{
	FCSOT_ADD	= 1,
	FCSOT_DEL	= 2,
};

enum FCITY_GET_TYPE
{
	FGT_BASE	= 0x01,
	FGT_MAIN	= 0x02,
	FGT_SUB		= 0x04,
	FGT_APPLY	= 0x08,

	FGT_ALL		= FGT_BASE | FGT_MAIN | FGT_SUB | FGT_APPLY,
};

enum FCITY_RESET_TYPE
{
	FCRT_SUB	= 0,
	FCRT_WEIGHT	= 1,
};

enum FACTION_GATHER_INFO_RESULT
{
	FGIR_SUCCESS	= 0,//¿ÉÒÔ²É¼¯
	FGIR_NOCITY	= 1,//ÎÞÊÆÁ¦µØÍ¼
};

// ÔÚÊý¾Ý¿âvote_mask×Ö¶ÎÖÐ£¬Èç¹û¸ÃÎ»ÖÃ1£¬±íÊ¾¸ÃÍæ¼ÒÒÑ¾­Í¶Æ±£¬ÖÃ0£¬±íÊ¾¸ÃÍæ¼ÒÎ´Í¶Æ±
// ÔÚÊý¾Ý¿âvote_result×Ö¶ÎÖÐ(Èç¹ûvote_mask×Ö¶ÎÖÐ¶ÔÓ¦Î»ÒÑ¾­±»ÖÃ1),ÖÃ1£¬±íÊ¾Í¬Òâ£¬ÖÃ0£¬±íÊ¾²»Í¬Òâ
enum VOTE_MASK
{
	VM_MERGE_VOTE		= 0x00000001,
	VM_SCORE_VOTE		= 0x00000002,
	VM_MERGE_TRANSFER	= 0x00000004,	//×¼±¸±»×ªÒÆµÄÈËÔ±
	VM_MERGED_VOTE		= 0x00000008,
	VM_REBEL_VOTE		= 0x00000010,
	VM_SALARY_GET		= 0x00000020,	//ÁìÈ¡Ð½Ë®±êÖ¾
	VM_BONUS_GET		= 0x00000040,	//ÁìÈ¡¹©·î±êÖ¾
	VM_WELF_EXP_GET		= 0x00000080,	//ÁìÈ¡¸£Àû¾­Ñé±êÊ¶

	VM_GS_ONLY_MASK		= VM_WELF_EXP_GET,
};

enum LINK_TYPE
{
	LINK_TYPE_LS   = 1, 
	LINK_TYPE_CS   = 2,
	LINK_TYPE_IWEB = 3, 
};

//ÓëGSÄÚ²¿¶¨ÒåÒ»ÖÂ
enum USE_MONEY_TYPE_MASK
{
	UMT_BIND  = 0x01, //Ê¹ÓÃ°ó¶¨±Ò
	UMT_TRADE = 0x02, //Ê¹ÓÃ½»Ò×±Ò
};

enum USE_CASH_TYPE_MASK
{
        UCT_BIND  = 0x01, //Ê¹ÓÃ°ó¶¨Ôª±¦
        UCT_TRADE = 0x02, //Ê¹ÓÃ½»Ò×Ôª±¦
};

enum TOPLIST_NAME
{
	//TPN_LEVEL = 1,			//µÈ¼¶°ñ
	//TPN_LEVEL_OLDDAY = 2,		//µÈ¼¶Ò»ÌìÇ°ÀÏ°ñ
	//TPN_MONEY = 3,			//½ðÇ®°ñ
	//TPN_MONEY_OLDDAY = 4,		//½ðÇ®Ò»ÌìÇ°ÀÏ°ñ
	//TPN_HP = 5,			//ÆøÑª°ñ
	//TPN_HP_OLDDAY = 28,		//ÆøÑªÒ»ÌìÇ°ÀÏ°ñ 
	//TPN_MP = 6,			//ÄÚÁ¦°ñ
	//TPN_MP_OLDDAY = 29,		//ÄÚÁ¦Ò»ÌìÇ°°ñ
	//TPN_ATTACKOUT = 7,		//Íâ¹¦¹¥»÷°ñ
	//TPN_ATTACKOUT_OLDDAY = 30,	//Íâ¹¦¹¥»÷Ò»ÌìÇ°ÀÏ°ñ
	//TPN_ATTACKIN = 8,		//ÄÚ¹¦¹¥»÷°ñ
	//TPN_ATTACKIN_OLDDAY = 31,	//ÄÚ¹¦¹¥»÷Ò»ÌìÇ°ÀÏ°ñ
	//TPN_REPUTATION = 9,		//³É¾Í°ñ
	//TPN_REPUTATION_OLDDAY = 32,	//³É¾ÍÒ»ÌìÇ°ÀÏ°ñ
	//TPN_PLANT = 10,			//ÖÖÖ²°ñ
	//TPN_PLANT_OLDDAY = 33,		//ÖÖÖ²Ò»ÌìÇ°ÀÏ°ñ
	//TPN_BREED = 11,			//ÑøÖ³°ñ
	//TPN_BREED_OLDDAY = 34,		//ÑøÖ³Ò»ÌìÇ°ÀÏ°ñ
	//TPN_MINE = 12,			//²É¿ó°ñ
	//TPN_MINE_OLDDAY = 35,		//²É¿óÒ»ÌìÇ°ÀÏ°ñ
	//TPN_CUT = 13,			//·¥Ä¾°ñ
	//TPN_CUT_OLDDAY = 36,		//·¥Ä¾Ò»ÌìÇ°ÀÏ°ñ
	//TPN_METAL = 14,			//½ðÊ¯°ñ
	//TPN_METAL_OLDDAY = 37,		//½ðÊ¯Ò»ÌìÇ°ÀÏ°ñ
	//TPN_WOODLEATHER = 15,		//Ä¾¸ï°ñ
	//TPN_WOODLEATHER_OLDDAY = 38,	//Ä¾¸ïÒ»ÌìÇ°ÀÏ°ñ
	//TPN_CLOTH = 16,			//²¼²¯°ñ
	//TPN_CLOTH_OLDDAY = 39,		//²¼²¯Ò»ÌìÇ°ÀÏ°ñ
	//TPN_MEDCINE = 17,		//ÖÆÒ©°ñ
	//TPN_MEDCINE_OLDDAY = 40,	//ÖÆÒ©Ò»ÌìÇ°ÀÏ°ñ
	//TPN_COOK = 18,			//Åëâ¿°ñ
	//TPN_COOK_OLDDAY = 41,		//Åëâ¿Ò»ÌìÇ°ÀÏ°ñ
	//TPN_FISH = 19,			//µöÓã°ñ
	//TPN_FISH_OLDDAY = 42,		//µöÓãÒ»ÌìÇ°ÀÏ°ñ
	//TPN_PET = 20,			//³èÎï°ñ
	//TPN_PET_OLDDAY = 43,		//³èÎïÒ»ÌìÇ°ÀÏ°ñ
	//TPN_REPCHARM = 21,		//÷ÈÁ¦°ñ
	//TPN_REPCHARM_OLDDAY = 44,	//÷ÈÁ¦Ò»ÌìÇ°ÀÏ°ñ
	//TPN_REPFAME = 22,		//ÈËÔµ°ñ
	//TPN_REPFAME_OLDDAY = 45,	//ÈËÔµÒ»ÌìÇ°ÀÏ°ñ
	//TPN_REPSECT = 23,		//Ê¦Í½°ñ
	//TPN_REPSECT_OLDDAY = 46,	//Ê¦Í½Ò»ÌìÇ°ÀÏ°ñ
	//TPN_REPLIFE = 24,		//Éú»îÃûÍû°ñ
	//TPN_REPLIFE_OLDDAY = 47,	//Éú»îÃûÍûÒ»ÌìÇ°ÀÏ°ñ
	//TPN_REPFUZHOU = 25,		//¸£ÖÝ³ÇÊÐÉùÍû°ñ
	//TPN_REPFUZHOU_OLDDAY = 48,	//¸£ÖÝ³ÇÊÐÉùÍûÒ»ÌìÇ°ÀÏ°ñ
	//TPN_REPHENGSHAN = 26,		//ºâÉ½³ÇÊÐÉùÍû°ñ
	//TPN_REPHENGSHAN_OLDDAY = 49,	//ºâÉ½³ÇÊÐÉùÍûÒ»ÌìÇ°ÀÏ°ñ
	//TPN_REPLUOYANG = 27,		//ÂåÑô³ÇÊÐÉùÍû°ñ
	//TPN_REPLUOYANG_OLDDAY = 50,	//ÂåÑô³ÇÊÐÉùÍûÒ»ÌìÇ°ÀÏ°ñ
	//TPN_REPJUEWEI = 51,		//¾ôÎ»ÉùÍû°ñ
	//TPN_REPJUEWEI_OLDDAY = 52,	//¾ôÎ»ÉùÍûÀÏ°ñ
	//TPN_REPYUHANG = 53,		//Óàº¼ÉùÍû°ñ
	//TPN_REPYUHANG_OLDDAY = 54,	//Óàº¼ÉùÍûÒ»ÌìÇ°ÀÏ°ñ
	//TPN_REPNANJIANG = 55,		//ÄÏ½®ÉùÍû°ñ
	//TPN_REPNANJIANG_OLDDAY = 56,	//ÄÏ½®ÉùÍûÒ»ÌìÇ°ÀÏ°ñ
	//TPN_REPWULIN	= 57,		//ÎäÁÖÉùÍû°ñ
	//TPN_REPWULIN_OLDDAY = 58,	//ÎäÁÖÉùÍûÒ»ÔÂÇ°ÀÏ°ñ
	//TPN_REPPK = 59,			//PKÉùÍû°ñ
	//TPN_REPPK_OLDDAY = 60,		//PKÉùÍûÒ»ÌìÇ°ÀÏ°ñ
	//TPN_REPRENOWNUSED = 61,		//ÊÀ½çÉùÍû°ñ
	//TPN_REPRENOWNUSED_OLDDAY = 62,	//ÊÀ½çÉùÍûÒ»ÌìÇ°ÀÏ°ñ

	//TPN_MAX	= 63,//ÅÅÐÐ°ñ±àºÅ×î´óÖµ+1(ÒÔÉÏÅÅÐÐ°ñ¶¼ÎªÔÚgamedbdÖÐµÄÅÅÐÐ°ñ)
	//TPN_NOTOLD_COUNT = 31,//ÅÅÐÐ°ñÖÐ·ÇÀÏ°ñÊýÁ¿(Õâ¸öÊýÒ²Ö»ÌØÖ¸ÔÚgamedbdÖÐµÄÅÅÐÐ°ñ)
	//TPN_MAX	= 3,//ÅÅÐÐ°ñ±àºÅ×î´óÖµ+1(ÒÔÉÏÅÅÐÐ°ñ¶¼ÎªÔÚgamedbdÖÐµÄÅÅÐÐ°ñ)
	//TPN_NOTOLD_COUNT = 1,//ÅÅÐÐ°ñÖÐ·ÇÀÏ°ñÊýÁ¿(Õâ¸öÊýÒ²Ö»ÌØÖ¸ÔÚgamedbdÖÐµÄÅÅÐÐ°ñ)

	// ÏÂÃæÊÇDSÎ¬»¤µÄÅÅÐÐ°ñ
	//TPN_FACTION_INDUSTRY = 300,	//°ïÅÉ×ÜÌåÊµÁ¦ÅÅÐÐ°ñ
	//TPN_FACTION_ESCORT = 301,	//°ïÅÉïÚ¾ÖÅÅÐÐ°ñ
	//TPN_FACTION_CARAVAN = 302,	//°ïÅÉÂí°ïÅÅÐÐ°ñ
	//TPN_FACTION_COTTAGE = 303,	//°ïÅÉÉ½Õ¯ÅÅÐÐ°ñ
	//TPN_FACTION_FACTORY = 304,	//°ïÅÉ¹¤·»ÅÅÐÐ°ñ
	//TPN_FACTION_LEVEL = 305,	//°ïÅÉµÈ¼¶ÅÅÐÐ°ñ
	//TPN_FACTION_CONSINC = 306,	//°ïÅÉ½¨Éè¶ÈÔöÁ¿ÅÅÐÐ°ñ
	//TPN_FACTION_INDUSTRY_OLD1 = 307,	//°ïÅÉ×ÜÌåÊµÁ¦ÀÏ°ñ1(Ã¿Ìì´æÒ»´Î)
	//TPN_FACTION_INDUSTRY_OLD2 = 308,	//°ïÅÉ×ÜÌåÊµÁ¦ÀÏ°ñ2(Ã¿ÖÜ´æÒ»´Î)
	//TPN_FACTION_ACTIVITY_FEATURE = 309,	//°ïÅÉÌØÉ«»î¶¯½ø¶ÈÅÅÐÐ°ñ
	//TPN_FACTION_ACTIVITY_TREASURE = 310,	//°ïÅÉÑ°±¦»î¶¯½ø¶ÈÅÅÐÐ°ñ
	//TPN_FACTION_ACTIVITY_EXTINCTION = 311,	//°ïÅÉÃðÃÅ»î¶¯½ø¶ÈÅÅÐÐ°ñ

	//TPN_FACTION_CONTRIBUTIONINC = 10000,//Õâ¸öÒ»¸öÌØÊâµÄÅÅÐÐ°ñ±àºÅ£¬¸Ã±àºÅ´ú±íÒ»¸öÌØÊâµÄÅÅÐÐ°ñ(Ã¿¸öÍæ¼Ò¶ÔÓ¦×Ô¼º°ïÅÉÖÐµÄ°ï¹±ÔöÁ¿ÅÅÐÐ°ñ)£¬¸Ã±àºÅÖ÷ÒªÓÃÓÚÁì½±ÓÃ.

	TPN_PATA			= 1,	//ÅÀËþ»ý·Ö°ñ
	TPN_PATA_OLDDAY			= 2,	//ÅÀËþ»ý·ÖÒ»ÌìÇ°ÀÏ°ñ
	TPN_LEVEL			= 3,	//µÈ¼¶°ñ
	TPN_LEVEL_OLDDAY		= 4,	//µÈ¼¶Ò»ÌìÇ°ÀÏ°ñ
	TPN_MONEY			= 5,	//½ðÇ®°ñ
	TPN_MONEY_OLDDAY		= 6,	//½ðÇ®Ò»ÌìÇ°ÀÏ°ñ
	TPN_FIGHTING_CAPACITY		= 7,	//Õ½Á¦°ñ
	TPN_FIGHTING_CAPACITY_OLDDAY	= 8,	//Õ½Á¦Ò»ÌìÇ°ÀÏ°ñ
	TPN_HERO			= 9,	//ÏÀ¿Í°ñ
	TPN_HERO_OLDDAY			= 10,	//ÏÀ¿ÍÒ»ÌìÇ°ÀÏ°ñ
	TPN_BIWU_1V1			= 11,	//1v1±ÈÎä°ñ
	TPN_BIWU_1V1_OLDDAY		= 12,	//
	TPN_BIWU_NVN			= 13,	//NvN±ÈÎä°ñ
	TPN_BIWU_NVN_OLDDAY		= 14,	//

	TPN_MAX				= 15,	//ÅÅÐÐ°ñ±àºÅ×î´óÖµ+1(ÒÔÉÏÅÅÐÐ°ñ¶¼ÎªÔÚgamedbdÖÐµÄÅÅÐÐ°ñ)
	TPN_NOTOLD_COUNT		= 7,	//ÅÅÐÐ°ñÖÐ·ÇÀÏ°ñÊýÁ¿(Õâ¸öÊýÒ²Ö»ÌØÖ¸ÔÚgamedbdÖÐµÄÅÅÐÐ°ñ)
};

enum TOPLIST_CATEGORY
{
	TPT_GLOBLE = 0, //È«¾ÖÅÅÐÐ°ñ
	//TPT_FACTION_CONTRIBUTE_INC = 1, //°ïÅÉ°ï¹±ÔöÁ¿ÅÅÐÐ°ñ--ÀÏ°ñ
	//TPT_FACTION_CONTRIBUTE_INC_TODAY = 2, //°ïÅÉ°ï¹±ÔöÁ¿ÅÅÐÐ°ñ--ÐÂ°ï
};
enum TOPLIST_INFO_TYPE
{
       TIT_PLAYER      = 0,    //Íæ¼ÒÊý¾ÝÅÅÐÐ°ñ
       //TIT_FACTION     = 1,    //°ïÅÉÊý¾ÝÅÅÐÐ°ñ
};

enum CAMPAIGN_SYNC_MODE
{
	CSM_INIT = 0,	//³õÊ¼»¯»î¶¯ÐÅÏ¢
	CSM_UPDATE = 1,	//¸üÐÂ»î¶¯ÐÅÏ¢
};

enum CAMPAIGN_INFO_TYPE
{
	CIT_OPEN	= 0,	//¿ªÆô»î¶¯
	CIT_CLOSE	= 1,	//¹Ø±Õ»î¶¯
	CIT_FORBID_OPEN	= 2,	//Ê±¼äµ½£¬µ«ÊÇ±»´ò¿ªÌõ¼þÏÞÖÆ
};

enum MIRROR_SCENE_STATE
{
	MSST_NORMAL		= 0,
	MSST_CLOSING		= 0x80,
	MSST_WAITING_CLOSE	= 0x40,
	MSST_FULL		= 5,
	MSST_STATE_MASK		= 0xF0,
};

inline unsigned char GetMirrorState(int capacity, int cur_num, unsigned char state)
{
	if(state == MSST_CLOSING || state == MSST_WAITING_CLOSE) return state;
	if(cur_num >= capacity && capacity > 0) return MSST_FULL;
	if(capacity <= 0 || cur_num <= 0) return 0;
	return cur_num * MSST_FULL / capacity;
}

enum SCENE_MIRROR_OP
{
	SMP_SYNC		= 0,	//Í¬²½ÐÅÏ¢
	SMP_CREATE		= 1,	//´´½¨¾µÏñ
	SMP_CLOSE		= 2,	//¹Ø±Õ¾µÏñ
	SMP_DEACTIVE_MIRROR	= 3,	//¹Ø±ÕÄ³³¡¾°¾µÏñ¹¦ÄÜ
	SMP_REACTIVE_MIRROR	= 4,	//ÖØÐÂ¼¤»î¾µÏñ¹¦ÄÜ
	SMP_REOPEN		= 5,
};

enum INSTANCE_RETURN_OP
{
	IRO_CANCEL	= 0,	//É¾³ý½øÈëÐÅÏ¢
	IRO_ENTER	= 1,	//½øÈëµ±Ç°¸±±¾
};

enum SERVER_MODE
{
	SMODE_NORMAL	= 0,	// Õý³£Ïß
	SMODE_PRIVATE	= 1,	// Ë½ÓÐÏß
};

enum TEAM_TASK_INFO
{
	GEN_MONSTER_FAIL	= 0,
	TEAM_MONSTER_DIE	= 1,
	CLEAR_MONSTER		= 2,
	MONSTER_CLEARED		= 3,
};

enum MINGXING_EVENT
{
	MX_EVENT_INVALID	= 0, //ÎÞÐ§ÊÂ¼þ
	MX_EVENT_NEW_BY_TASK	= 1, //ÈÎÎñ²úÉúÐÂÃ÷ÐÇ
	MX_EVENT_NEW_BY_TP	= 2, //ÅÅÐÐ°ñ²úÉúÐÂÃ÷ÐÇ
};

enum FACTION_TIGUAN_STATE 
{
	FTS_NONE		= 0,
	FTS_PREPARE0		= 1, //×¼±¸½×¶Î0, ·þÎñÆ÷±£»¤
	FTS_PREPARE1		= 2, //×¼±¸½×¶Î1, Ìß¹Ý±»·þÎñÆ÷½ÓÊÜ
	FTS_PREPARE2		= 3, //×¼±¸½×¶Î2, ¿ªÊ¼ÏÞÖÆ½øÈëÈËÔ±, ËæºóÇå³¡
	FTS_BEGIN_FIGHT		= 4, //¿ªÊ¼Õ½¶·
	FTS_END			= 5, //½áÊøÕ½¶·, ½ÓÏÂÀ´¿ÉÄÜ½øÈë½±ÀøÊ±¼ä°´
};

enum FACTION_WAR_TYPE
{
	FWT_TIGUAN		= 1, //Ìß¹Ý
};

enum FACTION_TIGUAN_GOAL
{
	FTG_PLAY		= 0, //ÓéÀÖ
	FTG_SUB			= 1, //ÊµÀýÍ¨ÐÐ
	FTG_MAIN		= 2, //ÇÀÕ¼×¤µØ
};

enum DB_SAVE_ROLE_TYPE
{
	DSRT_IS_GM		= 0x01,		//ÊÇGM
	DSRT_IS_ROAMER		= 0x02,		//ÊÇÂþÓÎÕß
};

enum DB_PACKE_ROAM_ROLE_TYPE
{
	DPRRT_ALL_DATA		= 0,		//´ò°üËùÓÐÊý¾Ý
	DPRRT_GS_DATA		= 1,		//´ò°üGSÊý¾Ý

	DPRRT_COUNT,
};

enum DB_ROLE_SAVE_PRIORITY
{
	DRSP_NOTING		= 0,		//Î´¶¨Òå
	DRSP_AUTO_SAVE		= 1,		//×Ô¶¯±£´æ
	DRSP_LOGOUT		= 2,		//ÀëÏßºó±£´æ
	DRSP_ROAM_BACK		= 3,		//¿ç·þ»Ø¹é´æÅÌ
};

enum ROAM_PROTOCOL_DIRECTION
{
	RPD_SEND_TO_DST		= 0,		//Ð­Òé·¢ÏòÄ¿±ê¸±
	RPD_SEND_TO_SRC		= 1,		//Ð­Òé·¢ÏòÔ´·þ
};

enum ROAM_SYNC_STATUS_TYPE
{
	RSS_LOGOUT		= 0,		//µÇ³ö²Ù×÷
	RSS_ROAMIN_SUCCESS	= 1,		//¿ç·þµÇÂ½Õý³£
	RSS_ROAM_BACK		= 2,		//³¢ÊÔ»Ø¹é
	RSS_LOSTCONNECT		= 3,		//¶ÏÏßÁË
};

enum LOGIN_MASK
{
	LOGIN_ROAM 		= 0x01, 	//¿ç·þµÇÂ¼
	LOGIN_DEFAULT_POS 	= 0x02, 	//Ä¬ÈÏ³öÉúµãµÇÂ¼
	LOGIN_CHANGE_LINE	= 0x04,		//»»ÏßµÇÂ½
	LOGIN_ROAM_RECONNECT	= 0x08,		//¶ÏÏßÖØÁ¬µÇÂ½
	LOGIN_RECONNECT		= 0x10,		//Õý³£ÓÎÏ·¶ÏÏßÖØÁ¬

	LOGIN_CLINET_USE	= LOGIN_DEFAULT_POS,
};

enum INSTANCE_DELVERY_STATE
{
	IS_RUNNING		= 0,		//ÕýÔÚÔËÐÐ
	IS_EXPORT_BORAD         = 1,            //µ½´ï³ö¿Ú°æÃæ
	IS_SUCCEED_FIHISH	= 2,		//³É¹¦Íê³É¸±±¾
	IS_CLOSED		= 3,		//¸±±¾¹Ø±Õ£¬Íæ¼Ò±»Ìß³ö
};

inline bool ValidMingxingShowId(const ruid_t& id)
{
	return (id>=330 && id<=350);
}

inline char _i2c(unsigned char i)
{
	const char *_table = "0123456789abcdef";
	if (i < 16)
		return _table[i];
	return '0';
}
inline char _i2C(unsigned char i)
{
	const char *_table = "0123456789ABCDEF";
	if (i < 16)
		return _table[i];
	return '0';
}
inline Octets& B16Encode(Octets &o, bool tolower)
{
	Octets dst;
	dst.resize(o.size()*2);
	unsigned char *src_data = (unsigned char*)o.begin();
	char *dst_data = (char*)dst.begin();
	for (unsigned int i=0; i<o.size(); i++)
	{
		if(tolower)
		{
			dst_data[2*i] = _i2c(src_data[i]>>4);
			dst_data[2*i+1] = _i2c(src_data[i]&0x0f);
		}
		else
		{
			dst_data[2*i] = _i2C(src_data[i]>>4);
			dst_data[2*i+1] = _i2C(src_data[i]&0x0f);
		}
	}
	o.swap(dst);
	return o;
}

struct BIPlayerInfo
{
	int		from;
	int		userid;
	std::string	account;
	std::string	platform;
	std::string	mac;
	int		os;
	std::string	peer;

	BIPlayerInfo(): from(0), userid(0), os(0) {}
};

class BIPlayerInfoManager
{
	std::map<int, BIPlayerInfo> _map; //userid => BIPlayerInfo
	mutable GNET::Thread::Mutex locker;

	BIPlayerInfoManager(): locker("BIPlayerInfoManager") {}

public:
	static BIPlayerInfoManager& GetInstance()
	{
		static BIPlayerInfoManager _instance;
		return _instance;
	}
	bool Get(int user_id, BIPlayerInfo& info) const
	{
		GNET::Thread::Mutex::Scoped l(locker);

		std::map<int, BIPlayerInfo>::const_iterator it = _map.find(user_id);
		if (it != _map.end())
		{
			info = it->second;
			return true;
		}
		return false;
	}
	int GetFrom() const
	{
		if (_map.empty()) return 0;
		return _map.begin()->second.from;
	}
	void Set(const BIPlayerInfo& info)
	{
		GNET::Thread::Mutex::Scoped l(locker);

		_map[info.userid] = info;
	}
};

enum KUAFU_EVENT
{
	KUAFU_EVENT_BIWU_BEGIN			= 1,
	KUAFU_EVENT_BIWU_WIN			= 2,
	KUAFU_EVENT_BIWU_LOSE			= 3,
	KUAFU_EVENT_BIWU_WIN_NO_SCORE		= 4,
};

}

enum TOP_BATTLE_CONST
{
	MAX_RECORD_COUNT	= 10,			//×î¶à±£´æ10´ÎÕ½¼¨ÐÅÏ¢
};

namespace SYS_SPEAK
{
	enum
	{
		PLAYER_NAME,
		FACTION_NAME,
		SWORN_NAME,
		MASTER_NAME,
		SPOUSE_NAME,
		PLAYER_POS,
		MONSTER_ENMITY,
		MONSTER_TARGET,
		MONSTER_POS,
		ECTYPE_CREATOR,
		ECTYPE_OWNER,
		ECTYPE_MEMBER,
		ECTYPE_ID,
		ITEM_LOOT_OWNER,
		ITEM_LOTTERY,
		ITEM_TASK,
		ITEM,
		SWORN_NICKNAME,
		PLAYER_NAME_2,
		PLAYER_NAME_3,
		PLAYER_NAME_4,
		ECTYPE_CREATOR_FACTION,
		ECTYPE_OWNER_FACTION,
		SCENE_ID,
		RELATION_1,
		RELATION_2,
		RELATION_3,
		RELATION_4,
		INT_1,
		INT_2,
		INT_3,
		INT_4,
		SERVER_NAME,
		WALL_ID,
		SERVICE_MSG,
		BANGHUI_NAME,
		
		MASK_PLAYER_NAME =		1 << PLAYER_NAME,
		MASK_FACTION_NAME =		1 << FACTION_NAME,
		MASK_SWORN_NAME =		1 << SWORN_NAME,
		MASK_MASTER_NAME =		1 << MASTER_NAME,
		MASK_SPOUSE_NAME =		1 << SPOUSE_NAME,
		MASK_PLAYER_POS =		1 << PLAYER_POS,
		MASK_MONSTER_ENMITY =		1 << MONSTER_ENMITY,
		MASK_MONSTER_TARGET =		1 << MONSTER_TARGET,
		MASK_MONSTER_POS =		1 << MONSTER_POS,
		MASK_ECTYPE_CREATOR =		1 << ECTYPE_CREATOR,
		MASK_ECTYPE_OWNER =		1 << ECTYPE_OWNER,
		MASK_ECTYPE_MEMBER =		1 << ECTYPE_MEMBER,
		MASK_ECTYPE_ID =		1 << ECTYPE_ID,
		MASK_ITEM_LOOT_OWNER =		1 << ITEM_LOOT_OWNER,
		MASK_ITEM_LOTTERY =		1 << ITEM_LOTTERY,
		MASK_ITEM_TASK =		1 << ITEM_TASK,
		MASK_ITEM =			1 << ITEM,
		MASK_SWORN_NICKNAME =		1 << SWORN_NICKNAME,
		MASK_PLAYER_NAME_2 =		1 << PLAYER_NAME_2,
		MASK_PLAYER_NAME_3 =		1 << PLAYER_NAME_3,
		MASK_PLAYER_NAME_4 =		1 << PLAYER_NAME_4,
		MASK_ECTYPE_CREATOR_FACTION =	1 << ECTYPE_CREATOR_FACTION,
		MASK_ECTYPE_OWNER_FACTION =	1 << ECTYPE_OWNER_FACTION,
		MASK_SCENE_ID =			1 << SCENE_ID,
		MASK_RELATION_1 =		1 << RELATION_1,
		MASK_RELATION_2 =		1 << RELATION_2,
		MASK_RELATION_3 =		1 << RELATION_3,
		MASK_RELATION_4 =		1 << RELATION_4,
		MASK_INT_1 =			1 << INT_1,
		MASK_INT_2 =			1 << INT_2,
		MASK_INT_3 =			1 << INT_3,
		MASK_INT_4 =			1 << INT_4,
		MASK_SERVER_NAME =		(uint64_t)1 << SERVER_NAME,
		MASK_WALL_ID =			(uint64_t)1 << WALL_ID,
		MASK_SERVICE_MSG =              (uint64_t)1 << SERVICE_MSG,
		MASK_BANGHUI_NAME = 		(uint64_t)1 << BANGHUI_NAME,
	};
}

enum ADD_CASH
{
	//ADD_CASH_MAX		= 1000000,	//Ã¿´Î×î¶à³äÖµÔª±¦Êý: 1m
	PENDING_ORDER_MAX	= 30,		//×î¶à¿ÉÒÔÓÐ¼¸¸öÎ´Ö§¸¶¶©µ¥
};

enum ACTIVE_CODE_TYPE
{
	ACTIVE_CODE_TYPE_INVALID	= 0,
	ACTIVE_CODE_TYPE_IOS_LOGIN	= 1,	//IOSÉè±¸µÇÂ¼ÓÎÏ·ÓÃµÄ¼¤»îÂë
	ACTIVE_CODE_TYPE_ANDROID_LOGIN	= 2,	//ANDROIDµÇÂ¼ÓÎÏ·ÓÃµÄ¼¤»îÂë

	ACTIVE_CODE_TYPE_LIBAO_START	= 10001,//±£Áô¸øÀñ°üÓÃµÄ¶Ò»»Âë
	ACTIVE_CODE_TYPE_LIBAO_END	= 21000,
};

enum DEVICE_OS
{
	DEVICE_OS_UNKNOWN	= 0,
	DEVICE_OS_IOS		= 1,
	DEVICE_OS_ANDROID	= 2,
	DEVICE_OS_IOS_YUEYU     = 3,
	DEVICE_OS_WP		= 4,
};

enum BANGHUI_POSITION
{
	BANGZHONG               = 0,
	FUBANGZHU		= 4,
	BANGZHU                 = 5,
};

enum BANGHUI_NOTICE_EVENT
{     
	NOTICE_APPLY                    = 0,
	NOTICE_LEAVE                    = 1,
	NOTICE_ADD_MEMBER               = 2,
	NOTICE_DELETE_MEMBER            = 3,
	NOTICE_INVITE_MEMBER            = 4,
	NOTICE_ADD_FUBANGZHU            = 5,
	NOTICE_DEL_FUBANGZHU            = 6,
	NOTICE_CHANGE_BANGZHU           = 7,
	NOTICE_BANGHUI_SIGN             = 8,//ÆÕÍ¨Ç©µ½
	NOTICE_BANGHUI_SIGN_MID         = 9,//Ð¡Ôª±¦Ç©µ½
	NOTICE_BANGHUI_SIGN_BIG         = 10,//´óÔª±¦Ç©µ½
	NOTICE_BANGHUI_REP_ITEM         = 11,//ÉÏ½ÉÎï×Ê
};

enum CENTER_COMMAND_TYPE
{
	//gs[1,400]
	//link[401,600]
	CENTER_COMMAND_IGNORE_PROTOCOL			= 401,
	CENTER_COMMAND_CLEAR_IGNORE_PROTOCOL		= 402,
	//deliver[601,800]
	CENTER_COMMAND_CHANGE_MAX_ONLINE_PLAYER		= 601,
	CENTER_COMMAND_GET_ONLINE_PLAYER		= 602,
	CENTER_COMMAND_PING				= 603,
	CENTER_COMMAND_DONT_CHECK_TMALL_SIGN		= 604,
	CENTER_COMMAND_CREATE_KUAFU_INSTANCE		= 605,
	CENTER_COMMAND_ENABLE_KUAFU			= 606,
	CENTER_COMMAND_DISABLE_KUAFU			= 607,
	CENTER_COMMAND_ENABLE_KUAFU_1V1			= 608,
	CENTER_COMMAND_DISABLE_KUAFU_1V1		= 609,
	//center[801,1000]
	CENTER_COMMAND_CREATE_ACTIVE_CODE		= 801,
	CENTER_COMMAND_INSERT_ACTIVE_CODE               = 802,
	CENTER_COMMAND_CREATE_504			= 803,
	CENTER_COMMAND_CREATE_2613			= 804,
	//db[1001,1200]
	CENTER_COMMAND_REFRESH_OLD_TOPLIST		= 1001,
	CENTER_COMMAND_GET_SERVER_OPEN_TIME		= 1002,
	CENTER_COMMAND_SET_SERVER_OPEN_TIME		= 1003,
	CENTER_COMMAND_ADD_COMPENSATE			= 1004, //·¢ËÍÈ«·þÀñ°ü
	CENTER_COMMAND_INNER_ADD_CASH			= 1005,	//³äÖµ(½öÓÃÓÚÌáÉýVIPµÈ¼¶£¬²¢²»»áÕæÕý»ñµÃÔª±¦)
	CENTER_COMMAND_ADD_CASH_4_R			= 1006,	//³äÖµ(ÕæÕý»ñµÃÔª±¦£¬Ò»°ãÊÇ¸ø´óRÓÃ)
	CENTER_COMMAND_UPDATE_TOPLIST_4_NEW_ZONE	= 1007,
	CENTER_COMMAND_CHANGE_PLATFORM_USERID		= 1008, //ÐÞ¸ÄÕÊºÅ¶ÔÓ¦µÄuserid
	CENTER_COMMAND_DELETE_ROLE			= 1009, //É¾³ý¶ÔÓ¦µÄ½ÇÉ«
};

enum BANGHUI_SIGN_TYPE
{
	BANGHUI_SIGN_COMMON		= 1,
	BANGHUI_SIGN_LITTLE_YUANBAO     = 2,
	BANGHUI_SIGN_BIG_YUANBAO        = 3,
};

enum BANGHUI_SIGN_MONEY_TYPE
{
	BANGHUI_SIGN_MONEY_COMMON		= 20000,
	BANGHUI_SIGN_MONEY_LITTLE_YUANBAO	= 20,
	BANGHUI_SIGN_MONEY_BIG_YUANBAO		= 200,
};

enum BANGHUI_SIGN_ENERY_TYPE
{
	BANGHUI_SIGN_ENERY_COMMON		= 20,
	BANGHUI_SIGN_ENERY_LITTLE_YUANBAO	= 30,
	BANGHUI_SIGN_ENERY_BIG_YUANBAO		= 60,
};

enum BANGHUI_SIGN_CONGRA_TYPE
{
	BANGHUI_SIGN_CONGRA_COMMON		= 200,
	BANGHUI_SIGN_CONGRA_LITTLE_YUANBAO      = 300,
	BANGHUI_SIGN_CONGRA_BIG_YUANBAO         = 1000,
};

enum BANGHUI_SIGN_ALL_CONGRA_TYPE
{
	BANGHUI_SIGN_ALL_CONGRA_COMMON              = 20,
	BANGHUI_SIGN_ALL_CONGRA_LITTLE_YUANBAO      = 30,
	BANGHUI_SIGN_ALL_CONGRA_BIG_YUANBAO         = 100,
};

enum VIETNAM_PAY_TYPE
{
	VIETNAM_APPLE = 0,		//Æ»¹û³äÖµ
	VIETNAM_GOOGLE = 1,		//google³äÖµ
	VIETNAM_BANK = 2,		//ÒøÐÐ³äÖµ
	VIETNAM_CARD = 3,		//µç»°¿¨³äÖµ
};

enum SERVER_COUNTRY
{
	SERVER_GUOFU = 0,
	SERVER_HK    = 1,
	SERVER_KR    = 2,
	SERVER_VIET  = 3,
	SERVER_WANDA = 4,
};

enum SDK_ID
{
	SDK_ID_HK_IOS_XA	= 1,
	SDK_ID_HK_GOOGLE_XA	= 2,
	SDK_ID_HK_BAPLAY	= 3,
	SDK_ID_HK_STUS   	= 4,
	SDK_ID_HK_FRIDAY	= 5,
	SDK_ID_KR_IOS_XA	= 11,
	SDK_ID_KR_GOOGLE_XA	= 12,
	SDK_ID_KR_BAPLAY	= 13,
	SDK_ID_KR_STUS		= 14,
	SDK_ID_VIET_AND_APPVN	= 21,
	SDK_ID_VIET_APP_APPVN   = 22,
	SDK_ID_VIET_GOOGLE	= 23,
	SDK_ID_VIET_ITUNES      = 24,
	SDK_ID_VIET_AND_GMO	= 25,
	SDK_ID_VIET_APP_GMO   = 26,
};
#endif
