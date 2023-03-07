function OnCommand_GetLastHero(player, role, arg, others)
	player:Log("OnCommand_GetLastHero, "..DumpTable(arg).." "..DumpTable(others))

	--发送给客户端
	local tmp_resp = NewCommand("GetLastHero_Re")
	tmp_resp.info = {}
	local last_hero = role._roledata._status._last_hero
	local lit = last_hero:SeekToBegin()
	local l = lit:GetValue()
	while l ~= nil do
		tmp_resp.info[#tmp_resp.info+1] = l._value
		lit:Next()
		l = lit:GetValue()
	end
	player:SendToClient(SerializeCommand(tmp_resp))
end
