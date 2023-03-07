function OnCommand_TaskFinish(player, role, arg, others)
	player:Log("OnCommand_TaskFinish, "..DumpTable(arg).." "..DumpTable(others))

	role:NewSendToClientList()

	local resp = NewCommand("TaskFinish_Re")
	resp.retcode = G_ERRCODE["SUCCESS"]
	resp.task_id = arg.task_id
	local task_id = arg.task_id

	--查看当前的是否有这个任务
	local current_task = role._roledata._task._current_task
	local inv = current_task:Find(task_id)

	--查看这个任务是否完成
	if role._roledata._task._finish_task:Find(task_id) ~= nil then
		resp.retcode = G_ERRCODE["TASK_HAVE_FINISH"]
		role:SendToClient(SerializeCommand(resp))
		player:Log("OnCommand_TaskFinish, error=TASK_HAVE_FINISH")
		return
	end

	local ed = DataPool_Find("elementdata")
	local ele_task = ed:FindBy("task_id", arg.task_id)

	if ele_task == nil then
		resp.retcode = G_ERRCODE["TASK_NOT_EXIST"]
		role:SendToClient(SerializeCommand(resp))
		player:Log("OnCommand_TaskFinish, error=TASK_NOT_EXIST")
		return
	end

	local quanju = ed.gamedefine[1]

	--元宝领取过期体力特殊处理
	local ti_flag = 0
	if inv == nil then
		--领取体力消耗元宝
		if ele_task.achtype == 4 and ele_task.achtype2 == 1 then --领取体力成就
			--判断玩家身上元宝
			if role._roledata._status._yuanbao < quanju.drink_replacement_cost then
				resp.retcode = G_ERRCODE["YUANBAO_LESS"]
				role:SendToClient(SerializeCommand(resp))
				player:Log("OnCommand_TaskFinish, error=YUANBAO_LESS")
				return
			end
			--判断一下补领时间
			local now = API_GetTime()
			local now_time = os.date("*t", now)

			if now_time.hour >= 5 and now_time.hour*100 < ele_task.end_time then
				return
			end

			ti_flag = 1
		end		
	end	

	if inv ~= nil or ti_flag == 1 then
		--数据统计日志
		local source_id = 0
		if ele_task.achtype == G_ACH_TYPE["STAGE_VIP"] and ele_task.achtype2 == G_ACH_TWO_TYPE["SPECIAL"] then
			source_id = G_SOURCE_TYP["VIP_RECRUIT"]
		elseif ele_task.achtype == G_ACH_TYPE["AUTO_FINISH"] or ele_task.achtype == G_ACH_TYPE["STAGE_COUNT"] then
			source_id = G_SOURCE_TYP["DAILY_TASK"]
		else
			source_id = G_SOURCE_TYP["ACHIEVEMENT"]
		end

		local next_task_condition = {}
		if ti_flag == 0 then
			--首先判断一下是否真的完成了任务
			local flag = 0
			local task_condition = inv._task_condition
			local it2 = task_condition:SeekToBegin()
			local inv2 = it2:GetValue()
			while inv2~=nil do
				local tmp_condition = {}
				if inv2._type == G_ACH_TYPE["LESSNUM"] then
					if inv2._num > inv2._maxnum then
						flag = 1
						break
					end
				else
					if inv2._num < inv2._maxnum then
						flag = 1
						break
					end
				end
				tmp_condition.typ = inv2._type
				tmp_condition.num = inv2._num
				next_task_condition[#next_task_condition+1] = tmp_condition
				it2:Next()
				inv2 = it2:GetValue()
			end
			if flag == 1 then
				resp.retcode = G_ERRCODE["TASK_NOT_FINISH"]
				role:SendToClient(SerializeCommand(resp))
				player:Log("OnCommand_TaskFinish, error=TASK_NOT_FINISH")
				return
			end
			--下面开始判断这个任务的时间是否合理
			local mist = API_GetLuaMisc()
			local now = API_GetTime()
			local now_time = os.date("*t", now)
			if ele_task.is_time_limited == 1 then
				local ach_begin_date = os.date("*t", mist._miscdata._open_server_time+ele_task.begin_date*3600*24)
				local task_begin_time = ach_begin_date.year*100000000 + ach_begin_date.month*1000000 + ach_begin_date.day*10000 + ele_task.begin_time
				local ach_end_date = os.date("*t", mist._miscdata._open_server_time+ele_task.end_date*3600*24)
				local task_end_time = ach_end_date.year*100000000 + ach_end_date.month*1000000 + ach_end_date.day*10000 + ele_task.end_time
				local cur_time = (now_time.year*10000 + now_time.month*100 + now_time.day)*10000+now_time.hour*100+now_time.min

				if cur_time < task_begin_time or cur_time >= task_end_time then
					resp.retcode = G_ERRCODE["TASK_NOT_TIME"]
					role:SendToClient(SerializeCommand(resp))
					player:Log("OnCommand_TaskFinish, error=TASK_NOT_TIME")
					return
				end
			elseif ele_task.begin_time ~= 0 and ele_task.end_time ~=0 then
				local cur_time = now_time.hour * 100
				if cur_time == 0 then
					cur_time = 2400
				end

				cur_time = cur_time + now_time.min
	
				local task_begin_time = ele_task.begin_time
				local task_end_time = ele_task.end_time
				if ele_task.begin_date ~= 0 then
					cur_time = ((now_time.year*100 + now_time.month)*100 + now_time.day)*10000 + cur_time
					task_begin_time = ((ele_task.begin_date*10000) + ele_task.begin_time)
					task_end_time = ((ele_task.end_date*10000) + ele_task.end_time)
				end

				if cur_time < task_begin_time or cur_time >= task_end_time then
					resp.retcode = G_ERRCODE["TASK_NOT_TIME"]
					role:SendToClient(SerializeCommand(resp))
					player:Log("OnCommand_TaskFinish, error=TASK_NOT_TIME")
					return
				end
			end
		end

		--下面开始判断等级
		if ele_task.aquire_level > role._roledata._status._level then
			API_Log("TASK_NOT_LEVEL level is error ele_task.aquire_level="..ele_task.aquire_level.."   role._status._level="..role._roledata._status._level)
			resp.retcode = G_ERRCODE["TASK_NOT_LEVEL"]
			role:SendToClient(SerializeCommand(resp))
			player:Log("OnCommand_TaskFinish, error=TASK_NOT_LEVEL")
			return
		end

		if ti_flag == 1 then
			ROLE_SubYuanBao(role, quanju.drink_replacement_cost)
		end

		--下面就可以发奖了
		local Reward = DROPITEM_Reward(role, ele_task.rewardsid)
		local additem = ROLE_AddReward(role, Reward, source_id)

		local instance_info = {}
		instance_info.exp = Reward.exp
		instance_info.heroexp = Reward.heroexp
		instance_info.item = {}
		local item_count = table.getn(additem)
		for i = 1, item_count do
			local instance_item = {}
			instance_item.id = additem[i].tid
			instance_item.count = additem[i].count
			instance_info.item[#instance_info.item+1] = instance_item
		end

		--把这个任务从当前任务中删除掉
		--把这个任务添加到已经完成的任务中去
		current_task:Delete(task_id)
		local finish_task =role._roledata._task._finish_task
		local tmp_finish = CACHE.Finish_Task()
		tmp_finish._task_id = task_id
		tmp_finish._finish_time = API_GetTime()
		finish_task:Insert(task_id, tmp_finish)

		if ele_task.if_own_next == 1 then --领取体力没有后续任务
			TASK_FinishTask(role, task_id, next_task_condition)
		end
		
		resp.rewards = instance_info
		role:SendToClientFirst(SerializeCommand(resp))
		
		return
	end
	resp.retcode = G_ERRCODE["TASK_ID_CURRENT"]
	role:SendToClient(SerializeCommand(resp))
end
