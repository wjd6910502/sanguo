function OnMessage_DelFriend(player, role, arg, others)
	player:Log("OnMessage_DelFriend, "..DumpTable(arg).." "..DumpTable(others))

	if role._roledata._friend._friends:Find(CACHE.Int64(arg.roleid)) ~= nil then
		role._roledata._friend._friends:Delete(CACHE.Int64(arg.roleid))
	end
	
	local resp = NewCommand("RemoveFriend_Re")

	resp.dest_id = arg.roleid
	resp.retcode = G_ERRCODE["SUCCESS"]
	player:SendToClient(SerializeCommand(resp))
end
