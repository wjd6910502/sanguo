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
	INSTANCE_SOLO       = 0,	// 个人副本
	INSTANCE_ROUTINE    = 1,	// 活动副本
	INSTANCE_TEAM       = 2,	// 常规副本
	INSTANCE_GM         = 3,	// GM尝试跟踪进入
	INSTANCE_BATTLE     = 4,	// 战场副本
	INSTANCE_BASE       = 5,	// 帮派基地
	INSTANCE_FACTION    = 6,	// 帮派副本
	INSTANCE_FACTION_TEAM=7,	// 帮派组队副本
	INSTANCE_TOURNAMENT = 8,	// 团体竞赛副本
	INSTANCE_DUEL       = 9,	// 切磋副本
	INSTANCE_BIWU       = 10,	// 比武副本
	INSTANCE_BANGHUIZHAN= 11,	// 帮会战副本

	INSTANCE_TYPE_COUNT,
};
enum SPEC_TYPE			//副本分类
{
	SPEC_CELEB		= 1,		//名人挑战
	SPEC_BATTLE		= 2,		//战场
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
	JIT_PATICIPATE	= 0,	//参与副本
	JIT_GM		= 1,	//GM跟随进入副本
	JIT_LOGIN	= 2,	//直接登录参与副本
};

enum PLAYER_LOST_CONNECTION_MODE
{
	PLCM_RECONNECT		= 0,	//普通逻辑,副本中使用断线重连
	PLCM_NO_RECONEC		= 1,	//副本中也不再使用断线重连
	PLCM_KEEP_CONNECT	= 2,	//断线后保持一致连接，直到模式改变

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
	MAIL_STATUS_ATTACHED   = 0x01,   // 有附件
	MAIL_STATUS_READ       = 0x02,   // 已读
	MAIL_STATUS_RESERVED   = 0x04,   // 保留
	MAIL_STATUS_PROCESSED  = 0x08,   // 已处理的邮件，比如加好友请求，通知等
	MAIL_STATUS_TO_DELETE  = 0x10,   // 可自动删除的邮件, 一般用于发奖
	MAIL_CANNOT_MERGE_MASK = ~(MAIL_STATUS_READ | MAIL_STATUS_PROCESSED), // MASK是会影响邮件合并的位的集合
};
enum MAIL_DBMODE
{
	MAIL_DBMODE_DIRTY      = 0x01,   // 待保存邮件
	MAIL_DBMODE_DELETED    = 0x02,   // 被删除
	MAIL_DBMODE_SAVING     = 0x04,   // 正在保存
};

enum
{

	REPLAY_TYPE_ARENA	= 0,
	REPLAY_TYPE_BIWU	= 1,

	ARENA_REPLAY_COUNT	= 1,	//最多保存几场竞技场挑战数据
	BIWU_REPLAY_COUNT	= 1,	//最多保存几场比武数据
};

enum MAIL_CATEGORY
{
	MAIL_CATEGORY_PLAYER   = 0,     // 普通玩家邮件
	MAIL_CATEGORY_TASK     = 1,     // 任务发送邮件
	MAIL_CATEGORY_MESSAGE  = 2,     // 玩家留言
	MAIL_CATEGORY_REQUEST  = 3,     // 格式邮件－请求
	MAIL_CATEGORY_INFORM   = 4,     // 格式邮件－通知
	//这些XOM没有使用
	MAIL_CATEGORY_GIFT     = 5,     // 礼物邮件
	MAIL_CATEGORY_STOCK    = 6,     // 元宝交易账户取钱邮件
	MAIL_CATEGORY_HOME     = 7,     // 家园系统取物品邮件
	MAIL_CATEGORY_LOSTFOUND= 8,     // 副本中没来得及发的东西
	MAIL_CATEGORY_MALL_BUY = 9,     // 商城购物邮件
	MAIL_CATEGORY_MALL_PRESENT = 10,// 商城赠送邮件
	MAIL_CATEGORY_AUCTION  = 11,	// 拍卖系统邮件
	MAIL_CATEGORY_WEBMAIL  = 12,    // 页面发奖工具
	//XOM新增
	MAIL_CATEGORY_REWARD   = 21,    // 系统发奖
	MAIL_CATEGORY_COMPENSATE= 22,   // 系统补偿

	//CATEGORY_MAIL_HIDDEN   = 0x40,  // 隐藏邮件，不会发给客户端
	CATEGORY_MAIL_SYSTEM   = 0x80,  // 来自系统的邮件最高位置 1
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
	CHAT_SYSTEM_TASK       = 0,  //任务系统
	CHAT_SYSTEM_MARRIAGE   = 1,  //婚姻系统
	CHAT_SYSTEM_DROP       = 2,  //掉落物品通知
};


enum SPEAK_ID_TYPE
{
	SIT_ROLEID	= 0,	//玩家角色id
	SIT_FACTIONID	= 1,	//帮派id
};

enum PRIVATE_CHANNEL
{
	WHISPER_NORMAL	= 0,	//非好友
	WHISPER_NORMALRE,	//非好友自动回复
	WHISPER_FRIEND,		//好友
	WHISPER_FRIEND_RE,	//好友自动回复
	WHISPER_USERINFO,	//好友相关信息
	WHISPER_GM, 		//在线客服
	WHISPER_MAX
};

// FORMAT_MAIL用于MailHeader.msgid定义，因为会存到数据库中，因此不能随便修改，一般只能新增，不能修改或删除已有定义
enum FORMAT_MAIL
{
	FORMAT_MAIL_FRIENDINVITE  = 1,  // 邀请成为好友
	FORMAT_MAIL_FRIENDAGREE   = 2,  // 同意好友申请
	//这些XOM没有使用
	FORMAT_MAIL_RENEGE        = 3,  // 被悔婚
	FORMAT_MAIL_DIVORCE       = 4,  // 被离婚
	FORMAT_MAIL_FAMILY_EXPEL  = 5,  // 被开除出结义
	FORMAT_MAIL_FAMILY_DISMISS= 6,  // 所在结义解散
	FORMAT_MAIL_SECT_EXPEL    = 7,  // 被师门开除
	FORMAT_MAIL_SECT_QUIT     = 8,  // 叛离师门
	FORMAT_MAIL_FACTION_INVITE= 9,  // 邀请加入帮派
	FORMAT_MAIL_SECT_GRADUATE_AWARD = 10, // 徒弟出师对师父的奖励
	FORMAT_MAIL_TIZI_ERASE		= 11,	//题字被擦出通知
	//XOM新增
	FORMAT_MAIL_WORLD_BOSS			= 21,  //参与世界boss战奖励
	FORMAT_MAIL_WORLD_BOSS_HERO		= 22,  //世界boss战主力奖励
	FORMAT_MAIL_WORLD_BOSS_HERO_BANGHUI	= 23,  //世界boss战主力帮会奖励
	//100之前给策划脚本用了
	FORMAT_MAIL_COMPENSATE_ROUTINE		= 101,  //服务器例行维护补偿
	FORMAT_MAIL_COMPENSATE_TEMP1		= 102,  //服务器临时维护补偿(小)
	FORMAT_MAIL_COMPENSATE_TEMP2		= 103,  //服务器临时维护补偿(中)
	FORMAT_MAIL_COMPENSATE_TEMP3		= 104,  //服务器临时维护补偿(大)
	FORMAT_MAIL_TOP_LEVEL			= 105,  //开服冲榜等级奖励
	FORMAT_MAIL_TOP_FIGHTCAPACITY		= 106,  //开服冲榜战力奖励
	FORMAT_MAIL_CLIENT_NOT_FREE		= 107,  //收费版客户端奖励
	FORMAT_MAIL_FOR_IOS_TEST_PLAYER		= 108,  //ios不删档测试用户回馈礼包
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
	COMMON_DATA_WEATHER	= 7,       //场景天气种子
	COMMON_DATA_WEDDING	= 8,       //婚礼预约
	COMMON_DATA_PROSPERITY	= 9,       //繁荣度
	COMMON_DATA_RANDOMSEED	= 10,      //随机种子
	COMMON_DATA_ALLIANCEWAR	= 11,      //盟主战
	COMMON_DATA_WOO		= 12,      //求爱
	COMMON_DATA_MASK_BITS	= 16,      //前缀左移位数
	COMMON_DATA_MASK	= 0xFFFF,  //数据蒙板
};

enum COMMON_DATA_VERSION
{
	WEATHER_VERSION		= 0x01,	//场景天气版本号
	WEDDING_VERSION		= 0x01,	//婚礼预约版本号
	PROSPERITY_VERSION	= 0x01,	//繁荣度版本号
	RANDOMSEED_VERSION	= 0x01, //随机种子版本号
	ALLIANCEWAR_VERSION	= 0x02,	//盟主战版本号
	WOO_VERSION		= 0x02, //求爱版本号
};

enum AUTHD_ERROR
{
	AUERR_INVALID_ACCOUNT      = 2,   //帐号不存在
	AUERR_INVALID_PASSWORD     = 3,   //密码错误
	AUERR_LOGOUT_FAIL          = 12,  //AUTH登出失败
	AUERR_PHONE_LOCK           = 130, //电话密保处于锁定中
	AUERR_NOT_ACTIVED          = 131, //本服务器需经激活方可登入，该帐号未激活。
	AUERR_ZONGHENG_ACCOUNT     = 132, //纵横中文网帐号未经激活不能登录游戏。
	AUERR_STOPPED_ACCOUNT      = 133, //为了优化服务器负载，因该帐号长时间未登录游戏，已被封禁，请与客服联系。
	AUERR_LOGIN_FREQUENT	   = 134, //您登录频繁，请稍后重新登录
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
	TRANSACTION_CLOSED	= 0,   // 交易已关闭
	TRANSACTION_SUCCESS	= 1,   // 交易成功完成
	TRANSACTION_FAILED	= 2,   // 交易失败
	TRANSACTION_TIMEOUT	= 3,   // GS在预定时间内未确认交易结果，归还物品
	TRANSACTION_UNKNOWN	= 4,   // GS未收到交易的执行结果
};

enum SWORD_ERRCODE
{
	ERROR_GENERAL                  = 9,     // 通用错误，偷懒不想加错误码用这个
	ERROR_INVALID_PASSWORD         = 10,    // 帐号或者密码错误
	ERROR_MULTILOGIN               = 11,    // 帐号已经登录
	ERROR_PHONE_LOCK               = 12,    // 电话密保处于锁定中
	ERROR_NOT_ACTIVATED            = 13,    // 本服务器需经激活方可登入，该帐号未激活。
	ERROR_ZONGHENG_ACCOUNT         = 14,    // 纵横中文网帐号未经激活不能登录游戏。
	ERROR_FROZEN_ACCOUNT           = 15,    // 为了优化服务器负载，因该帐号长时间未登录游戏，已被封禁，请与客服联系。
	ERROR_AUTHD_UNKNOWN            = 16,    // 未知AUTHD错误
	ERROR_SERVER_CLOSED            = 17,    // 服务器正在维护中
	ERROR_SERVER_OVERLOAD          = 18,    // 服务器人数达到上限
	ERROR_BANNED_ACCOUNT           = 19,    // 帐号被禁止登录
	ERROR_AUTHD_TIMEOUT            = 20,    // 帐号服务器认证超时
	ERROR_PROXY_SEND               = 21,    // ProxyRpc转发失败
	ERROR_GM_KICKOUT               = 22,    // 客服踢人
	ERROR_FORCE_LOGIN              = 23,    // 帐号从其他地方登录
	ERROR_AUTHD_KICKOUT            = 24,    // 帐号服务器踢人
	ERROR_ACCOUNT_FORBID           = 25,    // 帐号被封禁
	ERROR_INVLAID_ACCOUNT          = 26,    // 帐号数据错误
	ERROR_DB_LISTROLE              = 27,    // 从数据库读取角色信息失败
	ERROR_LOGIN_PENDING            = 28,    // 等待上次登录退出
	ERROR_LOGIN_STATE              = 29,    // 帐号状态不正确，登录失败
	ERROR_FORBID_IGNORE            = 30,    // 已经存在更长的同类封禁记录
	ERROR_INVALID_SCENE            = 31,    // scene不存在
	ERROR_LOGINFREQUENT_USBKEY2    = 32,    // 绑定二代神盾的通行证在32秒之内只能登陆一次。
	ERROR_GACD_KICKOUT             = 33,    // 反外挂系统踢人
	ERROR_MATRIX_FAILURE           = 34,    // 密保验证失败
	ERROR_NOT_IN_WHITELIST 	       = 35, 	// 不在glinkd的白名单中
	ERROR_IWEB_VERSION	       = 36,	// IWEB版本不一致

