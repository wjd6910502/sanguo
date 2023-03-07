function OnCommand_ResetBattleField(player, role, arg, others)
	player:Log("OnCommand_ResetBattleField, "..DumpTable(arg).." "..DumpTable(others))

	--老规矩，判断限次模板
	local resp = NewCommand("ResetBattleField_Re")
	resp.battle_id = arg.battle_id

	--判断等级，判断总次数
	local ed = DataPool_Find("elementdata")
	local quanju = ed.gamedefine[1]

	--判断等级
	if quanju.battle_open_lv > role._roledata._status._level then
		resp.retcode = G_ERRCODE["BATTLE_LEVEL_LESS"]
		player:SendToClient(SerializeCommand(resp))
		return
	end

	if quanju.battle_limit_id ~= 0 then
		if LIMIT_TestUseLimit(role, quanju.battle_limit_id, 1) == false then
			resp.retcode = G_ERRCODE["BATTLE_LIMIT_NO_COUNT"]
			player:SendToClient(SerializeCommand(resp))
			return
		end
	end

	local battle_info = ed:FindBy("battle_id", arg.battle_id)
	--if role._roledata._status._cur_battle_id ~= 0 then
	--	resp.retcode = 0
	--	player:SendToClient(SerializeCommand(resp))
	--	return
	--end
	--判断等级
	if role._roledata._status._level < battle_info.recommend_min_level then
		resp.retcode = G_ERRCODE["BATTLE_LEVEL_LESS"]
		player:SendToClient(SerializeCommand(resp))
		return
	end
	
	local reset_flag = 0
	if battle_info.limitid == 0 then
		reset_flag = ROLE_ResetBattleInfo(role, arg.battle_id)
	else
		if LIMIT_TestUseLimit(role, battle_info.limitid, 1) == true then
			reset_flag = ROLE_ResetBattleInfo(role, arg.battle_id)
		else
			resp.retcode = G_ERRCODE["BATTLE_LIMIT_NO_COUNT"]
			player:SendToClient(SerializeCommand(resp))
			return
		end
	end

	if reset_flag == 0 then
		if battle_info.limitid ~= 0 then
			LIMIT_AddUseLimit(role, battle_info.limitid, 1)
		end

		if quanju.battle_limit_id ~= 0 then
			LIMIT_AddUseLimit(role, quanju.battle_limit_id, 1)
		end
		resp.retcode = G_ERRCODE["SUCCESS"]
		resp.battle_info = ROLE_MakeBattleInfo(role, arg.battle_id)
		player:SendToClient(SerializeCommand(resp))

		--1的时候代表的是日常，2代表的是活动
		if arg.typ == 1 then
			role._roledata._status._cur_battle_id = arg.battle_id
			resp = NewCommand("GetCurBattleField_Re")
			resp.battle_id = role._roledata._status._cur_battle_id
			player:SendToClient(SerializeCommand(resp))
		end
		
		return
	else
		resp.retcode = G_ERRCODE["BATTLE_DATA_ERROR"]
		player:SendToClient(SerializeCommand(resp))
		return
	end
end
