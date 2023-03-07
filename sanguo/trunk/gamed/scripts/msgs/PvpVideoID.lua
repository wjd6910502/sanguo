function OnMessage_PvpVideoID(player, role, arg, others)
	player:Log("OnMessage_PvpVideoID, "..DumpTable(arg).." "..DumpTable(others))

	if arg.robot_flag~=0 or arg.duration==0 then return end

	local video = CACHE.PvpVideo()
	video._id._value = arg.video_id
	video._first_pvpinfo._str = arg.first_pvpinfo
	video._first_pvpinfo._checksum = G_CHECKSUM_S["RolePVPInfo"]
	video._second_pvpinfo._str = arg.second_pvpinfo
	video._second_pvpinfo._checksum = G_CHECKSUM_S["RolePVPInfo"]
	video._win_flag = arg.win_flag
	video._time = API_GetTime()
	video._match_pvp = arg.match_pvp
	video._score = arg.score
	video._duration = arg.duration
	role._roledata._status._pvp_video:PushBack(video);

	others.hot_pvp_video._data._pending_list:PushBack(video)

	--把这次的录像信息发送给客户端
	local is_idx,player1 = DeserializeStruct(arg.first_pvpinfo, 1, "RolePVPInfo")
	local is_idx,player2 = DeserializeStruct(arg.second_pvpinfo, 1, "RolePVPInfo")

	local resp = NewCommand("UpdatePvpVideo")
	resp.video = arg.video_id
	resp.win_flag = arg.win_flag
	resp.match_pvp = arg.match_pvp
	resp.player1 = {}
	resp.player2 = {}

	resp.player1.brief = player1.brief
	resp.player1.hero_hall = player1.hero_hall
	resp.player1.pvp_score = player1.pvp_score
	
	resp.player2.brief = player2.brief
	resp.player2.hero_hall = player2.hero_hall
	resp.player2.pvp_score = player2.pvp_score
	resp.time = API_GetTime()

	player:SendToClient(SerializeCommand(resp))
end
