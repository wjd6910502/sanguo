function OnMessage_PVPMatchSuccess(player, role, arg, others)
	player:Log("OnMessage_PVPMatchSuccess, "..DumpTable(arg).." "..DumpTable(others))

	if role._roledata._pvp._state == 0 then 
		return
	end

	local resp = NewCommand("PvpMatchSuccess")
	role._roledata._pvp._id = arg.index

	resp.retcode = arg.retcode
	resp.index = arg.index

	if arg.room_id == 0 then
		role._roledata._pvp_info._pvp_time = math.floor((role._roledata._pvp_info._pvp_time + arg.time)/2)
	end
	--else
	--	local yuezhan_info = others.yuezhan_info._data
	--	local yuezhan_data = yuezhan_info._yuezhan_info:Find(arg.room_id)
	--	
	--	if yuezhan_data._center_id == 0 then
	--		yuezhan_data._center_id = arg.index
	--		--就可以在这里广播观看信息了
	--		local msg = NewMessage("YueZhanInfo")
	--		msg.channel = yuezhan_data._channel
	--		msg.typ = 3
	--		msg.info_id = arg.index
	--		msg.creater = {}
	--		msg.joiner = {}
	--		msg.creater.id = yuezhan_data._create_id:ToStr()
	--		msg.creater.name = yuezhan_data._create_name
	--		msg.joiner.id = yuezhan_data._join_id:ToStr()
	--		msg.joiner.name = yuezhan_data._join_name

	--		player:SendMessageToAllRole(SerializeMessage(msg))
	--	end
	--end
	
	player:SendToClient(SerializeCommand(resp))
end
