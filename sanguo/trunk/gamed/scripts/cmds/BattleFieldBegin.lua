function OnCommand_BattleFieldBegin(player, role, arg, others)
	player:Log("OnCommand_BattleFieldBegin, "..DumpTable(arg).." "..DumpTable(others))

	--开始某一个战役
	local resp = NewCommand("BattleFieldBegin_Re")
	resp.battle_id = arg.battle_id
	
	local ed = DataPool_Find("elementdata")
	local quanju = ed.gamedefine[1]

	if quanju.battle_open_lv > role._roledata._status._level then
		resp.retcode = G_ERRCODE["BATTLE_LEVEL_LESS"]
		player:SendToClient(SerializeCommand(resp))
		player:Log("OnCommand_BattleFieldBegin, error=BATTLE_LEVEL_LESS")
		return
	end

	if quanju.battle_limit_id ~= 0 then
		if LIMIT_TestUseLimit(role, quanju.battle_limit_id, 1) == false then
			resp.retcode = G_ERRCODE["BATTLE_LIMIT_NO_COUNT"]
			player:SendToClient(SerializeCommand(resp))
			player:Log("OnCommand_BattleFieldBegin, error=BATTLE_LIMIT_NO_COUNT")
			return
		end
	end

	local battle = role._roledata._battle_info:Find(arg.battle_id)
	if battle == nil then
		resp.retcode = G_ERRCODE["BATTLE_ID_NOT_EXIST"]
		player:SendToClient(SerializeCommand(resp))
		player:Log("OnCommand_BattleFieldBegin, error=BATTLE_ID_NOT_EXIST")
		return
	end

	if battle._state == 1 then
		--战役已经开始
		resp.retcode = G_ERRCODE["BATTLE_HAVE_BEGIN"]
		player:SendToClient(SerializeCommand(resp))
		player:Log("OnCommand_BattleFieldBegin, error=BATTLE_HAVE_BEGIN")
		return
	elseif battle._state == 2 then
		--战役已经结束
		resp.retcode = G_ERRCODE["BATTLE_HAVE_END"]
		player:SendToClient(SerializeCommand(resp))
		player:Log("OnCommand_BattleFieldBegin, error=BATTLE_HAVE_END")
		return
	end
	
	--判断前置战役是否已经通关
	local battle_info = ed:FindBy("battle_id", arg.battle_id)
	if battle_info.req_battle ~= 0 then
		local req_battle = role._roledata._have_finish_battle:Find(battle_info.req_battle)
		if req_battle == nil then
			resp.retcode = G_ERRCODE["BATTLE_NOT_FINISH_REQ"]
			player:SendToClient(SerializeCommand(resp))
			player:Log("OnCommand_BattleFieldBegin, error=BATTLE_NOT_FINISH_REQ")
			return
		end
	end
	
	if battle_info.limitid ~= 0 then
		if LIMIT_TestUseLimit(role, battle_info.limitid, 1) == false then
			resp.retcode = G_ERRCODE["BATTLE_LIMIT_NO_COUNT"]
			player:SendToClient(SerializeCommand(resp))
			player:Log("OnCommand_BattleFieldBegin, error=BATTLE_LIMIT_NO_COUNT")
			return
		end
	end

	--判断英雄是否都存在
	if table.getn(arg.heros) == 0 then
		resp.retcode = G_ERRCODE["BATTLE_SELECT_ZERO"]
		player:SendToClient(SerializeCommand(resp))
		player:Log("OnCommand_BattleFieldBegin, error=BATTLE_SELECT_ZERO")
		return
	end

	if table.getn(arg.heros) > battle_info.char_amount_limit then
		resp.retcode = G_ERRCODE["BATTLE_SELECT_MORE_HERO"]
		player:SendToClient(SerializeCommand(resp))
		player:Log("OnCommand_BattleFieldBegin, error=BATTLE_SELECT_MORE_HERO")
		return
	end
	
	local heros = role._roledata._hero_hall._heros
	for i = 1, table.getn(arg.heros) do
		local h = heros:Find(arg.heros[i].hero_id)
		if h == nil then
			resp.retcode = G_ERRCODE["BATTLE_HERO_NOT_EXIST"]
			player:SendToClient(SerializeCommand(resp))
			player:Log("OnCommand_BattleFieldBegin, error=BATTLE_HERO_NOT_EXIST")
			return
		end
	end

	--判断等级
	if role._roledata._status._level < battle_info.recommend_min_level then
		resp.retcode = G_ERRCODE["BATTLE_LEVEL_LESS"]
		player:SendToClient(SerializeCommand(resp))
		player:Log("OnCommand_BattleFieldBegin, error=BATTLE_LEVEL_LESS")
		return
	end

	--开始设置相关的数据
	battle._state = 1
	--设置当前的回合数以及回合状态
	battle._round_num = 1
	battle._round_state = 1
	for i = 1, table.getn(arg.heros) do
		local tmp_hero = CACHE.BattleFieldHeroData()
		tmp_hero._id = arg.heros[i].hero_id
		tmp_hero._hp = arg.heros[i].hp
		battle._hero_info:Insert(tmp_hero._id, tmp_hero)
	end

	resp.retcode = G_ERRCODE["SUCCESS"]
	player:SendToClient(SerializeCommand(resp))

	resp = NewCommand("ChangeBattleState")
	resp.battle_id = arg.battle_id
	resp.state = battle._state
	player:SendToClient(SerializeCommand(resp))

	resp = NewCommand("BattleFieldUpdateRoundState")
	resp.battle_id = arg.battle_id
	resp.round_num = battle._round_num
	resp.round_state = battle._round_state
	player:SendToClient(SerializeCommand(resp))
	return
end
