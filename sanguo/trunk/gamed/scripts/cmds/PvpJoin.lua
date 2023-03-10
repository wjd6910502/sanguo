function OnCommand_PvpJoin(player, role, arg, others)
	player:Log("OnCommand_PvpJoin, "..DumpTable(arg).." "..DumpTable(others).." "..API_GetTime2())

	if G_CONF_PVP_RANDOM_ENABLE==true then
		--以下为临时用代码, pvp随机英雄
		local hsize = role._roledata._hero_hall._heros:Size()
		if hsize>3 then
			role._roledata._pvp_info._last_hero:Clear()
		
			local indexs = {}
			while true do
				local i = math.random(1000)
				indexs[i%hsize+1] = true
				local c = 0
				for _,_ in pairs(indexs) do c=c+1 end
				if c==3 then break end
			end
		
			local hids = {}
			for h in Cache_Map(role._roledata._hero_hall._heros) do
				hids[#hids+1] = h._tid
			end
			
			local resp = NewCommand("SetInstanceHeroInfo_Re")
			resp.retcode = G_ERRCODE["SUCCESS"]
			resp.typ = 2
			resp.battle_id = 0
			resp.heros = {}
			resp.horse = 0
		
			for i,_ in pairs(indexs) do
				local value = CACHE.Int()
				value._value = hids[i]
				role._roledata._pvp_info._last_hero:PushBack(value)
				resp.heros[#resp.heros+1] = hids[i]
			end
		
			player:SendToClient(SerializeCommand(resp))
		end
		--到这里结束
	end

	--检查PVP版本
	local cur_pvp_ver = ROLE_GetPVPVersion(role._roledata._client_ver._client_id, role._roledata._client_ver._exe_ver, role._roledata._client_ver._data_ver)
	if cur_pvp_ver <= 0 then
		local resp = NewCommand("ErrorInfo")
		resp.error_id = G_ERRCODE["EXE_OUT_OF_DATE"]
		player:SendToClient(SerializeCommand(resp))
		player:Log("OnCommand_PvpJoin, error=EXE_OUT_OF_DATE")
		return
	end

	role._roledata._client_ver._pvp_ver = cur_pvp_ver

	--检查当前玩家的状态是否可以进行PVP
	if role._roledata._pvp._id ~= 0 or role._roledata._pvp._state ~= 0 then
		player:Log("OnCommand_PvpJoin, "..role._roledata._pvp._id.."  ".."  "..role._roledata._pvp._state)
		return
	end

	if role._roledata._device_info._net_type < 2 then
		local resp = NewCommand("ErrorInfo")
		resp.error_id = G_ERRCODE["PVP_NET_TYPE_ERR"]
		player:SendToClient(SerializeCommand(resp))
		player:Log("OnCommand_PvpJoin, error=PVP_NET_TYPE_ERR")
		return
	end

	--在这里不进行任何的验证。直接就把消息发给中心服务器去
	if role._roledata._pvp_info._last_hero:Size() == 0 then
		local resp = NewCommand("ErrorInfo")
		resp.error_id = G_ERRCODE["PVP_HERO_COUNT_ERR"]
		player:SendToClient(SerializeCommand(resp))
		player:Log("OnCommand_PvpJoin, error=PVP_HERO_COUNT_ERR")
		return
	end

	local latency = player:GetLatency()
	local udp_latency = player:GetUDPLatency()
	local latency2 = API_GetTime2()-arg.typ*1000
	player:Log("OnCommand_PvpJoin, latency="..latency..", udp_latency="..udp_latency..", latency2="..latency2)
	if latency<0 or udp_latency<0 then
		--设置当前进入了PVP状态
		role._roledata._pvp._state = 1
		role._roledata._status._instance_id = 0
		--采样数据太少，无法确定延迟
		role._roledata._status._pvp_join_flag = 1
		local resp = NewCommand("PvpJoin_Re")
		resp.retcode = 0
		resp.time = role._roledata._pvp_info._pvp_time
		player:SendToClient(SerializeCommand(resp))
		return
		--local resp = NewCommand("ErrorInfo")
		--resp.error_id = G_ERRCODE["PVP_LATENCY_ING"]
		--player:SendToClient(SerializeCommand(resp))
		--return
	--elseif latency2<-10 or latency2>140 then
	--	--时间有错，直接放弃
	--	local resp = NewCommand("ErrorInfo")
	--	resp.error_id = G_ERRCODE["PVP_LATENCY_LARGE"]
	--	player:SendToClient(SerializeCommand(resp))
	--	player:Log("OnCommand_PvpJoin, error=PVP_LATENCY_LARGE")
	--	return
	elseif latency<300 or udp_latency<140 then
		--还行，进
	else
		--网络太差，直接放弃
		local resp = NewCommand("ErrorInfo")
		resp.error_id = G_ERRCODE["PVP_LATENCY_LARGE"]
		player:SendToClient(SerializeCommand(resp))
		player:Log("OnCommand_PvpJoin, error=PVP_LATENCY_LARGE")
		return
	end
	
	--设置当前进入了PVP状态
	role._roledata._pvp._state = 1
	role._roledata._status._instance_id = 0
	ROLE_PVPJoin(player, role)
end
