function OnCommand_ReadMail(player, role, arg, others)
	player:Log("OnCommand_ReadMail, "..DumpTable(arg).." "..DumpTable(others))

	local resp = NewCommand("ReadMail_Re")

	local mailinfo = role._roledata._mail_info._mail_info

	--�鿴�������Ƿ�������ʼ�
	local mail = mailinfo:Find(arg.mail_id)

	if mail == nil then
		resp.retcode = G_ERRCODE["MAIL_NOT_EXIST"]
		role:SendToClient(SerializeCommand(resp))
		return
	end

	local ed = DataPool_Find("elementdata")
	mail._read_flag = 1
	if mail._item:Size() ~= 0 then
		return
	end
	if mail._msg_id ~= 0 then
		local mail_xml = ed:FindBy("mail_id", mail._msg_id)
		if mail_xml ~= nil then
			if mail_xml.reward ~= 0 then
				return
			end
		end
	end
	--������ʼ��Ļ�ֱ��ɾ��
	mailinfo:Delete(arg.mail_id)
	resp.retcode = G_ERRCODE["SUCCESS"]
	role:SendToClient(SerializeCommand(resp))
	return

end