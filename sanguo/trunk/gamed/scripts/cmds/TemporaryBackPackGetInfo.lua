function OnCommand_TemporaryBackPackGetInfo(player, role, arg, others)
	player:Log("OnCommand_TemporaryBackPackGetInfo, "..DumpTable(arg).." "..DumpTable(others))

	local resp = NewCommand("TemporaryBackPackGetInfo_Re")
	resp.items = {}
	local backpack_info_it = role._roledata._temporary_backpack._data:SeekToBegin()
	local backpack_info = backpack_info_it:GetValue()
	while backpack_info ~= nil do
		local tmp_backpack_info = {}
		tmp_backpack_info.id = backpack_info._id
		tmp_backpack_info.typ = backpack_info._typ
		tmp_backpack_info.items = {}

		local iteminfo_it = backpack_info._iteminfo:SeekToBegin()
		local iteminfo = iteminfo_it:GetValue()
		while iteminfo ~= nil do
			local tmp_item = {}
			tmp_item.tid = iteminfo._tid
			tmp_item.count = iteminfo._count
			tmp_backpack_info.items[#tmp_backpack_info.items+1] = tmp_item

			iteminfo_it:Next()
			iteminfo = iteminfo_it:GetValue()
		end

		resp.items[#resp.items+1] = tmp_backpack_info
		backpack_info_it:Next()
		backpack_info = backpack_info_it:GetValue()
	end
	player:SendToClient(SerializeCommand(resp))
end
