function OnCommand_WuZheShiLianReset(player, role, arg, others)
	player:Log("OnCommand_WuZheShiLianReset, "..DumpTable(arg).." "..DumpTable(others))

	local resp = NewCommand("WuZheShiLianReset_Re")
	resp.retcode = G_ERRCODE["SUCCESS"]

	local ed = DataPool_Find("elementdata")
	local quanju = ed.gamedefine[1]
	if LIMIT_TestUseLimit(role, quanju.shilian_renew_limit_id, 1) == true then
		local high_difficulty =	role._roledata._wuzhe_shilian._high_difficulty 
		ROLE_UpdateWuZheShiLianInfo(role)
		role._roledata._wuzhe_shilian._high_difficulty = high_difficulty

		LIMIT_AddUseLimit(role, quanju.shilian_renew_limit_id, 1) 	
	else
		resp.retcode = G_ERRCODE["TRIAL_ACTIVE_HAS_REFRESH"]
	end
	
	player:SendToClient(SerializeCommand(resp))
	
end
