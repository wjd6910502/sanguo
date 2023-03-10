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

#define CHANGE_WORLD_WAIT_TIME		30	// 换线等待时间 同多人换线等待时间
#define PRE_CHANGE_WORLD_WAIT_TIME	15	// 标识DS换线状态等待时间
#define SYNC_GS_LOAD_TIME_SECOND	4	// 同步GS的负载的时间
#define GS_DS_SYNC_DELAY_MICRO_SECOND	800	// 估计DS_GS同步最大延迟，毫秒
//每次清除预测数据的比例
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
#define MAX_STOCK_VOLUME              1000000   // 最高单笔交易元宝数（银元宝）
#define MAX_STOCK_PRICE               1000000   // 最高元宝单价（银元宝）
#define MAX_STOCK_ACCOUNT_MONEY 8000000000000LL // 元宝交易账户允许储蓄交易币上限, 应大于MAX_STOCK_PRICE*MAX_STOCK_VOLUME
#define MAX_MAIL_ATTACH_MONEY     10000000000LL // 玩家邮件附件中可携带的交易币上限
#define MAX_USER_CASH             1000000000   // 账号元宝上限
#define CASH_BALANCE_THRESHOLD     500000000   // 当User.cash和User.cash_used都增长到一定阈值后，登录时统一减少
//#define STOCK_TAX_RATE          1.02
#define MAX_NAME_SIZE           40
#define BATTLE_NAME_MAX_SIZE		30		//战场房间名最长15个字节
#define BATTLE_PASSWORD_MAX_SIZE	20		//战场密码最长20个字节
#define TEAM_CAPACITY           4
#define MAX_MAILBOX_SIZE        32768
#define MAX_FRIEND_COUNT        5
#define MAX_ENEMY_COUNT         5
#define MAX_BLACKLIST_SIZE      20
#define INVALID_NEXTROLEID      -1
#define MAX_TRUSTEE_COUNT       (5)
#define MARRIAGE_PROPOSE_LEVEL_LIMIT 30 // 订婚双方等级限制
#define MARRIAGE_MARRY_LEVEL_LIMIT   30 // 结婚双方等级限制
#define MARRIAGE_DIVORCE_UNCONDITIONAL_TIME_LIMIT 3600 * 24 * 15 // 对方15天未登录可申请无条件离婚
//#define MARRIAGE_MARRY_AMITY_LIMIT 5000 // 结婚双方好感度限制
#define MAIL_PACK_COST              500 // 发送邮件包裹费用
#define MAX_STOCK_ORDER_PER_USER     10 // 玩家在元宝交易时的最大同时挂单数
#define MAX_STOCK_LOG_PER_USER       80 // 玩家元宝交易日志的条数上限

#define LAST_DAY_RNAK_KEY		0xFFFF	//默认的存储昨日排名的数值

// 计算含税的元宝交易数
//#define TaxedTradeCash(volume) ((int)((STOCK_TAX_RATE)*(volume)))
// 计算含税的元宝交易所需金钱。注意：对于收购元宝来说，其值小于0（因为price<0）
//#define CalTaxedTradeMoney(price,volume) ((int64_t)((STOCK_TAX_RATE)*((int64_t)price)*((int64_t)volume)))
//#define TaxedTradeMoney(money) ((int64_t)((STOCK_TAX_RATE)*((int64_t)money)))

#define BACKTABLEID(rid)  (int)(((rid)>>4) & 7)

// roleid相关，id与roleid不同，使用下面的ID_TO_ROLEID将id转换为roleid
#define TEMP_ID_MIN	1		// 第一个role模板的id
#define FREE_ID_MIN	0x01LL		// 第一个可分配给玩家的id，所以最小的玩家角色id为 (FREE_ID_MIN<<ZONE_ID_BIT)
#define FREE_ID_MAX	0xFFFFFFFFFFLL	// 最大可分配给玩家的id，注意范围
#define ZONE_ID_BIT	16		// zoneid占用16bit，最多支持65536个区
#define ZONE_ID_MASK	0xFFFF		
#define ID_TO_ROLEID(id, zoneid) (((id) << ZONE_ID_BIT) | (zoneid))
#define LOCAL_ZONE_MARK   0		// 泛指再自己当前的源区,zonedi最小值为1

#define MAX_ZONE_ID			0x0000FFFF		// zoneid最大值 65535
#define ZONE_ID(roleid)			((roleid) & ZONE_ID_MASK)
#define IS_LOCAL_ZONE_MARK(zone)	((size_t)zone == LOCAL_ZONE_MARK || (size_t)zone > MAX_ZONE_ID)
#define IS_NATIVE_PEOPLE(roleid,roleid2)  (ZONE_ID(roleid) == ZONE_ID(roleid2))
#define IS_LOCAL_ZONE_ID(roleid)	(IS_LOCAL_ZONE_MARK(ZONE_ID(roleid)) || (ZONE_ID(roleid) == g_zoneid))

#define FAMILY_FREE_ID_MIN	1	// 第一个可分配给family的id
#define FAMILY_FREE_ID_MAX	1000000	// 最大可分配给family的id,注意范围
#define ID_TO_FAMILYID(id, zoneid) (((id) << ZONE_ID_BIT) | (zoneid))

#define FACTION_FREE_ID_MIN	1	// 第一个可分配给faction的id
#define FACTION_FREE_ID_MAX	1000000	// 最大可分配给faction的id,注意范围
#define ID_TO_FACTIONID(id, zoneid) (((id) << ZONE_ID_BIT) | (zoneid))

#define COMMON_SDK_USERID_FREE_ID_MIN	1000 // 第一个可分配给common sdk的user id
#define COMMON_SDK_USERID_FREE_ID_MAX	100000000// 最大可分配给common sdk的user id,注意范围
#define ID_TO_COMMON_SDK_USERID(id, zoneid) (id)

#define MAX_PLAYER_SIGNATURE_LENGTH 32 // 玩家签名的最大长度
#define MAX_PLAYER_CUSTOM_APPEARANCE_LENGTH 100 // 玩家角色自定义数据的最大长度
#define MAX_PLAYER_TITLE_DATA_LENGTH 64 // 玩家称号附加数据的最大长度

