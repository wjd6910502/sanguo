function OnMessage_MafiaBangZhuSendMail(player, role, arg, others)
	player:Log("OnMessage_MafiaBangZhuSendMail, "..DumpTable(arg).." "..DumpTable(others))

	local resp = NewCommand("UpdateMail")
	resp.mail_info = {}
	
	local mail = CACHE.Mail()

	role._roledata._mail_info._mail_index = role._roledata._mail_info._mail_index + 1
	mail._mail_id = role._roledata._mail_info._mail_index
	mail._msg_id = 0
	mail._subject = arg.subject
	mail._context = arg.context
	mail._time = API_GetTime()
	mail._from_id:Set(arg.id)
	mail._from_name = arg.name

	role._roledata._mail_info._mail_info:Insert(role._roledata._mail_info._mail_index, mail)

	--给客户端来进行更新
	resp.mail_info.item = {} 
	resp.mail_info.mail_id = mail._mail_id
	resp.mail_info.msg_id = mail._msg_id
	resp.mail_info.subject = mail._subject
	resp.mail_info.context = mail._context
	resp.mail_info.time = mail._time
	resp.mail_info.from_id = mail._from_id:ToStr()
	resp.mail_info.from_name = mail._from_name
	resp.mail_info.read_flag = 0
	role:SendToClient(SerializeCommand(resp))

	return
end
