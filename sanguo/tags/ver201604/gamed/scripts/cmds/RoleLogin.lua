function OnCommand_RoleLogin(player, role, arg, others)
	player:Log("OnCommand_RoleLogin, "..DumpTable(arg).." "..DumpTable(others))

	--����ҵ�˽����Ϣ�������
	
	--local resp = NewCommand("PrivateChatHistory")
	--resp.private_chat = {}
	--local chats = role._roledata._chat._received_private_chats

	--local cit = chats:SeekToBegin()
	--local c = cit:GetValue()
	--while c~=nil do
	--	local c2 = {}
	--	c2.src = {}
	--	c2.src.id = c._brief._id:ToStr()
	--	c2.src.name = c._brief._name
	--	c2.src.photo = c._brief._photo
	--	c2.src.level = c._brief._level
	--	c2.src.mafia_id = c._brief._mafia_id:ToStr()
	--	c2.src.mafia_name = c._brief._mafia_name
	--	c2.content = c._content
	--	c2.time = c._time

	--	resp.private_chat[#resp.private_chat+1] = c2
	--	cit:Next()
	--	c = cit:GetValue()
	--end
	--player:SendToClient(SerializeCommand(resp))

	--�鿴ȫ���¼��������д���
	local msg = NewMessage("RoleUpdateServerEvent")
	player:SendMessage(role._roledata._base._id, SerializeMessage(msg))

	--ˢ����ҵĸ����̵�
	PRIVATE_RefreshAllShop(role)
	--ˢ����ҵ�ս����Ϣ
	--ROLE_RefreshAllBattleInfo(role)
	--local now = API_GetTime()
	--role._roledata._status._update_server_event = now
end