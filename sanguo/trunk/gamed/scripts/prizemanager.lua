--������������������ճ��ɾ͵ģ�������ճ��ɾʹӵ�ǰ�Ѿ���ɵģ��Լ���ǰ�ĳɾ�ɾ��
function TASK_RefreshDailyTask(role, diff_time)

	--�Զ�����Ƿ���Ӻ�ɾ�������������ĳһ��ʱ��βſ����е����񣬽��д���
	--�����������Ϊ���������ӵ�һЩ�ɾ��п��ܻ����Զ���ɵ�
	TASK_CheckTaskDate(role, diff_time)
	
	--���ȼ��ÿ�춨���Զ���ɵĳɾ͡�����˵��ȡ������PVP��λ����
	TASK_CheckAutoFinishTask(role, diff_time)
	
	local current_task = role._roledata._task._current_task
	local finish_task = role._roledata._task._finish_task
	local ed = DataPool_Find("elementdata")
	
	--������������������
	local tit = current_task:SeekToBegin()
	local t = tit:GetValue()
	--ѭ����ǰ�����гɾ�
	while t ~= nil do
		local ele_task = ed:FindBy("task_id", t._task_id)

		if ele_task == nil then
			API_LOG("task_table delete taskid ="..t._task_id)
		end

		if ele_task ~= nil and ele_task.continuty_day ~= 0 then
			local cur_time = API_GetTime()
			local flag = 0
			if cur_time >= t._timestamp + ele_task.continuty_day*3600*24 then
				local condition = t._task_condition
				local cit = condition:SeekToBegin()
				local c = cit:GetValue()
				while c ~= nil do
					c._num = 0
					cit:Next()
					c = cit:GetValue()
					flag = 1
				end
			end

			if flag == 1 then
				--���������ͻ��˷��������Ѿ��޸ĵ�����
				local resp = NewCommand("Task_Condition")
				resp.tid = t._task_id
				resp.condition = {}
				local tmp = {}
				local condition = t._task_condition
				local cit = condition:SeekToBegin()
				local c = cit:GetValue()
				while c ~= nil do
					tmp.current = c._num
					tmp.max = c._maxnum
					resp.condition[#resp.condition+1] = tmp
					cit:Next()
					c = cit:GetValue()
				end
				role:SendToClient(SerializeCommand(resp))
			end
		end
		tit:Next()
		t = tit:GetValue()
	end

	--�鿴�Ƿ����ÿ��� 5�㣬���ǵĻ�������ˢ�£�����Ļ�����ˢ��
	if (diff_time.last_day - diff_time.cur_day) == -1 then
		if diff_time.cur_hour < 5 then
			return
		end
	elseif (diff_time.last_day - diff_time.cur_day) == 0 then
		if diff_time.last_hour >= 5 or diff_time.cur_hour < 5 then
			return
		end
	end

	--���ȴ���ǰ�ɾ�
	local current = {}
	local tit = current_task:SeekToBegin()
	local t = tit:GetValue()
	while t ~= nil do
		local ele_task = ed:FindBy("task_id", t._task_id)
		if ele_task ~= nil then
			if ele_task.isdaily == 1 and ele_task.achtype ~= G_ACH_TYPE["AUTO_FINISH"] then
				current[#current+1] = t._task_id
			end
		end
		tit:Next()
		t = tit:GetValue()
	end
	--��ʼ����ɾ��
	local count = table.getn(current)
	for i = 1, count do
		current_task:Delete(current[i])
	end
	
	--�ٴδ����Ѿ���ɵĳɾ�
	local finish = {}
	tit = finish_task:SeekToBegin()
	t = tit:GetValue()
	while t ~= nil do
		local ele_task = ed:FindBy("task_id", t._task_id)
		if ele_task ~= nil then
			if ele_task.isdaily == 1 then
				finish[#finish+1] = t._task_id
			end
		end
		tit:Next()
		t = tit:GetValue()
	end

	--��ʼ����ɾ��
	count = table.getn(finish)
	for i = 1, count do
		finish_task:Delete(finish[i])
	end

	--����ˢ�£����ճ������ٴ���ӽ�ȥ
	TASK_RefreshTask(role)
	--�ٴΰѵ�ǰ�ĳɾͣ��Լ���ɵĳɾͷ����ͻ��ˣ��ÿͻ��������и���
	local resp = NewCommand("UpdateTask")
	resp.finish = {}
	local finish_task = role._roledata._task._finish_task
	local tit = finish_task:SeekToBegin()
	local t = tit:GetValue()
	while t ~= nil do
		resp.finish[#resp.finish+1]=t._task_id
		tit:Next()
		t = tit:GetValue()
	end

	resp.current = {}
	local current_task = role._roledata._task._current_task
	local tit = current_task:SeekToBegin()
	local t = tit:GetValue()
	while t ~= nil do
		local t2 = {}
		t2.id = t._task_id
		t2.condition = {}
		local tit3 = t._task_condition:SeekToBegin()
		local t3 = tit3:GetValue()
		while t3 ~= nil do 
			local t4 = {}
			t4.current_num = t3._num
			t4.max_num = t3._maxnum
			t2.condition[#t2.condition+1]=t4
			tit3:Next()
			t3 = tit3:GetValue()
		end
		resp.current[#resp.current+1]=t2
		tit:Next()
		t = tit:GetValue()
	end
	role:SendToClient(SerializeCommand(resp))
end

--�����������������ӵ�ǰ�ɾ͵ģ��鿴�����Ƿ���԰�һЩ�µĳɾ���ӽ�ȥ
function TASK_FinishTask(role, finish_task_id, task_condition)
	--�ȼ���ǰ�������Լ���������Ƿ����
	local ed = DataPool_Find("elementdata")
	local quanjus = ed.gamedefine
	local condition_count = 0
	for quanju in DataPool_Array(quanjus) do
		condition_count = quanju.achievement_condition_max
		break
	end
	local current_task = role._roledata._task._current_task
	local finish_task = role._roledata._task._finish_task
	local tasks = ed.achievement
	for ach in DataPool_Array(tasks) do
		local flag = 0
		if ach.aquire_ach == finish_task_id then
			flag = 1
		end

		if flag == 1 then
			--�������û�����
			local find = finish_task:Find(ach.id)
			if find == nil then
				--��������ٵ�ǰ��������
				find = current_task:Find(ach.id)
				if ach.aquire_stage_id ~= 0 then
					local stage = role._roledata._status._instances:Find(ach.aquire_stage_id)
					if stage == nil then
						flag = 0
					end
				end
				if find == nil and role._roledata._status._level >= ach.aquire_level and flag == 1 then
					--���԰�����ɾ���ӵ���ǰ�ɾ�����
					local tmp = CACHE.Task()
					tmp._task_id = ach.id

					if ach.if_own_pre == 1 then
						local task_data = CACHE.TaskData()
						for j = 1, table.getn(task_condition) do
							for i = 1,condition_count do
								local xxx = "condition"..i.."_type"
								local yyy = "condition"..i.."_facor"
								local zzz = "condition"..i.."_data"
								if ach[xxx] ~= 0 and ach[xxx] == task_condition[j].typ then
									task_data._type = ach[xxx]
									task_data._condition = ach[yyy]
									task_data._num = task_condition[j].num
									task_data._maxnum = ach[zzz]
									tmp._task_condition:PushBack(task_data)
								end
							end
						end
					else
						local task_data = CACHE.TaskData()
						for i = 1,condition_count do
							local xxx = "condition"..i.."_type"
							local yyy = "condition"..i.."_facor"
							local zzz = "condition"..i.."_data"
							if ach[xxx] ~= 0 then
								task_data._type = ach[xxx]
								task_data._condition = ach[yyy]
								task_data._num = 0
								task_data._maxnum = ach[zzz]
								tmp._task_condition:PushBack(task_data)
							end
						end
					end
			
					current_task:Insert(ach.id, tmp)
					local resp = NewCommand("Task_Condition")
					resp.tid = ach.id
					resp.condition = {}
					local tmp_con = {}
					local cit = tmp._task_condition:SeekToBegin()
					local c = cit:GetValue()
					while c ~= nil do
						tmp_con.current = c._num
						tmp_con.max = c._maxnum
						resp.condition[#resp.condition+1] = tmp_con
						cit:Next()
						c = cit:GetValue()
					end
					role:SendToClient(SerializeCommand(resp))
				end
			end
		end
	end
end

--�����������������ӵ�ǰ�ɾ͵ģ��鿴�����Ƿ���԰�һЩ�µĳɾ���ӽ�ȥ
function TASK_RefreshTask(role)
	--�ȼ���ǰ�������Լ���������Ƿ����
	local ed = DataPool_Find("elementdata")
	local quanjus = ed.gamedefine
	local condition_count = 0
	for quanju in DataPool_Array(quanjus) do
		condition_count = quanju.achievement_condition_max
		break
	end
	local current_task = role._roledata._task._current_task
	local finish_task = role._roledata._task._finish_task
	local tasks = ed.achievement
	local now = API_GetTime()
	local now_time = os.date("*t", now)	
	local mist = API_GetLuaMisc()

	local tupo_flag = false
	local star_flag = false
	local weapon_level_flag = false
	local equip_level_flag = false
	local pvpgrade_flag = false
	local pverank_flag = false
	
	for ach in DataPool_Array(tasks) do
		local flag = 1
		if ach.aquire_ach ~= 0 then
			--ǰ������û�����
			local find = finish_task:Find(ach.aquire_ach)
			if find == nil then
				flag = 0
			end
		end

		if ach.achtype == 0 then
			flag = 0
		end

		if flag == 1 and ach.achtype ~= G_ACH_TYPE["AUTO_FINISH"] and ach.achtype ~= G_ACH_TYPE["PVP_SERVER_FINISH"] then
			if ach.is_time_limited == 1 then
				local ach_begin_date = os.date("*t", mist._miscdata._open_server_time+ach.begin_date*3600*24)
				local begin_time = ach_begin_date.year*100000000 + ach_begin_date.month*1000000 + ach_begin_date.day*10000 + ach.begin_time
				local ach_end_date = os.date("*t", mist._miscdata._open_server_time+ach.end_date*3600*24)
				local end_time = ach_end_date.year*100000000 + ach_end_date.month*1000000 + ach_end_date.day*10000 + ach.end_time
				local cur_time = (now_time.year*10000 + now_time.month*100 + now_time.day)*10000+now_time.hour*100
				--�������ʼ5���ע������޷����������
				local activity = ed.activity[1]
				if activity.enter_end_date ~= 0 then
					local over_day = os.date("*t", role._roledata._base._create_time).yday-os.date("*t", mist._miscdata._open_server_time).yday
					if over_day >= activity.enter_end_date then
						flag = 0
					end
				end

				if cur_time < begin_time or cur_time >= end_time then
					flag = 0
				end
			elseif ach.begin_date ~= 0 or ach.begin_time ~= 0 then
				flag = 0
			end

			if flag == 1 then
				--�������û�����
				local find = finish_task:Find(ach.id)
				if find == nil then
					--��������ٵ�ǰ��������
					find = current_task:Find(ach.id)
					if ach.aquire_stage_id ~= 0 then
						local stage = role._roledata._status._instances:Find(ach.aquire_stage_id)
						if stage == nil then
							flag = 0
						end
					end
					if find == nil and role._roledata._status._level >= ach.aquire_level and flag == 1 then
						--���԰�����ɾ���ӵ���ǰ�ɾ�����
						local tmp = CACHE.Task()
						tmp._task_id = ach.id

						local task_data = CACHE.TaskData()
						for i = 1,condition_count do
							local xxx = "condition"..i.."_type"
							local yyy = "condition"..i.."_facor"
							local zzz = "condition"..i.."_data"
							if ach[xxx] ~= 0 then
								task_data._type = ach[xxx]
								task_data._condition = ach[yyy]
								task_data._num = 0
								task_data._maxnum = ach[zzz]
								tmp._task_condition:PushBack(task_data)
							end
						end
						current_task:Insert(ach.id, tmp)

						if ach.achtype == G_ACH_TYPE["HERO_TUPO"] then
							tupo_flag = true
						elseif ach.achtype == G_ACH_TYPE["HERO_STAR"] then
							star_flag = true
						elseif ach.achtype == G_ACH_TYPE["WEAPON_LEVELUP"] then
							weapon_level_flag = true
						elseif ach.achtype == G_ACH_TYPE["EQUIPMENT_LEVELUP"] then
							equip_level_flag = true
						elseif ach.achtype == G_ACH_TYPE["LESSNUM"] then
							if ach.achtype2 == G_ACH_TWENTYONE_TYPE["JJCRANK"] then
								pverank_flag = true
							elseif ach.achtype2 == G_ACH_TWENTYONE_TYPE["3V3GRADE"] then
								pvpgrade_flag = true
							end
						end

						local resp = NewCommand("Task_Condition")
						resp.tid = ach.id
						resp.condition = {}
						local tmp_con = {}
						local cit = tmp._task_condition:SeekToBegin()
						local c = cit:GetValue()
						while c ~= nil do
							tmp_con.current = c._num
							tmp_con.max = c._maxnum
							resp.condition[#resp.condition+1] = tmp_con
							cit:Next()
							c = cit:GetValue()
						end
						role:SendToClient(SerializeCommand(resp))
					end
				end
			end
		end
	end

	if tupo_flag or star_flag or weapon_level_flag or equip_level_flag or pverank_flag or pvpgrade_flag then
		local msg = NewMessage("UpdateSpecialTask")
		msg.hero_tupo = tupo_flag
		msg.hero_star = star_flag
		msg.weapon_level = weapon_level_flag
		msg.equip_level = equip_level_flag
		msg.pverank = pverank_flag
		msg.pvpgrade = pvpgrade_flag
		API_SendMessage(role._roledata._base._id, SerializeMessage(msg), CACHE.Int64List(), CACHE.Int64List(), CACHE.IntList())
	end
end

function TASK_ChangeCondition(role, task_type, task_condition, num)
	if num == 0 then
		return
	end

	local ed = DataPool_Find("elementdata")
	local task = role._roledata._task._current_task
	local tit = task:SeekToBegin()
	local t = tit:GetValue()
	--ѭ����ǰ�����гɾ�
	while t ~= nil do
		local condition = t._task_condition
		local cit = condition:SeekToBegin()
		local c = cit:GetValue()
		local flag = 0
		while c ~= nil do
			if c._type == task_type and c._condition == task_condition then
				local ele_task = ed:FindBy("task_id", t._task_id)
				if ele_task.continuty_day ~= 0 then
					local cur_time = API_GetTime()
					if cur_time >= t._timestamp then
						c._num = c._num + num
						flag = 1
						t._timestamp = API_MakeTodayTime(ele_task.continuty_time, 0, 0) + ele_task.continuty_day*3600*24
					end
				else
					if task_type == G_ACH_TYPE["LEVEL_FINISH"] or task_type == G_ACH_TYPE["MAFIA_JISI"] or task_type == G_ACH_TYPE["MILITARY"] then
						c._num = num
						flag = 1
					elseif task_type == G_ACH_TYPE["LESSNUM"] then
						if c._num == 0 and num ~= 0 then
							c._num = num
							flag = 1
						elseif c._num > num and num ~= 0 then
							c._num = num
							flag = 1
						end
					elseif task_type == G_ACH_TYPE["ZHANLI"] then
						if c._num < num then
							c._num = num
							flag = 1
						end
					else
						c._num = c._num + num
						flag = 1
					end
				end
			end
			cit:Next()
			c = cit:GetValue()
		end
		if flag == 1 then
			--���������ͻ��˷��������Ѿ��޸ĵ�����
			local resp = NewCommand("Task_Condition")
			resp.tid = t._task_id
			resp.condition = {}
			local tmp = {}
			cit = condition:SeekToBegin()
			c = cit:GetValue()
			while c ~= nil do
				tmp.current = c._num
				tmp.max = c._maxnum
				resp.condition[#resp.condition+1] = tmp
				cit:Next()
				c = cit:GetValue()
			end
			role:SendToClient(SerializeCommand(resp))
		end
		tit:Next()
		t = tit:GetValue()
	end
end

--��������ӿ�ֻ���佫ͻ�ƣ�������װ��/������������
function TASK_ChangeCondition_Special(role, task_type, task_condition, old_condition, num)
	if num == 0 then
		return
	end

	local ed = DataPool_Find("elementdata")
	local task = role._roledata._task._current_task
	local tit = task:SeekToBegin()
	local t = tit:GetValue()
	--ѭ����ǰ�����гɾ�
	while t ~= nil do
		local condition = t._task_condition
		local cit = condition:SeekToBegin()
		local c = cit:GetValue()
		local flag = 0
		while c ~= nil do
			if c._type == task_type and c._condition <= task_condition then
				if num < 0 then
					if c._num < c._maxnum then
						c._num = c._num + num
						flag = 1
					end
				else
					if c._condition > old_condition then
						if c._num < c._maxnum then
							c._num = c._num + num
							flag = 1
						end
					end
				end
			end
			cit:Next()
			c = cit:GetValue()
		end
		if flag == 1 then
			--���������ͻ��˷��������Ѿ��޸ĵ�����
			local resp = NewCommand("Task_Condition")
			resp.tid = t._task_id
			resp.condition = {}
			local tmp = {}
			cit = condition:SeekToBegin()
			c = cit:GetValue()
			while c ~= nil do
				tmp.current = c._num
				tmp.max = c._maxnum
				resp.condition[#resp.condition+1] = tmp
				cit:Next()
				c = cit:GetValue()
			end
			role:SendToClient(SerializeCommand(resp))
		end
		tit:Next()
		t = tit:GetValue()
	end
end

function TASK_CheckAutoFinishTask(role, diff_time)
	local ed = DataPool_Find("elementdata")
	local quanjus = ed.gamedefine
	local condition_count = 0
	for quanju in DataPool_Array(quanjus) do
		condition_count = quanju.achievement_condition_max
		break
	end
	local achs = ed.achievement
	for ach in DataPool_Array(achs) do
		if ach.achtype == G_ACH_TYPE["AUTO_FINISH"] then
			local cur_time = 0
			local last_time = 0
			if diff_time.cur_hour == 0 then
				cur_time = 2400
			else
				cur_time = diff_time.cur_hour*100
			end

			last_time = diff_time.last_hour*100
			
			if (cur_time >= ach.auto_finish_time and last_time < ach.auto_finish_time) then
				--���Ȳ�����ô��ֱ���ڵ�ǰ�ɾ��Լ���ɵĳɾ����������ɾ�ɾ��
				if role._roledata._task._current_task:Find(ach.id) ~= nil or 
				role._roledata._task._finish_task:Find(ach.id) ~= nil then
					role._roledata._task._current_task:Delete(ach.id)
					role._roledata._task._finish_task:Delete(ach.id)
					local resp = NewCommand("DeleteTask")
					resp.task_id = ach.id
					role:SendToClient(SerializeCommand(resp))
				end

				--����Ƿ���԰������ӽ�ȥ
				if ach.achtype2 == 1 then
					--����
					local tmp = CACHE.Task()
					tmp._task_id = ach.id

					role._roledata._task._current_task:Insert(ach.id, tmp)
				
					local resp = NewCommand("Task_Condition")
					resp.tid = ach.id
					resp.condition = {}
					role:SendToClient(SerializeCommand(resp))

				elseif ach.achtype2 == 2 then
					--PVP��𷢽����ж��Լ�������һ�����Ȼ�������Ӧ�ĳɾ�
					if role._roledata._pvp_info._pvp_grade >= ach.start_range and role._roledata._pvp_info._pvp_grade <= ach.end_range then
						local tmp = CACHE.Task()
						tmp._task_id = ach.id

						role._roledata._task._current_task:Insert(ach.id, tmp)
				
						local resp = NewCommand("Task_Condition")
						resp.tid = ach.id
						resp.condition = {}
						role:SendToClient(SerializeCommand(resp))
					end
				end
			end
			--elseif ach.end_time ~= 0 and (cur_time >= ach.end_time or cur_time < ach.begin_time) then
			if ach.end_time ~= 0 and (cur_time >= ach.end_time or cur_time < ach.begin_time) then
				--����������鿴�Ƿ��е������Ѿ����ٷ�Χ���ˣ��ǵĻ���ô��Ҫ����ɾ��
				if role._roledata._task._current_task:Find(ach.id) ~= nil or 
				role._roledata._task._finish_task:Find(ach.id) ~= nil then
					role._roledata._task._current_task:Delete(ach.id)
					if ach.achtype == 4 and ach.achtype2 == 1 then
					else
						role._roledata._task._finish_task:Delete(ach.id)
						--֪ͨ�ͻ��ˣ�������ɾ�ɾ����
						local resp = NewCommand("DeleteTask")
						resp.task_id = ach.id
						role:SendToClient(SerializeCommand(resp))
					end
				end
			end
		end
	end
end

--����ӿ�������������ߵ�ʱ��ˢ����ҵĳɾͣ���Ҫ������ɾ������ӳɾ�
--��Ϊ�߻�����ʱ��Ӻ�ɾ���ɾ�
function TASK_UpdateTaskOnline(role)
	--�鿴������ϵĳɾ��ڱ����Ƿ���Ȼ���ڣ���������ڵĻ����Ǿͽ���ɾ��
	local ed = DataPool_Find("elementdata")
	local current_task = role._roledata._task._current_task
	local finish_task = role._roledata._task._finish_task
	--���ȴ���ǰ�ɾ�
	local current = {}
	local tit = current_task:SeekToBegin()
	local t = tit:GetValue()
	while t ~= nil do
		local ele_task = ed:FindBy("task_id", t._task_id)
		if ele_task == nil then
			current[#current+1] = t._task_id
		end
		tit:Next()
		t = tit:GetValue()
	end
	--��ʼ����ɾ��
	for i = 1, table.getn(current) do
		current_task:Delete(current[i])
	end
	
	--�ٴδ����Ѿ���ɵĳɾ�
	local finish = {}
	tit = finish_task:SeekToBegin()
	t = tit:GetValue()
	while t ~= nil do
		local ele_task = ed:FindBy("task_id", t._task_id)
		if ele_task == nil then
			finish[#finish+1] = t._task_id
		end
		tit:Next()
		t = tit:GetValue()
	end

	--��ʼ����ɾ��
	for i = 1, table.getn(finish) do
		finish_task:Delete(finish[i])
	end

	--�鿴�Ƿ����µĳɾͿ�����ӽ���
	TASK_RefreshTask(role)
end

function TASK_CheckTaskDate(role, diff_time)
	--���Ȳ鿴�Ƿ�����Ҫ�ӵ�ǰ������ɾ����������
	local current_task = role._roledata._task._current_task
	local finish_task = role._roledata._task._finish_task
	local current = {}
	local ed = DataPool_Find("elementdata")
	local mist = API_GetLuaMisc()

	local tupo_flag = false
	local star_flag = false
	local weapon_level_flag = false
	local equip_level_flag = false
	local pverank_flag = false
	local pvpgrade_flag = false

	local tit = current_task:SeekToBegin()
	local t = tit:GetValue()
	--ѭ����ǰ�����гɾ�
	while t ~= nil do
		local ele_task = ed:FindBy("task_id", t._task_id)
		if ele_task.is_time_limited == 1 then
			local ach_end_date = os.date("*t", mist._miscdata._open_server_time+ele_task.end_date*3600*24)
			local end_time = ach_end_date.year*100000000 + ach_end_date.month*1000000 + ach_end_date.day*10000 + ele_task.end_time
			local cur_time = (diff_time.cur_year*10000 + diff_time.cur_month*100 + diff_time.cur_date)*10000+diff_time.cur_hour*100
			if cur_time >= end_time then
				current[#current+1] = t._task_id
			end
		elseif ele_task.end_date ~= 0 then
			--�������ǰʱ�������
			local end_time = ele_task.end_date*10000+ele_task.end_time
			local cur_time = (diff_time.cur_year*10000 + diff_time.cur_month*100 + diff_time.cur_date)*10000+diff_time.cur_hour*100
			if cur_time >= end_time then
				current[#current+1] = t._task_id
			end
		elseif ele_task.end_time ~= 0 then
			if diff_time.cur_hour*100 >= ele_task.end_time then
				current[#current+1] = t._task_id
			end
		end
		tit:Next()
		t = tit:GetValue()
	end
	--��ʼ����ɾ��
	local count = table.getn(current)
	for i = 1, count do
		current_task:Delete(current[i])
		--���¸��ͻ���
		local resp = NewCommand("DeleteTask")
		resp.task_id = current[i]
		role:SendToClient(SerializeCommand(resp))
	end

	--�鿴�Ƿ��������µ�ʱ��γɾ�
	local tasks = ed.achievement
	local quanjus = ed.gamedefine
	local condition_count = 0
	for quanju in DataPool_Array(quanjus) do
		condition_count = quanju.achievement_condition_max
		break
	end
	for ach in DataPool_Array(tasks) do
		if ach.is_time_limited == 1 then
			local ach_begin_date = os.date("*t", mist._miscdata._open_server_time+ach.begin_date*3600*24)
			local begin_time = ach_begin_date.year*100000000 + ach_begin_date.month*1000000 + ach_begin_date.day*10000 + ach.begin_time
			local ach_end_date = os.date("*t", mist._miscdata._open_server_time+ach.end_date*3600*24)
			local end_time = ach_end_date.year*100000000 + ach_end_date.month*1000000 + ach_end_date.day*10000 + ach.end_time
			local cur_time = (diff_time.cur_year*10000 + diff_time.cur_month*100 + diff_time.cur_date)*10000+diff_time.cur_hour*100
			local flag = 1
			--����5���ע������޷����������
			local activity = ed.activity[1]
			if activity.enter_end_date ~= 0 then
				local over_day = os.date("*t", role._roledata._base._create_time).yday-os.date("*t", mist._miscdata._open_server_time).yday
				if over_day >= activity.enter_end_date then
					flag = 0
				end
			end

			if ach.aquire_ach ~= 0 then
				local find = finish_task:Find(ach.aquire_ach)
				if find == nil then
					flag = 0
				end
			end

			if ach.aquire_stage_id ~= 0 then
				local stage = role._roledata._status._instances:Find(ach.aquire_stage_id)
				if stage == nil then
					flag = 0
				end
			end

			if cur_time >= begin_time and cur_time < end_time and flag == 1 then
				local find = finish_task:Find(ach.id)
				if find == nil then
					--��������ٵ�ǰ��������
					find = current_task:Find(ach.id)
					if find == nil and role._roledata._status._level >= ach.aquire_level then
						--���԰�����ɾ���ӵ���ǰ�ɾ�����
						local tmp = CACHE.Task()
						tmp._task_id = ach.id

						local task_data = CACHE.TaskData()
						for i = 1,condition_count do
							local xxx = "condition"..i.."_type"
							local yyy = "condition"..i.."_facor"
							local zzz = "condition"..i.."_data"
							if ach[xxx] ~= 0 then
								task_data._type = ach[xxx]
								task_data._condition = ach[yyy]
								task_data._num = 0
								task_data._maxnum = ach[zzz]
								tmp._task_condition:PushBack(task_data)
							end
						end
						current_task:Insert(ach.id, tmp)

						if ach.achtype == G_ACH_TYPE["HERO_TUPO"] then
							tupo_flag = true
						elseif ach.achtype == G_ACH_TYPE["HERO_STAR"] then
							star_flag = true
						elseif ach.achtype == G_ACH_TYPE["WEAPON_LEVELUP"] then
							weapon_level_flag = true
						elseif ach.achtype == G_ACH_TYPE["EQUIPMENT_LEVELUP"] then
							equip_level_flag = true
						elseif ach.achtype == G_ACH_TYPE["LESSNUM"] then
							if ach.achtype2 == G_ACH_TWENTYONE_TYPE["JJCRANK"] then
								pverank_flag = true
							elseif ach.achtype2 == G_ACH_TWENTYONE_TYPE["3V3GRADE"] then
								pvpgrade_flag = true
							end
						end

						local resp = NewCommand("Task_Condition")
						resp.tid = ach.id
						resp.condition = {}
						local tmp_con = {}
						local cit = tmp._task_condition:SeekToBegin()
						local c = cit:GetValue()
						while c ~= nil do
							tmp_con.current = c._num
							tmp_con.max = c._maxnum
							resp.condition[#resp.condition+1] = tmp_con
							cit:Next()
							c = cit:GetValue()
						end
						role:SendToClient(SerializeCommand(resp))
					end
				end
			end
		elseif ach.begin_date ~= 0 then
			local begin_time = ach.begin_date*10000+ach.begin_time
			local end_time = ach.end_date*10000+ach.end_time
			local cur_time = (diff_time.cur_year*10000 + diff_time.cur_month*100 + diff_time.cur_date)*10000+diff_time.cur_hour*100
			local flag = 1
			if cur_time >= begin_time and cur_time < end_time then
				local find = finish_task:Find(ach.id)
				if find == nil then
					--��������ٵ�ǰ��������
					find = current_task:Find(ach.id)
					if ach.aquire_stage_id ~= 0 then
						local stage = role._roledata._status._instances:Find(ach.aquire_stage_id)
						if stage == nil then
							flag = 0
						end
					end
					if find == nil and role._roledata._status._level >= ach.aquire_level and flag == 1 then
						--���԰�����ɾ���ӵ���ǰ�ɾ�����
						local tmp = CACHE.Task()
						tmp._task_id = ach.id

						local task_data = CACHE.TaskData()
						for i = 1,condition_count do
							local xxx = "condition"..i.."_type"
							local yyy = "condition"..i.."_facor"
							local zzz = "condition"..i.."_data"
							if ach[xxx] ~= 0 then
								task_data._type = ach[xxx]
								task_data._condition = ach[yyy]
								task_data._num = 0
								task_data._maxnum = ach[zzz]
								tmp._task_condition:PushBack(task_data)
							end
						end
						current_task:Insert(ach.id, tmp)
						local resp = NewCommand("Task_Condition")
						resp.tid = ach.id
						resp.condition = {}
						local tmp_con = {}
						local cit = tmp._task_condition:SeekToBegin()
						local c = cit:GetValue()
						while c ~= nil do
							tmp_con.current = c._num
							tmp_con.max = c._maxnum
							resp.condition[#resp.condition+1] = tmp_con
							cit:Next()
							c = cit:GetValue()
						end
						role:SendToClient(SerializeCommand(resp))
					end
				end
			end
		end
	end

	if tupo_flag or star_flag or weapon_level_flag or equip_level_flag or pverank_flag or pvpgrade_flag then
		local msg = NewMessage("UpdateSpecialTask")
		msg.hero_tupo = tupo_flag
		msg.hero_star = star_flag
		msg.weapon_level = weapon_level_flag
		msg.equip_level = equip_level_flag
		msg.pverank = pverank_flag
		msg.pvpgrade = pvpgrade_flag
		API_SendMessage(role._roledata._base._id, SerializeMessage(msg), CACHE.Int64List(), CACHE.Int64List(), CACHE.IntList())
	end
end

function TASK_RefreshTypeTask(role, typ1, typ2)
	local ed = DataPool_Find("elementdata")
	local quanju = ed.gamedefine[1]
	local condition_count = quanju.achievement_condition_max
	
	local achs = ed.achievement
	for ach in DataPool_Array(achs) do
		if (ach.condition1_type == typ1 and ach.condition1_facor == typ2) or
		   (ach.condition2_type == typ1 and ach.condition2_facor == typ2) or
		   (ach.condition3_type == typ1 and ach.condition3_facor == typ2) then
			
			role._roledata._task._current_task:Delete(ach.id)
			role._roledata._task._finish_task:Delete(ach.id)
			local resp = NewCommand("DeleteTask")
			resp.task_id = ach.id
			role:SendToClient(SerializeCommand(resp))
			
			--��������Ҫ�ٴΰ�����������ӽ���
			local tmp = CACHE.Task()
			tmp._task_id = ach.id

			local task_data = CACHE.TaskData()
			for i = 1,condition_count do
				local xxx = "condition"..i.."_type"
				local yyy = "condition"..i.."_facor"
				local zzz = "condition"..i.."_data"
				if ach[xxx] ~= 0 then
					task_data._type = ach[xxx]
					task_data._condition = ach[yyy]
					task_data._num = 0
					task_data._maxnum = ach[zzz]
					tmp._task_condition:PushBack(task_data)
				end
			end
			
			role._roledata._task._current_task:Insert(ach.id, tmp)
			local resp = NewCommand("Task_Condition")
			resp.tid = ach.id
			resp.condition = {}
			local tmp_con = {}
			local cit = tmp._task_condition:SeekToBegin()
			local c = cit:GetValue()
			while c ~= nil do
				tmp_con.current = c._num
				tmp_con.max = c._maxnum
				resp.condition[#resp.condition+1] = tmp_con
				cit:Next()
				c = cit:GetValue()
			end
			role:SendToClient(SerializeCommand(resp))
		end
	end
end

function TASK_SetTaskFinish(role, task_id)
	local ed = DataPool_Find("elementdata")
	local task = role._roledata._task._current_task
	local tit = task:SeekToBegin()
	local t = tit:GetValue()
	--ѭ����ǰ�����гɾ�
	while t ~= nil do
		if t._task_id == task_id then
			local condition = t._task_condition
			local cit = condition:SeekToBegin()
			local c = cit:GetValue()
			local flag = 0
			local ele_task = ed:FindBy("task_id", t._task_id)
			while c ~= nil do
				if c._type ~= 0 then
					if c._type == ele_task.condition1_type then
						c._num = ele_task.condition1_data
					elseif c._type == ele_task.condition2_type then
						c._num = ele_task.condition2_data
					elseif c._type == ele_task.condition3_type then
						c._num = ele_task.condition3_data
					end
				end
				cit:Next()
				c = cit:GetValue()
			end
			break
		end
		tit:Next()
		t = tit:GetValue()
	end
end

function TASK_ResetTask(role, task_type, task_condition)
	local ed = DataPool_Find("elementdata")
	local quanjus = ed.gamedefine
	local condition_count = 0
	for quanju in DataPool_Array(quanjus) do
		condition_count = quanju.achievement_condition_max
		break
	end
	local achs = ed.achievement
	for ach in DataPool_Array(achs) do
		if (ach.condition1_type == task_type and ach.condition1_facor == task_condition) or
		   (ach.condition2_type == task_type and ach.condition2_facor == task_condition) or
		   (ach.condition3_type == task_type and ach.condition3_facor == task_condition) then
			--���Ȳ�����ô��ֱ���ڵ�ǰ�ɾ��Լ���ɵĳɾ����������ɾ�ɾ��
			if role._roledata._task._current_task:Find(ach.id) ~= nil or 
			role._roledata._task._finish_task:Find(ach.id) ~= nil then
				role._roledata._task._current_task:Delete(ach.id)
				role._roledata._task._finish_task:Delete(ach.id)
				local resp = NewCommand("DeleteTask")
				resp.task_id = ach.id
				role:SendToClient(SerializeCommand(resp))
				
				local tmp = CACHE.Task()
				tmp._task_id = ach.id
				
				local task_data = CACHE.TaskData()
				for i = 1,condition_count do
					local xxx = "condition"..i.."_type"
					local yyy = "condition"..i.."_facor"
					local zzz = "condition"..i.."_data"
					if ach[xxx] ~= 0 then
						task_data._type = ach[xxx]
						task_data._condition = ach[yyy]
						task_data._num = 0
						task_data._maxnum = ach[zzz]
						tmp._task_condition:PushBack(task_data)
					end
				end

				role._roledata._task._current_task:Insert(ach.id, tmp)
			
				local resp = NewCommand("Task_Condition")
				resp.tid = ach.id
				resp.condition = {}
				local tmp_con = {}
				local cit = tmp._task_condition:SeekToBegin()
				local c = cit:GetValue()
				while c ~= nil do
					tmp_con.current = c._num
					tmp_con.max = c._maxnum
					resp.condition[#resp.condition+1] = tmp_con
					cit:Next()
					c = cit:GetValue()
				end
				role:SendToClient(SerializeCommand(resp))
			end
		end
	end
end
