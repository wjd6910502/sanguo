function OnMessage_TestMessage4(playermap, mafiamap, arg)
	API_Log("OnMessage_TestMessage4, "..DumpTable(arg))

	s = ""

	local it = playermap:SeekToBegin()
	local r = it:GetValue()
	while r~=nil do
		s = s.." "..r._base._name
		it:Next()
		r = it:GetValue()
	end

	it = mafiamap:SeekToBegin()
	local m = it:GetValue()
	while m~=nil do
		s = s.." "..m._name
		it:Next()
		m = it:GetValue()
	end

	API_Log(s)
end
