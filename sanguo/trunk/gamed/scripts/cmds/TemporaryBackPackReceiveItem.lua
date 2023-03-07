function OnCommand_TemporaryBackPackReceiveItem(player, role, arg, others)
	player:Log("OnCommand_TemporaryBackPackReceiveItem, "..DumpTable(arg).." "..DumpTable(others))

	local resp = NewCommand("TemporaryBackPackReceiveItem_Re")
	resp.id = arg.id

	local backpack_info = role._roledata._temporary_backpack._data:Find(arg.id)
	if backpack_info == nil then
		player:SendToClient(SerializeCommand(resp))
		resp.retcode = G_ERRCODE["TEMPORARY_NO_ID"]
		player:Log("OnCommand_TemporaryBackPackReceiveItem, error=TEMPORARY_NO_ID")
		return
	end

	local iteminfo_it = backpack_info._iteminfo:SeekToBegin()
	local iteminfo = iteminfo_it:GetValue()
	while iteminfo ~= nil do
		BACKPACK_AddItem(role, iteminfo._tid, iteminfo._count)

		iteminfo_it:Next()
		iteminfo = iteminfo_it:GetValue()
	end

	role._roledata._temporary_backpack._data:Delete(arg.id)
	resp.retcode = G_ERRCODE["SUCCESS"]
	player:SendToClient(SerializeCommand(resp))
end
