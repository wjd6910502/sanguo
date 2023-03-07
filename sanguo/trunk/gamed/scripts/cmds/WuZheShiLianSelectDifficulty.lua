function OnCommand_WuZheShiLianSelectDifficulty(player, role, arg, others)
	player:Log("OnCommand_WuZheShiLianSelectDifficulty, "..DumpTable(arg).." "..DumpTable(others))
		
	local resp = NewCommand("WuZheShiLianSelectDifficulty_Re")
	resp.retcode = G_ERRCODE["SUCCESS"]
	
	-- 难度定义 1-低  2-中 3-高  4-极高 5-暴怒
	local difficulty = arg.difficulty

	local hero_trial = role._roledata._wuzhe_shilian	

	--这里需要明确_high_difficulty代表的含义 最高难度是需要处理的
	local max_difficulty = 1
	if hero_trial._high_difficulty > hero_trial._cur_difficulty then
		max_difficulty = hero_trial._high_difficulty + 1
	elseif hero_trial._high_difficulty == 0 then
		max_difficulty = 1
	else
		max_difficulty = hero_trial._cur_difficulty
	end

	if difficulty < 1 or difficulty > max_difficulty then
		--关卡尚未开启
		resp.retcode = G_ERRCODE["TRIAL_ACTIVE_DIFFICULTY_LOCK"]
		player:SendToClient(SerializeCommand(resp))
		player:Log("OnCommand_WuZheShiLianSelectDifficulty, error=TRIAL_ACTIVE_DIFFICULTY_LOCK")
		return
	end
		
	--已经有难度
	if hero_trial._cur_difficulty ~= 0 and hero_trial._cur_difficulty ~= difficulty then
		resp.retcode = G_ERRCODE["TRIAL_ACTIVE_DIFFICULTY_LOCK"]
		player:SendToClient(SerializeCommand(resp))
		player:Log("OnCommand_WuZheShiLianSelectDifficulty, error=TRIAL_ACTIVE_DIFFICULTY_LOCK")
		return
	else
		hero_trial._cur_difficulty = difficulty
	end
	
	resp.cur_diffculty = hero_trial._cur_difficulty
		
	player:SendToClient(SerializeCommand(resp))

end
