function OnCommand_GetBattleFieldInfo(player, role, arg, others)
	player:Log("OnCommand_GetBattleFieldInfo, "..DumpTable(arg).." "..DumpTable(others))

	local resp = NewCommand("GetBattleFieldInfo_Re")
	resp.battle_id = arg.battle_id

	local battle = role._roledata._battle_info:Find(arg.battle_id)

	if battle == nil then
		--直接给客户端返回，认为这个不存在
		resp.retcode = G_ERRCODE["BATTLE_ID_NOT_EXIST"]
		player:SendToClient(SerializeCommand(resp))
		player:Log("OnCommand_GetBattleFieldInfo, error=BATTLE_ID_NOT_EXIST")
		return
	end
	
	resp.battle_info = ROLE_MakeBattleInfo(role, arg.battle_id)
	resp.retcode = G_ERRCODE["SUCCESS"]
	player:SendToClient(SerializeCommand(resp))
	return
end
