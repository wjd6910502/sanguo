function OnCommand_BattleFieldGetEvent(player, role, arg, others)
	player:Log("OnCommand_BattleFieldGetEvent, "..DumpTable(arg).." "..DumpTable(others))

	--在这里就要把NPC的触发事件设置成已经触发了。
	local battle = role._roledata._battle_info:Find(arg.battle_id)
	if battle == nil then
		return
	end
	
	local position = battle._position_info:Find(battle._cur_position)
	local npc_it = position._npc_info:SeekToBegin()
	local npc = npc_it:GetValue()
	while npc ~= nil do
		npc._event_flag = 1
		npc_it:Next()
		npc = npc_it:GetValue()
	end
	
	local resp = NewCommand("BattleFieldGetEvent_Re")
	resp.retcode = G_ERRCODE["SUCCESS"]
	resp.battle_id = arg.battle_id
	resp.event = 0
	player:SendToClient(SerializeCommand(resp))

	----判断这个战役的结束是否是占领这个格子，是的话直接让这个战役结束，然后发送奖励
	----胜利条件（0占领大营/1击败总大将）
	--local ed = DataPool_Find("elementdata")
	--local battle_info = ed:FindBy("battle_id", arg.battle_id)
	--local battlefielddata_info = ed:FindBy("battlefielddata_id", battle_info.battlefieldid)
	--if battlefielddata_info.battle_target_type == 0 then
	--	if battlefielddata_info.enemy_camp_pos == battle._cur_position then
	--		battle._state = 2
	--
	--		resp = NewCommand("ChangeBattleState")
	--		resp.battle_id = arg.battle_id
	--		resp.state = battle._state
	--		player:SendToClient(SerializeCommand(resp))
	--		return
	--	end
	--elseif battlefielddata_info.battle_target_type == 1 then
	--	local npc_it = position._npc_info:SeekToBegin()
	--	local npc = npc_it:GetValue()
	--	while npc ~= nil do
	--		if npc.armyid == battlefielddata_info.enemy_leader_id then
	--			battle._state = 2
	--
	--			resp = NewCommand("ChangeBattleState")
	--			resp.battle_id = arg.battle_id
	--			resp.state = battle._state
	--			player:SendToClient(SerializeCommand(resp))
	--			return
	--		end
	--		npc_it:Next()
	--		npc = npc_it:GetValue()
	--	end
	--end
end
