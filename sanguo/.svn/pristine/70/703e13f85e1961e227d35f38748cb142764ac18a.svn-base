function OnMessage_SendServerEvent(mist, arg, others)
	API_Log("OnMessage_SendServerEvent, "..DumpTable(arg).." "..DumpTable(others))

	--开始把这个事件添加到总的系统事件里面去
	local server_event = mist._miscdata._server_event
	server_event._event_index = server_event._event_index + 1

	local event = CACHE.Event()
	event._event_id = server_event._event_index
	event._event_type = arg.event_type
	event._event_time = API_GetTime()
	event._event_end_time = arg.end_time*3600*24 + API_MakeTodayTime(0, 0, 0)

	server_event._event_info:Insert(event._event_id, event)
end
