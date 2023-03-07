function OnCommand_GetAttachment(player, role, arg, others)
	player:Log("OnCommand_GetAttachment, "..DumpTable(arg).." "..DumpTable(others))

	local resp = NewCommand("GetAttachment_Re")

	local mailinfo = role._roledata._mail_info._mail_info

	local mail = mailinfo:Find(arg.mail_id)
	
	if mail == nil then
		resp.retcode = G_ERRCODE["MAIL_NOT_EXIST"]
		role:SendToClient(SerializeCommand(resp))
		return
	end

	local ed = DataPool_Find("elementdata")
	local attachment = mail._item
	if mail._msg_id ~= 0 then
		local mail_xml = ed:FindBy("mail_id", mail._msg_id)
		--首先查看这个邮件是否有附件
		if attachment:Size() == 0 and mail_xml.reward == 0 then
			resp.retcode = G_ERRCODE["MAIL_NO_ATTACHMENT"]
			role:SendToClient(SerializeCommand(resp))
			return
		end
	else
		if attachment:Size() == 0 then
			resp.retcode = G_ERRCODE["MAIL_NO_ATTACHMENT"]
			role:SendToClient(SerializeCommand(resp))
			return
		end
	end

	--开始给奖励
	local item_it = attachment:SeekToBegin()
	local item = item_it:GetValue()
	if item ~= nil then
		BACKPACK_AddItem(role, item._item_id, item._item_count)
		item_it:Next()
		item = item_it:GetValue()
	end
	if mail._msg_id ~= 0 then
		local mail_xml = ed:FindBy("mail_id", mail._msg_id)
		if mail_xml.reward ~= 0 then
			Reward = DROPITEM_Reward(role, mail_xml.reward)
			ROLE_AddReward(role, Reward)
		end
	end

	mailinfo:Delete(arg.mail_id)
	resp.retcode = G_ERRCODE["SUCCESS"]
	role:SendToClient(SerializeCommand(resp))
	return
end
