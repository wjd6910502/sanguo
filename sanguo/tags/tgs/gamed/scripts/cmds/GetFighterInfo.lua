function OnCommand_GetFighterInfo(player, role, arg, others)
	player:Log("OnCommand_GetFighterInfo, "..DumpTable(arg).." "..DumpTable(others))

	local resp = NewCommand("GetFighterInfo_Re")
	local pve_arena = others.pvearena._data

	--首先根据自己的名次，然后选出自己对手的名次
	local fight_id = {}
	local all_num = pve_arena._all_num
	if all_num < 2 then
		resp.retcode = G_ERRCODE["JJC_PLAYER_LESS"]
		player:SendToClient(SerializeCommand(resp))
		return
	end
	local my_rank = PVEARENA_GetRank(pve_arena._pve_arena_data_map_data, role._roledata._base._id, role._roledata._pve_arena_info._score)

	if all_num >= 2 and all_num < 5 then
		for i = 1, all_num do
			if i ~= my_rank then
				table.insert(fight_id, i)
			end
		end
	elseif all_num >= 5 and all_num < 20 then
		while table.getn(fight_id) < 4 do
			
			local insert_num = math.random(all_num)
			
			local insert_flag = 1
			
			if insert_num == my_rank then
				insert_flag = 0
			else
				for i = 1, table.getn(fight_id) do
					if fight_id[i] == insert_num then
						insert_flag = 0
						break
					end
				end
			end

			if insert_flag == 1 then
				table.insert(fight_id, insert_num)
			end
		end
	else
		local random_little = {}
		local random_big = {}
		if my_rank <= 15 then
			random_little[#random_little+1] = 1
			random_little[#random_little+1] = 6
			random_little[#random_little+1] = 11
			random_little[#random_little+1] = 16

			random_big[#random_big+1] = 5
			random_big[#random_big+1] = 10
			random_big[#random_big+1] = 15
			random_big[#random_big+1] = 20
		else
			local mid_num = 0
			if my_rank > math.floor(all_num/1.4) then
				mid_num = math.floor(all_num/1.4*1.1)
			else
				mid_num = math.floor(my_rank*1.1)
			end

			local random_num = math.floor(mid_num/1.1*0.3)

			random_little[#random_little+1] = mid_num-random_num*3
			random_little[#random_little+1] = mid_num-random_num*2
			random_little[#random_little+1] = mid_num-random_num
			random_little[#random_little+1] = mid_num

			random_big[#random_big+1] = mid_num-random_num*2 - 1
			random_big[#random_big+1] = mid_num-random_num - 1
			random_big[#random_big+1] = mid_num - 1
			random_big[#random_big+1] = mid_num + random_num - 1

			API_Log("mid_num="..mid_num.."random_num="..random_num.."all_num="..all_num.."my_rank="..my_rank)
			
		end

		for i = 1, table.getn(random_little) do
			while true do
				local insert_num = math.random(random_little[i], random_big[i])
				if insert_num ~= my_rank then
					table.insert(fight_id, insert_num)
					break
				end
			end
		end
	end
	table.sort(fight_id)
	resp.fightinfo = {}
	
	for i = 1, table.getn(fight_id) do
		local fight_info = PVEARENA_GetRoleInfoByRank(pve_arena._pve_arena_data_map_data, fight_id[i])

		if fight_info.role_id ~= "0" then
			local tmp_fight = {}
			tmp_fight.id = fight_info.role_id
			tmp_fight.name = fight_info.name
			tmp_fight.level = fight_info.level
			tmp_fight.score = fight_info.score
			tmp_fight.hero_score = 100
			tmp_fight.mafia_name = fight_info.mafia_name
			tmp_fight.rank = fight_id[i]
			
			tmp_fight.hero_info = {}
			tmp_fight.hero_info.heroinfo = {}
			for i = 1, table.getn(fight_info.hero_info) do
				tmp_fight.hero_info.heroinfo[#tmp_fight.hero_info.heroinfo+1] = fight_info.hero_info[i]
			end

			resp.fightinfo[#resp.fightinfo+1] = tmp_fight
		end
	end
	resp.retcode = G_ERRCODE["SUCCESS"]
	player:SendToClient(SerializeCommand(resp))
	return
end
