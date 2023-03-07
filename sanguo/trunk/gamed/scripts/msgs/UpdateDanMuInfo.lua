function OnMessage_UpdateDanMuInfo(player, role, arg, others)
	player:Log("OnMessage_UpdateDanMuInfo, "..DumpTable(arg).." "..DumpTable(others))

	local resp = NewCommand("DanMuInfo")
	resp.typ = 1
	resp.info = {}
	resp.info.info = {}

	local tmp_info = {}
	tmp_info.role_id = arg.role_id
	tmp_info.role_name = arg.role_name
	tmp_info.tick = arg.tick
	tmp_info.danmu_info = arg.danmu_info

	resp.info.info[#resp.info.info+1] = tmp_info

	player:SendToClient(SerializeCommand(resp))
end
