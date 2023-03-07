function OnMessage_PvpGetVideoErr(player, role, arg, others)
	player:Log("OnMessage_PvpGetVideoErr, "..DumpTable(arg).." "..DumpTable(others))

	local resp = NewCommand("GetVideo_Re")
	resp.retcode = G_ERRCODE["PVP_VIDEO_NOT_EXIST"]

	player:SendToClient(SerializeCommand(resp))
end
