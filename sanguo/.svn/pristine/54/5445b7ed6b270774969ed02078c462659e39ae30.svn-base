function OnCommand_MaShuBegin(player, role, arg, others)
	player:Log("OnCommand_MaShuBegin, "..DumpTable(arg).." "..DumpTable(others))

	role._roledata._mashu_info._cur_mashu_id = arg.id
	role._roledata._mashu_info._cur_mashu_score = 0
	role._roledata._mashu_info._cur_mashu_stage = 0

	local resp = NewCommand("MaShuBegin_Re")
	resp.id = arg.id
	resp.retcode = G_ERRCODE["SUCCESS"]
	player:SendToClient(SerializeCommand(resp))

	role._roledata._mashu_info._buff:Clear()
	role._roledata._mashu_info._fight_friend._roleid:Set("0")
	role._roledata._mashu_info._fight_friend._name = ""
	role._roledata._mashu_info._fight_friend._zhanli = 0
	
	resp.seed = math.random(1000000) --TODO:
	role._roledata._status._fight_seed = resp.seed
	role._roledata._status._time_line = G_ROLE_STATE["MASHUDASAI"]

	return
end
