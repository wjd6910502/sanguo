function OnCommand_WeaponEquip(player, role, arg, others)
	player:Log("OnCommand_WeaponEquip, "..DumpTable(arg).." "..DumpTable(others))

	local resp = NewCommand("WeaponEquip_Re")

	--��Ҫ�жϵ��������佫�ȼ��������Ƿ�ƥ�䣩
	local hero_info = role._roledata._hero_hall._heros:Find(arg.hero)

	if hero_info == nil then
		resp.retcode = G_ERRCODE["WEAPON_EQUIP_HERO_ERR"]
		player:SendToClient(SerializeCommand(resp))
		player:Log("OnCommand_WeaponEquip, error=WEAPON_EQUIP_HERO_ERR")
		return
	end

	--�ҵ���Ҫװ��������
	local weapon_items = role._roledata._backpack._weapon_items

	local weapon_item_it = weapon_items._weapon_items:SeekToBegin()
	local weapon_item = weapon_item_it:GetValue()
	while weapon_item ~= nil do
		if weapon_item._weapon_pro._tid == arg.weapon_id then
			
			local ed = DataPool_Find("elementdata")
			local item = ed:FindBy("item_id", weapon_item._base_item._tid)
			if item == nil or item.item_type ~= 7 or item.type_data1 == 0 then
				resp.retcode = G_ERRCODE["WEAPON_EQUIP_SYS_ERR"]
				player:SendToClient(SerializeCommand(resp))
				player:Log("OnCommand_WeaponEquip, error=WEAPON_EQUIP_SYS_ERR")
				return
			end

			local weapon_info = ed:FindBy("weapon_id", item.type_data1)
			
			if weapon_info == nil then
				resp.retcode = G_ERRCODE["WEAPON_EQUIP_SYS_ERR"]
				player:SendToClient(SerializeCommand(resp))
				player:Log("OnCommand_WeaponEquip, error=WEAPON_EQUIP_SYS_ERR")
				return
			end

			if weapon_info.wearlv > hero_info._level then
				resp.retcode = G_ERRCODE["WEAPON_EQUIP_LEVEL_LESS"]
				player:SendToClient(SerializeCommand(resp))
				player:Log("OnCommand_WeaponEquip, error=WEAPON_EQUIP_LEVEL_LESS")
				return
			end
			
			if weapon_info.ownerid ~= hero_info._tid then
				resp.retcode = G_ERRCODE["WEAPON_EQUIP_TYPE_ERR"]
				player:SendToClient(SerializeCommand(resp))
				player:Log("OnCommand_WeaponEquip, error=WEAPON_EQUIP_TYPE_ERR")
				return
			end
			
			hero_info._weapon_id = arg.weapon_id

			--�����佫��Ϣ���ͻ��˷���ȥ
			HERO_UpdateHeroInfo(role, arg.hero)

			resp.retcode = G_ERRCODE["SUCCESS"]
			resp.hero = arg.hero
			resp.weapon_id = arg.weapon_id
			player:SendToClient(SerializeCommand(resp))
			return
		end
		weapon_item_it:Next()
		weapon_item = weapon_item_it:GetValue()
	end

	resp.retcode = G_ERRCODE["WEAPON_EQUIP_NOT_EXIST"]
	player:SendToClient(SerializeCommand(resp))
	player:Log("OnCommand_WeaponEquip, error=WEAPON_EQUIP_NOT_EXIST")
	return
end