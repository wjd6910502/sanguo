function OnCommand_GetPveArenaHistory(player, role, arg, others)
	player:Log("OnCommand_GetPveArenaHistory, "..DumpTable(arg).." "..DumpTable(others))

	local resp = NewCommand("GetPveArenaHistory_Re")
	resp.retcode = G_ERRCODE["SUCCESS"]
	resp.hisroty_info = {}

	local history_info_it = role._roledata._pve_arena_info._pve_arena_history:SeekToBegin()
	local history_info = history_info_it:GetValue()
	while history_info ~= nil do
		local tmp_history = {}
		tmp_history.match_id = history_info._match_id
		tmp_history.id = history_info._id
		tmp_history.name = history_info._name
		tmp_history.win_flag = history_info._win_flag
		tmp_history.attack_flag = history_info._attack_flag
		tmp_history.time = history_info._time
		tmp_history.self_level = history_info._self_level
		tmp_history.oppo_level = history_info._oppo_level
		tmp_history.self_mafia = history_info._self_mafia
		tmp_history.oppo_mafia = history_info._oppo_mafia
		tmp_history.reply_flag = history_info._reply_flag
		resp.hisroty_info[#resp.hisroty_info+1] = tmp_history

		history_info_it:Next()
		history_info = history_info_it:GetValue()
	end

	role:SendToClient(SerializeCommand(resp))
	
	role._roledata._pve_arena_info._new_video = 0
	local resp = NewCommand("PveArenaUpdateVideoFlag")
	resp.video_flag = 0
	role:SendToClient(SerializeCommand(resp))

	return
end