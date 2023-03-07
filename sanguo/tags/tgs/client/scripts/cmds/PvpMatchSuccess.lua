function OnCommand_PvpMatchSuccess(player, role, arg, others)
	API_Log("OnCommand_PvpMatchSuccess, "..DumpTable(arg).." "..DumpTable(others))

	g_Pvp["PvpMatchSuccess"] = arg
	----在这里需要发送同意的协议
	--local cmd2 = NewCommand("PvpEnter")
	--cmd2.index = arg.index
	--cmd2.flag = 1
	--API_SendGameProtocol(SerializeCommand(cmd2))
end
