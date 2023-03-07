function OnCommand_BattleFieldRoundCount(player, role, arg, others)
	player:Log("OnCommand_BattleFieldRoundCount, "..DumpTable(arg).." "..DumpTable(others))
	
	local battle = role._roledata._battle_info:Find(arg.battle_id)

	local resp = NewCommand("BattleFieldRoundCount_Re")
	resp.battle_id = arg.battle_id

	if battle == nil then
		resp.retcode = G_ERRCODE["BATTLE_ID_NOT_EXIST"]
		player:SendToClient(SerializeCommand(resp))
		player:Log("OnCommand_BattleFieldRoundCount, error=BATTLE_ID_NOT_EXIST")
		return
	end
	
	if battle._round_flag ~= 0 then
		if battle._round_num > battle._round_flag then
			resp.retcode = G_ERRCODE["BATTLEFIELD_ROUND_COUNT_LESS"]
			player:SendToClient(SerializeCommand(resp))
			player:Log("OnCommand_BattleFieldRoundCount, error=BATTLEFIELD_ROUND_COUNT_LESS")
			return
		end
	end
	resp.retcode = G_ERRCODE["SUCCESS"]
	player:SendToClient(SerializeCommand(resp))
end
