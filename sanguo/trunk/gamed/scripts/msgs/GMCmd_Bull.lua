function OnMessage_GMCmd_Bull(player, role, arg, others)
	player:Log("OnMessage_GMCmd_Bull, "..DumpTable(arg).." "..DumpTable(others))

	local resp = NewCommand("SendNotice")
	resp.notice_id = G_NOTICE_ID["GM"]
	resp.time = API_GetTime()
	resp.notice_para = {}
	local notice_para = {}
	notice_para.typ = G_NOTICE_TYP["GM"]
	notice_para.text = arg.text
	resp.notice_para[#resp.notice_para+1] = notice_para
    player:SendToClient(SerializeCommand(resp))
end
