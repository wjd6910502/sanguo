function OnCommand_PvpSpeed(player, role, arg, others)
	player:Log("OnCommand_PvpSpeed, "..DumpTable(arg).." "..DumpTable(others))

	role:SendPVPSpeed(arg.speed)
end
