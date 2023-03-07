function OnCommand_PublicChat(player, role, arg, others)
	--player:Log("OnCommand_PublicChat, "..DumpTable(arg))

	--内容长度有限制
	if string.len(arg.content)>200 then return end

	----通知目标
	local msg = NewMessage("PublicChat")
	msg.src = ROLE_MakeRoleBrief(role)
	msg.content = arg.content
	msg.time = API_GetTime()
	player:SendMessageToAllRole(SerializeMessage(msg))
end
