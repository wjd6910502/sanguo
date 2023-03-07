function OnCommand_PrivateChat(player, role, arg, others)
	player:Log("OnCommand_PrivateChat, "..DumpTable(arg).." "..DumpTable(others))

	--���ݳ���������
	if string.len(arg.content)>200 then 
		local cmd = NewCommand("ErrorInfo")
		cmd.error_id = G_ERRCODE["CHAT_TOO_LONG"]
		return 
	end

	local dest_role = others.roles[arg.dest_id]

	--�����Ը��Լ�����˽��
	if role._roledata._base._id:ToStr() == dest_role._roledata._base._id:ToStr() then
		local cmd = NewCommand("ErrorInfo")
		cmd.error_id = G_ERRCODE["CHAT_TO_SELF"]
		role:SendToClient(SerializeCommand(cmd))
		return 
	end

	--����̫��, ��ɾ�����ڵ�����
	local chats = dest_role._roledata._chat._received_private_chats
	while chats:Size()>=10 do 
		chats:PopFront() 
	end
	chats = role._roledata._chat._received_private_chats
	while chats:Size()>=10 do 
		chats:PopFront() 
	end

	--��������
	local c = CACHE.PrivateChat()

	c._brief._id:Set(role._roledata._base._id)
	c._brief._name = role._roledata._base._name
	c._brief._photo = role._roledata._base._photo
	c._brief._level = role._roledata._status._level
	c._brief._mafia_id = role._roledata._mafia._id
	c._brief._mafia_name = role._roledata._mafia._name
	
	c._dest._id:Set(dest_role._roledata._base._id)
	c._dest._name = dest_role._roledata._base._name
	c._dest._photo = dest_role._roledata._base._photo
	c._dest._level = dest_role._roledata._status._level
	c._dest._mafia_id = dest_role._roledata._mafia._id
	c._dest._mafia_name = dest_role._roledata._mafia._name
	
	c._time = API_GetTime()
	c._content = arg.content
	
	role._roledata._chat._received_private_chats:PushBack(c)
	dest_role._roledata._chat._received_private_chats:PushBack(c)
	
	--��������ҷ�����Ϣ
	local resp = NewCommand("PrivateChat")
	resp.src = ROLE_MakeRoleBrief(role)
	resp.dest = ROLE_MakeRoleBrief(dest_role)
	resp.dest_id = arg.dest_id
	resp.content = arg.content
	resp.time = c._time

	role:SendToClient(SerializeCommand(resp))

	--�ж�����Ƿ�����
	if dest_role:IsActiveRole() == false then
		local cmd = NewCommand("ErrorInfo")
		cmd.error_id = G_ERRCODE["CHAT_NOT_ONLINE"]
		role:SendToClient(SerializeCommand(cmd))
		return 
	end

	dest_role:SendToClient(SerializeCommand(resp))
end