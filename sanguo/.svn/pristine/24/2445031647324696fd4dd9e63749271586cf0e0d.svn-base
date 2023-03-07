function OnCommand_MafiaJiSi(player, role, arg, others)
	player:Log("OnCommand_MafiaJiSi, "..DumpTable(arg).." "..DumpTable(others))
	
	local mafia_data = others.mafias[role._roledata._mafia._id:ToStr()]

	local resp = NewCommand("MafiaJiSi_Re")
	resp.jisi_typ = arg.jisi_typ
	--查看是否还有次数。没有次数的话，给客户端返回去
	local ed = DataPool_Find("elementdata")
	local quanju = ed.gamedefine[1]

	local jisi_info = ed:FindBy("leaguebuild_typ", arg.jisi_typ)

	if jisi_info == nil then
		resp.retcode = G_ERRCODE["MAFIA_JISI_TYP_ERR"]
		player:SendToClient(SerializeCommand(resp))
		return
	end

	if mafia_data == nil then
		resp.retcode = G_ERRCODE["NO_MAFIA"]
		player:SendToClient(SerializeCommand(resp))
		return
	end
	
	if LIMIT_TestUseLimit(role, quanju.league_build_maxtimes, 1) == false then
		resp.retcode = G_ERRCODE["MAFIA_JISI_MAX_NUM"]
		player:SendToClient(SerializeCommand(resp))
		return
	end

	--查看祭祀费用是否足够
	if jisi_info.cost_coin_type == 1 then
		if role._roledata._status._money < jisi_info.cost_coin_num then
			resp.retcode = G_ERRCODE["MAFIA_JISI_MONEY_ERR"]
			player:SendToClient(SerializeCommand(resp))
			return
		end
		ROLE_SubMoney(role, jisi_info.cost_coin_num)
	elseif jisi_info.cost_coin_type == 2 then
		if role._roledata._status._yuanbao < jisi_info.cost_coin_num then
			resp.retcode = G_ERRCODE["MAFIA_JISI_YUANBAO_ERR"]
			player:SendToClient(SerializeCommand(resp))
			return
		end
		ROLE_SubYuanBao(role, jisi_info.cost_coin_num)
	else
		resp.retcode = G_ERRCODE["MAFIA_JISI_TYP_ERR"]
		player:SendToClient(SerializeCommand(resp))
		return
	end

	local mafia_info = mafia_data._data
	--在这里开始进行祭祀，根据祭祀类型修改祭祀进度和帮会经验
	LIMIT_AddUseLimit(role, quanju.league_build_maxtimes, 1)
	
	local notice_flag = false
	mafia_info._jisi = mafia_info._jisi + jisi_info.daily_rate_get
	notice_flag = true

	local league_level_info = ed:FindBy("league_level", mafia_info._level)
	if league_level_info.exp ~= 0 then
		mafia_info._exp = mafia_info._exp + jisi_info.exp_get
		notice_flag = true

		if mafia_info._exp >= league_level_info.exp then
			mafia_info._level = mafia_info._level + 1

			local second_league_level_info = ed:FindBy("league_level", mafia_info._level)
			if second_league_level_info.exp ~= 0 then
				mafia_info._exp = mafia_info._exp - league_level_info.exp
			else
				mafia_info._exp = 0
			end
		end
	end

	--广播变化
	if notice_flag == true then
		MAFIA_MafiaUpdateExp(mafia_info)
	end

	MAFIA_MafiaUpdateJiSi(mafia_info, jisi_info.daily_rate_get)
	
	resp.retcode = 0
	player:SendToClient(SerializeCommand(resp))
	return
end
