function OnMessage_CheckClientVersion(player, role, arg, others)
	player:Log("OnMessage_CheckClientVersion, "..DumpTable(arg).." "..DumpTable(others))

	local client_ver = role._roledata._client_ver

	local client_ver_limit = others.misc._miscdata._client_ver_limit_map:Find(client_ver._client_id)
	if client_ver_limit==nil then return end --û�ж�Ӧ�ð汾�����ƹ���Ͳ�����

	if client_ver._exe_ver<client_ver_limit._exe_ver_min then --TODO: �汾�жϹ���
		player:KickoutSelf(G_KICKOUT_REASON["EXE_OUT_OF_DATE"])
		return
	end

	if client_ver._data_ver<client_ver_limit._data_ver_min then
		player:KickoutSelf(G_KICKOUT_REASON["DATA_OUT_OF_DATE"])
		return
	end
end
