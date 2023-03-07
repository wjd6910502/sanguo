function OnMessage_MafiaHeartBeat(mafia, arg, others)
--	API_Log("OnMessage_MafiaHeartBeat, "..DumpTable(arg).." "..DumpTable(others))

	--Ŀǰֻ��Ҫ����һ�����飬�Ǿ��ǲ鿴�Ƿ���Ҫ��ռ�����ȡ�
	local ed = DataPool_Find("elementdata")
	local quanju = ed.gamedefine[1]
	local mafia_info = mafia._data
	local clear_time = API_MakeTodayTime(quanju.global_reset_time, 0, 0)
	
	if mafia_info._last_heartbeat <= clear_time and arg.now > clear_time then
		if mafia_info._jisi ~= 0 then
			mafia_info._jisi = 0
			MAFIA_MafiaUpdateExp(mafia_info)
		end
		
		mafia_info._all_mashu_score = 0

		--��ÿһ����ҵ�ÿ�չ��׽�������
		local member_info_it = mafia_info._member_map:SeekToBegin()
		local member_info = member_info_it:GetValue()
		while member_info ~= nil do
			while member_info._week_contribution:Size() >= 7 do
				member_info._week_contribution:PopBack()
			end
			local insert_contrabution = CACHE.Int()
			insert_contrabution._value = 0
			member_info._week_contribution:PushFront(insert_contrabution)
			MAFIA_MafiaUpdateMember(mafia_info, member_info)

			member_info_it:Next()
			member_info = member_info_it:GetValue()
		end
	end

	mafia_info._last_heartbeat = arg.now
end