function OnCommand_AudienceGetList_Re(player, role, arg, others)
	API_Log("OnCommand_AudienceGetList_Re, "..DumpTable(arg).." "..DumpTable(others))

	for i = 1, table.getn(arg._fight_info) do
		API_Log("11111111111111111111111    "..arg._fight_info[i].room_id)
		API_Log("11111111111111111111111    "..arg._fight_info[i].fight1_id)
		API_Log("11111111111111111111111    "..arg._fight_info[i].fight2_id)
		API_Log("11111111111111111111111    "..arg._fight_info[i].fight1_name)
		API_Log("11111111111111111111111    "..arg._fight_info[i].fight2_name)
	end
end
