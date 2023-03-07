function OnCommand_MaShuGetRankPrize(player, role, others)
	player:Log("OnCommand_MaShuGetRankPrize, "..DumpTable(arg).." "..DumpTable(others))
	

	local resp = NewCommand("MaShuGetRankPrize_Re")
	local now = API_GetTime()
	if now > role._roledata._mashu_info._timestamp then
		role._roledata._mashu_info._yestaday_rank = 0
	end

	resp.yestaday_rank = role._roledata._mashu_info._yestaday_rank
	if role._roledata._mashu_info._yestaday_rank == 0 then
		resp.retcode = G_ERRCODE["MASHU_GET_PRIZE_NOT_RANK"]
		player:SendToClient(SerializeCommand(resp))
		return
	end

	if role._roledata._mashu_info._get_prize_flag == 1 then
		resp.get_prize_flag = role._roledata._mashu_info._get_prize_flag
		resp.retcode = G_ERRCODE["MASHU_GET_PRIZE_HAVE_GET"]
		player:SendToClient(SerializeCommand(resp))
		return
	end

	--下面开始给奖励
	

	--设置信息
	role._roledata._mashu_info._get_prize_flag = 1
	resp.get_prize_flag = role._roledata._mashu_info._get_prize_flag
	resp.retcode = G_ERRCODE["SUCCESS"]
	player:SendToClient(SerializeCommand(resp))

	return

end