#define MIN_AUCTION_LEVEL	10		//最小参与拍卖玩家等级
#define SYNC_FACTION_MIN_MONEY_ADD	73	//玩家捐钱后实时存盘的最小钱数

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
	ALGORITHM_OPT_NOCACHE         = 0x00000100,  // DS不保存密码
	ALGORITHM_PASSWORD_OBSOLETE   = 0x00000200,  // 密码长期未更换
	ALGORITHM_CARD_OBSOLETE       = 0x00000400,  // 密保卡长期未更换
	ALGORITHM_GM_ACCOUNT          = 0x00000800,  // GM帐号 
	ALGORITHM_NONE                = 0x0,
	ALGORITHM_CARD                = 0x00010000,  // 密保卡用户
	ALGORITHM_HANDSET             = 0x00020000,  // 手机密保用户
	ALGORITHM_USBKEY              = 0x00030000,  // 一代神盾用户
	ALGORITHM_PHONE               = 0x00040000,  // 电话密保用户
	ALGORITHM_USBKEY2             = 0x00050000,  // 二代神盾用户
};
enum{
	BASE_STATUS_DEFAULT	= 0x01,  // 默认状态
	BASE_STATUS_DELETING	= 0x02,  // 等待删除中
	BASE_STATUS_DELETED	= 0x04,  // 马上删除
	BASE_STATUS_BACKED	= 0x08,  // 完整角色数据保存于BackDBD中
	BASE_STATUS_NEWRETURN   = 0x10,  // 角色刚由不活跃状态变为活跃
	BASE_STATUS_EXPIRED	= 0x20,  // 角色信息已过期(用于明星备份角色)
};

//player logout style
enum PLAYER_LOGOUT_STYLE
{
	PLAYER_LOGOUT_FULL = 0,		//大退
	PLAYER_LOGOUT_HALF = 1,		//小退
	PLAYER_LOGOUT_ZONE = 2,		//跨服回归
	PLAYER_LOGOUT_DISCONNECT = 3,	//服务器踢掉或客户端断线

	PLAYER_LOGOUT_COUNT,
};

enum{
	PLAYER_STATUS_INITIAL		= 0, // 初始状态
	PLAYER_STATUS_PENDING		= 1, // 等待上次登录结束
	PLAYER_STATUS_ROAMRECV		= 2, // 收到Roam协议
	PLAYER_STATUS_READYGAME		= 3, // 等待进入世界命令
	PLAYER_STATUS_ONLINE		= 4, // 角色列表状态
	PLAYER_STATUS_LOGINRECV		= 5, // 收到PlayerLogin协议
	PLAYER_STATUS_LOADGAME		= 6, // 正在加载游戏数据
	PLAYER_STATUS_INGAME		= 7, // 游戏状态
	PLAYER_STATUS_ROAM		= 8, // 源DS跨服状态
	PLAYER_STATUS_CLOSING		= 9, // 收到PlayerLogout协议
	PLAYER_STATUS_CLOSEWAIT		= 10,// 等待GS确认角色退出
	PLAYER_STATUS_CLOSED		= 11,// 账号已退出登录
	PLAYER_STATUS_LOST_CONNECT	= 12,// 等待断线重连
	PLAYER_STATUS_RECONNECT		= 13,// 断线重连状态
};

