function OnCommand_PrivateChat(player, role, arg, others)
	player:Log("OnCommand_PrivateChat, "..DumpTable(arg).." "..DumpTable(others))
	
	--type=1私聊为语音的话 第二个参数 0 为公聊  1为私聊
	--if arg.typ == 1 then		
	--	role:SendSpeechToSTT(arg.dest_id,1,arg.speech_content);
	--	return
	--end

	--内容长度有限制
	if string.len(arg.text_content)>200 then
		local cmd = NewCommand("ErrorInfo")
		cmd.error_id = G_ERRCODE["CHAT_TOO_LONG"]
		return
	end

	local dest_role = others.roles[arg.dest_id]

	--不可以给自己发送私聊
	if role._roledata._base._id:ToStr() == dest_role._roledata._base._id:ToStr() then
		local cmd = NewCommand("ErrorInfo")
		cmd.error_id = G_ERRCODE["CHAT_TO_SELF"]
		role:SendToClient(SerializeCommand(cmd))
		return
	end
	
	--type=1私聊为语音的话 第二个参数 0 为公聊  1为私聊
	if arg.typ == 1 then		
		role:SendSpeechToSTT(arg.dest_id,1,arg.typ,arg.speech_content);
		return
	end

	--留言太多, 则删掉早期的留言
	local ed = DataPool_Find("elementdata")
	local quanju = ed.gamedefine[1]

	local chats = dest_role._roledata._chat._received_private_chats
	while chats:Size()>= quanju.private_chart_history_num do
		chats:PopFront()
	end
	chats = role._roledata._chat._received_private_chats
	while chats:Size()>=quanju.private_chart_history_num do
		chats:PopFront()
	end

	--保存留言
	--这里只保存好友的聊天记录
	local cur_time = API_GetTime()
	--if role._roledata._friend._friends:Find(dest_role._roledata._base._id) ~= nil then
	local c = CACHE.PrivateChat()

	c._brief._id:Set(role._roledata._base._id)
	c._brief._name = role._roledata._base._name
	c._brief._photo = role._roledata._base._photo
	c._brief._level = role._roledata._status._level
	c._brief._mafia_id = role._roledata._mafia._id
	c._brief._mafia_name = role._roledata._mafia._name
	c._brief._photo_frame = role._roledata._base._photo_frame
	c._brief._badge_map = role._roledata._base._badge_map
		
	c._dest._id:Set(dest_role._roledata._base._id)
	c._dest._name = dest_role._roledata._base._name
	c._dest._photo = dest_role._roledata._base._photo
	c._dest._level = dest_role._roledata._status._level
	c._dest._mafia_id = dest_role._roledata._mafia._id
	c._dest._mafia_name = dest_role._roledata._mafia._name
	c._dest._photo_frame = dest_role._roledata._base._photo_frame
	c._dest._badge_map = dest_role._roledata._base._badge_map
		
	c._time = cur_time
	c._content = arg.text_content
	c._typ = arg.typ	
	role._roledata._chat._received_private_chats:PushBack(c)
	dest_role._roledata._chat._received_private_chats:PushBack(c)
	--end
	
	--给两个玩家发送消息
	local resp = NewCommand("PrivateChat")
	resp.src = ROLE_MakeRoleBrief(role)
	resp.dest = ROLE_MakeRoleBrief(dest_role)
	resp.dest_id = arg.dest_id
	resp.text_content = arg.text_content
	resp.time = cur_time
	
	--是否在线
	if dest_role._roledata._status._online == 0 then
		--local cmd = NewCommand("ErrorInfo")
		--cmd.error_id = G_ERRCODE["CHAT_NOT_ONLINE"]
		--role:SendToClient(SerializeCommand(cmd))
		role:SendToClient(SerializeCommand(resp))	
		return
	end
	

	role:SendToClient(SerializeCommand(resp))
	dest_role:SendToClient(SerializeCommand(resp))
end
