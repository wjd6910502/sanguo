function OnMessage_CreateMafiaResult(player, role, arg, others)
	player:Log("OnMessage_CreateMafiaResult, "..DumpTable(arg).." "..DumpTable(others))

	local resp = NewCommand("MafiaCreate_Re")

	if arg.retcode == 0 then
		if role._roledata._mafia._id:ToStr()~="0" then
			resp.retcode = G_ERRCODE["MAFIA_HAVE"]
			player:SendToClient(SerializeCommand(resp))
			role._roledata._mafia._create_time = 0
			return
		elseif role._roledata._mafia._create_time ~= arg.create_time then
			--在这里什么都不做就可以了,因为肯定还会有下一个消息进来的，下一个消息进来的时候再做进一步的处理
			return
		end

		--马术排行榜
		local topdata = API_GetLuaTopList()._data
		local top = topdata._top_data
		
		local id = API_Mafia_AllocId()

		local data = CACHE.MafiaData()
		data._id = id
		data._name = arg.name
		data._level = 1
		data._boss_id = role._roledata._base._id
		data._boss_name = role._roledata._base._name
		data._mashu_toplist_id = topdata._top_list_type

		local member = CACHE.MafiaMember()
		member._id = role._roledata._base._id
		member._name = role._roledata._base._name
		member._photo = role._roledata._base._photo
		member._level = role._roledata._status._level
		member._zhanli = role._roledata._status._zhanli
		member._position = G_MAFIA_POSITION["BANGZHU"]
		member._online = role._roledata._status._online
		member._join_time = API_GetTime()
		data._member_map:Insert(member._id, member)

		resp.retcode = G_ERRCODE["SUCCESS"]
		resp.mafia = MAFIA_MakeMafia(data)
		player:SendToClient(SerializeCommand(resp))

		role._roledata._mafia._create_time = 0
		role._roledata._mafia._id = id
		role._roledata._mafia._name = arg.name
		role._roledata._mafia._position = member._position
		role._roledata._mafia._invites:Clear()
		role._roledata._mafia._apply_mafia:Clear()
		API_Mafia_Insert(id, data)
		
		local top_list = CACHE.TopList()
		top_list._top_list_type = topdata._top_list_type
		top:Insert(topdata._top_list_type, top_list)
		topdata._top_list_type = topdata._top_list_type + 1

		--判断自己的马术积分，如果马术积分不为0的话，给自己发一个消息，让自己的马术积分上帮会的马术积分排行榜
		if role._roledata._mashu_info._today_max_score > 0 then
			local msg = NewMessage("RoleUpdateInfoMafiaTop")
			msg.typ_id = data._mashu_toplist_id
			msg.data = role._roledata._mashu_info._today_max_score
			player:SendMessage(role._roledata._base._id, SerializeMessage(msg))
		end

		--更新帮会的信息到简易帮会表中去
		local msg = NewMessage("UpdateMafiaInfoTop")
		msg.level_flag = 0
		msg.id = data._id:ToStr()
		msg.name = data._name
		msg.announce = data._announce
		msg.level = data._level
		msg.boss_id = data._boss_id:ToStr()
		msg.boss_name = data._boss_name
		msg.level_limit = data._level_limit
		msg.num = 1
		player:SendMessage(CACHE.Int64(0), SerializeMessage(msg))

		--更新自己的帮会信息给客户端
		MAFIA_UpdateSelfInfo(role)

	elseif arg.retcode == 3 then
		role._roledata._mafia._create_time = 0
		resp.retcode = G_ERRCODE["MAFIA_NAME_USED"]
		player:SendToClient(SerializeCommand(resp))
		return
	else
		role._roledata._mafia._create_time = 0
		resp.retcode = G_ERRCODE["MAFIA_NAME_USED"]
		player:SendToClient(SerializeCommand(resp))
		return
	end

end
