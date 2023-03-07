#ifndef __GNET_LOCALMACRO_H
#define __GNET_LOCALMACRO_H

#include "commonmacro.h"
#include "marshal.h"
#include <vector>
#include <set>
#include <algorithm>
#include <stdio.h>
#include <time.h>
#include <limits.h>

#define CHANGE_WORLD_WAIT_TIME		30	// »»ÏßµÈ´ýÊ±¼ä Í¬¶àÈË»»ÏßµÈ´ýÊ±¼ä
#define PRE_CHANGE_WORLD_WAIT_TIME	15	// ±êÊ¶DS»»Ïß×´Ì¬µÈ´ýÊ±¼ä
#define SYNC_GS_LOAD_TIME_SECOND	4	// Í¬²½GSµÄ¸ºÔØµÄÊ±¼ä
#define GS_DS_SYNC_DELAY_MICRO_SECOND	800	// ¹À¼ÆDS_GSÍ¬²½×î´óÑÓ³Ù£¬ºÁÃë
//Ã¿´ÎÇå³ýÔ¤²âÊý¾ÝµÄ±ÈÀý
#define CLEAR_DOPE_DATA_RATE		(SYNC_GS_LOAD_TIME_SECOND * 10000 / GS_DS_SYNC_DELAY_MICRO_SECOND)

#ifndef INT64_MAX
#define INT64_MAX	0x7FFFFFFFFFFFFFFFLL
#endif

#ifndef UINT16_MAX
#define UINT16_MAX	0xFFFF
#endif

namespace GNET
{

#define PROJECT_APPLICATION_ID  23
#define MAX_STOCK_VOLUME              1000000   // ×î¸ßµ¥±Ê½»Ò×Ôª±¦Êý£¨ÒøÔª±¦£©
#define MAX_STOCK_PRICE               1000000   // ×î¸ßÔª±¦µ¥¼Û£¨ÒøÔª±¦£©
#define MAX_STOCK_ACCOUNT_MONEY 8000000000000LL // Ôª±¦½»Ò×ÕË»§ÔÊÐí´¢Ðî½»Ò×±ÒÉÏÏÞ, Ó¦´óÓÚMAX_STOCK_PRICE*MAX_STOCK_VOLUME
#define MAX_MAIL_ATTACH_MONEY     10000000000LL // Íæ¼ÒÓÊ¼þ¸½¼þÖÐ¿ÉÐ¯´øµÄ½»Ò×±ÒÉÏÏÞ
#define MAX_USER_CASH             1000000000   // ÕËºÅÔª±¦ÉÏÏÞ
#define CASH_BALANCE_THRESHOLD     500000000   // µ±User.cashºÍUser.cash_used¶¼Ôö³¤µ½Ò»¶¨ãÐÖµºó£¬µÇÂ¼Ê±Í³Ò»¼õÉÙ
//#define STOCK_TAX_RATE          1.02
#define MAX_NAME_SIZE           40
#define BATTLE_NAME_MAX_SIZE		30		//Õ½³¡·¿¼äÃû×î³¤15¸ö×Ö½Ú
#define BATTLE_PASSWORD_MAX_SIZE	20		//Õ½³¡ÃÜÂë×î³¤20¸ö×Ö½Ú
#define TEAM_CAPACITY           4
#define MAX_MAILBOX_SIZE        32768
#define MAX_FRIEND_COUNT        5
#define MAX_ENEMY_COUNT         5
#define MAX_BLACKLIST_SIZE      20
#define INVALID_NEXTROLEID      -1
#define MAX_TRUSTEE_COUNT       (5)
#define MARRIAGE_PROPOSE_LEVEL_LIMIT 30 // ¶©»éË«·½µÈ¼¶ÏÞÖÆ
#define MARRIAGE_MARRY_LEVEL_LIMIT   30 // ½á»éË«·½µÈ¼¶ÏÞÖÆ
#define MARRIAGE_DIVORCE_UNCONDITIONAL_TIME_LIMIT 3600 * 24 * 15 // ¶Ô·½15ÌìÎ´µÇÂ¼¿ÉÉêÇëÎÞÌõ¼þÀë»é
//#define MARRIAGE_MARRY_AMITY_LIMIT 5000 // ½á»éË«·½ºÃ¸Ð¶ÈÏÞÖÆ
#define MAIL_PACK_COST              500 // ·¢ËÍÓÊ¼þ°ü¹ü·ÑÓÃ
#define MAX_STOCK_ORDER_PER_USER     10 // Íæ¼ÒÔÚÔª±¦½»Ò×Ê±µÄ×î´óÍ¬Ê±¹Òµ¥Êý
#define MAX_STOCK_LOG_PER_USER       80 // Íæ¼ÒÔª±¦½»Ò×ÈÕÖ¾µÄÌõÊýÉÏÏÞ

#define LAST_DAY_RNAK_KEY		0xFFFF	//Ä¬ÈÏµÄ´æ´¢×òÈÕÅÅÃûµÄÊýÖµ

// ¼ÆËãº¬Ë°µÄÔª±¦½»Ò×Êý
//#define TaxedTradeCash(volume) ((int)((STOCK_TAX_RATE)*(volume)))
// ¼ÆËãº¬Ë°µÄÔª±¦½»Ò×ËùÐè½ðÇ®¡£×¢Òâ£º¶ÔÓÚÊÕ¹ºÔª±¦À´Ëµ£¬ÆäÖµÐ¡ÓÚ0£¨ÒòÎªprice<0£©
//#define CalTaxedTradeMoney(price,volume) ((int64_t)((STOCK_TAX_RATE)*((int64_t)price)*((int64_t)volume)))
//#define TaxedTradeMoney(money) ((int64_t)((STOCK_TAX_RATE)*((int64_t)money)))

#define BACKTABLEID(rid)  (int)(((rid)>>4) & 7)

// roleidÏà¹Ø£¬idÓëroleid²»Í¬£¬Ê¹ÓÃÏÂÃæµÄID_TO_ROLEID½«id×ª»»Îªroleid
#define TEMP_ID_MIN	1		// µÚÒ»¸öroleÄ£°åµÄid
#define FREE_ID_MIN	0x01LL		// µÚÒ»¸ö¿É·ÖÅä¸øÍæ¼ÒµÄid£¬ËùÒÔ×îÐ¡µÄÍæ¼Ò½ÇÉ«idÎª (FREE_ID_MIN<<ZONE_ID_BIT)
#define FREE_ID_MAX	0xFFFFFFFFFFLL	// ×î´ó¿É·ÖÅä¸øÍæ¼ÒµÄid£¬×¢Òâ·¶Î§
#define ZONE_ID_BIT	16		// zoneidÕ¼ÓÃ16bit£¬×î¶àÖ§³Ö65536¸öÇø
#define ZONE_ID_MASK	0xFFFF		
#define ID_TO_ROLEID(id, zoneid) (((id) << ZONE_ID_BIT) | (zoneid))
#define LOCAL_ZONE_MARK   0		// ·ºÖ¸ÔÙ×Ô¼ºµ±Ç°µÄÔ´Çø,zonedi×îÐ¡ÖµÎª1

#define MAX_ZONE_ID			0x0000FFFF		// zoneid×î´óÖµ 65535
#define ZONE_ID(roleid)			((roleid) & ZONE_ID_MASK)
#define IS_LOCAL_ZONE_MARK(zone)	((size_t)zone == LOCAL_ZONE_MARK || (size_t)zone > MAX_ZONE_ID)
#define IS_NATIVE_PEOPLE(roleid,roleid2)  (ZONE_ID(roleid) == ZONE_ID(roleid2))
#define IS_LOCAL_ZONE_ID(roleid)	(IS_LOCAL_ZONE_MARK(ZONE_ID(roleid)) || (ZONE_ID(roleid) == g_zoneid))

#define FAMILY_FREE_ID_MIN	1	// µÚÒ»¸ö¿É·ÖÅä¸øfamilyµÄid
#define FAMILY_FREE_ID_MAX	1000000	// ×î´ó¿É·ÖÅä¸øfamilyµÄid,×¢Òâ·¶Î§
#define ID_TO_FAMILYID(id, zoneid) (((id) << ZONE_ID_BIT) | (zoneid))

#define FACTION_FREE_ID_MIN	1	// µÚÒ»¸ö¿É·ÖÅä¸øfactionµÄid
#define FACTION_FREE_ID_MAX	1000000	// ×î´ó¿É·ÖÅä¸øfactionµÄid,×¢Òâ·¶Î§
#define ID_TO_FACTIONID(id, zoneid) (((id) << ZONE_ID_BIT) | (zoneid))

#define COMMON_SDK_USERID_FREE_ID_MIN	1000 // µÚÒ»¸ö¿É·ÖÅä¸øcommon sdkµÄuser id
#define COMMON_SDK_USERID_FREE_ID_MAX	100000000// ×î´ó¿É·ÖÅä¸øcommon sdkµÄuser id,×¢Òâ·¶Î§
#define ID_TO_COMMON_SDK_USERID(id, zoneid) (id)

#define MAX_PLAYER_SIGNATURE_LENGTH 32 // Íæ¼ÒÇ©ÃûµÄ×î´ó³¤¶È
#define MAX_PLAYER_CUSTOM_APPEARANCE_LENGTH 100 // Íæ¼Ò½ÇÉ«×Ô¶¨ÒåÊý¾ÝµÄ×î´ó³¤¶È
#define MAX_PLAYER_TITLE_DATA_LENGTH 64 // Íæ¼Ò³ÆºÅ¸½¼ÓÊý¾ÝµÄ×î´ó³¤¶È

#define MIN_AUCTION_LEVEL	10		//×îÐ¡²ÎÓëÅÄÂôÍæ¼ÒµÈ¼¶
#define SYNC_FACTION_MIN_MONEY_ADD	73	//Íæ¼Ò¾èÇ®ºóÊµÊ±´æÅÌµÄ×îÐ¡Ç®Êý

enum TIZI_ID_TYPE
{
	TZT_FACTION	= 0x1000000000000000LL,
	TZT_SCENE	= 0x2000000000000000LL,	

	TZT_TYPE_MASK	= 0xF000000000000000LL,
};
#define FACTIONID_TO_TIZIID(id) (id | TZT_FACTION)
#define SCENEID_TO_TIZIID(id) (id | TZT_SCENE)
#define TIZIID_TO_FACTIONID(id) (id & ~TZT_FACTION)
#define TIZIID_TO_SCENEID(id) (id & ~TZT_SCENE)
#define TIZIID_TYPE(id) (id & TZT_TYPE_MASK)

enum{
	ALGORITHM_MASK_HIGH           = 0xFFFF0000,  
	ALGORITHM_MASK_OPT            = 0x0000FF00,
	ALGORITHM_OPT_NOCACHE         = 0x00000100,  // DS²»±£´æÃÜÂë
	ALGORITHM_PASSWORD_OBSOLETE   = 0x00000200,  // ÃÜÂë³¤ÆÚÎ´¸ü»»
	ALGORITHM_CARD_OBSOLETE       = 0x00000400,  // ÃÜ±£¿¨³¤ÆÚÎ´¸ü»»
	ALGORITHM_GM_ACCOUNT          = 0x00000800,  // GMÕÊºÅ 
	ALGORITHM_NONE                = 0x0,
	ALGORITHM_CARD                = 0x00010000,  // ÃÜ±£¿¨ÓÃ»§
	ALGORITHM_HANDSET             = 0x00020000,  // ÊÖ»úÃÜ±£ÓÃ»§
	ALGORITHM_USBKEY              = 0x00030000,  // Ò»´úÉñ¶ÜÓÃ»§
	ALGORITHM_PHONE               = 0x00040000,  // µç»°ÃÜ±£ÓÃ»§
	ALGORITHM_USBKEY2             = 0x00050000,  // ¶þ´úÉñ¶ÜÓÃ»§
};
enum{
	BASE_STATUS_DEFAULT	= 0x01,  // Ä¬ÈÏ×´Ì¬
	BASE_STATUS_DELETING	= 0x02,  // µÈ´ýÉ¾³ýÖÐ
	BASE_STATUS_DELETED	= 0x04,  // ÂíÉÏÉ¾³ý
	BASE_STATUS_BACKED	= 0x08,  // ÍêÕû½ÇÉ«Êý¾Ý±£´æÓÚBackDBDÖÐ
	BASE_STATUS_NEWRETURN   = 0x10,  // ½ÇÉ«¸ÕÓÉ²»»îÔ¾×´Ì¬±äÎª»îÔ¾
	BASE_STATUS_EXPIRED	= 0x20,  // ½ÇÉ«ÐÅÏ¢ÒÑ¹ýÆÚ(ÓÃÓÚÃ÷ÐÇ±¸·Ý½ÇÉ«)
};

//player logout style
enum PLAYER_LOGOUT_STYLE
{
	PLAYER_LOGOUT_FULL = 0,		//´óÍË
	PLAYER_LOGOUT_HALF = 1,		//Ð¡ÍË
	PLAYER_LOGOUT_ZONE = 2,		//¿ç·þ»Ø¹é
	PLAYER_LOGOUT_DISCONNECT = 3,	//·þÎñÆ÷Ìßµô»ò¿Í»§¶Ë¶ÏÏß

