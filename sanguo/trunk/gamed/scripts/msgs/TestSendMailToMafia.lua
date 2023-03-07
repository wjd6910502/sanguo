function OnMessage_TestSendMailToMafia(player, role, arg, others)
	player:Log("OnMessage_TestSendMailToMafia, "..DumpTable(arg).." "..DumpTable(others))	

	TOP_TestSendMail(others.toplist._data._top_data)
end
