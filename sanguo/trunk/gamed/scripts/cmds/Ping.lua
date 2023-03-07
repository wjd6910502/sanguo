function OnCommand_Ping(player, role, arg, others)
	--player:Log("OnCommand_Ping, "..DumpTable(arg))

	--local ed = DataPool_Find("elementdata")
	--local drop_item = ed:FindBy("drop_id",8088)
	--if drop_item~=nil then
	--	API_Log("xxxxxxxxxxxxxxxxxxxxxxxxxx "..drop_item.bonus_set[1].array_id)
	--	API_Log("xxxxxxxxxxxxxxxxxxxxxxxxxx "..drop_item.bonus_set[1].chance_origin)
	--end

	--local msg = NewMessage("CheckClientVersion")
	--player:SendMessage(role._roledata._base._id, SerializeMessage(msg))

	local resp = NewCommand("Ping_Re")
	resp.client_send_time = arg.client_send_time
	player:SendToClient(SerializeCommand(resp))
end