	ERROR_DB_NOTFOUND              = 100,   // 记录未找到
	ERROR_DB_OVERWRITE             = 101,   // 不能覆盖已有记录
	ERROR_DB_NULLKEY               = 102,   // 错误的key长度
	ERROR_DB_DECODE                = 103,   // 记录数据解码错误
	ERROR_DB_UNKNOWN               = 104,   // 未知数据库错误
	ERROR_DB_INVALIDINPUT          = 105,   // 请求参数校验失败
	ERROR_DB_CREATEROLE            = 106,   // 创建角色失败
	ERROR_DB_DISCONNECT            = 107,   // 服务器内部错误
	ERROR_DB_TIMEOUT               = 108,   // 服务器内部错误
	ERROR_DB_NOSPACE               = 109,   // 服务器上没有剩余空间
	ERROR_DB_VERIFYFAILED          = 110,   // 数据校验失败
	ERROR_DB_CASHOVERFLOW          = 111,   // 元宝金额已达上限
	ERROR_DB_EXCEPTION             = 112,   // 数据库异常

	ERROR_ROLELIST_FULL            = 150,   // 本帐号不能创建更多角色
	ERROR_INVALID_NAME             = 151,   // 名字中含有非法字符
	ERROR_UNAMED_DISCONNECT        = 152,   // 不能连接到名字服务器，请稍侯
	ERROR_UNAMED_NAMEUSED          = 153,   // 该名字已经被使用
	ERROR_GAMEDBD_NAMEUSED         = 154,   // 该名字已经被使用
	ERROR_ROLELIST_TIMEOUT         = 155,   // 获得角色列表超时
	ERROR_NAME_WRONG_LEN           = 156,   // 名字太长或太短
	ERROR_VALID_PRO 	       = 157,   // 当前职业尚未开放，敬请期待

	ERROR_CMD_COOLING              = 200,   // 命令处于冷却中
	ERROR_CMD_INVALID              = 201,   // 角色状态错误
	ERROR_DATA_EXCEPTION           = 202,   // 数据异常
	ERROR_DATA_LOADING             = 203,   // 正在读取数据
	ERROR_LINE_UNAVAILABLE         = 204,   // 没有可用的线路
	ERROR_LINE_NOTFOUND            = 205,   // 选择的线路不存在
	ERROR_LINE_FULL                = 206,   // 该线路玩家数已经达到上限
	ERROR_SERVER_NETWORK           = 207,   // 网络通信错误
	ERROR_ROLE_BANNED              = 208,   // 角色被禁止登录
	ERROR_ROLE_UNAVAILABLE         = 209,   // 角色不能登录
	ERROR_ROLE_LOGINFAILED         = 210,   // 登录游戏服务器失败
	ERROR_ROLE_MULTILOGIN          = 211,   // 角色已经在游戏服务器中
	ERROR_ROLE_NOTFOUND            = 212,   // 角色不存在
	ERROR_INVALID_DATA             = 213,   // 收到客户端发送的错误数据
	ERROR_GS_DISCONNECTED          = 214,   // 服务器内部错误
	ERROR_GS_DROPPLAYER            = 215,   // 游戏服务器断开用户连接
	ERROR_CLIENT_SEND              = 216,   // 客户端接收数据出错
	ERROR_CLIENT_RECV              = 217,   // 客户端发送数据出错
	ERROR_CLIENT_CLOSE             = 218,   // 客户端主动关闭连接
	ERROR_CLIENT_TIMEOUT           = 219,   // 客户端连接超时
	ERROR_CLIENT_INVALIDDATA       = 220,   // 客户端收到不正确的协议
	ERROR_CLIENT_DECODE            = 221,   // 客户端收到错误的协议数据
	ERROR_ROLE_DELETED	       = 222,	// 角色已经被删除
	ERROR_SERVER_CLOSING	       = 223,	// 服务器即将关闭
	ERROR_WAIT_CONNECTION          = 224,	// 断线重连等待

	ERROR_PLAYER_OFFLINE           = 301,   // 玩家不在线
	ERROR_TEAM_FULL                = 302,   // 队伍已满
	ERROR_TEAM_PLAYERINTEAM        = 303,   // 玩家已经加入队伍
	ERROR_TEAM_REFUSED             = 304,   // 对方拒绝组队邀请
	ERROR_TEAM_NOTFOUND            = 305,   // 队伍不存在
	ERROR_TEAM_DENIED              = 306,   // 没有队长权限
	ERROR_TEAM_LEADEROFFLINE       = 307,   // 队长没有在线
	ERROR_TEAM_NOTONLINE           = 308,   // 不在线队员不能成为队长
	ERROR_TEAM_DUPLICATE           = 309,   // 重复发布队伍招人信息
	ERROR_MAIL_BOXFROZEN           = 310,   // 对方邮箱冻结
	ERROR_MAIL_BOXFULL             = 311,   // 对方邮箱已满
	ERROR_MAIL_NOTFOUND            = 312,   // 邮件没有找到
	ERROR_MAIL_NOATTACHMENT        = 313,   // 附件没有找到
	ERROR_FRIEND_LISTFULL          = 320,   // 好友数量达到上限
	ERROR_FRIEND_REFUSED           = 321,   // 对方拒绝好友邀请
	ERROR_FRIEND_LOADING           = 322,   // 好友数据暂时不可用
	ERROR_FRIEND_BLACKLISTFULL     = 323,   // 黑名单人数达到上限
	ERROR_FRIEND_TIMEOUT           = 324,   // 加好友超时
	ERROR_SECT_OFFLINE             = 330,   // 玩家不在线
	ERROR_SECT_UNAVAILABLE         = 331,   // 对方已经拜师
	ERROR_SECT_FULL                = 332,   // 徒弟数量已经达到上限
	ERROR_SECT_REFUSE              = 333,   // 对方拒绝了你的收徒邀请
	ERROR_SECT_INVALIDLEVEL        = 334,   // 对方级别不满足要求
	ERROR_SECT_COOLING             = 335,   // 一天只能招收一弟子
	ERROR_SECT_DBERROR             = 336,   // 保存数据失败
	ERROR_SECT_NOTFOUND            = 337,   // 查找不到师门信息
	ERROR_SECT_NONINSIDER          = 338,   // 玩家不属于本师门
	ERROR_TRANSACTION_PENDING      = 342,   // 角色数据处于事务状态中，暂时不能发起新的事务
	ERROR_TEAM_CLIENT_REFUSEED     = 343,   // 对方拒绝(对方客户端原因)
	ERROR_TEAM_CANT_BE_LEADER      = 344,   // 自己没队伍，但对方有队伍，所以无法建新队伍成为队长

	ERROR_TOP_LIST_ACTIVE          = 370,	// 比武排名系统未开启
	ERROR_MAX_FIGHT_RANK           = 371,	// 玩家排名超出最高排名
	ERROR_WRONG_ADVERSARY          = 372,	// 选择了错误的对手
	ERROR_ROLE_IN_BATTLE           = 373,	// 玩家正在接受挑战
	ERROR_BATTLE_TIME_OUT          = 374,	// 挑战超时
	ERROR_TOP_MIN_LEVEL            = 375,	// 玩家没有到达挑战等级
	ERROR_GET_REWARD               = 376,	// 玩家已经领了奖励
	ERROR_MAIL_FORCEDELETE         = 377,   // 不能删除有附件的邮件

