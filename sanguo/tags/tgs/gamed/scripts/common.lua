
G_ERRCODE = {}
G_ERRCODE["SUCCESS"] = 0
G_ERRCODE["NO_ROLE"] = 1
G_ERRCODE["CREATING_ROLE"] = 2
G_ERRCODE["INVALID_NAME"] = 3
G_ERRCODE["USED_NAME"] = 4
G_ERRCODE["SYSTEM_INVALID"] = 5
G_ERRCODE["YUANBAO_LESS"] = 6   --元宝不足
G_ERRCODE["LOAD_ROLE_DATA"] = 7   --重新去服务器Load角色数据了。稍等一会再次请求
G_ERRCODE["LOAD_ROLE_DATA_AGAIN"] = 8   --重新去服务器Load角色数据了。稍等一会再次请求
G_ERRCODE["SYSTEM_DATA_ERR"] = 9   --系统数据错误
G_ERRCODE["NO_MAFIA"] = 101
G_ERRCODE["CREATING_MAFIA"] = 102
G_ERRCODE["MAFIA_HAVE"] = 103		--已经有帮会了，无法创建帮会
G_ERRCODE["MAFIA_NAME_USED"] = 104	--名字重复了，请重新用一个名字
G_ERRCODE["MAFIA_APPLY_HAVE_MAFIA"] = 105	--你已经有帮会了，无法申请帮会
G_ERRCODE["MAFIA_APPLY_LEVEL_LESS"] = 106	--自己的等级不符合申请等级
G_ERRCODE["MAFIA_APPLY_HAVE_IN_APPLY"] = 107	--你已经在这个帮会的申请列表中了
G_ERRCODE["MAFIA_APPLY_MAX_NUM"] = 108	--帮会的申请上限达到了最大
G_ERRCODE["MAFIA_QUIT_NO_MAFIA"] = 109	--没有帮会怎么退出帮会呀
G_ERRCODE["MAFIA_QUIT_BANGZHU_ERR"] = 110	--帮主不可以退出帮会
G_ERRCODE["MAFIA_SET_LEVEL_ERR"] = 111	--权限不够，无法修改申请等级以及是否需要批准
G_ERRCODE["MAFIA_ANNOUNCE_INVALID"] = 112	--存在非法字符。重新设置
G_ERRCODE["MAFIA_KICKOUT_NO_ROLE"] = 113	--踢出的玩家不在自己的帮会中
G_ERRCODE["MAFIA_KICKOUT_NO_SELF"] = 114	--不可以自己踢出去自己
G_ERRCODE["MAFIA_KICKOUT_NO_POWER"] = 115	--你没有权限踢出这个玩家，比如说一个军师想要踢出帮主
G_ERRCODE["MAFIA_ACCEPT_MEMBER_MAX"] = 116	--帮会人数达到了上限，无法再添加人员
G_ERRCODE["MAFIA_ACCEPT_NO_MEMBER"] = 117	--帮会申请列表中没有这个成员
G_ERRCODE["MAFIA_ACCEPT_NO_ROLE"] = 118		--玩家不存在。
G_ERRCODE["MAFIA_ACCEPT_HAVE_MAFIA"] = 119	--玩家已经有帮会了
G_ERRCODE["MAFIA_POSITION_HIGH_SELF"] = 120	--不可以任命比自己高的职位
G_ERRCODE["MAFIA_POSITION_NO_CHANGE"] = 121	--职位没有任何的变化，有什么好发过来的。
G_ERRCODE["MAFIA_SHANRANG_ERR"] = 122		--只有帮主才可以进行禅让
G_ERRCODE["MAFIA_POSITION_MAX_NUM"] = 123	--这个职位的人数达到最高
G_ERRCODE["MAFIA_JISI_MAX_NUM"] = 124		--今日的祭祀次数已经达到了上限
G_ERRCODE["MAFIA_JISI_TYP_ERR"] = 125		--祭祀类型错误
G_ERRCODE["MAFIA_JISI_MONEY_ERR"] = 126		--祭祀金钱不足
G_ERRCODE["MAFIA_JISI_YUANBAO_ERR"] = 127	--祭祀元宝不足

G_ERRCODE["TASK_ID_CURRENT"]  = 201 --当前的任务中不存在这个ID
G_ERRCODE["TASK_NOT_FINISH"]  = 202 --这个任务还没有完成
G_ERRCODE["TASK_NOT_EXIST"]   = 203 --当前的模板中不存在这个任务
G_ERRCODE["TASK_NOT_LEVEL"]   = 204 --当前等级还不应该有这个任务。
G_ERRCODE["TASK_NOT_TIME"]    = 205 --当前任务不在规定的时间范围之内

