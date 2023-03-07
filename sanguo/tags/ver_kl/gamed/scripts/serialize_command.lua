--DONT CHANGE ME!

function SerializeCommand(cmd)
	local os = {}

	if false then
		--never to here
	elseif cmd.__type__ == "EnterInstance" then
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
	elseif cmd.__type__ == "EnterInstance_Re" then
		Serialize(os, 8)
		Serialize(os, cmd.retcode)
		Serialize(os, cmd.inst_tid)
		Serialize(os, cmd.seed)
	elseif cmd.__type__ == "CompleteInstance" then
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
	elseif cmd.__type__ == "CompleteInstance_Re" then
		Serialize(os, 10)
		Serialize(os, cmd.retcode)
		Serialize(os, cmd.inst_tid)
		Serialize(os, cmd.score)
		Serialize(os, cmd.star)
		__SerializeStruct(os, "SweepInstanceData", cmd.rewards)
		Serialize(os, cmd.first_flag)
	elseif cmd.__type__ == "SyncRoleInfo" then
		Serialize(os, 11)
	elseif cmd.__type__ == "OPStat" then
		Serialize(os, 12)
		Serialize(os, cmd.opset_count)
		Serialize(os, cmd.op_count)
	elseif cmd.__type__ == "FriendRequest" then
		Serialize(os, 10008)
		Serialize(os, cmd.dest_id)
		__SerializeStruct(os, "Friend", cmd.src)
	elseif cmd.__type__ == "TopListGet" then
		Serialize(os, 20000)
		Serialize(os, cmd.top_type)
		Serialize(os, cmd.top_flag)
	elseif cmd.__type__ == "TopListGet_Re" then
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
	elseif cmd.__type__ == "FriendReply" then
		Serialize(os, 10009)
		Serialize(os, cmd.src_id)
		Serialize(os, cmd.accept)
	elseif cmd.__type__ == "MafiaCreate" then
		Serialize(os, 10103)
		Serialize(os, cmd.name)
		Serialize(os, cmd.flag)
	elseif cmd.__type__ == "PVPInvite" then
		Serialize(os, 10301)
		Serialize(os, cmd.dest_id)
		__SerializeStruct(os, "RoleBrief", cmd.src)
		Serialize(os, cmd.mode)
	elseif cmd.__type__ == "PVPReply" then
		Serialize(os, 10302)
		Serialize(os, cmd.src_id)
		Serialize(os, cmd.accept)
	elseif cmd.__type__ == "PVPPrepare" then
		Serialize(os, 10303)
		Serialize(os, cmd.id)
		__SerializeStruct(os, "RoleBrief", cmd.player1)
		__SerializeStruct(os, "RoleBrief", cmd.player2)
		Serialize(os, cmd.N)
		Serialize(os, cmd.mode)
		Serialize(os, cmd.p2p_magic)
		Serialize(os, cmd.p2p_peer_ip)
		Serialize(os, cmd.p2p_peer_port)
	elseif cmd.__type__ == "PVPReady" then
		Serialize(os, 10304)
	elseif cmd.__type__ == "PVPBegin" then
		Serialize(os, 10305)
		Serialize(os, cmd.fight_start_time)
		Serialize(os, cmd.ip)
		Serialize(os, cmd.port)
	elseif cmd.__type__ == "PVPOperation" then
		Serialize(os, 10306)
		Serialize(os, cmd.client_tick)
		Serialize(os, cmd.op)
		Serialize(os, cmd.crc)
	elseif cmd.__type__ == "PVPOperationSet" then
		Serialize(os, 10307)
		Serialize(os, cmd.client_tick)
		Serialize(os, cmd.player1_op)
		Serialize(os, cmd.player2_op)
	elseif cmd.__type__ == "PVPEnd" then
		Serialize(os, 10308)
		Serialize(os, cmd.result)
		Serialize(os, cmd.typ)
		Serialize(os, cmd.pvp_typ)
		Serialize(os, cmd.star)
		Serialize(os, cmd.win_count)
	elseif cmd.__type__ == "PVPError" then
		Serialize(os, 10309)
		Serialize(os, cmd.result)
	elseif cmd.__type__ == "PVPPeerLatency" then
		Serialize(os, 10310)
		Serialize(os, cmd.latency)
	elseif cmd.__type__ == "NewFriend" then
		Serialize(os, 10010)
		__SerializeStruct(os, "Friend", cmd.friend)
	elseif cmd.__type__ == "MafiaGet" then
		Serialize(os, 10101)
	elseif cmd.__type__ == "SweepInstance" then
		Serialize(os, 100)
		Serialize(os, cmd.instance)
		Serialize(os, cmd.count)
	elseif cmd.__type__ == "SweepInstance_Re" then
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
	elseif cmd.__type__ == "GetBackPack" then
		Serialize(os, 102)
	elseif cmd.__type__ == "GetBackPack_Re" then
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
	elseif cmd.__type__ == "GetInstance" then
		Serialize(os, 104)
	elseif cmd.__type__ == "GetInstance_Re" then
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
	elseif cmd.__type__ == "Role_Mon_Exp" then
		Serialize(os, 106)
		Serialize(os, cmd.level)
		Serialize(os, cmd.exp)
		Serialize(os, cmd.money)
		Serialize(os, cmd.yuanbao)
		Serialize(os, cmd.vp)
	elseif cmd.__type__ == "BuyVp" then
		Serialize(os, 107)
	elseif cmd.__type__ == "BuyVp_Re" then
		Serialize(os, 108)
		Serialize(os, cmd.retcode)
		Serialize(os, cmd.num)
	elseif cmd.__type__ == "BuyInstanceCount" then
		Serialize(os, 109)
		Serialize(os, cmd.inst_tid)
	elseif cmd.__type__ == "BuyInstanceCount_Re" then
		Serialize(os, 110)
		Serialize(os, cmd.retcode)
	elseif cmd.__type__ == "RoleCommonLimit" then
		Serialize(os, 111)
		Serialize(os, cmd.tid)
		Serialize(os, cmd.count)
	elseif cmd.__type__ == "ChongZhi_Re" then
		Serialize(os, 114)
		Serialize(os, cmd.chongzhi)
	elseif cmd.__type__ == "TaskFinish" then
		Serialize(os, 115)
		Serialize(os, cmd.task_id)
	elseif cmd.__type__ == "TaskFinish_Re" then
		Serialize(os, 116)
		Serialize(os, cmd.retcode)
		Serialize(os, cmd.task_id)
		__SerializeStruct(os, "SweepInstanceData", cmd.rewards)
	elseif cmd.__type__ == "Task_Condition" then
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
	elseif cmd.__type__ == "Client_User_Define" then
		Serialize(os, 118)
		Serialize(os, cmd.user_key)
		Serialize(os, cmd.user_value)
	elseif cmd.__type__ == "BuyHero" then
		Serialize(os, 119)
		Serialize(os, cmd.tid)
		Serialize(os, cmd.typ)
	elseif cmd.__type__ == "BuyHero_Re" then
		Serialize(os, 120)
		Serialize(os, cmd.retcode)
	elseif cmd.__type__ == "HeroList_Re" then
		Serialize(os, 121)
		__SerializeStruct(os, "RoleHero", cmd.hero_hall)
	elseif cmd.__type__ == "UseItem" then
		Serialize(os, 122)
		Serialize(os, cmd.tid)
		Serialize(os, cmd.hero_id)
		Serialize(os, cmd.count)
	elseif cmd.__type__ == "AddHero" then
		Serialize(os, 123)
		__SerializeStruct(os, "RoleHero", cmd.hero_hall)
		Serialize(os, cmd.flag)
	elseif cmd.__type__ == "UpdateHeroInfo" then
		Serialize(os, 124)
		__SerializeStruct(os, "RoleHero", cmd.hero_hall)
	elseif cmd.__type__ == "UseItem_Re" then
		Serialize(os, 125)
		Serialize(os, cmd.retcode)
	elseif cmd.__type__ == "One_Level_Up" then
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
	elseif cmd.__type__ == "One_Level_Up_Re" then
		Serialize(os, 127)
		Serialize(os, cmd.retcode)
	elseif cmd.__type__ == "Hero_Up_Grade" then
		Serialize(os, 128)
		Serialize(os, cmd.hero_id)
	elseif cmd.__type__ == "Hero_Up_Grade_Re" then
		Serialize(os, 129)
		Serialize(os, cmd.retcode)
	elseif cmd.__type__ == "ErrorInfo" then
		Serialize(os, 130)
		Serialize(os, cmd.error_id)
	elseif cmd.__type__ == "BuyHorse" then
		Serialize(os, 131)
		Serialize(os, cmd.tid)
		Serialize(os, cmd.typ)
	elseif cmd.__type__ == "BuyHorse_Re" then
		Serialize(os, 132)
		Serialize(os, cmd.retcode)
	elseif cmd.__type__ == "AddHorse" then
		Serialize(os, 133)
		__SerializeStruct(os, "RoleHorse", cmd.horse)
	elseif cmd.__type__ == "GetLastHero" then
		Serialize(os, 134)
	elseif cmd.__type__ == "GetLastHero_Re" then
		Serialize(os, 135)
		if cmd.info==nil then
			Serialize(os, 0)
		else
			Serialize(os, #cmd.info)
			for i = 1, #cmd.info do
				Serialize(os, cmd.info[i])
			end
		end
	elseif cmd.__type__ == "PvpJoin" then
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
	elseif cmd.__type__ == "PvpJoin_Re" then
		Serialize(os, 137)
		Serialize(os, cmd.retcode)
		Serialize(os, cmd.time)
	elseif cmd.__type__ == "PvpMatchSuccess" then
		Serialize(os, 138)
		Serialize(os, cmd.retcode)
		Serialize(os, cmd.index)
	elseif cmd.__type__ == "PvpEnter" then
		Serialize(os, 139)
		Serialize(os, cmd.index)
		Serialize(os, cmd.flag)
	elseif cmd.__type__ == "PvpEnter_Re" then
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
	elseif cmd.__type__ == "PvpCancle" then
		Serialize(os, 141)
	elseif cmd.__type__ == "PvpCancle_Re" then
		Serialize(os, 142)
		Serialize(os, cmd.retcode)
	elseif cmd.__type__ == "PvpSpeed" then
		Serialize(os, 143)
		Serialize(os, cmd.speed)
	elseif cmd.__type__ == "ResetRoleInfo" then
		Serialize(os, 144)
	elseif cmd.__type__ == "SendNotice" then
		Serialize(os, 145)
		Serialize(os, cmd.notice_id)
		if cmd.notice_para==nil then
			Serialize(os, 0)
		else
			Serialize(os, #cmd.notice_para)
			for i = 1, #cmd.notice_para do
				Serialize(os, cmd.notice_para[i])
			end
		end
	elseif cmd.__type__ == "CurrentTask" then
		Serialize(os, 146)
		if cmd.current==nil then
			Serialize(os, 0)
		else
			Serialize(os, #cmd.current)
			for i = 1, #cmd.current do
				__SerializeStruct(os, "RoleCurrentTask", cmd.current[i])
			end
		end
	elseif cmd.__type__ == "FinishedTask" then
		Serialize(os, 147)
		if cmd.finish==nil then
			Serialize(os, 0)
		else
			Serialize(os, #cmd.finish)
			for i = 1, #cmd.finish do
				Serialize(os, cmd.finish[i])
			end
		end
	elseif cmd.__type__ == "GetTask" then
		Serialize(os, 148)
	elseif cmd.__type__ == "ItemCountChange" then
		Serialize(os, 149)
		Serialize(os, cmd.itemid)
		Serialize(os, cmd.count)
	elseif cmd.__type__ == "HeroUpgradeSkill" then
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
	elseif cmd.__type__ == "HeroUpgradeSkill_Re" then
		Serialize(os, 151)
		Serialize(os, cmd.retcode)
	elseif cmd.__type__ == "GetHeroComments" then
		Serialize(os, 152)
		Serialize(os, cmd.hero_id)
	elseif cmd.__type__ == "GetHeroComments_Re" then
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
	elseif cmd.__type__ == "AgreeHeroComments" then
		Serialize(os, 154)
		Serialize(os, cmd.hero_id)
		Serialize(os, cmd.role_id)
		Serialize(os, cmd.time_stamp)
	elseif cmd.__type__ == "AgreeHeroComments_Re" then
		Serialize(os, 155)
		Serialize(os, cmd.retcode)
		Serialize(os, cmd.hero_id)
		Serialize(os, cmd.role_id)
		Serialize(os, cmd.time_stamp)
	elseif cmd.__type__ == "WriteHeroComments" then
		Serialize(os, 156)
		Serialize(os, cmd.hero_id)
		Serialize(os, cmd.comments)
	elseif cmd.__type__ == "WriteHeroComments_Re" then
		Serialize(os, 157)
		Serialize(os, cmd.retcode)
		Serialize(os, cmd.hero_id)
	elseif cmd.__type__ == "ReWriteHeroComments" then
		Serialize(os, 158)
		Serialize(os, cmd.hero_id)
		Serialize(os, cmd.comments)
	elseif cmd.__type__ == "ReWriteHeroComments_Re" then
		Serialize(os, 159)
		Serialize(os, cmd.retcode)
		Serialize(os, cmd.hero_id)
	elseif cmd.__type__ == "UpdateHeroSkillPoint" then
		Serialize(os, 160)
		Serialize(os, cmd.point)
	elseif cmd.__type__ == "GetVPRefreshTime" then
		Serialize(os, 161)
	elseif cmd.__type__ == "GetVPRefreshTime_Re" then
		Serialize(os, 162)
		Serialize(os, cmd.refresh_time)
	elseif cmd.__type__ == "GetSkillPointRefreshTime" then
		Serialize(os, 163)
	elseif cmd.__type__ == "GetSkillPointRefreshTime_Re" then
		Serialize(os, 164)
		Serialize(os, cmd.refresh_time)
	elseif cmd.__type__ == "RoleLogin" then
		Serialize(os, 165)
	elseif cmd.__type__ == "BuySkillPoint" then
		Serialize(os, 166)
	elseif cmd.__type__ == "BuySkillPoint_Re" then
		Serialize(os, 167)
		Serialize(os, cmd.retcode)
		Serialize(os, cmd.point)
	elseif cmd.__type__ == "UpdatePvpVideo" then
		Serialize(os, 168)
		Serialize(os, cmd.video)
		__SerializeStruct(os, "RoleClientPVPInfo", cmd.player1)
		__SerializeStruct(os, "RoleClientPVPInfo", cmd.player2)
		Serialize(os, cmd.win_flag)
		Serialize(os, cmd.time)
	elseif cmd.__type__ == "GetVideo" then
		Serialize(os, 169)
		Serialize(os, cmd.video_id)
	elseif cmd.__type__ == "GetVideo_Re" then
		Serialize(os, 170)
		Serialize(os, cmd.retcode)
		__SerializeStruct(os, "RoleClientPVPInfo", cmd.player1)
		__SerializeStruct(os, "RoleClientPVPInfo", cmd.player2)
		__SerializeStruct(os, "PvpVideo", cmd.operation)
		Serialize(os, cmd.win_flag)
		Serialize(os, cmd.robot_flag)
		Serialize(os, cmd.robot_seed)
		Serialize(os, cmd.exe_ver)
		Serialize(os, cmd.data_ver)
	elseif cmd.__type__ == "PrivateChatHistory" then
		Serialize(os, 171)
		if cmd.private_chat==nil then
			Serialize(os, 0)
		else
			Serialize(os, #cmd.private_chat)
			for i = 1, #cmd.private_chat do
				__SerializeStruct(os, "ChatInfo", cmd.private_chat[i])
			end
		end
	elseif cmd.__type__ == "AddBlackList" then
		Serialize(os, 172)
		Serialize(os, cmd.roleid)
	elseif cmd.__type__ == "AddBlackList_Re" then
		Serialize(os, 173)
		__SerializeStruct(os, "RoleBase", cmd.roleinfo)
	elseif cmd.__type__ == "DelBlackList" then
		Serialize(os, 174)
		Serialize(os, cmd.roleid)
	elseif cmd.__type__ == "DelBlackList_Re" then
		Serialize(os, 175)
		Serialize(os, cmd.roleid)
	elseif cmd.__type__ == "SeeAnotherRole" then
		Serialize(os, 176)
		Serialize(os, cmd.roleid)
	elseif cmd.__type__ == "SeeAnotherRole_Re" then
		Serialize(os, 177)
		__SerializeStruct(os, "AnotherRoleData", cmd.roleinfo)
	elseif cmd.__type__ == "GetPrivateChatHistory" then
		Serialize(os, 178)
	elseif cmd.__type__ == "ReadMail" then
		Serialize(os, 179)
		Serialize(os, cmd.mail_id)
	elseif cmd.__type__ == "ReadMail_Re" then
		Serialize(os, 180)
		Serialize(os, cmd.retcode)
	elseif cmd.__type__ == "GetAttachment" then
		Serialize(os, 181)
		Serialize(os, cmd.mail_id)
	elseif cmd.__type__ == "GetAttachment_Re" then
		Serialize(os, 182)
		Serialize(os, cmd.retcode)
	elseif cmd.__type__ == "UpdateMail" then
		Serialize(os, 183)
		__SerializeStruct(os, "MailInfo", cmd.mail_info)
	elseif cmd.__type__ == "UpdatePvpEndTime" then
		Serialize(os, 184)
		Serialize(os, cmd.end_time)
	elseif cmd.__type__ == "UpdateHeroPvpInfo" then
		Serialize(os, 185)
		if cmd.hero_pvpinfo==nil then
			Serialize(os, 0)
		else
			Serialize(os, #cmd.hero_pvpinfo)
			for i = 1, #cmd.hero_pvpinfo do
				__SerializeStruct(os, "HeroPvpInfoData", cmd.hero_pvpinfo[i])
			end
		end
	elseif cmd.__type__ == "DeleteTask" then
		Serialize(os, 186)
		Serialize(os, cmd.task_id)
	elseif cmd.__type__ == "BroadcastPvpVideo" then
		Serialize(os, 187)
		Serialize(os, cmd.typ)
		Serialize(os, cmd.video_id)
		Serialize(os, cmd.content)
	elseif cmd.__type__ == "BroadcastPvpVideo_Re" then
		Serialize(os, 188)
		Serialize(os, cmd.typ)
		__SerializeStruct(os, "RoleBrief", cmd.src)
		Serialize(os, cmd.content)
		Serialize(os, cmd.video_id)
		__SerializeStruct(os, "RoleClientPVPInfo", cmd.player1)
		__SerializeStruct(os, "RoleClientPVPInfo", cmd.player2)
		Serialize(os, cmd.time)
		Serialize(os, cmd.win_flag)
	elseif cmd.__type__ == "ChangeHeroSelectSkill" then
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
	elseif cmd.__type__ == "ChangeHeroSelectSkill_Re" then
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
	elseif cmd.__type__ == "UpdatePvpInfo" then
		Serialize(os, 191)
		Serialize(os, cmd.join_count)
		Serialize(os, cmd.win_count)
	elseif cmd.__type__ == "UpdateRep" then
		Serialize(os, 192)
		Serialize(os, cmd.rep_id)
		Serialize(os, cmd.rep_num)
	elseif cmd.__type__ == "MallBuyItem" then
		Serialize(os, 193)
		Serialize(os, cmd.item_id)
		Serialize(os, cmd.item_num)
	elseif cmd.__type__ == "MallBuyItem_Re" then
		Serialize(os, 194)
		Serialize(os, cmd.retcode)
	elseif cmd.__type__ == "UpdatePvpStar" then
		Serialize(os, 195)
		Serialize(os, cmd.typ)
		Serialize(os, cmd.star)
	elseif cmd.__type__ == "UpdateHeroSoul" then
		Serialize(os, 197)
		Serialize(os, cmd.soul_id)
		Serialize(os, cmd.soul_num)
	elseif cmd.__type__ == "LevelUpHeroStar" then
		Serialize(os, 198)
		Serialize(os, cmd.hero_id)
	elseif cmd.__type__ == "LevelUpHeroStar_Re" then
		Serialize(os, 199)
		Serialize(os, cmd.hero_id)
		Serialize(os, cmd.retcode)
	elseif cmd.__type__ == "ClearHeroPvpInfo" then
		Serialize(os, 200)
	elseif cmd.__type__ == "UpdateMysteryShopInfo" then
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
	elseif cmd.__type__ == "MysteryShopBuyItem" then
		Serialize(os, 202)
		Serialize(os, cmd.shop_id)
		Serialize(os, cmd.position)
		Serialize(os, cmd.item_id)
	elseif cmd.__type__ == "MysteryShopBuyItem_Re" then
		Serialize(os, 203)
		Serialize(os, cmd.retcode)
		Serialize(os, cmd.shop_id)
		Serialize(os, cmd.position)
		Serialize(os, cmd.item_id)
		Serialize(os, cmd.buy_count)
	elseif cmd.__type__ == "RefreshMysteryShop" then
		Serialize(os, 204)
		Serialize(os, cmd.shop_id)
	elseif cmd.__type__ == "RefreshMysteryShop_Re" then
		Serialize(os, 205)
		Serialize(os, cmd.retcode)
		Serialize(os, cmd.shop_id)
	elseif cmd.__type__ == "ResetBattleField" then
		Serialize(os, 206)
		Serialize(os, cmd.battle_id)
		Serialize(os, cmd.typ)
	elseif cmd.__type__ == "ResetBattleField_Re" then
		Serialize(os, 207)
		Serialize(os, cmd.retcode)
		Serialize(os, cmd.typ)
		Serialize(os, cmd.battle_id)
		__SerializeStruct(os, "BattleInfo", cmd.battle_info)
	elseif cmd.__type__ == "BattleFieldBegin" then
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
	elseif cmd.__type__ == "BattleFieldBegin_Re" then
		Serialize(os, 209)
		Serialize(os, cmd.retcode)
		Serialize(os, cmd.battle_id)
	elseif cmd.__type__ == "BattleFieldMove" then
		Serialize(os, 210)
		Serialize(os, cmd.battle_id)
		Serialize(os, cmd.src_id)
		Serialize(os, cmd.src_position)
		Serialize(os, cmd.dst_id)
		Serialize(os, cmd.dst_position)
	elseif cmd.__type__ == "BattleFieldMove_Re" then
		Serialize(os, 211)
		Serialize(os, cmd.retcode)
		Serialize(os, cmd.battle_id)
		Serialize(os, cmd.src_id)
		Serialize(os, cmd.src_position)
		Serialize(os, cmd.dst_id)
		Serialize(os, cmd.dst_position)
	elseif cmd.__type__ == "BattleFieldJoinBattle" then
		Serialize(os, 212)
		Serialize(os, cmd.battle_id)
		Serialize(os, cmd.npc_id)
	elseif cmd.__type__ == "BattleFieldJoinBattle_Re" then
		Serialize(os, 213)
		Serialize(os, cmd.retcode)
		Serialize(os, cmd.battle_id)
		Serialize(os, cmd.npc_id)
	elseif cmd.__type__ == "BattleFieldFinishBattle" then
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
	elseif cmd.__type__ == "BattleFieldFinishBattle_Re" then
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
	elseif cmd.__type__ == "BattleFieldEnd" then
		Serialize(os, 216)
		Serialize(os, cmd.battle_id)
		Serialize(os, cmd.win_flag)
		__SerializeStruct(os, "SweepInstanceData", cmd.rewards)
	elseif cmd.__type__ == "BattleFieldGetPrize" then
		Serialize(os, 217)
		Serialize(os, cmd.battle_id)
	elseif cmd.__type__ == "BattleFieldGetPrize_Re" then
		Serialize(os, 218)
		Serialize(os, cmd.retcode)
		Serialize(os, cmd.battle_id)
		__SerializeStruct(os, "SweepInstanceData", cmd.rewards)
	elseif cmd.__type__ == "SetInstanceHeroInfo" then
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
	elseif cmd.__type__ == "SetInstanceHeroInfo_Re" then
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
	elseif cmd.__type__ == "Lottery" then
		Serialize(os, 221)
		Serialize(os, cmd.lottery_id)
		Serialize(os, cmd.cost_type)
	elseif cmd.__type__ == "Lottery_Re" then
		Serialize(os, 222)
		Serialize(os, cmd.retcode)
		Serialize(os, cmd.lottery_id)
		if cmd.reward_ids==nil then
			Serialize(os, 0)
		else
			Serialize(os, #cmd.reward_ids)
			for i = 1, #cmd.reward_ids do
				__SerializeStruct(os, "LotteryRewardInfo", cmd.reward_ids[i])
			end
		end
	elseif cmd.__type__ == "GetBattleFieldInfo" then
		Serialize(os, 223)
		Serialize(os, cmd.battle_id)
	elseif cmd.__type__ == "GetBattleFieldInfo_Re" then
		Serialize(os, 224)
		Serialize(os, cmd.retcode)
		Serialize(os, cmd.battle_id)
		__SerializeStruct(os, "BattleInfo", cmd.battle_info)
	elseif cmd.__type__ == "ChangeBattleState" then
		Serialize(os, 225)
		Serialize(os, cmd.battle_id)
		Serialize(os, cmd.state)
	elseif cmd.__type__ == "BattleFieldCancel" then
		Serialize(os, 226)
		Serialize(os, cmd.battle_id)
	elseif cmd.__type__ == "BattleFieldCancel_Re" then
		Serialize(os, 227)
		Serialize(os, cmd.retcode)
		Serialize(os, cmd.battle_id)
		Serialize(os, cmd.position)
	elseif cmd.__type__ == "BattleFieldGetEvent" then
		Serialize(os, 228)
		Serialize(os, cmd.battle_id)
	elseif cmd.__type__ == "BattleFieldGetEvent_Re" then
		Serialize(os, 229)
		Serialize(os, cmd.retcode)
		Serialize(os, cmd.battle_id)
		Serialize(os, cmd.event)
		__SerializeStruct(os, "BattleEventInfo", cmd.event_info)
	elseif cmd.__type__ == "BattleFieldCapturedPosition" then
		Serialize(os, 230)
		Serialize(os, cmd.battle_id)
		__SerializeStruct(os, "BattlePositionInfo", cmd.position_info)
		Serialize(os, cmd.event)
		__SerializeStruct(os, "BattleEventInfo", cmd.event_info)
	elseif cmd.__type__ == "GetCurBattleField" then
		Serialize(os, 231)
	elseif cmd.__type__ == "GetCurBattleField_Re" then
		Serialize(os, 232)
		Serialize(os, cmd.battle_id)
		Serialize(os, cmd.state)
	elseif cmd.__type__ == "BattleFieldFinishEvent" then
		Serialize(os, 233)
		Serialize(os, cmd.battle_id)
	elseif cmd.__type__ == "BattleFieldFinishEvent_Re" then
		Serialize(os, 234)
		Serialize(os, cmd.retcode)
		Serialize(os, cmd.battle_id)
		Serialize(os, cmd.join_battle_flag)
		Serialize(os, cmd.event)
	elseif cmd.__type__ == "GiveUpCurBattleField" then
		Serialize(os, 235)
	elseif cmd.__type__ == "GiveUpCurBattleField_Re" then
		Serialize(os, 236)
		Serialize(os, cmd.retcode)
	elseif cmd.__type__ == "GetRefreshTime" then
		Serialize(os, 237)
		Serialize(os, cmd.typ)
	elseif cmd.__type__ == "GetRefreshTime_Re" then
		Serialize(os, 238)
		Serialize(os, cmd.typ)
		Serialize(os, cmd.last_refreshtime)
	elseif cmd.__type__ == "DailySign" then
		Serialize(os, 239)
		Serialize(os, cmd.typ)
	elseif cmd.__type__ == "DailySign_Re" then
		Serialize(os, 240)
		Serialize(os, cmd.retcode)
		Serialize(os, cmd.typ)
		__SerializeStruct(os, "Item", cmd.item)
	elseif cmd.__type__ == "GetMyPveArenaInfo" then
		Serialize(os, 241)
	elseif cmd.__type__ == "GetMyPveArenaInfo_Re" then
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
	elseif cmd.__type__ == "GetOtherPveArenaInfo" then
		Serialize(os, 243)
		Serialize(os, cmd.roleid)
	elseif cmd.__type__ == "GetOtherPveArenaInfo_Re" then
		Serialize(os, 244)
		__SerializeStruct(os, "PveArenaFighterInfo", cmd.info)
	elseif cmd.__type__ == "GetFighterInfo" then
		Serialize(os, 245)
	elseif cmd.__type__ == "GetFighterInfo_Re" then
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
	elseif cmd.__type__ == "PveArenaJoinBattle" then
		Serialize(os, 247)
		Serialize(os, cmd.rank)
	elseif cmd.__type__ == "PveArenaJoinBattle_Re" then
		Serialize(os, 248)
		Serialize(os, cmd.retcode)
		Serialize(os, cmd.last_attack_time)
		__SerializeStruct(os, "RolePveArenaInfo", cmd.self_info)
		__SerializeStruct(os, "PveArenaFighterInfo", cmd.role_info)
	elseif cmd.__type__ == "PveArenaEndBattle" then
		Serialize(os, 249)
		Serialize(os, cmd.win_flag)
		__SerializeStruct(os, "PveArenaOperation", cmd.operation)
	elseif cmd.__type__ == "PveArenaEndBattle_Re" then
		Serialize(os, 250)
		Serialize(os, cmd.retcode)
		Serialize(os, cmd.score_change)
		if cmd.item==nil then
			Serialize(os, 0)
		else
			Serialize(os, #cmd.item)
			for i = 1, #cmd.item do
				__SerializeStruct(os, "Item", cmd.item[i])
			end
		end
	elseif cmd.__type__ == "PveArenaResetTime" then
		Serialize(os, 251)
	elseif cmd.__type__ == "PveArenaResetTime_Re" then
		Serialize(os, 252)
		Serialize(os, cmd.retcode)
		Serialize(os, cmd.last_time)
	elseif cmd.__type__ == "PveArenaResetCount" then
		Serialize(os, 253)
	elseif cmd.__type__ == "PveArenaResetCount_Re" then
		Serialize(os, 254)
		Serialize(os, cmd.retcode)
	elseif cmd.__type__ == "ChallengeRoleByItem" then
		Serialize(os, 255)
		Serialize(os, cmd.roleid)
		Serialize(os, cmd.name)
	elseif cmd.__type__ == "ChallengeRoleByItem_Re" then
		Serialize(os, 256)
		Serialize(os, cmd.retcode)
		__SerializeStruct(os, "RolePveArenaInfo", cmd.self_info)
		__SerializeStruct(os, "PveArenaFighterInfo", cmd.role_info)
	elseif cmd.__type__ == "GetPveArenaHistory" then
		Serialize(os, 257)
	elseif cmd.__type__ == "GetPveArenaHistory_Re" then
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
	elseif cmd.__type__ == "GetPveArenaOperation" then
		Serialize(os, 259)
		Serialize(os, cmd.id)
	elseif cmd.__type__ == "GetPveArenaOperation_Re" then
		Serialize(os, 260)
		Serialize(os, cmd.retcode)
		__SerializeStruct(os, "RolePveArenaInfo", cmd.self_hero_info)
		__SerializeStruct(os, "RolePveArenaInfo", cmd.oppo_hero_info)
		__SerializeStruct(os, "PveArenaOperation", cmd.operation)
		Serialize(os, cmd.exe_ver)
		Serialize(os, cmd.data_ver)
	elseif cmd.__type__ == "SetPveArenaHero" then
		Serialize(os, 261)
		if cmd.heros==nil then
			Serialize(os, 0)
		else
			Serialize(os, #cmd.heros)
			for i = 1, #cmd.heros do
				Serialize(os, cmd.heros[i])
			end
		end
	elseif cmd.__type__ == "SetPveArenaHero_Re" then
		Serialize(os, 262)
		Serialize(os, cmd.retcode)
	elseif cmd.__type__ == "ResetSkilllevel" then
		Serialize(os, 263)
		Serialize(os, cmd.hero_id)
	elseif cmd.__type__ == "ResetSkilllevel_Re" then
		Serialize(os, 264)
		Serialize(os, cmd.retcode)
	elseif cmd.__type__ == "WeaponEquip" then
		Serialize(os, 265)
		Serialize(os, cmd.hero)
		Serialize(os, cmd.weapon_id)
	elseif cmd.__type__ == "WeaponEquip_Re" then
		Serialize(os, 266)
		Serialize(os, cmd.retcode)
	elseif cmd.__type__ == "WeaponLevelUp" then
		Serialize(os, 267)
		Serialize(os, cmd.hero)
		Serialize(os, cmd.weapon_id)
	elseif cmd.__type__ == "WeaponLevelUp_Re" then
		Serialize(os, 268)
		Serialize(os, cmd.retcode)
		Serialize(os, cmd.hero)
		Serialize(os, cmd.weapon_id)
		Serialize(os, cmd.crit_flag)
		Serialize(os, cmd.skill_id)
	elseif cmd.__type__ == "WeaponStrength" then
		Serialize(os, 269)
		Serialize(os, cmd.hero)
		Serialize(os, cmd.weapon_id)
	elseif cmd.__type__ == "WeaponStrength_Re" then
		Serialize(os, 270)
		Serialize(os, cmd.retcode)
		Serialize(os, cmd.hero)
		Serialize(os, cmd.weapon_id)
		Serialize(os, cmd.crit_flag)
	elseif cmd.__type__ == "WeaponDecompose" then
		Serialize(os, 271)
		Serialize(os, cmd.weapon_id)
	elseif cmd.__type__ == "WeaponDecompose_Re" then
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
	elseif cmd.__type__ == "WeaponUnequip" then
		Serialize(os, 273)
		Serialize(os, cmd.hero)
	elseif cmd.__type__ == "WeaponUnequip_Re" then
		Serialize(os, 274)
		Serialize(os, cmd.retcode)
	elseif cmd.__type__ == "WeaponAdd" then
		Serialize(os, 275)
		__SerializeStruct(os, "WeaponItem", cmd.weapon_info)
	elseif cmd.__type__ == "WeaponDel" then
		Serialize(os, 276)
		Serialize(os, cmd.id)
	elseif cmd.__type__ == "WeaponUpdate" then
		Serialize(os, 277)
		__SerializeStruct(os, "WeaponItem", cmd.weapon_info)
	elseif cmd.__type__ == "LotteryUpdate" then
		Serialize(os, 278)
		Serialize(os, cmd.typ)
		Serialize(os, cmd.flag)
	elseif cmd.__type__ == "WuZheShiLianGetDifficultyInfo" then
		Serialize(os, 279)
	elseif cmd.__type__ == "WuZheShiLianGetDifficultyInfo_Re" then
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
	elseif cmd.__type__ == "WuZheShiLianSelectDifficulty" then
		Serialize(os, 281)
		Serialize(os, cmd.difficulty)
	elseif cmd.__type__ == "WuZheShiLianSelectDifficulty_Re" then
		Serialize(os, 282)
		Serialize(os, cmd.retcode)
		Serialize(os, cmd.cur_diffculty)
	elseif cmd.__type__ == "WuZheShiLianGetOpponentInfo" then
		Serialize(os, 283)
		Serialize(os, cmd.difficulty)
	elseif cmd.__type__ == "WuZheShiLianGetOpponentInfo_Re" then
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
	elseif cmd.__type__ == "WuZheShiLianGetHeroInfo" then
		Serialize(os, 285)
	elseif cmd.__type__ == "WuZheShiLianGetHeroInfo_Re" then
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
	elseif cmd.__type__ == "WuZheShiLianJoinBattle" then
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
	elseif cmd.__type__ == "WuZheShiLianJoinBattle_Re" then
		Serialize(os, 288)
		Serialize(os, cmd.retcode)
	elseif cmd.__type__ == "WuZheShiLianFinishBattle" then
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
	elseif cmd.__type__ == "WuZheShiLianFinishBattle_Re" then
		Serialize(os, 290)
		Serialize(os, cmd.retcode)
		Serialize(os, cmd.money)
	elseif cmd.__type__ == "WuZheShiLianReset" then
		Serialize(os, 291)
	elseif cmd.__type__ == "WuZheShiLianReset_Re" then
		Serialize(os, 292)
		Serialize(os, cmd.retcode)
	elseif cmd.__type__ == "PveArenaUpdateVideoFlag" then
		Serialize(os, 293)
		Serialize(os, cmd.video_flag)
	elseif cmd.__type__ == "WuZheShiLianGetReward" then
		Serialize(os, 294)
		Serialize(os, cmd.difficulty)
		Serialize(os, cmd.stage)
	elseif cmd.__type__ == "WuZheShiLianGetReward_Re" then
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
	elseif cmd.__type__ == "WuZheShiLianSweep" then
		Serialize(os, 296)
		Serialize(os, cmd.difficulty)
	elseif cmd.__type__ == "WuZheShiLianSweep_Re" then
		Serialize(os, 297)
		Serialize(os, cmd.difficulty)
		Serialize(os, cmd.retcode)
	elseif cmd.__type__ == "EquipmentEquip" then
		Serialize(os, 301)
		Serialize(os, cmd.hero)
		Serialize(os, cmd.typ)
		Serialize(os, cmd.equipment_id)
	elseif cmd.__type__ == "EquipmentEquip_Re" then
		Serialize(os, 302)
		Serialize(os, cmd.retcode)
		Serialize(os, cmd.hero)
		Serialize(os, cmd.typ)
		Serialize(os, cmd.equipment_id)
	elseif cmd.__type__ == "EquipmentLevelUp" then
		Serialize(os, 303)
		Serialize(os, cmd.hero)
		Serialize(os, cmd.typ)
		Serialize(os, cmd.equipment_id)
	elseif cmd.__type__ == "EquipmentLevelUp_Re" then
		Serialize(os, 304)
		Serialize(os, cmd.retcode)
		Serialize(os, cmd.hero)
		Serialize(os, cmd.typ)
		Serialize(os, cmd.equipment_id)
		Serialize(os, cmd.crit_flag)
	elseif cmd.__type__ == "EquipmentGradeUp" then
		Serialize(os, 305)
		Serialize(os, cmd.hero)
		Serialize(os, cmd.typ)
		Serialize(os, cmd.equipment_id)
	elseif cmd.__type__ == "EquipmentGradeUp_Re" then
		Serialize(os, 306)
		Serialize(os, cmd.retcode)
		Serialize(os, cmd.hero)
		Serialize(os, cmd.typ)
		Serialize(os, cmd.equipment_id)
	elseif cmd.__type__ == "EquipmentRefinable" then
		Serialize(os, 307)
		Serialize(os, cmd.hero)
		Serialize(os, cmd.typ)
		Serialize(os, cmd.equipment_id)
		Serialize(os, cmd.refinable_typ)
		Serialize(os, cmd.refinable_count)
	elseif cmd.__type__ == "EquipmentRefinable_Re" then
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
	elseif cmd.__type__ == "EquipmentDecompose" then
		Serialize(os, 309)
		Serialize(os, cmd.equipment_id)
	elseif cmd.__type__ == "EquipmentDecompose_Re" then
		Serialize(os, 310)
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
	elseif cmd.__type__ == "EquipmentUnequip" then
		Serialize(os, 311)
		Serialize(os, cmd.hero)
		Serialize(os, cmd.typ)
	elseif cmd.__type__ == "EquipmentUnequip_Re" then
		Serialize(os, 312)
		Serialize(os, cmd.retcode)
		Serialize(os, cmd.hero)
		Serialize(os, cmd.typ)
	elseif cmd.__type__ == "EquipmentAdd" then
		Serialize(os, 313)
		__SerializeStruct(os, "EquipmentItem", cmd.equipment_info)
	elseif cmd.__type__ == "EquipmentDel" then
		Serialize(os, 314)
		Serialize(os, cmd.id)
	elseif cmd.__type__ == "EquipmentUpdate" then
		Serialize(os, 315)
		__SerializeStruct(os, "EquipmentItem", cmd.equipment_info)
	elseif cmd.__type__ == "EquipmentRefinableSave" then
		Serialize(os, 316)
		Serialize(os, cmd.hero)
		Serialize(os, cmd.typ)
		Serialize(os, cmd.equipment_id)
		Serialize(os, cmd.save_flag)
	elseif cmd.__type__ == "EquipmentRefinableSave_Re" then
		Serialize(os, 317)
		Serialize(os, cmd.retcode)
		Serialize(os, cmd.hero)
		Serialize(os, cmd.typ)
		Serialize(os, cmd.equipment_id)
		Serialize(os, cmd.save_flag)
	elseif cmd.__type__ == "MafiaGet_Re" then
		Serialize(os, 10102)
		Serialize(os, cmd.retcode)
		__SerializeStruct(os, "Mafia", cmd.mafia)
	elseif cmd.__type__ == "MafiaCreate_Re" then
		Serialize(os, 10104)
		Serialize(os, cmd.retcode)
		__SerializeStruct(os, "Mafia", cmd.mafia)
	elseif cmd.__type__ == "TongQueTaiSetHeroInfo" then
		Serialize(os, 351)
		if cmd.hero==nil then
			Serialize(os, 0)
		else
			Serialize(os, #cmd.hero)
			for i = 1, #cmd.hero do
				Serialize(os, cmd.hero[i])
			end
		end
	elseif cmd.__type__ == "TongQueTaiSetHeroInfo_Re" then
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
	elseif cmd.__type__ == "TongQueTaiBeginMatch" then
		Serialize(os, 353)
		Serialize(os, cmd.difficulty)
		Serialize(os, cmd.double_flag)
		Serialize(os, cmd.auto_flag)
	elseif cmd.__type__ == "TongQueTaiBeginMatch_Re" then
		Serialize(os, 354)
		Serialize(os, cmd.difficulty)
		Serialize(os, cmd.double_flag)
		Serialize(os, cmd.auto_flag)
		Serialize(os, cmd.retcode)
	elseif cmd.__type__ == "TongQueTaiCancleMatch" then
		Serialize(os, 355)
		Serialize(os, cmd.difficulty)
	elseif cmd.__type__ == "TongQueTaiCancleMatch_Re" then
		Serialize(os, 356)
		Serialize(os, cmd.difficulty)
		Serialize(os, cmd.retcode)
	elseif cmd.__type__ == "TongQueTaiMatchSuccess" then
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
	elseif cmd.__type__ == "TongQueTaiNoticeRoleJoin" then
		Serialize(os, 358)
	elseif cmd.__type__ == "TongQueTaiJoin" then
		Serialize(os, 359)
		Serialize(os, cmd.role_id1)
		Serialize(os, cmd.role_id2)
	elseif cmd.__type__ == "TongQueTaiJoin_Re" then
		Serialize(os, 360)
		Serialize(os, cmd.role_id)
		Serialize(os, cmd.retcode)
	elseif cmd.__type__ == "TongQueTaiOperation" then
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
	elseif cmd.__type__ == "TongQueTaiOperation_Re" then
		Serialize(os, 362)
		if cmd.operation==nil then
			Serialize(os, 0)
		else
			Serialize(os, #cmd.operation)
			for i = 1, #cmd.operation do
				__SerializeStruct(os, "TongQueTaiOperation", cmd.operation[i])
			end
		end
	elseif cmd.__type__ == "TongQueTaiFinish" then
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
	elseif cmd.__type__ == "TongQueTaiFinish_Re" then
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
	elseif cmd.__type__ == "TongQueTaiReward" then
		Serialize(os, 365)
	elseif cmd.__type__ == "TongQueTaiSpeed" then
		Serialize(os, 366)
		Serialize(os, cmd.speed)
		Serialize(os, cmd.role_id1)
		Serialize(os, cmd.role_id2)
	elseif cmd.__type__ == "TongQueTaiSpeed_Re" then
		Serialize(os, 367)
		Serialize(os, cmd.role_id)
		Serialize(os, cmd.speed)
	elseif cmd.__type__ == "TongQueTaiLoad" then
		Serialize(os, 368)
		Serialize(os, cmd.role_id1)
		Serialize(os, cmd.role_id2)
	elseif cmd.__type__ == "TongQueTaiLoad_Re" then
		Serialize(os, 369)
		Serialize(os, cmd.role_id)
	elseif cmd.__type__ == "TongQueTaiReLoad" then
		Serialize(os, 370)
		Serialize(os, cmd.role_index)
		Serialize(os, cmd.monster_index)
		Serialize(os, cmd.retcode)
	elseif cmd.__type__ == "TongQueTaiEnd" then
		Serialize(os, 371)
		Serialize(os, cmd.retcode)
	elseif cmd.__type__ == "TongQueTaiGetReward" then
		Serialize(os, 372)
	elseif cmd.__type__ == "TongQueTaiGetReward_Re" then
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
	elseif cmd.__type__ == "TongQueTaiGetInfo" then
		Serialize(os, 374)
	elseif cmd.__type__ == "TongQueTaiGetInfo_Re" then
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
	elseif cmd.__type__ == "PrivateChat" then
		Serialize(os, 10003)
		__SerializeStruct(os, "RoleBrief", cmd.src)
		__SerializeStruct(os, "RoleBrief", cmd.dest)
		Serialize(os, cmd.dest_id)
		Serialize(os, cmd.content)
		Serialize(os, cmd.time)
	elseif cmd.__type__ == "MafiaInvite" then
		Serialize(os, 10105)
		Serialize(os, cmd.dest_id)
		__SerializeStruct(os, "RoleBrief", cmd.src)
	elseif cmd.__type__ == "MafiaReply" then
		Serialize(os, 10106)
		Serialize(os, cmd.src_id)
		Serialize(os, cmd.accept)
	elseif cmd.__type__ == "MafiaAddMember" then
		Serialize(os, 10107)
		__SerializeStruct(os, "RoleBrief", cmd.member)
	elseif cmd.__type__ == "MafiaUpdate" then
		Serialize(os, 10108)
		__SerializeStruct(os, "Mafia", cmd.mafia)
	elseif cmd.__type__ == "MafiaKickout" then
		Serialize(os, 10109)
		Serialize(os, cmd.dest_id)
	elseif cmd.__type__ == "MafiaKickout_Re" then
		Serialize(os, 10110)
		Serialize(os, cmd.retcode)
		Serialize(os, cmd.dest_id)
	elseif cmd.__type__ == "MafiaLoseMember" then
		Serialize(os, 10111)
		__SerializeStruct(os, "RoleBrief", cmd.member)
	elseif cmd.__type__ == "MafiaQuit" then
		Serialize(os, 10112)
	elseif cmd.__type__ == "MafiaQuit_Re" then
		Serialize(os, 10113)
		Serialize(os, cmd.retcode)
	elseif cmd.__type__ == "MafiaDestory" then
		Serialize(os, 10114)
	elseif cmd.__type__ == "MafiaDestory_Re" then
		Serialize(os, 10115)
		Serialize(os, cmd.retcode)
	elseif cmd.__type__ == "MafiaAnnounce" then
		Serialize(os, 10116)
		Serialize(os, cmd.announce)
	elseif cmd.__type__ == "MafiaAnnounce_Re" then
		Serialize(os, 10117)
		Serialize(os, cmd.retcode)
		Serialize(os, cmd.announce)
	elseif cmd.__type__ == "GetRoleInfo" then
		Serialize(os, 1000001)
	elseif cmd.__type__ == "GetRoleInfo_Re" then
		Serialize(os, 1000002)
		Serialize(os, cmd.retcode)
		__SerializeStruct(os, "RoleInfo", cmd.info)
	elseif cmd.__type__ == "CreateRole" then
		Serialize(os, 1000003)
		Serialize(os, cmd.name)
		Serialize(os, cmd.photo)
	elseif cmd.__type__ == "PublicChat" then
		Serialize(os, 10004)
		__SerializeStruct(os, "RoleBrief", cmd.src)
		Serialize(os, cmd.content)
		Serialize(os, cmd.time)
	elseif cmd.__type__ == "CreateRole_Re" then
		Serialize(os, 1000004)
		Serialize(os, cmd.retcode)
		__SerializeStruct(os, "RoleInfo", cmd.info)
	elseif cmd.__type__ == "ReportClientVersion" then
		Serialize(os, 1000005)
		Serialize(os, cmd.client_id)
		Serialize(os, cmd.exe_ver)
		Serialize(os, cmd.data_ver)
	elseif cmd.__type__ == "DebugCommand" then
		Serialize(os, 99999)
		Serialize(os, cmd.typ)
		Serialize(os, cmd.count1)
		Serialize(os, cmd.count2)
		Serialize(os, cmd.count3)
		Serialize(os, cmd.count4)
	elseif cmd.__type__ == "ListFriends" then
		Serialize(os, 10006)
	elseif cmd.__type__ == "Ping" then
		Serialize(os, 10201)
		Serialize(os, cmd.client_send_time)
	elseif cmd.__type__ == "Ping_Re" then
		Serialize(os, 10202)
		Serialize(os, cmd.client_send_time)
	elseif cmd.__type__ == "UDPPing" then
		Serialize(os, 10203)
		Serialize(os, cmd.client_send_time)
	elseif cmd.__type__ == "UDPPing_Re" then
		Serialize(os, 10204)
		Serialize(os, cmd.client_send_time)
	elseif cmd.__type__ == "ListFriends_Re" then
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

	end

	return table.concat(os)
end

