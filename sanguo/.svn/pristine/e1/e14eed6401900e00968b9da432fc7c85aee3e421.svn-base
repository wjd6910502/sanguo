function OnMessage_PublicChat(player, role, arg, others)
	--player:Log("OnMessage_PublicChat, "..DumpTable(arg))	
	local cmd = NewCommand("PublicChat") 
	cmd.src = arg.src
	cmd.text_content = arg.text_content
	cmd.speech_content = arg.speech_content
	cmd.time = arg.time	
    player:SendToClient(SerializeCommand(cmd))
end
