function OnMessage_TestMessage1(player, role, arg, others)
	--player:Log("OnMessage_TestMessage1, "..DumpTable(arg))

	local msg = NewMessage("TestMessage1")
	player:SendMessage(role._roledata._base._id, SerializeMessage(msg))

	--ThrowException()

	----²âÊÔdatapoolµÄ´úÂë
	--local ed = DataPool("elementdata")
	--local roles = ed.role
	--for r in DataPool_Array(roles) do
	--	local x1 = r.name
	--	local x2 = r.prefix
	--	local x3 = r.modelPath
	--	local x4 = r.soulID
	--end
end