	PLAYER_LOGOUT_COUNT,
};

enum{
	PLAYER_STATUS_INITIAL		= 0, // ³õÊ¼×´Ì¬
	PLAYER_STATUS_PENDING		= 1, // µÈ´ýÉÏ´ÎµÇÂ¼½áÊø
	PLAYER_STATUS_ROAMRECV		= 2, // ÊÕµ½RoamÐ­Òé
	PLAYER_STATUS_READYGAME		= 3, // µÈ´ý½øÈëÊÀ½çÃüÁî
	PLAYER_STATUS_ONLINE		= 4, // ½ÇÉ«ÁÐ±í×´Ì¬
	PLAYER_STATUS_LOGINRECV		= 5, // ÊÕµ½PlayerLoginÐ­Òé
	PLAYER_STATUS_LOADGAME		= 6, // ÕýÔÚ¼ÓÔØÓÎÏ·Êý¾Ý
	PLAYER_STATUS_INGAME		= 7, // ÓÎÏ·×´Ì¬
	PLAYER_STATUS_ROAM		= 8, // Ô´DS¿ç·þ×´Ì¬
	PLAYER_STATUS_CLOSING		= 9, // ÊÕµ½PlayerLogoutÐ­Òé
	PLAYER_STATUS_CLOSEWAIT		= 10,// µÈ´ýGSÈ·ÈÏ½ÇÉ«ÍË³ö
	PLAYER_STATUS_CLOSED		= 11,// ÕËºÅÒÑÍË³öµÇÂ¼
	PLAYER_STATUS_LOST_CONNECT	= 12,// µÈ´ý¶ÏÏßÖØÁ¬
	PLAYER_STATUS_RECONNECT		= 13,// ¶ÏÏßÖØÁ¬×´Ì¬
};

enum{
	ITEM_PROC_TYPE_NODROP           = 0x00000001,   //ËÀÍöÊ±²»µôÂä
	ITEM_PROC_TYPE_NODESTROY        = 0x00000002,   //²»ÔÊÐí´Ý»Ù
	ITEM_PROC_TYPE_NOSELL           = 0x00000004,   //ÎÞ·¨Âô¸øNPC 
	ITEM_PROC_TYPE_CASHITEM         = 0x00000008,   //ÊÇÈËÃñ±ÒÎïÆ·
	ITEM_PROC_TYPE_NOTRADE          = 0x00000010,   //Íæ¼Ò¼ä²»ÄÜ½»Ò×
	ITEM_PROC_TYPE_TASKITEM         = 0x00000020,   //ÊÇÈÎÎñÎïÆ¨
	ITEM_PROC_TYPE_PICK_BIND        = 0x00000040,   //Ê°È¡ºó°ó¶¨
	ITEM_PROC_TYPE_AUTO_BIND        = 0x00000080,   //×°±¸»òÕßÊ¹ÓÃºó°ó¶¨
	ITEM_PROC_TYPE_BOUND            = 0x00000100,   //ÊÇÒÑ¾­°ó¶¨µÄÎïÆ·
	ITEM_PROC_TYPE_NO_BIND          = 0x00000200,   //²»ÔÊÐíÑÏ¸ñ°ó¶¨£¨ÌìÈËºÏÒ»£©
	ITEM_PROC_TYPE_GUID             = 0x00000400,   //Ó¦²úÉúGUID
	ITEM_PROC_TYPE_NO_SPLIT         = 0x00000800,   //¼´Ê¹pile_limit >1 Ò²²»¿É¶ÑµþºÍ²ð·Ö
	ITEM_PROC_TYPE_EXBOUND          = 0x00002000,   //°ó¶¨
	ITEM_PROC_TYPE_S_BOUND          = 0x20000000,   //ÊÇÒÑ¾­ÑÏ¸ñ°ó¶¨µÄÎïÞ·
	ITEM_PROC_TYPE_UPGRADE          = 0x40000000,   //ÒÑÉý¹ý¼¶±ðµÄÎïÆ· ÎÞ·¨µôÂä½»Ò×
	ITEM_PROC_TYPE_UNBIND_EXPIRE    = 0x80000000,   //ÊÇÓµÓÐµ½ÆÚ½â³ý°ó¶¨µÄÎïÆ·
};
#define MASK_ITEM_NOTRADE  (ITEM_PROC_TYPE_NOTRADE|ITEM_PROC_TYPE_BOUND|ITEM_PROC_TYPE_S_BOUND|ITEM_PROC_TYPE_UPGRADE|ITEM_PROC_TYPE_EXBOUND)
#define MASK_ITEM_NOSPLIT  (ITEM_PROC_TYPE_NO_SPLIT|ITEM_PROC_TYPE_S_BOUND)

enum{
	CASH_GETSERIAL_FAILED = -16,
	CASH_ADD_FAILED       = -17,
	CASH_NOT_ENOUGH       = -18
};

enum{
	SYNC_STOTEHOUSE  = 0x01,
	SYNC_CASHUSED    = 0x02,
	SYNC_CASHTOTAL   = 0x04,
	SYNC_SHOPLOG     = 0x08,
};

enum{
	GMSTATE_ACTIVE   = 0x01, 
};

enum {
	TOP_PERSONAL_LEVEL = 1,
	TOP_PERSONAL_MONEY = 2,
	TOP_WEI_CREDIT13    =   11,
	TOP_WEI_CREDIT16    =   12,
	TOP_WEI_CREDIT17    =   13,
	TOP_SHU_CREDIT14    =   14,
	TOP_SHU_CREDIT16    =   15,
	TOP_SHU_CREDIT17    =   16,
	TOP_WU_CREDIT15     =   17,
	TOP_WU_CREDIT16     =   18,
	TOP_WU_CREDIT17     =   19,
	TOP_PERSONAL_CREDIT_START = 20,

	TOP_FACTION_LEVEL = 61,
	TOP_FACTION_MONEY = 62,
	TOP_FACTION_POPULATION = 63,
	TOP_FACTION_PROSPERITY = 64,
	TOP_FACTION_NIMBUS  = 65,
	TOP_FACTION_CREDIT_START = 80,

	TOP_FAMILY_TASK_START = 120,
};

#define FIRST_TOPTABLE_ID     (TOP_PERSONAL_LEVEL);
#define LAST_TOPTABLE_ID      (TOP_FAMILY_TASK_START+9)
#define TOP_ITEM_PER_PAGE     20
#define REGION_COUNT          10
#define TOPTABLE_COUNT        90
#define WEEKLYTOP_BEGIN       1000

enum ERR_TOP_TABLE{
	TOP_DATE_NOTREADY = 1,
	TOP_INVALID_ID = 2,
};

enum ERR_COMBAT
{
	ERR_COMBAT_MASTEROFFLINE = 1,
	ERR_COMBAT_NOPROSPERITY  = 2,
	ERR_COMBAT_COOLING       = 3,
	ERR_COMBAT_BUSY          = 4,
	ERR_COMBAT_LOWLEVEL      = 5,
	ERR_COMBAT_INBATTLE      = 6,
};

enum ERR_BATTLE
{
	ERR_BATTLE_TEAM_FULL		= 140,	// ÕóÓªÒÑÂú
	ERR_BATTLE_GAME_SERVER		= 141,	// ²»ÔÚÍ¬Ò»ÌõÏß
	ERR_BATTLE_JOIN_ALREADY 	= 142,	// ÒÑ¾­¼ÓÈë¶ÓÎé
	ERR_BATTLE_MAP_NOTEXIST		= 143,	// Ã»ÓÐÕÒµ½µØÍ¼
	ERR_BATTLE_COOLDOWN		= 144,	// ÀëÉÏ´ÎÕ½¶·Ê±¼ä²»×ãÀäÈ´Ê±¼ä£¬²»ÄÜ±¨Ãû
	ERR_BATTLE_NOT_INTEAM		= 145,  // ÓÃ»§²»ÔÚ¶ÓÎéÖÐ
	ERR_BATTLE_LEVEL_LIMIT		= 146,  // ÓÃ»§²»·ûºÏÕ½³¡¼¶±ðÏÞÖÆ
	ERR_BATTLE_OCCUPATION		= 147,  // ÓÃ»§ÕóÓªÏÞÖÆ
	ERR_BATTLE_QUEUELIMIT		= 148,  // ÓÃ»§ÅÅ¶Ó³¬¹ý×î´óÏÞÖÆ
	ERR_BATTLE_INFIGHTING 		= 149,  // ÒÑ¾­½øÈëÕ½³¡£¬²»ÄÜÍË³ö±¨Ãû
};

enum 
{
	RESULT_ATTACKER = 1,
	RESULT_DEFENDER = 2,
	RESULT_CANCEL = 3,
	RESULT_TIMEOUT = 4,
};
enum ERR_SIEGE
{
	ERR_SIEGE_BIDFAILED	= 160, 		//ÕóÓªÄÚ±¨ÃûÊ§°Ü
	ERR_SIEGE_CHALLENGEFAILED = 161, 	//³ÉÕ¼±¨ÃûÊ§°Ü
	ERR_SIEGE_NATION = 162, 		//²»ÊÇ±¾ÕóÓª£¬²»ÄÜ±¨ÃûÄÚ²¿
	ERR_SIEGE_NIMBUS = 163,			//Í³ÓùÖµ²»×ã
	ERR_SIEGE_NOOWNCITY = 164,		//Ã»ÓÐÁìµØ²»ÄÜ±¨Ãû³ÇÕ½
	ERR_SIEGE_NODEFENDERONLY = 165,		//È¡Ïû¹ý±¨Ãû£¬²»ÄÜ±¨ÓÐÈË·ÀÊØµÄ³Ç
	ERR_SIEGE_ADJACENT = 166,		//Á½¸ö³Ç²»ÏàÁÚ
	ERR_SIEGE_DUPBID = 167,			//ÖØ¸´¾º¼Û
	ERR_SIEGE_FACTIONLIMIT = 168,		//°ïÅÉ¼¶±ðÏÞÖÆ
	ERR_SIEGE_CITYNOTFOUND = 169,		//³ÇÊÐÃ»ÕÒµ½
	ERR_SIEGE_ENTERFAILED = 170,		//½øÈë³ÇÕ½Ê§°Ü
	ERR_SIEGE_NATIONFULL = 171,		//³ÇÕ½±¾·½ÕóÓªÈËÂú
	ERR_SIEGE_DUPENTER = 172,		//ÖØ¸´½øÈë
	ERR_SIEGE_CAPITAL = 173, 		//¹¥Õ¼Ê×¶¼±ØÐëÕ¼Áì37¸ö³ÊÐ
	ERR_SIEGE_CANNOTENTER = 174,		//²»ÊôÓÚ½»Õ½ÕóÓª£¬²»ÄÜ½øÈë
	ERR_SIEGE_LEVELLIMIT = 175,		//¼¶±ð²»×ã£¬²»ÄÜ½øÈë³ÇÕ½
	ERR_SIEGE_ENTERPRIOR = 176,		//¿ªÕ½Îå·ÖÖÓ£¬Ö»ÄÜ±¾°ïÅÉ½øÈë 

};

enum STOCK_ORDER_RESULT
{
	STOCK_ORDER_RESULT_SELL    = 0, 
	STOCK_ORDER_RESULT_BUY     = 1, 
	STOCK_ORDER_RESULT_CANCEL  = 2, 
	STOCK_ORDER_RESULT_TIMEOUT = 3,
};

enum OPER_ENEMY{
	ENEMY_REMOVE = 0,
	ENEMY_FREEZE = 1,
	ENEMY_INSERT = 2
};
enum GET_ENEMY{
	ENEMY_ONLINE   = 0,
	ENEMY_FULLLIST = 1,
	ENEMY_NEW      = 2,
	ENEMY_IDLIST   = 3
};
enum
{
	MSG_BIDSTART             = 1,  // ¿ªÊ¼¾º¼Û
	MSG_BIDEND               = 2,  // ¾º¼Û½áÊø
	MSG_BATTLESTART          = 3,  // ³ÇÕ½¿ªÊ¼
	MSG_BATTLEEND            = 4,  // ³ÇÕ½½áÊø
	MSG_BIDSUCCESS           = 5,  // ¾º¼Û³É¹¦
	MSG_BONUSSEND            = 6,  // ÁìÍÁÊÕÒæ·¢ËÍ
	MSG_MARRIAGE             = 10, // ½á»é
	MSG_DIVORCE              = 11, // Àë»é
	MSG_COMBATCHALLENGE      = 12, // Ò°Õ½ÌôÕ½
	MSG_COMBATSTART          = 13, // Ò°Õ½¿ªÊ¼
	MSG_COMBATREFUSE         = 14, // ¾Ü¾øÒ°Õ½ÑûÇë
	MSG_COMBATEND            = 15, // Ò°Õ½½áÊø
	MSG_COMBATTIMEOUT        = 16, // Ò°Õ½ÑûÇë³¬Ê±
	MSG_CITYNOOWN            = 17, // °ïÅÉ½µ¼¶ºó³ÇÊÐÎÞÖ÷
	MSG_BATTLE1START         = 18, // ÓÐÁìÍÁ¶ÔÓÐÁìÍÁ°ïÅÉ³ÇÕ½¿ªÊ¼
	MSG_BATTLE2START         = 19, // ÎÞÁìÍÁ¶ÔÓÐÁìÍÁ°ïÅÉ³ÇÕ½¿ªÊ¼ 
	MSG_FAMILYDEVOTION       = 20, // »ñµÃ¼Ò×å¹±Ï×¶È
	MSG_FAMILYSKILLABILITY   = 21, // ¼Ò×å¼¼ÄÜµÈ¼¶±ä»¯
	MSG_FAMILYSKILLEVEL      = 22, // ¼Ò×å¼¼ÄÜÊìÁ·¶È±ä»¯
	MSG_FACTIONNIMBUS        = 23, // °ïÅÉÁéÆø±ä»¯
	MSG_TASK                 = 24, // ÈÎÎñº°»°
	MSG_SIEGERESET           = 25, // ÁìÍÁÖØÖÃ
	MSG_SIEGEBIDBEGIN      	 = 26, // ¿ªÊ¼×¤ÊØÉêÇë
	MSG_SIEGEBID      	 = 27, // ×¤ÊØ
	MSG_SIEGERESETCITY     	 = 28, // ÖØÖÃÁìÍÁ²ÎÊý
	MSG_SIEGEBIDEND     	 = 29, // ×¤ÊØÉêÇë½áÊø
	MSG_SIEGECHALLENGEBEGIN  = 30, // ÁìÍÁÐûÕ½¿ªÊ¼
	MSG_SIEGECHALLENGE  	 = 31, // ÁìÍÁÐûÕ½
	MSG_SIEGECHALLENGEEND    = 32, // ÁìÍÁÐûÕ½½áÊø
	MSG_SIEGEARANGE   	 = 33, // ¹úÕ½ÁÐ±íÈ·¶¨
	MSG_SIEGEBEGIN   	 = 34, // ¹úÕ½¿ªÊ¼
	MSG_SIEGEEND   	 	 = 35, // ¹úÕ½½áÊø
	MSG_SIEGETIME  	 	 = 36, // Ê±¼äÍ¨Öª
	MSG_CONTESTTIME		 = 37, // ´ðÌâ¾ºÈü Ê±¼äÍ¨Öª 
	MSG_CONTESTEND		 = 38, // ´ðÌâ¾ºÈü ½áÊø
};

enum
{
	TIME_BIDEND = 1,
	TIME_CHALLENGEEND = 2,
	TIME_SIEGEBEFORE = 3,
	TIME_SIEGEBEGIN = 4,
	TIME_CONTEST	= 5,

};

enum CHGS_ERR
{
	ERR_CHGS_SUCCESS         = 0,
	ERR_CHGS_INVALIDGS       = 1,	//²»´æÔÚ¸ÃgsºÅ
	ERR_CHGS_MAXUSER         = 2,	//Ä¿µÄgsÈËÊý´ïµ½ÉÏÏÞ
	ERR_CHGS_NOTINSERVER     = 3,	//ÓÃ»§ÇÐ»»gsÊ±²»ÔÚ·þÎñÆ÷ÄÚ
	ERR_CHGS_STATUSINVALID   = 4,	//ÓÃ»§ÇÐ»»gsÊ±×´Ì¬²»¶Ô
	ERR_CHGS_NOTGM           = 5,	//ÓÃ»§²»ÊÇgm
	ERR_CHGS_MAPIDINVALID    = 6,	//µØÍ¼²»´æÔÚ
	ERR_CHGS_SCALEINVALID    = 7,	//·Ç·¨×ø±ê
	ERR_CHGS_DBERROR         = 8,	//Êý¾Ý¿â´íÎó
};

enum {
	TITLE_FREEMAN    = 0,
	TITLE_SYSTEM     = 1,
	TITLE_MASTER     = 2,
	TITLE_VICEMASTER = 3,
	TITLE_CAPTAIN    = 4,
	TITLE_HEADER     = 5,
	TITLE_MEMBER     = 6,
}; //end of Roles

enum	AWAR_STEP		//ÃËÖ÷Õ½½×¶Î
{
	AS_UNACTIVE	= 0,	//Î´¼¤»î
	AS_NONE         = 1,    //¿ÕÏÐ
	AS_APPLY        = 2,    //ÉêÇë½×¶Î
	AS_START_WAR    = 3,    //¿ªÕ½½×¶Î
	AS_END_WAR	= 4,	//Õ½¶·½áËã½×¶Î
};

enum
{
	GNET_FORBID_LOGIN	= 100,	//½ûÖ¹µÇÂ¼
	GNET_FORBID_TALK	= 101,	//½ûÑÔ
	GNET_FORBID_TRADE	= 102,	//½ûÖ¹Íæ¼Ò½»Ò×
};
enum
{
	PRV_TOGGLE_NAMEID	= 0,	//ÇÐ»»Íæ¼ÒÃû×ÖÓëID
	PRV_HIDE_BEGOD		= 1,	//½øÈëÒþÉí»òÎÞµÐ×´Ì¬
	PRV_ONLINE_ORNOT	= 2,	//ÇÐ»»ÊÇ·ñÔÚÏß
	PRV_CHAT_ORNOT		= 3,	//ÇÐ»»ÊÇ·ñ¿ÉÒÔÃÜÓï
	PRV_MOVETO_ROLE		= 4,	//ÒÆ¶¯µ½Ö¸¶¨½ÇÉ«Éí±ß
	PRV_FETCH_ROLE		= 5,	//½«Ö¸¶¨½ÇÉ«ÕÙ»½µ½GMÉí±ß
	PRV_MOVE_ASWILL		= 6,	//ÒÆ¶¯µ½Ö¸¶¨Î»ÖÃ
	PRV_MOVETO_NPC		= 7,	//ÒÆ¶¯µ½Ö¸¶¨NPCÎ»ÖÃ
	PRV_MOVETO_MAP		= 8,	//ÒÆ¶¯µ½Ö¸¶¨µØÍ¼£¨¸±±¾£©
	PRV_ENHANCE_SPEED	= 9,	//ÒÆ¶¯¼ÓËÙ
	PRV_FOLLOW		= 10,	//¸úËæÍæ¼Ò
	PRV_LISTUSER		= 11,	//»ñÈ¡ÔÚÏßÍæ¼ÒÁÐ±í
	PRV_FORCE_OFFLINE	= 100,	//Ç¿ÖÆÍæ¼ÒÏÂÏß£¬²¢½ûÖ¹ÔÚÒ»¶¨Ê±¼äÉÏÏß
	PRV_FORBID_TALK		= 101,	//½ûÑÔ
	PRV_FORBID_TRADE	= 102,	//½ûÖ¹Íæ¼Ò¼ä¡¢Íæ¼ÒÓëNPC½»Ò×£¬½öÕë¶ÔÒ»¸öÍæ¼Ò
	PRV_FORBID_SELL		= 103,	//½ûÂô
	PRV_BROADCAST		= 104,	//ÏµÍ³¹ã²¥
	PRV_SHUTDOWN_GAMESERVER	= 105,	//¹Ø±ÕÓÎÏ··þÎñÆ÷
	PRV_SUMMON_MONSTER	= 200,	//ÕÙ»½¹ÖÎï
	PRV_DISPEL_SUMMON	= 201,	//ÇýÉ¢±»ÕÙ»½ÎïÌå
	PRV_PRETEND		= 202,	//Î±×°
	PRV_GMMASTER		= 203,	//GM¹ÜÀíÔ±
};

enum ERR_FAMILY
{
	ERR_FC_INFACTION = 125,
};

#define FACTION_ACTIVE

enum FACTION_SAFE_SYNC_TYPE
{
	FSST_DISMISS		= 1,	// ½âÉ¢°ïÅÉ
	FSST_STATUS		= 2,	// Í¬²½status
};

enum FACTION_GETMONEY_TYPE
{
	FGT_SALARY		= 1,	// Áì¹¤×Ê
	FGT_BONUS		= 2,	// Áì¹©·î
	FGT_WELF_EXP		= 3,	// ¸£Àû¾­Ñé
	FGT_CLEAR_WELF_EXP	= 4,	// Çå³ý¸£Àû¾­ÑéÁìÈ¡±êÊ¶
};

enum ALLIANCE_INC_MONEY_TYPE
{
	AIMT_GENERAL		= 0,
	AIMT_SELL_TAX		= 1,	// ÊÛÂôÊÕË°
	AIMT_TASK_TAX		= 2,	// ÈÎÎñË°
	AIMT_ALLIANCER_INC	= 3,	// ÃËÖ÷Ôö¼Ó
};

enum ALLIANCE_DEC_MONEY_TYPE
{
	ADMT_GENERAL		= 0,
	ADMT_ALLIANCER_DEC	= 1,	// ÃËÖ÷»ñÈ¡
};

enum
{
	ALLIANCE_WAR_SCENE_TAG		= 1032,	// ÃËÖ÷Õ½³¡¾°TAG
};

enum FACTION_BASE_STATUS
{
	FBS_NORMAL		= 0,	//
	FBS_NO_MONEY		= 0x01,	//×Ê½ð²»×ã
	FBS_MERGE		= 0x02,	//ºÏ²¢¹ý³ÌÖÐ¹Ø±Õ
	FBS_ACTIVITY		= 0x04,	//»îÔ¾¶È²»×ã¹Ø±Õ
	FBS_MEMBERS		= 0x08,	//ÈËÊý²»×ã¹Ø±Õ

