function OnCommand_PublicChat(player, role, arg, others)
	player:Log("OnCommand_PublicChat, "..DumpTable(arg))
	
	--���typeΪ1 �������� �ڶ�������Ϊ0 ��������
	if arg.typ == 1 then
		PrintSpeech(arg.speech_content)
		role:SendSpeechToSTT(0,0,arg.speech_content);
		return
	end

	--���ݳ���������
	if string.len(arg.text_content)>200 then return end

	----֪ͨĿ��
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
	msg.time = API_GetTime()
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