	ERROR_GS_LOADTIMEOUT           = 400,   // 数据库读取超时
	ERROR_GS_LOADEXCEPTION         = 401,   // 数据库读取失败
	ERROR_GS_INVALIDDATA           = 402,   // 非法的角色数据
	ERROR_GS_INVALIDPOSITION       = 403,   // 角色处在错误的位置
	ERROR_GS_INVALIDWORLD          = 404,   // 世界类型错误
	ERROR_GS_MULTILOGIN            = 405,   // 玩家已经处于登入状态
	ERROR_GS_LOADFAILED            = 406,   // 加载玩家数据失败
	ERROR_GS_OVERLOADED            = 407,   // 本线达到人数上限
	ERROR_GS_INVALIDSTATE          = 408,   // 玩家状态错误
	ERROR_GS_DROPDELIVERY          = 409,   // GS与DS断开连接，连接恢复中
	ERROR_MARRY_GENDER             = 410,   // 性别错误
	ERROR_MARRY_NOT_SINGLE         = 411,   // 婚姻状态错误
	ERROR_MARRY_COOLTIME           = 412,   // 婚姻冷却中
	ERROR_MARRY_WRONG_LEVEL        = 413,   // 人物级别不够
	ERROR_MARRY_REJECTED           = 414,   // 对方拒绝
	ERROR_MARRY_ITEM               = 415,   // 缺少物品
	ERROR_VOTE_VOTING              = 416,   // 已经在投票中
	ERROR_MARRY_NOT_2PERSON        = 417,   // 组成员不是2个人
	ERROR_MARRY_NOT_ENGAGED        = 418,   // 未订婚
	ERROR_MARRY_AMITY              = 419,   // 好感度不够
	ERROR_MARRY_POSITION           = 420,   // 组成员不在一块
	ERROR_MARRY_NOT_TEAMLEADER     = 421,   // 申请者不是组长
	ERROR_VOTE_FAILED              = 422,   // 投票结果未通过
	ERROR_FAMILY_LACK_OF_MONEY     = 423,   // 缺少操作所需要的金钱
	ERROR_TEAM_OFFLINE             = 424,   // 组队中有成员不在线
	ERROR_FAMILY_DIFF_LINE         = 425,   // 组队中有成员不在同一条线
	ERROR_FAMILY_LEVEL_LIMIT       = 426,   // 组队中有成员等级不够
	ERROR_FAMILY_FRIENDLY_LIMIT    = 427,   // 组队中有成员之间的好感度不够
	ERROR_FAMILY_MENTOR_LIMIT      = 428,   // 组队中存在师徒关系
	ERROR_FAMILY_HAS_FAMILY        = 429,   // 组队中有成员已经在某个结义中
	ERROR_FAMILY_COOLTIME          = 430,   // 组队中有成员处于结义冷却期
	ERROR_FAMILY_BAD_NAME          = 431,   // 不合法的名字
	ERROR_FAMILY_DUP_NAME          = 432,   // 重复的名字
	ERROR_FAMILY_NOT_TEAMLEADER    = 433,   // 操作人不是组长
	ERROR_FAMILY_MEMBER_LIMIT      = 434,   // 人数超过结义上限
	ERROR_FAMILY_LEADER_NO_FAMILY  = 435,   // 组长不是结义成员
	ERROR_FAMILY_NOT_ALL_ONLINE    = 436,   // 不是所有结义成员都在线
	ERROR_FAMILY_NO_NEW_MEMBER     = 437,   // 没有要新加入的成员
	ERROR_FAMILY_NO_ITEM           = 439,   // 缺少操作所需物品
	ERROR_FAMILY_NOT_MEMBER        = 440,   // 组队中有不是结义成员
	ERROR_FAMILY_NEED_MORE_MEMBER  = 441,   // 需要更多的结义成员在组队中
	ERROR_INSTANCE_NOTFOUND        = 442,   // 副本没有找到
	ERROR_VOTE_TIMEOUT             = 443,   // 投票超时
	ERROR_LOST_CONNECTION          = 444,   // 失去与客户端的连接
	ERROR_TRUSTEE_DUPLICATE        = 445,   // 重复的受托人
	ERROR_TRUSTEE_COUNT_LIMIT      = 446,   // 受托人数超过上限
	ERROR_TRUSTEE_NOTFOUND         = 447,   // 托管关系不存在
	ERROR_TRUSTEE_SELF             = 448,   // 不能指定自己帐号下的角色为受托人
	ERROR_TRUSTEE_PERMISSION       = 449,   // 受托人没有操作权限
	ERROR_TRUSTOR_ONLINE           = 450,   // 委托人正在游戏中
	ERROR_FRIEND_BUFF_INVALID      = 451,   // 发送人没有这个技能或者级别不对
	ERROR_FRIEND_BUFF_SEND1_COOL   = 452,   // 发送冷却中
	ERROR_FRIEND_BUFF_SEND2_COOL   = 453,   // 已达到日发送上限
	ERROR_FRIEND_BUFF_RECV_COOL    = 454,   // 接收冷却中
	ERROR_FRIEND_BUFF_NOT_REMOTE   = 455,   // 非远程技能
	ERROR_FAMILY_VOTE_ERROR        = 456,   // 发起结义内投票失败
	ERROR_FAMILY_VOTE_VOTING       = 457,   // 有同样的结义内投票正在进行
	ERROR_FAMILY_VOTE_VOTING_MAX   = 458,   // 达到同时允许进行的结义内投票上限了
	ERROR_FAMILY_VOTE_VOTED        = 459,   // 个人已经投过票了
	ERROR_FAMILY_POSITION          = 460,   // 组员没有在一块
	ERROR_MARRY_NOTINONETEAM       = 461,   // 夫妻不在同一组
	ERROR_MARRY_NOT_SPOUSE         = 462,   // 一方不是另一方的配偶
	ERROR_FAMILY_VOTE_START        = 463,   // 因某操作而开始投票了，实际上不是错误，是一个中间状态
	ERROR_MARRY_NOT_MARRIED        = 464,   // 未结婚
	ERROR_STOCK_CLOSED             = 465,   // 元宝交易账户已关闭
	ERROR_STOCK_ACCOUNTBUSY        = 466,   // 元宝账户忙
	ERROR_STOCK_INVALIDINPUT       = 467,   // 非法输入
	ERROR_STOCK_OVERFLOW           = 468,   // 元宝或金钱数值溢出
	ERROR_STOCK_DATABASE           = 469,   // 数据库错误
	ERROR_STOCK_NOTENOUGHCASH      = 470,   // 元宝不足
	ERROR_STOCK_MAXCOMMISSION      = 471,   // 超过最大挂单数
	ERROR_STOCK_NOTFOUND           = 472,   // 未找到相关记录
	ERROR_STOCK_CASHLOCKED         = 473,   // 元宝交易已锁定
	ERROR_STOCK_CASHUNLOCKFAILED   = 474,   // 元宝交易解锁失败
	ERROR_STOCK_NOFREEMONEY        = 475,   // 无可取出金钱
	ERROR_STOCK_NOTENOUGHMONEY     = 476,   // 包裹金钱不足
	ERROR_SECT_QUIT_COOLING        = 477,   // 叛师冷却
	ERROR_SECT_EXPEL_COOLING       = 478,   // 开除徒弟冷却
	ERROR_SECT_RECOMMENDED         = 479,   // 已经是该师父的记名弟子了
	ERROR_SECT_TEACH_COOLING       = 480,   // 今天已经教过了
	ERROR_SECT_NOCONSULT           = 481,	// 请教的机会用光了
	ERROR_SECT_NOT_VICE_MENTOR     = 482,	// 被请教者不是记名师父
	ERROR_SECT_UPGRADE_LIMIT       = 483,	// 师德不够，无法升级宗师等级
	ERROR_FRIEND_CANNOT_BLACK      = 484,	// 特殊组中的好友无法加入到黑名单
	ERROR_SECT_RELATION            = 485,	// 无亲友关系，无法推荐徒弟
	ERROR_SECT_NOT_DISCIPLE        = 486,	// 只能鼓励未出师徒弟
	ERROR_HOME_NOTLOADED           = 487,   // 家园数据未加载
	ERROR_HOME_COOLING             = 488,   // 命令冷却中
	ERROR_HOME_TIMEOUT             = 489,   // 超时
	ERROR_HOME_LOCKED              = 490,   // 锁定状态，操作进行中
	ERROR_HOME_UNMARSHAL           = 491,   // 解码数据出错
	ERROR_HOME_INVALIDINPUT        = 492,   // 输入数据非法
	ERROR_HOME_INVALIDSTATE        = 493,   // 非法状态
	ERROR_HOME_PERMISSION          = 494,   // 无操作权限
	ERROR_HOME_OFFLINE             = 495,   // 玩家不在线
	ERROR_HOME_NOTFRIEND           = 496,   // 不是好友
	ERROR_HOME_NOSEED              = 497,   // 种子或幼兽不存在
	ERROR_HOME_NOENOUGHPRODUCEPOINT= 498,   // 生产点不足
	ERROR_HOME_AMBUSH_FULL         = 499,   // 埋伏人数已满
	ERROR_HOME_STOREHOUSE_FULL     = 500,   // 仓库已满
	ERROR_HOME_AMBUSHING           = 501,   // 已处于埋伏状态
	ERROR_HOME_NOFREEPRODUCTS      = 502,   // 没有可收获/偷窃的产物（偷窃时有保留个数限制）
	ERROR_HOME_STEALSELF           = 503,   // 不能偷自已
	ERROR_HOME_STEALAGAIN          = 504,   // 再次偷窃
	ERROR_HOME_STEALCAUGHT         = 505,   // 偷窃被抓
	ERROR_HOME_FRUITPROTECTED      = 506,   // 果实处于采摘保护期
	ERROR_HOME_PRODUCESKILL        = 507,   // 所需生产技能或技能等级不符合要求
	ERROR_HOME_NOTENOUGHPACKSPACE  = 508,   // 非安全区或包裹空间不足，物品已经存入系统邮件中，请自行取出
	ERROR_HOME_NO_ENOUGH_FORAGE    = 509,   // 饲料不足
	ERROR_HOME_TOO_MANY_FORAGE     = 510,   // 饲料过多
	ERROR_HOME_INVALID_ACTION      = 511,   // 非法操作
	ERROR_HOME_PLOT_NOT_FREE       = 512,   // 地块非空
	ERROR_HOME_CAPACITY            = 513,   // 超过容量限制
	ERROR_HOME_PLOT_INACTIVE       = 514,   // 地块未开放
	ERROR_HOME_PLOT_BLESSED        = 515,   // 地块已被祈福
	ERROR_FACTION_BAD_NAME         = 516,   // 非法名
	ERROR_FACTION_DUP_NAME         = 517,   // 重名
	ERROR_FACTION_MONEY            = 518,   // 钱不够
	ERROR_FACTION_SERVER           = 519,   // 服务器内部错误
	ERROR_FACTION_FULL             = 520,   // 帮派人数达到上限
	ERROR_FACTION_PERMISSION       = 521,   // 没有权限
	ERROR_FACTION_REFUSED          = 522,   // 对方拒绝
	ERROR_FACTION_LEVEL_MAX        = 523,   // 已经升到最高级
	ERROR_FACTION_COST             = 524,   // 升级所需资源不足
	ERROR_FACTION_TMP_MEMBER       = 525,   // 挂名成员不能任免
	ERROR_FACTION_UNAVAILABLE      = 526,   // 职位有人
	ERROR_FACTION_SUBFACTION       = 527,   // 分舵状态不对
	ERROR_FACTION_SPOUSE           = 528,   // 因配偶有职务而不能任免
	ERROR_FACTION_WRONG_POSITION   = 529,   // 无效职位
	ERROR_FACTION_EXPEL_COOLING    = 530,   // 踢人冷却
	ERROR_FACTION_HAS_FACTION      = 531,   // 被加者已经有帮派
	ERROR_GRADE_INVALIDLEVEL       = 532,   // 玩家不在任何同等级频道中
	ERROR_SHARE_EXPIRE             = 533,   // 祝福过期失效	
	ERROR_SHARE_FULL               = 534,   // 非好友祝福已满
	ERROR_SHARE_GRADE              = 535,   // 等级区间不符
	ERROR_SHARE_AGAIN              = 536,   // 已经祝福过了
	ERROR_SHARE_SELF               = 537,   // 不能祝福自己
	ERROR_SHARE_INVALID            = 538,   // 无效的祝福
	ERROR_DEL_ROLE_FAMILY          = 539,   // 已结义的角色不能删除
	ERROR_DEL_ROLE_FACTION         = 540,   // 加入帮派的角色不能删除
	ERROR_DEL_ROLE_DISCIPLE        = 541,   // 未出师的角色不能删除
	ERROR_DEL_ROLE_MENTOR          = 542,   // 已收徒的角色不能删除
	ERROR_DEL_ROLE_MARRIAGE        = 543,   // 已结婚的角色不能删除
	ERROR_INVENTORY_FULL           = 544,   // 包裹已满
	ERROR_INVENTORY_BIND_MONEY_FULL= 545,   // 银票携带数已达上限
	ERROR_INVENTORY_TRADE_MONEY_FULL=546,   // 银子携带数已达上限
	ERROR_HOME_BLESS_NO_CHANCES    = 547,   // 无祈福机会
	ERROR_HOME_CLOSED              = 548,   // 家园模块未开启
	ERROR_SECT_FAMILY              = 549,   // 结义关系不能拜师
	ERROR_SNS_QUALITY              = 550,   // 没有资格发此征友信息
	ERROR_SNS_EXISTED              = 551,   // 已经发过此征友信息了
	ERROR_SNS_NOTFOUND             = 552,   // 找不到征友信息
	ERROR_FAMILY_CREATE_WAIT       = 553,   // 创建结义/添加成员操作还在等待队员反馈
	ERROR_FAMILY_APPLY             = 554,	// 结义其他成员已经申请
	ERROR_LESS_LEVEL               = 555,	// 玩家等级太低
	ERROR_GREATER_LEVEL            = 556,	// 玩家等级过高
	ERROR_NO_FAMILY                = 557,	// 玩家不属于任何结义
	ERROR_IN_ALLIANCE_WAR          = 558,	// 盟主战进行中
	ERROR_ALLIANCE_MONEY           = 559,	// 盟主金不足
	ERROR_CANNOT_SPECTATE          = 560,	// 不能进行观战
	ERROR_ALLIANCE_CANNT_APPLY     = 561,	// 现在不能申请盟主战
	ERROR_ALLIANCE_MAX_FAMILY      = 562,	// 申请参战的结义达到上限
	ERROR_FAMILY_LEAGUE            = 563,	// 盟主所在结义
	ERROR_ALLIANCE_CANNT_START     = 564,	// 盟主战尚未开始
	ERROR_ALLIANCE_WAR_NO_APPLY    = 565,	// 没有申请盟主战
	ERROR_FAMILY_IN_ALLIANCE_WAR   = 566,	// 结义正在盟主战中，不能投票
	ERROR_NOT_LEAGUE               = 567,	// 没有盟主权限
	ERROR_LEAGUE_MONEY_LIMIT       = 568,	// 盟主取钱数达到上限
	ERROR_LEAGUE_COOLDOWN          = 569,	// 盟主权限冷却时间内
	ERROR_FACTION_LEVEL_MIN        = 570,	// 贵帮规模太小，不足以开宗立派。
	ERROR_FACTION_BASE_MONEY       = 571,	// 这可是近百亩的一整块地呢，区区**元宝，可真不算贵
	ERROR_FACTION_BASE_ERROR       = 572,	// 不好意思，这周围的地皮都被其他武林玩家购买了
	ERROR_FACTION_TEAM             = 573,	// 在江湖里没点朋友，建立帮会可不是好玩的
	ERROR_FACTION_MEMBER_LESS_LEVEL= 574,	// 创建队伍中其他玩家等级过低
	ERROR_FACTION_MEMBER_FRIEND    = 575,	// 创建帮派互为好友，且好友度达到要求
	ERROR_FACTION_NOT_READY        = 576,	// 帮派数据未准备好
	ERROR_FACTION_MERGEREQ_INVALID = 577,	// 帮派合并请求失败
	ERROR_FACTION_STATUS_CANNOTDO  = 578,	// 帮派当前状态不能进行此操作
	ERROR_FACTION_MERGEREQ_AGREE   = 579,	// 对方同意合帮
	ERROR_FACTION_MERGEREQ_DISAGREE= 580,	// 对方不同意合帮
	ERROR_FACTION_MERGEVOTE_FAILED = 581,   // 发起投票失败
	ERROR_FACTION_DB_WAIT          = 582,	// 数据库忙，暂时无法服务
	ERROR_FACTION_STATE            = 583,	// 帮派状态不错错误
	ERROR_FACTION_MAX_COUNT        = 584,	// 帮派数已满，不能创建新帮派
	ERROR_FACTION_TIMEOUT          = 585,	// 帮派建立超时
	ERROR_FACTION_INVALID_DATA     = 586,	// 帮派数据错误
	ERROR_FACTION_ITEM             = 587,   // 物品不齐
	ERROR_FACTION_NOTFOUND         = 588,	// 没有找到相应的帮派
	ERROR_FACTION_NO_BASE          = 589,	// 帮派没有基地
	ERROR_FACTION_MAX_SUB          = 590,	// 帮派分舵数已满
	ERROR_FACTION_GETPARA	       = 591,	// 获取帮派协议参数错误	
	ERROR_FACTION_DOWORKCOOLDOWN   = 592,	// 还未冷却，不能打工
	ERROR_FACTION_DOWORKSTATUS     = 593,	// 当前状态不能打工
	ERROR_ROLE_NOFACTION           = 594,	// 玩家没有加入帮派
	ERROR_FACTION_APPLIED          = 595,	// 已经申请
	ERROR_FACTION_INMERGE	       = 596,	// 帮派已经在合并过程中
	ERROR_FACTION_MERGEVOTE_NOTPASS= 597,	// 合并投票未通过
	ERROR_FACTION_MERGEVOTE_WAIT   = 598,	// 合并投票通过，待对方帮派投票确认
	ERROR_FACTION_VOTE_OPEN        = 599,	// 投票开通失败
	ERROR_FACTION_MERGE_MAX        = 600,	// 合并人数过多
	ERROR_FACTION_SUB_COOLDOWN     = 601,	// 解除分舵冷却时间
	ERROR_FACTION_CONTRIBUTAION    = 602,	// 帮派建设度不足
	ERROR_FACTION_CLUB             = 603,	// 帮派协作值不足
	ERROR_FACTION_INVALIDHIREREQ   = 604,	// 非法打工请求
	ERROR_FACTION_APPLYCOOLDOWN    = 605,	// 申请加入帮派冷却
	ERROR_FACTION_STOREFULL	       = 606,	// 帮派仓库已满
	ERROR_FACTION_REBELTIMEFAILED  = 607,	// 篡权时间不符合条件
	ERROR_FACTION_SUB_FACTION      = 608,	// 已经在这个帮建立了分舵
	ERROR_FACTION_TEMPLATE	       = 609,	// 帮派模板数据不正确
	ERROR_FACTION_BASE_ACTIVITY    = 610,	// 帮派基地将因为活跃度不足关闭
	ERROR_FACTION_BASE_CLOSED      = 611,	// 帮派基地关闭
	ERROR_FACTION_BASE_MEMBERS     = 612,	// 帮派基地将因为成员不足关闭
	ERROR_FACTION_ACTIVITYOPEN     = 613,   // 帮派有活动已经开启
	ERROR_FACTION_ACTIVITYEND      = 614,   // 帮派有活动已经结束
	ERROR_FAMILY_CALL_MISS         = 615,	// 有成员在特殊区域无法响应结义召集
	ERROR_STOCK_TXNCOOLING         = 616,   // 事务操作冷却中

