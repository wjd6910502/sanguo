function OnCommand_BattleFieldGetEvent(player, role, arg, others)
	player:Log("OnCommand_BattleFieldGetEvent, "..DumpTable(arg).." "..DumpTable(others))

	--�������Ҫ��NPC�Ĵ����¼����ó��Ѿ������ˡ�
	local battle = role._roledata._battle_info:Find(arg.battle_id)
	if battle == nil then
		return
	end
	
	local position = battle._position_info:Find(battle._cur_position)
	local npc_it = position._npc_info:SeekToBegin()
	local npc = npc_it:GetValue()
	local cur_event = 0
	while npc ~= nil do
		if npc._event_flag == 0 and npc._alive == 1 then
			npc._event_flag = 1
			local ed = DataPool_Find("elementdata")
			local battlearmy_info = ed:FindBy("battlearmy_id", npc._armyid)
			cur_event = battlearmy_info.eventid
			break
		end
		npc_it:Next()
		npc = npc_it:GetValue()
	end

	--����ǹ���NPC���ϵ��¼�
	local resp = NewCommand("BattleFieldGetEvent_Re")
	resp.retcode = G_ERRCODE["SUCCESS"]
	resp.battle_id = arg.battle_id
	resp.event = cur_event
	
	if cur_event ~= 0 then
		resp.event_info = ROLE_GetBattleEventInfo(role, arg.battle_id, cur_event)
	end

	player:SendToClient(SerializeCommand(resp))

end