enum{
	ITEM_PROC_TYPE_NODROP           = 0x00000001,   //死亡时不掉落
	ITEM_PROC_TYPE_NODESTROY        = 0x00000002,   //不允许摧毁
	ITEM_PROC_TYPE_NOSELL           = 0x00000004,   //无法卖给NPC 
	ITEM_PROC_TYPE_CASHITEM         = 0x00000008,   //是人民币物品
	ITEM_PROC_TYPE_NOTRADE          = 0x00000010,   //玩家间不能交易
	ITEM_PROC_TYPE_TASKITEM         = 0x00000020,   //是任务物屁
	ITEM_PROC_TYPE_PICK_BIND        = 0x00000040,   //拾取后绑定
	ITEM_PROC_TYPE_AUTO_BIND        = 0x00000080,   //装备或者使用后绑定
	ITEM_PROC_TYPE_BOUND            = 0x00000100,   //是已经绑定的物品
	ITEM_PROC_TYPE_NO_BIND          = 0x00000200,   //不允许严格绑定（天人合一）
	ITEM_PROC_TYPE_GUID             = 0x00000400,   //应产生GUID
	ITEM_PROC_TYPE_NO_SPLIT         = 0x00000800,   //即使pile_limit >1 也不可堆叠和拆分
	ITEM_PROC_TYPE_EXBOUND          = 0x00002000,   //绑定
	ITEM_PROC_TYPE_S_BOUND          = 0x20000000,   //是已经严格绑定的物薹
	ITEM_PROC_TYPE_UPGRADE          = 0x40000000,   //已升过级别的物品 无法掉落交易
	ITEM_PROC_TYPE_UNBIND_EXPIRE    = 0x80000000,   //是拥有到期解除绑定的物品
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
	ERR_BATTLE_TEAM_FULL		= 140,	// 阵营已满
	ERR_BATTLE_GAME_SERVER		= 141,	// 不在同一条线
	ERR_BATTLE_JOIN_ALREADY 	= 142,	// 已经加入队伍
	ERR_BATTLE_MAP_NOTEXIST		= 143,	// 没有找到地图
	ERR_BATTLE_COOLDOWN		= 144,	// 离上次战斗时间不足冷却时间，不能报名
	ERR_BATTLE_NOT_INTEAM		= 145,  // 用户不在队伍中
	ERR_BATTLE_LEVEL_LIMIT		= 146,  // 用户不符合战场级别限制
	ERR_BATTLE_OCCUPATION		= 147,  // 用户阵营限制
	ERR_BATTLE_QUEUELIMIT		= 148,  // 用户排队超过最大限制
	ERR_BATTLE_INFIGHTING 		= 149,  // 已经进入战场，不能退出报名
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
	ERR_SIEGE_BIDFAILED	= 160, 		//阵营内报名失败
	ERR_SIEGE_CHALLENGEFAILED = 161, 	//成占报名失败
	ERR_SIEGE_NATION = 162, 		//不是本阵营，不能报名内部
	ERR_SIEGE_NIMBUS = 163,			//统御值不足
	ERR_SIEGE_NOOWNCITY = 164,		//没有领地不能报名城战
	ERR_SIEGE_NODEFENDERONLY = 165,		//取消过报名，不能报有人防守的城
	ERR_SIEGE_ADJACENT = 166,		//两个城不相邻
	ERR_SIEGE_DUPBID = 167,			//重复竞价
	ERR_SIEGE_FACTIONLIMIT = 168,		//帮派级别限制
	ERR_SIEGE_CITYNOTFOUND = 169,		//城市没找到
	ERR_SIEGE_ENTERFAILED = 170,		//进入城战失败
	ERR_SIEGE_NATIONFULL = 171,		//城战本方阵营人满
	ERR_SIEGE_DUPENTER = 172,		//重复进入
	ERR_SIEGE_CAPITAL = 173, 		//攻占首都必须占领37个呈?
	ERR_SIEGE_CANNOTENTER = 174,		//不属于交战阵营，不能进入
	ERR_SIEGE_LEVELLIMIT = 175,		//级别不足，不能进入城战
	ERR_SIEGE_ENTERPRIOR = 176,		//开战五分钟，只能本帮派进入 

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
	MSG_BIDSTART             = 1,  // 开始竞价
	MSG_BIDEND               = 2,  // 竞价结束
	MSG_BATTLESTART          = 3,  // 城战开始
	MSG_BATTLEEND            = 4,  // 城战结束
	MSG_BIDSUCCESS           = 5,  // 竞价成功
	MSG_BONUSSEND            = 6,  // 领土收益发送
	MSG_MARRIAGE             = 10, // 结婚
	MSG_DIVORCE              = 11, // 离婚
	MSG_COMBATCHALLENGE      = 12, // 野战挑战
	MSG_COMBATSTART          = 13, // 野战开始
	MSG_COMBATREFUSE         = 14, // 拒绝野战邀请
	MSG_COMBATEND            = 15, // 野战结束
	MSG_COMBATTIMEOUT        = 16, // 野战邀请超时
	MSG_CITYNOOWN            = 17, // 帮派降级后城市无主
	MSG_BATTLE1START         = 18, // 有领土对有领土帮派城战开始
	MSG_BATTLE2START         = 19, // 无领土对有领土帮派城战开始 
	MSG_FAMILYDEVOTION       = 20, // 获得家族贡献度
	MSG_FAMILYSKILLABILITY   = 21, // 家族技能等级变化
	MSG_FAMILYSKILLEVEL      = 22, // 家族技能熟练度变化
	MSG_FACTIONNIMBUS        = 23, // 帮派灵气变化
	MSG_TASK                 = 24, // 任务喊话
	MSG_SIEGERESET           = 25, // 领土重置
	MSG_SIEGEBIDBEGIN      	 = 26, // 开始驻守申请
	MSG_SIEGEBID      	 = 27, // 驻守
	MSG_SIEGERESETCITY     	 = 28, // 重置领土参数
	MSG_SIEGEBIDEND     	 = 29, // 驻守申请结束
	MSG_SIEGECHALLENGEBEGIN  = 30, // 领土宣战开始
	MSG_SIEGECHALLENGE  	 = 31, // 领土宣战
	MSG_SIEGECHALLENGEEND    = 32, // 领土宣战结束
	MSG_SIEGEARANGE   	 = 33, // 国战列表确定
	MSG_SIEGEBEGIN   	 = 34, // 国战开始
	MSG_SIEGEEND   	 	 = 35, // 国战结束
	MSG_SIEGETIME  	 	 = 36, // 时间通知
	MSG_CONTESTTIME		 = 37, // 答题竞赛 时间通知 
	MSG_CONTESTEND		 = 38, // 答题竞赛 结束
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
	ERR_CHGS_INVALIDGS       = 1,	//不存在该gs号
	ERR_CHGS_MAXUSER         = 2,	//目的gs人数达到上限
	ERR_CHGS_NOTINSERVER     = 3,	//用户切换gs时不在服务器内
	ERR_CHGS_STATUSINVALID   = 4,	//用户切换gs时状态不对
	ERR_CHGS_NOTGM           = 5,	//用户不是gm
	ERR_CHGS_MAPIDINVALID    = 6,	//地图不存在
	ERR_CHGS_SCALEINVALID    = 7,	//非法坐标
	ERR_CHGS_DBERROR         = 8,	//数据库错误
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

enum	AWAR_STEP		//盟主战阶段
{
	AS_UNACTIVE	= 0,	//未激活
	AS_NONE         = 1,    //空闲
	AS_APPLY        = 2,    //申请阶段
	AS_START_WAR    = 3,    //开战阶段
	AS_END_WAR	= 4,	//战斗结算阶段
};

enum
{
	GNET_FORBID_LOGIN	= 100,	//禁止登录
	GNET_FORBID_TALK	= 101,	//禁言
	GNET_FORBID_TRADE	= 102,	//禁止玩家交易
};
enum
{
	PRV_TOGGLE_NAMEID	= 0,	//切换玩家名字与ID
	PRV_HIDE_BEGOD		= 1,	//进入隐身或无敌状态
	PRV_ONLINE_ORNOT	= 2,	//切换是否在线
	PRV_CHAT_ORNOT		= 3,	//切换是否可以密语
	PRV_MOVETO_ROLE		= 4,	//移动到指定角色身边
	PRV_FETCH_ROLE		= 5,	//将指定角色召唤到GM身边
	PRV_MOVE_ASWILL		= 6,	//移动到指定位置
	PRV_MOVETO_NPC		= 7,	//移动到指定NPC位置
	PRV_MOVETO_MAP		= 8,	//移动到指定地图（副本）
	PRV_ENHANCE_SPEED	= 9,	//移动加速
	PRV_FOLLOW		= 10,	//跟随玩家
	PRV_LISTUSER		= 11,	//获取在线玩家列表
	PRV_FORCE_OFFLINE	= 100,	//强制玩家下线，并禁止在一定时间上线
	PRV_FORBID_TALK		= 101,	//禁言
	PRV_FORBID_TRADE	= 102,	//禁止玩家间、玩家与NPC交易，仅针对一个玩家
	PRV_FORBID_SELL		= 103,	//禁卖
	PRV_BROADCAST		= 104,	//系统广播
	PRV_SHUTDOWN_GAMESERVER	= 105,	//关闭游戏服务器
	PRV_SUMMON_MONSTER	= 200,	//召唤怪物
	PRV_DISPEL_SUMMON	= 201,	//驱散被召唤物体
	PRV_PRETEND		= 202,	//伪装
	PRV_GMMASTER		= 203,	//GM管理员
};

enum ERR_FAMILY
{
	ERR_FC_INFACTION = 125,
};

#define FACTION_ACTIVE

enum FACTION_SAFE_SYNC_TYPE
{
	FSST_DISMISS		= 1,	// 解散帮派
	FSST_STATUS		= 2,	// 同步status
};

enum FACTION_GETMONEY_TYPE
{
	FGT_SALARY		= 1,	// 领工资
	FGT_BONUS		= 2,	// 领供奉
	FGT_WELF_EXP		= 3,	// 福利经验
	FGT_CLEAR_WELF_EXP	= 4,	// 清除福利经验领取标识
};

enum ALLIANCE_INC_MONEY_TYPE
{
	AIMT_GENERAL		= 0,
	AIMT_SELL_TAX		= 1,	// 售卖收税
	AIMT_TASK_TAX		= 2,	// 任务税
	AIMT_ALLIANCER_INC	= 3,	// 盟主增加
};

enum ALLIANCE_DEC_MONEY_TYPE
{
	ADMT_GENERAL		= 0,
	ADMT_ALLIANCER_DEC	= 1,	// 盟主获取
};

enum
{
	ALLIANCE_WAR_SCENE_TAG		= 1032,	// 盟主战场景TAG
};

enum FACTION_BASE_STATUS
{
	FBS_NORMAL		= 0,	//
	FBS_NO_MONEY		= 0x01,	//资金不足
	FBS_MERGE		= 0x02,	//合并过程中关闭
	FBS_ACTIVITY		= 0x04,	//活跃度不足关闭
	FBS_MEMBERS		= 0x08,	//人数不足关闭