	FBS_CLOSED		= 0x80,	//ÒÑ¾­¹Ø±Õ
};

enum FACTION_SYNC_STATUS
{
	FSS_BASE_STATUS		= 1, //Í¬²½»ùµØ×´Ì¬
};

enum FACTION_BASE_INFO_TYPE
{
	FBIT_GET		= 1,
	FBIT_SET		= 2,
};

enum FACTION_HIREINFO_SYNC_TYPE
{
	FHST_INIT		= 1,	// ³õÊ¼»¯
	FHST_ADD		= 2,	// Ôö¼Ó
	FHST_DEL		= 3,	// É¾³ý
	FHST_UPDATE		= 4,	// ¸üÐÂ
};

enum TIZI_SYNC_TYPE
{
	TST_INIT		= 1,	//³õÊ¼»¯
	TST_ADD			= 2,	//ÐÂÔö
	TST_DEL			= 3,	//É¾³ý
};

const int faction_inst_tid[] = {
		1247,		//ïÚ¾Ö¶ÔÓ¦¸±±¾Ä£°æid£º1247
		1249,		//Âí°ï¶ÔÓ¦µÄ¸±±¾Ä£°æid£º1249
		1248,		//É½Õ¯¶ÔÓ¦µÄ¸±±¾Ä£°æID£º1248
		1250,		//¹¤·»¶ÔÓ¦µÄ¸±±¾Ä£°æid£º1250
};

inline bool IsMafiaBase(int tid)
{
	for(size_t i = 0; i < sizeof(faction_inst_tid) / sizeof(faction_inst_tid[0]) ; ++i)
		if(tid == faction_inst_tid[i]) return true;
	return false;
}

enum {
	FACTION_DOMAIN_COUNT		= 4,	// ²úÒµÊýÁ¿
	FACTION_BUILD_COUNT		= 7,	// ½¨ÖþÀàÐÍÊýÁ¿
	FACTION_BUILD_LIVING		= 2,	// ºóÇÚ´¦µÄindex
};

class FactionHelper
{
public :
	typedef unsigned char uchar;

#define  FACTION_MAX_LEVEL		9

#define	FACTION_PER_LEVEL_COMMON_TEST(l, data, ret)		\
	{							\
		if (data.faction_config_per_level.size() == 0)	\
			return ret;				\
								\
		if (l >= FACTION_MAX_LEVEL)			\
			l = FACTION_MAX_LEVEL - 1;		\
								\
		if (l >= data.faction_config_per_level.size())	\
			l = data.faction_config_per_level.size() - 1;\
	}

	template<typename COMMON_DATA>
	static unsigned short FactionLevel2Capacity(unsigned char l, const COMMON_DATA& data)
	{
		l --;
		FACTION_PER_LEVEL_COMMON_TEST(l, data, 0)

		return data.faction_config_per_level[l].member_capacity;
	}

	template<typename COMMON_DATA>
	static unsigned short GetCapacity(uchar l, unsigned short ext_capacity, const COMMON_DATA& data)
	{
		l--;
		FACTION_PER_LEVEL_COMMON_TEST(l, data, 0)

		return  data.faction_config_per_level[l].member_capacity + ext_capacity;
	}

	template<typename COMMON_DATA>
	static int64_t UpgradeMoney(uchar l, const COMMON_DATA& data)
	{
		FACTION_PER_LEVEL_COMMON_TEST(l, data, INT64_MAX)

		return data.faction_config_per_level[l].upgrade_money;
	}

	template<typename COMMON_DATA>
	static int UpgradeContri(uchar level, const COMMON_DATA& data)
	{
		FACTION_PER_LEVEL_COMMON_TEST(level, data, INT_MAX);

		return data.faction_config_per_level[level].contri_upgrade;
	}

	template<typename GFaction, typename COMMON_DATA>
	static int GetExtCapcity(const GFaction &fa, const COMMON_DATA& data)
	{
		size_t place_wing_index = data.faction_build_place_wing_index;
		int level = 0;
		if(fa.housebase.domain >= 0 && fa.housebase.builds.size() >= place_wing_index)
		{
			level = fa.housebase.builds[place_wing_index -1].level + 1;
		}
		return UpgradeExtCapacity(level);
	}

#define  FACTION_TITLE_COUNTE			9		//from FTI_1 -> FTI_10 to 0 - 9

#define	FACTION_PER_TITLE_COMMON_TEST(l, data, ret)		\
	{							\
		if (data.faction_title_per_level.size() == 0 || l == 0)	\
			return ret;				\
								\
		if (--l > FACTION_TITLE_COUNTE)			\
			l = FACTION_TITLE_COUNTE;		\
								\
		if (l >= data.faction_title_per_level.size())	\
			l = data.faction_title_per_level.size() - 1;\
	}

	template<typename COMMON_DATA>
	static unsigned int GetTitleContri(uchar level, const COMMON_DATA& data)
	{
		FACTION_PER_TITLE_COMMON_TEST(level, data, INT_MAX);
		
		return data.faction_title_per_level[level].contri;
	}

	template<typename COMMON_DATA>
	static int GetTitleDate(uchar level, const COMMON_DATA& data)
	{
		FACTION_PER_TITLE_COMMON_TEST(level, data, INT_MAX);
		
		return data.faction_title_per_level[level].date;
	}

#define DBHelperGetExtCapcity(fa)		\
	(FactionHelper::GetExtCapcity<GFaction, XAServerConfigData>(fa, ServerCommonConfigManager::Instance()->GetData()))

#define DSHelperFactionLevel2Capacity(level)	\
	(FactionHelper::FactionLevel2Capacity<XAServerConfigData>(level, ServerCommonConfigManager::Instance()->GetData()))

#define DSHelperGetCapacity(level, ext_capacity)	\
	(FactionHelper::GetCapacity<XAServerConfigData>(level, ext_capacity, ServerCommonConfigManager::Instance()->GetData()))

#define DSHelperUpgradeMoney(level)	\
	(FactionHelper::UpgradeMoney<XAServerConfigData>(level, ServerCommonConfigManager::Instance()->GetData()))

#define DSHelperUpgradeContri(level)	\
	(FactionHelper::UpgradeContri<XAServerConfigData>(level, ServerCommonConfigManager::Instance()->GetData()))

#define FACTION_BASE_MONEY_REACTIVE	\
	(ServerCommonConfigManager::Instance()->GetData().faction_reactive_base_money)

#define DSFHelperTitleContri(level)	\
	(FactionHelper::GetTitleContri<XAServerConfigData>(level, ServerCommonConfigManager::Instance()->GetData()))

#define DSFHelperTitleDate(level)	\
	(FactionHelper::GetTitleDate<XAServerConfigData>(level, ServerCommonConfigManager::Instance()->GetData()))

#define DSFHelperTitleDateQuit		\
	(ServerCommonConfigManager::Instance()->GetData().faction_title_days_quit_need)
	/*
	static unsigned short FactionLevel2Capacity(unsigned char l)
	{
		static unsigned short capacity[] = {6, 50, 60, 70, 80, 90, 100, 120, 140, 160};
		if (l >= 10) return capacity[9];
		return capacity[l];
	}

	static int64_t UpgradeMoney(uchar levelname{
		static int64_t money[9] = { 0, 0, 1, 80, 400, 1000, 2000,
			3500, 9000};
		if(level <= 0 || level >= 9) return money[0] * 10000;
		return money[level] * 10000;
	}

	//°ïÅÉÉý¼¶ÐèÇó½¨Éè¶È
	static int UpgradeContri(uchar level)
	{
		static int contri[9] = { 0, 80, 2780, 16280, 48680, 111680, 219680, 476180, 1070180};
		if(level >= 9) return contri[8];
		return contri[level];
	}

	static int UpgradeClub(uchar level)
	{
		static int data[9] = { 0, 0, 0, 100, 500, 1000, 1500, 3000, 3000};
		if(level <= 0 || level >= 9) return data[0];
		return data[level];
	}
	*/

	static unsigned short UpgradeExtCapacity(uchar level)
	{
		static unsigned short capacity[10] = {0, 10, 20, 30, 40, 50, 60, 70, 80, 90};
		if(level >= 10) return capacity[9];
		return capacity[level];
	}

	static int64_t BaseRentMoney(uchar level)
	{
		static int64_t money[10] = { 0, 0, 0, 1, 30, 42, 48, 64, 80, 100};
		if(level >= 10) return money[9] * 10000;
		return money[level] * 10000;
	}

	static int FactionInstTID(char domain)
	{
		if(domain < 0 || (size_t)domain > (sizeof(faction_inst_tid) / sizeof(faction_inst_tid[0])))
			return 0;
		return faction_inst_tid[(size_t)domain];
	}

	static char GetDomain(int tid)
	{
		for(size_t i = 0; i < (sizeof(faction_inst_tid) / sizeof(faction_inst_tid[0])); i ++)
			if(faction_inst_tid[i] == tid)
				return i;
		return -1;
	}

	static unsigned short PositionMax(unsigned char l, unsigned char p)
	{
		switch (p) {
		case FP_MASTER_TRUSTED:
			if (l >= 9) return 5;
			if (l >= 7) return 4;
			if (l >= 4) return 3;
		return 2;
	
		case FP_HUFA_TRUSTED:
		case FP_ZHANGLAO_TRUSTED:
		case FP_SUBMASTER_TRUSTED:
			if (l >= 9) return 4;
			if (l >= 7) return 3;
			if (l >= 4) return 2;
			return 1;

		case FP_S_PET_TUTOR:
		case FP_S_CHEMIST:
		case FP_S_COOK:
		case FP_S_STONE_TUTOR:
		case FP_S_WOOD_TUTOR:
		case FP_S_CLOTH_TUTOR:
		case FP_S_SOCIALITE:
			return 1;
	
		case FP_PET_TUTOR:
		case FP_CHEMIST:
		case FP_COOK:
		case FP_STONE_TUTOR:
		case FP_WOOD_TUTOR:
		case FP_CLOTH_TUTOR:
		case FP_SOCIALITE:
			if (l >= 6) return 3;
			return 2;
	
		case FP_UNDERGRADUATE:
		case FP_GRADUATE:
		case FP_DOCTOR:
			if (l >= 6) return 4;
			return 2;
	
		case FP_BEAUTY:
		case FP_TALKER:
		case FP_KNOW_ALL:
		case FP_GOOD_GUY:
			if(l >= 8) return 3;
			if(l >= 5) return 2;
			return 1;
	
		case FP_ELITE:
			if(l >= 8) return 12;
			if(l >= 5) return 10;
			return 8;
	
		default:
			return 0;
		}
	}

	template<typename FactionMemberMap, typename FactionMemberMapIter,typename Sub2Cons_Map,typename Sub2Cons_MapIter>
	static int CheckNumberDS(uchar op_pos, uchar position, int flevel, int subfaction, const FactionMemberMap& members,int construction,const Sub2Cons_Map& sub2cons)
	{
		// ²¿·Ö¶ÀÁ¢Ö°Î»²»¿ÉÔÙÈÎ
		if (position >= FP_VICEMASTER1 && position <= FP_SUBMASTER) {
			for (FactionMemberMapIter it = members.begin(), ie = members.end(); it != ie; ++it) {
				if (it->second->GetPosition() == position) {
					if (position != FP_SUBMASTER) return ERROR_FACTION_UNAVAILABLE;
					// ·Ö¶æÖ÷»¹ÐèÒª¿´ËùÊô·Ö¶æ
					if (it->second->GetSubfaction() == subfaction) return ERROR_FACTION_UNAVAILABLE;
				}
			}
		}
		// ÆäËûÖ°Î»ÓÐÈËÊýÏÞÖÆ
		if (position >= FP_BEAUTY && position <= FP_SUBMASTER_TRUSTED) {
			unsigned short max = PositionMax(flevel, position);
			unsigned short n = 0;
			for (FactionMemberMapIter it = members.begin(), ie = members.end(); it != ie; ++it) {
				if (it->second->GetOwner() == op_pos && it->second->GetPosition() == position) {
					if (++n >= max) return ERROR_FACTION_UNAVAILABLE;
				}
			}
		}
		// ÈÎÃâ·Ö¶æÖ÷ÐèÒª¼ì²éµ±Ç°ÒÑ·ÖÅä·Ö¶æÇé¿öºÍµ±Ç°½¨Éè¶È
		if (position == FP_SUBMASTER) {
			Sub2Cons_MapIter sit = sub2cons.find(subfaction);
			if(sit == sub2cons.end() || sit->second > construction) return ERROR_FACTION_UNAVAILABLE;
		}
		return 0;
	}