G_ERRCODE["NO_TONGGUAN"] = 301 --不足3星，无法扫荡
G_ERRCODE["NO_ENOUGHVP"] = 302 --体力不足，无法扫荡
G_ERRCODE["NO_COUNT"]	 = 303 --副本次数不足
G_ERRCODE["NO_SWEEPITEM"]= 304 --扫荡令不足，无法扫荡
G_ERRCODE["NO_TONGGUAN"] = 305 --还没有通关副本，无法扫荡
G_ERRCODE["NO_STAGE"] 	 = 306 --没有这个关卡
G_ERRCODE["NO_REQSTAGE"] = 307 --没有打过前置关卡
G_ERRCODE["NO_REQSTAR"]  = 308 --前置关卡的星级没有达到要求
G_ERRCODE["NO_LEVEL"]	 = 309 --玩家的等级没有达到要求
G_ERRCODE["NO_FAIL"]	 = 310 --玩家没有打过这个副本
G_ERRCODE["NO_STAR"]	 = 311 --通关了，但是没有星星
G_ERRCODE["NO_HERO"]	 = 312 --结束副本，发过来的武将信息有错误，玩家没有这个武将
G_ERRCODE["NO_REQ_HERO"] = 313 --结束副本，发过来的强制出战的武将信息有错误
G_ERRCODE["HERO_COUNT_ERR"] = 314 --武将的数量错误，大于了3个。
G_ERRCODE["REQ_HERO_ERR"] = 315 --强制出战的武将ID信息错误
G_ERRCODE["INSTANCE_NO_COUNT"] = 316 --副本购买次数达到上限

G_ERRCODE["NO_COMLIMIT"] = 351 --没有配置体力的限次模板
G_ERRCODE["VP_NO_COUNT"] = 352 --购买次数已经达到上限
G_ERRCODE["VP_SYSTEM_ERROR"] = 353 --系统数据有了错误
G_ERRCODE["VP_LESS_YUANBAO"] = 354 --玩家的元宝不足

G_ERRCODE["BUY_INSTANCE_COUNT_HAVE"] = 361 --还有次数不可以重置
G_ERRCODE["CAN_NOT_BUY_INSTANCE_COUNT"] = 362 --不可以购买次数
G_ERRCODE["INSTANCE_SYSTEM_COUNT"] = 363 --副本购买次数配置错误


G_ERRCODE["HERO_ID_ERROR"] = 371 --武将的ID错误
G_ERRCODE["HAVED_HERO"] = 372 --已经有这个武将了，无法购买
G_ERRCODE["HERO_CAN_NOT_BUY"] = 373 --这个武将无法通过购买获得
G_ERRCODE["HERO_BUY_MONEY_LESS"] = 374 --铜币不足
G_ERRCODE["HERO_BUY_TYPE_ERROR"] = 375 --英雄购买的类型错误
G_ERRCODE["HERO_BUY_SOUL_LESS"] = 376 --武魂不足

G_ERRCODE["NO_ITEM"] = 381 --物品的ID不存在
G_ERRCODE["NO_ITEM_TYPE"] = 382 --物品的TYPE类型没有进行填写.无法使用
G_ERRCODE["HERO_EXP_FULL"] = 384 --玩家没有这个武将
G_ERRCODE["TEM_NO_HERO"] = 385 --玩家没有这个武将
G_ERRCODE["ITEM_COUNT_LESS"] = 386 --物品数量不足
G_ERRCODE["NOT_EXP_ITEM"] = 387 --物品数量不足

G_ERRCODE["MAX_HERO_ORDER"] = 390 --英雄达到最高的界别
G_ERRCODE["NOT_MAX_LEVEL_ORDER"] = 391 --英雄未达到当前界别的最高等级
G_ERRCODE["HERO_SKILLLV_UPGRADE_MONEY_LACK"] = 392 --武将突破金钱不足

G_ERRCODE["PVP_HERO_COUNT_ERR"] = 401 --出阵武将的数量错误

G_ERRCODE["PVP_STATE_ERROR"] = 411 --PVP对手状态出现异常。请重新进行匹配
G_ERRCODE["PVP_INVITE_STATE_ERROR"] = 412 --PVP对手状态出现异常。请重新进行邀请
G_ERRCODE["PVP_NET_TYPE_ERR"] = 413 --PVP自己的网络类型错误
G_ERRCODE["PVP_LATENCY_LARGE"] = 414 --PVP自己的网络延迟过大