	ERROR_TEAM_IN_INSTANCE         = 630,	// 队伍已经开启了一个副本
	ERROR_NOT_ENOUGH_MEMBER        = 631,	// 队伍人数不足
	ERROR_CREATE_INSTANCE          = 632,	// 创建副本失败
	ERROR_INSTANCE_TIME            = 633,   // 副本返回时间限制
	ERROR_INSTANCE_BOARD           = 634,	// 副本版面限制
	ERROR_INSTANCE_CLOSE           = 635,	// 副本关闭
	ERROR_INSTANCE_PLAYER_CANCEL   = 636,	// 玩家自己关闭管理面板
	ERROR_INSTANCE_MAX_TIMES       = 637,	// 玩家超过进入副本次数上限

	ERROR_HOME_NO_FREE_SPACE       = 640,	// 家园地图已满
	ERROR_HOME_INTERNAL            = 641,   // 家园内部错误
	ERROR_HOME_EXIST               = 642,	// 已有家园
	ERROR_HOME_NO_HOME             = 643,	// 没有家园
	ERROR_HOME_SCENE               = 644,	// 家园地图错误
	ERROR_HOME_BUILD_POINT         = 645,	// 建设度不足
	ERROR_HOME_RESOURCE            = 646,	// 资源不足
	ERROR_HOME_DUPLICATE           = 647,	// 重复
	ERROR_HOME_LEVEL               = 648,	// 家园或者建筑等级错误

	ERROR_FCITY_NOKINGAPPLYSUCCESS = 659,	//无龙头地图申请分舵成功
	ERROR_FCITY_DB_CORRUPT	       = 660,	//数据库一致性错误
	ERROR_FCITY_DB_SUBADD_EXIST    = 661,	//该帮在本地图已经有分舵或总舵
	ERROR_FCITY_SERVER	       = 662,	//帮派势力服务器错误
	ERROR_FCITY_APPLYEXIST	       = 663,	//该帮派的分舵申请已经存在
	ERROR_FCITY_APPLYFULL          = 664,	//势力地图分舵信息已满
	ERROR_FCITY_NOTFOUND           = 665,	//帮派势力地图不存在
	ERROR_FCITY_SUBEXIST           = 666,	//该分舵已经存在
	ERROR_FCITY_SUBNOTEXIST        = 667,	//该地图不存在该分舵
	ERROR_FCITY_MAINEXIST          = 668,	//该总舵已经存在
	ERROR_FCITY_MAINNOTEXIST       = 669,	//该地图不存在该总舵
	ERROR_FACTION_CITYEXIST        = 670,	//该帮已有此势力地图
	ERROR_FACTION_CITYNOTEXIST     = 671,	//该帮没有该势力地图
	ERROR_FACTION_CITYFULL         = 672,	//该帮势力地图数量已满
	ERROR_FACTION_INVALIDCITYNUM   = 673,	//帮派已有的势力地图数目不合法
	ERROR_FACTION_INITCITY         = 674,	//初始势力地图
	ERROR_FCITY_AUCPRICE_LESS      = 675,	//出价太少
	ERROR_FCITY_AUCTIONCLOSE       = 676,	//拍卖结束
	ERROR_FCITY_DB_RELOAD	       = 677,	//需要重导数据
	ERROR_FACTION_AUCTIONPOINT_LESS = 678,	//竞拍点太少了
	ERROR_FACTION_APDONATED	       = 679,	//每天只能捐一次
	ERROR_FACTION_APMASTERNAME     = 680,	//受益方帮主名不相符合
	ERROR_FCITY_SUBFULL	       = 681,	//势力地图分舵已满
	ERROR_FCITY_MAINFULL	       = 682,	//势力地图总舵已满
	ERROR_FCITY_NOTOPEN	       = 683,	//势力地图未开放
	ERROR_FCITY_NOTINAUC	       = 684,	//势力地图当前没有处于拍卖状态中
	ERROR_FCITY_WEIGHTVALID	       = 685,	//势力地图设置权重数据不合法
	ERROR_FCITY_SUBINPROTECT       = 686,	//该分舵处于保护期不能删除
	ERROR_FCITY_AUCPRICE_TWICE     = 687,	//势力地图竞拍帮派重复出价
	ERROR_FACTION_CITYCONSLESS     = 688,	//开拓势力时建设度不够
	ERROR_FCITY_FACTIONFULL	       = 689,	//势力地图可容纳的帮派数已满
	ERROR_FCITY_POWERLESS	       = 690,	//势力地图开放所需要的新势力不够
	ERROR_FACTION_NOMAIN	       = 691,	//总舵搬迁时，源势力地图没有总舵
	ERROR_FACTION_NOSUB	       = 692,	//总舵搬迁时，目的势力地图没有分舵
	ERROR_FACTION_AUCNOBASE        = 693,	//没有基地的帮派不允许竞拍
	ERROR_TEAM_MEMBER_TOO_FAR      = 694,	//队伍成员离的太远
	ERROR_FACTION_NOTNEARCITY      = 695,	//非临近势力地图，不能申请

	ERROR_AUCTION_PRICE            = 700,	//拍卖价格不满足条件
	ERROR_AUCTION_TYPE             = 701,	//拍卖类型不满足条件
	ERROR_AUCTION_NONE             = 702,	//当前没有拍卖
	ERROR_AUCTION_NOT_START        = 703,	//拍卖未开启
	ERROR_AUCTION_BID_TWICE        = 704,	//重复出价

	ERROR_MINGXING_EMPTY           = 711,	//没有该明星或者明星没有形象备份
	ERROR_MINGXING_NO_CHANGE       = 712,	//明星形象没有变化

	ERROR_LIST_END			= 721,	//到达列表结尾
	ERROR_LIST_WRONG_TYPE		= 722,	//列表类型错误
	ERROR_LIST_ABATE_DATA		= 723,	//失效数据
	ERROR_WRONG_KEY			= 724,	//索引查询错误

	ERROR_ENOUGH_REPU		= 730,	//没有足够的残页
	ERROR_WRONG_ENEMY		= 731,	//选择的对手不存在

	ERROR_DST_ZONE_DISCONNECT	= 740,	//漫游目标服务器无法连接
	ERROR_ZONE_NOT_REGISTER		= 741,	//当前服务器没有注册
	ERROR_HUB_SERVER_DISCONNECT	= 742,	//漫游目标服务器无法连接HUB服务器
	ERROR_WRONG_ZONE_ROAM		= 743,	//目标服务器错误
	ERROR_ROAM_TIMEOUT		= 744,	//漫游超时
	ERROR_ROAM_ROLE_NOTFOUND	= 745,	//漫游角色数据查找失败
	ERROR_ROAM_WRONG_STATUS		= 746,	//错误的角色状态
	ERROR_ROAM_DECODE		= 747,	//漫游角色数据加载错误
	ERROR_ROAM_GENERAL		= 748,	//漫游通用错误
	ERROR_ROAM_KICKOUT		= 749,	//漫游状态错误，踢掉
	ERROR_ROAM_SPECIAL_CMD		= 750,	//通知GS下线，且不存盘
	ERROR_ROAM_SAVE_STATUS		= 751,	//漫游角色正在下线
	ERROR_ROAM_NETWORK		= 752,	//网络错误，可能需要重新存盘
	ERROR_ROAM_STATUS		= 753,	//玩家正在漫游状态
	ERROR_WRONG_DST_ZONE		= 754,	//选择了错误的服务器
	ERROR_WRONG_HUB_PROTOCOL	= 755,	//错误的跨服协议
	ERROR_ROLEID_STATUS		= 756,	//玩家数据错误
	ERROR_HUB_TIMEOUT		= 757,	//跨服转发数据超时
	ERROR_ROAM_RECONNECT		= 758,	//跨服连接断开重连
	ERROR_ROAM_OTHER_ROLE		= 759,	//登陆了其他角色

	ERROR_TIGUAN_ALREADY		= 780,	//今天已经踢过了
	ERROR_TIGUAN_ING		= 781,	//目标帮派正在被踢中
	ERROR_TIGUAN_NOT_KING		= 782,	//目标帮派非龙头
	ERROR_TIGUAN_NOT_FULL		= 783,	//目标城市总舵未满
	ERROR_TIGUAN_CANT_ENTER		= 784,	//目标基地正在踢馆，无法进入
	ERROR_TIGUAN_SRCNOMAIN		= 785,	//踢馆方在源势力地图没有总舵
	ERROR_TIGUANED_SRCNOMAIN	= 786,	//被踢馆方在源势力地图没有总舵
	ERROR_TIGUAN_DSTNOSUB		= 787,	//踢馆方在目的势力地图没有分舵
	ERROR_TIGUANED_DSTNOSUB		= 788,	//被踢馆方在目的势力地图没有分舵
	ERROR_TIGUAN_SUB_NOTNEARCITY	= 789,	//踢馆方势力地图同申请通行的势力地图不接壤
	ERROR_TIGUANED_SUB_DSTNOTKING	= 790,	//被踢馆方不是申请通行的势力地图的龙头
	ERROR_TIZI_HASEXIST		= 791,	//涂鸦板上已经有内容
	ERROR_TIZI_NOTEXIST		= 792,	//涂鸦板上没有内容
	ERROR_FACTION_TIZINOTTIGUAN	= 793,	//贵帮不是踢馆发起者，不能题字
	ERROR_TIGUANED_NODST		= 794,	//被踢馆方的总舵无处可搬了
	ERROR_FACTION_TIZICOOLDOWN	= 795,	//题字冷却

