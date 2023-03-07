function OnCommand_PveArenaResetTime(player, role, arg, others)
	player:Log("OnCommand_PveArenaResetTime, "..DumpTable(arg).." "..DumpTable(others))

	local resp = NewCommand("PveArenaResetTime_Re")
	--首先判断时间是否需要重置
	local ed = DataPool_Find("elementdata")
	local quanju = ed.gamedefine[1]

	local now = API_GetTime()
	if (now - role._roledata._pve_arena_info._last_attack_time) >= quanju.arena_pk_cd then
		resp.retcode = G_ERRCODE["JJC_RESET_PK_CD_ERR"]
		resp.last_time = role._roledata._pve_arena_info._last_attack_time
		player:SendToClient(SerializeCommand(resp))
		return
	end

	if role._roledata._status._yuanbao < quanju.arena_cd_remove_cost then
		resp.retcode = G_ERRCODE["JJC_RESET_PK_CD_YUANBAO_LESS"]
		resp.last_time = role._roledata._pve_arena_info._last_attack_time
		player:SendToClient(SerializeCommand(resp))
		return
	end

	--在这里开始扣除元宝，重置CD
	ROLE_SubYuanBao(role, quanju.arena_cd_remove_cost)
	role._roledata._pve_arena_info._last_attack_time = role._roledata._pve_arena_info._last_attack_time - quanju.arena_pk_cd

	resp.retcode = G_ERRCODE["SUCCESS"]
	resp.last_time = role._roledata._pve_arena_info._last_attack_time
	player:SendToClient(SerializeCommand(resp))
	return

end
