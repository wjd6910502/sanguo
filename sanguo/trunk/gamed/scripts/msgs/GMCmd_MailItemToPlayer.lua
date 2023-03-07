function OnMessage_GMCmd_MailItemToPlayer(player, role, arg, others)
	player:Log("OnMessage_GMCmd_MailItemToPlayer, "..DumpTable(arg).." "..DumpTable(others))

	--role._roledata._mail_info._mail_index = role._roledata._mail_info._mail_index + 1
	--local mail = CACHE.Mail()
	--mail._mail_id = role._roledata._mail_info._mail_index
	--mail._msg_id = 0
	--mail._subject = arg.mailtitle
	--mail._context = arg.mailcontent
	--mail._time = API_GetTime()
	--mail._from_id:Set(0)
	--mail._from_name = "GM"
	--mail._item = CACHE.Mail_ItemList()
	--for i=1, #arg.items do
	--	local item = CACHE.Mail_Item()
	--	item._item_id = arg.items[i].tid
	--	item._item_count = arg.items[i].count
	--	mail._item:PushBack(item)
	--end


	--role._roledata._mail_info._mail_info:Insert(role._roledata._mail_info._mail_index, mail)

	--local resp = NewCommand("UpdateMail")
	--resp.mail_info = {}
	--resp.mail_info.item = arg.items 
	--resp.mail_info.mail_id = mail._mail_id
	--resp.mail_info.msg_id = mail._msg_id
	--resp.mail_info.subject = mail._subject
	--resp.mail_info.context = mail._context
	--resp.mail_info.time = mail._time
	--resp.mail_info.from_id = mail._from_id:ToStr()
	--resp.mail_info.from_name = mail._from_name
	--resp.mail_info.mail_arg = {}
	--resp.mail_info.read_flag = 0
	--role:SendToClient(SerializeCommand(resp))

	local msg = NewMessage("SendMail")
	msg.mail_id = tonumber(arg.items[1].tid)
	player:SendMessage(role._roledata._base._id, SerializeMessage(msg), 0)

	player:GMCmdMailItemToPlayerReply(arg.session_id, arg.sid)
end