	ERROR_MATCH_DISABLE             = 811,  //匹配功能已关闭
	ERROR_MATCH_ING                 = 812,  //[队伍有]玩家已经在匹配中了
	ERROR_MATCH_NO_TEAM             = 813,  //组队匹配但没有队伍
	ERROR_MATCH_NOT_TEAM_LEADER     = 814,  //组队匹配需要队长发起
	ERROR_MATCH_WRONG_POS           = 815,  //必须在 大世界+安全区 才能匹配
	ERROR_MATCH_CANT_ENTER          = 816,  //不满足进副本的条件
	ERROR_MATCH_OFFLINE             = 817,  //队伍中有玩家不在线
	ERROR_MATCH_TEAM_PROF           = 818,  //队伍中已有重复职业
	ERROR_MATCH_FULL_TEAM           = 819,  //已满员队伍就别来搀和了
	ERROR_MATCH_NOT_OPEN		= 820,  //活动时间没开

	ERROR_ADD_CASH_REPEAT		= 831,  //重复的AddCash命令
	ERROR_MUCH_PENDING_ORDER	= 832,  //未完成充值太多

	ERROR_INVALID_ACTIVE_CODE	= 841,  //无效激活码
	ERROR_USED_ACTIVE_CODE		= 842,  //使用过的激活码
	ERROR_USER_NEED_ACTIVE		= 843,  //帐号需要激活
	ERROR_CLOSE_DELETE_ROLE         = 844,  //删号功能已经关闭，无法删除角色




	ERROR_HAVE_BANGHUI         	= 900,  //已经有帮会了，无法申请其余帮会
	ERROR_APPLY_BANGHUI_MAX         = 901,  //申请帮会的个人达到了上限
	ERROR_APPLY_BANGHUI_WRONG       = 902,  //帮会不存在
	ERROR_NOT_IN_APPLY_BANGHUI      = 903,  //不在这个帮派的申请列表
	ERROR_DONOT_HAVE_BANGHUI        = 904,  //没有帮会
	ERROR_DONOT_HAVE_YOU_INBANGHUI  = 905,  //你所在的帮会成员里面没有你
	ERROR_DONOT_HAVE_POWER          = 906,  //没有帮会权限
	ERROR_BANGHUI_FULL	        = 907,  //帮派人数满了，无法加人
	ERROR_NOT_IN_BANGHUI            = 908,  //已经不在申请列表中了
	ERROR_DONOT_IN_YOUR_BANGHUI    	= 909,  //不在你的帮会里面
	ERROR_DONOT_FIND_BANGHUI        = 910,  //没有符合你查找条件的帮会
	ERROR_CANNOT_CREATE_BANGHUI     = 911,  //已经有帮会了，无法创建帮会
	ERROR_YOU_NOTIN_BANGHUI         = 912,  //你没有帮会
	ERROR_NOTIN_APPLY               = 913,  //你不是这个帮会的申请成员
	ERROR_HAVE_IN_APPLY             = 914,  //你已经是这个帮会的申请成员了
	ERROR_NOTICE_TOO_LONG           = 915,  //公告设置太长
	ERROR_BANGHUI_NUM_FULL          = 916,  //帮派数量达到上限
	ERROR_BANGHUI_NOT_IN_MANAGER    = 917,  //管理器中没有帮会ID
	ERROR_BANGHUI_CAN_NOT_DELETE    = 918,  //当前有帮会无法删号
	ERROR_BANGHUI_HAVE_BANGHUI_APPLY  = 919,  //已经有帮会了
	ERROR_BANGHUI_INVITE_NOTONLINE  = 920,  //被邀请的玩家不在线
	ERROR_BANGHUI_CANNOT_INVITE     = 921,  //你无法邀请别人加入帮会
	ERROR_BANGHUI_INVITE_HAVE       = 922,  //别邀请的玩家有帮会了
	ERROR_BANGHUI_HAVE_INVITED      = 923,  //已经邀请了这个玩家
	ERROR_BANGHUI_DEFUSE_INVITE     = 924,  //拒绝邀请
	ERROR_BANGHUI_NOT_IN_INVITE     = 925,  //没有被邀请
	ERROR_BANGHUI_INVITE_HAVE_BANGHUI     = 926,  //你已经有帮会了，无法再次接受邀请
	ERROR_BANGHUI_NAME_TOO_LONG     = 927,  //帮会名字太长
	ERROR_BANGHUI_LEVEL_TOO_LOW     = 928,  //等级不足
	ERROR_BANGHUI_INVITE_LEVEL_LOW  = 929,  //被邀请的人等级不足
	ERROR_BANGHUI_NAME_INVILAD      = 930,  //帮会的名字非法
	ERROR_BANGHUI_NAME_SAME         = 931,  //这个帮会已经存在，请换一个名字
	ERROR_BANGHUI_YUANBAO_LESS      = 932,  //元宝不足
	ERROR_BANGHUI_OPERATOR_FAST     = 933,  //操作太快
	ERROR_BANGHUI_FUBANGZHU_MAX     = 934,  //副帮主人数达到上限
	ERROR_BANGHUI_IS_FUBANGZHU      = 935,  //已经是副帮主了
	ERROR_BANGHUI_IS_BANGZHONG      = 936,  //已经是帮众了
	ERROR_BANGHUI_LEAVE_CD          = 937,  //离开上一个帮会不足22小时，还无法加入新的帮会
	ERROR_BANGHUI_TOP_LIST_LAST     = 938,  //帮会排行榜达到最后一页了
	ERROR_BANGHUI_APPLY_IS_FULL     = 939,  //帮会排行榜达到最后一页了
	ERROR_BANGHUI_NOT_IN_TIGUAN_TIME     = 940,  //当前不在可以踢馆的时间之内
	ERROR_BANGHUI_CREATE_72_HOURS_ATT     = 941,  //你的帮会建立时间不足72小时
	ERROR_BANGHUI_CREATE_72_HOURS_DEF     = 942,  //你踢馆的帮会建立时间不足72小时
	ERROR_BANGHUI_TIGUAN_NUM_MAX     = 943,  //踢馆数量达到上限
	ERROR_BANGHUI_TIGUAN_REPEATED    = 944,  //你已经对别的帮会进行了踢馆
	ERROR_BANGHUI_TIGUAN_NOT_IN_TIME = 945,  //不在踢馆时间内
	ERROR_BANGHUI_TIGUAN_NO_DEFENCE  = 946,  //没有帮会踢馆你们
	ERROR_BANGHUI_TIGUAN_NO_ATTACK   = 947,  //你们没有对别的帮会进行踢馆
	ERROR_BANGHUI_TIGUAN_JOIN_TIME   = 948,  //加入帮会不足一天，不可以进行踢馆
	ERROR_BANGHUI_TIGUAN_DEFENCE_FULL   = 949,  //帮会防御的人数已经达到上限
	ERROR_BANGHUI_TIGUAN_ATTACK_FULL   = 950,  //帮会进攻的人数已经达到上限

	ERROR_ARENA_NO_COST_CHANCE	= 951,  //竞技场收费挑战次数已经用光
	ERROR_ARENA_OUT_OF_CASH		= 952,  //元宝不足以支付竞技场收费挑战
	ERROR_ARENA_NOT_VIP		= 953,  //vip等级不足，不能购买竞技场收费次数
	ERROR_DB_MAIL_ITEM_EXIST        = 954,  //邮件发送奖励，单号已经存在

	ERROR_SERVER_PREPARING		= 961,	//服务器未开放(客户端收到会断开连接)

	ERROR_BANGHUI_TIGUAN_DISMISS   = 990,  //踢馆期间不可以解散帮会
	ERROR_BANGHUI_TIGUAN_JOINING   = 991,  //踢馆正在进行中
	ERROR_BANGHUI_AUTO_APPLY_NO    = 992,  //一键申请没有申请到帮会

	ERROR_SERVER_STATUS1		= 1001,  //尚未开服，请12点再来
	ERROR_SERVER_STATUS2		= 1002,  //尚未开服，请稍候再来
	ERROR_SERVER_STATUS3		= 1003,  //维护中
};

enum
{
	PLAYER_GENDER_MALE = 0, // 男性
	PLAYER_GENDER_FEMALE = 1, // 女性
};

enum VOTE_RESULT
{
	VOTE_RE_AGREE = 0, // 同意
	VOTE_RE_DISAGREE = 1, // 不同意
	VOTE_RE_MUTE = 2, // 弃权
};

enum PLAYER_MESSAGE_ID
{
	PMID_PEEK_YOUR_PROFILE	= 1, // 有人在查看你的名片
	PMID_FAMILY_CREATE	= 2, // 建立结义
	PMID_FAMILY_ADD		= 3, // 结义加人
	PMID_FAMILY_CHANGENAME  = 4, // 结义改名
	PMID_FAMILY_NICKNAME	= 5, // 改个人结义名
	PMID_FAMILY_EXPEL	= 6, // 结义开人
	PMID_MARRIAGE_MARRY	= 7, // 结婚成功
	PMID_MARRIAGE_PROPOSE	= 8, // 订婚成功
	PMID_HOME_ACTION	= 9, // 家园操作
	PMID_PEEK_YOUR_EQUIP	= 10,//有人查看你的装备
	PMID_HOME_BUY		= 11,//获取家园成功
};

enum GROUP_SERVER_ID
{
	GSI_INVALID		= 0,	//不可用
	GSI_FACTION_MASTER	= 1,	//帮主群

	GSI_COUNT,
};

enum REPUTATION_ID
{
	REPUID_CHARM		= 0,	// 社交魅力
	REPUID_FAME		= 1,	// 社交名望
	REPUID_SECT		= 2,	// 师德
	REPUID_LIVE		= 3,	// 生活名望
	REPUID_WULIN		= 4,	// 武林声望
	REPUID_PK		= 5,	// PK声望
	REPUID_DISPLAY_MAX	= 16,	// 最多可见
	REPUID_SECT_HIDE	= 16,	// 师德相关，隐藏
	REPUID_FACTION_CONTRIBUTION = 22,	// 帮派贡献度累计值
	REPUID_FACTION_CONTRIBUTION2 = 23,	// 帮派贡献度当前值
	REPUID_PROF_OFFSET	= 25,	// 此数值+门派id就是门派贡献值的index，如少林是26
	REPUID_FUZHOU		= 37,	//福州城声望
	REPUID_HENGSHAN		= 38,	//衡山城声望
	REPUID_LUOYANG		= 39,	//洛阳城声望
	REPUID_GENEROUS		= 43,	// 善值
	REPUID_BATTLE_MONEY	= 44,	// 竞技币
	//51 - 90 武学残叶
	REPUID_FACTION_CREATE_START = 95,	// 帮派创建后增加声望范围
	REPUID_FACTION_CREATE_END = 104,	// 帮派创建后增加声望范围
	REPUID_JUEWEI		= 110,	// 爵位排名声望

	REPUID_SWEEP_DAILY_FREE = 161,	//当日免费闯关次数
	REPUID_SWEEP_DAILY_CASH	= 162,	//当日付费闯关次数
	REPUID_SWEEP_HISTORY 	= 163,	//闯关历史最大版面
	REPUID_ZONE_RENOWN_USED	= 171,	// 世界威名	累计值
	REPUID_ZONE_RENOWN	= 172,	// 世界威名	当前值
	REPUID_ZONE_ROAM_MONEY	= 173,	// 漫游世界财富
	REPUID_ZONE_ROAM_TIME	= 174,	// 漫游时间
	REPUID_ZONE_KILLS	= 177,	// 本次漫游连续杀人数或者连续杀漫游者数
	REPUID_ZONE_ALL_KILLS	= 178,	// 本次漫游总杀人数
	REPUID_ZONE_MAX_KILLS	= 179,	// 本次漫游最高连杀数
	REPUID_YUHANG		= 192,	// 余杭声望
	REPUID_NANJIANG		= 193,	// 南疆声望

	REPUID_MAX		= 256,	// 最多
};

enum REPUTATION_CONSTANT
{
	REPUTATION_VERSION	= 0x03,
	MIN_REPUTATION_VALUE	= 0,
	MAX_REPUTATION_VALUE	= 200000000,
	FORCE_INT		= 0x7fffffff,
};

inline bool IsDeliverReputation(unsigned short id) //deliver负责保存的声望
{
	if(id >= 51 && id <= 90) return true;	//武学残页
	return false;
}

inline bool IsGsReputation(unsigned short id) //gs负责保存的声望
{
	if(IsDeliverReputation(id)) return false;
	return true;
}

//NOTE: 声望不能在月清和非月清之间摇摆, 要存盘的!
inline bool IsMonthClearReputation(unsigned short id) //月清声望列表
{
	if(id == GNET::REPUID_JUEWEI)
		return true;
	return false;
}

