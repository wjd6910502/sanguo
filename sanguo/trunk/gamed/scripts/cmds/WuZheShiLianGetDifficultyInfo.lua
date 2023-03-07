function OnCommand_WuZheShiLianGetDifficultyInfo(player, role, arg, others)
	player:Log("OnCommand_WuZheShiLianGetDifficultyInfo, "..DumpTable(arg).." "..DumpTable(others))
		
	local resp = NewCommand("WuZheShiLianGetDifficultyInfo_Re")
	local hero_trial = role._roledata._wuzhe_shilian
	
	--��ʼ������һ���佫id
	if hero_trial._cur_difficulty == 0 and hero_trial._high_difficulty == 0 then
		ROLE_UpdateWuZheShiLianInfo(role)
	else
		--��һ����ȡ������� ��Ҫ����Ƿ�����
		local ed = DataPool_Find("elementdata")
		local activity = ed.wanfahuodong
		if activity == nil then
			return
		end

		for act in DataPool_Array(activity) do
			if act.id == 17093 and role._roledata._status._level < act.start_level1  then
				resp.retcode = G_ERRCODE["TRIAL_ACTIVE_LEVEL_NOT_ENOUGH"]
				player:SendToClient(SerializeCommand(resp))
				player:Log("OnCommand_WuZheShiLianGetDifficultyInfo, error=TRIAL_ACTIVE_LEVEL_NOT_ENOUGH")
				return
			end			
		end
	end
		
	--��һ�ε�½ �Ѷȶ��� 1-��  2-�� 3-��  4-���� 5-��ŭ
	resp.cur_difficulty = hero_trial._cur_difficulty
	resp.high_difficulty = hero_trial._high_difficulty
	resp.difficulty_info = {}
	local fit = hero_trial._attack_info:SeekToBegin()
	local f = fit:GetValue()	
	while f~=nil do
		local dif_info = {}
		dif_info.camp = f._camp
		dif_info.difficulty = f._difficulty	
		resp.difficulty_info[#resp.difficulty_info+1] = dif_info
		fit:Next()
		f = fit:GetValue()			
	end
	
	player:SendToClient(SerializeCommand(resp))

end