G_ERRCODE["HERO_NO_SKILLID"] = 421 --武将没有这个技能
G_ERRCODE["HERO_SKILLLV_WRONG"] = 422 --武将的这个技能等级错误
G_ERRCODE["HERO_SKILLLV_MONEY_LESS"] = 423 --武将升级技能金钱不足
G_ERRCODE["HERO_SKILLLV_MAX"] = 424 --武将的技能等级不可以超过武将等级
G_ERRCODE["HERO_SKILL_POINT_LESS"] = 425 --武将的技能点数不足
G_ERRCODE["HERO_SKILL_POINT_ZERO"] = 426 --只有武将的技能点数为0的时候才可以购买
G_ERRCODE["HERO_SKILL_NOT_LEVELUP"] = 427 --技能不可以升级
G_ERRCODE["HERO_SKILLLV_WRONG_PARAM"] = 428 --传入参数错误
G_ERRCODE["HERO_SKILLLV_RESET_MONEY_LACK"] = 429 --武将技能重置元宝不足
G_ERRCODE["HERO_SKILLLV_RESET_INVALID"] = 430 --武将技能重置无效，已是最低等级

G_ERRCODE["HERO_COMMENTS_SELF"] = 431--不可以给自己的武将评论点赞
G_ERRCODE["HERO_COMMENTS_DID"] = 432--已经给这个评论点过赞了
G_ERRCODE["HERO_COMMENTS_NOT_HAVE"] = 433--没有这个评论，无法进行点赞操作
G_ERRCODE["HERO_COMMENTS_NOT_WRITE"] = 434--没有给这个武将写过评论，如何重新写
G_ERRCODE["HERO_COMMENTS_CAN_NOT_WRITE"] = 435--这个武将不可以评论
G_ERRCODE["HERO_COMMENTS_MAX"] = 436--今天对这个武将评论达到上限

G_ERRCODE["PVP_VIDEO_NOT_EXIST"] = 441--这个战斗回放不存在
G_ERRCODE["PVP_VIDEO_NOT_EXIST_SELF"] = 442--你自己身上不存在这个录像

G_ERRCODE["CHAT_TOO_LONG"] = 451--聊天长度太长，请重新编辑，最大多少。
G_ERRCODE["CHAT_TO_SELF"] = 452--不可以跟自己私聊
G_ERRCODE["CHAT_NOT_ONLINE"] = 453--玩家不在线

G_ERRCODE["BLACKLIST_HAVE"] = 461--这个玩家已经在黑名单中了
G_ERRCODE["BLACKLIST_FRIEND"] = 462--对方是你的好友无法添加到黑名单里面

G_ERRCODE["MAIL_NOT_EXIST"] = 471--这个邮件不存在
G_ERRCODE["MAIL_NO_ATTACHMENT"] = 472--这个邮件没有附件

G_ERRCODE["SELECT_SKILL_NO_HERO"] = 481--玩家没有这个武将
G_ERRCODE["SELECT_SKILL_NUM_ERROR"] = 482--武将的技能数量错误
G_ERRCODE["SELECT_SKILL_ID_ERROR"] = 483--武将的技能不存在
G_ERRCODE["SELECT_SKILL_LEVEL_LESS"] = 484--武将的这个无双技能还没有达到开启的等级

G_ERRCODE["MALLITEM_ID_ERR"] = 501--购买的商店物品不存在
G_ERRCODE["MALLITEM_NUM_ERR"] = 502--购买的物品数量是0
G_ERRCODE["MALLITEM_MAX_ERR"] = 503--购买的物品次数超过了上限
G_ERRCODE["MALLITEM_MONEY_LESS"] = 504--购买物品所需的金币不足
G_ERRCODE["MALLITEM_YUANBAO_LESS"] = 505--购买物品所需的勾玉不足
G_ERRCODE["MALLITEM_TEM_ERR"] = 506--购买物品的模板错误
G_ERRCODE["MALLITEM_TEM_MONEY_ERR"] = 507--物品的购买价格出现错误，配置为0或者<0
G_ERRCODE["MALLITEM_REP_LESS"] = 508--购买物品所需的声望不足

G_ERRCODE["INSTANCE_NO_REQUEST"] = 521--副本没有强制武将
G_ERRCODE["INSTANCE_NO_HERO"] = 522--请首先设置出战阵容

G_ERRCODE["HERO_STAR_MAX"] = 531--武将已经达到了最高的星级
G_ERRCODE["HERO_STAR_ERR"] = 532--武将的星级错误
G_ERRCODE["HERO_STAR_SOUL_LESS"] = 533--武将的武魂错误

