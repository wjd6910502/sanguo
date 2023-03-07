function OnMessage_TongQueTaiFail(player, role, arg, others)
	player:Log("OnMessage_TongQueTaiFail, "..DumpTable(arg).." "..DumpTable(others))

	role._roledata._tongquetai_data._cur_tongquetai_id = 0
	role._roledata._tongquetai_data._cur_state = 0
	role._roledata._tongquetai_data._double_flag = 0

	local resp = NewCommand("TongQueTaiEnd")
	resp.retcode = G_ERRCODE["TONGQUETAI_FAIL_PLAYER_DROP"]
	player:SendToClient(SerializeCommand(resp))
end