	FBS_CLOSED		= 0x80,	//已经关闭
};

enum FACTION_SYNC_STATUS
{
	FSS_BASE_STATUS		= 1, //同步基地状态
};

enum FACTION_BASE_INFO_TYPE
{
	FBIT_GET		= 1,
	FBIT_SET		= 2,
};

enum FACTION_HIREINFO_SYNC_TYPE
{
	FHST_INIT		= 1,	// 初始化
	FHST_ADD		= 2,	// 增加
	FHST_DEL		= 3,	// 删除
	FHST_UPDATE		= 4,	// 更新
};

enum TIZI_SYNC_TYPE
{
	TST_INIT		= 1,	//初始化
	TST_ADD			= 2,	//新增
	TST_DEL			= 3,	//删除
};

const int faction_inst_tid[] = {
		1247,		//镖局对应副本模版id：1247
		1249,		//马帮对应的副本模版id：1249
		1248,		//山寨对应的副本模版ID：1248
		1250,		//工坊对应的副本模版id：1250
};

inline bool IsMafiaBase(int tid)
{
	for(size_t i = 0; i < sizeof(faction_inst_tid) / sizeof(faction_inst_tid[0]) ; ++i)
		if(tid == faction_inst_tid[i]) return true;
	return false;
}

enum {
	FACTION_DOMAIN_COUNT		= 4,	// 产业数量
	FACTION_BUILD_COUNT		= 7,	// 建筑类型数量
	FACTION_BUILD_LIVING		= 2,	// 后勤处的index
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

	//帮派升级需求建设度
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
		// 部分独立职位不可再任
		if (position >= FP_VICEMASTER1 && position <= FP_SUBMASTER) {
			for (FactionMemberMapIter it = members.begin(), ie = members.end(); it != ie; ++it) {
				if (it->second->GetPosition() == position) {
					if (position != FP_SUBMASTER) return ERROR_FACTION_UNAVAILABLE;
					// 分舵主还需要看所属分舵
					if (it->second->GetSubfaction() == subfaction) return ERROR_FACTION_UNAVAILABLE;
				}
			}
		}
		// 其他职位有人数限制
		if (position >= FP_BEAUTY && position <= FP_SUBMASTER_TRUSTED) {
			unsigned short max = PositionMax(flevel, position);
			unsigned short n = 0;
			for (FactionMemberMapIter it = members.begin(), ie = members.end(); it != ie; ++it) {
				if (it->second->GetOwner() == op_pos && it->second->GetPosition() == position) {
					if (++n >= max) return ERROR_FACTION_UNAVAILABLE;
				}
			}
		}
		// 任免分舵主需要检查当前已分配分舵情况和当前建设度
		if (position == FP_SUBMASTER) {
			Sub2Cons_MapIter sit = sub2cons.find(subfaction);
			if(sit == sub2cons.end() || sit->second > construction) return ERROR_FACTION_UNAVAILABLE;
		}
		return 0;
	}

