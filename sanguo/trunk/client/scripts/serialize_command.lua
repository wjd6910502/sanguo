--DONT CHANGE ME!

local cmd_list = {}

function SerializeCommand(cmd)
	local os = {}

	if cmd_list[cmd.__type__] ~= nil then
		cmd_list[cmd.__type__](os, cmd)
	else
		error("wrong command type: "..cmd.__type__)
	end

	return table.concat(os)
end


cmd_list["EnterInstance"] = 
function(os, cmd)
	Serialize(os, 7)
	Serialize(os, cmd.inst_tid)
	if cmd.heros==nil then
		Serialize(os, 0)
	else
		Serialize(os, #cmd.heros)
		for i = 1, #cmd.heros do
			Serialize(os, cmd.heros[i])
		end
	end
	if cmd.req_heros==nil then
		Serialize(os, 0)
	else
		Serialize(os, #cmd.req_heros)
		for i = 1, #cmd.req_heros do
			Serialize(os, cmd.req_heros[i])
		end
	end

end

cmd_list["EnterInstance_Re"] = 
function(os, cmd)
	Serialize(os, 8)
	Serialize(os, cmd.retcode)
	Serialize(os, cmd.inst_tid)
	Serialize(os, cmd.seed)

end

cmd_list["CompleteInstance"] = 
function(os, cmd)
	Serialize(os, 9)
	Serialize(os, cmd.inst_tid)
	Serialize(os, cmd.flag)
	Serialize(os, cmd.score)
	if cmd.heros==nil then
		Serialize(os, 0)
	else
		Serialize(os, #cmd.heros)
		for i = 1, #cmd.heros do
			Serialize(os, cmd.heros[i])
		end
	end
	if cmd.req_heros==nil then
		Serialize(os, 0)
	else
		Serialize(os, #cmd.req_heros)
		for i = 1, #cmd.req_heros do
			Serialize(os, cmd.req_heros[i])
		end
	end
	if cmd.operations==nil then
		Serialize(os, 0)
	else
		Serialize(os, #cmd.operations)
		for i = 1, #cmd.operations do
			__SerializeStruct(os, "PVEOperation", cmd.operations[i])
		end
	end
	if cmd.star==nil then
		Serialize(os, 0)
	else
		Serialize(os, #cmd.star)
		for i = 1, #cmd.star do
			__SerializeStruct(os, "Instance_Star_Condition", cmd.star[i])
		end
	end
	Serialize(os, cmd.moneypiles)
	Serialize(os, cmd.chests)

end

cmd_list["CompleteInstance_Re"] = 
function(os, cmd)
	Serialize(os, 10)
	Serialize(os, cmd.retcode)
	Serialize(os, cmd.inst_tid)
	Serialize(os, cmd.score)
	Serialize(os, cmd.star)
	__SerializeStruct(os, "SweepInstanceData", cmd.rewards)
	Serialize(os, cmd.first_flag)
	Serialize(os, cmd.first_finish)

end

cmd_list["SyncRoleInfo"] = 
function(os, cmd)
	Serialize(os, 11)

end

cmd_list["OPStat"] = 
function(os, cmd)
	Serialize(os, 12)
	Serialize(os, cmd.opset_count)
	Serialize(os, cmd.op_count)

end

cmd_list["PVPInvite"] = 
function(os, cmd)
	Serialize(os, 10301)
	Serialize(os, cmd.dest_id)
	__SerializeStruct(os, "RoleBrief", cmd.src)
	Serialize(os, cmd.mode)

end

cmd_list["PVPReply"] = 
function(os, cmd)
	Serialize(os, 10302)
	Serialize(os, cmd.src_id)
	Serialize(os, cmd.accept)

end

cmd_list["PVPPrepare"] = 
function(os, cmd)
	Serialize(os, 10303)
	Serialize(os, cmd.id)
	__SerializeStruct(os, "RoleBrief", cmd.player1)
	__SerializeStruct(os, "RoleBrief", cmd.player2)
	Serialize(os, cmd.N)
	Serialize(os, cmd.mode)
	Serialize(os, cmd.p2p_magic)
	Serialize(os, cmd.p2p_peer_ip)
	Serialize(os, cmd.p2p_peer_port)

end

cmd_list["PVPReady"] = 
function(os, cmd)
	Serialize(os, 10304)

end

cmd_list["PVPBegin"] = 
function(os, cmd)
	Serialize(os, 10305)
	Serialize(os, cmd.fight_start_time)
	Serialize(os, cmd.ip)
	Serialize(os, cmd.port)
	Serialize(os, cmd.seed)

end

cmd_list["PVPOperation"] = 
function(os, cmd)
	Serialize(os, 10306)
	Serialize(os, cmd.client_tick)
	Serialize(os, cmd.op)
	Serialize(os, cmd.crc_tick)
	Serialize(os, cmd.crc)

end

cmd_list["PVPOperationSet"] = 
function(os, cmd)
	Serialize(os, 10307)
	Serialize(os, cmd.client_tick)
	Serialize(os, cmd.player1_op)
	Serialize(os, cmd.player2_op)

end

cmd_list["PVPEnd"] = 
function(os, cmd)
	Serialize(os, 10308)
	Serialize(os, cmd.result)
	Serialize(os, cmd.typ)
	Serialize(os, cmd.pvp_typ)
	Serialize(os, cmd.star)
	Serialize(os, cmd.win_count)
	Serialize(os, cmd.score)
	Serialize(os, cmd.duration)

end

cmd_list["PVPError"] = 
function(os, cmd)
	Serialize(os, 10309)
	Serialize(os, cmd.result)

end

cmd_list["PVPPeerLatency"] = 
function(os, cmd)
	Serialize(os, 10310)
	Serialize(os, cmd.latency)

end

cmd_list["PVPPause"] = 
function(os, cmd)
	Serialize(os, 10311)
	Serialize(os, cmd.pause_tick)
	Serialize(os, cmd.role_id)

end

cmd_list["PVPPause_Re"] = 
function(os, cmd)
	Serialize(os, 10312)
	Serialize(os, cmd.index)

end

cmd_list["PVPContinue"] = 
function(os, cmd)
	Serialize(os, 10313)
	Serialize(os, cmd.fight_continue_time)

end

cmd_list["PVPSendAutoVoice"] = 
function(os, cmd)
	Serialize(os, 10314)
	Serialize(os, cmd.hero_id)
	Serialize(os, cmd.voice_id)

end

cmd_list["PVPOperationRival"] = 
function(os, cmd)
	Serialize(os, 10315)
	Serialize(os, cmd.tick)
	Serialize(os, cmd.op)
	Serialize(os, cmd.confirm_tick)

end

cmd_list["PVPOperationReset"] = 
function(os, cmd)
	Serialize(os, 10316)
	Serialize(os, cmd.tick)
	Serialize(os, cmd.op)

end

cmd_list["PVPOperationCommit"] = 
function(os, cmd)
	Serialize(os, 10317)

end

cmd_list["UpdateHaveFinishBattle"] = 
function(os, cmd)
	Serialize(os, 10318)
	if cmd.battle_id==nil then
		Serialize(os, 0)
	else
		Serialize(os, #cmd.battle_id)
		for i = 1, #cmd.battle_id do
			Serialize(os, cmd.battle_id[i])
		end
	end

end

cmd_list["PVPDumpOP"] = 
function(os, cmd)
	Serialize(os, 10319)

end

cmd_list["RoleNameQuery"] = 
function(os, cmd)
	Serialize(os, 10321)
	Serialize(os, cmd.pattern)
	Serialize(os, cmd.reason)

end

cmd_list["RoleNameQuery_Re"] = 
function(os, cmd)
	Serialize(os, 10322)
	Serialize(os, cmd.pattern)
	if cmd.results==nil then
		Serialize(os, 0)
	else
		Serialize(os, #cmd.results)
		for i = 1, #cmd.results do
			__SerializeStruct(os, "RoleBrief", cmd.results[i])
		end
	end
	Serialize(os, cmd.reason)

end

cmd_list["BuyRefreshShopTimes"] = 
function(os, cmd)
	Serialize(os, 10323)
	Serialize(os, cmd.shop_id)

end

cmd_list["BuyRefreshShopTimes_Re"] = 
function(os, cmd)
	Serialize(os, 10324)
	Serialize(os, cmd.retcode)
	Serialize(os, cmd.shop_id)

end

cmd_list["GetShopRecoveryTime"] = 
function(os, cmd)
	Serialize(os, 10325)
	Serialize(os, cmd.shop_id)

end

cmd_list["GetShopRecoveryTime_Re"] = 
function(os, cmd)
	Serialize(os, 10326)
	Serialize(os, cmd.shop_id)
	Serialize(os, cmd.refresh_times)
	Serialize(os, cmd.recovery_time)

end

cmd_list["GetActivityReward"] = 
function(os, cmd)
	Serialize(os, 10327)
	Serialize(os, cmd.activity_id)

end

cmd_list["GetActivityReward_Re"] = 
function(os, cmd)
	Serialize(os, 10328)
	Serialize(os, cmd.retcode)
	Serialize(os, cmd.activity_id)
	if cmd.rewards==nil then
		Serialize(os, 0)
	else
		Serialize(os, #cmd.rewards)
		for i = 1, #cmd.rewards do
			__SerializeStruct(os, "Item", cmd.rewards[i])
		end
	end

end

cmd_list["GetJiaNianHuaInfo"] = 
function(os, cmd)
	Serialize(os, 10329)

end

cmd_list["GetJiaNianHuaInfo_Re"] = 
function(os, cmd)
	Serialize(os, 10330)
	Serialize(os, cmd.join_flag)

end

cmd_list["GetClientLocalTime"] = 
function(os, cmd)
	Serialize(os, 10331)
	Serialize(os, cmd.server_ms)

end

cmd_list["GetClientLocalTime_Re"] = 
function(os, cmd)
	Serialize(os, 10332)
	Serialize(os, cmd.server_ms)
	Serialize(os, cmd.client_ms)

end

cmd_list["SweepInstance"] = 
function(os, cmd)
	Serialize(os, 100)
	Serialize(os, cmd.instance)
	Serialize(os, cmd.count)

end

cmd_list["SweepInstance_Re"] = 
function(os, cmd)
	Serialize(os, 101)
	Serialize(os, cmd.retcode)
	if cmd.info==nil then
		Serialize(os, 0)
	else
		Serialize(os, #cmd.info)
		for i = 1, #cmd.info do
			__SerializeStruct(os, "SweepInstanceData", cmd.info[i])
		end
	end
	__SerializeStruct(os, "SweepInstanceData", cmd.info2)

end

cmd_list["GetBackPack"] = 
function(os, cmd)
	Serialize(os, 102)

end

cmd_list["GetBackPack_Re"] = 
function(os, cmd)
	Serialize(os, 103)
	Serialize(os, cmd.retcode)
	if cmd.info==nil then
		Serialize(os, 0)
	else
		Serialize(os, #cmd.info)
		for i = 1, #cmd.info do
			__SerializeStruct(os, "Item", cmd.info[i])
		end
	end
	if cmd.weaponitems==nil then
		Serialize(os, 0)
	else
		Serialize(os, #cmd.weaponitems)
		for i = 1, #cmd.weaponitems do
			__SerializeStruct(os, "WeaponItem", cmd.weaponitems[i])
		end
	end
	if cmd.equipmentitems==nil then
		Serialize(os, 0)
	else
		Serialize(os, #cmd.equipmentitems)
		for i = 1, #cmd.equipmentitems do
			__SerializeStruct(os, "EquipmentItem", cmd.equipmentitems[i])
		end
	end
	if cmd.skinitems==nil then
		Serialize(os, 0)
	else
		Serialize(os, #cmd.skinitems)
		for i = 1, #cmd.skinitems do
			__SerializeStruct(os, "SkinItem", cmd.skinitems[i])
		end
	end

end

cmd_list["GetInstance"] = 
function(os, cmd)
	Serialize(os, 104)

end

cmd_list["GetInstance_Re"] = 
function(os, cmd)
	Serialize(os, 105)
	Serialize(os, cmd.retcode)
	if cmd.info==nil then
		Serialize(os, 0)
	else
		Serialize(os, #cmd.info)
		for i = 1, #cmd.info do
			__SerializeStruct(os, "InstanceInfo", cmd.info[i])
		end
	end

end

cmd_list["Role_Mon_Exp"] = 
function(os, cmd)
	Serialize(os, 106)
	Serialize(os, cmd.level)
	Serialize(os, cmd.exp)
	Serialize(os, cmd.money)
	Serialize(os, cmd.yuanbao)
	Serialize(os, cmd.vp)

end

cmd_list["BuyVp"] = 
function(os, cmd)
	Serialize(os, 107)

end

cmd_list["BuyVp_Re"] = 
function(os, cmd)
	Serialize(os, 108)
	Serialize(os, cmd.retcode)
	Serialize(os, cmd.num)

end

cmd_list["BuyInstanceCount"] = 
function(os, cmd)
	Serialize(os, 109)
	Serialize(os, cmd.inst_tid)

end

cmd_list["BuyInstanceCount_Re"] = 
function(os, cmd)
	Serialize(os, 110)
	Serialize(os, cmd.retcode)

end

cmd_list["RoleCommonLimit"] = 
function(os, cmd)
	Serialize(os, 111)
	Serialize(os, cmd.tid)
	Serialize(os, cmd.count)

end

cmd_list["ChongZhi_Re"] = 
function(os, cmd)
	Serialize(os, 114)
	Serialize(os, cmd.chongzhi)

end

cmd_list["TaskFinish"] = 
function(os, cmd)
	Serialize(os, 115)
	Serialize(os, cmd.task_id)

end

cmd_list["TaskFinish_Re"] = 
function(os, cmd)
	Serialize(os, 116)
	Serialize(os, cmd.retcode)
	Serialize(os, cmd.task_id)
	__SerializeStruct(os, "SweepInstanceData", cmd.rewards)

end

cmd_list["Task_Condition"] = 
function(os, cmd)
	Serialize(os, 117)
	Serialize(os, cmd.tid)
	if cmd.condition==nil then
		Serialize(os, 0)
	else
		Serialize(os, #cmd.condition)
		for i = 1, #cmd.condition do
			__SerializeStruct(os, "Condition", cmd.condition[i])
		end
	end

end

cmd_list["Client_User_Define"] = 
function(os, cmd)
	Serialize(os, 118)
	Serialize(os, cmd.user_key)
	Serialize(os, cmd.user_value)

end

cmd_list["BuyHero"] = 
function(os, cmd)
	Serialize(os, 119)
	Serialize(os, cmd.tid)
	Serialize(os, cmd.typ)

end

cmd_list["BuyHero_Re"] = 
function(os, cmd)
	Serialize(os, 120)
	Serialize(os, cmd.retcode)

end

cmd_list["HeroList_Re"] = 
function(os, cmd)
	Serialize(os, 121)
	__SerializeStruct(os, "RoleHero", cmd.hero_hall)

end

cmd_list["UseItem"] = 
function(os, cmd)
	Serialize(os, 122)
	Serialize(os, cmd.tid)
	Serialize(os, cmd.hero_id)
	Serialize(os, cmd.count)

end

cmd_list["AddHero"] = 
function(os, cmd)
	Serialize(os, 123)
	__SerializeStruct(os, "RoleHero", cmd.hero_hall)
	Serialize(os, cmd.flag)

end

cmd_list["UpdateHeroInfo"] = 
function(os, cmd)
	Serialize(os, 124)
	__SerializeStruct(os, "RoleHero", cmd.hero_hall)

end

cmd_list["UseItem_Re"] = 
function(os, cmd)
	Serialize(os, 125)
	Serialize(os, cmd.retcode)

end

cmd_list["One_Level_Up"] = 
function(os, cmd)
	Serialize(os, 126)
	Serialize(os, cmd.hero_id)
	if cmd.item==nil then
		Serialize(os, 0)
	else
		Serialize(os, #cmd.item)
		for i = 1, #cmd.item do
			__SerializeStruct(os, "Item", cmd.item[i])
		end
	end

end

cmd_list["One_Level_Up_Re"] = 
function(os, cmd)
	Serialize(os, 127)
	Serialize(os, cmd.retcode)

end

cmd_list["Hero_Up_Grade"] = 
function(os, cmd)
	Serialize(os, 128)
	Serialize(os, cmd.hero_id)

end

cmd_list["Hero_Up_Grade_Re"] = 
function(os, cmd)
	Serialize(os, 129)
	Serialize(os, cmd.retcode)
	Serialize(os, cmd.hero_id)

end

cmd_list["ErrorInfo"] = 
function(os, cmd)
	Serialize(os, 130)
	Serialize(os, cmd.error_id)

end

cmd_list["BuyHorse"] = 
function(os, cmd)
	Serialize(os, 131)
	Serialize(os, cmd.tid)
	Serialize(os, cmd.typ)

end

cmd_list["BuyHorse_Re"] = 
function(os, cmd)
	Serialize(os, 132)
	Serialize(os, cmd.retcode)

end

cmd_list["AddHorse"] = 
function(os, cmd)
	Serialize(os, 133)
	__SerializeStruct(os, "RoleHorse", cmd.horse)

end

cmd_list["GetLastHero"] = 
function(os, cmd)
	Serialize(os, 134)

end

cmd_list["GetLastHero_Re"] = 
function(os, cmd)
	Serialize(os, 135)
	if cmd.info==nil then
		Serialize(os, 0)
	else
		Serialize(os, #cmd.info)
		for i = 1, #cmd.info do
			Serialize(os, cmd.info[i])
		end
	end

end

cmd_list["PvpJoin"] = 
function(os, cmd)
	Serialize(os, 136)
	Serialize(os, cmd.typ)
	if cmd.heroinfo==nil then
		Serialize(os, 0)
	else
		Serialize(os, #cmd.heroinfo)
		for i = 1, #cmd.heroinfo do
			Serialize(os, cmd.heroinfo[i])
		end
	end

end

cmd_list["PvpJoin_Re"] = 
function(os, cmd)
	Serialize(os, 137)
	Serialize(os, cmd.retcode)
	Serialize(os, cmd.time)

end

cmd_list["PvpMatchSuccess"] = 
function(os, cmd)
	Serialize(os, 138)
	Serialize(os, cmd.retcode)
	Serialize(os, cmd.index)

end

cmd_list["PvpEnter"] = 
function(os, cmd)
	Serialize(os, 139)
	Serialize(os, cmd.index)
	Serialize(os, cmd.flag)

end

cmd_list["PvpEnter_Re"] = 
function(os, cmd)
	Serialize(os, 140)
	Serialize(os, cmd.retcode)
	__SerializeStruct(os, "RoleClientPVPInfo", cmd.player1)
	__SerializeStruct(os, "RoleClientPVPInfo", cmd.player2)
	Serialize(os, cmd.N)
	Serialize(os, cmd.mode)
	Serialize(os, cmd.p2p_magic)
	Serialize(os, cmd.p2p_peer_ip)
	Serialize(os, cmd.p2p_peer_port)
	Serialize(os, cmd.robot_flag)
	Serialize(os, cmd.robot_seed)
	Serialize(os, cmd.robot_type)

end

cmd_list["PvpCancle"] = 
function(os, cmd)
	Serialize(os, 141)

end

cmd_list["PvpCancle_Re"] = 
function(os, cmd)
	Serialize(os, 142)
	Serialize(os, cmd.retcode)

end

cmd_list["PvpSpeed"] = 
function(os, cmd)
	Serialize(os, 143)
	Serialize(os, cmd.speed)

end

cmd_list["ResetRoleInfo"] = 
function(os, cmd)
	Serialize(os, 144)

end

cmd_list["SendNotice"] = 
function(os, cmd)
	Serialize(os, 145)
	Serialize(os, cmd.notice_id)
	Serialize(os, cmd.time)
	if cmd.notice_para==nil then
		Serialize(os, 0)
	else
		Serialize(os, #cmd.notice_para)
		for i = 1, #cmd.notice_para do
			__SerializeStruct(os, "NoticeParaInfo", cmd.notice_para[i])
		end
	end

end

cmd_list["UpdateTask"] = 
function(os, cmd)
	Serialize(os, 146)
	if cmd.current==nil then
		Serialize(os, 0)
	else
		Serialize(os, #cmd.current)
		for i = 1, #cmd.current do
			__SerializeStruct(os, "RoleCurrentTask", cmd.current[i])
		end
	end
	if cmd.finish==nil then
		Serialize(os, 0)
	else
		Serialize(os, #cmd.finish)
		for i = 1, #cmd.finish do
			Serialize(os, cmd.finish[i])
		end
	end

end

cmd_list["FinishedTask"] = 
function(os, cmd)
	Serialize(os, 147)
	if cmd.finish==nil then
		Serialize(os, 0)
	else
		Serialize(os, #cmd.finish)
		for i = 1, #cmd.finish do
			Serialize(os, cmd.finish[i])
		end
	end

end

cmd_list["GetTask"] = 
function(os, cmd)
	Serialize(os, 148)

end

cmd_list["ItemCountChange"] = 
function(os, cmd)
	Serialize(os, 149)
	Serialize(os, cmd.itemid)
	Serialize(os, cmd.count)

end

cmd_list["HeroUpgradeSkill"] = 
function(os, cmd)
	Serialize(os, 150)
	Serialize(os, cmd.hero_id)
	if cmd.skill_info==nil then
		Serialize(os, 0)
	else
		Serialize(os, #cmd.skill_info)
		for i = 1, #cmd.skill_info do
			__SerializeStruct(os, "UpgradeSkillInfo", cmd.skill_info[i])
		end
	end

end

cmd_list["HeroUpgradeSkill_Re"] = 
function(os, cmd)
	Serialize(os, 151)
	Serialize(os, cmd.retcode)

end

cmd_list["GetHeroComments"] = 
function(os, cmd)
	Serialize(os, 152)
	Serialize(os, cmd.hero_id)

end

cmd_list["GetHeroComments_Re"] = 
function(os, cmd)
	Serialize(os, 153)
	Serialize(os, cmd.retcode)
	if cmd.comment==nil then
		Serialize(os, 0)
	else
		Serialize(os, #cmd.comment)
		for i = 1, #cmd.comment do
			__SerializeStruct(os, "HeroComment", cmd.comment[i])
		end
	end
	Serialize(os, cmd.hero_id)

end

cmd_list["AgreeHeroComments"] = 
function(os, cmd)
	Serialize(os, 154)
	Serialize(os, cmd.hero_id)
	Serialize(os, cmd.role_id)
	Serialize(os, cmd.time_stamp)

end

cmd_list["AgreeHeroComments_Re"] = 
function(os, cmd)
	Serialize(os, 155)
	Serialize(os, cmd.retcode)
	Serialize(os, cmd.hero_id)
	Serialize(os, cmd.role_id)
	Serialize(os, cmd.time_stamp)

end

cmd_list["WriteHeroComments"] = 
function(os, cmd)
	Serialize(os, 156)
	Serialize(os, cmd.hero_id)
	Serialize(os, cmd.comments)

end

cmd_list["WriteHeroComments_Re"] = 
function(os, cmd)
	Serialize(os, 157)
	Serialize(os, cmd.retcode)
	Serialize(os, cmd.hero_id)

end

cmd_list["ReWriteHeroComments"] = 
function(os, cmd)
	Serialize(os, 158)
	Serialize(os, cmd.hero_id)
	Serialize(os, cmd.comments)

end

cmd_list["ReWriteHeroComments_Re"] = 
function(os, cmd)
	Serialize(os, 159)
	Serialize(os, cmd.retcode)
	Serialize(os, cmd.hero_id)

end

cmd_list["UpdateHeroSkillPoint"] = 
function(os, cmd)
	Serialize(os, 160)
	Serialize(os, cmd.point)

end

cmd_list["GetVPRefreshTime"] = 
function(os, cmd)
	Serialize(os, 161)

end

cmd_list["GetVPRefreshTime_Re"] = 
function(os, cmd)
	Serialize(os, 162)
	Serialize(os, cmd.refresh_time)

end

cmd_list["GetSkillPointRefreshTime"] = 
function(os, cmd)
	Serialize(os, 163)

end

cmd_list["GetSkillPointRefreshTime_Re"] = 
function(os, cmd)
	Serialize(os, 164)
	Serialize(os, cmd.refresh_time)

end

cmd_list["RoleLogin"] = 
function(os, cmd)
	Serialize(os, 165)

end

cmd_list["BuySkillPoint"] = 
function(os, cmd)
	Serialize(os, 166)

end

cmd_list["BuySkillPoint_Re"] = 
function(os, cmd)
	Serialize(os, 167)
	Serialize(os, cmd.retcode)
	Serialize(os, cmd.point)

end

cmd_list["UpdatePvpVideo"] = 
function(os, cmd)
	Serialize(os, 168)
	Serialize(os, cmd.video)
	__SerializeStruct(os, "RoleClientPVPInfo", cmd.player1)
	__SerializeStruct(os, "RoleClientPVPInfo", cmd.player2)
	Serialize(os, cmd.win_flag)
	Serialize(os, cmd.time)
	Serialize(os, cmd.match_pvp)

end

cmd_list["GetVideo"] = 
function(os, cmd)
	Serialize(os, 169)
	Serialize(os, cmd.video_id)

end

cmd_list["GetVideo_Re"] = 
function(os, cmd)
	Serialize(os, 170)
	Serialize(os, cmd.retcode)
	__SerializeStruct(os, "RoleClientPVPInfo", cmd.player1)
	__SerializeStruct(os, "RoleClientPVPInfo", cmd.player2)
	__SerializeStruct(os, "PvpVideo", cmd.operation)
	Serialize(os, cmd.win_flag)
	Serialize(os, cmd.robot_flag)
	Serialize(os, cmd.robot_seed)
	Serialize(os, cmd.robot_type)
	Serialize(os, cmd.exe_ver)
	Serialize(os, cmd.data_ver)
	Serialize(os, cmd.video_id)
	Serialize(os, cmd.pvp_ver)

end

cmd_list["PrivateChatHistory"] = 
function(os, cmd)
	Serialize(os, 171)
	if cmd.private_chat==nil then
		Serialize(os, 0)
	else
		Serialize(os, #cmd.private_chat)
		for i = 1, #cmd.private_chat do
			__SerializeStruct(os, "ChatInfo", cmd.private_chat[i])
		end
	end

end

cmd_list["AddBlackList"] = 
function(os, cmd)
	Serialize(os, 172)
	Serialize(os, cmd.roleid)

end

cmd_list["AddBlackList_Re"] = 
function(os, cmd)
	Serialize(os, 173)
	__SerializeStruct(os, "RoleBrief", cmd.roleinfo)

end

cmd_list["DelBlackList"] = 
function(os, cmd)
	Serialize(os, 174)
	Serialize(os, cmd.roleid)

end

cmd_list["DelBlackList_Re"] = 
function(os, cmd)
	Serialize(os, 175)
	Serialize(os, cmd.roleid)

end

cmd_list["SeeAnotherRole"] = 
function(os, cmd)
	Serialize(os, 176)
	Serialize(os, cmd.roleid)

end

cmd_list["SeeAnotherRole_Re"] = 
function(os, cmd)
	Serialize(os, 177)
	__SerializeStruct(os, "AnotherRoleData", cmd.roleinfo)

end

cmd_list["GetPrivateChatHistory"] = 
function(os, cmd)
	Serialize(os, 178)

end

cmd_list["ReadMail"] = 
function(os, cmd)
	Serialize(os, 179)
	Serialize(os, cmd.mail_id)

end

cmd_list["ReadMail_Re"] = 
function(os, cmd)
	Serialize(os, 180)
	Serialize(os, cmd.retcode)

end

cmd_list["GetAttachment"] = 
function(os, cmd)
	Serialize(os, 181)
	Serialize(os, cmd.mail_id)

end

cmd_list["GetAttachment_Re"] = 
function(os, cmd)
	Serialize(os, 182)
	Serialize(os, cmd.retcode)

end

cmd_list["UpdateMail"] = 
function(os, cmd)
	Serialize(os, 183)
	__SerializeStruct(os, "MailInfo", cmd.mail_info)

end

cmd_list["UpdatePvpEndTime"] = 
function(os, cmd)
	Serialize(os, 184)
	Serialize(os, cmd.end_time)

end

cmd_list["UpdateHeroPvpInfo"] = 
function(os, cmd)
	Serialize(os, 185)
	if cmd.hero_pvpinfo==nil then
		Serialize(os, 0)
	else
		Serialize(os, #cmd.hero_pvpinfo)
		for i = 1, #cmd.hero_pvpinfo do
			__SerializeStruct(os, "HeroPvpInfoData", cmd.hero_pvpinfo[i])
		end
	end

end

cmd_list["DeleteTask"] = 
function(os, cmd)
	Serialize(os, 186)
	Serialize(os, cmd.task_id)

end

cmd_list["BroadcastPvpVideo"] = 
function(os, cmd)
	Serialize(os, 187)
	Serialize(os, cmd.typ)
	Serialize(os, cmd.video_id)
	Serialize(os, cmd.content)
	Serialize(os, cmd.channel)

end

cmd_list["BroadcastPvpVideo_Re"] = 
function(os, cmd)
	Serialize(os, 188)
	Serialize(os, cmd.typ)
	__SerializeStruct(os, "RoleBrief", cmd.src)
	Serialize(os, cmd.content)
	Serialize(os, cmd.video_id)
	__SerializeStruct(os, "RoleClientPVPInfo", cmd.player1)
	__SerializeStruct(os, "RoleClientPVPInfo", cmd.player2)
	Serialize(os, cmd.time)
	Serialize(os, cmd.win_flag)
	Serialize(os, cmd.channel)
	Serialize(os, cmd.match_pvp)

end

cmd_list["ChangeHeroSelectSkill"] = 
function(os, cmd)
	Serialize(os, 189)
	Serialize(os, cmd.hero_id)
	if cmd.skill_id==nil then
		Serialize(os, 0)
	else
		Serialize(os, #cmd.skill_id)
		for i = 1, #cmd.skill_id do
			Serialize(os, cmd.skill_id[i])
		end
	end

end

cmd_list["ChangeHeroSelectSkill_Re"] = 
function(os, cmd)
	Serialize(os, 190)
	Serialize(os, cmd.retcode)
	Serialize(os, cmd.hero_id)
	if cmd.skill_id==nil then
		Serialize(os, 0)
	else
		Serialize(os, #cmd.skill_id)
		for i = 1, #cmd.skill_id do
			Serialize(os, cmd.skill_id[i])
		end
	end

end

cmd_list["UpdatePvpInfo"] = 
function(os, cmd)
	Serialize(os, 191)
	Serialize(os, cmd.join_count)
	Serialize(os, cmd.win_count)

end

cmd_list["UpdateRep"] = 
function(os, cmd)
	Serialize(os, 192)
	Serialize(os, cmd.rep_id)
	Serialize(os, cmd.rep_num)

end

cmd_list["MallBuyItem"] = 
function(os, cmd)
	Serialize(os, 193)
	Serialize(os, cmd.item_id)
	Serialize(os, cmd.item_num)

end

cmd_list["MallBuyItem_Re"] = 
function(os, cmd)
	Serialize(os, 194)
	Serialize(os, cmd.retcode)
	if cmd.item==nil then
		Serialize(os, 0)
	else
		Serialize(os, #cmd.item)
		for i = 1, #cmd.item do
			__SerializeStruct(os, "Item", cmd.item[i])
		end
	end

end

cmd_list["UpdatePvpStar"] = 
function(os, cmd)
	Serialize(os, 195)
	Serialize(os, cmd.typ)
	Serialize(os, cmd.star)

end

cmd_list["UpdateHeroSoul"] = 
function(os, cmd)
	Serialize(os, 197)
	Serialize(os, cmd.soul_id)
	Serialize(os, cmd.soul_num)

end

cmd_list["LevelUpHeroStar"] = 
function(os, cmd)
	Serialize(os, 198)
	Serialize(os, cmd.hero_id)

end

cmd_list["LevelUpHeroStar_Re"] = 
function(os, cmd)
	Serialize(os, 199)
	Serialize(os, cmd.hero_id)
	Serialize(os, cmd.retcode)

end

cmd_list["ClearHeroPvpInfo"] = 
function(os, cmd)
	Serialize(os, 200)

end

cmd_list["UpdateMysteryShopInfo"] = 
function(os, cmd)
	Serialize(os, 201)
	Serialize(os, cmd.shop_id)
	Serialize(os, cmd.refresh_time)
	if cmd.shop_item==nil then
		Serialize(os, 0)
	else
		Serialize(os, #cmd.shop_item)
		for i = 1, #cmd.shop_item do
			__SerializeStruct(os, "MysteryShopItem", cmd.shop_item[i])
		end
	end

end

cmd_list["MysteryShopBuyItem"] = 
function(os, cmd)
	Serialize(os, 202)
	Serialize(os, cmd.shop_id)
	Serialize(os, cmd.position)
	Serialize(os, cmd.item_id)
	Serialize(os, cmd.item_num)

end

cmd_list["MysteryShopBuyItem_Re"] = 
function(os, cmd)
	Serialize(os, 203)
	Serialize(os, cmd.retcode)
	Serialize(os, cmd.shop_id)
	Serialize(os, cmd.position)
	Serialize(os, cmd.item_id)
	Serialize(os, cmd.item_num)
	Serialize(os, cmd.buy_count)
	if cmd.item==nil then
		Serialize(os, 0)
	else
		Serialize(os, #cmd.item)
		for i = 1, #cmd.item do
			__SerializeStruct(os, "Item", cmd.item[i])
		end
	end

end

cmd_list["RefreshMysteryShop"] = 
function(os, cmd)
	Serialize(os, 204)
	Serialize(os, cmd.shop_id)

end

cmd_list["RefreshMysteryShop_Re"] = 
function(os, cmd)
	Serialize(os, 205)
	Serialize(os, cmd.retcode)
	Serialize(os, cmd.shop_id)

end

cmd_list["ResetBattleField"] = 
function(os, cmd)
	Serialize(os, 206)
	Serialize(os, cmd.battle_id)
	Serialize(os, cmd.typ)

end

cmd_list["ResetBattleField_Re"] = 
function(os, cmd)
	Serialize(os, 207)
	Serialize(os, cmd.retcode)
	Serialize(os, cmd.typ)
	Serialize(os, cmd.battle_id)
	__SerializeStruct(os, "BattleInfo", cmd.battle_info)

end

cmd_list["BattleFieldBegin"] = 
function(os, cmd)
	Serialize(os, 208)
	Serialize(os, cmd.battle_id)
	if cmd.heros==nil then
		Serialize(os, 0)
	else
		Serialize(os, #cmd.heros)
		for i = 1, #cmd.heros do
			__SerializeStruct(os, "BattleHeroInfo", cmd.heros[i])
		end
	end

end

cmd_list["BattleFieldBegin_Re"] = 
function(os, cmd)
	Serialize(os, 209)
	Serialize(os, cmd.retcode)
	Serialize(os, cmd.battle_id)

end

cmd_list["BattleFieldMove"] = 
function(os, cmd)
	Serialize(os, 210)
	Serialize(os, cmd.battle_id)
	Serialize(os, cmd.src_id)
	Serialize(os, cmd.src_position)
	Serialize(os, cmd.dst_id)
	Serialize(os, cmd.dst_position)

end

cmd_list["BattleFieldMove_Re"] = 
function(os, cmd)
	Serialize(os, 211)
	Serialize(os, cmd.retcode)
	Serialize(os, cmd.battle_id)
	Serialize(os, cmd.src_id)
	Serialize(os, cmd.src_position)
	Serialize(os, cmd.dst_id)
	Serialize(os, cmd.dst_position)

end

cmd_list["BattleFieldJoinBattle"] = 
function(os, cmd)
	Serialize(os, 212)
	Serialize(os, cmd.battle_id)
	Serialize(os, cmd.npc_id)

end

cmd_list["BattleFieldJoinBattle_Re"] = 
function(os, cmd)
	Serialize(os, 213)
	Serialize(os, cmd.retcode)
	Serialize(os, cmd.battle_id)
	Serialize(os, cmd.npc_id)
	Serialize(os, cmd.seed)

end

cmd_list["BattleFieldFinishBattle"] = 
function(os, cmd)
	Serialize(os, 214)
	Serialize(os, cmd.battle_id)
	Serialize(os, cmd.win_flag)
	Serialize(os, cmd.npc_id)
	if cmd.heros==nil then
		Serialize(os, 0)
	else
		Serialize(os, #cmd.heros)
		for i = 1, #cmd.heros do
			__SerializeStruct(os, "BattleHeroInfo", cmd.heros[i])
		end
	end
	if cmd.operations==nil then
		Serialize(os, 0)
	else
		Serialize(os, #cmd.operations)
		for i = 1, #cmd.operations do
			__SerializeStruct(os, "PVEOperation", cmd.operations[i])
		end
	end

end

cmd_list["BattleFieldFinishBattle_Re"] = 
function(os, cmd)
	Serialize(os, 215)
	Serialize(os, cmd.retcode)
	Serialize(os, cmd.battle_id)
	Serialize(os, cmd.win_flag)
	Serialize(os, cmd.fail_flag)
	Serialize(os, cmd.npc_id)
	if cmd.heros==nil then
		Serialize(os, 0)
	else
		Serialize(os, #cmd.heros)
		for i = 1, #cmd.heros do
			__SerializeStruct(os, "BattleHeroInfo", cmd.heros[i])
		end
	end
	__SerializeStruct(os, "SweepInstanceData", cmd.rewards)

end

cmd_list["BattleFieldEnd"] = 
function(os, cmd)
	Serialize(os, 216)
	Serialize(os, cmd.battle_id)
	Serialize(os, cmd.win_flag)
	__SerializeStruct(os, "SweepInstanceData", cmd.rewards)

end

cmd_list["BattleFieldGetPrize"] = 
function(os, cmd)
	Serialize(os, 217)
	Serialize(os, cmd.battle_id)

end

cmd_list["BattleFieldGetPrize_Re"] = 
function(os, cmd)
	Serialize(os, 218)
	Serialize(os, cmd.retcode)
	Serialize(os, cmd.battle_id)
	__SerializeStruct(os, "SweepInstanceData", cmd.rewards)

end

cmd_list["SetInstanceHeroInfo"] = 
function(os, cmd)
	Serialize(os, 219)
	Serialize(os, cmd.typ)
	Serialize(os, cmd.battle_id)
	if cmd.heros==nil then
		Serialize(os, 0)
	else
		Serialize(os, #cmd.heros)
		for i = 1, #cmd.heros do
			Serialize(os, cmd.heros[i])
		end
	end
	Serialize(os, cmd.horse)

end

cmd_list["SetInstanceHeroInfo_Re"] = 
function(os, cmd)
	Serialize(os, 220)
	Serialize(os, cmd.retcode)
	Serialize(os, cmd.typ)
	Serialize(os, cmd.battle_id)
	if cmd.heros==nil then
		Serialize(os, 0)
	else
		Serialize(os, #cmd.heros)
		for i = 1, #cmd.heros do
			Serialize(os, cmd.heros[i])
		end
	end
	Serialize(os, cmd.horse)

end

cmd_list["Lottery"] = 
function(os, cmd)
	Serialize(os, 221)
	Serialize(os, cmd.lottery_id)
	Serialize(os, cmd.cost_type)

end

cmd_list["Lottery_Re"] = 
function(os, cmd)
	Serialize(os, 222)
	Serialize(os, cmd.retcode)
	Serialize(os, cmd.lottery_id)
	Serialize(os, cmd.cost_type)
	if cmd.reward_ids==nil then
		Serialize(os, 0)
	else
		Serialize(os, #cmd.reward_ids)
		for i = 1, #cmd.reward_ids do
			__SerializeStruct(os, "LotteryRewardInfo", cmd.reward_ids[i])
		end
	end

end

cmd_list["GetBattleFieldInfo"] = 
function(os, cmd)
	Serialize(os, 223)
	Serialize(os, cmd.battle_id)

end

cmd_list["GetBattleFieldInfo_Re"] = 
function(os, cmd)
	Serialize(os, 224)
	Serialize(os, cmd.retcode)
	Serialize(os, cmd.battle_id)
	__SerializeStruct(os, "BattleInfo", cmd.battle_info)

end

cmd_list["ChangeBattleState"] = 
function(os, cmd)
	Serialize(os, 225)
	Serialize(os, cmd.battle_id)
	Serialize(os, cmd.state)

end

cmd_list["BattleFieldCancel"] = 
function(os, cmd)
	Serialize(os, 226)
	Serialize(os, cmd.battle_id)

end

cmd_list["BattleFieldCancel_Re"] = 
function(os, cmd)
	Serialize(os, 227)
	Serialize(os, cmd.retcode)
	Serialize(os, cmd.battle_id)
	Serialize(os, cmd.position)

end

cmd_list["BattleFieldGetEvent"] = 
function(os, cmd)
	Serialize(os, 228)
	Serialize(os, cmd.battle_id)

end

cmd_list["BattleFieldGetEvent_Re"] = 
function(os, cmd)
	Serialize(os, 229)
	Serialize(os, cmd.retcode)
	Serialize(os, cmd.battle_id)
	if cmd.event==nil then
		Serialize(os, 0)
	else
		Serialize(os, #cmd.event)
		for i = 1, #cmd.event do
			Serialize(os, cmd.event[i])
		end
	end
	if cmd.event_info==nil then
		Serialize(os, 0)
	else
		Serialize(os, #cmd.event_info)
		for i = 1, #cmd.event_info do
			__SerializeStruct(os, "BattleEventInfo", cmd.event_info[i])
		end
	end

end

cmd_list["BattleFieldCapturedPosition"] = 
function(os, cmd)
	Serialize(os, 230)
	Serialize(os, cmd.battle_id)
	__SerializeStruct(os, "BattlePositionInfo", cmd.position_info)
	Serialize(os, cmd.event)
	__SerializeStruct(os, "BattleEventInfo", cmd.event_info)

end

cmd_list["GetCurBattleField"] = 
function(os, cmd)
	Serialize(os, 231)

end

cmd_list["GetCurBattleField_Re"] = 
function(os, cmd)
	Serialize(os, 232)
	Serialize(os, cmd.battle_id)
	Serialize(os, cmd.state)

end

cmd_list["BattleFieldFinishEvent"] = 
function(os, cmd)
	Serialize(os, 233)
	Serialize(os, cmd.battle_id)

end

cmd_list["BattleFieldFinishEvent_Re"] = 
function(os, cmd)
	Serialize(os, 234)
	Serialize(os, cmd.retcode)
	Serialize(os, cmd.battle_id)
	Serialize(os, cmd.join_battle_flag)
	Serialize(os, cmd.event)

end

cmd_list["GiveUpCurBattleField"] = 
function(os, cmd)
	Serialize(os, 235)

end

cmd_list["GiveUpCurBattleField_Re"] = 
function(os, cmd)
	Serialize(os, 236)
	Serialize(os, cmd.retcode)

end

cmd_list["GetRefreshTime"] = 
function(os, cmd)
	Serialize(os, 237)
	Serialize(os, cmd.typ)

end

cmd_list["GetRefreshTime_Re"] = 
function(os, cmd)
	Serialize(os, 238)
	Serialize(os, cmd.typ)
	Serialize(os, cmd.last_refreshtime)

end

cmd_list["DailySign"] = 
function(os, cmd)
	Serialize(os, 239)
	Serialize(os, cmd.typ)

end

cmd_list["DailySign_Re"] = 
function(os, cmd)
	Serialize(os, 240)
	Serialize(os, cmd.retcode)
	Serialize(os, cmd.typ)
	if cmd.item==nil then
		Serialize(os, 0)
	else
		Serialize(os, #cmd.item)
		for i = 1, #cmd.item do
			__SerializeStruct(os, "Item", cmd.item[i])
		end
	end
	Serialize(os, cmd.sign_date)
	Serialize(os, cmd.today_flag)

end

cmd_list["GetMyPveArenaInfo"] = 
function(os, cmd)
	Serialize(os, 241)

end

cmd_list["GetMyPveArenaInfo_Re"] = 
function(os, cmd)
	Serialize(os, 242)
	Serialize(os, cmd.score)
	Serialize(os, cmd.rank)
	if cmd.defence_hero==nil then
		Serialize(os, 0)
	else
		Serialize(os, #cmd.defence_hero)
		for i = 1, #cmd.defence_hero do
			Serialize(os, cmd.defence_hero[i])
		end
	end
	Serialize(os, cmd.last_attack_time)
	Serialize(os, cmd.pve_refreshtime)

end

cmd_list["GetOtherPveArenaInfo"] = 
function(os, cmd)
	Serialize(os, 243)
	Serialize(os, cmd.roleid)

end

cmd_list["GetOtherPveArenaInfo_Re"] = 
function(os, cmd)
	Serialize(os, 244)
	__SerializeStruct(os, "PveArenaFighterInfo", cmd.info)

end

cmd_list["GetFighterInfo"] = 
function(os, cmd)
	Serialize(os, 245)

end

cmd_list["GetFighterInfo_Re"] = 
function(os, cmd)
	Serialize(os, 246)
	Serialize(os, cmd.retcode)
	if cmd.fightinfo==nil then
		Serialize(os, 0)
	else
		Serialize(os, #cmd.fightinfo)
		for i = 1, #cmd.fightinfo do
			__SerializeStruct(os, "PveArenaFighterInfo", cmd.fightinfo[i])
		end
	end

end

cmd_list["PveArenaJoinBattle"] = 
function(os, cmd)
	Serialize(os, 247)
	Serialize(os, cmd.rank)

end

cmd_list["PveArenaJoinBattle_Re"] = 
function(os, cmd)
	Serialize(os, 248)
	Serialize(os, cmd.retcode)
	Serialize(os, cmd.last_attack_time)
	__SerializeStruct(os, "RolePveArenaInfo", cmd.self_info)
	__SerializeStruct(os, "PveArenaFighterInfo", cmd.role_info)
	Serialize(os, cmd.seed)

end

cmd_list["PveArenaEndBattle"] = 
function(os, cmd)
	Serialize(os, 249)
	Serialize(os, cmd.win_flag)
	Serialize(os, cmd.win_type)
	Serialize(os, cmd.replay_flag)
	__SerializeStruct(os, "PveArenaOperation", cmd.operation)

end

cmd_list["PveArenaEndBattle_Re"] = 
function(os, cmd)
	Serialize(os, 250)
	Serialize(os, cmd.retcode)
	Serialize(os, cmd.win_type)
	Serialize(os, cmd.score_change)
	if cmd.item==nil then
		Serialize(os, 0)
	else
		Serialize(os, #cmd.item)
		for i = 1, #cmd.item do
			__SerializeStruct(os, "Item", cmd.item[i])
		end
	end

end

cmd_list["PveArenaResetTime"] = 
function(os, cmd)
	Serialize(os, 251)

end

cmd_list["PveArenaResetTime_Re"] = 
function(os, cmd)
	Serialize(os, 252)
	Serialize(os, cmd.retcode)
	Serialize(os, cmd.last_time)

end

cmd_list["PveArenaResetCount"] = 
function(os, cmd)
	Serialize(os, 253)

end

cmd_list["PveArenaResetCount_Re"] = 
function(os, cmd)
	Serialize(os, 254)
	Serialize(os, cmd.retcode)

end

cmd_list["ChallengeRoleByItem"] = 
function(os, cmd)
	Serialize(os, 255)
	Serialize(os, cmd.roleid)
	Serialize(os, cmd.name)

end

cmd_list["ChallengeRoleByItem_Re"] = 
function(os, cmd)
	Serialize(os, 256)
	Serialize(os, cmd.retcode)
	__SerializeStruct(os, "RolePveArenaInfo", cmd.self_info)
	__SerializeStruct(os, "PveArenaFighterInfo", cmd.role_info)

end

cmd_list["GetPveArenaHistory"] = 
function(os, cmd)
	Serialize(os, 257)

end

cmd_list["GetPveArenaHistory_Re"] = 
function(os, cmd)
	Serialize(os, 258)
	if cmd.hisroty_info==nil then
		Serialize(os, 0)
	else
		Serialize(os, #cmd.hisroty_info)
		for i = 1, #cmd.hisroty_info do
			__SerializeStruct(os, "RolePveArenaHistoryInfo", cmd.hisroty_info[i])
		end
	end
	Serialize(os, cmd.retcode)

end

cmd_list["GetPveArenaOperation"] = 
function(os, cmd)
	Serialize(os, 259)
	Serialize(os, cmd.id)

end

cmd_list["GetPveArenaOperation_Re"] = 
function(os, cmd)
	Serialize(os, 260)
	Serialize(os, cmd.retcode)
	__SerializeStruct(os, "RolePveArenaInfo", cmd.self_hero_info)
	__SerializeStruct(os, "RolePveArenaInfo", cmd.oppo_hero_info)
	__SerializeStruct(os, "PveArenaOperation", cmd.operation)
	Serialize(os, cmd.exe_ver)
	Serialize(os, cmd.data_ver)

end

cmd_list["SetPveArenaHero"] = 
function(os, cmd)
	Serialize(os, 261)
	if cmd.heros==nil then
		Serialize(os, 0)
	else
		Serialize(os, #cmd.heros)
		for i = 1, #cmd.heros do
			Serialize(os, cmd.heros[i])
		end
	end

end

cmd_list["SetPveArenaHero_Re"] = 
function(os, cmd)
	Serialize(os, 262)
	Serialize(os, cmd.retcode)

end

cmd_list["ResetSkilllevel"] = 
function(os, cmd)
	Serialize(os, 263)
	Serialize(os, cmd.hero_id)

end

cmd_list["ResetSkilllevel_Re"] = 
function(os, cmd)
	Serialize(os, 264)
	Serialize(os, cmd.retcode)

end

cmd_list["WeaponEquip"] = 
function(os, cmd)
	Serialize(os, 265)
	Serialize(os, cmd.hero)
	Serialize(os, cmd.weapon_id)

end

cmd_list["WeaponEquip_Re"] = 
function(os, cmd)
	Serialize(os, 266)
	Serialize(os, cmd.retcode)
	Serialize(os, cmd.hero)
	Serialize(os, cmd.weapon_id)

end

cmd_list["WeaponLevelUp"] = 
function(os, cmd)
	Serialize(os, 267)
	Serialize(os, cmd.hero)
	Serialize(os, cmd.weapon_id)
	if cmd.weapon_cost_ids==nil then
		Serialize(os, 0)
	else
		Serialize(os, #cmd.weapon_cost_ids)
		for i = 1, #cmd.weapon_cost_ids do
			Serialize(os, cmd.weapon_cost_ids[i])
		end
	end

end

cmd_list["WeaponLevelUp_Re"] = 
function(os, cmd)
	Serialize(os, 268)
	Serialize(os, cmd.retcode)
	Serialize(os, cmd.hero)
	Serialize(os, cmd.weapon_id)
	if cmd.weapon_cost_ids==nil then
		Serialize(os, 0)
	else
		Serialize(os, #cmd.weapon_cost_ids)
		for i = 1, #cmd.weapon_cost_ids do
			Serialize(os, cmd.weapon_cost_ids[i])
		end
	end
	Serialize(os, cmd.level)
	Serialize(os, cmd.exp)
	if cmd.skill_id==nil then
		Serialize(os, 0)
	else
		Serialize(os, #cmd.skill_id)
		for i = 1, #cmd.skill_id do
			Serialize(os, cmd.skill_id[i])
		end
	end

end

cmd_list["WeaponStrength"] = 
function(os, cmd)
	Serialize(os, 269)
	Serialize(os, cmd.hero)
	Serialize(os, cmd.weapon_id)

end

cmd_list["WeaponStrength_Re"] = 
function(os, cmd)
	Serialize(os, 270)
	Serialize(os, cmd.retcode)
	Serialize(os, cmd.hero)
	Serialize(os, cmd.weapon_id)
	Serialize(os, cmd.weapon_skill)

end

cmd_list["WeaponDecompose"] = 
function(os, cmd)
	Serialize(os, 271)
	Serialize(os, cmd.weapon_id)

end

cmd_list["WeaponDecompose_Re"] = 
function(os, cmd)
	Serialize(os, 272)
	Serialize(os, cmd.retcode)
	Serialize(os, cmd.money)
	if cmd.item_info==nil then
		Serialize(os, 0)
	else
		Serialize(os, #cmd.item_info)
		for i = 1, #cmd.item_info do
			__SerializeStruct(os, "Item", cmd.item_info[i])
		end
	end

end

cmd_list["WeaponUnequip"] = 
function(os, cmd)
	Serialize(os, 273)
	Serialize(os, cmd.hero)

end

cmd_list["WeaponUnequip_Re"] = 
function(os, cmd)
	Serialize(os, 274)
	Serialize(os, cmd.retcode)

end

cmd_list["WeaponAdd"] = 
function(os, cmd)
	Serialize(os, 275)
	__SerializeStruct(os, "WeaponItem", cmd.weapon_info)
	Serialize(os, cmd.show_panel)

end

cmd_list["WeaponDel"] = 
function(os, cmd)
	Serialize(os, 276)
	Serialize(os, cmd.id)

end

cmd_list["WeaponUpdate"] = 
function(os, cmd)
	Serialize(os, 277)
	__SerializeStruct(os, "WeaponItem", cmd.weapon_info)

end

cmd_list["LotteryUpdate"] = 
function(os, cmd)
	Serialize(os, 278)
	Serialize(os, cmd.typ)
	Serialize(os, cmd.flag)

end

cmd_list["WuZheShiLianGetDifficultyInfo"] = 
function(os, cmd)
	Serialize(os, 279)

end

cmd_list["WuZheShiLianGetDifficultyInfo_Re"] = 
function(os, cmd)
	Serialize(os, 280)
	Serialize(os, cmd.retcode)
	Serialize(os, cmd.cur_difficulty)
	Serialize(os, cmd.high_difficulty)
	if cmd.difficulty_info==nil then
		Serialize(os, 0)
	else
		Serialize(os, #cmd.difficulty_info)
		for i = 1, #cmd.difficulty_info do
			__SerializeStruct(os, "DifficultyInfo", cmd.difficulty_info[i])
		end
	end

end

cmd_list["WuZheShiLianSelectDifficulty"] = 
function(os, cmd)
	Serialize(os, 281)
	Serialize(os, cmd.difficulty)

end

cmd_list["WuZheShiLianSelectDifficulty_Re"] = 
function(os, cmd)
	Serialize(os, 282)
	Serialize(os, cmd.retcode)
	Serialize(os, cmd.cur_diffculty)

end

cmd_list["WuZheShiLianGetOpponentInfo"] = 
function(os, cmd)
	Serialize(os, 283)
	Serialize(os, cmd.difficulty)

end

cmd_list["WuZheShiLianGetOpponentInfo_Re"] = 
function(os, cmd)
	Serialize(os, 284)
	Serialize(os, cmd.retcode)
	if cmd.opponent_info==nil then
		Serialize(os, 0)
	else
		Serialize(os, #cmd.opponent_info)
		for i = 1, #cmd.opponent_info do
			__SerializeStruct(os, "OpponentInfo", cmd.opponent_info[i])
		end
	end

end

cmd_list["WuZheShiLianGetHeroInfo"] = 
function(os, cmd)
	Serialize(os, 285)

end

cmd_list["WuZheShiLianGetHeroInfo_Re"] = 
function(os, cmd)
	Serialize(os, 286)
	if cmd.dead_hero==nil then
		Serialize(os, 0)
	else
		Serialize(os, #cmd.dead_hero)
		for i = 1, #cmd.dead_hero do
			Serialize(os, cmd.dead_hero[i])
		end
	end
	if cmd.injured_hero==nil then
		Serialize(os, 0)
	else
		Serialize(os, #cmd.injured_hero)
		for i = 1, #cmd.injured_hero do
			__SerializeStruct(os, "InjuredHeroInfo", cmd.injured_hero[i])
		end
	end

end

cmd_list["WuZheShiLianJoinBattle"] = 
function(os, cmd)
	Serialize(os, 287)
	Serialize(os, cmd.difficulty)
	Serialize(os, cmd.stage)
	if cmd.heros==nil then
		Serialize(os, 0)
	else
		Serialize(os, #cmd.heros)
		for i = 1, #cmd.heros do
			Serialize(os, cmd.heros[i])
		end
	end

end

cmd_list["WuZheShiLianJoinBattle_Re"] = 
function(os, cmd)
	Serialize(os, 288)
	Serialize(os, cmd.retcode)
	Serialize(os, cmd.seed)

end

cmd_list["WuZheShiLianFinishBattle"] = 
function(os, cmd)
	Serialize(os, 289)
	Serialize(os, cmd.difficulty)
	Serialize(os, cmd.stage)
	if cmd.hero==nil then
		Serialize(os, 0)
	else
		Serialize(os, #cmd.hero)
		for i = 1, #cmd.hero do
			__SerializeStruct(os, "ShiLianHeroInfo", cmd.hero[i])
		end
	end
	__SerializeStruct(os, "OpponentInfo", cmd.opponent)
	Serialize(os, cmd.winflag)
	if cmd.operations==nil then
		Serialize(os, 0)
	else
		Serialize(os, #cmd.operations)
		for i = 1, #cmd.operations do
			__SerializeStruct(os, "PVEOperation", cmd.operations[i])
		end
	end

end

cmd_list["WuZheShiLianFinishBattle_Re"] = 
function(os, cmd)
	Serialize(os, 290)
	Serialize(os, cmd.retcode)
	Serialize(os, cmd.money)

end

cmd_list["WuZheShiLianReset"] = 
function(os, cmd)
	Serialize(os, 291)

end

cmd_list["WuZheShiLianReset_Re"] = 
function(os, cmd)
	Serialize(os, 292)
	Serialize(os, cmd.retcode)

end

cmd_list["PveArenaUpdateVideoFlag"] = 
function(os, cmd)
	Serialize(os, 293)
	Serialize(os, cmd.video_flag)

end

cmd_list["WuZheShiLianGetReward"] = 
function(os, cmd)
	Serialize(os, 294)
	Serialize(os, cmd.difficulty)
	Serialize(os, cmd.stage)

end

cmd_list["WuZheShiLianGetReward_Re"] = 
function(os, cmd)
	Serialize(os, 295)
	Serialize(os, cmd.retcode)
	Serialize(os, cmd.difficulty)
	Serialize(os, cmd.stage)
	if cmd.rewards==nil then
		Serialize(os, 0)
	else
		Serialize(os, #cmd.rewards)
		for i = 1, #cmd.rewards do
			__SerializeStruct(os, "Item", cmd.rewards[i])
		end
	end

end

cmd_list["WuZheShiLianSweep"] = 
function(os, cmd)
	Serialize(os, 296)
	Serialize(os, cmd.difficulty)

end

cmd_list["WuZheShiLianSweep_Re"] = 
function(os, cmd)
	Serialize(os, 297)
	Serialize(os, cmd.difficulty)
	Serialize(os, cmd.retcode)

end

cmd_list["EquipmentEquip"] = 
function(os, cmd)
	Serialize(os, 301)
	Serialize(os, cmd.hero)
	Serialize(os, cmd.typ)
	Serialize(os, cmd.equipment_id)
	Serialize(os, cmd.cost_flag)

end

cmd_list["EquipmentEquip_Re"] = 
function(os, cmd)
	Serialize(os, 302)
	Serialize(os, cmd.retcode)
	Serialize(os, cmd.hero)
	Serialize(os, cmd.typ)
	Serialize(os, cmd.equipment_id)
	Serialize(os, cmd.cost_flag)

end

cmd_list["EquipmentLevelUp"] = 
function(os, cmd)
	Serialize(os, 303)
	Serialize(os, cmd.hero)
	Serialize(os, cmd.typ)
	Serialize(os, cmd.equipment_id)

end

cmd_list["EquipmentLevelUp_Re"] = 
function(os, cmd)
	Serialize(os, 304)
	Serialize(os, cmd.retcode)
	Serialize(os, cmd.hero)
	Serialize(os, cmd.typ)
	Serialize(os, cmd.equipment_id)
	Serialize(os, cmd.crit_flag)

end

cmd_list["EquipmentGradeUp"] = 
function(os, cmd)
	Serialize(os, 305)
	Serialize(os, cmd.hero)
	Serialize(os, cmd.typ)
	Serialize(os, cmd.equipment_id)

end

cmd_list["EquipmentGradeUp_Re"] = 
function(os, cmd)
	Serialize(os, 306)
	Serialize(os, cmd.retcode)
	Serialize(os, cmd.hero)
	Serialize(os, cmd.typ)
	Serialize(os, cmd.equipment_id)

end

cmd_list["EquipmentRefinable"] = 
function(os, cmd)
	Serialize(os, 307)
	Serialize(os, cmd.hero)
	Serialize(os, cmd.typ)
	Serialize(os, cmd.equipment_id)
	Serialize(os, cmd.refinable_typ)
	Serialize(os, cmd.refinable_count)

end

cmd_list["EquipmentRefinable_Re"] = 
function(os, cmd)
	Serialize(os, 308)
	Serialize(os, cmd.retcode)
	Serialize(os, cmd.hero)
	Serialize(os, cmd.typ)
	Serialize(os, cmd.equipment_id)
	Serialize(os, cmd.refinable_typ)
	Serialize(os, cmd.refinable_count)
	if cmd.tmp_refinable_pro==nil then
		Serialize(os, 0)
	else
		Serialize(os, #cmd.tmp_refinable_pro)
		for i = 1, #cmd.tmp_refinable_pro do
			__SerializeStruct(os, "RefinableData", cmd.tmp_refinable_pro[i])
		end
	end

end

cmd_list["EquipmentDecompose"] = 
function(os, cmd)
	Serialize(os, 309)
	if cmd.equipment_id==nil then
		Serialize(os, 0)
	else
		Serialize(os, #cmd.equipment_id)
		for i = 1, #cmd.equipment_id do
			Serialize(os, cmd.equipment_id[i])
		end
	end

end

cmd_list["EquipmentDecompose_Re"] = 
function(os, cmd)
	Serialize(os, 310)
	Serialize(os, cmd.retcode)
	if cmd.equipment_id==nil then
		Serialize(os, 0)
	else
		Serialize(os, #cmd.equipment_id)
		for i = 1, #cmd.equipment_id do
			Serialize(os, cmd.equipment_id[i])
		end
	end
	Serialize(os, cmd.money)
	if cmd.item_info==nil then
		Serialize(os, 0)
	else
		Serialize(os, #cmd.item_info)
		for i = 1, #cmd.item_info do
			__SerializeStruct(os, "Item", cmd.item_info[i])
		end
	end

end

cmd_list["EquipmentUnequip"] = 
function(os, cmd)
	Serialize(os, 311)
	Serialize(os, cmd.hero)
	Serialize(os, cmd.typ)
	Serialize(os, cmd.cost_flag)

end

cmd_list["EquipmentUnequip_Re"] = 
function(os, cmd)
	Serialize(os, 312)
	Serialize(os, cmd.retcode)
	Serialize(os, cmd.hero)
	Serialize(os, cmd.typ)
	Serialize(os, cmd.cost_flag)

end

cmd_list["EquipmentAdd"] = 
function(os, cmd)
	Serialize(os, 313)
	__SerializeStruct(os, "EquipmentItem", cmd.equipment_info)

end

cmd_list["EquipmentDel"] = 
function(os, cmd)
	Serialize(os, 314)
	Serialize(os, cmd.id)

end

cmd_list["EquipmentUpdate"] = 
function(os, cmd)
	Serialize(os, 315)
	__SerializeStruct(os, "EquipmentItem", cmd.equipment_info)

end

cmd_list["EquipmentRefinableSave"] = 
function(os, cmd)
	Serialize(os, 316)
	Serialize(os, cmd.hero)
	Serialize(os, cmd.typ)
	Serialize(os, cmd.equipment_id)
	Serialize(os, cmd.save_flag)

end

cmd_list["EquipmentRefinableSave_Re"] = 
function(os, cmd)
	Serialize(os, 317)
	Serialize(os, cmd.retcode)
	Serialize(os, cmd.hero)
	Serialize(os, cmd.typ)
	Serialize(os, cmd.equipment_id)
	Serialize(os, cmd.save_flag)

end

cmd_list["EquipmentEasyLevelUp"] = 
function(os, cmd)
	Serialize(os, 318)
	Serialize(os, cmd.hero)

end

cmd_list["EquipmentEasyLevelUp_Re"] = 
function(os, cmd)
	Serialize(os, 319)
	Serialize(os, cmd.retcode)
	Serialize(os, cmd.hero)
	if cmd.equipment_id==nil then
		Serialize(os, 0)
	else
		Serialize(os, #cmd.equipment_id)
		for i = 1, #cmd.equipment_id do
			Serialize(os, cmd.equipment_id[i])
		end
	end
	Serialize(os, cmd.money)

end

cmd_list["TongQueTaiSetHeroInfo"] = 
function(os, cmd)
	Serialize(os, 351)
	if cmd.hero==nil then
		Serialize(os, 0)
	else
		Serialize(os, #cmd.hero)
		for i = 1, #cmd.hero do
			Serialize(os, cmd.hero[i])
		end
	end

end

cmd_list["TongQueTaiSetHeroInfo_Re"] = 
function(os, cmd)
	Serialize(os, 352)
	Serialize(os, cmd.retcode)
	if cmd.hero==nil then
		Serialize(os, 0)
	else
		Serialize(os, #cmd.hero)
		for i = 1, #cmd.hero do
			Serialize(os, cmd.hero[i])
		end
	end

end

cmd_list["TongQueTaiBeginMatch"] = 
function(os, cmd)
	Serialize(os, 353)
	Serialize(os, cmd.difficulty)
	Serialize(os, cmd.double_flag)
	Serialize(os, cmd.auto_flag)

end

cmd_list["TongQueTaiBeginMatch_Re"] = 
function(os, cmd)
	Serialize(os, 354)
	Serialize(os, cmd.difficulty)
	Serialize(os, cmd.double_flag)
	Serialize(os, cmd.auto_flag)
	Serialize(os, cmd.retcode)

end

cmd_list["TongQueTaiCancleMatch"] = 
function(os, cmd)
	Serialize(os, 355)
	Serialize(os, cmd.difficulty)

end

cmd_list["TongQueTaiCancleMatch_Re"] = 
function(os, cmd)
	Serialize(os, 356)
	Serialize(os, cmd.difficulty)
	Serialize(os, cmd.retcode)

end

cmd_list["TongQueTaiMatchSuccess"] = 
function(os, cmd)
	Serialize(os, 357)
	Serialize(os, cmd.retcode)
	Serialize(os, cmd.join_index)
	Serialize(os, cmd.monster_index)
	if cmd.player_info==nil then
		Serialize(os, 0)
	else
		Serialize(os, #cmd.player_info)
		for i = 1, #cmd.player_info do
			__SerializeStruct(os, "TongQueTaiPlayerInfo", cmd.player_info[i])
		end
	end
	if cmd.monster_info==nil then
		Serialize(os, 0)
	else
		Serialize(os, #cmd.monster_info)
		for i = 1, #cmd.monster_info do
			__SerializeStruct(os, "TongQueTaiMonsterInfo", cmd.monster_info[i])
		end
	end

end

cmd_list["TongQueTaiNoticeRoleJoin"] = 
function(os, cmd)
	Serialize(os, 358)

end

cmd_list["TongQueTaiJoin"] = 
function(os, cmd)
	Serialize(os, 359)
	Serialize(os, cmd.role_id1)
	Serialize(os, cmd.role_id2)

end

cmd_list["TongQueTaiJoin_Re"] = 
function(os, cmd)
	Serialize(os, 360)
	Serialize(os, cmd.role_id)
	Serialize(os, cmd.retcode)
	Serialize(os, cmd.seed)

end

cmd_list["TongQueTaiOperation"] = 
function(os, cmd)
	Serialize(os, 361)
	if cmd.operation==nil then
		Serialize(os, 0)
	else
		Serialize(os, #cmd.operation)
		for i = 1, #cmd.operation do
			__SerializeStruct(os, "TongQueTaiOperation", cmd.operation[i])
		end
	end
	Serialize(os, cmd.role_id1)
	Serialize(os, cmd.role_id2)

end

cmd_list["TongQueTaiOperation_Re"] = 
function(os, cmd)
	Serialize(os, 362)
	if cmd.operation==nil then
		Serialize(os, 0)
	else
		Serialize(os, #cmd.operation)
		for i = 1, #cmd.operation do
			__SerializeStruct(os, "TongQueTaiOperation", cmd.operation[i])
		end
	end

end

cmd_list["TongQueTaiFinish"] = 
function(os, cmd)
	Serialize(os, 363)
	Serialize(os, cmd.win_flag)
	Serialize(os, cmd.role_id1)
	Serialize(os, cmd.role_id2)
	if cmd.hero_info==nil then
		Serialize(os, 0)
	else
		Serialize(os, #cmd.hero_info)
		for i = 1, #cmd.hero_info do
			__SerializeStruct(os, "TongQueTaiMonsterState", cmd.hero_info[i])
		end
	end
	if cmd.monster_info==nil then
		Serialize(os, 0)
	else
		Serialize(os, #cmd.monster_info)
		for i = 1, #cmd.monster_info do
			__SerializeStruct(os, "TongQueTaiMonsterState", cmd.monster_info[i])
		end
	end
	if cmd.operations==nil then
		Serialize(os, 0)
	else
		Serialize(os, #cmd.operations)
		for i = 1, #cmd.operations do
			__SerializeStruct(os, "PVEOperation", cmd.operations[i])
		end
	end

end

cmd_list["TongQueTaiFinish_Re"] = 
function(os, cmd)
	Serialize(os, 364)
	Serialize(os, cmd.retcode)
	Serialize(os, cmd.win_flag)
	Serialize(os, cmd.monster_index)
	if cmd.hero_info==nil then
		Serialize(os, 0)
	else
		Serialize(os, #cmd.hero_info)
		for i = 1, #cmd.hero_info do
			__SerializeStruct(os, "TongQueTaiMonsterState", cmd.hero_info[i])
		end
	end
	if cmd.monster_info==nil then
		Serialize(os, 0)
	else
		Serialize(os, #cmd.monster_info)
		for i = 1, #cmd.monster_info do
			__SerializeStruct(os, "TongQueTaiMonsterState", cmd.monster_info[i])
		end
	end

end

cmd_list["TongQueTaiReward"] = 
function(os, cmd)
	Serialize(os, 365)

end

cmd_list["TongQueTaiSpeed"] = 
function(os, cmd)
	Serialize(os, 366)
	Serialize(os, cmd.speed)
	Serialize(os, cmd.role_id1)
	Serialize(os, cmd.role_id2)

end

cmd_list["TongQueTaiSpeed_Re"] = 
function(os, cmd)
	Serialize(os, 367)
	Serialize(os, cmd.role_id)
	Serialize(os, cmd.speed)

end

cmd_list["TongQueTaiLoad"] = 
function(os, cmd)
	Serialize(os, 368)
	Serialize(os, cmd.role_id1)
	Serialize(os, cmd.role_id2)

end

cmd_list["TongQueTaiLoad_Re"] = 
function(os, cmd)
	Serialize(os, 369)
	Serialize(os, cmd.role_id)

end

cmd_list["TongQueTaiReLoad"] = 
function(os, cmd)
	Serialize(os, 370)
	Serialize(os, cmd.role_index)
	Serialize(os, cmd.monster_index)
	Serialize(os, cmd.retcode)

end

cmd_list["TongQueTaiEnd"] = 
function(os, cmd)
	Serialize(os, 371)
	Serialize(os, cmd.retcode)

end

cmd_list["TongQueTaiGetReward"] = 
function(os, cmd)
	Serialize(os, 372)

end

cmd_list["TongQueTaiGetReward_Re"] = 
function(os, cmd)
	Serialize(os, 373)
	Serialize(os, cmd.retcode)
	Serialize(os, cmd.double_flag)
	if cmd.reward==nil then
		Serialize(os, 0)
	else
		Serialize(os, #cmd.reward)
		for i = 1, #cmd.reward do
			__SerializeStruct(os, "Item", cmd.reward[i])
		end
	end

end

cmd_list["TongQueTaiGetInfo"] = 
function(os, cmd)
	Serialize(os, 374)

end

cmd_list["TongQueTaiGetInfo_Re"] = 
function(os, cmd)
	Serialize(os, 375)
	if cmd.hero==nil then
		Serialize(os, 0)
	else
		Serialize(os, #cmd.hero)
		for i = 1, #cmd.hero do
			Serialize(os, cmd.hero[i])
		end
	end
	Serialize(os, cmd.reward_flag)

end

cmd_list["BattleFieldGetRoundStateInfo"] = 
function(os, cmd)
	Serialize(os, 401)
	Serialize(os, cmd.battle_id)
	Serialize(os, cmd.round_state)

end

cmd_list["BattleFieldGetRoundStateInfo_Re"] = 
function(os, cmd)
	Serialize(os, 402)
	Serialize(os, cmd.retcode)
	Serialize(os, cmd.battle_id)
	Serialize(os, cmd.round_state)
	if cmd.event_info==nil then
		Serialize(os, 0)
	else
		Serialize(os, #cmd.event_info)
		for i = 1, #cmd.event_info do
			__SerializeStruct(os, "BattleEventInfo", cmd.event_info[i])
		end
	end
	if cmd.npc_info==nil then
		Serialize(os, 0)
	else
		Serialize(os, #cmd.npc_info)
		for i = 1, #cmd.npc_info do
			__SerializeStruct(os, "BattleFieldNpcMoveInfo", cmd.npc_info[i])
		end
	end
	if cmd.info_history==nil then
		Serialize(os, 0)
	else
		Serialize(os, #cmd.info_history)
		for i = 1, #cmd.info_history do
			Serialize(os, cmd.info_history[i])
		end
	end
	if cmd.move_pos==nil then
		Serialize(os, 0)
	else
		Serialize(os, #cmd.move_pos)
		for i = 1, #cmd.move_pos do
			__SerializeStruct(os, "MovePos", cmd.move_pos[i])
		end
	end
	if cmd.morale_change==nil then
		Serialize(os, 0)
	else
		Serialize(os, #cmd.morale_change)
		for i = 1, #cmd.morale_change do
			__SerializeStruct(os, "MoraleData", cmd.morale_change[i])
		end
	end
	Serialize(os, cmd.cur_morale)

end

cmd_list["BattleFieldUpdateRoundState"] = 
function(os, cmd)
	Serialize(os, 403)
	Serialize(os, cmd.battle_id)
	Serialize(os, cmd.round_num)
	Serialize(os, cmd.round_state)

end

cmd_list["BattleFieldRoundCount"] = 
function(os, cmd)
	Serialize(os, 404)
	Serialize(os, cmd.battle_id)

end

cmd_list["BattleFieldRoundCount_Re"] = 
function(os, cmd)
	Serialize(os, 405)
	Serialize(os, cmd.retcode)
	Serialize(os, cmd.battle_id)

end

cmd_list["BackPackUseItem"] = 
function(os, cmd)
	Serialize(os, 421)
	Serialize(os, cmd.item_id)
	Serialize(os, cmd.item_num)

end

cmd_list["BackPackUseItem_Re"] = 
function(os, cmd)
	Serialize(os, 422)
	Serialize(os, cmd.retcode)
	Serialize(os, cmd.item_id)
	Serialize(os, cmd.item_num)
	if cmd.items==nil then
		Serialize(os, 0)
	else
		Serialize(os, #cmd.items)
		for i = 1, #cmd.items do
			__SerializeStruct(os, "Item", cmd.items[i])
		end
	end

end

cmd_list["TemporaryBackPackGetInfo"] = 
function(os, cmd)
	Serialize(os, 423)

end

cmd_list["TemporaryBackPackGetInfo_Re"] = 
function(os, cmd)
	Serialize(os, 424)
	if cmd.items==nil then
		Serialize(os, 0)
	else
		Serialize(os, #cmd.items)
		for i = 1, #cmd.items do
			__SerializeStruct(os, "TemporaryBackPackData", cmd.items[i])
		end
	end

end

cmd_list["TemporaryBackPackReceiveItem"] = 
function(os, cmd)
	Serialize(os, 425)
	Serialize(os, cmd.id)

end

cmd_list["TemporaryBackPackReceiveItem_Re"] = 
function(os, cmd)
	Serialize(os, 426)
	Serialize(os, cmd.retcode)
	Serialize(os, cmd.id)

end

cmd_list["TemporaryBackPackUpdate"] = 
function(os, cmd)
	Serialize(os, 427)
	__SerializeStruct(os, "TemporaryBackPackData", cmd.item)

end

cmd_list["HeroAddStar"] = 
function(os, cmd)
	Serialize(os, 428)
	Serialize(os, cmd.hero_id)

end

cmd_list["HeroAddStar_Re"] = 
function(os, cmd)
	Serialize(os, 429)
	Serialize(os, cmd.retcode)
	Serialize(os, cmd.hero_id)
	Serialize(os, cmd.star)

end

cmd_list["PveArenaUpdateInfo"] = 
function(os, cmd)
	Serialize(os, 430)
	if cmd.defence_hero==nil then
		Serialize(os, 0)
	else
		Serialize(os, #cmd.defence_hero)
		for i = 1, #cmd.defence_hero do
			Serialize(os, cmd.defence_hero[i])
		end
	end

end

cmd_list["UpdateLotteryInfo"] = 
function(os, cmd)
	Serialize(os, 431)
	if cmd.lottery_info==nil then
		Serialize(os, 0)
	else
		Serialize(os, #cmd.lottery_info)
		for i = 1, #cmd.lottery_info do
			__SerializeStruct(os, "LotteryInfo", cmd.lottery_info[i])
		end
	end

end

cmd_list["GetRankPveArenaInfo"] = 
function(os, cmd)
	Serialize(os, 432)
	Serialize(os, cmd.rank)

end

cmd_list["GetRankPveArenaInfo_Re"] = 
function(os, cmd)
	Serialize(os, 433)
	__SerializeStruct(os, "PveArenaFighterInfo", cmd.info)

end

cmd_list["ChangeLotterySelect"] = 
function(os, cmd)
	Serialize(os, 434)
	Serialize(os, cmd.lottery_id)
	Serialize(os, cmd.select_id)

end

cmd_list["ChangeLotterySelect_Re"] = 
function(os, cmd)
	Serialize(os, 435)
	Serialize(os, cmd.retcode)
	Serialize(os, cmd.lottery_id)
	Serialize(os, cmd.select_id)

end

cmd_list["LegionGetInfo"] = 
function(os, cmd)
	Serialize(os, 500)

end

cmd_list["LegionGetInfo_Re"] = 
function(os, cmd)
	Serialize(os, 501)
	Serialize(os, cmd.junxueguan_level)

end

cmd_list["LegionJunXueGuanGetInfo"] = 
function(os, cmd)
	Serialize(os, 502)

end

cmd_list["LegionJunXueGuanGetInfo_Re"] = 
function(os, cmd)
	Serialize(os, 503)
	if cmd.info==nil then
		Serialize(os, 0)
	else
		Serialize(os, #cmd.info)
		for i = 1, #cmd.info do
			__SerializeStruct(os, "LegionJunXueGuanData", cmd.info[i])
		end
	end

end

cmd_list["LegionJunXueZhuanJingLevelUp"] = 
function(os, cmd)
	Serialize(os, 504)
	Serialize(os, cmd.id)

end

cmd_list["LegionJunXueZhuanJingLevelUp_Re"] = 
function(os, cmd)
	Serialize(os, 505)
	Serialize(os, cmd.retcode)
	Serialize(os, cmd.id)
	Serialize(os, cmd.level)
	Serialize(os, cmd.xiangmu_open)
	Serialize(os, cmd.xiangmu_id)

end

cmd_list["LegionLearnJunXueXiangMu"] = 
function(os, cmd)
	Serialize(os, 506)
	Serialize(os, cmd.id)
	Serialize(os, cmd.learn_id)

end

cmd_list["LegionLearnJunXueXiangMu_Re"] = 
function(os, cmd)
	Serialize(os, 507)
	Serialize(os, cmd.retcode)
	Serialize(os, cmd.id)
	Serialize(os, cmd.learn_id)

end

cmd_list["LegionAddJunXueGuanInfo"] = 
function(os, cmd)
	Serialize(os, 508)
	__SerializeStruct(os, "LegionJunXueGuanData", cmd.info)

end

cmd_list["LegionOpenJunXueGuan"] = 
function(os, cmd)
	Serialize(os, 509)
	Serialize(os, cmd.level)

end

cmd_list["LegionActivationZhuanJing"] = 
function(os, cmd)
	Serialize(os, 510)
	Serialize(os, cmd.id)

end

cmd_list["LegionActivationZhuanJing_Re"] = 
function(os, cmd)
	Serialize(os, 511)
	Serialize(os, cmd.retcode)
	Serialize(os, cmd.id)
	__SerializeStruct(os, "LegionJunXueGuanData", cmd.info)

end

cmd_list["LegionDecomposeWuHun"] = 
function(os, cmd)
	Serialize(os, 512)
	if cmd.item==nil then
		Serialize(os, 0)
	else
		Serialize(os, #cmd.item)
		for i = 1, #cmd.item do
			__SerializeStruct(os, "Item", cmd.item[i])
		end
	end

end

cmd_list["LegionDecomposeWuHun_Re"] = 
function(os, cmd)
	Serialize(os, 513)
	Serialize(os, cmd.retcode)
	if cmd.item==nil then
		Serialize(os, 0)
	else
		Serialize(os, #cmd.item)
		for i = 1, #cmd.item do
			__SerializeStruct(os, "Item", cmd.item[i])
		end
	end
	Serialize(os, cmd.count)

end

cmd_list["GetRoleInfo"] = 
function(os, cmd)
	Serialize(os, 1000001)

end

cmd_list["GetRoleInfo_Re"] = 
function(os, cmd)
	Serialize(os, 1000002)
	Serialize(os, cmd.retcode)
	__SerializeStruct(os, "RoleInfo", cmd.info)
	Serialize(os, cmd.openservertime)

end

cmd_list["CreateRole"] = 
function(os, cmd)
	Serialize(os, 1000003)
	Serialize(os, cmd.name)
	Serialize(os, cmd.photo)
	Serialize(os, cmd.sex)

end

cmd_list["CreateRole_Re"] = 
function(os, cmd)
	Serialize(os, 1000004)
	Serialize(os, cmd.retcode)
	__SerializeStruct(os, "RoleInfo", cmd.info)

end

cmd_list["ReportClientVersion"] = 
function(os, cmd)
	Serialize(os, 1000005)
	Serialize(os, cmd.client_id)
	Serialize(os, cmd.exe_ver)
	Serialize(os, cmd.data_ver)

end

cmd_list["MaShuGetRoleInfo"] = 
function(os, cmd)
	Serialize(os, 600)

end

cmd_list["MaShuGetRoleInfo_Re"] = 
function(os, cmd)
	Serialize(os, 601)
	Serialize(os, cmd.rank)
	Serialize(os, cmd.yestaday_rank)
	Serialize(os, cmd.today_score)
	Serialize(os, cmd.hisroty_score)
	Serialize(os, cmd.today_stage)
	Serialize(os, cmd.history_stage)
	Serialize(os, cmd.get_prize_flag)
	__SerializeStruct(os, "MaShuHeroInfo", cmd.hero_info)
	if cmd.friend_info==nil then
		Serialize(os, 0)
	else
		Serialize(os, #cmd.friend_info)
		for i = 1, #cmd.friend_info do
			__SerializeStruct(os, "MaShuFriendInfo", cmd.friend_info[i])
		end
	end
	if cmd.buff_info==nil then
		Serialize(os, 0)
	else
		Serialize(os, #cmd.buff_info)
		for i = 1, #cmd.buff_info do
			__SerializeStruct(os, "MaShuBuffInfo", cmd.buff_info[i])
		end
	end
	__SerializeStruct(os, "MaShuFightFriendInfo", cmd.fight_friend)

end

cmd_list["MaShuSelectFriendToHelp"] = 
function(os, cmd)
	Serialize(os, 602)
	Serialize(os, cmd.roleid)

end

cmd_list["MaShuSelectFriendToHelp_Re"] = 
function(os, cmd)
	Serialize(os, 603)
	Serialize(os, cmd.retcode)
	Serialize(os, cmd.roleid)

end

cmd_list["MaShuGetBuff"] = 
function(os, cmd)
	Serialize(os, 604)
	Serialize(os, cmd.id)

end

cmd_list["MaShuGetBuff_Re"] = 
function(os, cmd)
	Serialize(os, 605)
	Serialize(os, cmd.retcode)
	Serialize(os, cmd.id)
	__SerializeStruct(os, "MaShuBuffInfo", cmd.buff_info)

end

cmd_list["MaShuBegin"] = 
function(os, cmd)
	Serialize(os, 606)
	Serialize(os, cmd.id)

end

cmd_list["MaShuBegin_Re"] = 
function(os, cmd)
	Serialize(os, 607)
	Serialize(os, cmd.retcode)
	Serialize(os, cmd.id)
	Serialize(os, cmd.seed)
	Serialize(os, cmd.scene)

end

cmd_list["MaShuGetPrize"] = 
function(os, cmd)
	Serialize(os, 608)
	Serialize(os, cmd.stage)

end

cmd_list["MaShuGetPrize_Re"] = 
function(os, cmd)
	Serialize(os, 609)
	Serialize(os, cmd.retcode)
	Serialize(os, cmd.stage)
	if cmd.item==nil then
		Serialize(os, 0)
	else
		Serialize(os, #cmd.item)
		for i = 1, #cmd.item do
			__SerializeStruct(os, "Item", cmd.item[i])
		end
	end
	Serialize(os, cmd.money)

end

cmd_list["MaShuUpdateScore"] = 
function(os, cmd)
	Serialize(os, 610)
	Serialize(os, cmd.score)

end

cmd_list["MaShuUpdateScore_Re"] = 
function(os, cmd)
	Serialize(os, 611)
	Serialize(os, cmd.retcode)
	Serialize(os, cmd.score)

end

cmd_list["MaShuEnd"] = 
function(os, cmd)
	Serialize(os, 612)
	Serialize(os, cmd.id)
	Serialize(os, cmd.score)
	Serialize(os, cmd.stage)
	Serialize(os, cmd.box_num)
	Serialize(os, cmd.money)
	if cmd.operations==nil then
		Serialize(os, 0)
	else
		Serialize(os, #cmd.operations)
		for i = 1, #cmd.operations do
			__SerializeStruct(os, "PVEOperation", cmd.operations[i])
		end
	end

end

cmd_list["MaShuEnd_Re"] = 
function(os, cmd)
	Serialize(os, 613)
	Serialize(os, cmd.retcode)
	Serialize(os, cmd.id)
	Serialize(os, cmd.score)
	Serialize(os, cmd.stage)
	Serialize(os, cmd.box_num)
	Serialize(os, cmd.money)
	__SerializeStruct(os, "TemporaryBackPackData", cmd.item)
	Serialize(os, cmd.server_money)
	Serialize(os, cmd.last_rank)
	Serialize(os, cmd.cur_rank)

end

cmd_list["MaShuGetRankPrize"] = 
function(os, cmd)
	Serialize(os, 614)

end

cmd_list["MaShuGetRankPrize_Re"] = 
function(os, cmd)
	Serialize(os, 615)
	Serialize(os, cmd.retcode)
	__SerializeStruct(os, "TemporaryBackPackData", cmd.item)
	Serialize(os, cmd.yestaday_rank)
	Serialize(os, cmd.get_prize_flag)

end

cmd_list["MaShuUpdateRoleInfo"] = 
function(os, cmd)
	Serialize(os, 616)
	Serialize(os, cmd.rank)
	Serialize(os, cmd.yestaday_rank)
	Serialize(os, cmd.today_score)
	Serialize(os, cmd.today_stage)
	Serialize(os, cmd.get_prize_flag)
	if cmd.friend_info==nil then
		Serialize(os, 0)
	else
		Serialize(os, #cmd.friend_info)
		for i = 1, #cmd.friend_info do
			__SerializeStruct(os, "MaShuFriendInfo", cmd.friend_info[i])
		end
	end

end

cmd_list["JieYiGetRoleInfo"] = 
function(os, cmd)
	Serialize(os, 651)

end

cmd_list["JieYiGetRoleInfo_Re"] = 
function(os, cmd)
	Serialize(os, 652)
	Serialize(os, cmd.id)
	Serialize(os, cmd.name)
	Serialize(os, cmd.level)
	Serialize(os, cmd.exp)
	Serialize(os, cmd.cur_operate_id)
	Serialize(os, cmd.cur_operate_typ)

end

cmd_list["JieYiUpdateRoleInfo"] = 
function(os, cmd)
	Serialize(os, 653)
	Serialize(os, cmd.id)
	Serialize(os, cmd.name)

end

cmd_list["JieYiGetInfo"] = 
function(os, cmd)
	Serialize(os, 654)
	Serialize(os, cmd.id)

end

cmd_list["JieYiGetInfo_Re"] = 
function(os, cmd)
	Serialize(os, 655)
	Serialize(os, cmd.id)
	Serialize(os, cmd.name)
	Serialize(os, cmd.level)
	Serialize(os, cmd.exp)
	__SerializeStruct(os, "JieYiInfo", cmd.bossinfo)
	if cmd.brotherinfo==nil then
		Serialize(os, 0)
	else
		Serialize(os, #cmd.brotherinfo)
		for i = 1, #cmd.brotherinfo do
			__SerializeStruct(os, "JieYiInfo", cmd.brotherinfo[i])
		end
	end
	Serialize(os, cmd.typ)

end

cmd_list["JieYiUpdateInfo"] = 
function(os, cmd)
	Serialize(os, 656)

end

cmd_list["JieYiCreate"] = 
function(os, cmd)
	Serialize(os, 657)
	Serialize(os, cmd.name)

end

cmd_list["JieYiCreate_Re"] = 
function(os, cmd)
	Serialize(os, 658)
	Serialize(os, cmd.cur_operate_id)
	Serialize(os, cmd.cur_operate_typ)

end

cmd_list["JieYiInviteRole"] = 
function(os, cmd)
	Serialize(os, 659)
	Serialize(os, cmd.typ)
	Serialize(os, cmd.id)
	Serialize(os, cmd.name)
	Serialize(os, cmd.dest_id)

end

cmd_list["JieYiInviteRole_Re"] = 
function(os, cmd)
	Serialize(os, 660)
	Serialize(os, cmd.retcode)
	Serialize(os, cmd.role_id)

end

cmd_list["JieYiInvite_Re"] = 
function(os, cmd)
	Serialize(os, 661)
	Serialize(os, cmd.typ)
	Serialize(os, cmd.id)
	Serialize(os, cmd.name)

end

cmd_list["JieYiReply"] = 
function(os, cmd)
	Serialize(os, 662)
	Serialize(os, cmd.typ)
	Serialize(os, cmd.id)
	Serialize(os, cmd.name)
	Serialize(os, cmd.agreement)
	Serialize(os, cmd.boss_id)
	Serialize(os, cmd.brother_id)

end

cmd_list["JieYiReply_Re"] = 
function(os, cmd)
	Serialize(os, 663)
	Serialize(os, cmd.id)
	Serialize(os, cmd.typ)
	Serialize(os, cmd.retcode)
	Serialize(os, cmd.role_id)

end

cmd_list["JieYiOperateInvite"] = 
function(os, cmd)
	Serialize(os, 664)
	Serialize(os, cmd.dest_id)
	Serialize(os, cmd.typ)
	Serialize(os, cmd.id)
	Serialize(os, cmd.name)
	Serialize(os, cmd.agreement)
	Serialize(os, cmd.boss_id)
	Serialize(os, cmd.brother_id)

end

cmd_list["JieYiOperateInvite_Re"] = 
function(os, cmd)
	Serialize(os, 665)
	Serialize(os, cmd.id)
	Serialize(os, cmd.name)
	Serialize(os, cmd.role_id)
	Serialize(os, cmd.retcode)

end

cmd_list["JieYiLastCreate"] = 
function(os, cmd)
	Serialize(os, 666)
	Serialize(os, cmd.id)
	Serialize(os, cmd.name)
	Serialize(os, cmd.typ)
	Serialize(os, cmd.boss_id)
	Serialize(os, cmd.brother_id)

end

cmd_list["JieYiLastCreate_Re"] = 
function(os, cmd)
	Serialize(os, 667)
	Serialize(os, cmd.id)
	Serialize(os, cmd.name)
	Serialize(os, cmd.dest_id)

end

cmd_list["JieYiLastOperate"] = 
function(os, cmd)
	Serialize(os, 668)
	Serialize(os, cmd.agreement)
	Serialize(os, cmd.id)
	Serialize(os, cmd.name)
	Serialize(os, cmd.typ)
	Serialize(os, cmd.boss_id)
	Serialize(os, cmd.brother_id)

end

cmd_list["JieYiLastOperate_Re"] = 
function(os, cmd)
	Serialize(os, 669)
	Serialize(os, cmd.id)
	Serialize(os, cmd.name)
	Serialize(os, cmd.role_id)
	Serialize(os, cmd.retcode)

end

cmd_list["JieYiResult"] = 
function(os, cmd)
	Serialize(os, 670)
	Serialize(os, cmd.id)
	Serialize(os, cmd.name)
	Serialize(os, cmd.retcode)

end

cmd_list["JieYiGetInviteInfo"] = 
function(os, cmd)
	Serialize(os, 671)

end

cmd_list["JieYiGetInviteInfo_Re"] = 
function(os, cmd)
	Serialize(os, 672)
	if cmd.invite_member==nil then
		Serialize(os, 0)
	else
		Serialize(os, #cmd.invite_member)
		for i = 1, #cmd.invite_member do
			Serialize(os, cmd.invite_member[i])
		end
	end

end

cmd_list["JieYiCancelInviteRole"] = 
function(os, cmd)
	Serialize(os, 673)
	Serialize(os, cmd.id)
	Serialize(os, cmd.name)
	Serialize(os, cmd.brother_id)

end

cmd_list["JieYiCancelInviteRole_Re"] = 
function(os, cmd)
	Serialize(os, 674)
	Serialize(os, cmd.id)
	Serialize(os, cmd.name)
	Serialize(os, cmd.brother_id)
	Serialize(os, cmd.retcode)

end

cmd_list["JieYiExpelBrother"] = 
function(os, cmd)
	Serialize(os, 675)
	Serialize(os, cmd.id)
	Serialize(os, cmd.name)
	Serialize(os, cmd.brother_id)
	Serialize(os, cmd.brother_otherid)

end

cmd_list["JieYiExpelBrother_Re"] = 
function(os, cmd)
	Serialize(os, 676)
	Serialize(os, cmd.id)
	Serialize(os, cmd.name)
	Serialize(os, cmd.brother_id)
	Serialize(os, cmd.retcode)

end

cmd_list["JieYiDisolve_Re"] = 
function(os, cmd)
	Serialize(os, 677)
	Serialize(os, cmd.retcode)

end

cmd_list["JieYiExitCurrentJieYi"] = 
function(os, cmd)
	Serialize(os, 678)
	Serialize(os, cmd.id)
	Serialize(os, cmd.name)
	Serialize(os, cmd.brother_id)
	Serialize(os, cmd.brother_otherid)

end

cmd_list["JieYiExitCurrentJieYi_Re"] = 
function(os, cmd)
	Serialize(os, 679)
	Serialize(os, cmd.id)
	Serialize(os, cmd.name)
	Serialize(os, cmd.retcode)
	Serialize(os, cmd.brother_id)

end

cmd_list["AudienceGetList"] = 
function(os, cmd)
	Serialize(os, 700)

end

cmd_list["AudienceGetList_Re"] = 
function(os, cmd)
	Serialize(os, 701)
	if cmd._fight_info==nil then
		Serialize(os, 0)
	else
		Serialize(os, #cmd._fight_info)
		for i = 1, #cmd._fight_info do
			__SerializeStruct(os, "FightInfo", cmd._fight_info[i])
		end
	end

end

cmd_list["AudienceGetOperation"] = 
function(os, cmd)
	Serialize(os, 702)
	Serialize(os, cmd.room_id)

end

cmd_list["AudienceGetOperation_Re"] = 
function(os, cmd)
	Serialize(os, 703)
	Serialize(os, cmd.retcode)
	Serialize(os, cmd.room_id)
	Serialize(os, cmd.robot_flag)
	Serialize(os, cmd.robot_seed)
	Serialize(os, cmd.robot_type)
	__SerializeStruct(os, "RoleClientPVPInfo", cmd.player1)
	__SerializeStruct(os, "RoleClientPVPInfo", cmd.player2)
	__SerializeStruct(os, "PvpVideo", cmd.operation)

end

cmd_list["AudienceSendOperation"] = 
function(os, cmd)
	Serialize(os, 704)
	Serialize(os, cmd.room_id)
	__SerializeStruct(os, "PvpVideo", cmd.operation)

end

cmd_list["AudienceLeaveRoom"] = 
function(os, cmd)
	Serialize(os, 705)
	Serialize(os, cmd.room_id)

end

cmd_list["AudienceFinishRoom"] = 
function(os, cmd)
	Serialize(os, 706)
	Serialize(os, cmd.room_id)
	Serialize(os, cmd.win_flag)
	Serialize(os, cmd.reason)
	__SerializeStruct(os, "PvpVideo", cmd.operation)

end

cmd_list["AudienceUpdateNum"] = 
function(os, cmd)
	Serialize(os, 707)
	Serialize(os, cmd.num)

end

cmd_list["PhotoSetPhoto"] = 
function(os, cmd)
	Serialize(os, 730)
	Serialize(os, cmd.photo_id)

end

cmd_list["PhotoSetPhoto_Re"] = 
function(os, cmd)
	Serialize(os, 731)
	Serialize(os, cmd.retcode)
	Serialize(os, cmd.photo_id)

end

cmd_list["PhotoSetPhotoFrame"] = 
function(os, cmd)
	Serialize(os, 732)
	Serialize(os, cmd.photoframe_id)

end

cmd_list["PhotoSetPhotoFrame_Re"] = 
function(os, cmd)
	Serialize(os, 733)
	Serialize(os, cmd.retcode)
	Serialize(os, cmd.photoframe_id)

end

cmd_list["PhotoUpdatePhotoInfo"] = 
function(os, cmd)
	Serialize(os, 736)
	if cmd.photo_info==nil then
		Serialize(os, 0)
	else
		Serialize(os, #cmd.photo_info)
		for i = 1, #cmd.photo_info do
			__SerializeStruct(os, "PhotoInfo", cmd.photo_info[i])
		end
	end
	if cmd.photoframe_info==nil then
		Serialize(os, 0)
	else
		Serialize(os, #cmd.photoframe_info)
		for i = 1, #cmd.photoframe_info do
			__SerializeStruct(os, "PhotoInfo", cmd.photoframe_info[i])
		end
	end

end

cmd_list["PhotoUpdateBadgeInfo"] = 
function(os, cmd)
	Serialize(os, 737)
	Serialize(os, cmd.add_flag)
	if cmd.badge_info==nil then
		Serialize(os, 0)
	else
		Serialize(os, #cmd.badge_info)
		for i = 1, #cmd.badge_info do
			__SerializeStruct(os, "PhotoInfo", cmd.badge_info[i])
		end
	end

end

cmd_list["YueZhanCreate"] = 
function(os, cmd)
	Serialize(os, 751)
	Serialize(os, cmd.channel)
	Serialize(os, cmd.announce)

end

cmd_list["YueZhanCreate_Re"] = 
function(os, cmd)
	Serialize(os, 752)
	Serialize(os, cmd.retcode)
	Serialize(os, cmd.room_id)

end

cmd_list["YueZhanJoin"] = 
function(os, cmd)
	Serialize(os, 753)
	Serialize(os, cmd.room_id)

end

cmd_list["YueZhanJoin_Re"] = 
function(os, cmd)
	Serialize(os, 754)
	Serialize(os, cmd.retcode)
	Serialize(os, cmd.room_id)

end

cmd_list["YueZhanCancel"] = 
function(os, cmd)
	Serialize(os, 755)
	Serialize(os, cmd.room_id)

end

cmd_list["YueZhanCancel_Re"] = 
function(os, cmd)
	Serialize(os, 756)
	Serialize(os, cmd.retcode)
	Serialize(os, cmd.room_id)

end

cmd_list["YueZhanDanMu"] = 
function(os, cmd)
	Serialize(os, 757)
	Serialize(os, cmd.pvp_id)
	Serialize(os, cmd.video_id)
	Serialize(os, cmd.tick)
	Serialize(os, cmd.word_info)

end

cmd_list["DanMuInfo"] = 
function(os, cmd)
	Serialize(os, 758)
	Serialize(os, cmd.typ)
	__SerializeStruct(os, "DanMuDataVector", cmd.info)

end

cmd_list["YueZhanInfo"] = 
function(os, cmd)
	Serialize(os, 759)
	Serialize(os, cmd.id)
	Serialize(os, cmd.channel)
	Serialize(os, cmd.typ)
	__SerializeStruct(os, "RoleBrief", cmd.creater)
	__SerializeStruct(os, "RoleBrief", cmd.joiner)
	Serialize(os, cmd.announce)
	Serialize(os, cmd.info_id)
	Serialize(os, cmd.time)

end

cmd_list["GetFlowerInfo"] = 
function(os, cmd)
	Serialize(os, 800)
	Serialize(os, cmd.id)

end

cmd_list["GetFlowerInfo_Re"] = 
function(os, cmd)
	Serialize(os, 801)
	__SerializeStruct(os, "RoleBrief", cmd.info)
	Serialize(os, cmd.lingering)
	Serialize(os, cmd.flower_count)
	if cmd.flowergift_info==nil then
		Serialize(os, 0)
	else
		Serialize(os, #cmd.flowergift_info)
		for i = 1, #cmd.flowergift_info do
			__SerializeStruct(os, "FlowerGiftInfo", cmd.flowergift_info[i])
		end
	end
	if cmd.sendflowergift_info==nil then
		Serialize(os, 0)
	else
		Serialize(os, #cmd.sendflowergift_info)
		for i = 1, #cmd.sendflowergift_info do
			__SerializeStruct(os, "FlowerGiftInfo", cmd.sendflowergift_info[i])
		end
	end
	Serialize(os, cmd.recive_flag)
	Serialize(os, cmd.title_id)

end

cmd_list["SendFlowerGift"] = 
function(os, cmd)
	Serialize(os, 806)
	Serialize(os, cmd.typ)
	Serialize(os, cmd.dest_id)

end

cmd_list["UpdateFlowerGiftInfo"] = 
function(os, cmd)
	Serialize(os, 807)

end

cmd_list["SendFlowerGift_Re"] = 
function(os, cmd)
	Serialize(os, 808)
	Serialize(os, cmd.typ)
	Serialize(os, cmd.dest_id)
	Serialize(os, cmd.count)
	Serialize(os, cmd.time)
	__SerializeStruct(os, "RoleBrief", cmd.src)
	__SerializeStruct(os, "RoleBrief", cmd.dest)
	Serialize(os, cmd.mask)

end

cmd_list["FlowerGiftTipsClear"] = 
function(os, cmd)
	Serialize(os, 809)

end

cmd_list["FlowerGiftTipsClear_Re"] = 
function(os, cmd)
	Serialize(os, 810)
	Serialize(os, cmd.flag)

end

cmd_list["TeXingGetInfo"] = 
function(os, cmd)
	Serialize(os, 821)

end

cmd_list["TeXingGetInfo_Re"] = 
function(os, cmd)
	Serialize(os, 822)
	if cmd.texing_info==nil then
		Serialize(os, 0)
	else
		Serialize(os, #cmd.texing_info)
		for i = 1, #cmd.texing_info do
			Serialize(os, cmd.texing_info[i])
		end
	end

end

cmd_list["TeXingUpdateInfo"] = 
function(os, cmd)
	Serialize(os, 823)
	if cmd.texing_add==nil then
		Serialize(os, 0)
	else
		Serialize(os, #cmd.texing_add)
		for i = 1, #cmd.texing_add do
			Serialize(os, cmd.texing_add[i])
		end
	end
	if cmd.texing_del==nil then
		Serialize(os, 0)
	else
		Serialize(os, #cmd.texing_del)
		for i = 1, #cmd.texing_del do
			Serialize(os, cmd.texing_del[i])
		end
	end

end

cmd_list["ChongZhi"] = 
function(os, cmd)
	Serialize(os, 831)
	Serialize(os, cmd.yuanbao)
	Serialize(os, cmd.extra_yuanbao)
	Serialize(os, cmd.fudai_flag)
	Serialize(os, cmd.fudai_time)

end

cmd_list["UpdateFuDaiTime"] = 
function(os, cmd)
	Serialize(os, 832)
	Serialize(os, cmd.fudai_flag)
	Serialize(os, cmd.fudai_time)

end

cmd_list["FuDaiGetReward"] = 
function(os, cmd)
	Serialize(os, 833)
	Serialize(os, cmd.fudai_flag)

end

cmd_list["FuDaiGetReward_Re"] = 
function(os, cmd)
	Serialize(os, 834)
	Serialize(os, cmd.retcode)
	Serialize(os, cmd.fudai_flag)
	if cmd.item==nil then
		Serialize(os, 0)
	else
		Serialize(os, #cmd.item)
		for i = 1, #cmd.item do
			__SerializeStruct(os, "Item", cmd.item[i])
		end
	end

end

cmd_list["DailySignUpdate"] = 
function(os, cmd)
	Serialize(os, 841)
	Serialize(os, cmd.sign_date)
	Serialize(os, cmd.today_flag)

end

cmd_list["TowerGetInfo"] = 
function(os, cmd)
	Serialize(os, 851)

end

cmd_list["TowerGetInfo_Re"] = 
function(os, cmd)
	Serialize(os, 852)
	Serialize(os, cmd.difficulty)
	Serialize(os, cmd.cur_layer)
	Serialize(os, cmd.all_star)
	Serialize(os, cmd.cur_star)
	Serialize(os, cmd.sweep_layer)
	if cmd.buff==nil then
		Serialize(os, 0)
	else
		Serialize(os, #cmd.buff)
		for i = 1, #cmd.buff do
			Serialize(os, cmd.buff[i])
		end
	end
	if cmd.dead_hero==nil then
		Serialize(os, 0)
	else
		Serialize(os, #cmd.dead_hero)
		for i = 1, #cmd.dead_hero do
			Serialize(os, cmd.dead_hero[i])
		end
	end
	if cmd.injured_hero==nil then
		Serialize(os, 0)
	else
		Serialize(os, #cmd.injured_hero)
		for i = 1, #cmd.injured_hero do
			__SerializeStruct(os, "ShiLianHeroInfo", cmd.injured_hero[i])
		end
	end
	Serialize(os, cmd.yestaday_difficulty)
	Serialize(os, cmd.yestaday_rank)
	Serialize(os, cmd.get_prize_flag)
	Serialize(os, cmd.rank)
	Serialize(os, cmd.history_best_layer)
	Serialize(os, cmd.history_best_star)

end

cmd_list["TowerSelectDifficulty"] = 
function(os, cmd)
	Serialize(os, 853)
	Serialize(os, cmd.difficulty)

end

cmd_list["TowerSelectDifficulty_Re"] = 
function(os, cmd)
	Serialize(os, 854)
	Serialize(os, cmd.retcode)
	Serialize(os, cmd.difficulty)
	Serialize(os, cmd.layer)

end

cmd_list["TowerGetLayerInfo"] = 
function(os, cmd)
	Serialize(os, 855)
	Serialize(os, cmd.layer)

end

cmd_list["TowerGetLayerInfo_Re"] = 
function(os, cmd)
	Serialize(os, 856)
	Serialize(os, cmd.retcode)
	Serialize(os, cmd.layer)
	Serialize(os, cmd.typ)
	if cmd.buff_list==nil then
		Serialize(os, 0)
	else
		Serialize(os, #cmd.buff_list)
		for i = 1, #cmd.buff_list do
			Serialize(os, cmd.buff_list[i])
		end
	end
	if cmd.buff_buy_flag==nil then
		Serialize(os, 0)
	else
		Serialize(os, #cmd.buff_buy_flag)
		for i = 1, #cmd.buff_buy_flag do
			Serialize(os, cmd.buff_buy_flag[i])
		end
	end
	Serialize(os, cmd.army_difficulty)
	if cmd.cur_army==nil then
		Serialize(os, 0)
	else
		Serialize(os, #cmd.cur_army)
		for i = 1, #cmd.cur_army do
			__SerializeStruct(os, "TowerArmyInfoList", cmd.cur_army[i])
		end
	end
	if cmd.cur_army_ids==nil then
		Serialize(os, 0)
	else
		Serialize(os, #cmd.cur_army_ids)
		for i = 1, #cmd.cur_army_ids do
			Serialize(os, cmd.cur_army_ids[i])
		end
	end
	Serialize(os, cmd.sweep_layer)

end

cmd_list["TowerSelectArmyInfo"] = 
function(os, cmd)
	Serialize(os, 857)
	Serialize(os, cmd.difficulty)

end

cmd_list["TowerSelectArmyInfo_Re"] = 
function(os, cmd)
	Serialize(os, 858)
	Serialize(os, cmd.retcode)
	Serialize(os, cmd.difficulty)

end

cmd_list["TowerSetArmyInfo"] = 
function(os, cmd)
	Serialize(os, 859)
	if cmd.army_info==nil then
		Serialize(os, 0)
	else
		Serialize(os, #cmd.army_info)
		for i = 1, #cmd.army_info do
			__SerializeStruct(os, "TowerArmyInfo", cmd.army_info[i])
		end
	end

end

cmd_list["TowerOpenBox"] = 
function(os, cmd)
	Serialize(os, 860)
	Serialize(os, cmd.layer)

end

cmd_list["TowerOpenBox_Re"] = 
function(os, cmd)
	Serialize(os, 861)
	Serialize(os, cmd.retcode)
	Serialize(os, cmd.layer)
	if cmd.item==nil then
		Serialize(os, 0)
	else
		Serialize(os, #cmd.item)
		for i = 1, #cmd.item do
			__SerializeStruct(os, "Item", cmd.item[i])
		end
	end

end

cmd_list["TowerBuyBuff"] = 
function(os, cmd)
	Serialize(os, 862)
	Serialize(os, cmd.layer)
	Serialize(os, cmd.id)
	Serialize(os, cmd.hero_id)

end

cmd_list["TowerBuyBuff_Re"] = 
function(os, cmd)
	Serialize(os, 863)
	Serialize(os, cmd.retcode)
	Serialize(os, cmd.layer)
	Serialize(os, cmd.id)
	Serialize(os, cmd.cur_star)
	if cmd.hero==nil then
		Serialize(os, 0)
	else
		Serialize(os, #cmd.hero)
		for i = 1, #cmd.hero do
			__SerializeStruct(os, "ShiLianHeroInfo", cmd.hero[i])
		end
	end

end

cmd_list["TowerJoinBattle"] = 
function(os, cmd)
	Serialize(os, 864)
	if cmd.hero==nil then
		Serialize(os, 0)
	else
		Serialize(os, #cmd.hero)
		for i = 1, #cmd.hero do
			Serialize(os, cmd.hero[i])
		end
	end

end

cmd_list["TowerJoinBattle_Re"] = 
function(os, cmd)
	Serialize(os, 865)
	Serialize(os, cmd.retcode)
	Serialize(os, cmd.layer)

end

cmd_list["TowerEndBattle"] = 
function(os, cmd)
	Serialize(os, 866)
	Serialize(os, cmd.win_flag)
	if cmd.hero==nil then
		Serialize(os, 0)
	else
		Serialize(os, #cmd.hero)
		for i = 1, #cmd.hero do
			__SerializeStruct(os, "ShiLianHeroInfo", cmd.hero[i])
		end
	end
	if cmd.army==nil then
		Serialize(os, 0)
	else
		Serialize(os, #cmd.army)
		for i = 1, #cmd.army do
			__SerializeStruct(os, "ShiLianHeroInfo", cmd.army[i])
		end
	end
	if cmd.star==nil then
		Serialize(os, 0)
	else
		Serialize(os, #cmd.star)
		for i = 1, #cmd.star do
			__SerializeStruct(os, "Instance_Star_Condition", cmd.star[i])
		end
	end
	if cmd.operations==nil then
		Serialize(os, 0)
	else
		Serialize(os, #cmd.operations)
		for i = 1, #cmd.operations do
			__SerializeStruct(os, "PVEOperation", cmd.operations[i])
		end
	end

end

cmd_list["TowerEndBattle_Re"] = 
function(os, cmd)
	Serialize(os, 867)
	Serialize(os, cmd.retcode)
	Serialize(os, cmd.win_flag)
	if cmd.hero==nil then
		Serialize(os, 0)
	else
		Serialize(os, #cmd.hero)
		for i = 1, #cmd.hero do
			__SerializeStruct(os, "ShiLianHeroInfo", cmd.hero[i])
		end
	end
	if cmd.army==nil then
		Serialize(os, 0)
	else
		Serialize(os, #cmd.army)
		for i = 1, #cmd.army do
			__SerializeStruct(os, "ShiLianHeroInfo", cmd.army[i])
		end
	end
	Serialize(os, cmd.all_star)
	Serialize(os, cmd.cur_star)
	Serialize(os, cmd.history_best_layer)
	Serialize(os, cmd.history_best_star)

end

cmd_list["TowerGetRankPrize"] = 
function(os, cmd)
	Serialize(os, 868)

end

cmd_list["TowerGetRankPrize_Re"] = 
function(os, cmd)
	Serialize(os, 869)
	Serialize(os, cmd.retcode)
	__SerializeStruct(os, "TemporaryBackPackData", cmd.item)
	Serialize(os, cmd.yestaday_rank)
	Serialize(os, cmd.yestaday_difficulty)
	Serialize(os, cmd.get_prize_flag)

end

cmd_list["TowerUpdateRoleInfo"] = 
function(os, cmd)
	Serialize(os, 870)
	Serialize(os, cmd.difficulty)

end

cmd_list["TowerSweep"] = 
function(os, cmd)
	Serialize(os, 871)
	Serialize(os, cmd.layer)
	Serialize(os, cmd.difficulty)

end

cmd_list["TowerSweep_Re"] = 
function(os, cmd)
	Serialize(os, 872)
	Serialize(os, cmd.retcode)
	Serialize(os, cmd.layer)
	if cmd.hero==nil then
		Serialize(os, 0)
	else
		Serialize(os, #cmd.hero)
		for i = 1, #cmd.hero do
			__SerializeStruct(os, "ShiLianHeroInfo", cmd.hero[i])
		end
	end
	Serialize(os, cmd.all_star)
	Serialize(os, cmd.cur_star)
	Serialize(os, cmd.cur_rank)
	Serialize(os, cmd.difficulty)

end

cmd_list["DaTiGetInfo"] = 
function(os, cmd)
	Serialize(os, 900)

end

cmd_list["DaTiGetInfo_Re"] = 
function(os, cmd)
	Serialize(os, 901)
	Serialize(os, cmd.cur_num)
	Serialize(os, cmd.cur_right_num)
	Serialize(os, cmd.today_reward)
	Serialize(os, cmd.exp)
	Serialize(os, cmd.yuanbao)
	Serialize(os, cmd.use_time)
	Serialize(os, cmd.history_right_num)
	Serialize(os, cmd.history_use_time)

end

cmd_list["DaTiUpdateInfo"] = 
function(os, cmd)
	Serialize(os, 902)
	Serialize(os, cmd.cur_num)
	Serialize(os, cmd.cur_right_num)
	Serialize(os, cmd.today_reward)
	Serialize(os, cmd.exp)
	Serialize(os, cmd.yuanbao)
	Serialize(os, cmd.use_time)
	Serialize(os, cmd.history_right_num)
	Serialize(os, cmd.history_use_time)

end

cmd_list["DaTiAnswer"] = 
function(os, cmd)
	Serialize(os, 903)
	Serialize(os, cmd.num)
	Serialize(os, cmd.right_flag)
	Serialize(os, cmd.use_time)

end

cmd_list["DaTiAnswer_Re"] = 
function(os, cmd)
	Serialize(os, 904)
	Serialize(os, cmd.retcode)
	Serialize(os, cmd.num)
	Serialize(os, cmd.right_flag)
	Serialize(os, cmd.exp)
	if cmd.item==nil then
		Serialize(os, 0)
	else
		Serialize(os, #cmd.item)
		for i = 1, #cmd.item do
			__SerializeStruct(os, "Item", cmd.item[i])
		end
	end

end

cmd_list["DaTiOpenBox"] = 
function(os, cmd)
	Serialize(os, 905)

end

cmd_list["DaTiOpenBox_Re"] = 
function(os, cmd)
	Serialize(os, 906)
	Serialize(os, cmd.retcode)
	Serialize(os, cmd.exp)
	if cmd.item==nil then
		Serialize(os, 0)
	else
		Serialize(os, #cmd.item)
		for i = 1, #cmd.item do
			__SerializeStruct(os, "Item", cmd.item[i])
		end
	end

end

cmd_list["DaTiUseTime"] = 
function(os, cmd)
	Serialize(os, 907)
	Serialize(os, cmd.use_time)

end

cmd_list["SkinEquip"] = 
function(os, cmd)
	Serialize(os, 910)
	Serialize(os, cmd.skinid)

end

cmd_list["SkinEquip_Re"] = 
function(os, cmd)
	Serialize(os, 911)
	Serialize(os, cmd.retcode)
	Serialize(os, cmd.skinid)

end

cmd_list["SkinBuy"] = 
function(os, cmd)
	Serialize(os, 912)
	Serialize(os, cmd.typ)
	Serialize(os, cmd.skinid)

end

cmd_list["SkinBuy_Re"] = 
function(os, cmd)
	Serialize(os, 913)
	Serialize(os, cmd.retcode)
	Serialize(os, cmd.typ)
	Serialize(os, cmd.skinid)

end

cmd_list["SkinTimeOut"] = 
function(os, cmd)
	Serialize(os, 914)
	Serialize(os, cmd.skinid)

end

cmd_list["SkinTimeOut_Re"] = 
function(os, cmd)
	Serialize(os, 915)
	Serialize(os, cmd.retcode)
	Serialize(os, cmd.skinid)

end

cmd_list["SkinUpdateInfo"] = 
function(os, cmd)
	Serialize(os, 916)
	Serialize(os, cmd.addflag)
	Serialize(os, cmd.skinid)
	Serialize(os, cmd.time)
	__SerializeStruct(os, "Item", cmd.item)

end

cmd_list["WeaponMakeGetInfo"] = 
function(os, cmd)
	Serialize(os, 920)

end

cmd_list["WeaponMakeGetInfo_Re"] = 
function(os, cmd)
	Serialize(os, 921)
	Serialize(os, cmd.num)
	Serialize(os, cmd.time)
	Serialize(os, cmd.level)
	Serialize(os, cmd.exp)
	if cmd.weapon_active==nil then
		Serialize(os, 0)
	else
		Serialize(os, #cmd.weapon_active)
		for i = 1, #cmd.weapon_active do
			Serialize(os, cmd.weapon_active[i])
		end
	end
	if cmd.weapon_not_active==nil then
		Serialize(os, 0)
	else
		Serialize(os, #cmd.weapon_not_active)
		for i = 1, #cmd.weapon_not_active do
			Serialize(os, cmd.weapon_not_active[i])
		end
	end

end

cmd_list["WeaponMake"] = 
function(os, cmd)
	Serialize(os, 922)
	Serialize(os, cmd.typ)
	Serialize(os, cmd.cost_type)
	Serialize(os, cmd.lottery_id)

end

cmd_list["WeaponMake_Re"] = 
function(os, cmd)
	Serialize(os, 923)
	Serialize(os, cmd.retcode)
	Serialize(os, cmd.typ)
	Serialize(os, cmd.cost_type)
	Serialize(os, cmd.lottery_id)
	Serialize(os, cmd.num)
	if cmd.item==nil then
		Serialize(os, 0)
	else
		Serialize(os, #cmd.item)
		for i = 1, #cmd.item do
			__SerializeStruct(os, "Item", cmd.item[i])
		end
	end

end

cmd_list["WeaponMakeGetStone"] = 
function(os, cmd)
	Serialize(os, 924)

end

cmd_list["WeaponMakeGetStone_Re"] = 
function(os, cmd)
	Serialize(os, 925)
	Serialize(os, cmd.retcode)
	Serialize(os, cmd.time)

end

cmd_list["WeaponMakeActive"] = 
function(os, cmd)
	Serialize(os, 926)
	Serialize(os, cmd.item_id)

end

cmd_list["WeaponMakeActive_Re"] = 
function(os, cmd)
	Serialize(os, 927)
	Serialize(os, cmd.retcode)
	Serialize(os, cmd.item_id)
	Serialize(os, cmd.exp)

end

cmd_list["WeaponMakeLevelUp"] = 
function(os, cmd)
	Serialize(os, 928)

end

cmd_list["WeaponMakeLevelUp_Re"] = 
function(os, cmd)
	Serialize(os, 929)
	Serialize(os, cmd.level)

end

cmd_list["WeaponForge"] = 
function(os, cmd)
	Serialize(os, 931)
	Serialize(os, cmd.typ)

end

cmd_list["WeaponForge_Re"] = 
function(os, cmd)
	Serialize(os, 932)
	Serialize(os, cmd.retcode)
	Serialize(os, cmd.typ)
	__SerializeStruct(os, "WeaponItem", cmd.weapon_info)

end

cmd_list["WeaponResetSkill"] = 
function(os, cmd)
	Serialize(os, 933)
	Serialize(os, cmd.typ)

end

cmd_list["WeaponResetSkill_Re"] = 
function(os, cmd)
	Serialize(os, 934)
	Serialize(os, cmd.retcode)
	Serialize(os, cmd.typ)
	Serialize(os, cmd.reset_time)
	if cmd.skill_pro==nil then
		Serialize(os, 0)
	else
		Serialize(os, #cmd.skill_pro)
		for i = 1, #cmd.skill_pro do
			__SerializeStruct(os, "WeaponSkill", cmd.skill_pro[i])
		end
	end

end

cmd_list["WeaponForgeGetInfo"] = 
function(os, cmd)
	Serialize(os, 935)

end

cmd_list["WeaponForgeGetInfo_Re"] = 
function(os, cmd)
	Serialize(os, 936)
	Serialize(os, cmd.today)
	Serialize(os, cmd.typ)
	Serialize(os, cmd.reset_time)
	__SerializeStruct(os, "WeaponItem", cmd.weapon_info)

end

cmd_list["TestFloat"] = 
function(os, cmd)
	Serialize(os, 941)
	Serialize(os, cmd.seed)
	Serialize(os, cmd.count)

end

cmd_list["TestFloat_Re"] = 
function(os, cmd)
	Serialize(os, 942)
	Serialize(os, cmd.seed)
	Serialize(os, cmd.count)
	Serialize(os, cmd.result)

end

cmd_list["MilitaryGetInfo"] = 
function(os, cmd)
	Serialize(os, 950)

end

cmd_list["MilitaryGetInfo_Re"] = 
function(os, cmd)
	Serialize(os, 951)
	Serialize(os, cmd.stage_id)
	Serialize(os, cmd.stage_difficult)
	Serialize(os, cmd.horse_id)
	if cmd.stage_info==nil then
		Serialize(os, 0)
	else
		Serialize(os, #cmd.stage_info)
		for i = 1, #cmd.stage_info do
			__SerializeStruct(os, "MilitaryStageInfo", cmd.stage_info[i])
		end
	end

end

cmd_list["MilitarySweep"] = 
function(os, cmd)
	Serialize(os, 952)
	Serialize(os, cmd.stage_id)

end

cmd_list["MilitarySweep_Re"] = 
function(os, cmd)
	Serialize(os, 953)
	Serialize(os, cmd.retcode)
	Serialize(os, cmd.stage_id)
	Serialize(os, cmd.cd)
	Serialize(os, cmd.times)
	if cmd.item==nil then
		Serialize(os, 0)
	else
		Serialize(os, #cmd.item)
		for i = 1, #cmd.item do
			__SerializeStruct(os, "Item", cmd.item[i])
		end
	end
	Serialize(os, cmd.exp)

end

cmd_list["MilitaryJoinBattle"] = 
function(os, cmd)
	Serialize(os, 954)
	Serialize(os, cmd.hero_id)
	Serialize(os, cmd.stage_id)
	Serialize(os, cmd.difficult)

end

cmd_list["MilitaryJoinBattle_Re"] = 
function(os, cmd)
	Serialize(os, 955)
	Serialize(os, cmd.retcode)
	Serialize(os, cmd.hero_id)
	Serialize(os, cmd.stage_id)
	Serialize(os, cmd.difficult)

end

cmd_list["MilitaryEndBattle"] = 
function(os, cmd)
	Serialize(os, 956)
	Serialize(os, cmd.reward_param)
	Serialize(os, cmd.hurt)
	if cmd.operations==nil then
		Serialize(os, 0)
	else
		Serialize(os, #cmd.operations)
		for i = 1, #cmd.operations do
			__SerializeStruct(os, "PVEOperation", cmd.operations[i])
		end
	end

end

cmd_list["MilitaryEndBattle_Re"] = 
function(os, cmd)
	Serialize(os, 957)
	Serialize(os, cmd.retcode)
	Serialize(os, cmd.reward_param)
	Serialize(os, cmd.hurt)
	Serialize(os, cmd.record)
	Serialize(os, cmd.stage_id)
	Serialize(os, cmd.difficult)
	if cmd.item==nil then
		Serialize(os, 0)
	else
		Serialize(os, #cmd.item)
		for i = 1, #cmd.item do
			__SerializeStruct(os, "Item", cmd.item[i])
		end
	end
	Serialize(os, cmd.exp)

end

cmd_list["MilitaryUpdateInfo"] = 
function(os, cmd)
	Serialize(os, 958)
	Serialize(os, cmd.stage_id)
	Serialize(os, cmd.stage_difficult)
	if cmd.stage_info==nil then
		Serialize(os, 0)
	else
		Serialize(os, #cmd.stage_info)
		for i = 1, #cmd.stage_info do
			__SerializeStruct(os, "MilitaryStageInfo", cmd.stage_info[i])
		end
	end

end

cmd_list["HotPvpVideoList"] = 
function(os, cmd)
	Serialize(os, 1001)
	Serialize(os, cmd.seq_max)

end

cmd_list["HotPvpVideoList_Re"] = 
function(os, cmd)
	Serialize(os, 1002)
	if cmd.list==nil then
		Serialize(os, 0)
	else
		Serialize(os, #cmd.list)
		for i = 1, #cmd.list do
			__SerializeStruct(os, "HotPvpVideo", cmd.list[i])
		end
	end

end

cmd_list["HotPvpVideoGet"] = 
function(os, cmd)
	Serialize(os, 1003)
	Serialize(os, cmd.seq)

end

cmd_list["ZhanliGetInfo"] = 
function(os, cmd)
	Serialize(os, 1020)

end

cmd_list["ZhanliGetInfo_Re"] = 
function(os, cmd)
	Serialize(os, 1021)
	Serialize(os, cmd.zhanli)
	if cmd.members==nil then
		Serialize(os, 0)
	else
		Serialize(os, #cmd.members)
		for i = 1, #cmd.members do
			__SerializeStruct(os, "TopListData", cmd.members[i])
		end
	end

end

cmd_list["GetActiveCodeRward"] = 
function(os, cmd)
	Serialize(os, 1030)
	Serialize(os, cmd.code)

end

cmd_list["GetActiveCodeRward_Re"] = 
function(os, cmd)
	Serialize(os, 1031)
	Serialize(os, cmd.retcode)
	if cmd.item==nil then
		Serialize(os, 0)
	else
		Serialize(os, #cmd.item)
		for i = 1, #cmd.item do
			__SerializeStruct(os, "Item", cmd.item[i])
		end
	end

end

cmd_list["PveArenaUpdateRefreshTime"] = 
function(os, cmd)
	Serialize(os, 1040)
	Serialize(os, cmd.pve_refreshtime)

end

cmd_list["ChangeRoleName"] = 
function(os, cmd)
	Serialize(os, 19998)
	Serialize(os, cmd.name)

end

cmd_list["ChangeRoleName_Re"] = 
function(os, cmd)
	Serialize(os, 19999)
	Serialize(os, cmd.retcode)
	Serialize(os, cmd.name)

end

cmd_list["TopListGet"] = 
function(os, cmd)
	Serialize(os, 20000)
	Serialize(os, cmd.top_type)
	Serialize(os, cmd.top_flag)

end

cmd_list["TopListGet_Re"] = 
function(os, cmd)
	Serialize(os, 20001)
	Serialize(os, cmd.top_type)
	Serialize(os, cmd.top_flag)
	Serialize(os, cmd.retcode)
	if cmd.members==nil then
		Serialize(os, 0)
	else
		Serialize(os, #cmd.members)
		for i = 1, #cmd.members do
			__SerializeStruct(os, "TopListData", cmd.members[i])
		end
	end
	if cmd.reward_info==nil then
		Serialize(os, 0)
	else
		Serialize(os, #cmd.reward_info)
		for i = 1, #cmd.reward_info do
			Serialize(os, cmd.reward_info[i])
		end
	end

end

cmd_list["GMcmd_Bull"] = 
function(os, cmd)
	Serialize(os, 99996)
	Serialize(os, cmd.text)

end

cmd_list["GMCommand"] = 
function(os, cmd)
	Serialize(os, 99997)
	Serialize(os, cmd.gm_id)
	Serialize(os, cmd.typ)
	Serialize(os, cmd.arg1)
	Serialize(os, cmd.arg2)
	Serialize(os, cmd.arg3)
	Serialize(os, cmd.arg4)

end

cmd_list["GMCommand_Re"] = 
function(os, cmd)
	Serialize(os, 99998)
	Serialize(os, cmd.retcode)
	Serialize(os, cmd.typ)
	Serialize(os, cmd.arg1)
	Serialize(os, cmd.arg2)
	Serialize(os, cmd.arg3)
	Serialize(os, cmd.arg4)

end

cmd_list["DebugCommand"] = 
function(os, cmd)
	Serialize(os, 99999)
	Serialize(os, cmd.typ)
	Serialize(os, cmd.count1)
	Serialize(os, cmd.count2)
	Serialize(os, cmd.count3)
	Serialize(os, cmd.count4)

end

cmd_list["PrivateChat"] = 
function(os, cmd)
	Serialize(os, 10003)
	__SerializeStruct(os, "RoleBrief", cmd.src)
	__SerializeStruct(os, "RoleBrief", cmd.dest)
	Serialize(os, cmd.dest_id)
	Serialize(os, cmd.text_content)
	Serialize(os, cmd.speech_content)
	Serialize(os, cmd.time)
	Serialize(os, cmd.typ)

end

cmd_list["PublicChat"] = 
function(os, cmd)
	Serialize(os, 10004)
	__SerializeStruct(os, "RoleBrief", cmd.src)
	Serialize(os, cmd.text_content)
	Serialize(os, cmd.speech_content)
	Serialize(os, cmd.time)
	Serialize(os, cmd.typ)
	Serialize(os, cmd.channel)

end

cmd_list["RoleForbidTalk"] = 
function(os, cmd)
	Serialize(os, 10005)
	Serialize(os, cmd.begintime)
	Serialize(os, cmd.time)
	Serialize(os, cmd.nitifytouser)

end

cmd_list["ListFriends"] = 
function(os, cmd)
	Serialize(os, 10006)

end

cmd_list["ListFriends_Re"] = 
function(os, cmd)
	Serialize(os, 10007)
	if cmd.friends==nil then
		Serialize(os, 0)
	else
		Serialize(os, #cmd.friends)
		for i = 1, #cmd.friends do
			__SerializeStruct(os, "Friend", cmd.friends[i])
		end
	end
	if cmd.requests==nil then
		Serialize(os, 0)
	else
		Serialize(os, #cmd.requests)
		for i = 1, #cmd.requests do
			__SerializeStruct(os, "Friend", cmd.requests[i])
		end
	end
	if cmd.black_list==nil then
		Serialize(os, 0)
	else
		Serialize(os, #cmd.black_list)
		for i = 1, #cmd.black_list do
			__SerializeStruct(os, "RoleBrief", cmd.black_list[i])
		end
	end

end

cmd_list["FriendRequest"] = 
function(os, cmd)
	Serialize(os, 10008)
	Serialize(os, cmd.dest_id)

end

cmd_list["FriendRequest_Re"] = 
function(os, cmd)
	Serialize(os, 10009)
	Serialize(os, cmd.retcode)
	Serialize(os, cmd.dest_id)

end

cmd_list["FriendAddRequest"] = 
function(os, cmd)
	Serialize(os, 10010)
	__SerializeStruct(os, "Friend", cmd.requests)

end

cmd_list["FriendReply"] = 
function(os, cmd)
	Serialize(os, 10011)
	Serialize(os, cmd.src_id)
	Serialize(os, cmd.accept)

end

cmd_list["FriendReply_Re"] = 
function(os, cmd)
	Serialize(os, 10012)
	Serialize(os, cmd.retcode)
	Serialize(os, cmd.src_id)
	Serialize(os, cmd.accept)

end

cmd_list["NewFriend"] = 
function(os, cmd)
	Serialize(os, 10013)
	__SerializeStruct(os, "Friend", cmd.friend)

end

cmd_list["RemoveFriend"] = 
function(os, cmd)
	Serialize(os, 10014)
	Serialize(os, cmd.dest_id)

end

cmd_list["RemoveFriend_Re"] = 
function(os, cmd)
	Serialize(os, 10015)
	Serialize(os, cmd.retcode)
	Serialize(os, cmd.dest_id)

end

cmd_list["FriendDelRequest"] = 
function(os, cmd)
	Serialize(os, 10016)
	Serialize(os, cmd.role_id)

end

cmd_list["FriendUpdateInfo"] = 
function(os, cmd)
	Serialize(os, 10017)
	__SerializeStruct(os, "Friend", cmd.friend_info)

end

cmd_list["MafiaGet"] = 
function(os, cmd)
	Serialize(os, 10101)

end

cmd_list["MafiaGet_Re"] = 
function(os, cmd)
	Serialize(os, 10102)
	Serialize(os, cmd.retcode)
	__SerializeStruct(os, "Mafia", cmd.mafia)

end

cmd_list["MafiaCreate"] = 
function(os, cmd)
	Serialize(os, 10103)
	Serialize(os, cmd.name)
	Serialize(os, cmd.flag)

end

cmd_list["MafiaCreate_Re"] = 
function(os, cmd)
	Serialize(os, 10104)
	Serialize(os, cmd.retcode)
	__SerializeStruct(os, "Mafia", cmd.mafia)

end

cmd_list["MafiaList"] = 
function(os, cmd)
	Serialize(os, 10105)

end

cmd_list["MafiaList_Re"] = 
function(os, cmd)
	Serialize(os, 10106)
	Serialize(os, cmd.retcode)
	if cmd.mafia_info==nil then
		Serialize(os, 0)
	else
		Serialize(os, #cmd.mafia_info)
		for i = 1, #cmd.mafia_info do
			__SerializeStruct(os, "MafiaBrief", cmd.mafia_info[i])
		end
	end

end

cmd_list["MafiaGetSelfInfo"] = 
function(os, cmd)
	Serialize(os, 10107)

end

cmd_list["MafiaGetSelfInfo_Re"] = 
function(os, cmd)
	Serialize(os, 10108)
	__SerializeStruct(os, "MafiaSelfInfo", cmd.mafia_info)

end

cmd_list["MafiaUpdateSelfInfo"] = 
function(os, cmd)
	Serialize(os, 10109)
	__SerializeStruct(os, "MafiaSelfInfo", cmd.mafia_info)

end

cmd_list["MafiaApply"] = 
function(os, cmd)
	Serialize(os, 10110)
	Serialize(os, cmd.id)

end

cmd_list["MafiaApply_Re"] = 
function(os, cmd)
	Serialize(os, 10111)
	Serialize(os, cmd.retcode)
	Serialize(os, cmd.id)

end

cmd_list["MafiaQuit"] = 
function(os, cmd)
	Serialize(os, 10112)

end

cmd_list["MafiaQuit_Re"] = 
function(os, cmd)
	Serialize(os, 10113)
	Serialize(os, cmd.retcode)

end

cmd_list["MafiaGetApplyList"] = 
function(os, cmd)
	Serialize(os, 10114)

end

cmd_list["MafiaGetApplyList_Re"] = 
function(os, cmd)
	Serialize(os, 10115)
	Serialize(os, cmd.retcode)
	if cmd.apply_info==nil then
		Serialize(os, 0)
	else
		Serialize(os, #cmd.apply_info)
		for i = 1, #cmd.apply_info do
			__SerializeStruct(os, "MafiaApplyRoleInfo", cmd.apply_info[i])
		end
	end

end

cmd_list["MafiaOperateApplyList"] = 
function(os, cmd)
	Serialize(os, 10116)
	Serialize(os, cmd.accept)
	Serialize(os, cmd.role_id)
	Serialize(os, cmd.mafia_id)

end

cmd_list["MafiaOperateApplyList_Re"] = 
function(os, cmd)
	Serialize(os, 10117)
	Serialize(os, cmd.retcode)
	Serialize(os, cmd.accept)
	Serialize(os, cmd.role_id)
	Serialize(os, cmd.mafia_id)

end

cmd_list["MafiaSetLevelLimit"] = 
function(os, cmd)
	Serialize(os, 10118)
	Serialize(os, cmd.level)
	Serialize(os, cmd.need_approval)

end

cmd_list["MafiaSetLevelLimit_Re"] = 
function(os, cmd)
	Serialize(os, 10119)
	Serialize(os, cmd.retcode)
	Serialize(os, cmd.level)
	Serialize(os, cmd.need_approval)

end

cmd_list["MafiaSetAnnounce"] = 
function(os, cmd)
	Serialize(os, 10120)
	Serialize(os, cmd.announce)

end

cmd_list["MafiaSetAnnounce_Re"] = 
function(os, cmd)
	Serialize(os, 10121)
	Serialize(os, cmd.retcode)
	Serialize(os, cmd.announce)

end

cmd_list["MafiaKickout"] = 
function(os, cmd)
	Serialize(os, 10122)
	Serialize(os, cmd.role_id)

end

cmd_list["MafiaKickout_Re"] = 
function(os, cmd)
	Serialize(os, 10123)
	Serialize(os, cmd.retcode)
	Serialize(os, cmd.role_id)

end

cmd_list["MafiaUpdateApplyList"] = 
function(os, cmd)
	Serialize(os, 10124)
	Serialize(os, cmd.del_flag)
	__SerializeStruct(os, "MafiaApplyRoleInfo", cmd.apply_info)

end

cmd_list["MafiaUpdateMafiaInfo"] = 
function(os, cmd)
	Serialize(os, 10125)
	__SerializeStruct(os, "MafiaInterfaceInfo", cmd.info)

end

cmd_list["MafiaUpdateExp"] = 
function(os, cmd)
	Serialize(os, 10126)
	Serialize(os, cmd.exp)
	Serialize(os, cmd.level)
	Serialize(os, cmd.jisi)

end

cmd_list["MafiaUpdateMemberInfo"] = 
function(os, cmd)
	Serialize(os, 10127)
	Serialize(os, cmd.flag)
	__SerializeStruct(os, "MafiaMember", cmd.member)

end

cmd_list["MafiaUpdateNoticeInfo"] = 
function(os, cmd)
	Serialize(os, 10128)
	__SerializeStruct(os, "MafiaNoticeInfo", cmd.notice_info)

end

cmd_list["MafiaChangeMenberPosition"] = 
function(os, cmd)
	Serialize(os, 10129)
	Serialize(os, cmd.position)
	Serialize(os, cmd.role_id)

end

cmd_list["MafiaChangeMenberPosition_Re"] = 
function(os, cmd)
	Serialize(os, 10130)
	Serialize(os, cmd.retcode)
	Serialize(os, cmd.position)
	Serialize(os, cmd.role_id)

end

cmd_list["MafiaShanRang"] = 
function(os, cmd)
	Serialize(os, 10131)
	Serialize(os, cmd.role_id)

end

cmd_list["MafiaShanRang_Re"] = 
function(os, cmd)
	Serialize(os, 10132)
	Serialize(os, cmd.retcode)
	Serialize(os, cmd.role_id)

end

cmd_list["MafiaJiSi"] = 
function(os, cmd)
	Serialize(os, 10133)
	Serialize(os, cmd.jisi_typ)

end

cmd_list["MafiaJiSi_Re"] = 
function(os, cmd)
	Serialize(os, 10134)
	Serialize(os, cmd.jisi_typ)
	Serialize(os, cmd.retcode)

end

cmd_list["MafiaDeclaration"] = 
function(os, cmd)
	Serialize(os, 10135)
	Serialize(os, cmd.declaration)
	Serialize(os, cmd.broadcast_flag)

end

cmd_list["MafiaDeclaration_Re"] = 
function(os, cmd)
	Serialize(os, 10136)
	Serialize(os, cmd.retcode)
	Serialize(os, cmd.declaration)
	Serialize(os, cmd.broadcast_flag)

end

cmd_list["MafiaChangeName"] = 
function(os, cmd)
	Serialize(os, 10137)
	Serialize(os, cmd.name)

end

cmd_list["MafiaChangeName_Re"] = 
function(os, cmd)
	Serialize(os, 10138)
	Serialize(os, cmd.retcode)
	Serialize(os, cmd.name)

end

cmd_list["MafiaSeeInfo"] = 
function(os, cmd)
	Serialize(os, 10139)
	Serialize(os, cmd.mafia_id)

end

cmd_list["MafiaSeeInfo_Re"] = 
function(os, cmd)
	Serialize(os, 10140)
	Serialize(os, cmd.retcode)
	__SerializeStruct(os, "MafiaBrief", cmd.mafia_info)

end

cmd_list["MafiaBangZhuSendMail"] = 
function(os, cmd)
	Serialize(os, 10141)
	Serialize(os, cmd.subject)
	Serialize(os, cmd.context)

end

cmd_list["MafiaBangZhuSendMail_Re"] = 
function(os, cmd)
	Serialize(os, 10142)
	Serialize(os, cmd.retcode)
	Serialize(os, cmd.subject)
	Serialize(os, cmd.context)

end

cmd_list["MafiaDeclarationBroadCast"] = 
function(os, cmd)
	Serialize(os, 10143)
	Serialize(os, cmd.mafia_id)
	Serialize(os, cmd.mafia_name)
	Serialize(os, cmd.info)
	Serialize(os, cmd.time)

end

cmd_list["Ping"] = 
function(os, cmd)
	Serialize(os, 10201)
	Serialize(os, cmd.client_send_time)

end

cmd_list["Ping_Re"] = 
function(os, cmd)
	Serialize(os, 10202)
	Serialize(os, cmd.client_send_time)

end

cmd_list["UDPPing"] = 
function(os, cmd)
	Serialize(os, 10203)
	Serialize(os, cmd.client_send_time)

end

cmd_list["UDPPing_Re"] = 
function(os, cmd)
	Serialize(os, 10204)
	Serialize(os, cmd.client_send_time)

end

cmd_list["UDPClientTimeRequest"] = 
function(os, cmd)
	Serialize(os, 10205)

end

cmd_list["UDPClientTimeRequest_Re"] = 
function(os, cmd)
	Serialize(os, 10206)
	Serialize(os, cmd.local_time)
	Serialize(os, cmd.server_time)

end


