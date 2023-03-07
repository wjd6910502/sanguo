function OnMessage_TestMafiaLevelUp(player, role, arg, others)
	player:Log("OnMessage_TestMafiaLevelUp, "..DumpTable(arg).." "..DumpTable(others))

	local mafia_data = others.mafias[role._roledata._mafia._id:ToStr()]
	local mafia_info = mafia_data._data

	mafia_info._level = mafia_info._level + 1
	--更新帮会的信息到简易帮会表中去
	MAFIA_MafiaUpdateInfoTop(mafia_info, 1)
end
