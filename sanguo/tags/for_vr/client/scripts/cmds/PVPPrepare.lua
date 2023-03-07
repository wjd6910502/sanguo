function OnCommand_PVPPrepare(player, role, arg, others)
	API_Log("OnCommand_PVPPrepare, "..DumpTable(arg))

	g_pvp_id = arg.id

	if g_role_id==arg.player1.id then
		g_opponent_id=arg.player2.id
		g_i_am_player1 = true
	end
	if g_role_id==arg.player2.id then
		g_opponent_id=arg.player1.id
		g_i_am_player1 = false
	end

	API_TryMakeHole(arg.p2p_magic, arg.p2p_peer_ip, arg.p2p_peer_port)
end
