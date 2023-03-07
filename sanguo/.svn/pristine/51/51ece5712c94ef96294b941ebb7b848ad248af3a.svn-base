function OnCommand_BattleFieldCancel(player, role, arg, others)
	player:Log("OnCommand_BattleFieldCancel, "..DumpTable(arg).." "..DumpTable(others))

	local resp = NewCommand("BattleFieldCancel_Re")
	resp.battle_id = arg.battle_id
	--这个操作不需要做其余的东西，只需要回到原来的位置就可以了
	
	--基本信息的判断
	local battle = role._roledata._battle_info:Find(arg.battle_id)
	if battle == nil then
		--直接给客户端返回，认为这个不存在
		resp.retcode = G_ERRCODE["BATTLE_ID_NOT_EXIST"]
		player:SendToClient(SerializeCommand(resp))
		player:Log("OnCommand_BattleFieldCancel, error=BATTLE_ID_NOT_EXIST")
		return
	end

	local position = battle._position_info:Find(battle._cur_position)
	position._flag = 2
	battle._attacked_flag = 0

	battle._cur_position = battle._last_position
	resp.retcode = G_ERRCODE["SUCCESS"]
	resp.position = battle._cur_position
	player:SendToClient(SerializeCommand(resp))
	
	resp = NewCommand("BattleFieldUpdateRoundState")
	battle._round_state = 3
	resp.battle_id = arg.battle_id
	resp.round_num = battle._round_num
	resp.round_state = battle._round_state
	player:SendToClient(SerializeCommand(resp))
	return
end
