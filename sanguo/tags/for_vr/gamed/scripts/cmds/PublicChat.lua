function OnCommand_PublicChat(player, role, arg, others)
	player:Log("OnCommand_PublicChat, "..DumpTable(arg))
	
	--如果type为1 语音翻译 第二个参数为0 代表公聊
	if arg.typ == 1 then
		PrintSpeech(arg.speech_content)
		role:SendSpeechToSTT(0,0,arg.speech_content);
		return
	end

	--内容长度有限制
	if string.len(arg.text_content)>200 then return end

	----通知目标
	local msg = NewMessage("PublicChatnew")
	msg.id = role._roledata._base._id:ToStr()
	msg.name = role._roledata._base._name
	msg.photo = role._roledata._base._photo
	msg.level = role._roledata._status._level 
	msg.mafia_id = role._roledata._mafia._id:ToStr() 
	msg.mafia_name = role._roledata._mafia._name
	msg.text_content = arg.text_content
	if arg.speech_content ~= nil then
		msg.speech_content = arg.speech_content 
	end
	
	PrintSpeech(arg.speech_content)
	msg.time = arg.time		
	player:SendMessageToAllRole(SerializeMessage(msg))
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

