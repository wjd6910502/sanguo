function OnCommand_ListFriends_Re(player, role, arg, others)
	API_Log("OnCommand_ListFriends_Re, "..DumpTable(arg))

	g_got_ListFriends_Re = true

	for _,v in ipairs(arg.friends)
	do
		g_friends[v.id] = v.name
	end

	for _,v in ipairs(arg.requests)
	do
		g_requests[v.id] = v.name
	end
end
