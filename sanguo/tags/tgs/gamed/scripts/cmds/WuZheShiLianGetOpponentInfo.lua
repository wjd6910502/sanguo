function OnCommand_WuZheShiLianGetOpponentInfo(player, role, arg, others)
	player:Log("OnCommand_WuZheShiLianGetOpponentInfo, "..DumpTable(arg).." "..DumpTable(others))

	local resp = NewCommand("WuZheShiLianGetOpponentInfo_Re")
	resp.retcode = G_ERRCODE["SUCCESS"]	
	
	local hero_trial = role._roledata._wuzhe_shilian

	--这里其实存在一个问题，客户端不是应该只能请求当前已经选择正在打得难度的信息吗？
	--他正在打难度1有必要给他难度2的信息
	resp.opponent_info = {}
	local f = hero_trial._attack_info:Find(arg.difficulty)	
	if f ~= nil then
		local sit = f._difficulty_attackinfo:SeekToBegin()
		local s = sit:GetValue()
		while s ~= nil do
			local opp_info ={}
			opp_info.id = s._id
			opp_info.level = s._level
			opp_info.alive = s._alive_flag		
			opp_info.stage = s._stage
			opp_info.hp = s._hp
			opp_info.anger = s._anger
			opp_info.rewardflag = s._reward_flag
			resp.opponent_info[#resp.opponent_info+1] = opp_info 
			sit:Next()
			s = sit:GetValue()		
		end
	else
		resp.retcode = G_ERRCODE["TRIAL_ACTIVE_PARAM_DIFFICULTY_WRONG"] 
	end
	
	player:SendToClient(SerializeCommand(resp))	
end
