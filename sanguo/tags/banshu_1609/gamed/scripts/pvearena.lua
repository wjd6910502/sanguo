function PVEARENA_GetRank(pve_arena, roleid, role_score)
	local pve_arena_it = pve_arena:SeekToLast()
	local pve_arena_info = pve_arena_it:GetValue()
	local num = 1
	while pve_arena_info ~= nil do
		if role_score >= pve_arena_info._begin_score and role_score <= pve_arena_info._end_score then
			local pve_arena_data_it = pve_arena_info._pve_arena_data_map:SeekToLast()
			local pve_arena_data = pve_arena_data_it:GetValue()
			while pve_arena_data ~= nil do
				if pve_arena_data._score == role_score then
					local list_data_it = pve_arena_data._list_data:SeekToBegin()
					local list_data = list_data_it:GetValue()
					while list_data ~= nil do
						if list_data._role_id:ToStr() == roleid:ToStr() then
							return num
						else
							num = num + 1
						end
						list_data_it:Next()
						list_data = list_data_it:GetValue()
					end
				else
					num = num + pve_arena_data._list_data:Size()
				end

				pve_arena_data_it:Prev()
				pve_arena_data = pve_arena_data_it:GetValue()
			end
			return 0
		end
		num = num + pve_arena_info._cur_num
		pve_arena_it:Prev()
		pve_arena_info = pve_arena_it:GetValue()
	end
	return 0
end

