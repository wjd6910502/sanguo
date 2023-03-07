function OnCommand_MilitaryJoinBattle(player, role, arg, others)
	player:Log("OnCommand_MilitaryJoinBattle, "..DumpTable(arg).." "..DumpTable(others))

	local resp = NewCommand("MilitaryJoinBattle_Re")
	if arg.stage_id == 0 or arg.hero_id == 0 then
		return
	end	

	local team = role._roledata._hero_all_team:Find(G_HERO_TEAM_TYP["JUNWUBAOKU"..arg.stage_id])
	if team == nil or team._cur_hero_ids:Size() > 3 then
		resp.retcode = G_ERRCODE["MILITARY_ERROR_TEAM"]
		player:SendToClient(SerializeCommand(resp))
		player:Log("OnCommand_MilitaryJoinBattle, error=MILITARY_ERROR_TEAM1")
		return
	end	

	local ed = DataPool_Find("elementdata")
	local military = ed:FindBy("military", arg.stage_id)
	if military == nil then
		resp.retcode = G_ERRCODE["MILITARY_ERROR_ARG"]
		player:SendToClient(SerializeCommand(resp))
		player:Log("OnCommand_MilitaryJoinBattle, error=MILITARY_ERROR_ARG1")
		return
	end

	--活动今天是否开启
	local now = API_GetTime()
	local date = os.date("*t", now)

	if military.open_day[date.wday] == 0 then
		resp.retcode = G_ERRCODE["MILITARY_ERROR_ACTIVIE"]
		player:SendToClient(SerializeCommand(resp))
		player:Log("OnCommand_MilitaryJoinBattle, error=MILITARY_ERROR_ACTIVIE")
		return	
	end

	--活动等级
	if role._roledata._status._level < military.dificulty_level then
		resp.retcode = G_ERRCODE["MILITARY_ERROR_LEVEL"]
		player:SendToClient(SerializeCommand(resp))
		player:Log("OnCommand_MilitaryJoinBattle, error=MILITARY_ERROR_LEVEL1")
		return
	end

	local battle_info = military.nandu_set[arg.difficult]
	if battle_info == nil then
		resp.retcode = G_ERRCODE["MILITARY_ERROR_ARG"]
		player:SendToClient(SerializeCommand(resp))
		player:Log("OnCommand_MilitaryJoinBattle, error=MILITARY_ERROR_ARG2")
		return
	end	

	--关卡等级
	if role._roledata._status._level < battle_info.nandu_dificulty_level then
		resp.retcode = G_ERRCODE["MILITARY_ERROR_LEVEL"]
		player:SendToClient(SerializeCommand(resp))
		player:Log("OnCommand_MilitaryJoinBattle, error=MILITARY_ERROR_LEVEL")
		return
	end	

	local info = role._roledata._military_data._stage_data:Find(arg.stage_id)
	if info ~= nil then
		--cd时间
		if info._cd > now then
			resp.retcode = G_ERRCODE["MILITARY_ERROR_CD"]
			player:SendToClient(SerializeCommand(resp))
			player:Log("OnCommand_MilitaryJoinBattle, error=MILITARY_ERROR_CD")
			return
		end 

		--已经战斗次数
		if info._times >= military.daily_limit then
			resp.retcode = G_ERRCODE["MILITARY_ERROR_TIMES"]
			player:SendToClient(SerializeCommand(resp))
			player:Log("OnCommand_MilitaryJoinBattle, error=MILITARY_ERROR_TIMES")
			return
		end
	end	

	--可以进入了
	role._roledata._military_data._stage_id = arg.stage_id
	role._roledata._military_data._stage_difficult = arg.difficult

	resp.retcode = G_ERRCODE["SUCCESS"]
	resp.hero_id = arg.hero_id
	resp.stage_id = arg.stage_id
	resp.difficult = arg.difficult	
	player:SendToClient(SerializeCommand(resp))
	return	
end
