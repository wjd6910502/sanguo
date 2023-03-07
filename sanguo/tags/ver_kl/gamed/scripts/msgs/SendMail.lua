function OnMessage_SendMail(player, role, arg, others)
	player:Log("OnMessage_SendMail, "..DumpTable(arg).." "..DumpTable(others))

	local resp = NewCommand("UpdateMail")
	resp.mail_info = {}
	
	local ed = DataPool_Find("elementdata")
	local mail_xml = ed:FindBy("mail_id", arg.mail_id)
	local Reward = 0
	local mail = CACHE.Mail()
	
	--if mail_xml.reward ~= 0 then
	--	resp.mail_info.item = {}
	--	Reward = DROPITEM_Reward(role, mail_xml.reward)
	--	for i = 1, table.getn(Reward.item) do
	--		local tmp_item = CACHE.Mail_Item()
	--		tmp_item._item_id = Reward.item[i].itemid
	--		tmp_item._item_count = Reward.item[i].itemnum
	--		mail._item:PushBack(tmp_item)
	--		local client_item = {}
	--		client_item.tid = tmp_item._item_id
	--		client_item.count = tmp_item._item_count
	--		resp.mail_info.item[#resp.mail_info.item+1] = client_item
	--	end
	--end

	role._roledata._mail_info._mail_index = role._roledata._mail_info._mail_index + 1
	mail._mail_id = role._roledata._mail_info._mail_index
	mail._msg_id = arg.mail_id
	mail._subject = ""
	mail._context = ""
	mail._time = API_GetTime()
	mail._from_id:Set(0)
	mail._from_name = ""
	local tmp_arg = CACHE.Str()
	tmp_arg._value = arg.arg1
	mail._mail_arg:PushBack(tmp_arg)

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
	resp.mail_info.mail_arg = {}
	resp.mail_info.mail_arg[#resp.mail_info.mail_arg+1] = tostring(arg.arg1)
	resp.mail_info.read_flag = 0
	role:SendToClient(SerializeCommand(resp))
	return
end
