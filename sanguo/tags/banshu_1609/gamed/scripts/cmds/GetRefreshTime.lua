function OnCommand_GetRefreshTime(player, role, arg, others)
	player:Log("OnCommand_GetRefreshTime, "..DumpTable(arg).." "..DumpTable(others))
	
	-- type = ³é½±Ä£°åid 
	local resp = NewCommand("GetRefreshTime_Re")	 
	resp.typ = arg.typ
	
	local last_time = 0
	local now = API_GetTime()
	
	local time_map = role._roledata._status._last_lotterytime
	
	local find_time = time_map:Find(arg.typ)
	
	if find_time == nil then
		local now_s = CACHE.Int()
		now_s._value = 0
		time_map:Insert(arg.typ,now_s)
		resp.last_refreshtime = 0
	else		
		resp.last_refreshtime = find_time._value 
	end
	
	player:SendToClient(SerializeCommand(resp)) 
			 
end