G_ERRCODE["PRIVATE_SHOP_ERR"] = 541--这个商店不存在
G_ERRCODE["PRIVATE_SHOP_CANOT_REFRESH"] = 542--这个商店不可以手动刷新
G_ERRCODE["PRIVATE_SHOP_REFRESH_MAX"] = 543--代表达到刷新上限
G_ERRCODE["PRIVATE_SHOP_REFRESH_PRICE_ERR"] = 544--商店刷新价格错误
G_ERRCODE["PRIVATE_SHOP_MONEY_TYPE_ERR"] = 545--神秘商店货币类型错误
G_ERRCODE["PRIVATE_SHOP_MONEY_LESS"] = 546--神秘商店金币不足
G_ERRCODE["PRIVATE_SHOP_YUANBAO_LESS"] = 547--神秘商店元宝不足
G_ERRCODE["PRIVATE_SHOP_REP_LESS"] = 548--神秘商店声望不足
G_ERRCODE["PRIVATE_SHOP_BUY_MAX"] = 549--神秘商店物品已经没有购买次数了
G_ERRCODE["PRIVATE_SHOP_ITEM_NOT_EXIST"] = 550--购买的物品不存在
G_ERRCODE["PRIVATE_SHOP_ITEM_INFO_ERR"] = 551--神秘商店物品的信息错误

G_ERRCODE["BATTLE_LIMIT_NO_COUNT"] = 571--战场没有限次模板了
G_ERRCODE["BATTLE_DATA_ERROR"] = 572--战场地图信息配置错误
G_ERRCODE["BATTLE_ID_NOT_EXIST"] = 573--不存在的战役
G_ERRCODE["BATTLE_HAVE_BEGIN"] = 574--战役已经开始了
G_ERRCODE["BATTLE_HAVE_END"] = 575--战役已经结束了
G_ERRCODE["BATTLE_HERO_NOT_EXIST"] = 576--战役不存在这个武将
G_ERRCODE["BATTLE_NOT_FINISH_REQ"] = 577--战役还没有完成前置战役
G_ERRCODE["BATTLE_SELECT_ZERO"] = 578--战役没有选择武将
G_ERRCODE["BATTLE_SELECT_MORE_HERO"] = 579--战役选择的武将数量过多
G_ERRCODE["BATTLE_LEVEL_LESS"] = 580--等级不足，不可以参加这个战役
G_ERRCODE["BATTLE_MOVE_SRC_ERR"] = 581--移动的起点错误
G_ERRCODE["BATTLE_MOVE_DST_ERR"] = 582--移动的终点不可达
G_ERRCODE["BATTLE_NOT_BEGIN"] = 583--战役还没有开始
G_ERRCODE["BATTLE_POSITION_NO_ARMY"] = 584--当前位置没有敌军
G_ERRCODE["BATTLE_ARMY_NOT_SAME"] = 585--战役位置的敌军信息不一致
G_ERRCODE["BATTLE_SET_HERO_INFO"] = 586--战役出战武将阵容错误，请重新设置
G_ERRCODE["BATTLE_VP_LESS"] = 587--战役体力不足，返回到上一个格子

G_ERRCODE["NO_HORSE"] = 601--没有这个马
G_ERRCODE["HERO_COUNT_ZERO"] = 602--武将数量不可以为0
G_ERRCODE["HORSE_COUNT_ZERO"] = 603--马战请设置出战的马
G_ERRCODE["BATTLE_STATE_NOT_SET_HERO"] = 604--战役的当前状态不可以设置出战武将
G_ERRCODE["BATTLE_HERO_HP_ZERO"] = 605--战役选择的武将血量为0

G_ERRCODE["NO_LOTTERY"] = 620 --没有这个抽奖模板
G_ERRCODE["LOTTERY_MONEY_NOTENOUGH"] = 621 --抽奖money不够 
G_ERRCODE["LOTTERY_YUANBAO_NOTENOUGH"] = 622 --抽奖yuanbao不够
G_ERRCODE["LOTTERY_COSTTYPE_NOTKNOWN"] = 623 --不知道的抽奖类型
G_ERRCODE["LOTTERY_REP_NOTENOUGH"] = 624  --卷轴抽奖不足    

G_ERRCODE["DAILY_SIGN_HAVE"] = 630 	--今天已经进行了签到
G_ERRCODE["DAILY_RESIGN_ERR"] = 631 	--没有补签的机会了

