function OnCommand_MafiaKickout(player, role, arg, others)
	player:Log("OnCommand_MafiaKickout, "..DumpTable(arg))

	--把某一个玩家踢出去帮会,这里需要注意被踢出去的玩家不一定可以找到
	--所以要以帮会中的信息为准，只要可以找到，就可以把他踢掉，
	--然后如果当前可以找到玩家的话就重置玩家的信息，
	--要是没有找到的话，就等玩家自己上线的时候去重置信息
	local mafia_data = others.mafias[role._roledata._mafia._id:ToStr()]
	local dest_role = others.roles[arg.role_id]
	local resp = NewCommand("MafiaKickout_Re")

	--首先不可以自己踢出自己的
	if arg.role_id == role._roledata._base._id:ToStr() then
		resp.retcode = G_ERRCODE["MAFIA_KICKOUT_NO_SELF"]
		player:SendToClient(SerializeCommand(resp))
		return
	end

	if mafia_data == nil then
		resp.retcode = G_ERRCODE["NO_MAFIA"]
		player:SendToClient(SerializeCommand(resp))
		return
	end

	local mafia_info = mafia_data._data

	if role._roledata._mafia._position ~= G_MAFIA_POSITION["BANGZHU"] and role._roledata._mafia._position ~= G_MAFIA_POSITION["JUNSHI"] then
		resp.retcode = G_ERRCODE["MAFIA_SET_LEVEL_ERR"]
		player:SendToClient(SerializeCommand(resp))
		return
	end

	--查看当前帮会中是否有这个玩家
	local find_member = mafia_info._member_map:Find(CACHE.Int64(arg.role_id))
	if find_member == nil then
		resp.retcode = G_ERRCODE["MAFIA_KICKOUT_NO_ROLE"]
		player:SendToClient(SerializeCommand(resp))
		return
	end

	--查看自己是否有权限踢出这个玩家
	if role._roledata._mafia._position >= find_member._position then
		resp.retcode = G_ERRCODE["MAFIA_KICKOUT_NO_POWER"]
		player:SendToClient(SerializeCommand(resp))
		return
	end

	--在这里直接把这个玩家删除掉然后广播给帮会中的人
	mafia_info._member_map:Delete(CACHE.Int64(arg.role_id))

	MAFIA_MafiaDelMember(mafia_info, CACHE.Int64(arg.role_id))

	--在这里查看是否找到了这个玩家，找到了的话就进行操作，没有找到就不用管了
	if dest_role ~= nil then
		dest_role._roledata._mafia._create_time = 0
		dest_role._roledata._mafia._id:Set("0")
		dest_role._roledata._mafia._name = ""
		dest_role._roledata._mafia._position = 0
		dest_role._roledata._mafia._invites:Clear()
		dest_role._roledata._mafia._apply_mafia:Clear()
		MAFIA_UpdateSelfInfo(dest_role)
		TASK_ChangeCondition(dest_role, G_ACH_TYPE["MAFIA_QUIT"], 0, -1)

		--查看这个玩家的马术积分，如果不是0的话，需要去删除掉这个玩家的这个信息
		if dest_role._roledata._mashu_info._today_max_score > 0 then
			local msg = NewMessage("TestDeleteTop")
			msg.id = mafia_info._mashu_toplist_id
			API_SendMsg(dest_role._roledata._base._id:ToStr(), SerializeMessage(msg), 0)
		end

		--给这个玩家发送被踢出去的邮件
		local msg = NewMessage("SendMail")
		msg.mail_id = 1801
		player:SendMessage(dest_role._roledata._base._id, SerializeMessage(msg))
	end
end
