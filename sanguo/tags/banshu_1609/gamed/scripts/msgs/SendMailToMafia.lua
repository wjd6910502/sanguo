function OnMessage_SendMailToMafia(mafia, arg, others)
	API_Log("OnMessage_SendMailToMafia, "..DumpTable(arg).." "..DumpTable(others))
	
	local mafia_info = mafia._data

	MAFIA_MafiaSendMail(mafia_info, arg.mail_id)
end
