function OnMessage_BroadcastPvpVideo(player, role, arg, others)
	player:Log("OnMessage_BroadcastPvpVideo, "..DumpTable(arg).." "..DumpTable(others))

	local resp = NewCommand("BroadcastPvpVideo_Re")
	resp.src = arg.src
	resp.video_id = arg.video_id
	resp.player1 = arg.player1
	resp.player2 = arg.player2
	resp.time = arg.time
	resp.typ = arg.typ
	resp.win_flag = arg.win_flag
	resp.content = arg.content
        player:SendToClient(SerializeCommand(resp))
end