	template<typename FactionMemberVector, typename FactionMemberVectorIter>
	static int CheckNumberDB(uchar op_pos, uchar position, int flevel, int subfaction, const FactionMemberVector& members)
	{
		// ²¿·Ö¶ÀÁ¢Ö°Î»²»¿ÉÔÙÈÎ
		if (position >= FP_VICEMASTER1 && position <= FP_SUBMASTER) {
			for (FactionMemberVectorIter it = members.begin(), ie = members.end(); it != ie; ++it) {
				if (it->position == position) {
					if (position != FP_SUBMASTER) return ERROR_FACTION_UNAVAILABLE;
					// ·Ö¶æÖ÷»¹ÐèÒª¿´ËùÊô·Ö¶æ
					if (it->subfaction == subfaction) return ERROR_FACTION_UNAVAILABLE;
				}
			}
		}
		// ÆäËûÖ°Î»ÓÐÈËÊýÏÞÖÆ
		if (position >= FP_BEAUTY && position <= FP_SUBMASTER_TRUSTED) {
			unsigned short max = PositionMax(flevel, position);
			unsigned short n = 0;
			for (FactionMemberVectorIter it = members.begin(), ie = members.end(); it != ie; ++it) {
				if (it->owner == op_pos && it->position == position) {
					if (++n >= max) return ERROR_FACTION_UNAVAILABLE;
				}
			}
		}
		return 0;
	}

	template<typename T, typename CIT>
	static int FactionAppoint(uchar op_pos, int op_sub, uchar dst_pos, uchar dst_ow, uchar dst_ti, int dst_sub,
				  uchar position, int subfaction, uchar flevel, const T& subfactions)
	{
		if (position == dst_pos && (position != FP_SUBMASTER || subfaction == dst_sub)) return ERROR_FACTION_PERMISSION;

		// ¹ÒÃû³ÉÔ±²»¿ÉÈÎÃâ
		if (dst_ti == FTI_TMP) return ERROR_FACTION_TMP_MEMBER;
		// °ïÖ÷²»¿ÉÈÎÃâ
		if (position == FP_MASTER || dst_pos == FP_MASTER) return ERROR_FACTION_PERMISSION;
		// ·òÈË²»¿ÉÈÎÃâ
		if (position == FP_MASTER_SPOUSE || position == FP_VICEMASTER_SPOUSE
		    || dst_pos == FP_MASTER_SPOUSE || dst_pos == FP_VICEMASTER_SPOUSE)
		{
			return ERROR_FACTION_PERMISSION;
		}
		// ËûÈËµÄÇ×ÐÅ²»¿ÉÈÎÃâ
		if (dst_ow && dst_ow != op_pos) return ERROR_FACTION_PERMISSION;
		// ²»´æÔÚµÄ·Ö¶æ²»ÄÜÈÎÃâ·Ö¶æÖ÷
		//if (position == FP_SUBMASTER && find(subfactions.begin(), subfactions.end(), subfaction) == subfactions.end())
		//	return ERROR_FACTION_PERMISSION;
		// ÈÎÃâ·Ö¶æÖ÷ÖÁÓÚ°ïÅÉ½¨Éè¶ÈÏà¹ØÁË£¬ºÍÍõÀÚ°æ±¾µÄ·Ö¶æ¹¦ÄÜÍêÈ«ÎÞ¹ØÁË
		if(position == FP_SUBMASTER)
		{
			//bool have = false;
			//for(CIT it = subfactions.begin(); it != subfactions.end(); ++it)
			//	if(it->id == subfaction)
			//		have = true;
			//if(!have) return ERROR_FACTION_SUBFACTION;
			if(subfaction < FSN_1 || subfaction > FSN_16) return ERROR_FACTION_PERMISSION;
		}

		// ¸±°ïÖ÷¶Ô°ïÅÉµÈ¼¶ÓÐÒªÇó
		if (position == FP_VICEMASTER2 && flevel < 5) return ERROR_FACTION_WRONG_POSITION;
		if (position == FP_VICEMASTER3 && flevel < 8) return ERROR_FACTION_WRONG_POSITION;
	
		bool ok = false;
		if (op_pos == FP_MASTER) {
			// °ïÖ÷ÔÚÈÎÃâ
			if (position != FP_HUFA_TRUSTED && position != FP_ZHANGLAO_TRUSTED && position != FP_SUBMASTER_TRUSTED)
				ok = true;
		} else if (op_pos >= FP_VICEMASTER1 && op_pos < FP_HUFA1) {
			// ¸±°ïÖ÷ÔÚÈÎÃâ
			// Ç×ÐÅ
			if ((position == FP_MASTER_TRUSTED && dst_pos == FP_NONE) || (position == FP_NONE && dst_pos == FP_MASTER_TRUSTED))
				ok = true;
			// ÈÎÃâÖ°Î»
			if ( ((position >= FP_SUBMASTER && position <= FP_DOCTOR) || position == FP_NONE) &&
			     (dst_pos == FP_NONE || dst_pos == FP_MASTER_TRUSTED || (dst_pos>=FP_SUBMASTER && dst_pos<=FP_DOCTOR)))
				ok = true;
		} else if (op_pos >= FP_HUFA1 && op_pos < FP_ZHANGLAO1) {
			// »¤·¨ÔÚÈÎÃâ
			// Ñ¡Ç×ÐÅ
			if (position == FP_HUFA_TRUSTED && dst_pos == FP_NONE) ok = true;
			// ÃâÖ°
			if (position == FP_NONE && dst_pos == FP_HUFA_TRUSTED) ok = true;
		} else if (op_pos >= FP_ZHANGLAO1 && op_pos < FP_SUBMASTER) {
			// ³¤ÀÏÔÚÈÎÃâ
			// Ñ¡Ç×ÐÅ
			if (position == FP_ZHANGLAO_TRUSTED && dst_pos == FP_NONE) ok = true;
			// ÃâÖ°
			if (position == FP_NONE && dst_pos == FP_ZHANGLAO_TRUSTED) ok = true;
		} else if (op_pos == FP_SUBMASTER) {
			// ·Ö¶æÖ÷ÔÚÈÎÃâ
			// Ñ¡Ç×ÐÅ
			if (position == FP_SUBMASTER_TRUSTED && dst_pos == FP_NONE && dst_sub == op_sub) ok = true;
			// ÃâÖ°
			if (position == FP_NONE && dst_pos == FP_SUBMASTER_TRUSTED) ok = true;
		}
		if (!ok) return ERROR_FACTION_PERMISSION;
		return 0;
	}

	template<typename RoleInfo>
	static int FactionInfoCheck(uchar position, RoleInfo* info, int level = 1, char gender = -1)
	{
		if(info)
		{
			level = info->level;
			gender = info->gender;
		}
		//ÆäËûÏÞÖÆ
		switch(position) {
			case FP_BEAUTY:
				if(gender != 0)
					return ERROR_MARRY_GENDER;
				break;
	
			case FP_UNDERGRADUATE:
				if(level >= 40)
					return ERROR_GREATER_LEVEL;
				break;
	
			case FP_GRADUATE:
				if(level < 40)
					return ERROR_LESS_LEVEL;
				if(level >= 60)
					return ERROR_GREATER_LEVEL;
				break;
	
			case FP_DOCTOR:
				if(level < 60)
					return ERROR_LESS_LEVEL;
				break;
	
			default:
				break;
		}
		return 0;
	}

	template<typename GFaction>
	static int FindOwnCity(const GFaction &fa,int cityid)
	{
		for(int i=0;i<(int)fa.owncitys.size();i++)
		{
			if(fa.owncitys[i].cityid == cityid) return i;
		}
		return -1;
	}

	template<typename GFaction>
	static bool DelOwnCity(GFaction &fa,int cityid,bool delmain = false)
	{
		for(int i=0;i<(int)fa.owncitys.size();i++)
		{
			if(fa.owncitys[i].cityid == cityid)
			{
				if((i == 0 && delmain) || i != 0)
				{
					fa.owncitys.erase(fa.owncitys.begin() + i);
					return true;
				}
				return false;
			}
		}
		return false;
	}

	template<typename GFaction,typename GFactionOwnCity>
	static bool ExchangeCityPos(GFaction &fa,int cityid1,int cityid2)
	{
		int pos1 = FindOwnCity<GFaction>(fa,cityid1);
		int pos2 = FindOwnCity<GFaction>(fa,cityid2);

		if(pos1 == pos2 || pos1 < 0 || pos2 < 0) return -1;
		GFactionOwnCity tmp;
		tmp = fa.owncitys[pos1];
		fa.owncitys[pos1] = fa.owncitys[pos2];
		fa.owncitys[pos2] = tmp;
		return 0;
	}

};

class FactionCityHelper
{
public:
	template<typename GFactionCity>
	static int FindSubFaction(const GFactionCity &fc,unsigned int fid)
	{
		for(int i=0;i<(int)fc.subfactions.size();i++)
		{
			if(fc.subfactions[i].fid == fid) return i;
		}
		return -1;
	}

	template<typename GFactionCity>
	static bool DelSubFaction(GFactionCity &fc,unsigned int fid)
	{
		for(int i=0;i<(int)fc.subfactions.size();i++)
		{
			if(fc.subfactions[i].fid == fid)
			{
				fc.subfactions.erase(fc.subfactions.begin() + i);
				return true;
			}
		}
		return false;
	}

	template<typename GFactionCity>
	static int FindMainFaction(const GFactionCity &fc,unsigned int fid)
	{
		for(int i=0;i<(int)fc.mainfactions.size();i++)
		{
			if(fc.mainfactions[i].fid == fid) return i;
		}
		return -1;
	}

	template<typename GFactionCity>
	static bool DelMainFaction(GFactionCity &fc,unsigned int fid)
	{
		for(int i=0;i<(int)fc.mainfactions.size();i++)
		{
			if(fc.mainfactions[i].fid == fid)
			{
				fc.mainfactions.erase(fc.mainfactions.begin() + i);
				return true;
			}
		}
		return false;
	}

	template<typename GFactionCity>
	static int FindFaction(const GFactionCity &fc,unsigned int fid,bool &issub)
	{
		for(int i=0;i<(int)fc.mainfactions.size();i++)
		{
			if(fc.mainfactions[i].fid == fid) 
			{
				issub = false;
				return i;
			}
		}
		for(int i=0;i<(int)fc.subfactions.size();i++)
		{
			if(fc.subfactions[i].fid == fid) 
			{
				issub = true;
				return i;
			}
		}
		return -1;
	}

	template<typename GFactionCity>
	static bool DelAuctionCity(GFactionCity &fc,int cityid)
	{
		for(int i=0;i<(int)fc.auccitys.size();i++)
		{
			if(fc.auccitys[i] == cityid)
			{
				fc.auccitys.erase(fc.auccitys.begin() + i);
				return true;
			}
		}
		return false;
	}

	template<typename GFactionCity,typename GSubFaction,typename GMainFaction>
	static bool CheckWeightValid(GFactionCity &fc)
	{
		int total_weight = 0;
		for(int i=0;i<(int)fc.subfactions.size();i++)
		{
			const GSubFaction& tmp = fc.subfactions[i];
			if(tmp.fid != fc.kingid && tmp.weightrate > 20) return false;
			if(tmp.fid == fc.kingid && (tmp.weightrate < 1 || tmp.weightrate > 40)) return false;
			total_weight += fc.subfactions[i].weightrate;
			if(total_weight < 0 || total_weight > 100) return false;
		}
		for(int i=0;i<(int)fc.mainfactions.size();i++)
		{
			const GMainFaction& tmp = fc.mainfactions[i];
			if(tmp.fid != fc.kingid && tmp.weightrate > 20) return false;
			if(tmp.fid == fc.kingid && (tmp.weightrate < 1 || tmp.weightrate > 40)) return false;
			total_weight += fc.mainfactions[i].weightrate;
			if(total_weight < 0 || total_weight > 100) return false;
		}
		return true;
	}

	template<typename GFactionCity,typename GSubFaction,typename GMainFaction>
	static int GetTotalWeight(GFactionCity &fc)
	{
		int total_weight = 0;
		for(int i=0;i<(int)fc.subfactions.size();i++)
		{
			total_weight += fc.subfactions[i].weightrate;
		}
		for(int i=0;i<(int)fc.mainfactions.size();i++)
		{
			total_weight += fc.mainfactions[i].weightrate;
		}
		return total_weight;
	}

	template<typename GFactionCity,typename GSubFaction,typename GMainFaction>
	static bool LocationFaction(GFactionCity &fc,unsigned int fid,int &pos,bool &issub)
	{
		if(fid == 0) return false;
		for(int i=0;i<(int)fc.subfactions.size();i++)
		{
			if(fc.subfactions[i].fid != fid) continue;
			issub = true;
			pos = i;
			return true;
		}
		for(int i=0;i<(int)fc.mainfactions.size();i++)
		{
			if(fc.mainfactions[i].fid != fid) continue;
			issub = false;
			pos = i;
			return true;
		}
		return false;
	}

	template<typename GFactionCity,typename GSubFaction,typename GMainFaction>
	static bool SetFactionWeight(GFactionCity &fc,char issub,int pos,int weight)
	{
		if(pos < 0) return false;
		if(issub)
		{
			if(pos >= (int)fc.subfactions.size()) return false;
			GSubFaction& tmp = fc.subfactions[pos];
			if(tmp.fid != fc.kingid && (weight < 1 || weight > 20)) return false;
			if(tmp.fid == fc.kingid && (weight < 1 || weight > 40)) return false;
			tmp.weightrate = weight;
		}
		else
		{
			if(pos >= (int)fc.mainfactions.size()) return false;
			GMainFaction& tmp = fc.mainfactions[pos];
			if(tmp.fid != fc.kingid && (weight < 1 || weight > 20)) return false;
			if(tmp.fid == fc.kingid && (weight < 1 || weight > 40)) return false;
			tmp.weightrate = weight;
		}
		return true;
	}
	template<typename GFactionCity,typename GSubFaction,typename GMainFaction>
	static int GetFactionWeight(GFactionCity &fc,char issub,int pos)
	{
		if(pos < 0) return -1;
		if(issub)
		{
			if(pos >= (int)fc.subfactions.size()) return -1;
			return fc.subfactions[pos].weightrate;
		}
		else
		{
			if(pos >= (int)fc.mainfactions.size()) return -1;
			return fc.mainfactions[pos].weightrate;
		}
	}
};

enum WAITDEL_TYPE
{
	TYPE_ROLE        = 1,
	TYPE_FACTION     = 2,
	TYPE_FAMILY      = 3,
};

enum DB_KEY
{
	KEY_CITY = 0,
	KEY_NATION = 1,
	KEY_BATTLE = 2,
};

enum CHALLENGE_ALGO     
{               
	ALGO_NONE 		= -1,
	ALGO_MD5 		= 0,
	ALGO_PLAINTEXT	= 1, 
	ALGO_TOKEN		= 2, 
	ALGO_COMMON_SDK	= 3,	//Íæ¼ÒÐÅÏ¢À´×ÔÓÚ¡°Í¨ÓÃSDK¡±
	ALGO_TX_QQ		= 4,	//Íæ¼ÒÐÅÏ¢À´×ÔÓÚ¡°ÊÖQ¡±
	ALGO_TX_WEIXIN	= 5,	//Íæ¼ÒÐÅÏ¢À´×ÔÓÚ¡°Î¢ÐÅ¡±
	ALGO_TX_GUEST	= 6,	//Íæ¼ÒÐÅÏ¢À´×ÔÓÚ¡°txÓÎ¿Í¡±
	ALGO_TW			= 7,	//Íæ¼ÒÐÅÏ¢À´×ÔÓÚÌ¨Íå
	ALGO_VIETNAM	= 8,	//Íæ¼ÒÐÅÏ¢À´×ÔÓÚÔ½ÄÏ
	ALGO_KOREA      = 9,    //Íæ¼ÒÐÅÏ¢À´×ÔÓÚº«¹ú
	ALGO_WANDA      = 10,   //À´×ÔÓÚÍò´ï
};       

enum SIEGE_RELATIVE
{
	_MST_SIEGE = 5,
	_SIEGE_END_BONUS = 0,

