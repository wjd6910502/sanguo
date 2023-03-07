function OnCommand_BattleFieldJoinBattle(player, role, arg, others)
	player:Log("OnCommand_BattleFieldJoinBattle, "..DumpTable(arg).." "..DumpTable(others))

	local resp = NewCommand("BattleFieldJoinBattle_Re")
	
	--检查PVP版本
	local cur_pvp_ver = ROLE_GetPVPVersion(role._roledata._client_ver._client_id, role._roledata._client_ver._exe_ver, role._roledata._client_ver._data_ver)
	if cur_pvp_ver <= 0 then
		local resp = NewCommand("ErrorInfo")
		resp.error_id = G_ERRCODE["EXE_OUT_OF_DATE"]
		player:SendToClient(SerializeCommand(resp))
		player:Log("OnCommand_BattleFieldJoinBattle, error=EXE_OUT_OF_DATE")
		return
	end
	
	local battle = role._roledata._battle_info:Find(arg.battle_id)
	local position = battle._position_info:Find(battle._cur_position)
	
	local id = 0
	local army_id = 0
	local npc_it = position._npc_info:SeekToBegin()
	local npc = npc_it:GetValue()
	while npc ~= nil do
		if npc._camp == 2 then
			if arg.npc_id == npc._id and npc._alive == 1 then
				id = npc._id
				army_id = npc._armyid
				break
			end
		end
		npc_it:Next()
		npc = npc_it:GetValue()
	end

	if id == 0 then
		resp.retcode = G_ERRCODE["BATTLE_POSITION_NO_ARMY"]
		player:SendToClient(SerializeCommand(resp))
		player:Log("OnCommand_BattleFieldJoinBattle, error=BATTLE_POSITION_NO_ARMY")
		return
	end

	if id ~= arg.npc_id then
		resp.retcode = G_ERRCODE["BATTLE_ARMY_NOT_SAME"]
		player:SendToClient(SerializeCommand(resp))
		player:Log("OnCommand_BattleFieldJoinBattle, error=BATTLE_ARMY_NOT_SAME")
		return
	end
	--在这里开始判断，武将的信息是否正确
	local ed = DataPool_Find("elementdata")
	local battlearmy_info = ed:FindBy("battlearmy_id", army_id)
	--关卡类型（0普通，1马战）
	if battlearmy_info.stagetype == 1 then
		if battle._cur_hero_horse_info._horse == 0 or battle._cur_hero_horse_info._heroinfo:Size() == 0 then
			resp.retcode = G_ERRCODE["BATTLE_SET_HERO_INFO"]
			player:SendToClient(SerializeCommand(resp))
			player:Log("OnCommand_BattleFieldJoinBattle, error=BATTLE_SET_HERO_INFO")
			return
		end
		local cur_hero_it = battle._cur_hero_horse_info._heroinfo:SeekToBegin()
		local cur_hero = cur_hero_it:GetValue()
		while cur_hero ~= nil do
			local find_hero = battle._hero_info:Find(cur_hero._value)
			if find_hero == nil then
				resp.retcode = G_ERRCODE["BATTLE_SET_HERO_INFO"]
				player:SendToClient(SerializeCommand(resp))
				player:Log("OnCommand_BattleFieldJoinBattle, error=BATTLE_SET_HERO_INFO")
				return
			--elseif find_hero._hp == 0 then
			--	resp.retcode = G_ERRCODE["BATTLE_SET_HERO_INFO"]
			--	player:SendToClient(SerializeCommand(resp))
			--	player:Log("OnCommand_BattleFieldJoinBattle, error=BATTLE_SET_HERO_INFO")
			--	return
			end
			cur_hero_it:Next()
			cur_hero = cur_hero_it:GetValue()
		end
	else
		if battle._cur_hero_info:Size() == 0 then
			resp.retcode = G_ERRCODE["BATTLE_SET_HERO_INFO"]
			player:SendToClient(SerializeCommand(resp))
			player:Log("OnCommand_BattleFieldJoinBattle, error=BATTLE_SET_HERO_INFO")
			return
		end
		local cur_hero_it = battle._cur_hero_info:SeekToBegin()
		local cur_hero = cur_hero_it:GetValue()
		while cur_hero ~= nil do
			local find_hero = battle._hero_info:Find(cur_hero._value)
			if find_hero == nil then
				resp.retcode = G_ERRCODE["BATTLE_SET_HERO_INFO"]
				player:SendToClient(SerializeCommand(resp))
				player:Log("OnCommand_BattleFieldJoinBattle, error=BATTLE_SET_HERO_INFO")
				return
			----elseif find_hero._hp == 0 then
			----	resp.retcode = G_ERRCODE["BATTLE_SET_HERO_INFO"]
			----	player:SendToClient(SerializeCommand(resp))
			----	player:Log("OnCommand_BattleFieldJoinBattle, error=BATTLE_SET_HERO_INFO")
			----	return
			end
			cur_hero_it:Next()
			cur_hero = cur_hero_it:GetValue()
		end
	end
	
	--在这里开始判断体力相关的东西
	if role._roledata._status._vp < (battlearmy_info.enter_tili + battlearmy_info.end_tili) then
		resp.retcode = G_ERRCODE["BATTLE_VP_LESS"]
		player:SendToClient(SerializeCommand(resp))

		--让这个玩家退回到上一次的位置
		resp = NewCommand("BattleFieldCancel_Re")
		resp.battle_id = arg.battle_id
		battle._cur_position = battle._last_position
		resp.retcode = G_ERRCODE["SUCCESS"]
		resp.position = battle._cur_position
		player:SendToClient(SerializeCommand(resp))
		return
	end

	ROLE_Subvp(role, battlearmy_info.enter_tili)

	--这里就可以返回正确了
	resp.retcode = G_ERRCODE["SUCCESS"]
	resp.battle_id = arg.battle_id
	resp.npc_id = arg.npc_id
	player:SendToClient(SerializeCommand(resp))
	
	resp.seed = math.random(1000000) --TODO:
	role._roledata._status._fight_seed = resp.seed
	role._roledata._status._time_line = G_ROLE_STATE["BATTLEFIELD"]
	return
end
