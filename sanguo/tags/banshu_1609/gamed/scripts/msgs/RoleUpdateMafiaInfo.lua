function OnMessage_RoleUpdateMafiaInfo(mafia, arg, others)
	API_Log("OnMessage_RoleUpdateMafiaInfo, "..DumpTable(arg).." "..DumpTable(others))

	local mafia_info = mafia._data
	local member_info = mafia_info._member_map:Find(CACHE.Int64(arg.roleid))
	if member_info ~= nil then
		member_info._level = arg.level
		member_info._zhanli = arg.zhanli
		if member_info._online == 1 and arg.online == 0 then
			member_info._logout_time = API_GetTime()
		elseif member_info._online == 0 and arg.online == 1 then
			member_info._logout_time = 0
		end
		member_info._online = arg.online
		MAFIA_MafiaUpdateMember(mafia_info, member_info)
	end
end
