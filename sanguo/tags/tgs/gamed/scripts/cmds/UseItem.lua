function OnCommand_UseItem(player, role, arg, others)
	API_Log("OnCommand_UseItem, "..DumpTable(arg).." "..DumpTable(others))

	local ed = DataPool_Find("elementdata")
	local item_info = ed:FindBy("item_id", arg.tid)
	
	local resp = NewCommand("UseItem_Re")

	if item_info == nil then
		resp.retcode = G_ERRCODE["NO_ITEM"]
		player:SendToClient(SerializeCommand(resp))
		return
	end

	--if item_info.item_type == 1 then
	--	--表示给武将加经验
	--	resp.retcode = HERO_AddExp(role, arg.hero_id, item_info.type_data1, arg.count)
	--	player:SendToClient(SerializeCommand(resp))
	--	return
	--else
	--	resp.retcode = G_ERRCODE["NO_ITEM_TYPE"]
	--	player:SendToClient(SerializeCommand(resp))
	--	return
	--end
end