	template<typename FactionMemberVector, typename FactionMemberVectorIter>
	static int CheckNumberDB(uchar op_pos, uchar position, int flevel, int subfaction, const FactionMemberVector& members)
	{
		// 部分独立职位不可再任
		if (position >= FP_VICEMASTER1 && position <= FP_SUBMASTER) {
			for (FactionMemberVectorIter it = members.begin(), ie = members.end(); it != ie; ++it) {
				if (it->position == position) {
					if (position != FP_SUBMASTER) return ERROR_FACTION_UNAVAILABLE;
					// 分舵主还需要看所属分舵
					if (it->subfaction == subfaction) return ERROR_FACTION_UNAVAILABLE;
				}
			}
		}
		// 其他职位有人数限制
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

		// 挂名成员不可任免
		if (dst_ti == FTI_TMP) return ERROR_FACTION_TMP_MEMBER;
		// 帮主不可任免
		if (position == FP_MASTER || dst_pos == FP_MASTER) return ERROR_FACTION_PERMISSION;
		// 夫人不可任免
		if (position == FP_MASTER_SPOUSE || position == FP_VICEMASTER_SPOUSE
		    || dst_pos == FP_MASTER_SPOUSE || dst_pos == FP_VICEMASTER_SPOUSE)
		{
			return ERROR_FACTION_PERMISSION;
		}
		// 他人的亲信不可任免
		if (dst_ow && dst_ow != op_pos) return ERROR_FACTION_PERMISSION;
		// 不存在的分舵不能任免分舵主
		//if (position == FP_SUBMASTER && find(subfactions.begin(), subfactions.end(), subfaction) == subfactions.end())
		//	return ERROR_FACTION_PERMISSION;
		// 任免分舵主至于帮派建设度相关了，和王磊版本的分舵功能完全无关了
		if(position == FP_SUBMASTER)
		{
			//bool have = false;
			//for(CIT it = subfactions.begin(); it != subfactions.end(); ++it)
			//	if(it->id == subfaction)
			//		have = true;
			//if(!have) return ERROR_FACTION_SUBFACTION;
			if(subfaction < FSN_1 || subfaction > FSN_16) return ERROR_FACTION_PERMISSION;
		}

		// 副帮主对帮派等级有要求
		if (position == FP_VICEMASTER2 && flevel < 5) return ERROR_FACTION_WRONG_POSITION;
		if (position == FP_VICEMASTER3 && flevel < 8) return ERROR_FACTION_WRONG_POSITION;
	
		bool ok = false;
		if (op_pos == FP_MASTER) {
			// 帮主在任免
			if (position != FP_HUFA_TRUSTED && position != FP_ZHANGLAO_TRUSTED && position != FP_SUBMASTER_TRUSTED)
				ok = true;
		} else if (op_pos >= FP_VICEMASTER1 && op_pos < FP_HUFA1) {
			// 副帮主在任免
			// 亲信
			if ((position == FP_MASTER_TRUSTED && dst_pos == FP_NONE) || (position == FP_NONE && dst_pos == FP_MASTER_TRUSTED))
				ok = true;
			// 任免职位
			if ( ((position >= FP_SUBMASTER && position <= FP_DOCTOR) || position == FP_NONE) &&
			     (dst_pos == FP_NONE || dst_pos == FP_MASTER_TRUSTED || (dst_pos>=FP_SUBMASTER && dst_pos<=FP_DOCTOR)))
				ok = true;
		} else if (op_pos >= FP_HUFA1 && op_pos < FP_ZHANGLAO1) {
			// 护法在任免
			// 选亲信
			if (position == FP_HUFA_TRUSTED && dst_pos == FP_NONE) ok = true;
			// 免职
			if (position == FP_NONE && dst_pos == FP_HUFA_TRUSTED) ok = true;
		} else if (op_pos >= FP_ZHANGLAO1 && op_pos < FP_SUBMASTER) {
			// 长老在任免
			// 选亲信
			if (position == FP_ZHANGLAO_TRUSTED && dst_pos == FP_NONE) ok = true;
			// 免职
			if (position == FP_NONE && dst_pos == FP_ZHANGLAO_TRUSTED) ok = true;
		} else if (op_pos == FP_SUBMASTER) {
			// 分舵主在任免
			// 选亲信
			if (position == FP_SUBMASTER_TRUSTED && dst_pos == FP_NONE && dst_sub == op_sub) ok = true;
			// 免职
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
		//其他限制
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
	ALGO_COMMON_SDK	= 3,	//玩家信息来自于“通用SDK”
	ALGO_TX_QQ		= 4,	//玩家信息来自于“手Q”
	ALGO_TX_WEIXIN	= 5,	//玩家信息来自于“微信”
	ALGO_TX_GUEST	= 6,	//玩家信息来自于“tx游客”
	ALGO_TW			= 7,	//玩家信息来自于台湾
	ALGO_VIETNAM	= 8,	//玩家信息来自于越南
	ALGO_KOREA      = 9,    //玩家信息来自于韩国
	ALGO_WANDA      = 10,   //来自于万达
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
	COOLDOWN_ID_PROPOSE = 2, // 求婚
	COOLDOWN_ID_RENEGE = 3,  // 悔婚
	COOLDOWN_ID_DIVORCE = 4, // 离婚
	COOLDOWN_ID_FAMILY = 5,
	COOLDOWN_ID_FRIEND_BUFF_SEND1 = 6, // 相邻两次friend_buff发送冷却
	COOLDOWN_ID_FRIEND_BUFF_SEND2 = 7, // 每天friend_buff发送次数上限冷却
	COOLDOWN_ID_FRIEND_BUFF_RECV = 8, // 相邻两次friend_buff接受冷却
	COOLDOWN_ID_SECT_QUIT = 9, // 叛师冷却
	COOLDOWN_ID_SECT_EXPEL = 10, // 开除徒弟冷却
	COOLDOWN_ID_HOME_AMBUSH = 11, // 家园埋伏冷却
	COOLDOWN_ID_HOME_STEALCAUGHT = 12, // 家园偷窃被抓
	COOLDOWN_ID_FACTION_QUIT = 13, // 退出帮派
	COOLDOWN_ID_FACTION_ACTIVITY = 14, // 帮派报道加活跃度
	COOLDOWN_ID_FACTION_EXPEL = 15, // 帮派踢人
	COOLDOWN_ID_FACTION_UPDATEFACTIONINFO = 16, // 帮派成员更新帮派信息
	COOLDOWN_ID_FACTION_APPLYJOININ = 17, // 玩家申请加入帮派
	COOLDOWN_ID_AUCTION_INFO = 18,		// 玩家获取拍卖信息
	COOLDOWN_ID_MARRY = 19, // 结婚申请发起后一定时间内不能再次发起结婚申请
	COOLDOWN_ID_ADD_APPLY = 20, //帮会申请
	COOLDOWN_ID_CANCLE_APPLY = 21, //帮会取消申请
	COOLDOWN_ID_CHECK_TX_CASH = 22, //查询tx元宝余额
	COOLDOWN_ID_LEAVE_BANGHUI = 23, //离开帮会的CD
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
	COOLDOWN_COUNT_FRIEND_BUFF_SEND2_MAX = 100, /* 最多每天可以发100个friend_buff */
	COOLDOWN_COUNT_FACTION_EXPEL = 5, /* 最多每天可以踢5个人 */
	COOLDOWN_COUNT_AUCTION_INFO  = 2, /* 最多 3s 2次 */
};

enum {
	MARRIAGE_ST_SINGLE = 0, // 单身
	MARRIAGE_ST_ENGAGED = 1, // 已订婚
	MARRIAGE_ST_MARRIED = 2, // 已结婚
};
enum
{
	MARRIAGE_OP_PROPOSE = 0, // 订婚
	MARRIAGE_OP_RENEGE = 1, // 毁婚
	MARRIAGE_OP_MARRY = 2, // 结婚
	MARRIAGE_OP_DIVORCE = 3, // 离婚
};

enum VOTE_TYPE {
	VOTE_ID_MARRY = 0, // 为结婚投票
	VOTE_ID_FAMILY_CREATE = 1, // 为建立结义投票
	VOTE_ID_FAMILY_ADD = 2, // 为结义添加成员投票
	VOTE_ID_FAMILY_CHANGE_NAME = 3, // 为结义改名投票
	VOTE_ID_FAMILY_EXPEL = 4, // 为开除某个结义成员投票
	VOTE_ID_FAMILY_CALL = 5, // 是否同意结义召集
	VOTE_ID_SOS = 6, // 是否同意呼救
	VOTE_ID_FACTION_MERGE = 7,// 帮派合并投票
	VOTE_ID_FACTION_SCORE = 8,// 帮派管理人员评分投票
	VOTE_ID_FACTION_MERGED = 9,// 帮派被合并投票
	VOTE_ID_FACTION_REBEL = 10,// 帮派篡权投票
	VOTE_ID_FACTION_TRANS = 11,// 帮派合并选人
};

enum {
	FAMILY_SAVE_OP_CREATE = 0, // 建立结义
	FAMILY_SAVE_OP_ADD = 1, // 添加结义成员
	FAMILY_SAVE_OP_CHANGE_NAME = 2, // 修改结义名
	FAMILY_SAVE_OP_EXPEL = 3, // 开除结义成员
	FAMILY_SAVE_OP_QUIT = 4, // 退出结义
};

enum {
	FAMILY_MEMBER_MAX		= 6,
	FAMILY_MEMBER_LEVEL_MIN		= 30,
	FAMILY_MEMBER_AMITY_MIN		= 3000,
	FAMILY_LEAVE_MESSAGE_MAX	= 100,	// 结义留言最长

	MARRIAGE_VOTE_DURATION = 180,	// 结婚投票期
	FAMILY_VOTE_DURATION = 300,	// 结义投票期
	FAMILY_CALL_DURATION = 60,	// 结义召集
	SOS_DURATION = 180,		// 呼救超时
	WEDDING_DURATION = 3600,	//一场婚礼的秒数，一小时

	FAMILY_VOTE_MAX = 10,	// 最多能保存的结义内投票项，包含正在投票中的已经结束的
	FAMILY_VOTE_VOTING_MAX = 3,	// 最多可同时进行的结义内投票
	FAMILY_VOTE_TIME = 7 * 24 * 3600,	// 结义内投票的有效期
	MAX_ALLIANCEWAR_APPLY_FAMILY	= 50,	// 参加盟主战结义上限
};

enum {
	FRIEND_ADD_AMITY_MAX = 100,	// 加好友时的最大初始好感度
	FRIEND_LIST_CONTACTS_MAX = 10,	// 列出他人好友时的最多数量
};

// IPCTxn相关
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

enum ITEM_LOCATION//物品位置
{
	IL_INVALID = 0xFF,

	IL_EQUIPMENT = 0,	//0装备
	IL_BACKPACK,		//1背包
	IL_TASK_ITEM,		//2任务物品包
	IL_MATERIAL,		//3材料物品包		//已经作废，不存盘了
	IL_DEPOSITORY,		//4仓库          
	IL_MAFIA_STORE,         //5帮派仓库     ******
	IL_RECYCLE_BIN,		//6回收站       
	IL_TEMP_BACK,		//7临时包裹，过关时获得的奖励会先放在这里，在关底升阶
	IL_TITLE_PACK,		//8称号包裹栏

/*	
	临时包裹
	名人装备1~8
*/
	IL_COUNT,

	IL_HERO_EQUIP_START = 50,	//名人等效包裹栏的起始，这个是虚拟包裹栏，不是真实的
};


//
// 家园系统相关
//
#define HOME_MANAGER_UPDATE_INTERVAL                     10 // 家园管理器更新周期，单位：秒
#define MAX_HOME_LEVEL                                   10 // 家园最大等级
#define MAX_HOME_POINTS                          2000000000 // 家园积分最大值
#define INIT_HOME_STOREHOUSE_CAPACITY                    30 // 家园仓库的初始栏位数
#define DEFAULT_HOME_STOREHOUSE_PILE_LIMIT             9999 // 家园仓库的默认物品堆叠数上限
#define MAX_HOME_LOG_COUNT                               50 // 家园菜园日志条数最大值
#define MAX_HOME_FARM_AMBUSH_COUNT                        5 // 家园菜园里最多可埋伏的玩家数
// 随机状态相关
// 随机周期会根据物理时间进行调整，比如凌晨可能随机间隔会少，而上线密集时段会加快频率
#define HOME_RAND_PERIOD_NORMAL                      (2*60) // 正常随机周期，单位：秒
#define HOME_RAND_PERIOD_SLOWDOWN                    (3*60) // 低速随机周期，单位：秒
#define HOME_RAND_SLOWDOWN_STARTHOUR                      0 // 随机频率降低开始时间，单位：时（24小时制），0-23
#define HOME_RAND_SLOWDOWN_ENDHOUR                        6 // 随机频率降低结束时间，单位：时（24小时制），0-23
#define HOME_RAND_STATE_DURATION                     (2*60) // 异常状态持续时间，超时后异常状态自动解除
// 菜园等级相关
#define MAX_FARM_LEVEL                                   10 // 菜园最高等级
#define INIT_FARM_LEVEL                                   0 // 菜园初始等级
#define INIT_FARM_PLOT_COUNT                              4 // 菜园的初始地块数
// 菜园植物健康指数相关
#define DEFAULT_FARMCROP_HEALTH                         100 // 植物健康指数默认值
#define MAX_FARMCROP_HEALTH                             200 // 植物健康指数最大值
#define MIN_FARMCROP_HEALTH                               0 // 植物健康指数最小值，达到此值的植物即死亡
// 菜园作物状态相关
#define FARMCROP_ABNORMAL_REMOVAL_AWARD_HEALTH           10 // 在限定时间内解除作物异常状态所奖励的植物健康指数
#define FARMCROP_ABNORMAL_REMOVAL_AWARD_PRODUCE_POINT_MIN 1 // 解除作物异常状态所奖励的生产点最小值
#define FARMCROP_ABNORMAL_REMOVAL_AWARD_PRODUCE_POINT_MAX 5 // 解除作物异常状态所奖励的生产点最大值
// 家园埋伏相关
#define HOME_AMBUSH_DURATION                         (5*60) // 埋伏持续时间
// 家园偷窃相关
#define MAX_HOME_FARM_PLOT_STEAL_COUNT_PER_PLAYER         2 // 每人每地块偷窃的最大数量
#define MIN_HOME_FARM_STOLEN_COMPENSATE_POINTS            1 // 菜园被偷补偿的家园积分最小值
#define MAX_HOME_FARM_STOLEN_COMPENSATE_POINTS            5 // 菜园被偷补偿的家园积分最大值
// 养殖场等级相关
#define MAX_BREED_FIELD_LEVEL                            10 // 养殖场最高等级
#define INIT_BREED_FIELD_LEVEL                            0 // 养殖场初始等级
#define INIT_BREED_FIELD_ACTIVE_WIDTH                     4 // 养殖场地块初始开放状态(4x6)
#define INIT_BREED_FIELD_ACTIVE_LENGTH                    6 // 养殖场地块初始开放状态(4x6)
// 养殖圈相关
#define BREED_FENCE_TYPE_COUNT                            8 // 养殖圈形状数
#define MAX_PLOT_COUNT_PER_BREED_FENCE                    5 // 一个养殖圈最多可能占用的地块数
// 祈福相关
#define BREED_BLESS_PERIOD                     (60*60*24*2) // 祈福机会获取周期
#define BLESS_FENCE_TYPE_COUNT                           12 // 祈福圈形状数
#define MAX_PLOT_COUNT_PER_BLESS_FENCE                    8 // 一个祈福圈最多可能占用的地块数
#define INIT_MAX_BREED_BLESS_CHANCES                      3 // 初始最大累积祈福机会次数
#define INIT_BREED_BLESS_EFFECT                        1.50 // 初始祈福增益效果
// 养殖场动物健康指数相关
#define BREED_ANIMAL_HEALTH_DEFAULT                     100 // 植物健康指数默认值
#define BREED_ANIMAL_HEALTH_MAX                         200 // 植物健康指数最大值
// 养殖场动物生长值相关
#define BREED_ANIMAL_INC_GROW_POINT_PER_MINUTE            1 // 饱食状态每持续一分钟增长的生长值
#define BREED_ANIMAL_SYMBIOSE_EFFECT                    2.0 // 共生增益效果
#define BREED_ANIMAL_DEC_GROW_POINT_PER_MINUTE            1 // 饥饿状态每持续一分钟减少的生长值
// 养殖场动物状态相关
#define BREED_ABNORMAL_REMOVAL_AWARD_HEALTH              10 // 在限定时间内解除异常状态所奖励的健康指数
#define BREED_ABNORMAL_REMOVAL_AWARD_PRODUCE_POINT_MIN    1 // 解除异常状态所奖励的生产点最小值
#define BREED_ABNORMAL_REMOVAL_AWARD_PRODUCE_POINT_MAX    5 // 解除异常状态所奖励的生产点最大值

enum HOME_COMPONENT_TYPE {
	HOME_COMPONENT_NONE = 0, 
	HOME_COMPONENT_FARM = 1,        // 菜园
	HOME_COMPONENT_BREED_FIELD = 2, // 养殖场
};

enum HOME_COMPONENT_MASK {
	HOME_COMPONENT_MASK_FARM        = 0x01, // 菜园
	HOME_COMPONENT_MASK_BREED_FIELD = 0x02, // 养殖场
};

enum HOME_COMPONENT_STATE {
	HOME_COMPONENT_STATE_OPENED = 0, 
	HOME_COMPONENT_STATE_CLOSED = 1,
};


enum FARMPLOT_TYPE {
	FARMPLOT_TYPE_ORDINARY = 0, // 普通土地
};

enum FARMPLOT_STATE {
	FARMPLOT_STATE_INCULT         = 0, // 未开垦，由于家园等级限制而未开启的地块
	FARMPLOT_STATE_NORMAL         = 1, // 正常

	FARMPLOT_STATE_MAX,
};

enum FARMCROP_STATE {
	FARMCROP_STATE_INVALID        = 0, // 非法状态
	FARMCROP_STATE_NORMAL         = 1, // 正常

	FARMCROP_STATE_ABNORMAL_BEGIN = 2,
	// {异常状态
	FARMCROP_STATE_DRY            = 2, // 干旱
	FARMCROP_STATE_FLOODING       = 3, // 水淹
	FARMCROP_STATE_POOR           = 4, // 贫瘠
	FARMCROP_STATE_WEED           = 5, // 杂草
	FARMCROP_STATE_PEST           = 6, // 害虫
	// 异常状态} 
	FARMCROP_STATE_ABNORMAL_END,

	FARMCROP_STATE_GROWN          = 7, // 长成的
	FARMCROP_STATE_DEAD           = 8, // 枯萎的

	FARMCROP_STATE_MAX,
};

enum FARM_ACTION_TYPE {
	FARM_ACTION_PLOW          =  1, // 锄地，可清除地块上的植物，也可用于解除枯木状态
	FARM_ACTION_SOW           =  2, // 播种
	FARM_ACTION_WATER         =  3, // 浇水，可解除干旱状态
	FARM_ACTION_DRAIN         =  4, // 排水，可解除水淹状态
	FARM_ACTION_FERTILIZE     =  5, // 施肥，可解除贫瘠状态
	FARM_ACTION_WEED          =  6, // 拔草，可解除杂草状态
	FARM_ACTION_CLEARPEST     =  7, // 治虫，可解除生虫状态
	FARM_ACTION_HARVEST       =  8, // 采摘，把果实放到仓库，植物变成枯木
	FARM_ACTION_AMBUSH        =  9, // 埋伏，可抓获偷窃者
	FARM_ACTION_AMBUSH_CANCEL = 10, // 取消埋伏
	FARM_ACTION_STEAL         = 11, // 偷窃，可能失败，甚至被抓

	FARM_ACTION_STEALCAUGHT   = 12, // 偷窃被抓
	FARM_ACTION_CATCH_THIEF   = 13, // 抓住小偷
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

// 种植方式
enum FARM_PLANT_TYPE {
	FARM_PLANT_NORMAL    = 0, // 普通种植
	FARM_PLANT_INTENSIVE = 1, // 精耕
};

// 养殖场动物特殊状态
enum BREED_ANIMAL_STATE
{
	BREED_ANIMAL_STATE_NORMAL         = 0, // 正常

	BREED_ANIMAL_STATE_ABNORMAL_BEGIN = 1,
	// {异常状态
	BREED_ANIMAL_STATE_ABNORMAL1      = 1, // 瘟疫
	BREED_ANIMAL_STATE_ABNORMAL2      = 2, // 热症
	BREED_ANIMAL_STATE_ABNORMAL3      = 3, // 寒症
	BREED_ANIMAL_STATE_ABNORMAL4      = 4, // 积食
	BREED_ANIMAL_STATE_ABNORMAL5      = 5, // 痉挛
	// 异常状态}
	BREED_ANIMAL_STATE_ABNORMAL_END,

	BREED_ANIMAL_STATE_DEAD           = 6, // 死亡
};

// 治疗
enum BREED_ANIMAL_TREATMENT
{
	BREED_ANIMAL_TREAT_ABNORMAL1 = 1, // 喂药
	BREED_ANIMAL_TREAT_ABNORMAL2 = 2, // 通风
	BREED_ANIMAL_TREAT_ABNORMAL3 = 3, // 生火
	BREED_ANIMAL_TREAT_ABNORMAL4 = 4, // 针灸
	BREED_ANIMAL_TREAT_ABNORMAL5 = 5, // 推拿
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
	BREED_FIELD_BLESS_STEP1 = 0, // 开始祈福，获得祈福圈类型
	BREED_FIELD_BLESS_STEP2 = 1, // 放置祈福圈
	BREED_FIELD_BLESS_QUERY = 2, // 查询祈福信息
};

enum FORAGE_SOURCE_TYPE
{
	FORAGE_SOURCE_HOME_STOREHOUSE,    // 家园仓库
	FORAGE_SOURCE_MATERIAL_INVENTORY, // 材料包裹
};

enum
{
	SOCIAL_ACT_PROPOSE = 1,	//求婚
	SOCIAL_ACT_FRIEND = 2,	//加好友
};

enum CAMPAIGN_NOTIFY_TYPE
{
	CAMPAIGN_NOTIFY_NORMAL	= 1, // 普通信息
	CAMPAIGN_NOTIFY_TIMEOUT	= 2, // GS需要先清掉所有当前已经开放的活动 
};

enum CAMPAIGN_DBOPERATE_TYPE
{
	CAMPAIGN_DBOPERATE_LOADALL	= 1,//导出封禁列表和gm强开活动时间表
	CAMPAIGN_DBOPERATE_SAVEFORBID	= 2,//保存封禁/解禁信息
	CAMPAIGN_DBOPERATE_CLRFORBID	= 3,//清除封禁/解禁消息
	CAMPAIGN_DBOPERATE_SAVEGMOPEN	= 4,//保存GM强开时间信息
	CAMPAIGN_DBOPERATE_CLRGMOPEN	= 5,//清除GM强开时间信息
};

enum STOCK_ORDER_STATUS
{
	STOCK_ORDER_NORMAL    = 0, //正常挂单，可交易状态
	STOCK_ORDER_NEW       = 1, //临时挂单，不可交易状态
	STOCK_ORDER_TRADING   = 2, //交易过程中
};

enum BATTLE_OPTION_TYPE
{
	BOT_NAME	= 1,	// 修改房间名
	BOT_PASSWORD	= 2,	// 修改房间密码
	BOT_INVITATE	= 3,	// 邀请
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
	FCDT_WELFARE_EXP	= 3,	//当日福利经验累计
};

enum FACTION_CHANGE_DATA_MODE
{
	FCDM_REWARD		= 0,	//通用奖励改变
	FCDM_TASK		= 1,	//任务改变
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
	FRT_NONE		= 0,//不关心的重置情况
	FRT_ADDCITY		= 1,//增加分舵
	FRT_DELCITY		= 2,//减少分舵
	FRT_MAINCHANGE		= 3,//搬迁总舵
	FRT_CLRUNLINK		= 4,//清除不连通分舵
	FRT_RELOAD		= 5,//重导数据库
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
	DLS_FACTION	= 0x01,	//帮派数据
	DLS_FCITY	= 0x02,	//势力地图
	DLS_TOPLIST	= 0x04,	//排行榜

	DLS_ALL_FACTION_NEED	= DLS_FACTION | DLS_FCITY | DLS_TOPLIST,	//帮派相关的数据
};

enum TIZI_PLACE_TYPE
{
	TPT_BIGWORLD	= 0,	//大世界
	TPT_MAFIA_BASE	= 1,	//帮派基地
};

//团体竞赛副本阶段定义
enum TOURNAMENT_STAGE_TYPE
{
	TOURNAMENT_STAGE_INVALID     = 0, //非法
	TOURNAMENT_STAGE_INIT        = 1, //初始化
	TOURNAMENT_STAGE_ENTERING    = 2, //进场
	TOURNAMENT_STAGE_COMPETITION = 3, //比赛
	TOURNAMENT_STAGE_FINISH      = 4, //结束
};

enum SCENE_INFO_STATE_MASK
{
	SISM_MASTER_LINE		= 0x01,	//主镜像所在线
	SISM_FORCE_CLOSED		= 0x02,	//GS所在镜像强制关闭
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
	AU_TYPE_AUCTION		= 0,	// 拍卖
	AU_TYPE_BID		= 1,	// 竞价

	AU_TYPE_COUNT,
};

const int AUCTION_PRICE_ADD_MIN			= 50;	//最少
const double AUCTION_PRICE_ADD_MIN_RATE		= 0.01;	//最少为当前价格1%
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
	MST_AUCTION		= 1,	// 拍卖相关
};

class TimeConfig
{
private:
	enum TIME_TYPE
	{
		TIME_TYPE_ABSOLUTE_TIME_POINT, // 确切时间点
		TIME_TYPE_YEARLY,              // 每年的某月某日某时某分某秒
		TIME_TYPE_MONTHLY_MDAY,        // 每月的某日某分某秒
		TIME_TYPE_MONTHLY_WDAY,        // 每月的第一个某周几某分某秒
		TIME_TYPE_WEEKLY,              // 每周的周几某时某分某秒
		TIME_TYPE_DAILY,               // 每天的某时某分某秒
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
			// 对于低端求爱NPC，当地时间每周日18:00点重置归属，2小时后检查恢复原归属（需要保证归属任务开放时间在两者之间），同时重置求爱相关声望
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
			// 对于高端求爱NPC，当地时间每月每一个周六18:00点重置归属，2小时后检查恢复原归属（需要保证归属任务开放时间在两者之间），同时重置求爱相关声望
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
				//转换代码，现在忽略
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
