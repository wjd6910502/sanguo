function OnMessage_TestMessage4(playermap, arg)
	--API_Log("OnMessage_TestMessage4, "..DumpTable(arg))

	s = ""

	local it = playermap:SeekToBegin()
	local r = it:GetValue()
	while r~=nil do
		s = s.." "..r._roledata._base._name
		r._roledata._status._pvp_video:Clear()
		it:Next()
		r = it:GetValue()
	end

	for m in Cache_Map(API_Mafia_GetMap()) do
		API_Log(m._data._name)
		s = s.." "..m._data._name
	end

	API_Log(s)
end
