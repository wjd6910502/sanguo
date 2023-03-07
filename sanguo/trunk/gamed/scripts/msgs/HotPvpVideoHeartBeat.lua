function OnMessage_HotPvpVideoHeartBeat(arg, others)
	--API_Log("OnMessage_HotPvpVideoHeartBeat, "..DumpTable(arg))

	local manager = others.hot_pvp_video._data
	local now = API_GetTime()
	if now-manager._prev_time<60 then return end
	manager._prev_time = now;

	API_Log("OnMessage_HotPvpVideoHeartBeat, "..DumpTable(arg))

	if manager._pending_list:Size()>0 then
		local uniq_v = {} --video_id=>v
		local top_score = {} --score arr for sort

		for v in Cache_List(manager._pending_list) do
			if uniq_v[v._id._value]==nil then
				uniq_v[v._id._value] = v
				top_score[#top_score+1] = v._score
			end
		end

		table.sort(top_score)
		local score_limit = top_score[1]
		if #top_score>5 then score_limit = top_score[#top_score+1-5] end

		--local c = 0
		for _,v in pairs(uniq_v) do
			if v._score>=score_limit then
				--c = c+1
				--if c>5 then break end --最多挑5个

				local hpv = CACHE.HotPvpVideo()
				manager._seq_stub = manager._seq_stub+1
				hpv._seq = manager._seq_stub
				hpv._video = v
				hpv._replayed_count = 0
				manager._map:Insert(hpv._seq, hpv)
			end
		end

		manager._pending_list:Clear() --FIXME: 提前放可以吗？
	end
end
