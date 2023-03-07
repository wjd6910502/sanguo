function OnMessage_RoleUpdateFriendInfo(player, role, arg, others)
	player:Log("OnMessage_RoleUpdateFriendInfo, "..DumpTable(arg).." "..DumpTable(others))

	--设置好友的信息，并且发给客户端

	local friend_info = role._roledata._friend._friends:Find(CACHE.Int64(arg.roleid))
	if friend_info ~= nil then
		friend_info._online = arg.online
		friend_info._zhanli = arg.zhanli
		friend_info._brief._level = arg.level
		friend_info._mashu_score = arg.mashu_score

		local resp = NewCommand("FriendUpdateInfo")
		resp.friend_info = {}
		resp.friend_info.id = friend_info._brief._id:ToStr()
		resp.friend_info.name = friend_info._brief._name
		resp.friend_info.photo = friend_info._brief._photo
		resp.friend_info.level = friend_info._brief._level
		resp.friend_info.zhanli = friend_info._zhanli
		resp.friend_info.faction = friend_info._faction
		resp.friend_info.online = friend_info._online
		resp.friend_info.mashu_score = friend_info._mashu_score
	
		player:SendToClient(SerializeCommand(resp))
	end
end
