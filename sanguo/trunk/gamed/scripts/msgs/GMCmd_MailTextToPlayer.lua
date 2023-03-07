function OnMessage_GMCmd_MailTextToPlayer(player, role, arg, others)
	player:Log("OnMessage_GMCmd_MailTextToPlayer, "..DumpTable(arg).." "..DumpTable(others))

	local msg = NewMessage("SendMail")
	msg.title = arg.mailtitle
	msg.content = arg.mailcontent
	player:SendMessage(role._roledata._base._id, SerializeMessage(msg), 0)

	player:GMCmdMailItemToPlayerReply(arg.session_id, arg.sid)

end
