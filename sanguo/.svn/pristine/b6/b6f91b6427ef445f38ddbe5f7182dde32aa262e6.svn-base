function OnMessage_GMCmd_MailToPlayer(player, role, arg, others)
	player:Log("OnMessage_GMCmd_MailToPlayer, "..DumpTable(arg).." "..DumpTable(others))
	
	local ed = DataPool_Find("elementdata")
	local mail_xml = ed:FindBy("mail_id", arg.mailid)
	if mail_xml ~= nil then
		local msg = NewMessage("SendMail")
		msg.mail_id = arg.mailid
		player:SendMessage(role._roledata._base._id, SerializeMessage(msg), 0)

		player:GMCmdMailToPlayerReply(0, arg.session_id, arg.sid)
	else
		player:GMCmdMailToPlayerReply(-1, arg.session_id, arg.sid)
	end
end