G_ERRCODE["JJC_RESET_PK_CD_ERR"] = 640 	--当前不需要重置时间
G_ERRCODE["JJC_RESET_PK_CD_YUANBAO_LESS"] = 641 	--重置CD所需的元宝不足
G_ERRCODE["JJC_BUY_PK_COUNT_ERR"] = 642 	--当前还有次数无法购买
G_ERRCODE["JJC_BUY_PK_COUNT_MAX"] = 643 	--已经达到当前VIP等级的最大次数
G_ERRCODE["JJC_BUY_PK_COUNT_SYSREM_ERR"] = 644 	--购买价格，系统配置错误
G_ERRCODE["JJC_BUY_PK_COUNT_YUANBAO_LESS"] = 645 	--元宝不足，无法购买次数
G_ERRCODE["JJC_ATTACK_COUNT_LESS"] = 646 	--次数不足，无法进攻
G_ERRCODE["JJC_PLAYER_LESS"] = 647 	--服务器人数不足，暂未开放
G_ERRCODE["JJC_ATTACK_CD"] = 648 	--处于进攻CD中，当前无法进攻
G_ERRCODE["JJC_END_NO_OPPO"] = 649 	--处于进攻CD中，当前无法进攻
G_ERRCODE["JJC_VIDEO_NOT_EXIST"] = 650 	--JJC录像已经不存在了
G_ERRCODE["JJC_RANK_ERR"] = 651 	--JJC玩家排名错误
G_ERRCODE["JJC_JOIN_RANK_ERR"] = 652 	--JJC玩家排名错误
G_ERRCODE["JJC_CHALLENGE_ROLE_NOT_EXIST"] = 653 	--JJC玩家不存在
G_ERRCODE["JJC_ITEM_NOT_EXIST"] = 654 	--激战道具不存在

G_ERRCODE["WEAPON_EQUIP_HERO_ERR"] = 671 	--武将不存在
G_ERRCODE["WEAPON_EQUIP_LEVEL_LESS"] = 672 	--武将武器装备等级不足
G_ERRCODE["WEAPON_EQUIP_NOT_EXIST"] = 673 	--武将装备的武器不存在
G_ERRCODE["WEAPON_EQUIP_SYS_ERR"] = 674 	--策划配表错误
G_ERRCODE["WEAPON_EQUIP_TYPE_ERR"] = 675 	--装备类型不匹配
G_ERRCODE["WEAPON_LEVELUP_UNEQUIP"] = 676 	--武器没有装备，不可以升级
G_ERRCODE["WEAPON_LEVELUP_MAX_LEVEL"] = 677 	--武器达到最大等级，请先提升武将等级再来升级
G_ERRCODE["WEAPON_LEVELUP_MONEY_LESS"] = 678 	--武器升级，金钱不足
G_ERRCODE["WEAPON_STRENGTH_MAX"] = 679 		--武器强化达到了最高等级
G_ERRCODE["WEAPON_STRENGTH_ITEM_LESS"] = 680 	--武器强化,缺少相应的强化石
G_ERRCODE["WEAPON_DECOMPOSE_EQUIP"] = 681 	--已经装备的物品不可以分解

G_ERRCODE["TRIAL_ACTIVE_LEVEL_NOT_ENOUGH"] = 700 --试炼活动等级不够
G_ERRCODE["TRIAL_ACTIVE_DIFFICULTY_LOCK"] = 701 --试炼活动关卡难度尚未开启
G_ERRCODE["TRIAL_ACTIVE_PARAM_DIFFICULTY_WRONG"] = 702 --试炼活动难度参数错误
G_ERRCODE["TRIAL_ACTIVE_PARAM_STAGE_WRONG"] = 703 --试炼活动关卡参数错误
G_ERRCODE["TRIAL_ACTIVE_PARAM_HERO_NOT_EXIST"] = 704 -- 不存在的武将
G_ERRCODE["TRIAL_ACTIVE_PARAM_HERO_DEAD"] = 705 --上阵死亡英雄 
G_ERRCODE["TRIAL_ACTIVE_HAS_REFRESH"] = 706 --已经刷新过了
G_ERRCODE["TRIAL_ACTIVE_FAILED"] = 707 --武者试炼失败
G_ERRCODE["TRIAL_ACTIVE_DIFFICULTY_NOT_FOUND"] = 708 --难度找不到
G_ERRCODE["TRIAL_ACTIVE_STAGE_NOT_FOUND"] = 709 --关卡找不到
G_ERRCODE["TRIAL_ACTIVE_STAGE_STAGE_PASSED"] = 710 --关卡已经通关
G_ERRCODE["TRIAL_ACTIVE_STAGE_HERO_NOT_SELECTED"] = 711 --没有选择英雄
G_ERRCODE["TRIAL_ACTIVE_BOSSID_NOT_FIND"] = 712 --找不到关卡怪物id
G_ERRCODE["TRIAL_ACTIVE_REWARD_NOT_TAKEN"] = 713 --试炼奖励没通关 不可以领取
G_ERRCODE["TRIAL_ACTIVE_REWARD_HAS_TAKEN"] = 714 --试炼奖励已经领取
G_ERRCODE["TRIAL_ACTIVE_YUANBAO_NOT_ENOUGH"] = 715 --试炼扫荡元宝不足
G_ERRCODE["TRIAL_ACTIVE_STAGEINFO_NOT_FOUND"] = 716 --关卡信息找不到
G_ERRCODE["TRIAL_ACTIVE_BOSSINFO_NOT_FOUND"] = 717 --boss信息找不到
G_ERRCODE["TRIAL_ACTIVE_STAGE_SWEEP_NOT_ALLOWED"] = 718 --试炼关卡已经通关，不可以扫荡
G_ERRCODE["TRIAL_ACTIVE_STAGE_HAS_FIGHTED"] = 719 --试炼关卡已经打过