inline bool IsPeriodReputation(unsigned short id) //月清日清等类型的声望
{
	if (IsMonthClearReputation(id))
		return true;
	//...
	return false;
}

inline int GetMonthClearReputationDelay(unsigned short id)
{
	if(id == GNET::REPUID_JUEWEI)
		return (6-1)*86400 + 0*3600 + 0*0; //爵位声望每月6日0点0分清零
	return 0;
}

// 结义内投票
enum FAMILY_VOTE_REASON
{
	FAMILY_VOTE_RS_CHANGE_NAME = 0,	// 改结义名
	FAMILY_VOTE_RS_EXPEL_MEMBER,	// 开除成员
	FAMILY_VOTE_RS_GLAD_BIRTH,	// 成员生日（以下不是投票而是喜事）
	FAMILY_VOTE_RS_GLAD_MARRY,	// 成员结婚
	FAMILY_VOTE_RS_GLAD_FACTION,	// 成员建立帮派
	FAMILY_VOTE_RS_GLAD_TOP,	// 成员上排行榜
	FAMILY_VOTE_RS_COUNT,	// 理由数
};
enum FAMILY_VOTE_STATUS
{
	FAMILY_VOTE_ST_VOTING = 0,	// 投票中
	FAMILY_VOTE_ST_AGREED = 1,	// 投票结束，通过
	FAMILY_VOTE_ST_DISAGREED = 2,	// 投票结束，拒绝
	FAMILY_VOTE_ST_GLAD = 3,	// 喜事，不是投票
};
enum FAMILY_VOTE_EVENT
{
	FAMILY_VOTE_EVT_NEW = 0,	// 开始新投票
	FAMILY_VOTE_EVT_REPLY = 1,	// 有人投票
	FAMILY_VOTE_EVT_END = 2,	// 投票结束
	FAMILY_VOTE_EVT_DEL = 3,	// 删除条目
};
enum TITLE_INDEX
{
	TITLE_INDEX_NULL = 0,	// 不使用title
	TITLE_INDEX_MARRIAGE_GROOM = 1,	// 给新郎的称号，比如***的相公
	TITLE_INDEX_MARRIAGE_BRIDE = 2,	// 给新娘的称号，比如***的娘子
	TITLE_INDEX_FAMILY = 3,	// 使用结义title
	TITLE_INDEX_SECT = 4,	// 使用师徒title
	TITLE_INDEX_FACTION_POS = 5,	// 使用帮派职位title
	TITLE_INDEX_FACTION_TI = 6,	// 使用帮派荣誉身份title

	TITLE_INDEX_NORMAL_BEGIN = 1000,	// 普通title的起始id
};

enum SECT_STATUS
{
	SECT_STATUS_NULL = 0,	// 还没有拜师
	SECT_STATUS_DISCIPLE = 1,	// 当徒弟了
	SECT_STATUS_GRADUATE = 2,	// 出师了
	SECT_STATUS_MENTOR = 3,	// 收徒了，即使有师傅也是出师状态
};

enum SECT_QUIT_REASON
{
	SECT_QUIT_REASON_EXPEL = 0,	// 被驱逐
	SECT_QUIT_REASON_QUIT = 1,	// 叛师
	SECT_QUIT_REASON_GRADUATE = 2,	// 出师
};

enum
{
	SECT_DISCIPLE_LEVEL_LIMIT = 50,	// 徒弟等级上限
	SECT_MENTOR_LEVEL_LIMIT = 50,	// 师父等级下限
	SECT_VICE_MENTOR_MAX = 6,	// 徒弟最多有几个记名师父
	SECT_OFFLINE_SAFE_TIME = 72 * 3600,	// 多久不上线可被无责任开除
	SECT_TEACH_AMITY = 20,		// 教徒弟互相增加友好度
	SECT_CONSULT_AMITY = 3,		// 请教记名师父增加友好度
	SECT_CONSULT_REPUTATION = 5,	// 请教记名师父增加善值
};

enum
{
	// 修改好友分组 id 时必须修? FriendManager::ValidUserGroup/ValidSysGroup
	FRIEND_GROUP_SPOUSE = 0x8000,	// 结婚
	FRIEND_GROUP_FAMILY = 0x4000,	// 结义
	FRIEND_GROUP_SECT = 0x2000,	// 师徒组：师父、记名师父、弟子

	FRIEND_GROUP_SYS_MASK = 0xff00,
	FRIEND_GROUP_USER_MASK = 0x00ff,
};

enum BUFF_ADD_REASON
{
	BUFF_ADD_BY_FAMILY_CREATE = 0,	// 结义成功
	BUFF_ADD_BY_SECT_QUIT = 1,	// 叛离师门
	BUFF_ADD_BY_SECT_EXPEL = 2,	// 逐出弟子
	BUFF_ADD_BY_SECT_ENCOURAGE1 = 3,	// 师父鼓励弟子
	BUFF_ADD_BY_SECT_ENCOURAGE2 = 4,	// 记名师父鼓励弟子
};

enum TITLE_ADD_REASON
{
	TITLE_ADD_BY_SECT_EXPEL = 0,	// 逐出弟子
	TITLE_ADD_BY_HOME_STEAL_CAUGHT = 1, // 家园偷窃被抓
};

enum ALLOC_NAME_CATEGORY
{
	ALLOC_FACTION_NAME = 1,
	ALLOC_BANGHUI_NAME = 2,
};

enum PLAYER_FACTION_STATE
{
	PAS_ACTIVITY		= 0x01,	// 活跃
	PAS_FACTION_ACTIVITY	= 0x02,	// 帮派活跃
	PAS_LEAVE_FACTION	= 0x04,	// 离开帮派 (ds->gs)

	PAS_JOIN_FACTION	= 0x20,	// 加入帮派 (ds->gs)

	PAS_GS_MASK		= 0,
	PAS_DS_MASK		= PAS_ACTIVITY | PAS_FACTION_ACTIVITY | PAS_LEAVE_FACTION | PAS_JOIN_FACTION,
};

enum FACTION_DS_SYNC_MASK
{
	FDSM_MEMBER		= 0x01,	//同步玩家数据
	FDSM_LEVEL		= 0x02,	//等级
	FDSM_VALUE		= 0x04,	//普通数据
	FDSM_SUBFACTION		= 0x08,	//分舵数据
	FDSM_PARTNER		= 0x10,	//合作帮派数据
	FDSM_CLOSEBASE		= 0x20,	//完全关闭基地
	FDSM_VOLATILITY		= 0x40,	//帮派易变属性
};

enum FACTION_REBEL_STATUS
{
	FRS_SUCCESS		= 0x01, // 造反成功
	FRS_FAILED		= 0x02, // 造反失败，由于投票不通过
	FRS_REBEL		= 0x03, // 有人造反
	FRS_STOP		= 0x04, // 平叛成功，由于有人一票否决
};

enum FACTION_BASE_NOENTER_TYPE
{
	FBCT_BASECLOSE		= 1,	//基地关闭
	FBCT_NOBASE		= 2,	//没有基地
};

enum FACTION_COLLECTLEADER_TYPE
{
	FCT_PUSHLEADER	= 0,	//复杂推送信息处理的相关领导
	FCT_MASTER	= 1,	//帮主
	FCT_LEADER_CANADD = 2,	//有邀请权限的领导

	FCT_COUNT,
};

enum FACTION_COLLECTLEADER_STATUS
{
	FCS_ALL		= 0,	//全部信息，不管在线与否
	FCS_OFFLINE	= 1,	//离线领导
	FCS_ONLINE	= 2,	//在线领导
};

enum
{
	FACTION_MAX_NAME_LEN		= 16,			//帮派最长名字
	FACTION_BASE_COST		= 20000,	// 获取帮派基地费用
	FACTION_EXT_ROOM_COST		= 0,		// 帮派升级厢房费用
	FACTION_MEMBER_PER_PAGE		= 8,		// 显示帮派成员时每页显示数量
	FACTION_LEVEL_MAX		= 9,		// 帮派最高等级
	FACTION_VALUE_TRANSFER		= 80,		// 帮派基本属性转移 百分比
	FACTION_DOMAIN_TRANSFER_DIFF	= 10,		// 帮派产业不同时数值转移 百分比
	FACTION_DOMAIN_TRANSFER_SAME	= 40,		// 帮派产业相同时数值转移 百分比
	FACTION_ACTIVE_CONSUME_COUNT	= 5,		// 帮派激活所需要的物品数量
	FACTION_BASE_RENT_PER_LEVEL	= 100000,	// 帮会基地每等级需要租金
	FACTION_SUB_MAX			= 3,		// 帮派最多分舵数
	FACTION_TEMP_MEMBER_LEVEL	= 12,		// 正式成员等级阈值
	FACTION_NICKNAME_MAX_SIZE	= 12,		// 帮派昵称最大字节数
	FACTION_ANNOUNCE_MAX_SIZE	= 256,		// 帮派宣言最大字节数
	FACTION_MONEY_PER_CON		= 1000000,	// 每捐赠多少钱可以获取5点帮贡
	FACTION_BASE_MIN_ACTIVITY	= 20,		// 帮派基地开启活跃度下限
	FACTION_BASE_MIN_MEMBERS	= 10,		// 帮派基地开启人数下限
	FACTION_BASE_MIN_MONEY		= 0,		// 帮派基地开启资金下限
	FACTION_JOIN_MINLEVEL		= 12,		// 加入帮派需要的最小等级
	FACTION_OWNCITY_MAX		= 17,           // 每个帮派最多拥有17势力地图 
	FACTION_BASE_TACTIVITY_TIME	= 72 * 60 * 60,		//下限持续时间
	FACTION_BASE_MEMBERS_TIME	= 72 * 60 * 60,		//下限持续时间
	FACTION_BASE_MONEY_TIME		= 3 * 60 * 60,		//下限持续时间
	FACTION_BASE_RENT_FREE_TIME	= 7 * 24 * 60 * 60,	// 帮派基地第一周租金免费
	FACTION_BASE_RENT_TIME		= 12 * 60 * 60,		// 帮会基地租金周期
	FACTION_SUBFACTION_COOLDOWN	= 24 * 60 * 60,		// 删除分舵冷却时间
	FACTION_MEMBER_ACTIVITY		= 3 * 24 * 60 * 60,	// 帮派活跃玩家定义，上线时间
};

//使用const int 可以便于运行时修改测试, 只能当做局部变量改变


enum FACTION_MERAGE_MEMBER_OP
{
	FMMO_ADD	= 0,	//添加
	FMMO_DEL	= 1,	//删除
	FMMO_OK		= 2, 	//确定
	FMMO_ALL	= 3,	//获取
	FMMO_SELF	= 4,	//添加个人
};

enum FACTION_UPGRADE_TYPE
{
	FUT_NONE	= 0,
	FUT_LEVEL	= 1,	//升级等级
	FUT_BASE	= 2,	//开宗建派
	FUT_ACTIVE	= 3,	//激活帮派
	FUT_EXT_ROOM	= 4,	//升级厢房
	FUT_BASE_ACTIVE	= 5,	//重新激活基地
};

enum FACTION_BUILDING_TYPE
{
	DSEXP_FACTIONBLD_PLACE_SPECIAL2 = 8,	//EXP_FACTIONBLD_PLACE_SPECIAL2
	DSEXP_FACTIONBLD_PLACE_SPECIAL3 = 9,	//EXP_FACTIONBLD_PLACE_SPECIAL3
	DSEXP_FACTIONBLD_PLACE_SPECIAL4 = 10,	//EXP_FACTIONBLD_PLACE_SPECIAL4
};

enum FACTION_STATUS	// 帮派状态
{
	FS_NORMAL	= 0,	// 正常
	//FS_REBEL	= 1,	// 造反中
	FS_MERGEREQ	= 2,	// 合并请求
	FS_MERGEVOTE	= 3,	// 合并投票
	FS_MERGEVOTEEND = 4,	// 投票结束
	FS_MERGESTART	= 5,	// 开始合并,锁定帮派操作
	FS_CLEAR_DATA	= 6,	// GSLoad used,新数据
	FS_MERGEPRESTART= 7,	// 合并双方能够开始合并时(还未合并)的状态
};

