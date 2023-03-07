function OnCommand_WuZheShiLianSelectDifficulty(player, role, arg, others)
	player:Log("OnCommand_WuZheShiLianSelectDifficulty, "..DumpTable(arg).." "..DumpTable(others))
		
	local resp = NewCommand("WuZheShiLianSelectDifficulty_Re")
	resp.retcode = G_ERRCODE["SUCCESS"]
	
	-- �Ѷȶ��� 1-��  2-�� 3-��  4-���� 5-��ŭ 
	local difficulty = arg.difficulty

	local hero_trial = role._roledata._wuzhe_shilian	

	--������Ҫ��ȷ_high_difficulty�����ĺ��� ����Ѷ�����Ҫ������
	local max_difficulty = 1
	if hero_trial._high_difficulty > hero_trial._cur_difficulty then
		max_difficulty = hero_trial._high_difficulty + 1
	elseif hero_trial._high_difficulty == 0 then
		max_difficulty = 1
	else
		max_difficulty = hero_trial._cur_difficulty
	end

	if difficulty < 1 or difficulty > max_difficulty then
		--�ؿ���δ����
		resp.retcode = G_ERRCODE["TRIAL_ACTIVE_DIFFICULTY_LOCK"] 
		player:SendToClient(SerializeCommand(resp))
		return
	end
		
	--�Ѿ����Ѷ�
	if hero_trial._cur_difficulty ~= 0 and hero_trial._cur_difficulty ~= difficulty then
		resp.retcode = G_ERRCODE["TRIAL_ACTIVE_DIFFICULTY_LOCK"]
		player:SendToClient(SerializeCommand(resp))
		return
	else
		hero_trial._cur_difficulty = difficulty
	end
	
	resp.cur_diffculty = hero_trial._cur_difficulty
		
	player:SendToClient(SerializeCommand(resp))

end