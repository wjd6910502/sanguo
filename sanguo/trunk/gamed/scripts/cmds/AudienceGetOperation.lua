function OnCommand_AudienceGetOperation(player, role, arg, others)
	player:Log("OnCommand_AudienceGetOperation, "..DumpTable(arg).." "..DumpTable(others))

	if role._roledata._status._time_line == G_ROLE_STATE["YUEZHAN"] then
		local resp = NewCommand("AudienceGetOperation_Re")
		resp.retcode = G_ERRCODE["YUEZHAN_BATTLE_STATE"]
		player:SendToClient(SerializeCommand(resp))
		player:Log("OnCommand_AudienceGetOperation, error=YUEZHAN_BATTLE_STATE")
		return
	end

	role:AudienceGetRoomInfo(arg.room_id)
end