G_ERRCODE["EQUIPMENT_NOT_EXIST"] = 721 --装备不存在
G_ERRCODE["EQUIPMENT_HERO_NOT_EXIST"] = 722 --装备，不存在这个武将
G_ERRCODE["EQUIPMENT_BIND_OTHER_HERO"] = 723 --装备已经绑定了其他的武将，无法装备给这个武将
G_ERRCODE["EQUIPMENT_TYP_NOT_EXIST"] = 724 --装备类型不存在
G_ERRCODE["EQUIPMENT_TYP_NOT_MATCH"] = 725 --装备跟这个格子不符合
G_ERRCODE["EQUIPMENT_MAX_LEVEL"] = 726 --装备达到了最高等级
G_ERRCODE["EQUIPMENT_LEVEL_SYS_ERR"] = 727 --策划给装备等级升级表错误
G_ERRCODE["EQUIPMENT_LEVEL_MONEY_LESS"] = 728 --装备升级金钱不足
G_ERRCODE["EQUIPMENT_NO_UNEQUIP"] = 729 --当前位置没有装备，无法卸下装备
G_ERRCODE["EQUIPMENT_NOT_GRADE"] = 730 --这件装备不可以升阶
G_ERRCODE["EQUIPMENT_NOT_REFINABLE"] = 731 --这件装备不可以洗练
G_ERRCODE["EQUIPMENT_NO_REFINABLE_SAVE"] = 732 --这件装备没有属性可以进行保存
G_ERRCODE["EQUIPMENT_GRADE_EQUIP_LESS"] = 733 --物品进阶装备不足
G_ERRCODE["EQUIPMENT_GRADE_ITEM_LESS"] = 734 --物品进阶物品不足
G_ERRCODE["EQUIPMENT_GRADE_MAX"] = 735 --装备达到了最高阶别
G_ERRCODE["EQUIPMENT_DECOMPOSE_WEARED"] = 736 --已经装备的装备无法分解
G_ERRCODE["EQUIPMENT_NOT_DECOMPOSE"] = 737 --这个装备无法分解
G_ERRCODE["EQUIPMENT_LAST_REFINE"] = 738 --先完成上一次洗练结果的处理再进行下一次洗练
G_ERRCODE["EQUIPMENT_REFINE_MAX"] = 739 --洗练达到了最大值。请提升阶别（这里还有可能是已经达到了最高阶别）
G_ERRCODE["EQUIPMENT_REFINE_COUNT_ERR"] = 740 --洗练次数错误
G_ERRCODE["EQUIPMENT_REFINE_TYP_ERR"] = 741 --洗练类型错误
G_ERRCODE["EQUIPMENT_REFINE_MONEY_LESS"] = 742 --洗练需要的金钱不足
G_ERRCODE["EQUIPMENT_REFINE_GOUYU_LESS"] = 743 --洗练需要的勾玉不足
G_ERRCODE["EQUIPMENT_REFINE_ITEM_LESS"] = 744 --洗练需要的物品不足

G_ERRCODE["TONGQUETAI_SET_HERO_COUNT_LESS"] = 751 --铜雀台必须设置三个武将参加
G_ERRCODE["TONGQUETAI_SET_HERO_NO_HERO"] = 752 --武将不存在
G_ERRCODE["TONGQUETAI_JOIN_HERO_LESS"] = 753 --请先设置好3个武将再进行铜雀台活动的匹配
G_ERRCODE["TONGQUETAI_JOIN_IN_ACTIVITY"] = 754 --你现在正在匹配活动中，结束以后再进行下一次
G_ERRCODE["TONGQUETAI_CANCLE_JOIN"] = 755 --没有在匹配队列中。
G_ERRCODE["TONGQUETAI_JOIN_NO_COUNT"] = 756 --没有次数了
G_ERRCODE["TONGQUETAI_JOIN_SYS_COST_ERR"] = 757 --配置错误花费
G_ERRCODE["TONGQUETAI_JOIN_SYS_COST_TYP_ERR"] = 758 --配置花费类型错误
G_ERRCODE["TONGQUETAI_JOIN_COST_MONEY_LESS"] = 759 --需要的金钱不足
G_ERRCODE["TONGQUETAI_CANCLE_STATE_ERR"] = 760 --当前状态不可以取消匹配
G_ERRCODE["TONGQUETAI_PLAYER_DROP"] = 761 --玩家掉线，下一个玩家开始对战
G_ERRCODE["TONGQUETAI_FAIL_PLAYER_DROP"] = 762 --玩家掉线，这次活动失败
G_ERRCODE["TONGQUETAI_ATTACK_SUCCESS"] = 763 --玩家成功打死一个，开始打下一个
G_ERRCODE["TONGQUETAI_FAIL_ALL_DEAD"] = 764 --由于我方玩家全部阵亡，所以这次铜雀台失败了
G_ERRCODE["TONGQUETAI_REWARD_NOT_GET"] = 765 --还有上次的奖励没有领取，所以无法参加铜雀台，请先领取奖励
G_ERRCODE["TONGQUETAI_REWARD_NOT_EXIST"] = 766 --没有奖励可以领取。

