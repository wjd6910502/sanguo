function OnMessage_PvpGetVideo(player, role, arg, others)
	player:Log("OnMessage_PvpGetVideo, "..DumpTable(arg).." "..DumpTable(others))
	
	local resp = NewCommand("GetVideo_Re")
	resp.retcode = G_ERRCODE["SUCCESS"]
	resp.win_flag = arg.win_flag
	local is_idx,player1 = DeserializeStruct(arg.first_pvpinfo, 1, "RolePVPInfo")
	local is_idx,player2 = DeserializeStruct(arg.second_pvpinfo, 1, "RolePVPInfo")

	resp.player1 = {}
	resp.player2 = {}

	resp.player1.brief = player1.brief
	resp.player1.hero_hall = player1.hero_hall
	resp.player1.pvp_score = player1.pvp_score
	
	resp.player2.brief = player2.brief
	resp.player2.hero_hall = player2.hero_hall
	resp.player2.pvp_score = player2.pvp_score

	local is_idx,operation = DeserializeStruct(arg.operation, 1, "PvpVideo")

	resp.operation = {}
	resp.operation.video = {}
	for i = 1, table.getn(operation.video) do
		resp.operation.video[#resp.operation.video+1] = operation.video[i]
	end

	player:SendToClient(SerializeCommand(resp))
end
