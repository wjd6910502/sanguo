function OnCommand_GetBackPack(player, role, arg, others)
	player:Log("OnCommand_GetBackPack, "..DumpTable(arg))
	
	local resp = NewCommand("GetBackPack_Re")
	resp.info = {}
	local backpack = role._roledata._backpack._items
	local iit = backpack:SeekToBegin()
	local i = iit:GetValue()
	while i ~= nil do
		local item = {}
		item.tid = i._tid
		item.count = i._count
		resp.info[#resp.info+1] = item
		iit:Next()
		i = iit:GetValue()
	end
	resp.retcode = G_ERRCODE["SUCCESS"]
	player:SendToClient(SerializeCommand(resp))
end
