function OnCommand_WuZheShiLianSweep(player, role, arg, others)
	player:Log("OnCommand_WuZheShiLianSweep, "..DumpTable(arg).." "..DumpTable(others))
		
	local resp = NewCommand("WuZheShiLianSweep_Re")
	resp.retcode = G_ERRCODE["SUCCESS"]
	resp.difficulty = arg.difficulty
	
	local hero_trial = role._roledata._wuzhe_shilian 
	--0-��������ȡ  1-������ȡ 2-��ȡ����
	local curdifficulty = arg.difficulty
	if curdifficulty ~= hero_trial._cur_difficulty then
		resp.retcode = G_ERRCODE["TRIAL_ACTIVE_PARAM_DIFFICULTY_WRONG"] 
		player:SendToClient(SerializeCommand(resp))
		return
	end
	
	local ed = DataPool_Find("elementdata")
	local quanju = ed.gamedefine[1]
	if quanju == nil then
		return
	end

	--����Ǯ������ ɨ��ÿ��15
	local cost_yuanbao = 0
	local trialdifficultyinfo  = hero_trial._attack_info:Find(curdifficulty)		
	local fit = trialdifficultyinfo._difficulty_attackinfo:SeekToBegin()
	local f = fit:GetValue()
	while f~= nil do
		if f._alive_flag == 1 then		
			cost_yuanbao = cost_yuanbao + quanju.shilian_saodang_cost 
		end

		fit:Next()
		f = fit:GetValue()
	end
	
	if cost_yuanbao == 0 then
		resp.retcode = G_ERRCODE["TRIAL_ACTIVE_STAGE_SWEEP_NOT_ALLOWED"]	
		player:SendToClient(SerializeCommand(resp))
		return
	end

	if cost_yuanbao > role._roledata._status._yuanbao then
		resp.retcode = G_ERRCODE["TRIAL_ACTIVE_YUANBAO_NOT_ENOUGH"] 
		player:SendToClient(SerializeCommand(resp))
		return
	else
		ROLE_SubYuanBao(role, cost_yuanbao)	
	end

	--�������йؿ�״̬
	local trialdifficultyinfo  = hero_trial._attack_info:Find(curdifficulty)		
	local fit = trialdifficultyinfo._difficulty_attackinfo:SeekToBegin()
	local f = fit:GetValue()
	while f~= nil do
		if f._alive_flag == 1 then
			f._alive_flag = 0
			f._reward_flag = 1
		end 
		fit:Next()
		f = fit:GetValue()
	end
	--]]
	
	player:SendToClient(SerializeCommand(resp))
end