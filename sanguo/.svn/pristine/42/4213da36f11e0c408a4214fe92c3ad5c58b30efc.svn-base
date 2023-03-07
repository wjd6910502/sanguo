function OnCommand_MafiaList(player, role, arg, others)
	player:Log("OnCommand_MafiaList, "..DumpTable(arg).." "..DumpTable(others))

	--这里拿到的是简单的帮会信息
	local resp = NewCommand("MafiaList_Re")
	resp.retcode = G_ERRCODE["SUCCESS"]
	resp.mafia_info = {}
	local mafia_info = others.mafia_info

	local mafia_level_list_it = mafia_info._data._mafia_info:SeekToLast()
	local mafia_level_list = mafia_level_list_it:GetValue()
	while mafia_level_list ~= nil do
		local mafia_data_it = mafia_level_list._info:SeekToBegin()
		local mafia_data = mafia_data_it:GetValue()
		while mafia_data ~= nil do
			local tmp_mafia_info = {}
			tmp_mafia_info.id = mafia_data._id:ToStr()
			tmp_mafia_info.name = mafia_data._name
			tmp_mafia_info.announce = mafia_data._announce
			tmp_mafia_info.level = mafia_data._level
			tmp_mafia_info.boss_id = mafia_data._boss_id:ToStr()
			tmp_mafia_info.boss_name = mafia_data._boss_name
			tmp_mafia_info.level_limit = mafia_data._level_limit
			tmp_mafia_info.num = mafia_data._num
			tmp_mafia_info.xuanyan = mafia_data._declaration

			resp.mafia_info[#resp.mafia_info+1] = tmp_mafia_info
			mafia_data_it:Next()
			mafia_data = mafia_data_it:GetValue()
		end

		mafia_level_list_it:Prev()
		mafia_level_list = mafia_level_list_it:GetValue()
	end

	player:SendToClient(SerializeCommand(resp))
end
