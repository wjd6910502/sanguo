function OnCommand_DelBlackList(player, role, arg, others)
	player:Log("OnCommand_DelBlackList, "..DumpTable(arg).." "..DumpTable(others))

	local blacklist = role._roledata._friend._blacklist

	local index = CACHE.Int64()
	index:Set(arg.roleid)

	local value = blacklist:Find(index)

	if value == nil then
		local cmd = NewCommand("ErrorInfo")
		cmd.error_id = G_ERRCODE["BLACKLIST_HAVE"]
		role:SendToClient(SerializeCommand(cmd))
		return
	end

	blacklist:Delete(index)

	local resp = NewCommand("DelBlackList_Re")
	resp.roleid = arg.roleid
	role:SendToClient(SerializeCommand(resp))
	return
end
