function OnMessage_RoleUpdatePveArenaInfo(player, role, arg, others)
	player:Log("OnMessage_RoleUpdatePveArenaInfo, "..DumpTable(arg).." "..DumpTable(others))

	local pve_arena = others.pvearena._data._pve_arena_data_map_data
	local role_score = role._roledata._pve_arena_info._score

	local pve_arena_it = pve_arena:SeekToBegin()
	local pve_arena_info = pve_arena_it:GetValue()
	while pve_arena_info ~= nil do
		if role_score >= pve_arena_info._begin_score and role_score <= pve_arena_info._end_score then
			local find_info = pve_arena_info._pve_arena_data_map:Find(role_score)
			local pve_arena_data_it = pve_arena_info._pve_arena_data_map:SeekToBegin()
			local pve_arena_data = pve_arena_data_it:GetValue()
			while pve_arena_data ~= nil do
				if pve_arena_data._score == role_score then
					local list_data_it = pve_arena_data._list_data:SeekToBegin()
					local list_data = list_data_it:GetValue()
					while list_data ~= nil do
						if list_data._role_id:ToStr() == role._roledata._base._id:ToStr() then
							list_data._level = role._roledata._status._level
							list_data._mafia_name = role._roledata._mafia._name
							return
						end
						list_data_it:Next()
						list_data = list_data_it:GetValue()
					end
				end

				pve_arena_data_it:Next()
				pve_arena_data = pve_arena_data_it:GetValue()
			end
		end
		pve_arena_it:Next()
		pve_arena_info = pve_arena_it:GetValue()
	end
	return
end
