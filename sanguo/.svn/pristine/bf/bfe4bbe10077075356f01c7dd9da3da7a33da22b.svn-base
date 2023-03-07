function OnCommand_MaShuBegin(player, role, arg, others)
	player:Log("OnCommand_MaShuBegin, "..DumpTable(arg).." "..DumpTable(others))

	local resp = NewCommand("MaShuBegin_Re")
	resp.id = arg.id
	--ºÏ≤ÈPVP∞Ê±æ
	local cur_pvp_ver = ROLE_GetPVPVersion(role._roledata._client_ver._client_id, role._roledata._client_ver._exe_ver, role._roledata._client_ver._data_ver)
	if cur_pvp_ver <= 0 then
		local resp = NewCommand("ErrorInfo")
		resp.error_id = G_ERRCODE["EXE_OUT_OF_DATE"]
		player:SendToClient(SerializeCommand(resp))
		player:Log("OnCommand_MaShuBegin, error=EXE_OUT_OF_DATE")
		return
	end
	
	role._roledata._mashu_info._cur_mashu_id = arg.id
	role._roledata._mashu_info._cur_mashu_score = 0
	role._roledata._mashu_info._cur_mashu_stage = 0

	local ed = DataPool_Find("elementdata")
	local quanju = ed.gamedefine[1]
	local size = 0
	for data in DataPool_Array(quanju.equestrain_possible_scene_id) do
		size = size + 1
	end	

	if size > 0 then
		local rand = math.random(1, size)
		resp.scene = quanju.equestrain_possible_scene_id[rand]
	end

	resp.retcode = G_ERRCODE["SUCCESS"]
	player:SendToClient(SerializeCommand(resp))

	role._roledata._mashu_info._buff:Clear()
	role._roledata._mashu_info._fight_friend._roleid:Set("0")
	role._roledata._mashu_info._fight_friend._name = ""
	role._roledata._mashu_info._fight_friend._zhanli = 0
	
	resp.seed = math.random(1000000) --TODO:
	role._roledata._status._fight_seed = resp.seed
	role._roledata._status._time_line = G_ROLE_STATE["MASHUDASAI"]

	TASK_ChangeCondition(role, G_ACH_TYPE["STAGE_COUNT"], G_ACH_EIGHT_TYPE["MASHUDASAI"] , 1)
	
	return
end
