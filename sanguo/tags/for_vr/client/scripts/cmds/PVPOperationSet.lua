function OnCommand_PVPOperationSet(player, role, arg, others)
	--API_Log("OnCommand_PVPOperationSet, "..DumpTable(arg))

	if arg.client_tick>g_received_client_tick_max then g_received_client_tick_max=arg.client_tick end

	g_player1_hash = g_player1_hash*33 + arg.player1_op
	if g_player1_hash>=65536 then g_player1_hash=g_player1_hash%65536 end

	g_player2_hash = g_player2_hash*33 + arg.player2_op
	if g_player2_hash>=65536 then g_player2_hash=g_player2_hash%65536 end
end
