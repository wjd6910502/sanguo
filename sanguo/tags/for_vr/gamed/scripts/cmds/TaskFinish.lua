function OnCommand_TaskFinish(player, role, arg, others)
	player:Log("OnCommand_TaskFinish, "..DumpTable(arg).." "..DumpTable(others))

	local resp = NewCommand("TaskFinish_Re")
	resp.retcode = G_ERRCODE["SUCCESS"]
	resp.task_id = arg.task_id
	local task_id = arg.task_id

	--查看当前的是否有这个任务
	local current_task = role._roledata._task._current_task
	local inv = current_task:Find(task_id)
	if inv ~= nil then
		local ed = DataPool_Find("elementdata")
		local ele_task = ed:FindBy("task_id", arg.task_id)
		if ele_task == nil then
			resp.retcode = G_ERRCODE["TASK_NOT_EXIST"]
			role:SendToClient(SerializeCommand(resp))
			return
		end
		--首先判断一下是否真的完成了任务
		local flag = 0
		local task_condition = inv._task_condition
		local it2 = task_condition:SeekToBegin()
		local inv2 = it2:GetValue()
		local next_task_condition = {}
		while inv2~=nil do
			local tmp_condition = {}
			if inv2._num < inv2._maxnum then
				flag = 1
				break
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
			return
		end
		--下面开始判断这个任务的时间是否合理
		if ele_task.begin_time ~= 0 and ele_task.end_time ~=0 then
			local now = API_GetTime()
			local now_time = os.date("*t", now)
			local cur_time = now_time.hour * 100
			if cur_time == 0 then
				cur_time = 2400
			end

			cur_time = cur_time + now_time.min

			if cur_time < ele_task.begin_time or cur_time >= ele_task.end_time then
				resp.retcode = G_ERRCODE["TASK_NOT_TIME"]
				role:SendToClient(SerializeCommand(resp))
				return
			end
			
		end
		--下面开始判断等级
		if ele_task.aquire_level > role._roledata._status._level then
			API_Log("TASK_NOT_LEVEL level is error ele_task.level="..ele_task.level.."   role._status._level="..role._roledata._status._level)
			resp.retcode = G_ERRCODE["TASK_NOT_LEVEL"]
			role:SendToClient(SerializeCommand(resp))
			return
		end

		--下面就可以发奖了
		local Reward = DROPITEM_Reward(role, ele_task.rewardsid)
		ROLE_AddReward(role, Reward)

		local instance_info = {}
		instance_info.exp = Reward.exp
		instance_info.heroexp = Reward.heroexp
		instance_info.item = {}
		local item_count = table.getn(Reward.item)
		for i = 1, item_count do
			local instance_item = {}
			instance_item.id = Reward.item[i].itemid
			instance_item.count = Reward.item[i].itemnum
			instance_info.item[#instance_info.item+1] = instance_item
		end

		--把这个任务从当前任务中删除掉
		--把这个任务添加到已经完成的任务中去
		current_task:Delete(task_id)
		local finish_task =role._roledata._task._finish_task
		local tmp_finish = CACHE.Finish_Task:new()
		tmp_finish._task_id = task_id
		tmp_finish._finish_time = API_GetTime()
		finish_task:Insert(task_id, tmp_finish)

		if ele_task.if_own_next == 1 then
			TASK_FinishTask(role, task_id, next_task_condition)
		end
		
		resp.rewards = instance_info
		role:SendToClient(SerializeCommand(resp))
		
		return
	end
	resp.retcode = G_ERRCODE["TASK_ID_CURRENT"]
	role:SendToClient(SerializeCommand(resp))
end
