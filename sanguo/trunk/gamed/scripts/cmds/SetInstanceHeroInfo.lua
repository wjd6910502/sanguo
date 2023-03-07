function OnCommand_SetInstanceHeroInfo(player, role, arg, others)
	player:Log("OnCommand_SetInstanceHeroInfo, "..DumpTable(arg).." "..DumpTable(others))

	local resp = NewCommand("SetInstanceHeroInfo_Re")
	resp.typ = arg.typ
	resp.battle_id = arg.battle_id
	resp.heros = arg.heros
	resp.horse = arg.horse
	--typ为1代表PVE副本的阵容保存
	--typ为2代表3V3的PVP阵容保存
	--typ为3代表的是马战的阵容保存
	--typ为4代表的是战役的阵容保存
	--typ为5代表的是战役的马战阵容保存
	--pve = 1, 	--闯关
	--pvp = 2,	--pvp
	--pve_m = 3,	--马战
	--pve_b = 4,  --战役
	--pve_bm = 5  ,--战役马战
	--pve_ac = 6 , --竞技场
	--pve_bzz = 7, --兵长战
	--pve_w = 8, -- 远征
	--pve_wm = 9, -- 远征马战
	--pve_tqt = 10, --铜雀台容易
	--pve_tqt_hard = 11, --铜雀台困难
	--pve_eventing = 12, -- 马术大赛
	--pve_prologue = 13, -- 新手开场战斗
	--		     -- 约战信息
	--pve_pt	= 43,--爬塔
	--pve_fuli  = 44,--军武宝库

	
	--设置出战的武将是否存在
	if table.getn(arg.heros) == 0 then
		resp.retcode = G_ERRCODE["HERO_COUNT_ZERO"]
		player:SendToClient(SerializeCommand(resp))
		player:Log("OnCommand_SetInstanceHeroInfo, error=HERO_COUNT_ZERO")
		return
	end
	local heros = role._roledata._hero_hall._heros

	for i = 1, table.getn(arg.heros) do
		local h = heros:Find(arg.heros[i])
		if h == nil then
			resp.retcode = G_ERRCODE["NO_HERO"]
			player:SendToClient(SerializeCommand(resp))
			player:Log("OnCommand_SetInstanceHeroInfo, error=NO_HERO")
			return
		end
	end

	--检查出战的马是否存在
	if arg.horse ~= 0 then
		local tmp_horse = role._roledata._horse_hall._horses:Find(arg.horse)
		if tmp_horse == nil then
			resp.retcode = G_ERRCODE["NO_HORSE"]
			player:SendToClient(SerializeCommand(resp))
			player:Log("OnCommand_SetInstanceHeroInfo, error=NO_HORSE")
			return
		end
	end

	if arg.typ == 1 then
		role._roledata._status._last_hero:Clear()
		for i = 1, table.getn(arg.heros) do
			local value = CACHE.Int()
			value._value = arg.heros[i]
			role._roledata._status._last_hero:PushBack(value)
		end
		resp.retcode = G_ERRCODE["SUCCESS"]
		player:SendToClient(SerializeCommand(resp))
		return
	elseif arg.typ == 2 then
		local hero_score = {}

		local ed = DataPool_Find("elementdata")
		local score = 0
		for i = 1, table.getn(arg.heros) do
			local hero_score_info = ed:FindBy("hero_score", arg.heros[i])
			if hero_score_info ~= nil then
				score = score + hero_score_info.role_score
			end
		end

		if score > 12 then
			return
		end
	
		role._roledata._pvp_info._last_hero:Clear()
		for i = 1, table.getn(arg.heros) do
			local value = CACHE.Int()
			value._value = arg.heros[i]
			role._roledata._pvp_info._last_hero:PushBack(value)
		end
		resp.retcode = G_ERRCODE["SUCCESS"]
		player:SendToClient(SerializeCommand(resp))
		return
	elseif arg.typ == 3 then
		if arg.horse == 0 then
			resp.retcode = G_ERRCODE["HORSE_COUNT_ZERO"]
			player:SendToClient(SerializeCommand(resp))
			player:Log("OnCommand_SetInstanceHeroInfo, error=HORSE_COUNT_ZERO")
			return
		end
		role._roledata._status._last_horse_hero._heroinfo:Clear()
		role._roledata._status._last_horse_hero._horse = 0
		for i = 1, table.getn(arg.heros) do
			local value = CACHE.Int()
			value._value = arg.heros[i]
			role._roledata._status._last_horse_hero._heroinfo:PushBack(value)
		end
		role._roledata._status._last_horse_hero._horse = arg.horse
		resp.retcode = G_ERRCODE["SUCCESS"]
		player:SendToClient(SerializeCommand(resp))
		return
	elseif arg.typ == 4 then
		local battle = role._roledata._battle_info:Find(arg.battle_id)
		if battle == nil then
			--直接给客户端返回，认为这个不存在
			resp.retcode = G_ERRCODE["BATTLE_ID_NOT_EXIST"]
			player:SendToClient(SerializeCommand(resp))
			player:Log("OnCommand_SetInstanceHeroInfo, error=BATTLE_ID_NOT_EXIST")
			return
		end
		
		if battle._state ~= 1 then
			--战役还没有开始
			resp.retcode = G_ERRCODE["BATTLE_STATE_NOT_SET_HERO"]
			player:SendToClient(SerializeCommand(resp))
			player:Log("OnCommand_SetInstanceHeroInfo, error=BATTLE_STATE_NOT_SET_HERO")
			return
		end
		
		local heros = battle._hero_info
		for i = 1, table.getn(arg.heros) do
			local h = heros:Find(arg.heros[i])
			if h == nil then
				resp.retcode = G_ERRCODE["NO_HERO"]
				player:SendToClient(SerializeCommand(resp))
				player:Log("OnCommand_SetInstanceHeroInfo, error=NO_HERO")
				return
			else
				--判断血量是否为0
				if h._hp == 0 then
					resp.retcode = G_ERRCODE["BATTLE_HERO_HP_ZERO"]
					player:SendToClient(SerializeCommand(resp))
					player:Log("OnCommand_SetInstanceHeroInfo, error=BATTLE_HERO_HP_ZERO")
					return
				end
			end
		end

		battle._cur_hero_info:Clear()
		for i = 1, table.getn(arg.heros) do
			local value = CACHE.Int()
			value._value = arg.heros[i]
			battle._cur_hero_info:PushBack(value)
		end
		resp.retcode = G_ERRCODE["SUCCESS"]
		player:SendToClient(SerializeCommand(resp))
		return
	elseif arg.typ == 5 then
		if arg.horse == 0 then
			resp.retcode = G_ERRCODE["HORSE_COUNT_ZERO"]
			player:SendToClient(SerializeCommand(resp))
			player:Log("OnCommand_SetInstanceHeroInfo, error=HORSE_COUNT_ZERO")
			return
		end
		local battle = role._roledata._battle_info:Find(arg.battle_id)
		if battle == nil then
			--直接给客户端返回，认为这个不存在
			resp.retcode = G_ERRCODE["BATTLE_ID_NOT_EXIST"]
			player:SendToClient(SerializeCommand(resp))
			player:Log("OnCommand_SetInstanceHeroInfo, error=BATTLE_ID_NOT_EXIST")
			return
		end
		
		if battle._state ~= 1 then
			--战役还没有开始
			resp.retcode = G_ERRCODE["BATTLE_STATE_NOT_SET_HERO"]
			player:SendToClient(SerializeCommand(resp))
			player:Log("OnCommand_SetInstanceHeroInfo, error=BATTLE_STATE_NOT_SET_HERO")
			return
		end
		
		local heros = battle._hero_info
		for i = 1, table.getn(arg.heros) do
			local h = heros:Find(arg.heros[i])
			if h == nil then
				resp.retcode = G_ERRCODE["NO_HERO"]
				player:SendToClient(SerializeCommand(resp))
				player:Log("OnCommand_SetInstanceHeroInfo, error=NO_HERO")
				return
			else
				--判断血量是否为0
				if h._hp == 0 then
					resp.retcode = G_ERRCODE["BATTLE_HERO_HP_ZERO"]
					player:SendToClient(SerializeCommand(resp))
					player:Log("OnCommand_SetInstanceHeroInfo, error=BATTLE_HERO_HP_ZERO")
					return
				end
			end
		end
		battle._cur_hero_horse_info._heroinfo:Clear()
		battle._cur_hero_horse_info._horse = 0
		for i = 1, table.getn(arg.heros) do
			local value = CACHE.Int()
			value._value = arg.heros[i]
			battle._cur_hero_horse_info._heroinfo:PushBack(value)
		end
		battle._cur_hero_horse_info._horse = arg.horse

		resp.retcode = G_ERRCODE["SUCCESS"]
		player:SendToClient(SerializeCommand(resp))
		return
	elseif arg.typ == 10 then
		if table.getn(arg.heros) < 3 then
			resp.retcode = G_ERRCODE["TONGQUETAI_SET_HERO_COUNT_LESS"]
			player:SendToClient(SerializeCommand(resp))
			player:Log("OnCommand_SetInstanceHeroInfo, error=TONGQUETAI_SET_HERO_COUNT_LESS")
			return
		end
		
		for i = 1, table.getn(arg.heros) do
			local h = role._roledata._hero_hall._heros:Find(arg.heros[i])
			if h == nil then
				resp.retcode = G_ERRCODE["TONGQUETAI_SET_HERO_NO_HERO"]
				player:SendToClient(SerializeCommand(resp))
				player:Log("OnCommand_SetInstanceHeroInfo, error=TONGQUETAI_SET_HERO_NO_HERO")
				return
			end
		end

		role._roledata._tongquetai_data._hero_info_list:Clear()

		for i = 1, table.getn(arg.heros) do
			local insert_data = CACHE.Int()
			insert_data._value = arg.heros[i]
			role._roledata._tongquetai_data._hero_info_list:PushBack(insert_data)
		end
		
		resp.retcode = G_ERRCODE["SUCCESS"]
		player:SendToClient(SerializeCommand(resp))
		return
	elseif arg.typ == 12 then
		if table.getn(arg.heros) ~= 1 then
			resp.retcode = G_ERRCODE["MASHU_BUY_SET_HERO_COUNT"]
			player:SendToClient(SerializeCommand(resp))
			player:Log("OnCommand_SetInstanceHeroInfo, error=MASHU_BUY_SET_HERO_COUNT")
			return
		end

		if arg.horse == 0 then
			resp.retcode = G_ERRCODE["MASHU_BUY_SET_HERO_COUNT"]
			player:SendToClient(SerializeCommand(resp))
			player:Log("OnCommand_SetInstanceHeroInfo, error=MASHU_BUY_SET_HERO_COUNT")
			return
		end

		role._roledata._mashu_info._hero_info._heroid = arg.heros[1]
		role._roledata._mashu_info._hero_info._horse_id = arg.horse
		resp.retcode = G_ERRCODE["SUCCESS"]
		player:SendToClient(SerializeCommand(resp))
		return
	elseif arg.typ == G_HERO_TEAM_TYP["TOWER"] then
		local tmp_hero_info = CACHE.IntList()
		
		for i = 1, table.getn(arg.heros) do
			local insert_data = CACHE.Int()
			insert_data._value = arg.heros[i]
			tmp_hero_info:PushBack(insert_data)
		end
		
		local data = CACHE.HeroTeamInfo()
		data._id = G_HERO_TEAM_TYP["TOWER"]
		data._cur_hero_ids = tmp_hero_info

		role._roledata._hero_all_team:Delete(G_HERO_TEAM_TYP["TOWER"])
		role._roledata._hero_all_team:Insert(G_HERO_TEAM_TYP["TOWER"], data)
		resp.retcode = G_ERRCODE["SUCCESS"]
		player:SendToClient(SerializeCommand(resp))
		return
    elseif arg.typ == G_HERO_TEAM_TYP["JUNWUBAOKU1"] or arg.typ == G_HERO_TEAM_TYP["JUNWUBAOKU2"] or
			arg.typ == G_HERO_TEAM_TYP["JUNWUBAOKU3"] or arg.typ == G_HERO_TEAM_TYP["JUNWUBAOKU4"] then

		if table.getn(arg.heros) < 1 or arg.typ == G_HERO_TEAM_TYP["JUNWUBAOKU4"] and table.getn(arg.heros) ~= 1 then
			resp.retcode = G_ERRCODE["BATTLE_HERO_SIZE"]
			player:SendToClient(SerializeCommand(resp))
			player:Log("OnCommand_SetInstanceHeroInfo, error=MASHU_BUY_SET_HERO_COUNT")
			return
		end

		if arg.typ == G_HERO_TEAM_TYP["JUNWUBAOKU4"] then
			if arg.horse == 0 then
				resp.retcode = G_ERRCODE["HORSE_COUNT_ZERO"]
				player:SendToClient(SerializeCommand(resp))
				player:Log("OnCommand_SetInstanceHeroInfo, error=HORSE_COUNT_ZERO")
				return
			end

			role._roledata._military_data._horse_id = arg.horse
		end

		--判断武将类型
		local ed = DataPool_Find("elementdata")
		local military = ed:FindBy("military", (arg.typ-43))
		if military == nil then
			resp.retcode = G_ERRCODE["MILITARY_ERROR_ARG"]
			player:SendToClient(SerializeCommand(resp))
			player:Log("OnCommand_SetInstanceHeroInfo, error=MILITARY_ERROR_ARG")
			return
		end

		for i = 1, table.getn(arg.heros) do
			local hero = ed:FindBy("hero_id", arg.heros[i])
			if hero == nil then
				resp.retcode = G_ERRCODE["MILITARY_ERROR_ARG"]
				player:SendToClient(SerializeCommand(resp))
				player:Log("OnCommand_SetInstanceHeroInfo, error=MILITARY_ERROR_ARG1")
				return
			end

			if military.role_limit_type ~= 0 and military.role_limit_type ~= hero.roletype then
				resp.retcode = G_ERRCODE["MILITARY_ERROR_HERO_TYPE"]
				player:SendToClient(SerializeCommand(resp))
				player:Log("OnCommand_SetInstanceHeroInfo, error=MILITARY_ERROR_HERO_TYPE1")
				return	
			end

			if military.role_sex_type ~= -1 then
				if hero.gender_male == 1 then
					if military.role_sex_type ~= 1 then
						resp.retcode = G_ERRCODE["MILITARY_ERROR_HERO_TYPE"]
						player:SendToClient(SerializeCommand(resp))
						player:Log("OnCommand_SetInstanceHeroInfo, error=MILITARY_ERROR_HERO_TYPE2")
						return
					end
				else
					if military.role_sex_type ~= 0 then
						resp.retcode = G_ERRCODE["MILITARY_ERROR_HERO_TYPE"]
						player:SendToClient(SerializeCommand(resp))
						player:Log("OnCommand_SetInstanceHeroInfo, error=MILITARY_ERROR_HERO_TYPE3")
						return
					end
				end
			end
		end
  
		local tmp_hero_info = CACHE.IntList() 
		for i = 1, table.getn(arg.heros) do
        	local insert_data = CACHE.Int()
        	insert_data._value = arg.heros[i]
        	tmp_hero_info:PushBack(insert_data)
		end

        local data = CACHE.HeroTeamInfo()
        data._id = G_HERO_TEAM_TYP["JUNWUBAOKU"..(arg.typ-43)]
        data._cur_hero_ids = tmp_hero_info

        role._roledata._hero_all_team:Delete(arg.typ)
        role._roledata._hero_all_team:Insert(arg.typ, data)   
        resp.retcode = G_ERRCODE["SUCCESS"]
        player:SendToClient(SerializeCommand(resp))
        return
	end
end