	OS_INIT 	= 0,
	OS_CLOSE 	= 1,
	OS_OPEN 	= 2,
};

enum USER_STATUS
{
	STATUS_CASHINVISIBLE   =   0x01,
};

enum 
{
	MASK_SAVEROLE_FRIENDS   = 0x01,
	MASK_SAVEROLE_FACEBOOK  = 0x02,
	MASK_SAVEROLE_COOLDOWN	= 0x04,
	MASK_SAVEROLE_REPUTATION= 0x08,
};
enum 
{ 
	SECT_QUIT_EXPEL, 
	SECT_QUIT_LEAVE, 
	SECT_QUIT_GRADUATE, 
};
enum 
{
	AUTHDATA_UPTODATE,
	AUTHDATA_CACHEHIT,
	AUTHDATA_CACHEMISS,
};

enum
{
	COOLDOWN_ID_RESERVED = 0,
	COOLDOWN_ID_STRANGER_MAIL = 1,
	COOLDOWN_ID_PROPOSE = 2, // Çó»é
	COOLDOWN_ID_RENEGE = 3,  // »Ú»é
	COOLDOWN_ID_DIVORCE = 4, // Àë»é
	COOLDOWN_ID_FAMILY = 5,
	COOLDOWN_ID_FRIEND_BUFF_SEND1 = 6, // ÏàÁÚÁ½´Îfriend_buff·¢ËÍÀäÈ´
	COOLDOWN_ID_FRIEND_BUFF_SEND2 = 7, // Ã¿Ììfriend_buff·¢ËÍ´ÎÊýÉÏÏÞÀäÈ´
	COOLDOWN_ID_FRIEND_BUFF_RECV = 8, // ÏàÁÚÁ½´Îfriend_buff½ÓÊÜÀäÈ´
	COOLDOWN_ID_SECT_QUIT = 9, // ÅÑÊ¦ÀäÈ´
	COOLDOWN_ID_SECT_EXPEL = 10, // ¿ª³ýÍ½µÜÀäÈ´
	COOLDOWN_ID_HOME_AMBUSH = 11, // ¼ÒÔ°Âñ·üÀäÈ´
	COOLDOWN_ID_HOME_STEALCAUGHT = 12, // ¼ÒÔ°ÍµÇÔ±»×¥
	COOLDOWN_ID_FACTION_QUIT = 13, // ÍË³ö°ïÅÉ
	COOLDOWN_ID_FACTION_ACTIVITY = 14, // °ïÅÉ±¨µÀ¼Ó»îÔ¾¶È
	COOLDOWN_ID_FACTION_EXPEL = 15, // °ïÅÉÌßÈË
	COOLDOWN_ID_FACTION_UPDATEFACTIONINFO = 16, // °ïÅÉ³ÉÔ±¸üÐÂ°ïÅÉÐÅÏ¢
	COOLDOWN_ID_FACTION_APPLYJOININ = 17, // Íæ¼ÒÉêÇë¼ÓÈë°ïÅÉ
	COOLDOWN_ID_AUCTION_INFO = 18,		// Íæ¼Ò»ñÈ¡ÅÄÂôÐÅÏ¢
	COOLDOWN_ID_MARRY = 19, // ½á»éÉêÇë·¢ÆðºóÒ»¶¨Ê±¼äÄÚ²»ÄÜÔÙ´Î·¢Æð½á»éÉêÇë
	COOLDOWN_ID_ADD_APPLY = 20, //°ï»áÉêÇë
	COOLDOWN_ID_CANCLE_APPLY = 21, //°ï»áÈ¡ÏûÉêÇë
	COOLDOWN_ID_CHECK_TX_CASH = 22, //²éÑ¯txÔª±¦Óà¶î
	COOLDOWN_ID_LEAVE_BANGHUI = 23, //Àë¿ª°ï»áµÄCD
	COOLDOWN_ID_APPLY_ADD_CASH = 24, //
};
enum
{
	COOLDOWN_RANGE_STRANGER_MAIL = 24 * 3600,
	COOLDOWN_RANGE_PROPOSE = 3 * 60,
	COOLDOWN_RANGE_RENEGE = 24 * 3600,
	COOLDOWN_RANGE_DIVORCE = 24 * 3600,
	COOLDOWN_RANGE_FAMILY = 24 * 3600,
	COOLDOWN_RANGE_FRIEND_BUFF_SEND1 = 60,
	COOLDOWN_RANGE_FRIEND_BUFF_SEND2 = 24 * 3600,
	COOLDOWN_RANGE_FRIEND_BUFF_RECV = 60,
	COOLDOWN_RANGE_SECT = 3 * 3600,
	COOLDOWN_RANGE_HOME_AMBUSH = 20 * 60,
	COOLDOWN_RANGE_HOME_STEALCAUGHT = 30 * 60, 
	COOLDOWN_RANGE_FACTION_QUIT = 3 * 24 * 3600,
	COOLDOWN_RANGE_FACTION_ACTIVITY = 24 * 3600,
	COOLDOWN_RANGE_FACTION_EXPEL = 24 * 3600,
	COOLDOWN_RANGE_FACTION_UPDATEFACTIONINFO = 3,
	COOLDOWN_RANGE_FACTION_APPLYJOININ = 10,
	COOLDOWN_RANGE_AUCTION_INFO = 3,
	COOLDOWN_RANGE_MARRY = 24 * 3600,
	COOLDOWN_RANGE_ADD_APPLY = 1, 
	COOLDOWN_RANGE_CANCLE_APPLY = 1,
	COOLDOWN_RANGE_CHECK_TX_CASH = 10,
	COOLDOWN_RANGE_BANGHUI_SIGN = 2 * 3600,
};
enum
{
	COOLDOWN_COUNT_STRANGER_MAIL = 10, /* 10 mail per day */
	COOLDOWN_COUNT_FRIEND_BUFF_SEND2_MAX = 100, /* ×î¶àÃ¿Ìì¿ÉÒÔ·¢100¸öfriend_buff */
	COOLDOWN_COUNT_FACTION_EXPEL = 5, /* ×î¶àÃ¿Ìì¿ÉÒÔÌß5¸öÈË */
	COOLDOWN_COUNT_AUCTION_INFO  = 2, /* ×î¶à 3s 2´Î */
};

enum {
	MARRIAGE_ST_SINGLE = 0, // µ¥Éí
	MARRIAGE_ST_ENGAGED = 1, // ÒÑ¶©»é
	MARRIAGE_ST_MARRIED = 2, // ÒÑ½á»é
};
enum
{
	MARRIAGE_OP_PROPOSE = 0, // ¶©»é
	MARRIAGE_OP_RENEGE = 1, // »Ù»é
	MARRIAGE_OP_MARRY = 2, // ½á»é
	MARRIAGE_OP_DIVORCE = 3, // Àë»é
};

enum VOTE_TYPE {
	VOTE_ID_MARRY = 0, // Îª½á»éÍ¶Æ±
	VOTE_ID_FAMILY_CREATE = 1, // Îª½¨Á¢½áÒåÍ¶Æ±
	VOTE_ID_FAMILY_ADD = 2, // Îª½áÒåÌí¼Ó³ÉÔ±Í¶Æ±
	VOTE_ID_FAMILY_CHANGE_NAME = 3, // Îª½áÒå¸ÄÃûÍ¶Æ±
	VOTE_ID_FAMILY_EXPEL = 4, // Îª¿ª³ýÄ³¸ö½áÒå³ÉÔ±Í¶Æ±
	VOTE_ID_FAMILY_CALL = 5, // ÊÇ·ñÍ¬Òâ½áÒåÕÙ¼¯
	VOTE_ID_SOS = 6, // ÊÇ·ñÍ¬Òâºô¾È
	VOTE_ID_FACTION_MERGE = 7,// °ïÅÉºÏ²¢Í¶Æ±
	VOTE_ID_FACTION_SCORE = 8,// °ïÅÉ¹ÜÀíÈËÔ±ÆÀ·ÖÍ¶Æ±
	VOTE_ID_FACTION_MERGED = 9,// °ïÅÉ±»ºÏ²¢Í¶Æ±
	VOTE_ID_FACTION_REBEL = 10,// °ïÅÉ´ÛÈ¨Í¶Æ±
	VOTE_ID_FACTION_TRANS = 11,// °ïÅÉºÏ²¢Ñ¡ÈË
};

enum {
	FAMILY_SAVE_OP_CREATE = 0, // ½¨Á¢½áÒå
	FAMILY_SAVE_OP_ADD = 1, // Ìí¼Ó½áÒå³ÉÔ±
	FAMILY_SAVE_OP_CHANGE_NAME = 2, // ÐÞ¸Ä½áÒåÃû
	FAMILY_SAVE_OP_EXPEL = 3, // ¿ª³ý½áÒå³ÉÔ±
	FAMILY_SAVE_OP_QUIT = 4, // ÍË³ö½áÒå
};

enum {
	FAMILY_MEMBER_MAX		= 6,
	FAMILY_MEMBER_LEVEL_MIN		= 30,
	FAMILY_MEMBER_AMITY_MIN		= 3000,
	FAMILY_LEAVE_MESSAGE_MAX	= 100,	// ½áÒåÁôÑÔ×î³¤

	MARRIAGE_VOTE_DURATION = 180,	// ½á»éÍ¶Æ±ÆÚ
	FAMILY_VOTE_DURATION = 300,	// ½áÒåÍ¶Æ±ÆÚ
	FAMILY_CALL_DURATION = 60,	// ½áÒåÕÙ¼¯
	SOS_DURATION = 180,		// ºô¾È³¬Ê±
	WEDDING_DURATION = 3600,	//Ò»³¡»éÀñµÄÃëÊý£¬Ò»Ð¡Ê±

	FAMILY_VOTE_MAX = 10,	// ×î¶àÄÜ±£´æµÄ½áÒåÄÚÍ¶Æ±Ïî£¬°üº¬ÕýÔÚÍ¶Æ±ÖÐµÄÒÑ¾­½áÊøµÄ
	FAMILY_VOTE_VOTING_MAX = 3,	// ×î¶à¿ÉÍ¬Ê±½øÐÐµÄ½áÒåÄÚÍ¶Æ±
	FAMILY_VOTE_TIME = 7 * 24 * 3600,	// ½áÒåÄÚÍ¶Æ±µÄÓÐÐ§ÆÚ
	MAX_ALLIANCEWAR_APPLY_FAMILY	= 50,	// ²Î¼ÓÃËÖ÷Õ½½áÒåÉÏÏÞ
};

enum {
	FRIEND_ADD_AMITY_MAX = 100,	// ¼ÓºÃÓÑÊ±µÄ×î´ó³õÊ¼ºÃ¸Ð¶È
	FRIEND_LIST_CONTACTS_MAX = 10,	// ÁÐ³öËûÈËºÃÓÑÊ±µÄ×î¶àÊýÁ¿
};

// IPCTxnÏà¹Ø
enum {
	IPCTXN_REASON_MAIL_PACK        = 0,
	IPCTXN_REASON_MARRIAGE_PROPOSE = 1, 
	IPCTXN_REASON_MARRIAGE_MARRY   = 2, 
	IPCTXN_REASON_STOCK_COMMISSION = 3,
	IPCTXN_REASON_HOME_FARMSOW     = 4, 
	IPCTXN_REASON_HOME_BREEDCUB    = 5, 
	IPCTXN_REASON_HOME_FEED        = 6,
	IPCTXN_REASON_FACTION_CREATE   = 7, 
	IPCTXN_REASON_FACTION_UPGRADE  = 8, 
	IPCTXN_REASON_MALL_PRESENT     = 9, 
	IPCTXN_REASON_FACTION_EXTROOM  = 10,
	IPCTXN_REASON_ALLIANCEWAR_APPLY= 11,
	IPCTXN_REASON_ALLIANCER_AWARD  = 12,
	IPCTXN_REASON_ADD_MAFIA_MONEY  = 13,
	IPCTXN_REASON_FACTION_BASE_ACTIVE = 14,
	IPCTXN_REASON_HOME_BUY         = 15,
	IPCTXN_REASON_HOME_TRANSFER    = 16,
	IPCTXN_REASON_HOME_SERVANT     = 17,
	IPCTXN_REASON_FACTION_BASE_INIT	= 18, 
	IPCTXN_REASON_FACTION_MAIN_OPER	= 19, 
	IPCTXN_REASON_START_ROB_ESCORT	= 20, 
	IPCTXN_REASON_JUEWEI_TASK_PUBLISH	= 21,
	IPCTXN_REASON_JUEWEI_TASK_SETTLE	= 22,
	IPCTXN_REASON_JUEWEI_TASK_DELIVER	= 23,
	IPCTXN_REASON_AUCTION			= 24,
	IPCTXN_REASON_MARRIAGE_DIVORCE		= 25,
	IPCTXN_REASON_TIZI		= 26,
	IPCTXN_REASON_TIGUAN		= 27,
	IPCTXN_REASON_PARADING          = 28,
	IPCTXN_REASON_BANGHUI           = 29,
	IPCTXN_REASON_INVALID           = 255,
};

enum ITEM_LOCATION//ÎïÆ·Î»ÖÃ
{
	IL_INVALID = 0xFF,

	IL_EQUIPMENT = 0,	//0×°±¸
	IL_BACKPACK,		//1±³°ü
	IL_TASK_ITEM,		//2ÈÎÎñÎïÆ·°ü
	IL_MATERIAL,		//3²ÄÁÏÎïÆ·°ü		//ÒÑ¾­×÷·Ï£¬²»´æÅÌÁË
	IL_DEPOSITORY,		//4²Ö¿â          
	IL_MAFIA_STORE,         //5°ïÅÉ²Ö¿â     ******
	IL_RECYCLE_BIN,		//6»ØÊÕÕ¾       
	IL_TEMP_BACK,		//7ÁÙÊ±°ü¹ü£¬¹ý¹ØÊ±»ñµÃµÄ½±Àø»áÏÈ·ÅÔÚÕâÀï£¬ÔÚ¹Øµ×Éý½×
	IL_TITLE_PACK,		//8³ÆºÅ°ü¹üÀ¸

/*	
	ÁÙÊ±°ü¹ü
	ÃûÈË×°±¸1~8
*/
	IL_COUNT,

