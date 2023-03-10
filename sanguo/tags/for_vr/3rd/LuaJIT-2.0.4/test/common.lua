
G_ERRCODE = {}
G_ERRCODE["SUCCESS"] = 0
G_ERRCODE["NO_ROLE"] = 1
G_ERRCODE["CREATING_ROLE"] = 2
G_ERRCODE["INVALID_NAME"] = 3
G_ERRCODE["USED_NAME"] = 4
G_ERRCODE["SYSTEM_INVALID"] = 5
G_ERRCODE["YUANBAO_LESS"] = 6   --元宝不足
G_ERRCODE["NO_MAFIA"] = 101
G_ERRCODE["CREATING_MAFIA"] = 102

G_ERRCODE["TASK_ID_CURRENT"]  = 201 --当前的任务中不存在这个ID
G_ERRCODE["TASK_NOT_FINISH"]  = 202 --这个任务还没有完成
G_ERRCODE["TASK_NOT_EXIST"]   = 203 --当前的模板中不存在这个任务
G_ERRCODE["TASK_NOT_LEVEL"]   = 204 --当前等级还不应该有这个任务。

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

G_ERRCODE["NO_ITEM"] = 381 --物品的ID不存在
G_ERRCODE["NO_ITEM_TYPE"] = 382 --物品的TYPE类型没有进行填写.无法使用
G_ERRCODE["HERO_EXP_FULL"] = 384 --玩家没有这个武将
G_ERRCODE["TEM_NO_HERO"] = 385 --玩家没有这个武将
G_ERRCODE["ITEM_COUNT_LESS"] = 386 --物品数量不足
G_ERRCODE["NOT_EXP_ITEM"] = 387 --物品数量不足

G_ERRCODE["MAX_HERO_ORDER"] = 390 --英雄达到最高的界别
G_ERRCODE["NOT_MAX_LEVEL_ORDER"] = 391 --英雄未达到当前界别的最高等级

G_ERRCODE["PVP_HERO_COUNT_ERR"] = 401 --出阵武将的数量错误

G_ERRCODE["PVP_STATE_ERROR"] = 411 --PVP对手状态出现异常。请重新进行匹配
G_ERRCODE["PVP_INVITE_STATE_ERROR"] = 412 --PVP对手状态出现异常。请重新进行邀请

G_ERRCODE["HERO_NO_SKILLID"] = 421 --武将没有这个技能
G_ERRCODE["HERO_SKILLLV_WRONG"] = 422 --武将的这个技能等级错误
G_ERRCODE["HERO_SKILLLV_MONEY_LESS"] = 423 --武将升级技能金钱不足
G_ERRCODE["HERO_SKILLLV_MAX"] = 424 --武将的技能等级不可以超过武将等级
G_ERRCODE["HERO_SKILL_POINT_LESS"] = 425 --武将的技能点数不足
G_ERRCODE["HERO_SKILL_POINT_ZERO"] = 426 --只有武将的技能点数为0的时候才可以购买

G_ERRCODE["HERO_COMMENTS_SELF"] = 431--不可以给自己的武将评论点赞
G_ERRCODE["HERO_COMMENTS_DID"] = 432--已经给这个评论点过赞了
G_ERRCODE["HERO_COMMENTS_NOT_HAVE"] = 433--没有这个评论，无法进行点赞操作
G_ERRCODE["HERO_COMMENTS_NOT_WRITE"] = 434--没有给这个武将写过评论，如何重新写
G_ERRCODE["HERO_COMMENTS_CAN_NOT_WRITE"] = 435--这个武将不可以评论
G_ERRCODE["HERO_COMMENTS_MAX"] = 436--今天对这个武将评论达到上限

G_ACH_TYPE = {}
G_ACH_TYPE["STAGE_STAR"]  = 1
G_ACH_TYPE["STAGE_VIP"]  = 2
G_ACH_TYPE["STAGE_PVP"]  = 3

G_CHAT_TYPE = {}
G_CHAT_TYPE["CHAT_WORLD"] = 1
G_CHAT_TYPE["CHAT_MAFIA"] = 2
G_CHAT_TYPE["CHAT_PRIVATE"] = 3


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