enum FACTION_POSITION	// 帮派职位
{
	FP_NONE = 0,		// 帮众
	// 独立职位
	FP_MASTER = 1,		// 帮主
	FP_VICEMASTER1 = 2,	// 副帮主
	FP_VICEMASTER2 = 3,
	FP_VICEMASTER3 = 4,
	FP_HUFA1 = 11,		// 护法
	FP_HUFA2 = 12,
	FP_ZHANGLAO1 = 21,	// 长老
	FP_ZHANGLAO2 = 22,
	FP_ZHANGLAO3 = 23,
	FP_ZHANGLAO4 = 24,
	FP_SUBMASTER 	= 31,	// 分舵主
	//人数限制
	FP_BEAUTY	= 42,	// 帮花
	FP_TALKER	= 43,	// 话唠
	FP_KNOW_ALL	= 44,	// 百事通
	FP_GOOD_GUY	= 45,	// 老好人
	FP_ELITE	= 46,	// 精英
	FP_S_PET_TUTOR	= 47,	// 首席门徒导师
	FP_S_CHEMIST	= 48,	// 首席药师
	FP_S_COOK	= 49,	// 首席厨师
	FP_S_STONE_TUTOR= 50,	// 首席金石师
	FP_S_WOOD_TUTOR	= 51,	// 首席木师
	FP_S_CLOTH_TUTOR= 52,	// 首席布师
	FP_S_SOCIALITE	= 53,	// 首席社交师
	FP_PET_TUTOR	= 54,	// 高级门徒导师
	FP_CHEMIST	= 55,	// 高级药师
	FP_COOK		= 56,	// 高级厨师
	FP_STONE_TUTOR	= 57,	// 高级金石师
	FP_WOOD_TUTOR	= 58,	// 高级木师
	FP_CLOTH_TUTOR	= 59,	// 高级布师
	FP_SOCIALITE	= 60,	// 高级社交师
	FP_UNDERGRADUATE= 61,	// 新手辅导员
	FP_GRADUATE	= 62,	// 进阶辅导员
	FP_DOCTOR	= 63,	// 老手辅导员

	// 附属职位
	FP_MASTER_SPOUSE = 101,		// 帮主配偶
	FP_VICEMASTER_SPOUSE = 102,	// 副帮主配偶
	FP_MASTER_TRUSTED = 103,	// 帮主亲信
	FP_HUFA_TRUSTED = 104,		// 护法亲信
	FP_ZHANGLAO_TRUSTED = 105,	// 长老亲信
	FP_SUBMASTER_TRUSTED = 106,	// 分舵主亲信


	FP_UNKNOWN = 255,	// 非本帮派成员
};

enum FACTION_TITLE // 帮派荣誉身份
{
	FTI_NONE = 0,	// 帮众
	FTI_1 = 1,	// 1阶成员
	FTI_2 = 2,	// 2阶成员
	FTI_3 = 3,	// 3阶成员
	FTI_4 = 4,	// 4阶成员
	FTI_5 = 5,	// 5阶成员
	FTI_6 = 6,	// 6阶成员
	FTI_7 = 7,	// 7阶成员
	FTI_8 = 8,	// 8阶成员
	FTI_9 = 9,	// 9阶成员
	FTI_10 = 10,	// 10阶成员
	FTI_TMP = 101,	// 挂名成员
};

enum FACTION_SUB_NAME
{
	FSN_NONE	= 0,	// 空
	FSN_1		= 1,	// 青龙
	FSN_2		= 2,	// 白虎
	FSN_3		= 3,	// 朱雀
	FSN_4		= 4,	// 玄武
	FSN_5		= 5,	// 惊云
	FSN_6		= 6,	// 秀月
	FSN_7		= 7,	// 琴心
	FSN_8		= 8,	// 神策
	FSN_9		= 9,	// 开天
	FSN_10		= 10,	// 劈地
	FSN_11		= 11,	// 逐日
	FSN_12		= 12,	// 奔月
	FSN_13		= 13,	// 乾坤
	FSN_14		= 14,	// 天机
	FSN_15		= 15,   // 神途
	FSN_16		= 16,	// 霸业

};

enum FACTION_ADD_MONEY_TYPE
{
	FAMT_NORMAL	= 0,	//通用
	FAMT_TASK	= 1,	//任务
	FAMT_CONTRI	= 2,	//捐赠

	FAMT_CONTRI_RE	= 101,	//捐赠成功
};

enum FACTION_DEC_MONEY_TYPE
{
	FDMT_UPGRADE = 0,	//升级

	FAMT_COUNT,
};

enum FACTION_THING	// 帮派权限操作
{
//DS相关操作
	FT_ADD		= 1,	// 加成员
	FT_UPGRADE	= 2,	// 帮派升级
	FT_ANNOUNCE	= 3,	// 修改宣言
	FT_ABDICATE	= 4,	// 传位
	FT_REBEL1	= 5,	// 7天篡位
	FT_SUPPRESS	= 6,	// 反对7天篡位
	FT_REBEL2	= 7,	// 15天篡位
	FT_RESIGN	= 8,	// 辞职
	FT_EXPEL	= 9,	// 开除
	FT_QUIT		= 10,	// 退出
	FT_OP_MERGE	= 11,	// 选择合并成员列表
	FT_MERGE_OK	= 12,	// 确认合并成员列表
	FT_APPLY_SUB	= 13,	// 申请分舵
	FT_OP_SUB	= 14,	// 建立、删除分舵
	FT_SUBCITYAPPLY = 15,	// 申请势力范围
	FT_SUBCITYAPPLYDEAL = 16,// 处理势力申请	
	FT_AUCTION_OFFERPRICE = 17,// 龙头竞价
	FT_MAINCITYOPER = 18,	// 总舵处理
	FT_SUBRESET	= 19,	// 分舵设置
	FT_CONTRI_MONEY = 20,	// 捐钱
	FT_BASE_ACTIVE	= 21,	//重新激活已经关闭的基地
	FT_SETTIGUAN	= 22,	//设置玩家战斗队
	FT_TIGUAN	= 23,	//发起踢馆

//GS相关操作
	FT_STORE	= 50,	// 操作基地仓库
	FT_UPGRADE_BUILD = 51,	// 升级基地建筑
	FT_GET_WELWARE	= 52,	// 获取福利
	FT_HIREINFO	= 53,	// 招工信息管理
	FT_OPENACTIVITY	= 54,	// 打开活动
	FT_GET_SALARY	= 55,	// 领工资
	FT_GET_BONUS	= 56,	// 领供奉
	FT_COREMSG	= 57,	// 操作核心消息仓库
	FT_NORMALMSG	= 58,	// 操作小道消息仓库
	FT_TREASURE	= 59,	// 操作宝物仓库
	FT_TREASURE_TRAP = 60,	// 宝物机关操作
	FT_CONTRI_ITEM	= 61,	// 捐物品
	FT_PARTY	= 62,	// 用帮派资金打开宴会
	FT_DELACTIVITY	= 63,	// 删除活动
	FT_GET_MONEYTASK= 64,	// 获取发粮任务
};

enum FACTION_GETTYPE//获取帮派方式
{
	FG_GLOBLEGET = 0,	//无筛选条件，直接按照帮派ID获取
	FG_HAVEBASE = 1,	//有帮派基地
	FG_NOBASE = 2,		//没有帮派基地
};

enum FACTION_INVITE_TYPE //帮派成员邀请方式
{
	FIT_PUSH = 1,	//系统推送
	FIT_INVITE = 2,	//玩家主动邀请
};

enum FACTION_MERGE_REQ
{
	FMR_AGREE = 1, //同意合并
	FMR_DISAGREE = 2,//不同意合并
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
	FVR_DEFAULT = 0,//初始化值，未决状态
	FVR_PASS = 1,//通过
	FVR_NOTPASS = 2,//没有通过
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
	FASM_READY	= 0,	// 活动预备开始
	FASM_ON		= 1,	// 活动开启中
	FASM_OFF	= 2,	// 活动结束
	FASM_ON_OFF	= 3,	// 开启后自动结束，不需要在结束时再通知客户端了
};

enum FACTION_ACTIVITY_TYPE
{
	FAT_ACTIVITY	= 0, //活动
	FAT_PARTY	= 1, //宴会
	FAT_LVUPCELE	= 2, //升级庆典
	FAT_AUCTION	= 3, //竞标
};

enum FACTION_RECORD_THING_TYPE
{
	FRTT_AUCPOINT_DONATE	= 1,	//捐赠竞标点
	FRTT_AUCPOINT_RECEIVE	= 2,	//接受竞标点
	FRTT_CITY_ADD		= 3,	//增加势力地图
	FRTT_CITY_DEL		= 4,	//删除势力地图
	FRTT_MAIN_EXCHANGE	= 5,	//搬迁总舵
	FRTT_TIGUAN		= 6,	//踢馆
	FRTT_BE_TIGUAN		= 7,	//被踢馆
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
	FGIR_SUCCESS	= 0,//可以采集
	FGIR_NOCITY	= 1,//无势力地图
};

// 在数据库vote_mask字段中，如果该位置1，表示该玩家已经投票，置0，表示该玩家未投票
// 在数据库vote_result字段中(如果vote_mask字段中对应位已经被置1),置1，表示同意，置0，表示不同意
enum VOTE_MASK
{
	VM_MERGE_VOTE		= 0x00000001,
	VM_SCORE_VOTE		= 0x00000002,
	VM_MERGE_TRANSFER	= 0x00000004,	//准备被转移的人员
	VM_MERGED_VOTE		= 0x00000008,
	VM_REBEL_VOTE		= 0x00000010,
	VM_SALARY_GET		= 0x00000020,	//领取薪水标志
	VM_BONUS_GET		= 0x00000040,	//领取供奉标志
	VM_WELF_EXP_GET		= 0x00000080,	//领取福利经验标识

	VM_GS_ONLY_MASK		= VM_WELF_EXP_GET,
};

enum LINK_TYPE
{
	LINK_TYPE_LS   = 1, 
	LINK_TYPE_CS   = 2,
	LINK_TYPE_IWEB = 3, 
};

//与GS内部定义一致
enum USE_MONEY_TYPE_MASK
{
	UMT_BIND  = 0x01, //使用绑定币
	UMT_TRADE = 0x02, //使用交易币
};

enum USE_CASH_TYPE_MASK
{
        UCT_BIND  = 0x01, //使用绑定元宝
        UCT_TRADE = 0x02, //使用交易元宝
};

