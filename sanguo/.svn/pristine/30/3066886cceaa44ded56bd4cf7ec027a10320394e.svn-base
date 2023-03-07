function OnCommand_WeaponMakeGetInfo(player, role, arg, others)
	player:Log("OnCommand_WeaponMakeGetInfo, "..DumpTable(arg).." "..DumpTable(others))
	local resp = NewCommand("WeaponMakeGetInfo_Re")
	
	resp.num = role._roledata._make_data._num
	resp.time = role._roledata._make_data._time
	resp.level = role._roledata._make_data._level
	resp.exp = role._roledata._make_data._exp
	resp.weapon_active = {}
	for s in Cache_Map(role._roledata._make_data._weapon_active) do
		resp.weapon_active[#resp.weapon_active + 1] = s
	end
	resp.weapon_not_active = {}
	for s in Cache_Map(role._roledata._make_data._weapon_not_active) do
		resp.weapon_not_active[#resp.weapon_not_active + 1] = s
	end
	
	player:SendToClient(SerializeCommand(resp))
end	
