function OnCommand_AudienceGetList(player, role, arg, others)
	player:Log("OnCommand_AudienceGetList, "..DumpTable(arg).." "..DumpTable(others))

	--获得当前正在战斗的玩家信息
	role:AudienceGetAllList()
end
