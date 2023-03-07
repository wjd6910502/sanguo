function OnCommand_TowerBuyBuff(player, role, arg, others)
	player:Log("OnCommand_TowerBuyBuff, "..DumpTable(arg).." "..DumpTable(others))
	local resp = NewCommand("TowerBuyBuff_Re")
	if role._roledata._tower_data._cur_layer ~= arg.layer then
		resp.retcode = G_ERRCODE["TOWER_ERROR_LEVEL"]
		player:SendToClient(SerializeCommand(resp))
		player:Log("OnCommand_TowerBuyBuff, error=TOWER_ERROR_LEVEL")	
		return
    end

	if arg.id == 0 then
		role._roledata._tower_data._cur_layer = role._roledata._tower_data._cur_layer + 1
		resp.retcode = G_ERRCODE["SUCCESS"]
		resp.id = 0
		player:SendToClient(SerializeCommand(resp))
		return
	end

	local buffs = role._roledata._tower_data._buff_info:Find(arg.layer)
	if buffs == nil then
		resp.retcode = G_ERRCODE["TOWER_ERROR_BUFF"]
		player:SendToClient(SerializeCommand(resp))
		player:Log("OnCommand_TowerBuyBuff, error=TOWER_ERROR_BUFF")
		return
	end

	local ed = DataPool_Find("elementdata")
	local layer = arg.layer
	if role._roledata._tower_data._difficulty == 2 then
		layer = layer + 100
	end

	local towerstage = ed:FindBy("tower_stage", layer)
	if towerstage == nil then
		resp.retcode = G_ERRCODE["TOWER_ERROR_DATA"]
		player:SendToClient(SerializeCommand(resp))
		player:Log("OnCommand_TowerBuyBuff, error=TOWER_ERROR_DATA")
		return
	end

	local index = 0
	local lit = buffs._buff:SeekToBegin()
	local l = lit:GetValue()
	while l ~= nil do
		index = index + 1	
		if l._id == arg.id then
			if l._buy_flag == 1 then
				resp.retcode = G_ERRCODE["TOWER_ERROR_GET_BUFF"]
				player:SendToClient(SerializeCommand(resp))
				player:Log("OnCommand_TowerBuyBuff, error=TOWER_ERROR_GET_BUFF")
				return
			end

			if role._roledata._tower_data._cur_star < towerstage.buffs_cost[index] then
				resp.retcode = G_ERRCODE["TOWER_ERROR_LESS_STAR"]
				player:SendToClient(SerializeCommand(resp))
				player:Log("OnCommand_TowerBuyBuff, error=TOWER_ERROR_LESS_STAR")
				return
			end

			local ed = DataPool_Find("elementdata")
			local buff_info = ed:FindBy("tower_adds", arg.id)
			if buff_info == nil then
				resp.retcode = G_ERRCODE["TOWER_ERROR_ARG"]
				player:SendToClient(SerializeCommand(resp))
				player:Log("OnCommand_TowerBuyBuff, error=TOWER_ERROR_ARG")
				return
			end

			if buff_info.buff_category == 4 or buff_info.buff_category == 6 then
				if arg.hero_id == 0 then
					resp.retcode = G_ERRCODE["TOWER_ERROR_ARG"]
					player:SendToClient(SerializeCommand(resp))
					player:Log("OnCommand_TowerBuyBuff, error=TOWER_ERROR_ARG")
					return
				end

				local f = role._roledata._hero_hall._heros:Find(arg.hero_id)
				if f == nil then
					resp.restcode = G_ERRCODE["TOWER_PARAM_HERO_NOT_EXIST"]
					player:SendToClient(SerializeCommand(resp))
					player:Log("OnCommand_TowerBuyBuff, error=TOWER_PARAM_HERO_NOT_EXIST")
					return
				end
			end

			role._roledata._tower_data._cur_star = role._roledata._tower_data._cur_star - towerstage.buffs_cost[index]
			l._buy_flag = 1
			local insert_data = CACHE.Int()
			insert_data._value = arg.id
			role._roledata._tower_data._buff:PushBack(insert_data)
			
			if buff_info.buff_category == 4 then
				local f = role._roledata._tower_data._injured_hero:Find(arg.hero_id)
				if f == nil then
					resp.restcode = G_ERRCODE["TOWER_PARAM_HERO_NOT_EXIST"]
					player:SendToClient(SerializeCommand(resp))
					player:Log("OnCommand_TowerBuyBuff, error=TOWER_PARAM_HERO_NOT_EXIST")
					return
				end

				f._hp = f._hp + buff_info.buff_data*100
				if f._hp > 100000 then
					f._hp = 100000
				end
				resp.hero = {}
				local info = {}
				info.id = f._id
				info.hp = f._hp
				info.anger = f._anger
				resp.hero[#resp.hero + 1] = info
			elseif buff_info.buff_category == 5 then
				local injured_it = role._roledata._tower_data._injured_hero:SeekToBegin()
				local injured = injured_it:GetValue()
				resp.hero = {}
				while injured ~= nil do
					injured._hp = injured._hp + buff_info.buff_data*100
					if injured._hp >= 100000 then
						injured._hp = 100000
					end
					local info = {}
					info.id = injured._id
					info.hp = injured._hp
					info.anger = injured._anger
					resp.hero[#resp.hero + 1] = info
					injured_it:Next()
					injured = injured_it:GetValue()
				end

			elseif buff_info.buff_category == 6 then
				local f = role._roledata._tower_data._dead_hero:Find(arg.hero_id)
				if f == nil then
					resp.restcode = G_ERRCODE["TOWER_PARAM_HERO_NOT_EXIST"]
					player:SendToClient(SerializeCommand(resp))
					player:Log("OnCommand_TowerBuyBuff, error=TOWER_PARAM_HERO_NOT_EXIST")
					return	
				end
				role._roledata._tower_data._dead_hero:Delete(arg.hero_id)
				local hero = CACHE.ShiLianHeroInfo()	
				hero._id = arg.hero_id
				hero._hp = buff_info.buff_data*100
				role._roledata._tower_data._injured_hero:Insert(hero._id, hero)
				resp.hero = {}
				local info = {}
				info.id = hero._id
				info.hp = hero._hp
				resp.hero[#resp.hero + 1] = info
			end	

			resp.retcode = G_ERRCODE["SUCCESS"]
			resp.layer = role._roledata._tower_data._cur_layer
			resp.id = arg.id
			resp.cur_star = role._roledata._tower_data._cur_star
			player:SendToClient(SerializeCommand(resp))
			break
		end
		lit:Next()
		l = lit:GetValue()
	end
end
