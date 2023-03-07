function OnCommand_HotPvpVideoList(player, role, arg, others)
	player:Log("OnCommand_HotPvpVideoList, "..DumpTable(arg).." "..DumpTable(others))

	local hpv_manager = others.hot_pvp_video._data

	local resp = NewCommand("HotPvpVideoList_Re")
	resp.list = {}

	local c = 0
	for hpv in Cache_ReverseMap(hpv_manager._map) do
		c = c+1
		if c>30 then break end
		if hpv._seq<=arg.seq_max then break end

		local video = hpv._video

		local hpv_c = {}
		hpv_c.seq = hpv._seq

		hpv_c.video = {}
		hpv_c.video.video_id = video._id._value

		local checksum = G_CHECKSUM_S["RolePVPInfo"]
		if checksum == video._first_pvpinfo._checksum and checksum == video._second_pvpinfo._checksum then
			local _,player1 = DeserializeStruct(video._first_pvpinfo._str, 1, "RolePVPInfo")
			hpv_c.video.player1 = {} --RoleClientPVPInfo
			hpv_c.video.player1.brief = player1.brief
			hpv_c.video.player1.hero_hall = player1.hero_hall
			hpv_c.video.player1.pvp_score = player1.pvp_score

			local _,player2 = DeserializeStruct(video._second_pvpinfo._str, 1, "RolePVPInfo")
			hpv_c.video.player2 = {} --RoleClientPVPInfo
			hpv_c.video.player2.brief = player2.brief
			hpv_c.video.player2.hero_hall = player2.hero_hall
			hpv_c.video.player2.pvp_score = player2.pvp_score

			hpv_c.video.win_flag = video._win_flag
			hpv_c.video.time = video._time
			hpv_c.video.match_pvp = video._match_pvp
			hpv_c.video.duration = video._duration

			hpv_c.replayed_count = hpv._replayed_count
			hpv_c.replayed = false
			if role._roledata._misc._hot_pvp_video_replayed_map:Find(hpv._seq)~=nil then hpv_c.replayed=true end

			resp.list[#resp.list+1] = hpv_c
		end
	end

----for test
--	if #resp.list<30 then
--		for hpv in Cache_ReverseMap(hpv_manager._map) do
--			local video = hpv._video
--
--			for i=1+#resp.list,30 do
--				local hpv_c = {}
--				hpv_c.seq = i
--
--				hpv_c.video = {}
--				hpv_c.video.video_id = video._id._value
--
--				local _,player1 = DeserializeStruct(video._first_pvpinfo._value, 1, "RolePVPInfo")
--				hpv_c.video.player1 = {} --RoleClientPVPInfo
--				hpv_c.video.player1.brief = player1.brief
--				hpv_c.video.player1.hero_hall = player1.hero_hall
--				hpv_c.video.player1.pvp_score = player1.pvp_score
--
--				local _,player2 = DeserializeStruct(video._second_pvpinfo._value, 1, "RolePVPInfo")
--				hpv_c.video.player2 = {} --RoleClientPVPInfo
--				hpv_c.video.player2.brief = player2.brief
--				hpv_c.video.player2.hero_hall = player2.hero_hall
--				hpv_c.video.player2.pvp_score = player2.pvp_score
--
--				hpv_c.video.win_flag = video._win_flag
--				hpv_c.video.time = video._time
--				hpv_c.video.match_pvp = video._match_pvp
--				hpv_c.video.duration = video._duration
--
--				hpv_c.replayed_count = hpv._replayed_count
--				hpv_c.replayed = false
--				if role._roledata._misc._hot_pvp_video_replayed_map:Find(hpv._seq)~=nil then hpv_c.replayed=true end
--
--				resp.list[#resp.list+1] = hpv_c
--			end
--
--			break
--		end
--	end
----for end

	player:SendToClient(SerializeCommand(resp))
end
