function OnMessage_PvpError(player, role, arg, others)
	player:Log("OnMessage_PvpError, "..DumpTable(arg).." "..DumpTable(others))
	
	if role._roledata._pvp._state == 0 then 
		return
	end
	
	if role._roledata._pvp._id ~= 0 then
		local resp = NewCommand("PVPError")
		resp.result = G_ERRCODE["PVP_STATE_ERROR"]
		player:SendToClient(SerializeCommand(resp))
	end
	role._roledata._pvp._typ = 0
	role._roledata._pvp._id = 0
	role._roledata._pvp._state = 0
end