G_ERRCODE["BATTLEFIELD_ROUND_STATE_ERR"] = 771 --战役回合状态错误
G_ERRCODE["BATTLEFIELD_ROUND_COUNT_LESS"] = 772 --战役没有回合次数了

G_ERRCODE["USE_ITEM_NOT_EXIST"] = 780 --物品不存在
G_ERRCODE["USE_ITEM_CAN_NOT_USE"] = 781 --物品不可以使用
G_ERRCODE["USE_ITEM_NUM_ERR"] = 782 --数量必须大于0
G_ERRCODE["USE_ITEM_NUM_LESS"] = 783 --你没有这么多物品
G_ERRCODE["USE_ITEM_KEY_NUM_LESS"] = 784 --你没有这么相应的钥匙，(这里需要注意一下，你使用箱子，那么钥匙就是对应的钥匙，你使用钥匙，那么箱子就是钥匙的钥匙)

G_ERRCODE["TEMPORARY_NO_ID"] = 791 --临时背包，你没有这个东西了

G_ERRCODE["LEGION_ACH_NOT_FINISH"] = 800 --还有相关战役没有完成，无法激活专精
G_ERRCODE["LEGION_HAVE_ACTIVE"] = 801 --已经激活了当前专精
G_ERRCODE["LEGION_LEARN_LEVEL_LESS"] = 802 --学习军学项目，玩家等级不足，还不可以学习
G_ERRCODE["LEGION_DECOMPOSE_ITEM"] = 803 --请选择你想要分解的武魂
G_ERRCODE["LEGION_DECOMPOSE_ITEM_NOT_EXIST"] = 804 --选择分解的武魂不存在
G_ERRCODE["LEGION_DECOMPOSE_ITEM_NOT_WUHUN"] = 805 --选择分解的物品不是武魂
G_ERRCODE["LEGION_DECOMPOSE_ITEM_COUNT_LESS"] = 806 --选择分解的武魂数量不足
G_ERRCODE["LEGION_XIANGMU_LEARNED"] = 807 --已经学习过了
G_ERRCODE["LEGION_XIANGMU_QIANZHI_UNLEARNED"] = 808 --前置没有学习
G_ERRCODE["LEGION_SPEC_MAX_LEVEL"] = 809 --专精等级达到最大，无法进行升级了

G_ERRCODE["MASHU_NOT_FRIEND"] = 810 --对方不是你的好友，无法助战
G_ERRCODE["MASHU_FRIEND_COUNT_MAX"] = 811 --这个好友的助战次数达到上限
G_ERRCODE["MASHU_BUY_BUFF_MONEY_LESS"] = 812 --购买BUFF金钱不足
G_ERRCODE["MASHU_BUY_BUFF_GOUYU_LESS"] = 813 --购买BUFF勾玉不足
G_ERRCODE["MASHU_BUY_BUFF_HAVE_BUFF"] = 814 --已经有了这个BUFF
G_ERRCODE["MASHU_SET_HERO_COUNT"] = 815 --只可以设置一个武将
G_ERRCODE["MASHU_SET_HORSE_ERR"] = 816 --必须设置出战的马匹
G_ERRCODE["MASHU_GET_PRIZE_NOT_RANK"] = 817 --昨日没有参加马术大赛，没有可以领取的奖励,想要得到奖励，记得每天都要参加呀
G_ERRCODE["MASHU_GET_PRIZE_HAVE_GET"] = 818 --你已经领取了昨日的奖励
G_ERRCODE["MASHU_FRIEND_MONEY_LESS"] = 819 --金钱不足，无法邀请这个好友助战
G_ERRCODE["MASHU_GET_PRIZE_RANK_LOW"] = 820 --昨日名次太低无法领取奖励