	IL_HERO_EQUIP_START = 50,	//ÃûÈËµÈÐ§°ü¹üÀ¸µÄÆðÊ¼£¬Õâ¸öÊÇÐéÄâ°ü¹üÀ¸£¬²»ÊÇÕæÊµµÄ
};


//
// ¼ÒÔ°ÏµÍ³Ïà¹Ø
//
#define HOME_MANAGER_UPDATE_INTERVAL                     10 // ¼ÒÔ°¹ÜÀíÆ÷¸üÐÂÖÜÆÚ£¬µ¥Î»£ºÃë
#define MAX_HOME_LEVEL                                   10 // ¼ÒÔ°×î´óµÈ¼¶
#define MAX_HOME_POINTS                          2000000000 // ¼ÒÔ°»ý·Ö×î´óÖµ
#define INIT_HOME_STOREHOUSE_CAPACITY                    30 // ¼ÒÔ°²Ö¿âµÄ³õÊ¼À¸Î»Êý
#define DEFAULT_HOME_STOREHOUSE_PILE_LIMIT             9999 // ¼ÒÔ°²Ö¿âµÄÄ¬ÈÏÎïÆ·¶ÑµþÊýÉÏÏÞ
#define MAX_HOME_LOG_COUNT                               50 // ¼ÒÔ°²ËÔ°ÈÕÖ¾ÌõÊý×î´óÖµ
#define MAX_HOME_FARM_AMBUSH_COUNT                        5 // ¼ÒÔ°²ËÔ°Àï×î¶à¿ÉÂñ·üµÄÍæ¼ÒÊý
// Ëæ»ú×´Ì¬Ïà¹Ø
// Ëæ»úÖÜÆÚ»á¸ù¾ÝÎïÀíÊ±¼ä½øÐÐµ÷Õû£¬±ÈÈçÁè³¿¿ÉÄÜËæ»ú¼ä¸ô»áÉÙ£¬¶øÉÏÏßÃÜ¼¯Ê±¶Î»á¼Ó¿ìÆµÂÊ
#define HOME_RAND_PERIOD_NORMAL                      (2*60) // Õý³£Ëæ»úÖÜÆÚ£¬µ¥Î»£ºÃë
#define HOME_RAND_PERIOD_SLOWDOWN                    (3*60) // µÍËÙËæ»úÖÜÆÚ£¬µ¥Î»£ºÃë
#define HOME_RAND_SLOWDOWN_STARTHOUR                      0 // Ëæ»úÆµÂÊ½µµÍ¿ªÊ¼Ê±¼ä£¬µ¥Î»£ºÊ±£¨24Ð¡Ê±ÖÆ£©£¬0-23
#define HOME_RAND_SLOWDOWN_ENDHOUR                        6 // Ëæ»úÆµÂÊ½µµÍ½áÊøÊ±¼ä£¬µ¥Î»£ºÊ±£¨24Ð¡Ê±ÖÆ£©£¬0-23
#define HOME_RAND_STATE_DURATION                     (2*60) // Òì³£×´Ì¬³ÖÐøÊ±¼ä£¬³¬Ê±ºóÒì³£×´Ì¬×Ô¶¯½â³ý
// ²ËÔ°µÈ¼¶Ïà¹Ø
#define MAX_FARM_LEVEL                                   10 // ²ËÔ°×î¸ßµÈ¼¶
#define INIT_FARM_LEVEL                                   0 // ²ËÔ°³õÊ¼µÈ¼¶
#define INIT_FARM_PLOT_COUNT                              4 // ²ËÔ°µÄ³õÊ¼µØ¿éÊý
// ²ËÔ°Ö²Îï½¡¿µÖ¸ÊýÏà¹Ø
#define DEFAULT_FARMCROP_HEALTH                         100 // Ö²Îï½¡¿µÖ¸ÊýÄ¬ÈÏÖµ
#define MAX_FARMCROP_HEALTH                             200 // Ö²Îï½¡¿µÖ¸Êý×î´óÖµ
#define MIN_FARMCROP_HEALTH                               0 // Ö²Îï½¡¿µÖ¸Êý×îÐ¡Öµ£¬´ïµ½´ËÖµµÄÖ²Îï¼´ËÀÍö
// ²ËÔ°×÷Îï×´Ì¬Ïà¹Ø
#define FARMCROP_ABNORMAL_REMOVAL_AWARD_HEALTH           10 // ÔÚÏÞ¶¨Ê±¼äÄÚ½â³ý×÷ÎïÒì³£×´Ì¬Ëù½±ÀøµÄÖ²Îï½¡¿µÖ¸Êý
#define FARMCROP_ABNORMAL_REMOVAL_AWARD_PRODUCE_POINT_MIN 1 // ½â³ý×÷ÎïÒì³£×´Ì¬Ëù½±ÀøµÄÉú²úµã×îÐ¡Öµ
#define FARMCROP_ABNORMAL_REMOVAL_AWARD_PRODUCE_POINT_MAX 5 // ½â³ý×÷ÎïÒì³£×´Ì¬Ëù½±ÀøµÄÉú²úµã×î´óÖµ
// ¼ÒÔ°Âñ·üÏà¹Ø
#define HOME_AMBUSH_DURATION                         (5*60) // Âñ·ü³ÖÐøÊ±¼ä
// ¼ÒÔ°ÍµÇÔÏà¹Ø
#define MAX_HOME_FARM_PLOT_STEAL_COUNT_PER_PLAYER         2 // Ã¿ÈËÃ¿µØ¿éÍµÇÔµÄ×î´óÊýÁ¿
#define MIN_HOME_FARM_STOLEN_COMPENSATE_POINTS            1 // ²ËÔ°±»Íµ²¹³¥µÄ¼ÒÔ°»ý·Ö×îÐ¡Öµ
#define MAX_HOME_FARM_STOLEN_COMPENSATE_POINTS            5 // ²ËÔ°±»Íµ²¹³¥µÄ¼ÒÔ°»ý·Ö×î´óÖµ
// ÑøÖ³³¡µÈ¼¶Ïà¹Ø
#define MAX_BREED_FIELD_LEVEL                            10 // ÑøÖ³³¡×î¸ßµÈ¼¶
#define INIT_BREED_FIELD_LEVEL                            0 // ÑøÖ³³¡³õÊ¼µÈ¼¶
#define INIT_BREED_FIELD_ACTIVE_WIDTH                     4 // ÑøÖ³³¡µØ¿é³õÊ¼¿ª·Å×´Ì¬(4x6)
#define INIT_BREED_FIELD_ACTIVE_LENGTH                    6 // ÑøÖ³³¡µØ¿é³õÊ¼¿ª·Å×´Ì¬(4x6)
// ÑøÖ³È¦Ïà¹Ø
#define BREED_FENCE_TYPE_COUNT                            8 // ÑøÖ³È¦ÐÎ×´Êý
#define MAX_PLOT_COUNT_PER_BREED_FENCE                    5 // Ò»¸öÑøÖ³È¦×î¶à¿ÉÄÜÕ¼ÓÃµÄµØ¿éÊý
// Æí¸£Ïà¹Ø
#define BREED_BLESS_PERIOD                     (60*60*24*2) // Æí¸£»ú»á»ñÈ¡ÖÜÆÚ
#define BLESS_FENCE_TYPE_COUNT                           12 // Æí¸£È¦ÐÎ×´Êý
#define MAX_PLOT_COUNT_PER_BLESS_FENCE                    8 // Ò»¸öÆí¸£È¦×î¶à¿ÉÄÜÕ¼ÓÃµÄµØ¿éÊý
#define INIT_MAX_BREED_BLESS_CHANCES                      3 // ³õÊ¼×î´óÀÛ»ýÆí¸£»ú»á´ÎÊý
#define INIT_BREED_BLESS_EFFECT                        1.50 // ³õÊ¼Æí¸£ÔöÒæÐ§¹û
// ÑøÖ³³¡¶¯Îï½¡¿µÖ¸ÊýÏà¹Ø
#define BREED_ANIMAL_HEALTH_DEFAULT                     100 // Ö²Îï½¡¿µÖ¸ÊýÄ¬ÈÏÖµ
#define BREED_ANIMAL_HEALTH_MAX                         200 // Ö²Îï½¡¿µÖ¸Êý×î´óÖµ
// ÑøÖ³³¡¶¯ÎïÉú³¤ÖµÏà¹Ø
#define BREED_ANIMAL_INC_GROW_POINT_PER_MINUTE            1 // ±¥Ê³×´Ì¬Ã¿³ÖÐøÒ»·ÖÖÓÔö³¤µÄÉú³¤Öµ
#define BREED_ANIMAL_SYMBIOSE_EFFECT                    2.0 // ¹²ÉúÔöÒæÐ§¹û
#define BREED_ANIMAL_DEC_GROW_POINT_PER_MINUTE            1 // ¼¢¶ö×´Ì¬Ã¿³ÖÐøÒ»·ÖÖÓ¼õÉÙµÄÉú³¤Öµ
// ÑøÖ³³¡¶¯Îï×´Ì¬Ïà¹Ø
#define BREED_ABNORMAL_REMOVAL_AWARD_HEALTH              10 // ÔÚÏÞ¶¨Ê±¼äÄÚ½â³ýÒì³£×´Ì¬Ëù½±ÀøµÄ½¡¿µÖ¸Êý
#define BREED_ABNORMAL_REMOVAL_AWARD_PRODUCE_POINT_MIN    1 // ½â³ýÒì³£×´Ì¬Ëù½±ÀøµÄÉú²úµã×îÐ¡Öµ
#define BREED_ABNORMAL_REMOVAL_AWARD_PRODUCE_POINT_MAX    5 // ½â³ýÒì³£×´Ì¬Ëù½±ÀøµÄÉú²úµã×î´óÖµ

enum HOME_COMPONENT_TYPE {
	HOME_COMPONENT_NONE = 0, 
	HOME_COMPONENT_FARM = 1,        // ²ËÔ°
	HOME_COMPONENT_BREED_FIELD = 2, // ÑøÖ³³¡
};

enum HOME_COMPONENT_MASK {
	HOME_COMPONENT_MASK_FARM        = 0x01, // ²ËÔ°
	HOME_COMPONENT_MASK_BREED_FIELD = 0x02, // ÑøÖ³³¡
};

enum HOME_COMPONENT_STATE {
	HOME_COMPONENT_STATE_OPENED = 0, 
	HOME_COMPONENT_STATE_CLOSED = 1,
};


enum FARMPLOT_TYPE {
	FARMPLOT_TYPE_ORDINARY = 0, // ÆÕÍ¨ÍÁµØ
};

enum FARMPLOT_STATE {
	FARMPLOT_STATE_INCULT         = 0, // Î´¿ª¿Ñ£¬ÓÉÓÚ¼ÒÔ°µÈ¼¶ÏÞÖÆ¶øÎ´¿ªÆôµÄµØ¿é
	FARMPLOT_STATE_NORMAL         = 1, // Õý³£

	FARMPLOT_STATE_MAX,
};

enum FARMCROP_STATE {
	FARMCROP_STATE_INVALID        = 0, // ·Ç·¨×´Ì¬
	FARMCROP_STATE_NORMAL         = 1, // Õý³£

	FARMCROP_STATE_ABNORMAL_BEGIN = 2,
	// {Òì³£×´Ì¬
	FARMCROP_STATE_DRY            = 2, // ¸Éºµ
	FARMCROP_STATE_FLOODING       = 3, // Ë®ÑÍ
	FARMCROP_STATE_POOR           = 4, // Æ¶ñ¤
	FARMCROP_STATE_WEED           = 5, // ÔÓ²Ý
	FARMCROP_STATE_PEST           = 6, // º¦³æ
	// Òì³£×´Ì¬} 
	FARMCROP_STATE_ABNORMAL_END,

	FARMCROP_STATE_GROWN          = 7, // ³¤³ÉµÄ
	FARMCROP_STATE_DEAD           = 8, // ¿ÝÎ®µÄ

	FARMCROP_STATE_MAX,
};

enum FARM_ACTION_TYPE {
	FARM_ACTION_PLOW          =  1, // ³úµØ£¬¿ÉÇå³ýµØ¿éÉÏµÄÖ²Îï£¬Ò²¿ÉÓÃÓÚ½â³ý¿ÝÄ¾×´Ì¬
	FARM_ACTION_SOW           =  2, // ²¥ÖÖ
	FARM_ACTION_WATER         =  3, // ½½Ë®£¬¿É½â³ý¸Éºµ×´Ì¬
	FARM_ACTION_DRAIN         =  4, // ÅÅË®£¬¿É½â³ýË®ÑÍ×´Ì¬
	FARM_ACTION_FERTILIZE     =  5, // Ê©·Ê£¬¿É½â³ýÆ¶ñ¤×´Ì¬
	FARM_ACTION_WEED          =  6, // °Î²Ý£¬¿É½â³ýÔÓ²Ý×´Ì¬
	FARM_ACTION_CLEARPEST     =  7, // ÖÎ³æ£¬¿É½â³ýÉú³æ×´Ì¬
	FARM_ACTION_HARVEST       =  8, // ²ÉÕª£¬°Ñ¹ûÊµ·Åµ½²Ö¿â£¬Ö²Îï±ä³É¿ÝÄ¾
	FARM_ACTION_AMBUSH        =  9, // Âñ·ü£¬¿É×¥»ñÍµÇÔÕß
	FARM_ACTION_AMBUSH_CANCEL = 10, // È¡ÏûÂñ·ü
	FARM_ACTION_STEAL         = 11, // ÍµÇÔ£¬¿ÉÄÜÊ§°Ü£¬ÉõÖÁ±»×¥

	FARM_ACTION_STEALCAUGHT   = 12, // ÍµÇÔ±»×¥
	FARM_ACTION_CATCH_THIEF   = 13, // ×¥×¡Ð¡Íµ
};

enum HOME_DATA_MASK {
	HOME_DATA_MASK_HOME_BASIC      = 0x0001,
	HOME_DATA_MASK_HOME_OWNER      = 0x0002,
	HOME_DATA_MASK_HOME_STOREHOUSE = 0x0004,
	HOME_DATA_MASK_HOME_LOG        = 0x0008,

	HOME_DATA_MASK_FARM_BASIC      = 0x0010,
	HOME_DATA_MASK_FARM_PLOTS      = 0x0020, 
	HOME_DATA_MASK_FARM_AMBUSHES   = 0x0040, 

	HOME_DATA_MASK_BREED_BASIC     = 0x0100,
	HOME_DATA_MASK_BREED_FENCE     = 0x0200,
	HOME_DATA_MASK_BREED_BLESS     = 0x0400,

	HOME_DATA_MASK_FORCE_ALL       = 0xFFFF,
};

// ÖÖÖ²·½Ê½
enum FARM_PLANT_TYPE {
	FARM_PLANT_NORMAL    = 0, // ÆÕÍ¨ÖÖÖ²
	FARM_PLANT_INTENSIVE = 1, // ¾«¸û
};

// ÑøÖ³³¡¶¯ÎïÌØÊâ×´Ì¬
enum BREED_ANIMAL_STATE
{
	BREED_ANIMAL_STATE_NORMAL         = 0, // Õý³£

	BREED_ANIMAL_STATE_ABNORMAL_BEGIN = 1,
	// {Òì³£×´Ì¬
	BREED_ANIMAL_STATE_ABNORMAL1      = 1, // ÎÁÒß
	BREED_ANIMAL_STATE_ABNORMAL2      = 2, // ÈÈÖ¢
	BREED_ANIMAL_STATE_ABNORMAL3      = 3, // º®Ö¢
	BREED_ANIMAL_STATE_ABNORMAL4      = 4, // »ýÊ³
	BREED_ANIMAL_STATE_ABNORMAL5      = 5, // ¾·ÂÎ
	// Òì³£×´Ì¬}
	BREED_ANIMAL_STATE_ABNORMAL_END,

