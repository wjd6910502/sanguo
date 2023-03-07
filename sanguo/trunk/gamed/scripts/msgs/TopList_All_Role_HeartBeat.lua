function OnMessage_TopList_All_Role_HeartBeat(arg, others)
	--API_Log("OnMessage_TopList_All_Role_HeartBeat, "..DumpTable(arg))

	local now = API_GetTime()
	local toplist_data = others.toplist_all_role._data._data
	local toplist_info_it = toplist_data:SeekToBegin()
	local toplist_info = toplist_info_it:GetValue()
	while toplist_info ~= nil do
		local time_stamp = toplist_info._time_stamp
		local toplist_info_map = toplist_info._data_map
		local typ = toplist_info._typ
	
		if typ == 1 then
			if now >= time_stamp + 3600*24 then
				local ed = DataPool_Find("elementdata")
				local quanju = ed.gamedefine[1]
				toplist_info._time_stamp = API_MakeTodayTime(quanju.global_reset_time, 0, 0)
				--���ͽ��� singletons/TopList_All_Role.h 
				TOP_ALL_Role_SendDailyReward(toplist_data, 1)
				--��ʼ������������Ȼ���toplist������Ϣ�����Ǳߵ����а�ȥ���ϰ�Ľ������Լ��°�����
				toplist_info._data_map:Clear()
				
				local msg = NewMessage("DeleteTopList")
				msg.id = 7
				API_SendMsg(0, SerializeMessage(msg), 0)
				
				local msg = NewMessage("DeleteTopList")
				msg.id = 8
				API_SendMsg(0, SerializeMessage(msg), 0)
			end
		elseif typ == 2 then
			if now >= time_stamp + 3600*24 then
				local ed = DataPool_Find("elementdata")
				local quanju = ed.gamedefine[1]
				toplist_info._time_stamp = API_MakeTodayTime(quanju.global_reset_time, 0, 0)
				TOP_ALL_Role_SendDailyReward(toplist_data, 2)
				toplist_info._data_map:Clear()
				
				local msg = NewMessage("DeleteTopList")
				msg.id = 10
				API_SendMsg(0, SerializeMessage(msg), 0)
			end
		elseif typ == 3 then
			if now >= time_stamp + 3600*24 then
				local ed = DataPool_Find("elementdata")
				local quanju = ed.gamedefine[1]
				toplist_info._time_stamp = API_MakeTodayTime(quanju.global_reset_time, 0, 0)
				TOP_ALL_Role_SendDailyReward(toplist_data, 3)
				toplist_info._data_map:Clear()

				local msg = NewMessage("DeleteTopList")
				msg.id = 11
				API_SendMsg(0, SerializeMessage(msg), 0)
			end
		end

		toplist_info_it:Next()
		toplist_info = toplist_info_it:GetValue()
	end
end
