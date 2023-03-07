function OnCommand_MaShuUpdateScore(player, role, arg, others)
	player:Log("OnCommand_MaShuUpdateScore, "..DumpTable(arg).." "..DumpTable(others))

	local resp = NewComamnd("MaShuUpdateScore_Re")
	resp.retcode = G_ERRCODE["SUCCESS"]
	resp.score = arg.score
	if role._roledata._mashu_info._cur_mashu_score < arg.score then
		role._roledata._mashu_info._cur_mashu_score = arg.score
	end

	player:SendToClient(SerializeCommand(resp))
	return
end
