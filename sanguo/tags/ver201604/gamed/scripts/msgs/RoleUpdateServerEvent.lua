function OnMessage_RoleUpdateServerEvent(player, role, arg, others)
	player:Log("OnMessage_RoleUpdateServerEvent, "..DumpTable(arg).." "..DumpTable(others))

	local server_event = others.mist._miscdata._server_event._event_info

	local event_it = server_event:SeekToBegin()
	local event = event_it:GetValue()
	while event ~= nil do
		if event._event_time > role._roledata._status._update_server_event then
			if event._event_type == G_EVENT_TYPE["MAIL_PVP_DAILY"] then
				local msg = NewMessage("SendMail")
				local mail_id = 0
				if role._roledata._pvp_info._pvp_grade == 0 then
					mail_id = 1001
				elseif role._roledata._pvp_info._pvp_grade <= 5 then
					mail_id = 1002
				elseif role._roledata._pvp_info._pvp_grade <= 10 then
					mail_id = 1003
				elseif role._roledata._pvp_info._pvp_grade <= 20 then
					mail_id = 1004
				elseif role._roledata._pvp_info._pvp_grade <= 25 then
					--当这个玩家是25段位的时候，需要判断一下这个玩家是否玩过这个活动
					if role._roledata._pvp_info._pvp_grade == 25 then
						if role._roledata._pvp_info._win_count == 0 and role._roledata._pvp_info._fail_count == 0 then
							mail_id = 0
						else
							mail_id = 1004
						end
					else
						mail_id = 1004
					end
				end
				if mail_id ~= 0 then
					msg.mail_id = mail_id
					msg.arg1 = tostring(role._roledata._pvp_info._pvp_grade)
					player:SendMessage(role._roledata._base._id, SerializeMessage(msg))
				end
			elseif event._event_type == G_EVENT_TYPE["PVP_SEASON_FINISH"] then
				role._roledata._pvp_info._pvp_server_season_end_time = others.mist._miscdata._pvp_season_end_time
				role._roledata._pvp_info._pvp_season_end_time = others.mist._miscdata._pvp_season_end_time
				local cmd = NewCommand("UpdatePvpEndTime")
				cmd.end_time = role._roledata._pvp_info._pvp_season_end_time
				player:SendToClient(SerializeCommand(cmd))
				
				local ed = DataPool_Find("elementdata")
				local achs = ed.achievement
				for ach in DataPool_Array(achs) do
					if ach.achtype == G_ACH_TYPE["PVP_SERVER_FINISH"] then

						if role._roledata._task._current_task:Find(ach.id) ~= nil or
						role._roledata._task._finish_task:Find(ach.id) ~= nil then
						
							role._roledata._task._current_task:Delete(ach.id)
							role._roledata._task._finish_task:Delete(ach.id)
							local resp = NewCommand("DeleteTask")
							resp.task_id = ach.id
							role:SendToClient(SerializeCommand(resp))
						end

						if role._roledata._pvp_info._pvp_grade >= ach.start_range and 
						role._roledata._pvp_info._pvp_grade <= ach.end_range then
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

				--开始修改当前界别
				if role._roledata._pvp_info._pvp_grade == 0 then
					local quanju = ed.gamedefine[1]
					role._roledata._pvp_info._pvp_grade = quanju.pvp_3v3_rank0_reset_rank
					role._roledata._pvp_info._cur_star = 0
				else
					local ranking = ed:FindBy("ranking_id", role._roledata._pvp_info._pvp_grade)
					role._roledata._pvp_info._pvp_grade = ranking.rank_reset
					role._roledata._pvp_info._cur_star = 0
				end

				--更新到客户端
				local data = 0
				if role._roledata._pvp_info._pvp_grade == 0 then
					--这里是为了在排行榜中做排列的时候，容易一些.
					--这里是做了一些假设的，假设玩家的传说分数不会低于10000
					data = role._roledata._pvp_info._cur_star + 10000
				else
					for i = 25, role._roledata._pvp_info._pvp_grade + 1, -1 do
						local ranking = ed:FindBy("ranking_id", i)
						data = data + ranking.ascending_order_star
					end
					data = data + role._roledata._pvp_info._cur_star
				end
				--把玩家的信息更新到排行榜中去
				local msg = NewMessage("RoleUpdateTopList")
				msg.top_type = 3
				msg.data = data
				player:SendMessage(role._roledata._base._id, SerializeMessage(msg))

				local resp = NewCommand("UpdatePvpStar")
				resp.typ = 1
				resp.star = data
				player:SendToClient(SerializeCommand(resp))

				--把PVP英雄的出站信息清空掉
				role._roledata._pvp_info._hero_pvp_info:Clear()
				role._roledata._pvp_info._win_count = 0
				role._roledata._pvp_info._win_flag = 0
				role._roledata._pvp_info._win_victory = 0
				role._roledata._pvp_info._fail_count = 0
				resp = NewCommand("ClearHeroPvpInfo")
				player:SendToClient(SerializeCommand(resp))

				--给客户端进行更新
				local resp = NewCommand("UpdatePvpEndTime")
				resp.end_time = role._roledata._pvp_info._pvp_server_season_end_time
				player:SendToClient(SerializeCommand(resp))
			end
		end

		event_it:Next()
		event = event_it:GetValue()
	end
	role._roledata._status._update_server_event = API_GetTime()
end