	BREED_ANIMAL_STATE_DEAD           = 6, // ËÀÍö
};

// ÖÎÁÆ
enum BREED_ANIMAL_TREATMENT
{
	BREED_ANIMAL_TREAT_ABNORMAL1 = 1, // Î¹Ò©
	BREED_ANIMAL_TREAT_ABNORMAL2 = 2, // Í¨·ç
	BREED_ANIMAL_TREAT_ABNORMAL3 = 3, // Éú»ð
	BREED_ANIMAL_TREAT_ABNORMAL4 = 4, // Õë¾Ä
	BREED_ANIMAL_TREAT_ABNORMAL5 = 5, // ÍÆÄÃ
};

enum BREED_FIELD_ACTION_TYPE
{
	BREED_FIELD_ACTION_BREED   = 0,
	BREED_FIELD_ACTION_FEED       ,
	BREED_FIELD_ACTION_TREAT      ,
	BREED_FIELD_ACTION_HARVEST    ,
};

enum BREED_FIELD_BLESS_STEP
{
	BREED_FIELD_BLESS_STEP1 = 0, // ¿ªÊ¼Æí¸££¬»ñµÃÆí¸£È¦ÀàÐÍ
	BREED_FIELD_BLESS_STEP2 = 1, // ·ÅÖÃÆí¸£È¦
	BREED_FIELD_BLESS_QUERY = 2, // ²éÑ¯Æí¸£ÐÅÏ¢
};

enum FORAGE_SOURCE_TYPE
{
	FORAGE_SOURCE_HOME_STOREHOUSE,    // ¼ÒÔ°²Ö¿â
	FORAGE_SOURCE_MATERIAL_INVENTORY, // ²ÄÁÏ°ü¹ü
};

enum
{
	SOCIAL_ACT_PROPOSE = 1,	//Çó»é
	SOCIAL_ACT_FRIEND = 2,	//¼ÓºÃÓÑ
};

enum CAMPAIGN_NOTIFY_TYPE
{
	CAMPAIGN_NOTIFY_NORMAL	= 1, // ÆÕÍ¨ÐÅÏ¢
	CAMPAIGN_NOTIFY_TIMEOUT	= 2, // GSÐèÒªÏÈÇåµôËùÓÐµ±Ç°ÒÑ¾­¿ª·ÅµÄ»î¶¯ 
};

enum CAMPAIGN_DBOPERATE_TYPE
{
	CAMPAIGN_DBOPERATE_LOADALL	= 1,//µ¼³ö·â½ûÁÐ±íºÍgmÇ¿¿ª»î¶¯Ê±¼ä±í
	CAMPAIGN_DBOPERATE_SAVEFORBID	= 2,//±£´æ·â½û/½â½ûÐÅÏ¢
	CAMPAIGN_DBOPERATE_CLRFORBID	= 3,//Çå³ý·â½û/½â½ûÏûÏ¢
	CAMPAIGN_DBOPERATE_SAVEGMOPEN	= 4,//±£´æGMÇ¿¿ªÊ±¼äÐÅÏ¢
	CAMPAIGN_DBOPERATE_CLRGMOPEN	= 5,//Çå³ýGMÇ¿¿ªÊ±¼äÐÅÏ¢
};

enum STOCK_ORDER_STATUS
{
	STOCK_ORDER_NORMAL    = 0, //Õý³£¹Òµ¥£¬¿É½»Ò××´Ì¬
	STOCK_ORDER_NEW       = 1, //ÁÙÊ±¹Òµ¥£¬²»¿É½»Ò××´Ì¬
	STOCK_ORDER_TRADING   = 2, //½»Ò×¹ý³ÌÖÐ
};

enum BATTLE_OPTION_TYPE
{
	BOT_NAME	= 1,	// ÐÞ¸Ä·¿¼äÃû
	BOT_PASSWORD	= 2,	// ÐÞ¸Ä·¿¼äÃÜÂë
	BOT_INVITATE	= 3,	// ÑûÇë
};

enum GRADE_VALUE
{
	GV_IDLE		= 0,
	GV_NORMAL	= 70,
	GV_BUSY		= 85,
	GV_LIMIT	= 100,
	GV_MAX		= 127,
};

enum FACTION_ADD_SUB_TYPE
{
	FAST_DEL	= 0,
	FAST_ADD	= 1,
	FAST_LEVEL	= 2,
};

enum FACTION_CHANGE_DATA_TYPE
{
	FCDT_MONEY		= 0,
	FCDT_AUCTIONPOINT	= 1,
	FCDT_CONSTRUCTION	= 2,
	FCDT_WELFARE_EXP	= 3,	//µ±ÈÕ¸£Àû¾­ÑéÀÛ¼Æ
};

enum FACTION_CHANGE_DATA_MODE
{
	FCDM_REWARD		= 0,	//Í¨ÓÃ½±Àø¸Ä±ä
	FCDM_TASK		= 1,	//ÈÎÎñ¸Ä±ä
};

enum FC_WEIGHT_RESET_TYPE
{
	FCWRT_ONE_OFFSET	= 0,
	FCWRT_TWO_OFFSET	= 1,
	FCWRT_ONE_VALUE		= 2,
	FCWRT_TWO_VALUE		= 3,
};

enum FACTION_RESETCITY_TYPE
{
	FRT_NONE		= 0,//²»¹ØÐÄµÄÖØÖÃÇé¿ö
	FRT_ADDCITY		= 1,//Ôö¼Ó·Ö¶æ
	FRT_DELCITY		= 2,//¼õÉÙ·Ö¶æ
	FRT_MAINCHANGE		= 3,//°áÇ¨×Ü¶æ
	FRT_CLRUNLINK		= 4,//Çå³ý²»Á¬Í¨·Ö¶æ
	FRT_RELOAD		= 5,//ÖØµ¼Êý¾Ý¿â
};

enum FACTION_CITY_CHECK_TYPE
{
	FCCT_BASE_OPEN		= 0,
	FCCT_MAIN_EXHG		= 1,
	FCCT_SUB_APPLY		= 2,
	FCCT_TIGUAN_EXHG1	= 3,
	FCCT_TIGUANED_EXHG1	= 4,
	FCCT_TIGUAN_EXHG2	= 5,
	FCCT_TIGUANED_EXHG2	= 6,

	FCCT_MAX,
};

enum DB_LOAD_STATUS
{
	DLS_FACTION	= 0x01,	//°ïÅÉÊý¾Ý
	DLS_FCITY	= 0x02,	//ÊÆÁ¦µØÍ¼
	DLS_TOPLIST	= 0x04,	//ÅÅÐÐ°ñ

	DLS_ALL_FACTION_NEED	= DLS_FACTION | DLS_FCITY | DLS_TOPLIST,	//°ïÅÉÏà¹ØµÄÊý¾Ý
};

enum TIZI_PLACE_TYPE
{
	TPT_BIGWORLD	= 0,	//´óÊÀ½ç
	TPT_MAFIA_BASE	= 1,	//°ïÅÉ»ùµØ
};

//ÍÅÌå¾ºÈü¸±±¾½×¶Î¶¨Òå
enum TOURNAMENT_STAGE_TYPE
{
	TOURNAMENT_STAGE_INVALID     = 0, //·Ç·¨
	TOURNAMENT_STAGE_INIT        = 1, //³õÊ¼»¯
	TOURNAMENT_STAGE_ENTERING    = 2, //½ø³¡
	TOURNAMENT_STAGE_COMPETITION = 3, //±ÈÈü
	TOURNAMENT_STAGE_FINISH      = 4, //½áÊø
};

enum SCENE_INFO_STATE_MASK
{
	SISM_MASTER_LINE		= 0x01,	//Ö÷¾µÏñËùÔÚÏß
	SISM_FORCE_CLOSED		= 0x02,	//GSËùÔÚ¾µÏñÇ¿ÖÆ¹Ø±Õ
};

#define PRINT_SUB(__id,x)	\
	if(0){		\
		char __buf[1024];	\
		char* p = __buf;	\
		for(size_t i = 0; i < x.size(); i ++)	{	\
			p += sprintf(p, "<sub%d:%d, d:%d, l:%d> |", i, x[i].id, x[i].sub_domain, x[i].level);	\
		}				\
		LOG_TRACE("-->SUB_FACTION: %d,\t%s", (__id), __buf);	\
	}

#define PRINT_BUILD(__id, bu)	\
	if(1) {			\
		char __buf[1024];	\
		char*p = __buf;		\
		for(size_t i = 0; i < bu.size(); ++i)			\
			p += sprintf(p, "%d: %d,\t", i, bu[i].level);	\
		LOG_TRACE("-->Building: %d,\t%s", __id, __buf);		\
	}

#define LOAD_FACTION(fid,gfaction) \
	{ \
		Marshal::OctetsStream value; \
		if(faction->find(Marshal::OctetsStream() << fid,value,txnobj)) \
		{ \
			value >> gfaction; \
		} \
		else \
		{ \
			res->retcode = ERROR_FACTION_NOTFOUND; \
			return; \
		} \
	}

#define LOAD_FACTION1(fid,gfaction,ret) \
	{ \
		Marshal::OctetsStream value; \
		if(faction->find(Marshal::OctetsStream() << fid,value,txnobj)) \
		{ \
			value >> gfaction; \
			ret = 0;\
		} \
		else \
		{ \
			ret = -1;\
		} \
	}

#define LOAD_CITY1(cityid,gcity,ret) \
	{ \
		Marshal::OctetsStream value; \
		if(city->find(Marshal::OctetsStream() << cityid,value,txnobj)) \
		{ \
			value >> gcity; \
			ret = 0;\
		} \
		else \
		{ \
			ret = -1;\
		} \
	}

#define LOAD_CITY(cityid,gcity) \
	{ \
		Marshal::OctetsStream value; \
		if(city->find(Marshal::OctetsStream() << cityid,value,txnobj)) \
		{ \
			value >> gcity; \
		} \
		else \
		{ \
			res->retcode = ERROR_FACTION_NOTFOUND; \
			return;\
		} \
	}

#define LOAD_CITY2(cityid,gcity) \
	{ \
		Marshal::OctetsStream value; \
		if(city->find(Marshal::OctetsStream() << cityid,value,txnobj)) \
		{ \
			value >> gcity; \
		} \
		else \
		{ \
			res->value = ERROR_FACTION_NOTFOUND;\
			return; \
		} \
	}

enum AUCTION_TYPE
{
	AU_TYPE_AUCTION		= 0,	// ÅÄÂô
	AU_TYPE_BID		= 1,	// ¾º¼Û

	AU_TYPE_COUNT,
};

const int AUCTION_PRICE_ADD_MIN			= 50;	//×îÉÙ
const double AUCTION_PRICE_ADD_MIN_RATE		= 0.01;	//×îÉÙÎªµ±Ç°¼Û¸ñ1%
inline int64_t AUCTION_NEXT_PRICE_MIN(int64_t now)
{
	if((double)now * AUCTION_PRICE_ADD_MIN_RATE <= (double)AUCTION_PRICE_ADD_MIN)
		return AUCTION_PRICE_ADD_MIN + now;
	int64_t temp = (int64_t)((double)now * AUCTION_PRICE_ADD_MIN_RATE);
	return (temp - temp % AUCTION_PRICE_ADD_MIN) + now;
}

enum CHANGE_LINE_TYPE
{
	CLT_INVALID		= 0,
	CLT_LONG_JUMP		= 1,	// Long_jump
	CLT_SIGNLE_JUMP		= 2,	// Single_long_jump
	CLT_ENTER_INSTACE	= 3,	// EnterInstance
	CLT_LEAVEINSTNACE	= 4,	// LeaveIntance
	CLT_MULTI_JUMP		= 5,	// MultiLongJump
};

enum MINGXING_SPEAK_TYPE
{
	MST_AUCTION		= 1,	// ÅÄÂôÏà¹Ø
};

class TimeConfig
{
private:
	enum TIME_TYPE
	{
		TIME_TYPE_ABSOLUTE_TIME_POINT, // È·ÇÐÊ±¼äµã
		TIME_TYPE_YEARLY,              // Ã¿ÄêµÄÄ³ÔÂÄ³ÈÕÄ³Ê±Ä³·ÖÄ³Ãë
		TIME_TYPE_MONTHLY_MDAY,        // Ã¿ÔÂµÄÄ³ÈÕÄ³·ÖÄ³Ãë
		TIME_TYPE_MONTHLY_WDAY,        // Ã¿ÔÂµÄµÚÒ»¸öÄ³ÖÜ¼¸Ä³·ÖÄ³Ãë
		TIME_TYPE_WEEKLY,              // Ã¿ÖÜµÄÖÜ¼¸Ä³Ê±Ä³·ÖÄ³Ãë
		TIME_TYPE_DAILY,               // Ã¿ÌìµÄÄ³Ê±Ä³·ÖÄ³Ãë
	};

public:
	TIME_TYPE type;
	unsigned short year; // The value of years. e.g. 2012
	unsigned char month; // [1,12]
	unsigned char mday;  // [1,31]
	unsigned char wday;  // [0,6]
	unsigned char hour;  // [0,23]
	unsigned char min;   // [0,59] 
	unsigned char sec;   // [0,60], 60 for leap seconds

public:
	static TimeConfig ConstructAbsTimeConfig(unsigned short year, unsigned char month, unsigned char mday, unsigned char hour, unsigned char min, unsigned char sec)
	{
		return ConstructTimeConfig(TIME_TYPE_ABSOLUTE_TIME_POINT, year, month, mday, 0, hour, min, sec);
	}
	static TimeConfig ConstructYearlyConfig(unsigned char month, unsigned char mday, unsigned char hour, unsigned char min, unsigned char sec)
	{
		return ConstructTimeConfig(TIME_TYPE_YEARLY, 0, month, mday, 0, hour, min, sec);
	}
	static TimeConfig ConstructMonthlyMDayConfig(unsigned char mday, unsigned char hour, unsigned char min, unsigned char sec)
	{
		return ConstructTimeConfig(TIME_TYPE_MONTHLY_MDAY, 0, 0, mday, 0, hour, min, sec);
	}
	static TimeConfig ConstructMonthlyWDayConfig(unsigned char wday, unsigned char hour, unsigned char min, unsigned char sec)
	{
		return ConstructTimeConfig(TIME_TYPE_MONTHLY_WDAY, 0, 0, 0, wday, hour, min, sec);
	}
	static TimeConfig ConstructWeeklyConfig(unsigned char wday, unsigned char hour, unsigned char min, unsigned char sec)
	{
		return ConstructTimeConfig(TIME_TYPE_WEEKLY, 0, 0, 0, wday, hour, min, sec);
	}
	static TimeConfig ConstructDailyConfig(unsigned char hour, unsigned char min, unsigned char sec)
	{
		return ConstructTimeConfig(TIME_TYPE_DAILY, 0, 0, 0, 0, hour, min, sec);
	}

private:
	static TimeConfig ConstructTimeConfig(TIME_TYPE type, 
		unsigned short abs_year, unsigned char month, unsigned char mday, unsigned char wday, unsigned char hour, unsigned char min, unsigned char sec)
	{
		TimeConfig cfg;
		cfg.type = type;
		cfg.year = abs_year;
		cfg.month = month;
		cfg.mday = mday;
		cfg.wday = wday;
		cfg.hour = hour;
		cfg.min = min;
		cfg.sec = sec;
		return cfg;
	}

public:
	bool IsTimeToUpdate(time_t cur_time)
	{
		struct tm cur_tm;
		localtime_r(&cur_time, &cur_tm);
		bool retflag = false;
		switch (type)
		{
			case TIME_TYPE_ABSOLUTE_TIME_POINT:
				retflag = (cur_tm.tm_year + 1900 == year && cur_tm.tm_mon + 1 == month && cur_tm.tm_mday == mday && cur_tm.tm_hour == hour && cur_tm.tm_min == min && cur_tm.tm_sec == sec);
				break;
			case TIME_TYPE_YEARLY:
				retflag = (cur_tm.tm_mon + 1 == month && cur_tm.tm_mday == mday && cur_tm.tm_hour == hour && cur_tm.tm_min == min && cur_tm.tm_sec == sec);
				break;
			case TIME_TYPE_MONTHLY_MDAY:
				retflag = (cur_tm.tm_mday == mday && cur_tm.tm_hour == hour && cur_tm.tm_min == min && cur_tm.tm_sec == sec);
				break;
			case TIME_TYPE_MONTHLY_WDAY:
				retflag = (cur_tm.tm_mday <= 7 && cur_tm.tm_wday == wday && cur_tm.tm_hour == hour && cur_tm.tm_min == min && cur_tm.tm_sec == sec);
				break;
			case TIME_TYPE_WEEKLY:
				retflag = (cur_tm.tm_wday == wday && cur_tm.tm_hour == hour && cur_tm.tm_min == min && cur_tm.tm_sec == sec);
				break;
			case TIME_TYPE_DAILY:
				retflag = (cur_tm.tm_hour == hour && cur_tm.tm_min == min && cur_tm.tm_sec == sec);
				break;
			default:
				break;
		}
		return retflag;
	}

