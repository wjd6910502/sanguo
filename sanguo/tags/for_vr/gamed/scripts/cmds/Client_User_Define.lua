function OnCommand_Client_User_Define(player, role, arg, others)
	player:Log("OnCommand_Client_User_Define, "..DumpTable(arg).." "..DumpTable(others))

	local user_key = role._roledata._user_define._define:Find(arg.user_key)
	if user_key == nil then
		local tmp = CACHE.RoleClientDefineData:new()
		tmp._value = arg.user_value
		tmp._id = arg.user_key

		role._roledata._user_define._define:Insert(arg.user_key, tmp)
	else
		user_key._value = arg.user_value
		user_key._id = arg.user_key
	end
end
