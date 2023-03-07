function OnCommand_FriendRequest(player, role, arg, others)
	API_Log("OnCommand_FriendRequest, "..DumpTable(arg))

	g_requests[arg.src.id] = arg.src.name
end
