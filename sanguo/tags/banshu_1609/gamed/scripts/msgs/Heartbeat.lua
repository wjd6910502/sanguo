function OnMessage_Heartbeat(player, role, arg, others)
	--player:Log("OnMessage_Heartbeat, "..DumpTable(arg))
	--_net_type >= 2 and GetLatency < 200
--	player:Log("Latency:"..player:GetLatency().."\tUDP net type:"..role._roledata._device_info._net_type)
	
	--[[
		if role._roledata._base._id:ToStr() == "1221" or role._roledata._base._id:ToStr() == "1219" then
		local s = role._roledata._jieyi_info._invite_member:Size()
		local fit = role._roledata._jieyi_info._invite_member:SeekToBegin()
		f = fit:GetValue()
		if f ~= nil then
			player:Log("OnMessage_Heartbeat, ".."role._roledata._base._id:ToStr()".."invite size = "..s.."invite id = "..f._id:ToStr())			
		end
	end
	--]]
	
	role._roledata._status._online = 1
	local now = API_GetTime()
	--if player:NetTime_NeedSync() or now%300==0 then
	if now%5==0 and player:NetTime_NeedSync() then
		player:NetTime_Sync2Client()
	end

	if role._roledata._status._vp_refreshtime ~= 0 and now - role._roledata._status._vp_refreshtime >= 360 then
		local point = math.floor((now - role._roledata._status._vp_refreshtime)/360)
		role._roledata._status._vp_refreshtime = point*360 + role._roledata._status._vp_refreshtime
		ROLE_Addvp(role, point, 0)
		
	end
	
	if role._roledata._status._hero_skill_point_refreshtime ~= 0 and now - role._roledata._status._hero_skill_point_refreshtime >= 600 then
		local point = math.floor((now - role._roledata._status._hero_skill_point_refreshtime)/600)
		role._roledata._status._hero_skill_point_refreshtime = point*600 + role._roledata._status._hero_skill_point_refreshtime
		ROLE_AddHeroSkillPoint(role, point)
	end

	if role._roledata._pvp_info._pvp_season_end_time == 0 then
		--在这里扔一个消息，给自己的这个PVP赛季结束设置时间去
		local msg = NewMessage("RoleUpdatePvpEndTime")
		player:SendMessage(role._roledata._base._id, SerializeMessage(msg))
	end
	
	if now - role._roledata._status._update_server_event >= 60 then
		--给自己扔一个消息，查看是否有新的事件需要进行处理
		local msg = NewMessage("RoleUpdateServerEvent")
		player:SendMessage(role._roledata._base._id, SerializeMessage(msg))

		--role._roledata._status._update_server_event = now
	end

	--if role._roledata._pvp._id ~= 0 then
	--	if now - role._last_active_time >= 5 then
	--		role:SendPVPReset()
	--	end
	--end

	--if role._roledata._pvp._state == 1 then
	--	if now - role._last_active_time >= 5 then
	--		role:SendPVPCancle()
	--	end
	--end

	local now_time = os.date("*t", now)
	local last_time = os.date("*t", role._roledata._status._last_heartbeat)
	if now_time.year ~= last_time.year or now_time.month ~= last_time.month or last_time.yday ~= now_time.yday or now_time.hour ~= last_time.hour then
		if now_time.wday == 1 then
			now_time.wday = now_time.wday + 7
		end
		if last_time.wday == 1 then
			last_time.wday = last_time.wday + 7
		end
		
		local diff_time = {}
		diff_time.last_year = last_time.year
		diff_time.cur_year = now_time.year
		diff_time.last_month = last_time.month
		diff_time.cur_month = now_time.month
		diff_time.last_week = last_time.wday - 1
		diff_time.cur_week = now_time.wday - 1
		diff_time.last_day = last_time.yday
		diff_time.cur_day = now_time.yday
		diff_time.last_hour = last_time.hour
		diff_time.cur_hour = now_time.hour
		
		LIMIT_RefreshUseLimit(role, diff_time)
		TASK_RefreshDailyTask(role, diff_time)

		--刷新玩家的个人商店
		PRIVATE_RefreshAllShop(role)
	end

	--给自己的好友更新自己的信息
	if role._roledata._status._notice_other == 1 then
		local msg = NewMessage("RoleUpdateFriendInfo")
		msg.roleid = role._roledata._base._id:ToStr()
		msg.level = role._roledata._status._level
		msg.zhanli = role._roledata._status._zhanli
		msg.online = role._roledata._status._online
		msg.mashu_score = role._roledata._mashu_info._today_max_score
		msg.photo = role._roledata._base._photo
		msg.photo_frame = role._roledata._base._photo_frame
		msg.badge_info = {}

		local badge_info_it = role._roledata._base._badge_map:SeekToBegin()
		local badge_info = badge_info_it:GetValue()
		while badge_info ~= nil do
			local tmp_badge_info = {}
			tmp_badge_info.id = badge_info._id
			tmp_badge_info.typ = badge_info._pos
			msg.badge_info[#msg.badge_info+1] = tmp_badge_info

			badge_info_it:Next()
			badge_info = badge_info_it:GetValue()
		end
	
		local friend_info_it = role._roledata._friend._friends:SeekToBegin()
		local friend_info = friend_info_it:GetValue()
		while friend_info ~= nil do
			player:SendMessage(friend_info._brief._id, SerializeMessage(msg))

			friend_info_it:Next()
			friend_info = friend_info_it:GetValue()
		end
		
		--把自己的状态更新到帮会
		if role._roledata._mafia._id:ToStr() ~= "0" then
			local msg = NewMessage("RoleUpdateMafiaInfo")
			msg.roleid = role._roledata._base._id:ToStr()
			msg.level = role._roledata._status._level
			msg.zhanli = role._roledata._status._zhanli
			msg.online = role._roledata._status._online
			player:SendMessage(role._roledata._mafia._id, SerializeMessage(msg))
		end

		role._roledata._status._notice_other = 0
	end
		
	role._roledata._status._last_heartbeat = now
end
