function OnCommand_MilitarySweep(player, role, arg, others)
	player:Log("OnCommand_MilitarySweep, "..DumpTable(arg).." "..DumpTable(others))

	local resp = NewCommand("MilitarySweep_Re")
	local source_id = G_SOURCE_TYP["FULIHUODONG"]

	resp.stage_id = arg.stage_id
	resp.exp = 0

	local ed = DataPool_Find("elementdata")
	local vip_data = ed:FindBy("vip_level", ROLE_GetVIP(role))
	if vip_data == nil then
		resp.retcode = G_ERRCODE["MILITARY_ERROR_DATA"]
		player:SendToClient(SerializeCommand(resp))
		player:Log("OnCommand_MilitarySweep, error=MILITARY_ERROR_DATA")
		return
	end

	if vip_data.dailybenefits_sweep_switch == 0 then
		resp.retcode = G_ERRCODE["MILITARY_ERROR_VIP"]
		player:SendToClient(SerializeCommand(resp))
		player:Log("OnCommand_MilitarySweep, error=MILITARY_ERROR_VIP")
		return
	end

	local military = ed:FindBy("military", arg.stage_id)

	if military == nil then
		resp.retcode = G_ERRCODE["MILITARY_ERROR_ARG"]
		player:SendToClient(SerializeCommand(resp))
		player:Log("OnCommand_MilitarySweep, error=MILITARY_ERROR_ARG")
		return
	end

	local now = API_GetTime()
	local date = os.date("*t", now)

	if military.open_day[date.wday] == 0 then
		resp.retcode = G_ERRCODE["MILITARY_ERROR_ACTIVIE"]
		player:SendToClient(SerializeCommand(resp))
		player:Log("OnCommand_MilitarySweep, error=MILITARY_ERROR_ACTIVIE")
		return
	end

	if role._roledata._status._level < military.dificulty_level then
		resp.retcode = G_ERRCODE["MILITARY_ERROR_LEVEL"]
		player:SendToClient(SerializeCommand(resp))
		player:Log("OnCommand_MilitarySweep, error=MILITARY_ERROR_LEVEL")
		return
	end

	local info = role._roledata._military_data._stage_data:Find(arg.stage_id)
	local times = military.daily_limit
	if info ~= nil then
		if info._cd > now then
			resp.retcode = G_ERRCODE["MILITARY_ERROR_CD"]
			player:SendToClient(SerializeCommand(resp))
			player:Log("OnCommand_MilitarySweep, error=MILITARY_ERROR_CD")
			return
		end

		--已经战斗次数
		if info._times >= military.daily_limit then
			resp.retcode = G_ERRCODE["MILITARY_ERROR_TIMES"]
			player:SendToClient(SerializeCommand(resp))
			player:Log("OnCommand_MilitarySweep, error=MILITARY_ERROR_TIMES")
			return
		end
		times = military.daily_limit - info._times
	end

	if role._roledata._status._yuanbao < military.sweep_cost*times then
		resp.retcode = G_ERRCODE["YUANBAO_LESS"]
		role:SendToClient(SerializeCommand(resp))
		player:Log("OnCommand_MilitarySweep, error=YUANBAO_LESS")
		return
	end

	--计算能扫荡的最大难度
	local index = 0
	for data in DataPool_Array(military.nandu_set) do
		if data.nandu_dificulty_level > role._roledata._status._level then
			break
		end
		index = index + 1
	end

	if index < 1 then
		resp.retcode = G_ERRCODE["MILITARY_ERROR_DATA"]
		player:SendToClient(SerializeCommand(resp))
		player:Log("OnCommand_MilitaryJoinBattle, error=MILITARY_ERROR_DATA")
		return
	end

	ROLE_SubYuanBao(role, military.sweep_cost*times)

	local now = API_GetTime()
	local quanju = ed.gamedefine[1]
	local vip_data = ed:FindBy("vip_level", ROLE_GetVIP(role))
	local rate = times

	if vip_data.dailybenefits_bonus > 0 then
		rate = rate*(vip_data.dailybenefits_bonus+100)/100
	end

	if role._roledata._status._little_fudai > now then
		 rate = rate*(quanju.dailybenefits_bonus_monthcard_1+100)/100
	end

	if role._roledata._status._big_fudai > now then
		rate = rate*(quanju.dailybenefits_bonus_monthcard_2+100)/100
	end

	local reward_id = military.nandu_set[index].nandu_reward_id
	local Reward = DROPITEM_Reward(role, reward_id)
	Reward.exp = math.ceil(Reward.exp*rate)
	resp.exp = Reward.exp
	local add_items = ROLE_AddReward(role, Reward, source_id, rate)
	resp.item = {}
	for i = 1 , #add_items do
		local tmp_item = {}
		tmp_item.tid = add_items[i].tid
		tmp_item.count = add_items[i].count
		resp.item[#resp.item +1] = tmp_item
	end	

	if info == nil then
		local data = CACHE.MilitaryStageData()
		data._id = arg.stage_id
		data._cd = 0
		data._times = military.daily_limit
		role._roledata._military_data._stage_data:Insert(arg.stage_id, data)
	else
		info._cd = 0
		info._times = military.daily_limit
	end	

	resp.retcode = G_ERRCODE["SUCCESS"]
	resp.times = military.daily_limit
	resp.cd = 0
	player:SendToClient(SerializeCommand(resp))
	return
end
