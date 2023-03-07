function OnCommand_MafiaQuit(player, role, arg, others)
	player:Log("OnCommand_MafiaQuit, "..DumpTable(arg))

	--玩家自己退出帮会
	local mafia_data = others.mafias[role._roledata._mafia._id:ToStr()]
	local resp = NewCommand("MafiaQuit_Re")
	resp.id = arg.id

	if mafia_data == nil then
		resp.retcode = G_ERRCODE["NO_MAFIA"]
		player:SendToClient(SerializeCommand(resp))
		player:Log("OnCommand_MafiaQuit, error=NO_MAFIA")
		return
	end

	local mafia_info = mafia_data._data
	--帮会退出，首先查看自己是否有帮会
	--if role._roledata._mafia._id:ToStr() == "0" or role._roledata._mafia._name == "" then
	--	resp.retcode = G_ERRCODE["MAFIA_QUIT_NO_MAFIA"]
	--	player:SendToClient(SerializeCommand(resp))
	--	return
	--end

	--查看自己是否是帮主，如果是帮主的话，告诉他帮主不可以退出帮会，
	--但是如果他是帮会的最后一个人，那么可以退出，退出去以后帮会就会直接解散
	if role._roledata._mafia._position == 1 and mafia_info._member_map:Size() > 1 then
		resp.retcode = G_ERRCODE["MAFIA_QUIT_BANGZHU_ERR"]
		player:SendToClient(SerializeCommand(resp))
		player:Log("OnCommand_MafiaQuit, error=MAFIA_QUIT_BANGZHU_ERR")
		return
	end

	mafia_info._member_map:Delete(role._roledata._base._id)

	--设置自己的头像徽章的信息
	if role._roledata._mafia._position == G_MAFIA_POSITION["BANGZHU"] then
		ROLE_UpdateBadge(role, 1, 1, 0)
	elseif role._roledata._mafia._position == G_MAFIA_POSITION["JUNSHI"] then
		ROLE_UpdateBadge(role, 1, 2, 0)
	end
	role._roledata._mafia._create_time = 0
	role._roledata._mafia._id:Set("0")
	role._roledata._mafia._name = ""
	role._roledata._mafia._position = 0
	role._roledata._mafia._invites:Clear()
	role._roledata._mafia._apply_mafia:Clear()

	--更新自己的信息
	MAFIA_UpdateSelfInfo(role)

	--如果自己的马术积分大于0的话，那么需要把自己从帮会的排行榜中清除掉
	if role._roledata._mashu_info._today_max_score > 0 then
		local msg = NewMessage("TestDeleteTop")
		msg.id = mafia_info._mashu_toplist_id
		player:SendMessage(role._roledata._base._id, SerializeMessage(msg))
	
		mafia_info._all_mashu_score = mafia_info._all_mashu_score - role._roledata._mashu_info._today_max_score
		local msg = NewMessage("RoleUpdateMafiaMaShuScore")
		player:SendMessage(mafia_info._id, SerializeMessage(msg))
	end
	
	if mafia_info._member_map:Size() == 0 then
		--设置帮会是删除状态，其余的信息不进行修改，设置成这个状态以后，玩家就无法申请加入这个帮会了
		mafia_info._deleted = 1

		--删除帮会的马术排行榜
		local msg = NewMessage("MafiaDeleteTopList")
		msg.id =mafia_info._mashu_toplist_id
		player:SendMessage(CACHE.Int64(0), SerializeMessage(msg))

		--把自己从帮会的简易信息中删除掉
		msg = NewMessage("DeleteMafiaInfoTop")
		msg.level = mafia_info._level
		msg.id = mafia_info._id:ToStr()
		player:SendMessage(CACHE.Int64(0), SerializeMessage(msg))
	else
		--这里仅仅是需要通知玩家有一个玩家退出了帮会而已
		MAFIA_MafiaDelMember(mafia_info, role._roledata._base._id)
		--更新帮会的信息到简易帮会表中去
		MAFIA_MafiaUpdateInfoTop(mafia_info, 0)
	end

	TASK_ChangeCondition(role, G_ACH_TYPE["MAFIA_QUIT"], 0, -1)
	resp.retcode = G_ERRCODE["SUCCESS"]
	player:SendToClient(SerializeCommand(resp))
end
