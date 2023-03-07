function OnCommand_PvpCancle(player, role, arg, others)
	player:Log("OnCommand_PvpCancle, "..DumpTable(arg).." "..DumpTable(others))

	if role._roledata._status._pvp_join_flag == 1 then
		role._roledata._status._pvp_join_flag = 0
		role._roledata._pvp._typ = 0
		role._roledata._pvp._id = 0
		role._roledata._pvp._state = 0

		local resp = NewCommand("PvpCancle_Re")
		resp.retcode = arg.retcode
		player:SendToClient(SerializeCommand(resp))
		return
	end
	role:SendPVPCancle()
end
