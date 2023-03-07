function OnMessage_PvpCancle(player, role, arg, others)
	player:Log("OnMessage_PvpCancle, "..DumpTable(arg).." "..DumpTable(others))

	if role._roledata._pvp._state == 0 then 
		return
	end
	if arg.retcode == 0 then
		role._roledata._pvp._typ = 0
		role._roledata._pvp._id = 0
		role._roledata._pvp._state = 0
	end

	local resp = NewCommand("PvpCancle_Re")
	resp.retcode = arg.retcode
	player:SendToClient(SerializeCommand(resp))
end
