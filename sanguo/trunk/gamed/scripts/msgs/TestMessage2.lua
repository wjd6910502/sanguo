function OnMessage_TestMessage2(mafia, arg, others)
	API_Log("OnMessage_TestMessage2, "..DumpTable(arg).." "..DumpTable(others))
	API_Log("OnMessage_TestMessage2, "..mafia._data._id:ToStr())
end