	bool IsTimeToUpdate(time_t last_time, time_t cur_time)
	{
		if (last_time == cur_time) return false;
		struct tm last_tm;
		struct tm cur_tm;
		localtime_r(&last_time, &last_tm);
		localtime_r(&cur_time, &cur_tm);
		return (Compare(last_tm) > 0 && Compare(cur_tm) < 0);
	}

private:
	int Compare(const struct tm& _tm)
	{
		int retval = 0;
		switch (type)
		{
			case TIME_TYPE_ABSOLUTE_TIME_POINT:
			{
				if (year < _tm.tm_year + 1900) retval = -1;
				else if (year > _tm.tm_year + 1900) retval = 1;
				else if (month < _tm.tm_mon + 1) retval = -1;
				else if (month > _tm.tm_mon + 1) retval = 1;
				else if (mday < _tm.tm_mday) retval = -1;
				else if (mday > _tm.tm_mday) retval = 1;
				else if (hour < _tm.tm_hour) retval = -1;
				else if (hour > _tm.tm_hour) retval = 1;
				else if (min < _tm.tm_min) retval = -1;
				else if (min > _tm.tm_min) retval = 1;
				else if (sec < _tm.tm_sec) retval = -1;
				else if (sec > _tm.tm_sec) retval = 1;
				break;
			}
			case TIME_TYPE_YEARLY:
			{
				if (month < _tm.tm_mon + 1) retval = -1;
				else if (month > _tm.tm_mon + 1) retval = 1;
				else if (mday < _tm.tm_mday) retval = -1;
				else if (mday > _tm.tm_mday) retval = 1;
				else if (hour < _tm.tm_hour) retval = -1;
				else if (hour > _tm.tm_hour) retval = 1;
				else if (min < _tm.tm_min) retval = -1;
				else if (min > _tm.tm_min) retval = 1;
				else if (sec < _tm.tm_sec) retval = -1;
				else if (sec > _tm.tm_sec) retval = 1;
				break;
			}
			case TIME_TYPE_MONTHLY_MDAY:
			{
				if (mday < _tm.tm_mday) retval = -1;
				else if (mday > _tm.tm_mday) retval = 1;
				else if (hour < _tm.tm_hour) retval = -1;
				else if (hour > _tm.tm_hour) retval = 1;
				else if (min < _tm.tm_min) retval = -1;
				else if (min > _tm.tm_min) retval = 1;
				else if (sec < _tm.tm_sec) retval = -1;
				else if (sec > _tm.tm_sec) retval = 1;
				break;
			}
			case TIME_TYPE_MONTHLY_WDAY:
			{
				if (_tm.tm_mday > 7) retval = -1;
				if (wday < _tm.tm_wday) retval = -1;
				else if (wday > _tm.tm_wday) retval = 1;
				else if (hour < _tm.tm_hour) retval = -1;
				else if (hour > _tm.tm_hour) retval = 1;
				else if (min < _tm.tm_min) retval = -1;
				else if (min > _tm.tm_min) retval = 1;
				else if (sec < _tm.tm_sec) retval = -1;
				else if (sec > _tm.tm_sec) retval = 1;
				break;
			}
			case TIME_TYPE_WEEKLY:
			{
				if (wday < _tm.tm_wday) retval = -1;
				else if (wday > _tm.tm_wday) retval = 1;
				else if (hour < _tm.tm_hour) retval = -1;
				else if (hour > _tm.tm_hour) retval = 1;
				else if (min < _tm.tm_min) retval = -1;
				else if (min > _tm.tm_min) retval = 1;
				else if (sec < _tm.tm_sec) retval = -1;
				else if (sec > _tm.tm_sec) retval = 1;
				break;
			}
			case TIME_TYPE_DAILY:
			{
				if (hour < _tm.tm_hour) retval = -1;
				else if (hour > _tm.tm_hour) retval = 1;
				else if (min < _tm.tm_min) retval = -1;
				else if (min > _tm.tm_min) retval = 1;
				else if (sec < _tm.tm_sec) retval = -1;
				else if (sec > _tm.tm_sec) retval = 1;
				break;
			}
			default:
				break;
		}
		return retval;
	}
};

typedef std::map<int, unsigned char> WooConfig; // woo npc tid -> is_senior

class WooHelper
{
public:
	bool IsTimeToResetOwner(time_t cur_time)
	{
		return _reset_owner_time.IsTimeToUpdate(cur_time);
	}
	bool IsTimeToResetOwner(time_t last_time, time_t cur_time)
	{
		return _reset_owner_time.IsTimeToUpdate(last_time, cur_time);
	}

	bool IsTimeToCheckRestoreOwner(time_t cur_time)
	{
		return _check_restore_owner_time.IsTimeToUpdate(cur_time);
	}
	bool IsTimeToCheckRestoreOwner(time_t last_time, time_t cur_time)
	{
		return _check_restore_owner_time.IsTimeToUpdate(last_time, cur_time);
	}

	bool IsTimeToResetWooReputation(time_t cur_time)
	{
		return _reset_woo_reputation_time.IsTimeToUpdate(cur_time);
	}
	bool IsTimeToResetWooReputation(time_t last_time, time_t cur_time)
	{
		return _reset_woo_reputation_time.IsTimeToUpdate(last_time, cur_time);
	}

	static WooHelper& JuniorHelper()
	{
		static WooHelper s_instance;
		static bool inited = false;
		if (!inited)
		{
			// ¶ÔÓÚµÍ¶ËÇó°®NPC£¬µ±µØÊ±¼äÃ¿ÖÜÈÕ18:00µãÖØÖÃ¹éÊô£¬2Ð¡Ê±ºó¼ì²é»Ö¸´Ô­¹éÊô£¨ÐèÒª±£Ö¤¹éÊôÈÎÎñ¿ª·ÅÊ±¼äÔÚÁ½ÕßÖ®¼ä£©£¬Í¬Ê±ÖØÖÃÇó°®Ïà¹ØÉùÍû
			s_instance._reset_owner_time = TimeConfig::ConstructWeeklyConfig(0, 18, 0, 0);
			s_instance._check_restore_owner_time = TimeConfig::ConstructWeeklyConfig(0, 20, 0, 0);
			s_instance._reset_woo_reputation_time = TimeConfig::ConstructWeeklyConfig(0, 20, 0, 0);
		}
		return s_instance;
	}

	static WooHelper& SeniorHelper()
	{
		static WooHelper s_instance;
		static bool inited = false;
		if (!inited)
		{
			// ¶ÔÓÚ¸ß¶ËÇó°®NPC£¬µ±µØÊ±¼äÃ¿ÔÂÃ¿Ò»¸öÖÜÁù18:00µãÖØÖÃ¹éÊô£¬2Ð¡Ê±ºó¼ì²é»Ö¸´Ô­¹éÊô£¨ÐèÒª±£Ö¤¹éÊôÈÎÎñ¿ª·ÅÊ±¼äÔÚÁ½ÕßÖ®¼ä£©£¬Í¬Ê±ÖØÖÃÇó°®Ïà¹ØÉùÍû
			s_instance._reset_owner_time = TimeConfig::ConstructMonthlyWDayConfig(6, 18, 0, 0);
			s_instance._check_restore_owner_time = TimeConfig::ConstructMonthlyWDayConfig(6, 20, 0, 0);
			s_instance._reset_woo_reputation_time = TimeConfig::ConstructMonthlyWDayConfig(6, 20, 0, 0);
		}
		return s_instance;
	}

private:
	TimeConfig _reset_owner_time;
	TimeConfig _check_restore_owner_time;
	TimeConfig _reset_woo_reputation_time;
}; // class WooHelper

class RoleInfoHelper
{
public:
	template<typename GRoleDetail, typename GRoleNetInfo, typename GRoleInfo>
	static void Detail2Info(GRoleDetail& role, GRoleNetInfo& net, GRoleInfo& info)
	{
		info.roleid = role.roleid;
		info.name = role.baseinfo.name;
		info.gender = role.baseinfo.gender;
		info.clothesid = role.baseinfo.clothesid;
		info.idphoto = role.baseinfo.idphoto;
		info.faceid = role.baseinfo.faceid;
		info.hairid = role.baseinfo.hairid;
		info.haircolor = role.baseinfo.haircolor;
		info.skincolor = role.baseinfo.skincolor;
		info.beardid = role.baseinfo.beardid;
		info.tattoo = role.baseinfo.tattoo;
		info.sharp = role.baseinfo.sharp;
		info.appearance = role.status.appearance;
		info.profession = role.status.profession;
		info.level = (unsigned char)(char)role.status.level;
		info.worldpos = role.status.worldpos;
		info.lug_worldpos = role.status.lug_worldpos;
		info.create_time = role.create_time;
		info.logout_time = role.status.updatetime;
		info.title = role.title;
		info.contribution = role.status.contribution;
		info.devotion = role.status.devotion;
		info.jointime = role.jointime;
		info.custom_status.swap(role.status.custom_status);
		info.character_mode.swap(role.status.charactermode);
		info.equipment.swap(role.pocket.equipment);
		info.reputation = role.status.reputation;
		info.ds_timestamp = role.status.ds_timestamp;

		info.status = net.status;
//		info.origin = net.origin;
		info.delete_time = net.delete_time;
		info.help_data.swap(net.help_data);
		info.stable_data.swap(net.stable_data);
		info.volatile_data.swap(net.volatile_data);
		info.forbid.swap(net.forbid);
		info.trustees.swap(net.trustees);
		info.cooldown.swap(net.cooldown);

//		info.cur_title = role.status.cur_title;
		info.inst_tid = role.status.inst_tid;

		info.cash_total_add = role.status.cash_total_add;
		info.rmb_total_add = role.status.rmb_total_add;
	}
	
	template<typename GRoleBase, typename GRoleStatus, typename GRolePocket, typename GRoleInfo>
	static void Data2Info(GRoleBase& base, GRoleStatus& status, GRolePocket& pocket, GRoleInfo& info)
	{
		info.roleid = base.roleid;
		info.status = base.status;
		info.name = base.name;
		info.gender = base.gender;
//		info.origin = base.origin;
		info.clothesid = base.clothesid;
		info.idphoto = base.idphoto;
		info.faceid = base.faceid;
		info.hairid = base.hairid;
		info.haircolor = base.haircolor;
		info.skincolor = base.skincolor;
		info.beardid = base.beardid;
		info.tattoo = base.tattoo;
		info.sharp = base.sharp;
		info.appearance = status.appearance;
		info.profession = status.profession;
		info.level = (unsigned char)(char)status.level;
		info.worldpos = status.worldpos;
		info.lug_worldpos = status.lug_worldpos;
		info.src_zone_worldpos = status.src_zone_worldpos;
		info.create_time = base.create_time;
		info.delete_time = base.delete_time;
		info.logout_time = status.updatetime;
		info.title = base.title;
		info.contribution = status.contribution;
		info.devotion = status.devotion;
		info.jointime = base.join_time;
		info.custom_status.swap(status.custom_status);
		info.character_mode.swap(status.charactermode);
		info.help_data.swap(base.help_data);
		info.stable_data.swap(base.stable_data);
		info.volatile_data.swap(base.volatile_data);
		info.equipment.swap(pocket.equipment);
		info.forbid.swap(base.forbid);
		info.trustees.swap(base.trustees);
		info.cooldown.swap(base.cooldown);
		info.reputation = status.reputation;
		//info.cur_title = status.cur_title;
		info.inst_tid = status.inst_tid;
		info.ds_timestamp = status.ds_timestamp;
		info.cash_total_add = status.cash_total_add;
		info.rmb_total_add = status.rmb_total_add;
		info.fightingcapacity = status.fightingcapacity;
	}
	
};

enum BADGE_CONSTANT
{
	BADGE_VERSION = 0x04,
};
class PlayerBadgeHelper
{
public:
	struct BadgeInfo
	{
		int badge_id;
		unsigned char badge_level;
		int achieve_time;
		unsigned char relate_type;
		int relate_id;
	public:
		BadgeInfo(int _badge_id = 0,unsigned char _badge_level = 0,int _achieve_time = 0,int _relate_type = 0,int _relate_id = 0)
			: badge_id(_badge_id),badge_level(_badge_level),achieve_time(_achieve_time),relate_type(_relate_type),relate_id(_relate_id)
		{}

	};
	typedef std::vector<BadgeInfo> Badge_Vec;
public:
	static bool Load(const Marshal::OctetsStream& os,Badge_Vec& equip_badge,Badge_Vec& badge_store)
	{
		equip_badge.clear();
		badge_store.clear();
		try
		{
			if(os.size() < 4) return false;//VERSION + EQUIP_SIZE + STORE_SIZE
			unsigned short version;
			os >> version;
			if(version != BADGE_VERSION)
			{
				//×ª»»´úÂë£¬ÏÖÔÚºöÂÔ
				return true;
			}
			unsigned int equip_count;
			os >> CompactUINT(equip_count);
			for(size_t i = 0; i < equip_count; i++)
			{
				int badge_id = 0,achieve_time = 0,relate_id = 0;
				unsigned char badge_level = 0,relate_type = 0;
				os >> badge_id >> badge_level >> achieve_time >> relate_type >> relate_id;
				equip_badge.push_back(BadgeInfo(badge_id,badge_level,achieve_time,relate_type,relate_id));
			}
			unsigned int badge_count;
			os >> CompactUINT(badge_count);
			for(size_t i = 0; i < badge_count; i++)
			{
				int badge_id = 0,achieve_time = 0,relate_id = 0;
				unsigned char badge_level = 0,relate_type = 0;
				os >> badge_id >> badge_level >> achieve_time >> relate_type >> relate_id;
				badge_store.push_back(BadgeInfo(badge_id,badge_level,achieve_time,relate_type,relate_id));
			}
		}
		catch(...)
		{
			return false;
		}
		return true;
	}

	static void Save(Marshal::OctetsStream& os,const Badge_Vec& equip_badge,const Badge_Vec& badge_store)
	{
		os.clear();
		os << (unsigned short)BADGE_VERSION;
		const Badge_Vec *pArray[] = {&equip_badge,&badge_store};
		for(size_t i = 0;i < sizeof(pArray)/sizeof(const Badge_Vec *); i++)
		{
			os << CompactUINT(pArray[i]->size());
			for(size_t j = 0; j < pArray[i]->size(); j++)
			{
				const BadgeInfo& item = (*pArray[i])[j];
				int badge_id = item.badge_id,achieve_time = item.achieve_time,relate_id = item.relate_id;
				unsigned char badge_level = item.badge_level,relate_type = item.relate_type;
				os << badge_id << badge_level << achieve_time << relate_type << relate_id;
			}
		}

	}
};

//IWEB
#define ISIWebManager(manager) (manager->Identification() == "IWebDSServer")


}
#endif
