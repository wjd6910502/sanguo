function TASK_TaskEvent(role, event, id)
	local current_task = role._roledata._task._current_task
	local it = current_task:SeekToBegin()
	local inv = it:GetValue()
	while inv~=nil do
		local task_condition = inv._task_condition
		local it2 = task_condition:SeekToBegin()
		local inv2 = it2:GetValue()
		while inv2~=nil do
			--��������Ҫ�ж��¼����ͣ��¼���Ӧ��ID���Լ���ǰ�Ĵ�����������ֱ�ӵĹ�ϵ
			if inv2._event_id == event and inv2._instance_id == id and inv2._num < inv2._maxnum then
				inv2._num = inv2._num+1
				--��������ͻ��˷���һ����Ϣ��֪ͨ�ͻ����޸�����
				local resp = NewCommand("TaskEvent_Re")
				resp.retcode = G_ERRCODE["SUCCESS"]
				resp.task_id = inv._task_id
				resp.num = inv2._num
				resp.max_num = inv2._maxnum
				resp.event = event
				resp.id = id
				role:SendToClient(SerializeCommand(resp))
			end
			it2:Next()
			inv2 = it2:GetValue()
		end
		it:Next()
		inv = it:GetValue()
	end
end