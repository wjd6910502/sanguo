function OnCommand_LegionLearnJunXueXiangMu(player, role, arg, others)
	player:Log("OnCommand_LegionLearnJunXueXiangMu, "..DumpTable(arg).." "..DumpTable(others))

	local resp = NewCommand("LegionLearnJunXueXiangMu_Re")
	resp.retcode = G_ERRCODE["SUCCESS"]
	resp.id = arg.id
	resp.learn_id = arg.learn_id

	local junxue_info = role._roledata._legion_info._junxueguan._junxueinfo:Find(arg.id)
	if junxue_info ~= nil then
		local learn_flag = false
		local ed = DataPool_Find("elementdata")
		local xiangmu_info = ed:FindBy("legiontech_id", arg.learn_id)
		if xiangmu_info ~= nil then
			--判断是否已经学习过了
			if junxue_info._learned:Find(arg.learn_id) ~= nil then
				resp.retcode = G_ERRCODE["LEGION_XIANGMU_LEARNED"]
				player:SendToClient(SerializeCommand(resp))
				return
			end
			if xiangmu_info.legion_spec_platform_type == arg.id then
				--查看等级是否达到了要求
				if role._roledata._status._level < xiangmu_info.need_legion_lv then
					resp.retcode = G_ERRCODE["LEGION_LEARN_LEVEL_LESS"]
					player:SendToClient(SerializeCommand(resp))
					return
				end
				--查看前置的是否进行了学习，如果没有的话直接返回
				if xiangmu_info.precondition_legion_tech_id ~= 0 then
					if junxue_info._learned:Find(xiangmu_info.precondition_legion_tech_id) == nil then
						resp.retcode = G_ERRCODE["LEGION_LEARN_LEVEL_LESS"]
						player:SendToClient(SerializeCommand(resp))
						return
					end
				end
				for tech_id in DataPool_Array(xiangmu_info.nearby_legion_tech_id) do 
					if tech_id ~= 0 then
						local learn_info = junxue_info._learned:Find(tech_id)
						if learn_info ~= nil then
							learn_flag = true
						end
					else
						break
					end
					
				end
			else
				resp.retcode = G_ERRCODE["SYSTEM_DATA_ERR"]
				player:SendToClient(SerializeCommand(resp))
				return
			end
		else
			resp.retcode = G_ERRCODE["SYSTEM_DATA_ERR"]
			player:SendToClient(SerializeCommand(resp))
			return
		end

		if learn_flag == true then
			API_Log("11111111111111111111111111111111111111111111111111111")
			local insert_learned = CACHE.Int()
			insert_learned._value = arg.learn_id
			junxue_info._learned:Insert(arg.learn_id, insert_learned)
		end
	else
		resp.retcode = G_ERRCODE["SYSTEM_DATA_ERR"]
		player:SendToClient(SerializeCommand(resp))
		return
	end

	ROLE_UpdateZhanli(role)
	player:SendToClient(SerializeCommand(resp))
end
