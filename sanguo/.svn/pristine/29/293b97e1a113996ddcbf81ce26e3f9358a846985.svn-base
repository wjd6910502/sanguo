function OnCommand_GetVPRefreshTime(player, role, arg, others)
	player:Log("OnCommand_GetVPRefreshTime, "..DumpTable(arg).." "..DumpTable(others))

	local resp = NewCommand("GetVPRefreshTime_Re")
	resp.refresh_time = role._roledata._status._vp_refreshtime

	player:SendToClient(SerializeCommand(resp))
end
