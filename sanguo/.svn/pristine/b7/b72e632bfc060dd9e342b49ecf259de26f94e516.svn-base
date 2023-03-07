function OnCommand_BuyHorse(player, role, arg, others)
	player:Log("OnCommand_BuyHorse, "..DumpTable(arg).." "..DumpTable(others))

	local tmp = CACHE.RoleHorse:new()
	tmp._tid = arg.tid
	role._roledata._horse_hall._horses:Insert(arg.tid,tmp)
	
	local resp = NewCommand("AddHorse")
	--hero_hall
	resp.horse = {}
	resp.horse.tid = arg.tid
	player:SendToClient(SerializeCommand(resp))
end