G_ERRCODE["FRIEND_REQUEST_NOT_ROLE"] = 830 --没有找到这个玩家
G_ERRCODE["FRIEND_REQUEST_HAVE"] = 831 --这个玩家已经是你的好友了
G_ERRCODE["FRIEND_REQUEST_HAVE_REQ"] = 832 --你已经对这个玩家进行了好友申请
G_ERRCODE["FRIEND_REQUEST_SELF_MAX"] = 833 --自己的好友数量达到最大
G_ERRCODE["FRIEND_REQUEST_OTHER_MAX"] = 834 --对方的好友数量达到最大
G_ERRCODE["FRIEND_REQUEST_SELF_BLACK_LIST"] = 835 --对方在自己的黑名单里面
G_ERRCODE["FRIEND_REQUEST_OTHER_BLACK_LIST"] = 836 --自己在对方的黑名单里面
G_ERRCODE["FRIEND_REPLY_ROLE_NOT_EXIST"] = 837 --玩家不存在

G_ERRCODE["LEGION_SPEC_ITEM_LESS"] = 851 --专精等级学习，物品不足
G_ERRCODE["LEGION_SPEC_EXP_LESS"] = 852 --专精等级学习，军学经验不足
G_ERRCODE["LEGION_LEARN_EXP_LESS"] = 853 --专精项目学习，经验不足
G_ERRCODE["LEGION_LEARN_JUNHUN_LESS"] = 854 --专精项目学习，军魂不足
G_ERRCODE["LEGION_LEARN_ITEM_LESS"] = 855 --专精项目学习，物品不足


G_ACH_TYPE = {}
G_ACH_TYPE["STAGE_STAR"]  = 1
G_ACH_TYPE["STAGE_VIP"]  = 2
G_ACH_TYPE["STAGE_PVP"]  = 3
G_ACH_TYPE["AUTO_FINISH"]  = 4  --每天定点完成的成就
G_ACH_TYPE["PVP_SERVER_FINISH"]  = 5  --服务器来进行每个PVP赛季发奖的东西
G_ACH_TYPE["STAGE_FINISH"]  = 6		--完成指定关卡以后的成就
G_ACH_TYPE["LEVEL_FINISH"]  = 7		--等级达到指定以后的成就
G_ACH_TYPE["STAGE_COUNT"]  = 8		--每日普通副本的次数
G_ACH_TYPE["STAGE_JINGYING_COUNT"]  = 9		--每日精英副本的次数
G_ACH_TYPE["STAGE_JINGYING_FINISH"]  = 10	--完成指定精英关卡以后的成就
G_ACH_TYPE["HUODONG_HUOYUE"]  = 11		--活跃度成就
G_ACH_TYPE["BATTLEFIELD_FINISH"]  = 12		--完成指定战役成就
G_ACH_TYPE["MAFIA_JISI"]  = 13			--祭祀进度
G_ACH_TYPE["MAFIA_QUIT"]  = 14			--离开帮会

G_CHAT_TYPE = {}
G_CHAT_TYPE["CHAT_WORLD"] = 1
G_CHAT_TYPE["CHAT_MAFIA"] = 2
G_CHAT_TYPE["CHAT_PRIVATE"] = 3

G_EVENT_TYPE = {}
G_EVENT_TYPE["MAIL_PVP_DAILY"] = 1
G_EVENT_TYPE["PVP_SEASON_FINISH"] = 2

G_KICKOUT_REASON = {}
G_KICKOUT_REASON["UNKNOWN"] = 1--未知原因
G_KICKOUT_REASON["EXE_OUT_OF_DATE"] = 2--客户端exe版本太老，需要更新
G_KICKOUT_REASON["DATA_OUT_OF_DATE"] = 3--客户端data版本太老，需要更新

G_MAFIA_POSITION = {}
G_MAFIA_POSITION["BANGZHU"] 	= 1	--帮主
G_MAFIA_POSITION["JUNSHI"] 	= 3	--军师
G_MAFIA_POSITION["XIANFENG"] 	= 5	--先锋
G_MAFIA_POSITION["JINGYING"] 	= 7	--精英
G_MAFIA_POSITION["PINGMIN"] 	= 9	--平民


function NewCommand(typ)
	local cmd = {}
	cmd.__type__ = typ
	return cmd
end

function NewMessage(typ)
	local msg = {}
	msg.__type__ = typ
	return msg
end

function NewStruct(typ)
	local struct = {}
	struct.__type__ = typ
	return struct
end


function _DumpTable(ot, t)
	for k,v in pairs(t) do
		if type(v)=="table" then
			ot[#ot+1] = k.."={"
			_DumpTable(ot, v)
			ot[#ot+1] = "};"
		elseif type(v)=="userdata" then
			ot[#ot+1] = k.."=USERDATA;"
		elseif type(v)=="boolean" then
			ot[#ot+1] = k.."="..tostring(v)..";"
		else
			ot[#ot+1] = k.."="..v..";"
		end
	end
end

function DumpTable(t)
	local ot = {}
	_DumpTable(ot, t)
	return table.concat(ot)
end

function AddTraceInfo(info)
	return info..debug.traceback("",2)
end

