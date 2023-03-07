function OnMessage_MafiaUpdateNoticeInfo(player, role, arg, others)
	player:Log("OnMessage_MafiaUpdateNoticeInfo, "..DumpTable(arg).." "..DumpTable(others))

	local resp = NewCommand("MafiaUpdateNoticeInfo")
	resp.notice_info = arg.notice_info

	player:SendToClient(SerializeCommand(resp))
end
