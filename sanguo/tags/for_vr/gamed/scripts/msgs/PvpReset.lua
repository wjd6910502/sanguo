function OnMessage_PvpReset(player, role, arg, others)
	player:Log("OnMessage_PvpReset, "..DumpTable(arg).." "..DumpTable(others))

	if arg.retcode == 0 then
		role._roledata._pvp._typ = 0
		role._roledata._pvp._id = 0
		role._roledata._pvp._state = 0
	elseif arg.retcode == 1 then
		if role._roledata._pvp._state ~= 0 then
			local resp = NewCommand("PVPError")
			resp.result = G_ERRCODE["PVP_STATE_ERROR"]
			player:SendToClient(SerializeCommand(resp))
		end
		
		role._roledata._pvp._typ = 0
		role._roledata._pvp._id = 0
		role._roledata._pvp._state = 0
	end
end
