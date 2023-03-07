function OnCommand_WeaponMakeActive(player, role, arg, others)
	player:Log("OnCommand_WeaponMakeActive, "..DumpTable(arg).." "..DumpTable(others))
	
	local resp = NewCommand("WeaponMakeActive_Re")
	resp.item_id = arg.item_id --item_id ÎäÆ÷±íid
	
	local ed = DataPool_Find("elementdata")
	local weapon = ed:FindBy("weapon_id", arg.item_id)
	if weapon == nil then
		resp.retcode = G_ERRCODE["WEAPON_EQUIP_SYS_ERR"]
		player:SendToClient(SerializeCommand(resp))
		player:Log("OnCommand_WeaponForge, error=WEAPON_EQUIP_SYS_ERR")
		return
	end	

	local data = role._roledata._make_data._weapon_active:Find(weapon.library_id)
	if data ~= nil then
		resp.retcode = G_ERRCODE["WEAPON_FORGE_ACTIVE"]
		player:SendToClient(SerializeCommand(resp))
		player:Log("OnCommand_WeaponMakeActive, error=WEAPON_FORGE_ACTIVE")
		return
	end

	data = role._roledata._make_data._weapon_not_active:Find(weapon.library_id)
	if data == nil then
		resp.retcode = G_ERRCODE["WEAPON_FORGE_NO_ACTIVE"]
		player:SendToClient(SerializeCommand(resp))
		player:Log("OnCommand_WeaponMakeActive, error=WEAPON_FORGE_NO_ACTIVE")
		return
	end

	local tmp = CACHE.Int()
	tmp._value = weapon.library_id
	role._roledata._make_data._weapon_active:Insert(weapon.library_id, tmp)
	role._roledata._make_data._weapon_not_active:Delete(weapon.library_id)

	role._roledata._make_data._exp = role._roledata._make_data._exp + weapon.library_collect_score
	
	resp.retcode = G_ERRCODE["SUCCESS"]
	resp.exp = role._roledata._make_data._exp
	player:SendToClient(SerializeCommand(resp))
end
