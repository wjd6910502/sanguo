function OnCommand_PublicChat(player, role, arg, others)
	--player:Log("OnCommand_PublicChat, "..DumpTable(arg))

	--���ݳ���������
	if string.len(arg.content)>200 then return end

	----֪ͨĿ��
	local msg = NewMessage("PublicChat")
	msg.src = ROLE_MakeRoleBrief(role)
	msg.content = arg.content
	msg.time = API_GetTime()
	player:SendMessageToAllRole(SerializeMessage(msg))
end