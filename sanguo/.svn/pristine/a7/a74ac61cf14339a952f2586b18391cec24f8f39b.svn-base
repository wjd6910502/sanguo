function OnCommand_YueZhanCancel(player, role, arg, others)
	player:Log("OnCommand_YueZhanCancel, "..DumpTable(arg).." "..DumpTable(others))

	local resp = NewCommand("YueZhanCancel_Re")
	resp.room_id = arg.room_id

	local yuezhan_info = others.yuezhan_info._data

	local yuezhan_data = yuezhan_info._yuezhan_info:Find(arg.room_id)
	if yuezhan_data == nil then
		resp.retcode = G_ERRCODE["YUEZHAN_ROOM_ERR"]
		player:SendToClient(SerializeCommand(resp))
		player:Log("OnCommand_YueZhanCancel, error=YUEZHAN_ROOM_ERR")
		return
	end

	--查看房间是否已经有人应战了
	if not yuezhan_data._join_id:Equal(0) then
		resp.retcode = G_ERRCODE["YUEZHAN_CANCLE_ROLE"]
		player:SendToClient(SerializeCommand(resp))
		player:Log("OnCommand_YueZhanCancel, error=YUEZHAN_CANCLE_ROLE")
		return
	end

	--查看是否是你发起的约战
	if yuezhan_data._create_id:ToStr() ~= role._roledata._base._id:ToStr() then
		resp.retcode = G_ERRCODE["YUEZHAN_CANCLE_NOT_CREATE"]
		player:SendToClient(SerializeCommand(resp))
		player:Log("OnCommand_YueZhanCancel, error=YUEZHAN_CANCLE_NOT_CREATE")
		return
	end

	--广播出去把这个约战的信息
	local msg = NewMessage("YueZhanInfo")
	msg.id = yuezhan_data._id
	msg.channel = yuezhan_data._channel
	msg.typ = 0

	if yuezhan_data._channel == 2 then
		player:SendMessageToAllRole(SerializeMessage(msg), G_CHECKSUM_M["YueZhanInfo"])
	elseif yuezhan_data._channel == 3 then
		local mafia_msg = NewMessage("MafiaYueZhan")
		mafia_msg.id = msg.id
		mafia_msg.channel = msg.channel
		mafia_msg.typ = msg.typ
		mafia_msg.announce = msg.announce
		mafia_msg.info_id = msg.info_id
		mafia_msg.creater = msg.creater
		mafia_msg.joiner = msg.joiner
		mafia_msg.time = msg.time
		API_SendMessage(yuezhan_data._mafia_id, SerializeMessage(mafia_msg), CACHE.Int64List(), CACHE.Int64List(), CACHE.IntList())
	end

	yuezhan_info._yuezhan_info:Delete(arg.room_id)

	resp.retcode = 0
	player:SendToClient(SerializeCommand(resp))

	--删除这个房间，重新设置玩家的状态
	role._roledata._pvp._state = 0
	role._roledata._pvp._typ = 0
	role._roledata._status._time_line = G_ROLE_STATE["FREE"]

end
