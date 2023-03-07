function OnCommand_EnterInstance(player, role, arg, others)
	player:Log("OnCommand_EnterInstance, "..DumpTable(arg))

	local msg = NewMessage("CheckClientVersion")
	player:SendMessage(role._roledata._base._id, SerializeMessage(msg))

	local resp = NewCommand("EnterInstance_Re")
	resp.retcode = 0
	resp.inst_tid = arg.inst_tid
	--判断这个副本是否满足了条件
	local ed = DataPool_Find("elementdata")
	local stage = ed:FindBy("stage_id", arg.inst_tid)
	if stage == nil then
		resp.retcode = G_ERRCODE["NO_STAGE"]--没有这个关卡
		player:SendToClient(SerializeCommand(resp))
		return
	end
	
	local vp = role._roledata._status._vp
	local need_vp = (stage.enter_tili + stage.finish_tili)
	if need_vp > vp then
		resp.retcode = G_ERRCODE["NO_ENOUGHVP"]--玩家的体力不足
		player:SendToClient(SerializeCommand(resp))
		return
	end
	
	if stage.limittimes ~= 0 then
		if LIMIT_TestUseLimit(role, stage.limittimes, 1) == false then
			resp.retcode = G_ERRCODE["NO_COUNT"]--这个副本没有了次数
			player:SendToClient(SerializeCommand(resp))
			return
		end
	end

	--前置关卡是否打过了,以及星级
	local instance = role._roledata._status._instances
	if stage.req_stage ~= 0 then
		local i = instance:Find(stage.req_stage)
		if i == nil then
			resp.retcode = G_ERRCODE["NO_REQSTAGE"]--还没有打通前置关卡
			player:SendToClient(SerializeCommand(resp))
			return
		else
			if i._star < stage.req_stagestars then
				resp.retcode = G_ERRCODE["NO_REQSTAR"]--前置关卡的星级，不符合要求
				player:SendToClient(SerializeCommand(resp))
				return
			end
		end
	end

	--判断玩家的等级是否达到了
	local level = role._roledata._status._level
	if level < stage.req_level then
		resp.retcode = G_ERRCODE["NO_LEVEL"]--玩家的等级没有达到这个关卡的要求
		player:SendToClient(SerializeCommand(resp))
		return
	end
	--开始判断武将信息
	local req_hero = ed:FindBy("requisite_role", arg.inst_tid)
	if req_hero == nil then
		if stage.stagetype == 0 then
			if role._roledata._status._last_hero:Size() == 0 then
				resp.retcode = G_ERRCODE["INSTANCE_NO_HERO"]--请先设置出战的武将
				player:SendToClient(SerializeCommand(resp))
				return
			end
		else
			if role._roledata._status._last_horse_hero._horse == 0 or role._roledata._status._last_horse_hero._heroinfo:Size() == 0 then
				resp.retcode = G_ERRCODE["INSTANCE_NO_HERO"]--请先设置出战的武将
				player:SendToClient(SerializeCommand(resp))
				return
			end
		end
	else
		--检查武将的合法性,检查玩家是否有这些武将
		local heros = role._roledata._hero_hall._heros

		for i = 1, table.getn(arg.heros) do
			local h = heros:Find(arg.heros[i])
			if h == nil then
				resp.retcode = G_ERRCODE["NO_HERO"]
				player:SendToClient(SerializeCommand(resp))
				return
			end
		end

		--if role._roledata._status._last_horse_hero._horse == 0 then
		--	resp.retcode = G_ERRCODE["INSTANCE_NO_HERO"]--请先设置出战的武将
		--	player:SendToClient(SerializeCommand(resp))
		--	return
		--end
	end
	ROLE_Subvp(role, stage.enter_tili)
	role._roledata._status._instance_id = arg.inst_tid

	resp.seed = math.random(1000000) --TODO:
	role._roledata._status._fight_seed = resp.seed
	role._roledata._status._time_line = G_ROLE_STATE["INSTANCE"]
	player:SendToClient(SerializeCommand(resp))
end
