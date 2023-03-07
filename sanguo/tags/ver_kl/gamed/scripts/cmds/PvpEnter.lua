function OnCommand_PvpEnter(player, role, arg, others)
	player:Log("OnCommand_PvpEnter, "..DumpTable(arg).." "..DumpTable(others))

	if role._roledata._pvp._state == 0 then
		player:Log("OnCommand_PvpEnter, "..role._roledata._pvp._state)
		return
	end
	role:SendPVPEnter(arg.flag)
end
