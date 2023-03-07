function OnCommand_WeaponMakeGetStone(player, role, arg, others)
	player:Log("OnCommand_WeaponMakeGetStone, "..DumpTable(arg).." "..DumpTable(others))

	local resp = NewCommand("WeaponMakeGetStone_Re")
	local now = API_GetTime()
	if role._roledata._make_data._time ~= 0 and now < role._roledata._make_data._time then --==0上来就可以领一次
		resp.retcode = G_ERRCODE["WEAPON_FORGE_TIME"]
		player:SendToClient(SerializeCommand(resp))
		player:Log("OnCommand_WeaponMake, error=WEAPON_FORGE_TIME")
		return
	end

	local ed = DataPool_Find("elementdata")
	local quanju = ed.gamedefine[1]
	BACKPACK_AddItem(role, quanju.weapon_forge_supply_id, quanju.weapon_forge_supply_num, 0)
	role._roledata._make_data._time = now + quanju.weapon_forge_supply_cycle*3600
	
	resp.time = role._roledata._make_data._time
	player:SendToClient(SerializeCommand(resp))	
end
