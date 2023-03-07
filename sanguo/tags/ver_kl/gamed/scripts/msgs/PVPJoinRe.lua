function OnMessage_PVPJoinRe(player, role, arg, others)
	player:Log("OnMessage_PVPJoinRe, "..DumpTable(arg).." "..DumpTable(others))

	if role._roledata._pvp._state == 0 then 
		return
	end
	local resp = NewCommand("PvpJoin_Re")
	--resp.retcode = arg.retcode
	resp.retcode = 0
	resp.time = role._roledata._pvp_info._pvp_time
	player:SendToClient(SerializeCommand(resp))
end
