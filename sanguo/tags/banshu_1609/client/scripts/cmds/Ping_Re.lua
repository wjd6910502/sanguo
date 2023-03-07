function OnCommand_Ping_Re(player, role, arg, others)
	API_Log("OnCommand_Ping_Re, "..DumpTable(arg).." rtt="..(API_GetTime2()-arg.client_send_time).." MillSeconds")
end
