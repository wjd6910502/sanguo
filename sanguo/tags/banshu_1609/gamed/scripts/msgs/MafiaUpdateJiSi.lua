function OnMessage_MafiaUpdateJiSi(player, role, arg, others)
	player:Log("OnMessage_MafiaUpdateJiSi, "..DumpTable(arg).." "..DumpTable(others))
	
	TASK_ChangeCondition(role, G_ACH_TYPE["MAFIA_JISI"], 0, arg.jisi)
end
