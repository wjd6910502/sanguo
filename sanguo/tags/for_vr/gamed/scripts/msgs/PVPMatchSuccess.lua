function OnMessage_PVPMatchSuccess(player, role, arg, others)
	player:Log("OnMessage_PVPMatchSuccess, "..DumpTable(arg).." "..DumpTable(others))

	if role._roledata._pvp._state == 0 then 
		return
	end
	--在这里就给客户端发送协议告诉他匹配成功了
	local resp = NewCommand("PvpMatchSuccess")
	role._roledata._pvp._id = arg.index
	role._roledata._pvp_info._pvp_time = math.floor((role._roledata._pvp_info._pvp_time + arg.time)/2)

	resp.retcode = arg.retcode
	resp.index = arg.index
	player:SendToClient(SerializeCommand(resp))
end