function PVEARENA_GetRoleInfoByRank(pve_arena, rank)
	local pve_arena_it = pve_arena:SeekToLast()
	local pve_arena_info = pve_arena_it:GetValue()
	local cur_rank = 0
	local role_info = {}
	role_info.role_id = "0"
	while pve_arena_info ~= nil do
		if rank >= cur_rank and rank <= (cur_rank + pve_arena_info._cur_num) then
			local data_list_it = pve_arena_info._pve_arena_data_map:SeekToLast()
			local data_list = data_list_it:GetValue()
			while data_list ~= nil do
				if rank >= cur_rank and rank <= (cur_rank + data_list._list_data:Size()) then
					local role_data_it = data_list._list_data:SeekToBegin()
					local role_data = role_data_it:GetValue()
					while role_data ~= nil do
						cur_rank = cur_rank + 1
						if rank == cur_rank then
							--就是这个玩家的数据了
							role_info.role_id = role_data._role_id:ToStr()
							role_info.name = role_data._name
							role_info.level = role_data._level
							role_info.mafia_name = role_data._mafia_name
							role_info.hero_info = role_data._hero_info
							role_info.score = data_list._score

							role_info.hero_info = {}

							local hero_info_it = role_data._hero_info:SeekToBegin()
							local hero_info = hero_info_it:GetValue()
							while hero_info ~= nil do
								local tmp_hero_info = {}
								tmp_hero_info.id = hero_info._heroid
								tmp_hero_info.level = hero_info._level
								tmp_hero_info.star = hero_info._star
								tmp_hero_info.grade = hero_info._grade

								tmp_hero_info.skill = {}
								tmp_hero_info.common_skill = {}
								tmp_hero_info.select_skill = {}

								local skill_it = hero_info._skill:SeekToBegin()
								local skill = skill_it:GetValue()
								while skill ~= nil do
									local h3 = {}
									h3.skill_id = skill._skill_id
									h3.skill_level = skill._skill_level
									tmp_hero_info.skill[#tmp_hero_info.skill+1] = h3
									skill_it:Next()
									skill = skill_it:GetValue()
								end

								local skill_it = hero_info._common_skill:SeekToBegin()
								local skill = skill_it:GetValue()
								while skill ~= nil do
									local h3 = {}
									h3.skill_id = skill._skill_id
									h3.skill_level = skill._skill_level
									tmp_hero_info.common_skill[#tmp_hero_info.common_skill+1] = h3
									skill_it:Next()
									skill = skill_it:GetValue()
								end

								local skill_it = hero_info._select_skill:SeekToBegin()
								local skill = skill_it:GetValue()
								while skill ~= nil do
									tmp_hero_info.select_skill[#tmp_hero_info.select_skill+1] = skill._value
									skill_it:Next()
									skill = skill_it:GetValue()
								end

								--武将的羁绊
								tmp_hero_info.relations = {}
								local relation_it = hero_info._relations:SeekToBegin()
								local relation = relation_it:GetValue()
								while relation ~= nil do
									tmp_hero_info.relations[#tmp_hero_info.relations+1] = relation._value
									relation_it:Next()
									relation = relation_it:GetValue()
								end
								--武将的武器，服务器来进行使用的
								tmp_hero_info.weapon_info = CACHE.WeaponItem()
								if hero_info._weapon_info._base_item._tid ~= 0 then
									tmp_hero_info.weapon_info = hero_info._weapon_info
								end
								--武将的武器信息，给客户端用的
								tmp_hero_info.weapon = {}
								tmp_hero_info.weapon.base_item = {}
								tmp_hero_info.weapon.weapon_info = {}

								if hero_info._weapon_info._base_item._tid ~= 0 then
									tmp_hero_info.weapon.base_item.tid = hero_info._weapon_info._base_item._tid
									tmp_hero_info.weapon.base_item.count = hero_info._weapon_info._base_item._count

									tmp_hero_info.weapon.weapon_info.tid = hero_info._weapon_info._weapon_pro._tid
									tmp_hero_info.weapon.weapon_info.level = hero_info._weapon_info._weapon_pro._level
									tmp_hero_info.weapon.weapon_info.star = hero_info._weapon_info._weapon_pro._star
									tmp_hero_info.weapon.weapon_info.quality = hero_info._weapon_info._weapon_pro._quality
									tmp_hero_info.weapon.weapon_info.prop = hero_info._weapon_info._weapon_pro._prop
									tmp_hero_info.weapon.weapon_info.attack = hero_info._weapon_info._weapon_pro._attack
									tmp_hero_info.weapon.weapon_info.weapon_skill = 
										hero_info._weapon_info._weapon_pro._weapon_skill
									tmp_hero_info.weapon.weapon_info.strength = 
										hero_info._weapon_info._weapon_pro._strengthen
									tmp_hero_info.weapon.weapon_info.level_up = hero_info._weapon_info._weapon_pro._level_up
									tmp_hero_info.weapon.weapon_info.strength_prob = 
										hero_info._weapon_info._weapon_pro._strengthen_prob
									tmp_hero_info.weapon.weapon_info.skill_pro = {}
									local skill_pro_it = hero_info._weapon_info._weapon_pro._skill_pro:SeekToBegin()
									local skill_pro = skill_pro_it:GetValue()
									while skill_pro ~= nil do
										local tmp_skill_pro = {}
										tmp_skill_pro.skill_id = skill_pro._skill_id
										tmp_skill_pro.skill_level = skill_pro._skill_level
										tmp_hero_info.weapon.weapon_info.skill_pro[#tmp_hero_info.weapon.weapon_info.skill_pro+1] = tmp_skill_pro
										skill_pro_it:Next()
										skill_pro = skill_pro_it:GetValue()
									end
								else
									tmp_hero_info.weapon.base_item.tid = 0
								end

								--武将的装备信息
								tmp_hero_info.equipment = {}
								local equipment_it = hero_info._equipment_info:SeekToBegin()
								local equipment = equipment_it:GetValue()
								while equipment ~= nil do
									local tmp_equipment = {}
									tmp_equipment.pos = equipment._pos
									tmp_equipment.item_id = equipment._item_id
									tmp_equipment.level = equipment._level
									tmp_equipment.order = equipment._order
									tmp_equipment.refinable_pro = {}
									local refine_it = equipment._refinable_data:SeekToBegin()
									local refine = refine_it:GetValue()
									while refine ~= nil do
										local tmp_refine = {}
										tmp_refine.typ = refine._typ
										tmp_refine.data = refine._num
										tmp_equipment.refinable_pro[#tmp_equipment.refinable_pro+1] = tmp_refine
										refine_it:Next()
										refine = refine_it:GetValue()
									end
									tmp_hero_info.equipment[#tmp_hero_info.equipment+1] = tmp_equipment
									equipment_it:Next()
									equipment = equipment_it:GetValue()
								end

								role_info.hero_info[#role_info.hero_info+1] = tmp_hero_info
								hero_info_it:Next()
								hero_info = hero_info_it:GetValue()
							end

							return role_info
						else
							--cur_rank = cur_rank + 1
						end
						role_data_it:Next()
						role_data = role_data_it:GetValue()
					end
					
					break
				else
					cur_rank = cur_rank + data_list._list_data:Size()
				end
				data_list_it:Prev()
				data_list = data_list_it:GetValue()
			end
		
		else
			cur_rank = cur_rank + pve_arena_info._cur_num
		end
		pve_arena_it:Prev()
		pve_arena_info = pve_arena_it:GetValue()
	end
	return role_info
end

function PVEARENA_ChangeRoleScore(pve_arena, role, last_score, cur_score)
	if last_score == cur_score then
		return
	end
	local pve_arena_it = pve_arena._pve_arena_data_map_data:SeekToBegin()
	local pve_arena_info = pve_arena_it:GetValue()
	local num = 0
	while pve_arena_info ~= nil do
		if last_score >= pve_arena_info._begin_score and last_score <= pve_arena_info._end_score then
			local pve_arena_data_it = pve_arena_info._pve_arena_data_map:SeekToBegin()
			local pve_arena_data = pve_arena_data_it:GetValue()
			while pve_arena_data ~= nil do
				if pve_arena_data._score == last_score then
					local list_data_it = pve_arena_data._list_data:SeekToBegin()
					local list_data = list_data_it:GetValue()
					while list_data ~= nil do
						if list_data._role_id:ToStr() == role._roledata._base._id:ToStr() then
							pve_arena_info._cur_num = pve_arena_info._cur_num - 1
							pve_arena._all_num = pve_arena._all_num - 1
							list_data_it:Pop()
							break
						else
							num = num + 1
						end
						list_data_it:Next()
						list_data = list_data_it:GetValue()
					end
					break
				else
					num = num + pve_arena_data._list_data:Size()
				end

				pve_arena_data_it:Next()
				pve_arena_data = pve_arena_data_it:GetValue()
			end

			break
		end
		pve_arena_it:Next()
		pve_arena_info = pve_arena_it:GetValue()
	end
	
	local msg = NewMessage("TopListInsertInfo")
	msg.typ = 4
	msg.data = tostring(role._roledata._pve_arena_info._score)
	API_SendMsg(role._roledata._base._id:ToStr(), SerializeMessage(msg), 0)
	
	local msg = NewMessage("RoleUpdatePveArenaMisc")
	API_SendMsg(role._roledata._base._id:ToStr(), SerializeMessage(msg), 0)
end

function PVEARENA_PrintRoleInfo(pve_arena)
	local pve_arena_it = pve_arena:SeekToLast()
	local pve_arena_info = pve_arena_it:GetValue()
	local num = 1
	while pve_arena_info ~= nil do
		local pve_arena_data_it = pve_arena_info._pve_arena_data_map:SeekToLast()
		local pve_arena_data = pve_arena_data_it:GetValue()
		while pve_arena_data ~= nil do
			local list_data_it = pve_arena_data._list_data:SeekToBegin()
			local list_data = list_data_it:GetValue()
			while list_data ~= nil do
				API_Log("111111111111   num="..num.."   roleid="..list_data._role_id:ToStr().."   score="..pve_arena_data._score)
				list_data_it:Next()
				list_data = list_data_it:GetValue()
				num = num + 1
			end

			pve_arena_data_it:Prev()
			pve_arena_data = pve_arena_data_it:GetValue()
		end
		pve_arena_it:Prev()
		pve_arena_info = pve_arena_it:GetValue()
	end
end

function PVEARENA_SendRewardOnTime(pve_arena)
	API_Log("PVEARENA_SendRewardOnTime")
	local ed = DataPool_Find("elementdata")
	local reward = ed.arenareward[1]
	
	local reward_index = 1
	local pve_arena_it = pve_arena:SeekToLast()
	local pve_arena_info = pve_arena_it:GetValue()
	local num = 1
	while pve_arena_info ~= nil do
		local pve_arena_data_it = pve_arena_info._pve_arena_data_map:SeekToLast()
		local pve_arena_data = pve_arena_data_it:GetValue()
		while pve_arena_data ~= nil do
			local list_data_it = pve_arena_data._list_data:SeekToBegin()
			local list_data = list_data_it:GetValue()
			while list_data ~= nil do
				while true do
					if num <= reward.arenarewardgroup[reward_index].arena_rank_max then
						local msg = NewMessage("SendMail")
						msg.mail_id = reward.arenarewardgroup[reward_index].arena_mail_id
						msg.arg1 = tostring(num)
						API_SendMsg(list_data._role_id:ToStr(), SerializeMessage(msg), 0)
						break
					else
						reward_index = reward_index + 1
					end
				end
				list_data_it:Next()
				list_data = list_data_it:GetValue()
				num = num + 1
			end

			pve_arena_data_it:Prev()
			pve_arena_data = pve_arena_data_it:GetValue()
		end
		pve_arena_it:Prev()
		pve_arena_info = pve_arena_it:GetValue()
	end
end
