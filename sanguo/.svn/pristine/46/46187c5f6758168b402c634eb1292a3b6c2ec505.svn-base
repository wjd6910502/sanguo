function OnMessage_ReloadLua(playermap, arg)
	API_Log("OnMessage_ReloadLua, "..DumpTable(arg))

	API_ReloadLua()

	--local version_info = API_GetLuaVersion_Info()
	----设置版本的信息
	--local version_data = version_info._data._version_info
	--version_data:Clear()
	--for key, value in pairs(G_VERSION_INFO) do

	--	local find_version_info = version_data:Find(key)
	--	if find_version_info == nil then
	--		local insert_list = CACHE.VersionDataList()
	--		version_data:Insert(key, insert_list)
	--	end

	--	for i = 1, table.getn(value) do
	--		find_version_info = version_data:Find(key)
	--		local insert_data = CACHE.VersionData()
	--		insert_data._exe_ver = value[i].exe_ver
	--		insert_data._res_ver = value[i].res_ver
	--		find_version_info:PushBack(insert_data)
	--	end
	--end
end
