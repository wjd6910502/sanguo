function OnMessage_AudienceFinishRoom(player, role, arg, others)
	player:Log("OnMessage_AudienceFinishRoom, "..DumpTable(arg).." "..DumpTable(others))

	local resp = NewCommand("AudienceFinishRoom")
	resp.room_id = arg.room_id
	resp.win_flag = arg.win_flag
	resp.reason = arg.reason

	local is_idx,operation = DeserializeStruct(arg.operation, 1, "PvpVideo")
	
	resp.operation = {}
	resp.operation.video = {}
	for i = 1, table.getn(operation.video) do
		resp.operation.video[#resp.operation.video+1] = operation.video[i]
	end

	player:SendToClient(SerializeCommand(resp))
end
