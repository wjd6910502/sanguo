function OnCommand_TowerEndBattle(player, role, arg, others)
	player:Log("OnCommand_TowerEndBattle, "..DumpTable(arg).." "..DumpTable(others))
	if role._roledata._status._time_line ~= G_ROLE_STATE["TOWER"] then
		return
	end	
	
	local resp = NewCommand("TowerEndBattle_Re")
	local size = table.getn(arg.hero)

	--检查武将信息
	for i = 1, size do
		local hero = arg.hero[i]
		--判断是否在英雄列表中
		local f = role._roledata._hero_hall._heros:Find(hero.id)
		if f == nil then
			resp.restcode = G_ERRCODE["TOWER_PARAM_HERO_NOT_EXIST"]
			player:SendToClient(SerializeCommand(resp))
			player:Log("OnCommand_TowerEndBattle, error=TOWER_PARAM_HERO_NOT_EXIST")
			return
		end
	end

	--处理武将信息
	for i = 1, size do
		local hero = arg.hero[i]
		local f = role._roledata._tower_data._injured_hero:Find(hero.id)
		if f ~= nil then
			f._hp = hero.hp
			f._anger = hero.anger
			if f._hp == 0 then
				role._roledata._tower_data._injured_hero:Delete(hero.id)
				local deadhero = CACHE.Int()
				deadhero._value = hero.id
				role._roledata._tower_data._dead_hero:Insert(hero.id, deadhero)
			end
		else
			if hero.hp == 0 then
				local deadhero = CACHE.Int()
				deadhero._value = hero.id
				role._roledata._tower_data._dead_hero:Insert(hero.id, deadhero)
			else
				local towerhero = CACHE.ShiLianHeroInfo()
				towerhero._id  = hero.id
				towerhero._hp  = hero.hp
				towerhero._anger  = hero.anger
				role._roledata._tower_data._injured_hero:Insert(hero.id, towerhero)
			end
		end
	end

	local tower_data = role._roledata._tower_data
	--玩家胜利
	if arg.win_flag == 1 then
		local last_score = tower_data._all_star
		--玩家增加星星		
		local star_count = 0
		local size = table.getn(arg.star)
		for i = 1, size do
			if arg.star[i].flag == 1 then
				star_count = star_count + 1
			end
		end
		tower_data._all_star = tower_data._all_star + star_count * tower_data._select_layer_difficulty
		tower_data._cur_star = tower_data._cur_star + star_count * tower_data._select_layer_difficulty
		tower_data._reward_star = tower_data._reward_star + star_count * tower_data._select_layer_difficulty

		--更新排行榜
		local msg = NewMessage("TopListInsertInfo")
		if tower_data._difficulty == 1 then
			msg.typ = 10
		elseif tower_data._difficulty == 2 then
			msg.typ = 11
		end
		msg.data = tostring(tower_data._all_star)
		API_SendMsg(role._roledata._base._id:ToStr(), SerializeMessage(msg), 0)

		--更新奖励榜 分开写清楚
		if tower_data._difficulty == 1 then
			TOP_ALL_Role_UpdateData(others.toplist_all_role._data._data, 2, role._roledata._base._id, role._roledata._base._name,
					role._roledata._base._photo, role._roledata._status._level, role._roledata._mafia._name,
					tower_data._all_star, last_score)
		elseif tower_data._difficulty == 2 then
			TOP_ALL_Role_UpdateData(others.toplist_all_role._data._data, 3, role._roledata._base._id, role._roledata._base._name,
					role._roledata._base._photo, role._roledata._status._level, role._roledata._mafia._name,
					tower_data._all_star, last_score)
		end

		if tower_data._history_best_star <= tower_data._all_star then
			tower_data._history_best_star = tower_data._all_star
			tower_data._history_best_layer = tower_data._cur_layer	
		end		
		
		--增加打过的信息，map肯定不存在当前层数据
		local army_info = CACHE.TowerArmyInfo()
		army_info._layer = role._roledata._tower_data._cur_layer
		army_info._star = star_count * tower_data._select_layer_difficulty
		army_info._difficulty = tower_data._select_layer_difficulty		
		local army_it = tower_data._cur_army_info:Find(tower_data._select_layer_difficulty):SeekToBegin()
        local army = army_it:GetValue()
        while army ~= nil do
			local insert_data = CACHE.Int()
			insert_data._value = army._id
			army_info._army_info:PushBack(insert_data)
            army_it:Next()
            army = army_it:GetValue()
        end
		tower_data._army_info:Insert(tower_data._cur_layer, army_info)

		--删除当前敌人数据
		tower_data._cur_army_info:Clear()
		tower_data._cur_army_ids:Clear()

		if tower_data._cur_layer == 1 and tower_data._select_layer_difficulty == 3 then
			tower_data._win_flag = 1
		end

		if tower_data._win_flag == 1 then
			tower_data._history_layer = tower_data._cur_layer
		end

		resp.all_star = tower_data._all_star
		resp.cur_star = tower_data._cur_star

		tower_data._select_layer_difficulty = 0
		tower_data._cur_layer = tower_data._cur_layer + 1
	else
		--只有失败才会返回敌人信息吧？胜利敌人都死了
		
		--处理敌人血量
		size = table.getn(arg.army)
		for i = 1, size do
			local army = arg.army[i]
			local fs = tower_data._cur_army_info:Find(tower_data._select_layer_difficulty)
			if fs ~= nil then
				local info_it = fs:SeekToBegin()
				local info = info_it:GetValue()
				while info ~= nil do
					if army.id == info._id then
						info._hp = army.hp
						info._anger = army.anger
						if info._hp == 0 then
							info._alive_flag = 0
						end
						break
					end
					info_it:Next()
					info = info_it:GetValue()
				end
			end
		end
		
		tower_data._win_flag = 0
		local army_it = tower_data._cur_army_info:Find(tower_data._select_layer_difficulty):SeekToBegin()
		local army = army_it:GetValue()
		resp.army = {}
		while army ~= nil do
			local info = {}
			info.id = army._id
			info.hp = army._hp
			info.anger = army._anger
			resp.army[#resp.army + 1] = info
			army_it:Next()
			army = army_it:GetValue()
		end
		resp.all_star = tower_data._all_star
		resp.cur_star = tower_data._cur_star
	end

	resp.history_best_layer = tower_data._history_best_layer
	resp.history_best_star = tower_data._history_best_star
	resp.hero = arg.hero
	resp.retcode = G_ERRCODE["SUCCESS"]
	resp.win_flag = arg.win_flag
	player:SendToClient(SerializeCommand(resp))
	role._roledata._status._time_line = G_ROLE_STATE["FREE"]
	--查看操作和种子，准备做后面的验证
	--arg.operations
	--role._roledata._status._fight_seed
end
