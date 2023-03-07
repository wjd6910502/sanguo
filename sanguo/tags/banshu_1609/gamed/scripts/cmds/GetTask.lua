function OnCommand_GetTask(player, role, arg, others)
	player:Log("OnCommand_GetTask, "..DumpTable(arg).." "..DumpTable(others))
	
	--再次把当前的成就，以及完成的成就发给客户端，让客户端来进行更新
	local resp = NewCommand("FinishedTask")
	resp.finish = {}
	local finish_task = role._roledata._task._finish_task
	local tit = finish_task:SeekToBegin()
	local t = tit:GetValue()
	while t ~= nil do
		resp.finish[#resp.finish+1]=t._task_id
		tit:Next()
		t = tit:GetValue()
	end
	role:SendToClient(SerializeCommand(resp))

	local resp_cur = NewCommand("CurrentTask")
	resp_cur.current = {}
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
		resp_cur.current[#resp_cur.current+1]=t2
		tit:Next()
		t = tit:GetValue()
	end
	role:SendToClient(SerializeCommand(resp_cur))

end
