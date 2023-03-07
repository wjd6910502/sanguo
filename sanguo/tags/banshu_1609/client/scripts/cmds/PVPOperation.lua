function OnCommand_PVPOperation(player, role, arg, others)
	--API_Log("OnCommand_PVPOperation, "..DumpTable(arg))

	if arg.client_tick>g_received_client_tick_max_p2p then g_received_client_tick_max_p2p=arg.client_tick end

	if g_i_am_player1 then
		g_player2_hash_p2p = g_player2_hash_p2p*33 + arg.op
		if g_player2_hash_p2p>=65536 then g_player2_hash_p2p=g_player2_hash_p2p%65536 end
	else
		g_player1_hash_p2p = g_player1_hash_p2p*33 + arg.op
		if g_player1_hash_p2p>=65536 then g_player1_hash_p2p=g_player1_hash_p2p%65536 end
	end
end