enum TOPLIST_NAME
{
	//TPN_LEVEL = 1,			//等级榜
	//TPN_LEVEL_OLDDAY = 2,		//等级一天前老榜
	//TPN_MONEY = 3,			//金钱榜
	//TPN_MONEY_OLDDAY = 4,		//金钱一天前老榜
	//TPN_HP = 5,			//气血榜
	//TPN_HP_OLDDAY = 28,		//气血一天前老榜 
	//TPN_MP = 6,			//内力榜
	//TPN_MP_OLDDAY = 29,		//内力一天前榜
	//TPN_ATTACKOUT = 7,		//外功攻击榜
	//TPN_ATTACKOUT_OLDDAY = 30,	//外功攻击一天前老榜
	//TPN_ATTACKIN = 8,		//内功攻击榜
	//TPN_ATTACKIN_OLDDAY = 31,	//内功攻击一天前老榜
	//TPN_REPUTATION = 9,		//成就榜
	//TPN_REPUTATION_OLDDAY = 32,	//成就一天前老榜
	//TPN_PLANT = 10,			//种植榜
	//TPN_PLANT_OLDDAY = 33,		//种植一天前老榜
	//TPN_BREED = 11,			//养殖榜
	//TPN_BREED_OLDDAY = 34,		//养殖一天前老榜
	//TPN_MINE = 12,			//采矿榜
	//TPN_MINE_OLDDAY = 35,		//采矿一天前老榜
	//TPN_CUT = 13,			//伐木榜
	//TPN_CUT_OLDDAY = 36,		//伐木一天前老榜
	//TPN_METAL = 14,			//金石榜
	//TPN_METAL_OLDDAY = 37,		//金石一天前老榜
	//TPN_WOODLEATHER = 15,		//木革榜
	//TPN_WOODLEATHER_OLDDAY = 38,	//木革一天前老榜
	//TPN_CLOTH = 16,			//布帛榜
	//TPN_CLOTH_OLDDAY = 39,		//布帛一天前老榜
	//TPN_MEDCINE = 17,		//制药榜
	//TPN_MEDCINE_OLDDAY = 40,	//制药一天前老榜
	//TPN_COOK = 18,			//烹饪榜
	//TPN_COOK_OLDDAY = 41,		//烹饪一天前老榜
	//TPN_FISH = 19,			//钓鱼榜
	//TPN_FISH_OLDDAY = 42,		//钓鱼一天前老榜
	//TPN_PET = 20,			//宠物榜
	//TPN_PET_OLDDAY = 43,		//宠物一天前老榜
	//TPN_REPCHARM = 21,		//魅力榜
	//TPN_REPCHARM_OLDDAY = 44,	//魅力一天前老榜
	//TPN_REPFAME = 22,		//人缘榜
	//TPN_REPFAME_OLDDAY = 45,	//人缘一天前老榜
	//TPN_REPSECT = 23,		//师徒榜
	//TPN_REPSECT_OLDDAY = 46,	//师徒一天前老榜
	//TPN_REPLIFE = 24,		//生活名望榜
	//TPN_REPLIFE_OLDDAY = 47,	//生活名望一天前老榜
	//TPN_REPFUZHOU = 25,		//福州城市声望榜
	//TPN_REPFUZHOU_OLDDAY = 48,	//福州城市声望一天前老榜
	//TPN_REPHENGSHAN = 26,		//衡山城市声望榜
	//TPN_REPHENGSHAN_OLDDAY = 49,	//衡山城市声望一天前老榜
	//TPN_REPLUOYANG = 27,		//洛阳城市声望榜
	//TPN_REPLUOYANG_OLDDAY = 50,	//洛阳城市声望一天前老榜
	//TPN_REPJUEWEI = 51,		//爵位声望榜
	//TPN_REPJUEWEI_OLDDAY = 52,	//爵位声望老榜
	//TPN_REPYUHANG = 53,		//余杭声望榜
	//TPN_REPYUHANG_OLDDAY = 54,	//余杭声望一天前老榜
	//TPN_REPNANJIANG = 55,		//南疆声望榜
	//TPN_REPNANJIANG_OLDDAY = 56,	//南疆声望一天前老榜
	//TPN_REPWULIN	= 57,		//武林声望榜
	//TPN_REPWULIN_OLDDAY = 58,	//武林声望一月前老榜
	//TPN_REPPK = 59,			//PK声望榜
	//TPN_REPPK_OLDDAY = 60,		//PK声望一天前老榜
	//TPN_REPRENOWNUSED = 61,		//世界声望榜
	//TPN_REPRENOWNUSED_OLDDAY = 62,	//世界声望一天前老榜

	//TPN_MAX	= 63,//排行榜编号最大值+1(以上排行榜都为在gamedbd中的排行榜)
	//TPN_NOTOLD_COUNT = 31,//排行榜中非老榜数量(这个数也只特指在gamedbd中的排行榜)
	//TPN_MAX	= 3,//排行榜编号最大值+1(以上排行榜都为在gamedbd中的排行榜)
	//TPN_NOTOLD_COUNT = 1,//排行榜中非老榜数量(这个数也只特指在gamedbd中的排行榜)

	// 下面是DS维护的排行榜
	//TPN_FACTION_INDUSTRY = 300,	//帮派总体实力排行榜
	//TPN_FACTION_ESCORT = 301,	//帮派镖局排行榜
	//TPN_FACTION_CARAVAN = 302,	//帮派马帮排行榜
	//TPN_FACTION_COTTAGE = 303,	//帮派山寨排行榜
	//TPN_FACTION_FACTORY = 304,	//帮派工坊排行榜
	//TPN_FACTION_LEVEL = 305,	//帮派等级排行榜
	//TPN_FACTION_CONSINC = 306,	//帮派建设度增量排行榜
	//TPN_FACTION_INDUSTRY_OLD1 = 307,	//帮派总体实力老榜1(每天存一次)
	//TPN_FACTION_INDUSTRY_OLD2 = 308,	//帮派总体实力老榜2(每周存一次)
	//TPN_FACTION_ACTIVITY_FEATURE = 309,	//帮派特色活动进度排行榜
	//TPN_FACTION_ACTIVITY_TREASURE = 310,	//帮派寻宝活动进度排行榜
	//TPN_FACTION_ACTIVITY_EXTINCTION = 311,	//帮派灭门活动进度排行榜

	//TPN_FACTION_CONTRIBUTIONINC = 10000,//这个一个特殊的排行榜编号，该编号代表一个特殊的排行榜(每个玩家对应自己帮派中的帮贡增量排行榜)，该编号主要用于领奖用.

	TPN_PATA			= 1,	//爬塔积分榜
	TPN_PATA_OLDDAY			= 2,	//爬塔积分一天前老榜
	TPN_LEVEL			= 3,	//等级榜
	TPN_LEVEL_OLDDAY		= 4,	//等级一天前老榜
	TPN_MONEY			= 5,	//金钱榜
	TPN_MONEY_OLDDAY		= 6,	//金钱一天前老榜
	TPN_FIGHTING_CAPACITY		= 7,	//战力榜
	TPN_FIGHTING_CAPACITY_OLDDAY	= 8,	//战力一天前老榜
	TPN_HERO			= 9,	//侠客榜
	TPN_HERO_OLDDAY			= 10,	//侠客一天前老榜
	TPN_BIWU_1V1			= 11,	//1v1比武榜
	TPN_BIWU_1V1_OLDDAY		= 12,	//
	TPN_BIWU_NVN			= 13,	//NvN比武榜
	TPN_BIWU_NVN_OLDDAY		= 14,	//

	TPN_MAX				= 15,	//排行榜编号最大值+1(以上排行榜都为在gamedbd中的排行榜)
	TPN_NOTOLD_COUNT		= 7,	//排行榜中非老榜数量(这个数也只特指在gamedbd中的排行榜)
};

enum TOPLIST_CATEGORY
{
	TPT_GLOBLE = 0, //全局排行榜
	//TPT_FACTION_CONTRIBUTE_INC = 1, //帮派帮贡增量排行榜--老榜
	//TPT_FACTION_CONTRIBUTE_INC_TODAY = 2, //帮派帮贡增量排行榜--新帮
};
enum TOPLIST_INFO_TYPE
{
       TIT_PLAYER      = 0,    //玩家数据排行榜
       //TIT_FACTION     = 1,    //帮派数据排行榜
};

enum CAMPAIGN_SYNC_MODE
{
	CSM_INIT = 0,	//初始化活动信息
	CSM_UPDATE = 1,	//更新活动信息
};

enum CAMPAIGN_INFO_TYPE
{
	CIT_OPEN	= 0,	//开启活动
	CIT_CLOSE	= 1,	//关闭活动
	CIT_FORBID_OPEN	= 2,	//时间到，但是被打开条件限制
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
	SMP_SYNC		= 0,	//同步信息
	SMP_CREATE		= 1,	//创建镜像
	SMP_CLOSE		= 2,	//关闭镜像
	SMP_DEACTIVE_MIRROR	= 3,	//关闭某场景镜像功能
	SMP_REACTIVE_MIRROR	= 4,	//重新激活镜像功能
	SMP_REOPEN		= 5,
};

enum INSTANCE_RETURN_OP
{
	IRO_CANCEL	= 0,	//删除进入信息
	IRO_ENTER	= 1,	//进入当前副本
};

enum SERVER_MODE
{
	SMODE_NORMAL	= 0,	// 正常线
	SMODE_PRIVATE	= 1,	// 私有线
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
	MX_EVENT_INVALID	= 0, //无效事件
	MX_EVENT_NEW_BY_TASK	= 1, //任务产生新明星
	MX_EVENT_NEW_BY_TP	= 2, //排行榜产生新明星
};

enum FACTION_TIGUAN_STATE 
{
	FTS_NONE		= 0,
	FTS_PREPARE0		= 1, //准备阶段0, 服务器保护
	FTS_PREPARE1		= 2, //准备阶段1, 踢馆被服务器接受
	FTS_PREPARE2		= 3, //准备阶段2, 开始限制进入人员, 随后清场
	FTS_BEGIN_FIGHT		= 4, //开始战斗
	FTS_END			= 5, //结束战斗, 接下来可能进入奖励时间按
};

enum FACTION_WAR_TYPE
{
	FWT_TIGUAN		= 1, //踢馆
};

enum FACTION_TIGUAN_GOAL
{
	FTG_PLAY		= 0, //娱乐
	FTG_SUB			= 1, //实例通行
	FTG_MAIN		= 2, //抢占驻地
};

enum DB_SAVE_ROLE_TYPE
{
	DSRT_IS_GM		= 0x01,		//是GM
	DSRT_IS_ROAMER		= 0x02,		//是漫游者
};

enum DB_PACKE_ROAM_ROLE_TYPE
{
	DPRRT_ALL_DATA		= 0,		//打包所有数据
	DPRRT_GS_DATA		= 1,		//打包GS数据

	DPRRT_COUNT,
};

enum DB_ROLE_SAVE_PRIORITY
{
	DRSP_NOTING		= 0,		//未定义
	DRSP_AUTO_SAVE		= 1,		//自动保存
	DRSP_LOGOUT		= 2,		//离线后保存
	DRSP_ROAM_BACK		= 3,		//跨服回归存盘
};

enum ROAM_PROTOCOL_DIRECTION
{
	RPD_SEND_TO_DST		= 0,		//协议发向目标副
	RPD_SEND_TO_SRC		= 1,		//协议发向源服
};

enum ROAM_SYNC_STATUS_TYPE
{
	RSS_LOGOUT		= 0,		//登出操作
	RSS_ROAMIN_SUCCESS	= 1,		//跨服登陆正常
	RSS_ROAM_BACK		= 2,		//尝试回归
	RSS_LOSTCONNECT		= 3,		//断线了
};

enum LOGIN_MASK
{
	LOGIN_ROAM 		= 0x01, 	//跨服登录
	LOGIN_DEFAULT_POS 	= 0x02, 	//默认出生点登录
	LOGIN_CHANGE_LINE	= 0x04,		//换线登陆
	LOGIN_ROAM_RECONNECT	= 0x08,		//断线重连登陆
	LOGIN_RECONNECT		= 0x10,		//正常游戏断线重连

	LOGIN_CLINET_USE	= LOGIN_DEFAULT_POS,
};

enum INSTANCE_DELVERY_STATE
{
	IS_RUNNING		= 0,		//正在运行
	IS_EXPORT_BORAD         = 1,            //到达出口版面
	IS_SUCCEED_FIHISH	= 2,		//成功完成副本
	IS_CLOSED		= 3,		//副本关闭，玩家被踢出
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
	MAX_RECORD_COUNT	= 10,			//最多保存10次战绩信息
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
	//ADD_CASH_MAX		= 1000000,	//每次最多充值元宝数: 1m
	PENDING_ORDER_MAX	= 30,		//最多可以有几个未支付订单
};

enum ACTIVE_CODE_TYPE
{
	ACTIVE_CODE_TYPE_INVALID	= 0,
	ACTIVE_CODE_TYPE_IOS_LOGIN	= 1,	//IOS设备登录游戏用的激活码
	ACTIVE_CODE_TYPE_ANDROID_LOGIN	= 2,	//ANDROID登录游戏用的激活码

	ACTIVE_CODE_TYPE_LIBAO_START	= 10001,//保留给礼包用的兑换码
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
	NOTICE_BANGHUI_SIGN             = 8,//普通签到
	NOTICE_BANGHUI_SIGN_MID         = 9,//小元宝签到
	NOTICE_BANGHUI_SIGN_BIG         = 10,//大元宝签到
	NOTICE_BANGHUI_REP_ITEM         = 11,//上缴物资
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
	CENTER_COMMAND_ADD_COMPENSATE			= 1004, //发送全服礼包
	CENTER_COMMAND_INNER_ADD_CASH			= 1005,	//充值(仅用于提升VIP等级，并不会真正获得元宝)
	CENTER_COMMAND_ADD_CASH_4_R			= 1006,	//充值(真正获得元宝，一般是给大R用)
	CENTER_COMMAND_UPDATE_TOPLIST_4_NEW_ZONE	= 1007,
	CENTER_COMMAND_CHANGE_PLATFORM_USERID		= 1008, //修改帐号对应的userid
	CENTER_COMMAND_DELETE_ROLE			= 1009, //删除对应的角色
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
	VIETNAM_APPLE = 0,		//苹果充值
	VIETNAM_GOOGLE = 1,		//google充值
	VIETNAM_BANK = 2,		//银行充值
	VIETNAM_CARD = 3,		//电话卡充值
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
