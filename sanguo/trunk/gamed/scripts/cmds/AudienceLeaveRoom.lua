function OnCommand_AudienceLeaveRoom(player, role, arg, others)
	player:Log("OnCommand_AudienceLeaveRoom, "..DumpTable(arg).." "..DumpTable(others))

	role:AudienceLeave(arg.room_id)
end
