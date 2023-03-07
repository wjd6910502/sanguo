function OnMessage_PvpBegin(player, role, arg, others)
	player:Log("OnMessage_PvpBegin, "..DumpTable(arg).." "..DumpTable(others))

	if role._roledata._pvp._state == 0 then 
		player:Log("OnMessage_PvpBegin, "..role._roledata._pvp._state)
		return
	end
	--添加限次模板
	local ed = DataPool_Find("elementdata")
	local quanju = ed.gamedefine[1]
	LIMIT_AddUseLimit(role, quanju.pvp_daily_limit_times, 1)
	--修改成就
	TASK_ChangeCondition(role, G_ACH_TYPE["STAGE_PVP"], 0, 1)
	local resp = NewCommand("PVPBegin")
	resp.fight_start_time = arg.start_time
	resp.ip = arg.ip
	resp.port = arg.port

	player:SendToClient(SerializeCommand(resp))
end
