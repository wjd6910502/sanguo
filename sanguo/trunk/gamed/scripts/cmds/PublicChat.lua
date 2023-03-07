function OnCommand_PublicChat(player, role, arg, others)
	player:Log("OnCommand_PublicChat, "..DumpTable(arg).." "..DumpTable(others))
	
	--内容长度有限制
	if string.len(arg.text_content)>200 then return end

	if arg.channel == 3 and role._roledata._mafia._id:ToStr() == "0" then
		return
	end

	--local chat_info = others.chat_info._data._chat_info
	--如果type为1 语音翻译 第二个参数为0 代表公聊
	if arg.typ == 1 then
		local channel = arg.typ*100 + arg.channel 	
		--PrintSpeech(arg.speech_content)
		role:SendSpeechToSTT(0,0,channel,arg.speech_content)
		return
	end

	----通知目标
	local msg = NewMessage("PublicChatnew")
	msg.src = ROLE_MakeRoleBrief(role)
	msg.text_content = arg.text_content
	msg.channel = arg.channel
	if arg.speech_content ~= nil then
		msg.speech_content = arg.speech_content
	end
	
	msg.time = API_GetTime()
	if arg.channel == 2 then
		--查看玩家是否在禁言名单中
		local mist = others.misc
		local forbidmap = mist._miscdata._forbidlogin_role_map
		local forbidinfo = forbidmap:Find(role._roledata._base._id)
		if forbidinfo ~= nil then
			local resp = NewCommand("RoleForbidTalk")
			resp.begintime = forbidinfo._begintime
			resp.time = forbidinfo._time
			resp.notifytouser = forbidinfo._notifytouser
			player:SendToClient(SerializeCommand(resp))
			player:Log("OnCommand_PublicChat, Forbid Talk")
			return
		end
		--实现1:
		--player:SendMessageToAllRole(SerializeMessage(msg))
		--实现2:
		--chat_info._chat_index = chat_info._chat_index + 1
		--local index = chat_info._chat_index
		--local chat_data = CACHE.ChatData()
		--chat_data._src._id = role._roledata._base._id
		--chat_data._src._name = role._roledata._base._name
		--chat_data._src._photo = role._roledata._base._photo
		--chat_data._src._level = role._roledata._status._level
		--chat_data._src._mafia_id = role._roledata._mafia._id
		--chat_data._src._mafia_name = role._roledata._mafia._name
		--chat_data._src._photo_frame = role._roledata._base._photo_frame
		--chat_data._src._badge_map = role._roledata._base._badge_map
		--chat_data._time = API_GetTime()
		--chat_data._text_content = arg.text_content
		--chat_data._speech_content = arg.speech_content
		--chat_data._channel = arg.channel
		--chat_data._chat_typ = arg.typ
		--chat_info._chat_data:Insert(index, chat_data)
		--实现3:
		--others.global_message:Put(SerializeMessage(msg))
		--实现4:
		local cmd = NewCommand("PublicChat")
		cmd.src = ROLE_MakeRoleBrief(role)
		cmd.text_content = arg.text_content
		if arg.speech_content ~= nil then
			cmd.speech_content = arg.speech_content
		end
		cmd.time = API_GetTime()
		cmd.typ = arg.typ
		cmd.channel = arg.channel
		player:SendCommandToAllRole(SerializeCommand(cmd), G_CHECKSUM_C["PublicChat"])

		--数据统计日志
		local date = os.date("%Y-%m-%d %H:%M:%S")
		role._roledata._status._login_time = API_GetTime()
		player:BILog("{\"logtime\":\""..date.."\",\"logname\":\"player_feedback\",\"groupname\":\""..API_GetZoneId().."\",\"os\":\""
			..role._roledata._device_info._os.."\",\"platform\":\"".."laohu".."\",\"userid\":\""..role._roledata._status._account..
			"\",\"account\":\""..role._roledata._status._account.."\",\"roleid\":\""..role._roledata._base._id:ToStr()..
			"\",\"rolename\":\""..role._roledata._base._name.."\",\"lev\":\""..role._roledata._status._level.."\",\"totalcash\":\""
			.."0".."\",\"msg\":\""..arg.text_content.."\"}")

		--API:SendCommandToAllRole(SerializeCommand(cmd))
	elseif arg.channel == 3 then
		if role._roledata._mafia._id:ToStr() ~= "0" or role._roledata._mafia._name ~= "" then
			local mafia_msg = NewMessage("MafiaChat")
			mafia_msg.src = msg.src
			mafia_msg.text_content = msg.text_content
			mafia_msg.channel = msg.channel
			mafia_msg.speech_content = msg.speech_content
			mafia_msg.time = msg.time
			mafia_msg.chat_typ = msg.chat_typ
			API_SendMessage(role._roledata._mafia._id, SerializeMessage(mafia_msg), CACHE.Int64List(), CACHE.Int64List(), CACHE.IntList())
		end
	end
end

--Convert Bytes to hex string
function PrintSpeech(bytes)
	print("*********************************************\n")
	local wwwww = ''
	print("bytes len = "..string.len(bytes))
	for i = 1, string.len(bytes) do
		local charcode = tonumber(string.byte(bytes,i,i));
		local hexstr = string.format("%02X",charcode);
		wwwww = wwwww..hexstr
	end
	print(wwwww);
	print("*********************************************\n")
end

