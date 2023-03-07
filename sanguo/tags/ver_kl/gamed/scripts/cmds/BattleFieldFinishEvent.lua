function OnCommand_BattleFieldFinishEvent(player, role, arg, others)
	player:Log("OnCommand_BattleFieldFinishEvent, "..DumpTable(arg).." "..DumpTable(others))

	local resp = NewCommand("BattleFieldFinishEvent_Re")
	resp.battle_id = arg.battle_id
	resp.retcode = G_ERRCODE["SUCCESS"]

	--������Ҫ�ѵ�ǰ��������NPC���ŵ��¼����ó��Ѿ�����
	local battle = role._roledata._battle_info:Find(arg.battle_id)
	local position = battle._position_info:Find(battle._cur_position)
	
	--���濪ʼ�������������Ķ���
	if position._flag == 1 then
		--��ε��ƶ�������
		resp.join_battle_flag = 0
		player:SendToClient(SerializeCommand(resp))
		
		local ed = DataPool_Find("elementdata")
		local battle_info = ed:FindBy("battle_id", arg.battle_id)
		local battlefielddata_info = ed:FindBy("battlefielddata_id", battle_info.battlefieldid)

		local cur_event_id = 0
		if position._event_flag == 0 then
			for slot in DataPool_Array(battlefielddata_info.init_slots) do
				if slot.pos == battle._cur_position then
					cur_event_id = slot.eventid
					break
				end
			end
		end
	
		position._event_flag = 1
		--���Э��������ʾ����ƶ�������
		local resp = NewCommand("BattleFieldCapturedPosition")
		resp.battle_id = arg.battle_id
		resp.event = cur_event_id
		if cur_event_id ~= 0 then
			resp.event_info = ROLE_GetBattleEventInfo(role, arg.battle_id, cur_event_id)
		end
		player:SendToClient(SerializeCommand(resp))
		
		return
	elseif position._flag == 2 or position._flag == 3 then
		--�鿴�Ƿ��ез�NPC���еĻ�����ս����û�еĻ�����ֱ�����óɼ����ģ����Ҵ����¼�
		local army_flag = 0
		local npc_it = position._npc_info:SeekToBegin()
		local npc = npc_it:GetValue()
		while npc ~= nil do
			if npc._camp == 2 and npc._alive ~= 0 then
				army_flag = 1
				break
			end
			npc_it:Next()
			npc = npc_it:GetValue()
		end
		if army_flag == 1 then
			resp.join_battle_flag = 1
			player:SendToClient(SerializeCommand(resp))
			return
		else
			position._flag = 1
			
			resp.join_battle_flag = 0
			resp.event = 0
			player:SendToClient(SerializeCommand(resp))
		
			--���Э��������ʾ����ƶ�������
			local ed = DataPool_Find("elementdata")
			local battle_info = ed:FindBy("battle_id", arg.battle_id)
			local battlefielddata_info = ed:FindBy("battlefielddata_id", battle_info.battlefieldid)

			local cur_event_id = 0
			if position._event_flag == 0 then
				for slot in DataPool_Array(battlefielddata_info.init_slots) do
					if slot.pos == battle._cur_position then
						cur_event_id = slot.eventid
						break
					end
				end
			end
			position._event_flag = 1 
			
			local resp = NewCommand("BattleFieldCapturedPosition")
			resp.battle_id = arg.battle_id
			resp.position_info = ROLE_MakeBattleCurPositionInfo(role, arg.battle_id)
		
			if cur_event_id ~= 0 then
				resp.event_info = ROLE_GetBattleEventInfo(role, arg.battle_id, cur_event_id)
			end
			resp.event = cur_event_id
			player:SendToClient(SerializeCommand(resp))
		
			if battlefielddata_info.battle_target_type == 0 then
				if battlefielddata_info.enemy_camp_pos == battle._cur_position then
					battle._state = 2
			
					resp = NewCommand("ChangeBattleState")
					resp.battle_id = arg.battle_id
					resp.state = battle._state
					player:SendToClient(SerializeCommand(resp))
				end
			end
			
			return
		end
	end
end
