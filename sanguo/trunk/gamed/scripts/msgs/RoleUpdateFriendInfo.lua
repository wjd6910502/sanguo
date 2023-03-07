function OnMessage_RoleUpdateFriendInfo(player, role, arg, others)
	player:Log("OnMessage_RoleUpdateFriendInfo, "..DumpTable(arg).." "..DumpTable(others))

	--设置好友的信息，并且发给客户端

	local friend_info = role._roledata._friend._friends:Find(CACHE.Int64(arg.roleid))
	if friend_info ~= nil then
		friend_info._online = arg.online
		friend_info._zhanli = arg.zhanli
		friend_info._brief._level = arg.level
		friend_info._mashu_score = arg.mashu_score
		friend_info._brief._photo = arg.photo
		friend_info._brief._photo_frame = arg.photo_frame
		friend_info._brief._badge_map:Clear()
		if arg.name ~= "" then
			friend_info._brief._name = arg.name
		end

		for index = 1, table.getn(arg.badge_info) do
			local badge_info = CACHE.BadgeInfo()
			badge_info._id = arg.badge_info[index].id
			badge_info._pos = arg.badge_info[index].typ

			friend_info._brief._badge_map:Insert(badge_info._pos, badge_info)
		end

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
		resp.friend_info.photo_frame = friend_info._brief._photo_frame
		resp.friend_info.sex = friend_info._sex

		resp.friend_info.badge_info = arg.badge_info
		--local badge_info_it = friend_info._brief._badge_map:SeekToBegin()
		--local badge_info = badge_info_it:GetValue()
		--while badge_info ~= nil do
		--	local tmp_badge_info = {}
		--	tmp_badge_info.id = badge_info._id
		--	tmp_badge_info.typ = badge_info._pos
		--	resp.friend_info.badge_info[#resp.friend_info.badge_info+1] = tmp_badge_info

		--	badge_info_it:Next()
		--	badge_info = badge_info_it:GetValue()
		--end

		player:SendToClient(SerializeCommand(resp))
	end
end
