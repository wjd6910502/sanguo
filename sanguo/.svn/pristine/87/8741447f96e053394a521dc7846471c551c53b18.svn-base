function OnMessage_PvpEnd(player, role, arg, others)
	player:Log("OnMessage_PvpEnd, "..DumpTable(arg).." "..DumpTable(others))

	if role._roledata._pvp._state == 0 then
		return
	end

	if role._roledata._status._time_line ~= G_ROLE_STATE["PVP"] then
		return
	end


	role._roledata._pvp._typ = 0
	role._roledata._pvp._id = 0
	role._roledata._pvp._state = 0
	--这里确认一件事情，那就是胜利一次，肯定不会连升两级。因为一次做多才可以给两颗星

	local ed = DataPool_Find("elementdata")
	local quanju = ed.gamedefine[1]

	if arg.reason == 1 then	--胜利
		if role._roledata._pvp_info._win_flag > 0 then
			role._roledata._pvp_info._win_flag = role._roledata._pvp_info._win_flag + 1
		else
			role._roledata._pvp_info._win_flag = 1
		end

		role._roledata._pvp_info._win_count = role._roledata._pvp_info._win_count + 1
		role._roledata._pvp_info._failed_count_in_succession = 0
		role._roledata._pvp_info._elo_score = role._roledata._pvp_info._elo_score + arg.score

		if arg.typ == 1 then --完胜
			role._roledata._pvp_info._win_victory = role._roledata._pvp_info._win_victory + 1
		end
		
		--更新玩家的武将出战信息
		local hero_pvp_info = role._roledata._pvp_info._hero_pvp_info
		local pvp_last_hero = role._roledata._pvp_info._last_hero

		local pvp_last_hero_it = pvp_last_hero:SeekToBegin()
		local last_hero = pvp_last_hero_it:GetValue()
		while last_hero ~= nil do
			local hero_pvp = hero_pvp_info:Find(last_hero._value)
			if hero_pvp == nil then
				local tmp_hero = CACHE.HeroPVPInfo()
				tmp_hero._join_count = 1
				tmp_hero._win_count = 1
				hero_pvp_info:Insert(last_hero._value, tmp_hero)
			else
				hero_pvp._join_count = hero_pvp._join_count + 1
				hero_pvp._win_count = hero_pvp._win_count + 1
			end
			pvp_last_hero_it:Next()
			last_hero = pvp_last_hero_it:GetValue()
		end

		if role._roledata._pvp_info._pvp_grade == 0 then
			if LIMIT_TestUseLimit(role, quanju.pvp_rank0_score_times, 1) == true then
				role._roledata._pvp_info._cur_star = role._roledata._pvp_info._cur_star + quanju.pvp_rank0_win_score
				LIMIT_AddUseLimit(role, quanju.pvp_rank0_score_times, 1)
				TASK_ChangeCondition(role, G_ACH_TYPE["YONGJIU"], G_ACH_TWENTY_TYPE["3V3CHUANSHUOSCORE"], quanju.pvp_rank0_win_score)
			end
		else
			local ranking = ed:FindBy("ranking_id", role._roledata._pvp_info._pvp_grade)
			if role._roledata._pvp_info._win_flag >= 2 then
				role._roledata._pvp_info._cur_star = role._roledata._pvp_info._cur_star + ranking.straight_wins_star
			else
				role._roledata._pvp_info._cur_star = role._roledata._pvp_info._cur_star + ranking.win_star
			end
			if role._roledata._pvp_info._cur_star >= ranking.ascending_order_star then
				role._roledata._pvp_info._pvp_grade = role._roledata._pvp_info._pvp_grade - 1
				if role._roledata._pvp_info._pvp_grade == 0 then
					role._roledata._pvp_info._cur_star = quanju.pvp_rank0_initial_score
					
					--达到传说发公告
					local notice_para = {}
					
					local tmp_notice_para = {}
					tmp_notice_para.typ = 1
					tmp_notice_para.id = role._roledata._base._id:ToStr()
					tmp_notice_para.name = role._roledata._base._name
					tmp_notice_para.num = 0
					notice_para[#notice_para+1] = tmp_notice_para
					
					ROLE_SendNotice(2, notice_para)
					TASK_ChangeCondition(role, G_ACH_TYPE["YONGJIU"], G_ACH_TWENTY_TYPE["3V3CHUANSHUOSCORE"], quanju.pvp_rank0_initial_score)
					TASK_ChangeCondition(role, G_ACH_TYPE["YONGJIU"], G_ACH_TWENTY_TYPE["3V3CHUANSHUO"], 1)
				else
					role._roledata._pvp_info._cur_star = role._roledata._pvp_info._cur_star - ranking.ascending_order_star
					TASK_ChangeCondition(role, G_ACH_TYPE["LESSNUM"], G_ACH_TWENTYONE_TYPE["3V3GRADE"], role._roledata._pvp_info._pvp_grade)
				end
			end
		end

		--每日胜利次数统计
		LIMIT_AddUseLimit(role, quanju.pvp_daily_limit_win_times, 1)

		TASK_ChangeCondition(role, G_ACH_TYPE["STAGE_COUNT"], G_ACH_EIGHT_TYPE["3V3"] , 1)
		TASK_ChangeCondition(role, G_ACH_TYPE["YONGJIU"], G_ACH_TWENTY_TYPE["3V3WIN"], 1)

	elseif arg.reason == 0 then	--失败
		if role._roledata._pvp_info._win_flag > 0 then
			role._roledata._pvp_info._win_flag = -1
		else
			role._roledata._pvp_info._win_flag = role._roledata._pvp_info._win_flag - 1
		end
	--	role._roledata._pvp_info._win_flag = 0
		role._roledata._pvp_info._fail_count = role._roledata._pvp_info._fail_count + 1
		role._roledata._pvp_info._failed_count_in_succession = role._roledata._pvp_info._failed_count_in_succession+1
		role._roledata._pvp_info._elo_score = role._roledata._pvp_info._elo_score + arg.score
		
		--更新玩家的武将出战信息
		local hero_pvp_info = role._roledata._pvp_info._hero_pvp_info
		local pvp_last_hero = role._roledata._pvp_info._last_hero

		local pvp_last_hero_it = pvp_last_hero:SeekToBegin()
		local last_hero = pvp_last_hero_it:GetValue()
		while last_hero ~= nil do
			local hero_pvp = hero_pvp_info:Find(last_hero._value)
			if hero_pvp == nil then
				local tmp_hero = CACHE.HeroPVPInfo()
				tmp_hero._join_count = 1
				tmp_hero._win_count = 0
				hero_pvp_info:Insert(last_hero._value, tmp_hero)
			else
				hero_pvp._join_count = hero_pvp._join_count + 1
			end
			pvp_last_hero_it:Next()
			last_hero = pvp_last_hero_it:GetValue()
		end
		
		if role._roledata._pvp_info._pvp_grade == 0 then
			if LIMIT_TestUseLimit(role, quanju.pvp_rank0_score_times, 1) == true then
				local change_score = role._roledata._pvp_info._cur_star
				role._roledata._pvp_info._cur_star = role._roledata._pvp_info._cur_star - quanju.pvp_rank0_fail_score
				if role._roledata._pvp_info._cur_star < 0 then
					role._roledata._pvp_info._cur_star = 0
				end
				change_score = role._roledata._pvp_info._cur_star - change_score
				TASK_ChangeCondition(role, G_ACH_TYPE["YONGJIU"], G_ACH_TWENTY_TYPE["3V3CHUANSHUOSCORE"], change_score)
				LIMIT_AddUseLimit(role, quanju.pvp_rank0_score_times, 1)
			end
		else
			local ranking = ed:FindBy("ranking_id", role._roledata._pvp_info._pvp_grade)
			local fail_count = math.random(1000000)
			if fail_count <= ranking.fail_lose_star_probability then
				role._roledata._pvp_info._cur_star = role._roledata._pvp_info._cur_star - 1
			end

			if role._roledata._pvp_info._cur_star < 0 then
				if role._roledata._pvp_info._pvp_grade == 25 then
					role._roledata._pvp_info._cur_star = 0
				else
					role._roledata._pvp_info._pvp_grade = role._roledata._pvp_info._pvp_grade + 1
					ranking = ed:FindBy("ranking_id", role._roledata._pvp_info._pvp_grade)
					role._roledata._pvp_info._cur_star = role._roledata._pvp_info._cur_star + ranking.ascending_order_star
				end
			end
		end
	end

	--在这里把玩家的界别都弄完以后，开始把玩家的数据进行排行榜
	--首先先计算出来玩家目前的数值
	local data = 0
	if role._roledata._pvp_info._pvp_grade == 0 then
		--这里是为了在排行榜中做排列的时候，容易一些.
		--这里是做了一些假设的，假设玩家的传说分数不会低于10000
		data = role._roledata._pvp_info._cur_star + 10000
	else
		for i = 25, role._roledata._pvp_info._pvp_grade + 1, -1 do
			local ranking = ed:FindBy("ranking_id", i)
			data = data + ranking.ascending_order_star
		end
		data = data + role._roledata._pvp_info._cur_star
	end
	
	TOP_InsertData(others.toplist._data._top_data, 3, role._roledata._base._id, data, role._roledata._base._name, 
			role._roledata._base._photo, role._roledata._base._photo_frame, role._roledata._base._badge_map, role._roledata._status._level, 0, 0, 0)

	local resp = NewCommand("PVPEnd")

	resp.result = arg.reason
	resp.typ = arg.typ
	resp.pvp_typ = 1
	resp.star = data
	resp.win_count = role._roledata._pvp_info._win_victory	--连胜次数

	player:SendToClient(SerializeCommand(resp))

	--更新客户端的武将PVP信息
	resp = NewCommand("UpdateHeroPvpInfo")

	resp.hero_pvpinfo = {}

	local pvp_last_hero = role._roledata._pvp_info._last_hero

	local pvp_last_hero_it = pvp_last_hero:SeekToBegin()
	local last_hero = pvp_last_hero_it:GetValue()
	while last_hero ~= nil do
		local hero_pvp = role._roledata._pvp_info._hero_pvp_info:Find(last_hero._value)
		
		local tmp_hero = {}
		tmp_hero.id = last_hero._value
		tmp_hero.join_count = hero_pvp._join_count
		tmp_hero.win_count = hero_pvp._win_count
		
		resp.hero_pvpinfo[#resp.hero_pvpinfo+1] = tmp_hero

		pvp_last_hero_it:Next()
		last_hero = pvp_last_hero_it:GetValue()
	end
	player:SendToClient(SerializeCommand(resp))

	resp = NewCommand("UpdatePvpInfo")
	resp.join_count = role._roledata._pvp_info._win_count + role._roledata._pvp_info._fail_count
	resp.win_count = role._roledata._pvp_info._win_count
	player:SendToClient(SerializeCommand(resp))

	role._roledata._status._time_line = G_ROLE_STATE["FREE"]
end
