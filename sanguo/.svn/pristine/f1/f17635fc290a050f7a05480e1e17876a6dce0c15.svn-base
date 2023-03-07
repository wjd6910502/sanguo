function OnMessage_PublicChatnew(player, role, arg, others)
	--player:Log("OnMessage_PublicChatnew, "..DumpTable(arg).." "..DumpTable(others))
	
	--≈–∂œ «∑Ò‘⁄œﬂ
	--if role._roledata._status._online == 0 then
	--	return 
	--end

	local cmd = NewCommand("PublicChat")
	cmd.src = arg.src
	cmd.text_content = arg.text_content
	cmd.speech_content = arg.speech_content
	cmd.time = arg.time
	cmd.typ = arg.chat_typ
	cmd.channel = arg.channel
	player:SendToClient(SerializeCommand(cmd))
end
