function OnCommand_GetCurBattleField(player, role, arg, others)
	player:Log("OnCommand_GetCurBattleField, "..DumpTable(arg).." "..DumpTable(others))

	local resp = NewCommand("GetCurBattleField_Re")
	resp.battle_id = role._roledata._status._cur_battle_id
	
	if role._roledata._status._cur_battle_id ~= 0 then
		local battle = role._roledata._battle_info:Find(role._roledata._status._cur_battle_id)
		resp.state = battle._state
	end
	player:SendToClient(SerializeCommand(resp))
end
