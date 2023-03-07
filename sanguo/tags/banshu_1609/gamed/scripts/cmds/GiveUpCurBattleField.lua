function OnCommand_GiveUpCurBattleField(player, role, arg, others)
	player:Log("OnCommand_GiveUpCurBattleField, "..DumpTable(arg).." "..DumpTable(others))

	role._roledata._status._cur_battle_id = 0

	local resp = NewCommand("GiveUpCurBattleField_Re")
	resp.retcode = G_ERRCODE["SUCCESS"]
	player:SendToClient(SerializeCommand(resp))
end
