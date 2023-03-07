function OnCommand_MafiaChangeMenberPosition(player, role, arg, others)
	player:Log("OnCommand_MafiaChangeMenberPosition, "..DumpTable(arg).." "..DumpTable(others))

	--修改某一个人的帮会职位，不可以是帮主
	local mafia_data = others.mafias[role._roledata._mafia._id:ToStr()]
	local dest_role = others.roles[arg.role_id]
	local resp = NewCommand("MafiaChangeMenberPosition_Re")

	if role._roledata._base._id:ToStr() == arg.role_id then
		return
	end

	resp.position = arg.position
	resp.role_id = arg.role_id

	if mafia_data == nil then
		resp.retcode = G_ERRCODE["NO_MAFIA"]
		player:SendToClient(SerializeCommand(resp))
		player:Log("OnCommand_MafiaChangeMenberPosition, error=NO_MAFIA")
		return
	end

	local mafia_info = mafia_data._data

	if role._roledata._mafia._position ~= G_MAFIA_POSITION["BANGZHU"] and role._roledata._mafia._position ~= G_MAFIA_POSITION["JUNSHI"] then
		resp.retcode = G_ERRCODE["MAFIA_SET_LEVEL_ERR"]
		player:SendToClient(SerializeCommand(resp))
		player:Log("OnCommand_MafiaChangeMenberPosition, error=MAFIA_SET_LEVEL_ERR")
		return
	end

	if role._roledata._mafia._position >= arg.position then
		resp.retcode = G_ERRCODE["MAFIA_POSITION_HIGH_SELF"]
		player:SendToClient(SerializeCommand(resp))
		player:Log("OnCommand_MafiaChangeMenberPosition, error=MAFIA_POSITION_HIGH_SELF")
		return
	end

	--首先查看这个职位是否存在，不能任命一个不存在的职位,其次这个职位不可以是帮主
	local ed = DataPool_Find("elementdata")
	local league_position_info = ed:FindBy("league_position", arg.position)
	if league_position_info == nil then
		return
	end

	local member_info = mafia_info._member_map:Find(CACHE.Int64(arg.role_id))
	if member_info == nil then
		resp.retcode = G_ERRCODE["MAFIA_KICKOUT_NO_ROLE"]
		player:SendToClient(SerializeCommand(resp))
		player:Log("OnCommand_MafiaChangeMenberPosition, error=MAFIA_KICKOUT_NO_ROLE")
		return
	end

	--没有做任何的修改，有什么好做的
	if member_info._position == arg.position then
		resp.retcode = G_ERRCODE["MAFIA_POSITION_NO_CHANGE"]
		player:SendToClient(SerializeCommand(resp))
		player:Log("OnCommand_MafiaChangeMenberPosition, error=MAFIA_POSITION_NO_CHANGE")
		return
	end

	if arg.position ~= G_MAFIA_POSITION["PINGMIN"] then
		--查看职位的人数。
		local league_level_info = ed:FindBy("league_level", mafia_info._level)

		local position_num = 0
		local member_map_info_it = mafia_info._member_map:SeekToBegin()
		local member_map_info = member_map_info_it:GetValue()
		while member_map_info ~= nil do
			if member_info._position == arg.position then
				position_num = position_num + 1
			end

			member_map_info_it:Next()
			member_map_info = member_map_info_it:GetValue()
		end

		--判断是否达到了最多人数
		local max_num = 0
		for pos_info in DataPool_Array(league_level_info.pos_info) do
			if pos_info.type_id == 0 then
				break
			end

			if pos_info.type_id == arg.position then
				max_num = pos_info.max_num
				break
			end
		end

		if position_num >= max_num then
			resp.retcode = G_ERRCODE["MAFIA_POSITION_MAX_NUM"]
			player:SendToClient(SerializeCommand(resp))
			player:Log("OnCommand_MafiaChangeMenberPosition, error=MAFIA_POSITION_MAX_NUM")
			return
		end
	end

	--给这个玩家任命
	if member_info._position > arg.position then
		if dest_role ~= nil then
			--给这个玩家发送职位任命的邮件
			local msg = NewMessage("SendMail")
			msg.mail_id = 1800
			msg.arg1 = league_position_info.name
			player:SendMessage(dest_role._roledata._base._id, SerializeMessage(msg))
		end
	end
	member_info._position = arg.position

	--广播给所有的玩家信息变化
	MAFIA_MafiaUpdateMember(mafia_info, member_info)
	
	--查看玩家是否被加载进来了
	if dest_role ~= nil then
		dest_role._roledata._mafia._position = arg.position
		MAFIA_UpdateSelfInfo(dest_role)

		if dest_role._roledata._mafia._position == G_MAFIA_POSITION["BANGZHU"] then
			ROLE_UpdateBadge(role, 1, 1, 1)
		elseif dest_role._roledata._mafia._position == G_MAFIA_POSITION["JUNSHI"] then
			ROLE_UpdateBadge(role, 1, 2, 1)
		end
	end

	resp.retcode = G_ERRCODE["SUCCESS"]
	player:SendToClient(SerializeCommand(resp))
	return
end
