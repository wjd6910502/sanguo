function OnMessage_MafiaDeleteTopList(arg, others)
	API_Log("OnMessage_MafiaDeleteTopList, "..DumpTable(arg))

	--ɾ��ĳһ�����а�
	if arg.id >= 1000 then
		others.toplist._data._top_data:Delete(arg.id)
	end
end
