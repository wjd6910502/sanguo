function OnMessage_TopListHeartBeat(arg, others)
	--API_Log("OnMessage_TopListHeartBeat, "..DumpTable(arg).." "..DumpTable(others))

	local now = API_GetTime()
	local top = others.toplist._data._top_data
	local tit = top:SeekToBegin()
	local tmp_toplist = tit:GetValue()
	while tmp_toplist ~= nil do
		if now >= tmp_toplist._new_top_list_by_data._timestamp then
			local ed = DataPool_Find("elementdata")
			local quanju = ed.gamedefine[1]
			if tmp_toplist._top_list_type ~= 7 and tmp_toplist._top_list_type ~= 8 then
				tmp_toplist._old_top_list = tmp_toplist._new_top_list_by_data._data
			end
			if quanju.global_reset_time >= 0 and quanju.global_reset_time <= 23 then
				tmp_toplist._new_top_list_by_data._timestamp = API_MakeTodayTime(quanju.global_reset_time, 0, 0) + 3600*24
			else
				tmp_toplist._new_top_list_by_data._timestamp = API_MakeTodayTime(5, 0, 0) + 3600*24
			end
			--PVP排行榜奖励
			if tmp_toplist._top_list_type == 3 then
				--在这里给排行榜上面的人发每日的奖励
				local toplist_data = tmp_toplist._old_top_list
				local rit = toplist_data:SeekToBegin()
				local r = rit:GetValue()
				local members = {}
				while r~=nil do
					local rit_list = r:SeekToBegin()
					local r_list = rit_list:GetValue()
					while r_list~=nil do
						members[#members+1] = r_list._id
						rit_list:Next()
						r_list = rit_list:GetValue()
					end
					rit:Next()
					r = rit:GetValue()
				end
				
				local mailid = 0
				local all_number = table.getn(members)
				--for i = 1, all_number do
				--	if i == 1 then
				--		mailid = 1005
				--	elseif i == 2 then
				--		mailid = 1006
				--	elseif i == 3 then
				--		mailid = 1007
				--	elseif i >= 4 and i <= 6 then
				--		mailid = 1008
				--	elseif i >= 7 and i <= 10 then
				--		mailid = 1009
				--	elseif i >= 11 and i <= 15 then
				--		mailid = 1010
				--	else
				--		break
				--	end
				--	local msg = NewMessage("SendMail")
				--	msg.mail_id = mailid
				--	msg.arg1 = tostring(i)
				--	API_SendMsg(members[all_number -i + 1]:ToStr(), SerializeMessage(msg), 0)
				--end
				
				--发一个系统邮件，用来给全服的玩家发送PVP每日奖励
				local msg = NewMessage("SendServerEvent")
				msg.event_type = G_EVENT_TYPE["MAIL_PVP_DAILY"]
				msg.end_time = 1
				API_SendMsg("0", SerializeMessage(msg), 0)
			end
			--帮会马术排行榜积分
			--if tmp_toplist._top_list_type == 8 then
			--	--在这里给排行榜上面的人发每日的奖励
			--	local toplist_data = tmp_toplist._old_top_list
			--	local rit = toplist_data:SeekToBegin()
			--	local r = rit:GetValue()
			--	local members = {}
			--	while r~=nil do
			--		local rit_list = r:SeekToBegin()
			--		local r_list = rit_list:GetValue()
			--		while r_list~=nil do
			--			members[#members+1] = r_list._id
			--			rit_list:Next()
			--			r_list = rit_list:GetValue()
			--		end
			--		rit:Next()
			--		r = rit:GetValue()
			--	end
			--	
			--	local mailid = 0
			--	local all_number = table.getn(members)
			--	for i = 1, all_number do
			--		if i == 1 then
			--			mailid = 1900
			--		elseif i == 2 then
			--			mailid = 1901
			--		elseif i == 3 then
			--			mailid = 1902
			--		else
			--			break
			--		end
			--		local msg = NewMessage("SendMailToMafia")
			--		msg.mail_id = mailid
			--		API_SendMsg(members[all_number -i + 1]:ToStr(), SerializeMessage(msg), 0)
			--	end
			--end
		end
		tit:Next()
		tmp_toplist = tit:GetValue()
	end
end
