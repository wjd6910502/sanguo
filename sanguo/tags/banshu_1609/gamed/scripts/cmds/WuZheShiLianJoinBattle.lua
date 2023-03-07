function OnCommand_WuZheShiLianJoinBattle(player, role, arg, others)
	player:Log("OnCommand_WuZheShiLianJoinBattle, "..DumpTable(arg).." "..DumpTable(others))
	
	local resp = NewCommand("WuZheShiLianJoinBattle_Re")
	resp.retcode = G_ERRCODE["SUCCESS"]

	local hero_trial = role._roledata._wuzhe_shilian 
	
	--��Ҫ��֤��ǰ�ѶȵĹؿ���Ϣ�Ƿ���	
	if arg.difficulty ~= hero_trial._cur_difficulty then
		--��ǰ�ѶȲ���ȷ
		resp.retcode = G_ERRCODE["TRIAL_ACTIVE_PARAM_DIFFICULTY_WRONG"] 
		player:SendToClient(SerializeCommand(resp))
		return
	end
	
	--��֤�ؿ����ݶԲ���
	local f = hero_trial._attack_info:Find(arg.difficulty)
	if f ~= nil then
		local s = f._difficulty_attackinfo:Find(arg.stage)
		if s ~= nil then
			if s._alive_flag == 1 then
				hero_trial._cur_stage = s._stage
			else
				resp.retcode = G_ERRCODE["TRIAL_ACTIVE_STAGE_STAGE_PASSED"]
				player:SendToClient(SerializeCommand(resp))
				return
			end
		else
			resp.retcode = G_ERRCODE["TRIAL_ACTIVE_PARAM_STAGE_WRONG"]
			player:SendToClient(SerializeCommand(resp))
			return					
		end
	else
		resp.retcode = G_ERRCODE["TRIAL_ACTIVE_DIFFICULTY_NOT_FOUND"]
		player:SendToClient(SerializeCommand(resp))
		return
	end
	
	if #arg.heros < 1 then		
		resp.retcode = G_ERRCODE["TRIAL_ACTIVE_STAGE_HERO_NOT_SELECTED"]
		player:SendToClient(SerializeCommand(resp))
		return 
	end

	for i = 1, #arg.heros do
		local hero_id  = arg.heros[i]
		--�ж��Ƿ���Ӣ���б���
		local f = role._roledata._hero_hall._heros:Find(hero_id)
		if f == nil then	
			--�佫������
			resp.restcode = G_ERRCODE["TRIAL_ACTIVE_PARAM_HERO_NOT_EXIST"]
			player:SendToClient(SerializeCommand(resp))	
			return
		end
		
		local s = hero_trial._dead_hero_info:Find(hero_id)
		if s ~= nil then
			--����Ӣ�۲���������
			resp.retcode = G_ERRCODE["TRIAL_ACTIVE_PARAM_HERO_DEAD"] 
			player:SendToClient(SerializeCommand(resp))
			return
		end		
	end


	resp.seed = math.random(1000000) --TODO:
	role._roledata._status._fight_seed = resp.seed
	role._roledata._status._time_line = G_ROLE_STATE["WUZHESHILIAN"]
	player:SendToClient(SerializeCommand(resp))

end