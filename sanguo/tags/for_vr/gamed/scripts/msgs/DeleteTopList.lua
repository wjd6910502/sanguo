function OnMessage_DeleteTopList(arg, others)
	API_Log("OnMessage_DeleteTopList, "..DumpTable(arg))

	TOP_DeleteTop(others.toplist._top_manager,arg.id)
end
