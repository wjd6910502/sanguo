function OnCommand_ReportClientVersion(player, role, arg, others)
	player:Log("OnCommand_ReportClientVersion, "..DumpTable(arg).." "..DumpTable(others))
	
	local cur_pvp_ver = ROLE_GetPVPVersion(arg.client_id, arg.exe_ver, arg.data_ver)
	--等于-1的时候代表渠道错误
	--if cur_pvp_ver == -1 then
	--	player:KickoutSelf(G_KICKOUT_REASON["CLIENTID_ERR"])
	--	return
	--end

	role._roledata._client_ver._client_id = arg.client_id
	role._roledata._client_ver._exe_ver = arg.exe_ver
	role._roledata._client_ver._data_ver = arg.data_ver
	
	--role._roledata._client_ver._pvp_ver = cur_pvp_ver
	--role._roledata._client_ver._pvp_ver = 1

	--local msg = NewMessage("CheckClientVersion")
	--player:SendMessageToRole(role._roledata._base._id:ToStr(), SerializeMessage(msg))

	----这里玩家不一定有角色，所以不要使用消息
	--local client_ver_limit = others.misc._miscdata._client_ver_limit_map:Find(arg.client_id)
	--if client_ver_limit==nil then return end --没有对应该版本的限制规则就不限制

	--if arg.exe_ver<client_ver_limit._exe_ver_min then --TODO: 版本判断规则
	--	player:KickoutSelf(G_KICKOUT_REASON["EXE_OUT_OF_DATE"])
	--	return
	--end

	--if arg.data_ver<client_ver_limit._data_ver_min then
	--	player:KickoutSelf(G_KICKOUT_REASON["DATA_OUT_OF_DATE"])
	--	return
	--end
end
