function OnMessage_PvpSeasonFinish(arg, others)
	API_Log("OnMessage_PvpSeasonFinish, "..DumpTable(arg).." "..DumpTable(others))

	--��������Լ����һ���¼���������������
	local server_event = others.misc._miscdata._server_event
	server_event._event_index = server_event._event_index + 1

	local server_event_info = server_event._event_info
	local event_it = server_event_info:SeekToBegin()
	local event = event_it:GetValue()
	local del_event = {}
	while event ~= nil do
		del_event[#del_event+1] = event._event_id
		event_it:Next()
		event = event_it:GetValue()
	end
	--���Ȳ鿴������͵�ɾ������
	for i = 1, table.getn(del_event) do
		server_event_info:Delete(del_event[i])
	end

	local event = CACHE.Event()
	event._event_id = server_event._event_index
	event._event_type = G_EVENT_TYPE["PVP_SEASON_FINISH"]
	event._event_time = API_GetTime()
	event._event_end_time = 5*3600*24 + API_MakeTodayTime(0, 0, 0)

	server_event._event_info:Insert(event._event_id, event)

	--��������յ����а�
	local toplist = others.toplist._top_manager:Find(3)
	if toplist~=nil then
		toplist._new_top_list_by_id:Clear()
		toplist._new_top_list_by_data._data:Clear()
	end
end
