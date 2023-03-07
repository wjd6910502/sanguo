function OnCommand_AudienceGetOperation(player, role, arg, others)
	player:Log("OnCommand_AudienceGetOperation, "..DumpTable(arg).." "..DumpTable(others))

	role:AudienceGetRoomInfo(arg.room_id)
end
