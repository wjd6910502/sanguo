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

--	role._roledata._client_ver._pvp_ver = 1 --FIXME
	--player:Log("Latency:"..player:GetLatency().."\tUDP net type:"..role._roledata._device_info._net_type.."\t UDP Latency:"..player:GetUDPLatency())

	if role._roledata._status._online~=1 then
		role._roledata._status._online = 1
	end

	if role._roledata._status._init_flag == 0 then
		ROLE_OnlineInit(role)
		role._roledata._status._init_flag = 1
	end

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

	if role._roledata._pve_arena_info._pve_refreshtime ~= nil and role._roledata._pve_arena_info._pve_refreshtime ~= 0 and now >= role._roledata._pve_arena_info._pve_refreshtime then
		PVEARENA_RefreshTime(role, now)
	end

	--商店刷新次数恢复
	PRIVATE_RecoveryShopRefreshTimes(role)
	
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
	
	if now - role._roledata._status._update_server_event >= math.random(60,120) then
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
	--pvp检查判断
	if role._roledata._status._pvp_join_flag == 1 then
		local latency = player:GetLatency()
		local udp_latency = player:GetUDPLatency()
		if (latency>0 and latency<300) or (udp_latency > 0 and udp_latency<140) then
			ROLE_PVPJoin(player, role)
			role._roledata._status._pvp_join_flag = 2
		end
	end

	local now_time = os.date("*t", now)
	local last_time = os.date("*t", role._roledata._status._last_heartbeat)

	if now_time.year ~= last_time.year or now_time.month ~= last_time.month or last_time.yday ~= now_time.yday then --12点跨天
		--军武宝库跨天更新
		role._roledata._military_data._stage_data:Clear()
		local resp = NewCommand("MilitaryUpdateInfo")
		resp.stage_id = role._roledata._military_data._stage_id
		resp.stage_difficult = role._roledata._military_data._stage_difficult
		resp.stage_info = {}
		player:SendToClient(SerializeCommand(resp))	
	end


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
		diff_time.last_date = last_time.day
		diff_time.cur_date = now_time.day
		
		LIMIT_RefreshUseLimit(role, diff_time)
		TASK_RefreshDailyTask(role, diff_time)

		--刷新玩家的个人商店
		PRIVATE_RefreshAllShop(role)
		
		local today_time = now - 5*3600
		local today_date = os.date("*t", today_time)
		if today_date.yday ~= role._roledata._status._dailly_sign._today_flag then
			local resp = NewCommand("DailySignUpdate")
			resp.sign_date = role._roledata._status._dailly_sign._sign_date
			resp.today_flag = 0
			player:SendToClient(SerializeCommand(resp))
		
			--[[	在下面加了新的更新接口，先把这里住掉
			if role._roledata._status._dailly_sign._sign_date%150 == 0 then
				TASK_RefreshTypeTask(role, G_ACH_TYPE["CHONGZHI"], G_ACH_NINTEEN_TYPE["DAILYSIGNBOX"])
			end
			--]]
		end
		local flag = true
		if (diff_time.last_day - diff_time.cur_day) == -1 then
			if diff_time.cur_hour < 5 and diff_time.last_hour >= 5 then
				flag = false
			end
		elseif (diff_time.last_day - diff_time.cur_day) == 0 then
			if diff_time.last_hour >= 5 or diff_time.cur_hour < 5 then
				flag = false
			end
		end

		if flag == true then
			if role._roledata._status._dailly_sign._sign_date > 0 then
				local index = math.fmod(role._roledata._status._dailly_sign._sign_date, 150)
				if index == 0 then
					TASK_ResetTask(role, G_ACH_TYPE["CHONGZHI"], G_ACH_NINTEEN_TYPE["DAILYSIGNBOX"])
				end
			end

			role._roledata._dati_data._cur_num = 0
			role._roledata._dati_data._cur_right_num = 0
			role._roledata._dati_data._today_reward = 0
			role._roledata._dati_data._exp = 0
			role._roledata._dati_data._yuanbao = 0
			role._roledata._dati_data._use_time = 0

			if diff_time.cur_week == 1 then
				role._roledata._dati_data._history_right_num = 0
				role._roledata._dati_data._history_use_time = 0
			end
			
			local resp = NewCommand("DaTiUpdateInfo")
			
			resp.cur_num = role._roledata._dati_data._cur_num
			resp.cur_right_num = role._roledata._dati_data._cur_right_num
			resp.today_reward = role._roledata._dati_data._today_reward
			resp.exp = role._roledata._dati_data._exp
			resp.yuanbao = role._roledata._dati_data._yuanbao
			resp.history_num = role._roledata._dati_data._history_num
			resp.history_right_num = role._roledata._dati_data._history_right_num
			resp.use_time = role._roledata._dati_data._use_time
			resp.history_use_time = role._roledata._dati_data._history_use_time
			player:SendToClient(SerializeCommand(resp))
		end
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
		ROLE_UpdateMafiaInfo(role)
		--if role._roledata._mafia._id:ToStr() ~= "0" then
		--	local msg = NewMessage("RoleUpdateMafiaInfo")
		--	msg.roleid = role._roledata._base._id:ToStr()
		--	msg.level = role._roledata._status._level
		--	msg.zhanli = role._roledata._status._zhanli
		--	msg.online = role._roledata._status._online
		--	player:SendMessage(role._roledata._mafia._id, SerializeMessage(msg))
		--end

		role._roledata._status._notice_other = 0
	end
		
	role._roledata._status._last_heartbeat = now

	--给玩家仍全服的聊天信息
	local chat_info = others.chat_info._data._chat_info
	local index = chat_info._chat_index
	if role._roledata._status._chat_index < index then
		if(index - role._roledata._status._chat_index) > 10 then
			role._roledata._status._chat_index = index - 10
		end
		for i = role._roledata._status._chat_index+1, index do
			local chat_data = chat_info._chat_data:Find(i)
			if chat_data ~= nil then
				local cmd = NewCommand("PublicChat")
				cmd.channel = chat_data._channel
				cmd.typ = chat_data._chat_typ
				cmd.time = chat_data._time
				cmd.speech_content = chat_data._speech_content
				cmd.text_content = chat_data._text_content
				
				cmd.src = {}
				cmd.src.id = chat_data._src._id:ToStr()
				cmd.src.name = chat_data._src._name
				cmd.src.photo = chat_data._src._photo
				cmd.src.level = chat_data._src._level
				cmd.src.mafia_id = chat_data._src._mafia_id:ToStr()
				cmd.src.mafia_name = chat_data._src._mafia_name
				cmd.src.sex = 1
				cmd.src.photo_frame = chat_data._src._photo_frame
				cmd.src.badge_info = {}
				local badge_info_it = chat_data._src._badge_map:SeekToBegin()
				local badge_info = badge_info_it:GetValue()
				while badge_info ~= nil do
					local tmp_badge_info = {}
					tmp_badge_info.id = badge_info._id
					tmp_badge_info.typ = badge_info._pos
					cmd.src.badge_info[#cmd.src.badge_info+1] = tmp_badge_info

					badge_info_it:Next()
					badge_info = badge_info_it:GetValue()
				end
				player:SendToClient(SerializeCommand(cmd))
			end
		end
		role._roledata._status._chat_index = index
	end

	--如果服务器时间被修改了(调试功能)，则不断提示玩家
	if API_HaveTimeOffset() and now%31==0 then
		local resp = NewCommand("PublicChat")
		resp.src = ROLE_MakeRoleBrief(role)
		--resp.text_content = "TIME IS CHANGED, ALL DATA WILL BE LOST!!!"
		--游戏服务器时间被修改了，之后所有数据将不会存盘，请测试完后及时重启服务器！
		--od -t u1 txt.utf8
		resp.text_content = "\230\184\184\230\136\143\230\156\141\229\138\161\229\153\168\230\151\182\233\151\180\232\162\171\228\191\174\230\148\185\228\186\134\239\188\140\228\185\139\229\144\142\230\137\128\230\156\137\230\149\176\230\141\174\229\176\134\228\184\141\228\188\154\229\173\152\231\155\152\239\188\140\232\175\183\230\181\139\232\175\149\229\174\140\229\144\142\229\143\138\230\151\182\233\135\141\229\144\175\230\156\141\229\138\161\229\153\168\239\188\129"
		resp.time = now
		resp.channel = 2
		player:SendToClient(SerializeCommand(resp))
	end

	--获取并处理全局消息(即广播消息)
	local global_message = API_GetLuaGlobalMessage_NOLOCK()
	local rets = global_message:Get_NOLOCK(0, role._roledata._misc._global_message_index)
	if rets~=nil then
		role._roledata._misc._global_message_index = rets._index
		for s in Cache_List(rets._msgs) do
			_DeserializeAndProcessPlayerMessage(s._str, player, role, s._checksum)
		end
		for s in Cache_List(rets._cmds) do
			--player:Log("OnMessage_Heartbeat, 1")
			local is_idx, c_type= Deserialize(s._str, 1, "number")
			if s._checksum == G_CHECKSUM_C[c_type] then
				player:SendToClient(s._str)
			else
				player:Log("Err in Sending Command "..c_type.." : strus has changed!")
			end
		end
		global_message:ReleaseResult_NOLOCK(rets)
	end

	--每60秒检查一次是否有ServerReward
	if (now-role._roledata._base._create_time)%60 == 0 then
		local msg = NewMessage("CheckServerReward")
		player:SendMessage(role._roledata._base._id, SerializeMessage(msg))
	end

	--local uptime = API_GetUptime()
	--local prev = role._roledata._misc._prev_server_ms
	--if prev>0 and uptime-prev>60*1000 then
	--	--timeout, restart
	--	role._roledata._misc._prev_server_ms = 0
	--	role._roledata._misc._bt = 0
	--	role._roledata._misc._et = 0
	--	role._roledata._misc._ct = ""
	--	player:Log("OnMessage_Heartbeat, reset _prev_server_ms/_bt/_et")
	--end
	--local prev = role._roledata._misc._prev_server_ms
	--if prev==0 then
	--	role._roledata._misc._prev_server_ms = uptime
	--	local cmd = NewCommand("GetClientLocalTime")
	--	cmd.server_ms = uptime
	--	player:SendToClient(SerializeCommand(cmd))
	--end

	--local msg = NewMessage("TestMessage1")
	--player:SendMessage(role._roledata._base._id, SerializeMessage(msg))
end
