function OnMessage_UpdateMafiaInfoTop(arg, others)
	API_Log("OnMessage_UpdateMafiaInfoTop, "..DumpTable(arg))

	local mafia_info = others.mafia_info
	
	if arg.level_flag == 1 then
		local last_level = arg.level - 1

		local mafia_level_info = mafia_info._data._mafia_info:Find(last_level)
		local del_id = CACHE.Int64()
		del_id:Set(arg.id)
		mafia_level_info._info:Delete(del_id)
	end

	local mafia_level_info = mafia_info._data._mafia_info:Find(arg.level)
	if mafia_level_info == nil then
		local insert_mafia_info_list = CACHE.Mafia_InfoMapData()
		insert_mafia_info_list._level = arg.level
		local insert_mafia_info = CACHE.Mafia_Info()
		
		insert_mafia_info._id:Set(arg.id)
		insert_mafia_info._name = arg.name
		insert_mafia_info._announce = arg.announce
		insert_mafia_info._declaration = arg.declaration
		insert_mafia_info._level = arg.level
		insert_mafia_info._boss_id:Set(arg.boss_id)
		insert_mafia_info._boss_name = arg.boss_name
		insert_mafia_info._level_limit = arg.level_limit
		insert_mafia_info._num = arg.num

		insert_mafia_info_list._info:Insert(insert_mafia_info._id, insert_mafia_info)

		mafia_info._data._mafia_info:Insert(arg.level, insert_mafia_info_list)
	else
		--判断是否已经插入了
		local find_info = mafia_level_info._info:Find(CACHE.Int64(arg.id))
		if find_info == nil then
			local insert_mafia_info = CACHE.Mafia_Info()
			
			insert_mafia_info._id:Set(arg.id)
			insert_mafia_info._name = arg.name
			insert_mafia_info._announce = arg.announce
			insert_mafia_info._declaration = arg.declaration
			insert_mafia_info._level = arg.level
			insert_mafia_info._boss_id:Set(arg.boss_id)
			insert_mafia_info._boss_name = arg.boss_name
			insert_mafia_info._level_limit = arg.level_limit
			insert_mafia_info._num = arg.num

			mafia_level_info._info:Insert(insert_mafia_info._id, insert_mafia_info)
		else
			find_info._announce = arg.announce
			find_info._declaration = arg.declaration
			find_info._level = arg.level
			find_info._boss_id:Set(arg.boss_id)
			find_info._boss_name = arg.boss_name
			find_info._level_limit = arg.level_limit
			find_info._num = arg.num
		end
	end
end
