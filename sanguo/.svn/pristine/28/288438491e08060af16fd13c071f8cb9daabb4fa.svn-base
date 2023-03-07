function OnCommand_PVPPause_Re(player, role, arg, others)
	player:Log("OnCommand_PVPPause_Re, "..DumpTable(arg).." "..DumpTable(others))

	role:SendPVPPauseRe(arg.index)
	player:NetTime_Sync2Client()
end
