function OnMessage_RoleUpdateMafiaInfo(mafia, arg, others)
	API_Log("OnMessage_RoleUpdateMafiaInfo, "..DumpTable(arg).." "..DumpTable(others))

	local mafia_info = mafia._data
	local member_info = mafia_info._member_map:Find(CACHE.Int64(arg.roleid))
	if member_info ~= nil then
		member_info._level = arg.level
		member_info._zhanli = arg.zhanli
		member_info._name = arg.name
		if member_info._online == 1 and arg.online == 0 then
			member_info._logout_time = API_GetTime()
		elseif member_info._online == 0 and arg.online == 1 then
			member_info._logout_time = 0
		end
		member_info._online = arg.online
		member_info._photo = arg.photo
		member_info._photo_frame = arg.photo_frame
		member_info._badge_map:Clear()
		for i = 1, table.getn(arg.badge_info) do
			local tmp_badge = CACHE.BadgeInfo()
			tmp_badge._pos = arg.badge_info[i].typ
			tmp_badge._id = arg.badge_info[i].id

			member_info._badge_map:Insert(tmp_badge._pos, tmp_badge)
		end
		MAFIA_MafiaUpdateMember(mafia_info, member_info)
	end
end
