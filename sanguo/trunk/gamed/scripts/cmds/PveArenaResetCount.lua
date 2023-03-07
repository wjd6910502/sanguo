function OnCommand_PveArenaResetCount(player, role, arg, others)
	player:Log("OnCommand_PveArenaResetCount, "..DumpTable(arg).." "..DumpTable(others))

	local resp = NewCommand("PveArenaResetCount_Re")
	local ed = DataPool_Find("elementdata")
	local quanju = ed.gamedefine[1]

	if LIMIT_TestResetUseLimit(role, quanju.arena_free_times) == false then
		resp.retcode = G_ERRCODE["JJC_BUY_PK_COUNT_ERR"]
		player:SendToClient(SerializeCommand(resp))
		player:Log("OnCommand_PveArenaResetCount, error=JJC_BUY_PK_COUNT_ERR")
		return
	else
		if LIMIT_TestUseLimit(role, quanju.arena_buy_times_id, 1) == false then
			resp.retcode = G_ERRCODE["JJC_BUY_PK_COUNT_MAX"]
			player:SendToClient(SerializeCommand(resp))
			player:Log("OnCommand_PveArenaResetCount, error=JJC_BUY_PK_COUNT_MAX")
			return
		end

		local buy_count = LIMIT_GetUseLimit(role, quanju.arena_buy_times_id)
		local need_yuanbao = 0
		local flag = 0
		for price in DataPool_Array(quanju.arena_buy_price) do
			if flag == buy_count then
				need_yuanbao = price
				break
			end
			flag = flag + 1
		end

		if need_yuanbao == 0 then
			resp.retcode = G_ERRCODE["JJC_BUY_PK_COUNT_SYSREM_ERR"]
			player:SendToClient(SerializeCommand(resp))
			player:Log("OnCommand_PveArenaResetCount, error=JJC_BUY_PK_COUNT_SYSREM_ERR")
			return
		end

		local curr_yuanbao = role._roledata._status._yuanbao
		if curr_yuanbao < need_yuanbao then
			resp.retcode = G_ERRCODE["JJC_BUY_PK_COUNT_YUANBAO_LESS"]
			player:SendToClient(SerializeCommand(resp))
			player:Log("OnCommand_PveArenaResetCount, error=JJC_BUY_PK_COUNT_YUANBAO_LESS")
			return
		end

		ROLE_SubYuanBao(role, need_yuanbao)
		LIMIT_AddUseLimit(role, quanju.arena_buy_times_id, 1)
		LIMIT_ReduceUseLimit(role, quanju.arena_free_times, 1)
		resp.retcode = G_ERRCODE["SUCCESS"]
		player:SendToClient(SerializeCommand(resp))
		return
	end
	
end
