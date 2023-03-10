function OnMessage_YueZhanEnd(player, role, arg, others)
	player:Log("OnMessage_YueZhanEnd, "..DumpTable(arg).." "..DumpTable(others))
	
	if role._roledata._pvp._state == 0 then
		return
	end

	--if role._roledata._status._time_line ~= G_ROLE_STATE["YUEZHAN"] then
	--	return
	--end

	role._roledata._pvp._typ = 0
	role._roledata._pvp._id = 0
	role._roledata._pvp._state = 0
	local resp = NewCommand("PVPEnd")

	resp.result = arg.reason
	resp.typ = arg.typ
	resp.pvp_typ = 2
	resp.star = 0
	resp.win_count = 0

	player:SendToClient(SerializeCommand(resp))

	role._roledata._status._time_line = G_ROLE_STATE["FREE"]

	--设置约战房间的信息
	local yuezhan_info = others.yuezhan_info._data
	local yuezhan_data = yuezhan_info._yuezhan_info:Find(arg.room_id)
	if yuezhan_data==nil then
		--FIXME: 已经被YueZhanUpdateState抢先删掉了
		player:Err("OnMessage_YueZhanEnd, yuezhan_data==nil, "..DumpTable(arg).." "..DumpTable(others))
		return
	end

	if arg.video_flag == 1 then
		if 4 > yuezhan_data._typ then
			yuezhan_data._typ = 4
			--就可以在这里广播观看信息了
			local msg = NewMessage("YueZhanInfo")
			msg.id = arg.room_id
			msg.channel = yuezhan_data._channel
			msg.typ = yuezhan_data._typ
			msg.info_id = yuezhan_data._center_id
			msg.creater = {}
			msg.joiner = {}
			msg.creater.id = yuezhan_data._create_id:ToStr()
			msg.creater.name = yuezhan_data._create_name
			msg.joiner.id = yuezhan_data._join_id:ToStr()
			msg.joiner.name = yuezhan_data._join_name
			if yuezhan_data._channel == 2 then
				API_SendMessageToAllRole(SerializeMessage(msg), CACHE.Int64List(), CACHE.Int64List(), CACHE.IntList())
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
		end
	else
		if yuezhan_data ~= nil then
			--就可以在这里广播观看信息了
			local msg = NewMessage("YueZhanInfo")
			msg.id = arg.room_id
			msg.channel = yuezhan_data._channel
			msg.typ = 6
			msg.info_id = yuezhan_data._center_id
			msg.creater = {}
			msg.joiner = {}
			msg.creater.id = yuezhan_data._create_id:ToStr()
			msg.creater.name = yuezhan_data._create_name
			msg.joiner.id = yuezhan_data._join_id:ToStr()
			msg.joiner.name = yuezhan_data._join_name

			if yuezhan_data._channel == 2 then
				API_SendMessageToAllRole(SerializeMessage(msg), CACHE.Int64List(), CACHE.Int64List(), CACHE.IntList())
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
			--如果没有录像就直接删除掉这个房间的信息
			yuezhan_info._yuezhan_info:Delete(arg.room_id)
		end
	end
end
