

--Ä£Äâ³éÎä½«
function TestKeJin()
	API_Log("!!!!!!----TestKeJin")
	Init()	
	Login()
	API_Log("!!!!!!----Login OK")
	Sleep(2)
	while true do
	
		local cmd1 = NewCommand("DebugCommand")
       		cmd1.typ = "AddYuanBao"
       		cmd1.count1 = 100000
       		API_SendGameProtocol(SerializeCommand(cmd1))
		API_Log("!!!!!!----Add Yuanbao Send OK")
		Sleep(2)

		local cmd2 = NewCommand("Lottery")
		cmd2.lottery_id = 42589
		cmd2.cost_type = 2
		API_SendGameProtocol(SerializeCommand(cmd2))
		
		API_Log("!!!!!!----Ke 42589 Send OK")
		Sleep(2)
	
	
		local cmd2 = NewCommand("Lottery")
		cmd2.lottery_id = 42589
		cmd2.cost_type = 2
		API_SendGameProtocol(SerializeCommand(cmd2))
		API_Log("!!!!!!----Ke 42589 Send OK")
		Sleep(2)
	
	
		local cmd2 = NewCommand("Lottery")
		cmd2.lottery_id = 42589
		cmd2.cost_type = 2
		API_SendGameProtocol(SerializeCommand(cmd2))
		API_Log("!!!!!!----Ke 42590 Send OK")
		Sleep(2)
	end
end
