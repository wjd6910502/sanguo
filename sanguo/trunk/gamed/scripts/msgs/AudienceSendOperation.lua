function OnMessage_AudienceSendOperation(player, role, arg, others)
--	player:Log("OnMessage_AudienceSendOperation, "..DumpTable(arg).." "..DumpTable(others))

	API_Log("OnMessage_AudienceSendOperation          ..."..arg.operation)
	player:Log("OnMessage_AudienceSendOperation,      OnMessage_AudienceSendOperation       OnMessage_AudienceSendOperation")
	local resp = NewCommand("AudienceSendOperation")
	resp.room_id = arg.room_id

	local is_idx,operation = DeserializeStruct(arg.operation, 1, "PvpVideo")
	resp.operation = {}
	resp.operation.video = {}
	for i = 1, table.getn(operation.video) do
		resp.operation.video[#resp.operation.video+1] = operation.video[i]
	end

	player:SendToClient(SerializeCommand(resp))
end
