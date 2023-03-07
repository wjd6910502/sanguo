function OnCommand_MilitaryEndBattle(player, role, arg, others)
	player:Log("OnCommand_MilitaryEndBattle, "..DumpTable(arg).." "..DumpTable(others))

	local resp = NewCommand("MilitaryEndBattle_Re")
	
	local source_id = G_SOURCE_TYP["FULIHUODONG"]

	resp.reward_param = arg.reward_param
	resp.hurt = arg.hurt
	resp.stage_id = role._roledata._military_data._stage_id
	resp.difficult = role._roledata._military_data._stage_difficult

	if arg.reward_param > 100 or arg.reward_param < 0 or arg.hurt < 0 then
		resp.retcode = G_ERRCODE["MILITARY_ERROR_ARG"]
		player:SendToClient(SerializeCommand(resp))
		player:Log("OnCommand_MilitaryEndBattle, error=MILITARY_ERROR_ARG")
		return
	end

	if role._roledata._military_data._stage_id == 0 or role._roledata._military_data._stage_difficult == 0 then
		resp.retcode = G_ERRCODE["MILITARY_ERROR_BATTLE_DATA"]
		player:SendToClient(SerializeCommand(resp))
		player:Log("OnCommand_MilitaryEndBattle, error=MILITARY_ERROR_BATTLE_DATA")
		return
	end

	local ed = DataPool_Find("elementdata")
	local military = ed:FindBy("military", role._roledata._military_data._stage_id)
	if military == nil then
		resp.retcode = G_ERRCODE["MILITARY_ERROR_DATA"]
		player:SendToClient(SerializeCommand(resp))
		player:Log("OnCommand_MilitaryJoinBattle, error=MILITARY_ERROR_DATA")
		return
	end

	local battle_info = military.nandu_set[role._roledata._military_data._stage_difficult]
	if battle_info == nil then
		resp.retcode = G_ERRCODE["MILITARY_ERROR_BATTLE_DATA"]
		player:SendToClient(SerializeCommand(resp))
		player:Log("OnCommand_MilitaryEndBattle, error=MILITARY_ERROR_BATTLE_DATA1")
		return
	end

	local now = API_GetTime()
	local ed = DataPool_Find("elementdata")
	local quanju = ed.gamedefine[1]
	local vip_data = ed:FindBy("vip_level", ROLE_GetVIP(role))
	local rate = 1

	if arg.reward_param < 100 then
		rate = arg.reward_param/100
	end

	if vip_data.dailybenefits_bonus > 0 then
		rate = rate*(vip_data.dailybenefits_bonus+100)/100
	end
	
	if role._roledata._status._little_fudai > now then
		rate = rate*(quanju.dailybenefits_bonus_monthcard_1+100)/100
	end

	if role._roledata._status._big_fudai > now then
		rate = rate*(quanju.dailybenefits_bonus_monthcard_2+100)/100
	end
	
	local Reward = DROPITEM_Reward(role, battle_info.nandu_reward_id)
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
	
	local info = role._roledata._military_data._stage_data:Find(role._roledata._military_data._stage_id)
	local now = API_GetTime()
	if info == nil then
		local data = CACHE.MilitaryStageData()
		data._id = role._roledata._military_data._stage_id
		data._cd = now + military.CD_time
		data._times = 1
		role._roledata._military_data._stage_data:Insert(role._roledata._military_data._stage_id, data)
	else
		info._cd = now + military.CD_time
		info._times = info._times + 1
	end

	--�ɾ����
	resp.record = 0
	if arg.hurt > 0 then
		local max = role._roledata._military_data._stage_max:Find(role._roledata._military_data._stage_id)
		if max == nil then
			local data = CACHE.MilitaryStageMax()
			data._id = role._roledata._military_data._stage_id
			data._max_hurt = arg.hurt
			role._roledata._military_data._stage_max:Insert(role._roledata._military_data._stage_id, data)
			resp.record = 1
			TASK_ChangeCondition(role, G_ACH_TYPE["MILITARY"], G_ACH_TWENTYNIME_TYPE["MILITARY_ALL_HURT"..role._roledata._military_data._stage_id], arg.hurt)
		else
			if arg.hurt > max._max_hurt then
				max._max_hurt = arg.hurt
				resp.record = 1
				TASK_ChangeCondition(role, G_ACH_TYPE["MILITARY"], G_ACH_TWENTYNIME_TYPE["MILITARY_ALL_HURT"..role._roledata._military_data._stage_id], arg.hurt)
			end 
		end
	end

	role._roledata._military_data._stage_id = 0
	role._roledata._military_data._stage_difficult = 0
	resp.retcode = G_ERRCODE["SUCCESS"]

	player:SendToClient(SerializeCommand(resp))
	return
end
