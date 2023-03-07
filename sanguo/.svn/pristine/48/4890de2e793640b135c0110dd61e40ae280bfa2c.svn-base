function OnCommand_DaTiGetInfo(player, role, arg, others)
	player:Log("OnCommand_DaTiGetInfo, "..DumpTable(arg).." "..DumpTable(others))

	local resp = NewCommand("DaTiGetInfo_Re")
	
	resp.cur_num = role._roledata._dati_data._cur_num
	resp.cur_right_num = role._roledata._dati_data._cur_right_num
	resp.today_reward = role._roledata._dati_data._today_reward
	resp.exp = role._roledata._dati_data._exp
	resp.yuanbao = role._roledata._dati_data._yuanbao
	resp.history_right_num = role._roledata._dati_data._history_right_num
	resp.use_time = role._roledata._dati_data._use_time
	resp.history_use_time = role._roledata._dati_data._history_use_time
	player:SendToClient(SerializeCommand(resp))
	player:Log("OnCommand_DaTiGetInfo, "..resp.cur_num..", "..resp.cur_right_num..", "..role._roledata._dati_data._today_reward)

	return
	
end
