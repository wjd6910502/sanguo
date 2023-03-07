function OnCommand_MaShuEnd(player, role, arg, others)
	player:Log("OnCommand_MaShuEnd, "..DumpTable(arg).." "..DumpTable(others))

	if role._roledata._status._time_line ~= G_ROLE_STATE["MASHUDASAI"] then
		return
	end

	local resp = NewCommand("MaShuEnd_Re")
	resp.retcode = G_ERRCODE["SUCCESS"]
	resp.id = arg.id
	resp.score = arg.score
	resp.stage = arg.stage
	resp.box_num = arg.box_num
	resp.money = arg.money

	--数据统计日志
	local source_id = G_SOURCE_TYP["MASHU"]

	--查看今天箱子是否达到了上限
	local ed = DataPool_Find("elementdata")
	local quanju = ed.gamedefine[1]
	local max_box_num = quanju.equestrain_treasure_box_max
	local box_num = LIMIT_GetUseLimit(role, quanju.equestrain_treasure_box_limit_id)
	
	local open_box_num = 0
	if max_box_num > box_num then
		box_num = box_num + arg.box_num
		if box_num > max_box_num then
			open_box_num = arg.box_num - (box_num - max_box_num)
		else
			open_box_num = arg.box_num
		end
	end

	if open_box_num > 0 then
		LIMIT_AddUseLimit(role, quanju.equestrain_treasure_box_limit_id, open_box_num)
		
		--在这里开始开箱子给物品
		local level_reward = ed:FindBy("level_reward", role._roledata._status._level)
		local reward_id = 0
		local drop_item_id = 0
		for huodong_reward in DataPool_Array(level_reward.huodong_reward) do
			if huodong_reward.huodong_type == quanju.equestrain_treasure_box_id then
				reward_id = huodong_reward.huodong_rewardid
				drop_item_id = huodong_reward.huodong_dropid
				break
			end
		end

		role._roledata._temporary_backpack._id = role._roledata._temporary_backpack._id + 1
		local insert_data = CACHE.TemporaryBackPackData()
		insert_data._id = role._roledata._temporary_backpack._id
		insert_data._typ = 2	--类型为1代表的是背包开箱子给的东西
		for i = 1, open_box_num do
			local drop_item = DROPITEM_DropItem(role, drop_item_id)
			local reward = DROPITEM_Reward(role, reward_id)

			for index = 1,table.getn(drop_item) do
				local item = ed:FindBy("item_id", drop_item[index].id)
				if item.packlimit == 0 then
					for index = 1,drop_item[index].count do
						local tmp = CACHE.Item()
						tmp._tid = drop_item[index].id
						tmp._count = 1
						insert_data._iteminfo:PushBack(tmp)
					end
				else
					local insert_flag = true
					local iteminfo_it = insert_data._iteminfo:SeekToBegin()
					local iteminfo = iteminfo_it:GetValue()
					while iteminfo ~= nil do
						if iteminfo._tid == drop_item[index].id then
							iteminfo._count = iteminfo._count + drop_item[index].count
							insert_flag = false
							break
						end
						iteminfo_it:Next()
						iteminfo = iteminfo_it:GetValue()
					end
					if insert_flag == true then
						local tmp = CACHE.Item()
						tmp._tid = drop_item[index].id
						tmp._count = drop_item[index].count
						insert_data._iteminfo:PushBack(tmp)
					end
				end
			end

			for index = 1,table.getn(reward.item) do
				local item = ed:FindBy("item_id", reward.item[index].itemid)
				if item.packlimit == 0 then
					for index = 1,reward.item[index].itemnum do
						local tmp = CACHE.Item()
						tmp._tid = reward.item[index].itemid
						tmp._count = 1
						insert_data._iteminfo:PushBack(tmp)
					end
				else
					local insert_flag = true
					local iteminfo_it = insert_data._iteminfo:SeekToBegin()
					local iteminfo = iteminfo_it:GetValue()
					while iteminfo ~= nil do
						if iteminfo._tid == reward.item[index].itemid then
							iteminfo._count = iteminfo._count + reward.item[index].itemnum
							insert_flag = false
							break
						end
						iteminfo_it:Next()
						iteminfo = iteminfo_it:GetValue()
					end
					if insert_flag == true then
						local tmp = CACHE.Item()
						tmp._tid = reward.item[index].itemid
						tmp._count = reward.item[index].itemnum
						insert_data._iteminfo:PushBack(tmp)
					end
				end
			end
		end
		role._roledata._temporary_backpack._data:Insert(insert_data._id, insert_data)

		resp.item = {}
		resp.item.items = {}
		resp.item.id = insert_data._id
		resp.item.typ = insert_data._typ
		local iteminfo_it = insert_data._iteminfo:SeekToBegin()
		local iteminfo = iteminfo_it:GetValue()
		while iteminfo ~= nil do
			local tmp_item = {}
			tmp_item.tid = iteminfo._tid
			tmp_item.count = iteminfo._count
			resp.item.items[#resp.item.items+1] = tmp_item

			iteminfo_it:Next()
			iteminfo = iteminfo_it:GetValue()
		end
		
	end

	--查看今天金钱的获取是否达到了上限
	local money = LIMIT_GetUseLimit(role, quanju.equestrain_yb_limit_id)
	local level_exp = ed:FindBy("level_id", role._roledata._status._level)
	local add_money = 0
	if money < level_exp.equestrain_yb_max then
		money = money + arg.money
		add_money = arg.money
		if money > level_exp.equestrain_yb_max then
			add_money = arg.money - (money - level_exp.equestrain_yb_max)
		end
	end
	if add_money > 0 then
		ROLE_AddMoney(role, add_money, source_id)
		LIMIT_AddUseLimit(role, quanju.equestrain_yb_limit_id, add_money)
	end
	resp.server_money = add_money

	--查看是否超过了历史最高值
	resp.score = arg.score
	
	if arg.stage > role._roledata._mashu_info._today_max_stage then
		role._roledata._mashu_info._today_max_stage = arg.stage
	end

	if arg.stage > role._roledata._mashu_info._history_max_stage then
		role._roledata._mashu_info._history_max_stage = arg.stage
	end

	if arg.score > role._roledata._mashu_info._today_max_score then
		local last_score = role._roledata._mashu_info._today_max_score
		role._roledata._mashu_info._today_max_score = arg.score

		if last_score == 0 then
			resp.last_rank = 0
			TOP_ALL_Role_UpdateData(others.toplist_all_role._data._data, 1, role._roledata._base._id, role._roledata._base._name,
					role._roledata._base._photo, role._roledata._status._level, role._roledata._mafia._name,
					role._roledata._mashu_info._today_max_score, last_score)
			resp.cur_rank = TOP_ALL_Role_GetRoleRank(others.toplist_all_role._data._data, 1,
					role._roledata._base._id, role._roledata._mashu_info._today_max_score)
		else
			resp.last_rank = TOP_ALL_Role_GetRoleRank(others.toplist_all_role._data._data, 1,
					 role._roledata._base._id, last_score)
			TOP_ALL_Role_UpdateData(others.toplist_all_role._data._data, 1, role._roledata._base._id, role._roledata._base._name,
					role._roledata._base._photo, role._roledata._status._level, role._roledata._mafia._name,
					role._roledata._mashu_info._today_max_score, last_score)
			resp.cur_rank = TOP_ALL_Role_GetRoleRank(others.toplist_all_role._data._data, 1,
					role._roledata._base._id, role._roledata._mashu_info._today_max_score)
		end

		TASK_ChangeCondition(role, G_ACH_TYPE["LESSNUM"], G_ACH_TWENTYONE_TYPE["MASHURANK"], resp.cur_rank)
		
		if resp.cur_rank <= 10 then
			local notice_para = {}
			
			local tmp_notice_para = {}
			tmp_notice_para.typ = 1
			tmp_notice_para.id = role._roledata._base._id:ToStr()
			tmp_notice_para.name = role._roledata._base._name
			tmp_notice_para.num = 0
			notice_para[#notice_para+1] = tmp_notice_para
			
			local tmp_notice_para = {}
			tmp_notice_para.typ = 3
			tmp_notice_para.id = ""
			tmp_notice_para.name = ""
			tmp_notice_para.num = resp.cur_rank
			notice_para[#notice_para+1] = tmp_notice_para

			ROLE_SendNotice(3, notice_para)
		end

		--在这里修改成给自己扔一个消息，去进行处理去
		local msg = NewMessage("TopListInsertInfo")
		msg.typ = 7
		msg.data = tostring(role._roledata._mashu_info._today_max_score)
		player:SendMessage(role._roledata._base._id, SerializeMessage(msg))

		local msg = NewMessage("RoleUpdateFriendInfo")
		msg.roleid = role._roledata._base._id:ToStr()
		msg.level = role._roledata._status._level
		msg.zhanli = role._roledata._status._zhanli
		msg.online = role._roledata._status._online
		msg.mashu_score = role._roledata._mashu_info._today_max_score
		msg.photo = role._roledata._base._photo
		msg.photo_frame = role._roledata._base._photo_frame
		msg.badge_info = {}

		local badge_info_it = role._roledata._base._badge_map:SeekToBegin()
		local badge_info = badge_info_it:GetValue()
		while badge_info ~= nil do
			local tmp_badge_info = {}
			tmp_badge_info.id = badge_info._id
			tmp_badge_info.typ = badge_info._pos
			msg.badge_info[#msg.badge_info+1] = tmp_badge_info

			badge_info_it:Next()
			badge_info = badge_info_it:GetValue()
		end
	
		local friend_info_it = role._roledata._friend._friends:SeekToBegin()
		local friend_info = friend_info_it:GetValue()
		while friend_info ~= nil do
			player:SendMessage(friend_info._brief._id, SerializeMessage(msg))

			friend_info_it:Next()
			friend_info = friend_info_it:GetValue()
		end

		if role._roledata._mafia._id:ToStr() ~= "0" then
			local msg = NewMessage("RoleUpdateInfoMafiaTop")
			msg.mafia_id = role._roledata._mafia._id:ToStr()
			msg.data = role._roledata._mashu_info._today_max_score
			msg.score = role._roledata._mashu_info._today_max_score - last_score
			local mafia_list = CACHE.Int64List()
			mafia_list:PushBack(role._roledata._mafia._id)
			API_SendMessage(role._roledata._base._id, SerializeMessage(msg), CACHE.Int64List(), mafia_list, CACHE.IntList())
		end

	else
		resp.cur_rank = TOP_ALL_Role_GetRoleRank(others.toplist_all_role._data._data, 1,
				role._roledata._base._id, role._roledata._mashu_info._today_max_score)

		resp.last_rank = resp.cur_rank
	end

	if arg.score > role._roledata._mashu_info._history_max_score then
		TASK_ChangeCondition(role, G_ACH_TYPE["YONGJIU"], G_ACH_TWENTY_TYPE["MASHUSCORE"], arg.score-role._roledata._mashu_info._history_max_score)
		role._roledata._mashu_info._history_max_score = arg.score
	end

	player:SendToClient(SerializeCommand(resp))
	--查看操作和种子，准备做后面的验证
	--arg.operations
	--role._roledata._status._fight_seed
	role._roledata._status._time_line = G_ROLE_STATE["FREE"]
	return
end
