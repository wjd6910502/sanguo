function OnCommand_SkinBuy(player, role, arg, others)
	player:Log("OnCommand_SkinBuy, "..DumpTable(arg).." "..DumpTable(others))

	local resp = NewCommand("SkinBuy_Re")
	resp.typ = arg.typ
	resp.skinid = arg.skinid

	--�鿴����Ƿ��Ѿ��������Ƥ��
	--�鿴�Ƿ�����Ӧ���佫
	--�鿴���Ƥ���Ƿ����ʹ�������ʽ����
	--�鿴�������Ƥ������Ҫ����Ʒ�Ƿ��㹻
	local skin_info = role._roledata._backpack._skin_items:Find(arg.skinid)
	if skin_info ~= nil then
		if skin_info._time == 0 then
			resp.retcode = G_ERRCODE["SKIN_BUY_HAVE"]
			player:SendToClient(SerializeCommand(resp))
			return
		end
	end
	
	local ed = DataPool_Find("elementdata")
	local dress_info = ed:FindBy("dress_id", arg.skinid)
	--�ж�����佫�Ƿ����
	local hero_info = role._roledata._hero_hall._heros:Find(dress_info.owner_id)
	if hero_info == nil then
		resp.retcode = G_ERRCODE["SKIN_BUY_NO_HERO"]
		player:SendToClient(SerializeCommand(resp))
		return
	end

	if arg.typ == 1 then
		if dress_info.price_yuanbao == 0 then
			resp.retcode = G_ERRCODE["SKIN_BUY_CAN_NOT_YUANBAO"]
			player:SendToClient(SerializeCommand(resp))
			return
		end
		
		if dress_info.price_yuanbao > role._roledata._status._yuanbao then
			resp.retcode = G_ERRCODE["YUANBAO_LESS"]
			player:SendToClient(SerializeCommand(resp))
			return
		end
		
		ROLE_SubYuanBao(role, dress_info.price_yuanbao)
		if skin_info == nil then
			local insert_info = CACHE.SkinInfo()
			insert_info._id = arg.skinid
			insert_info._time = 0
			role._roledata._backpack._skin_items:Insert(arg.skinid, insert_info)

			hero_info._skin = arg.skinid
		else
			skin_info._time = 0
		end
		resp.retcode = G_ERRCODE["SUCCESS"]
		player:SendToClient(SerializeCommand(resp))

		local cmd = NewCommand("SkinUpdateInfo")
		cmd.addflag = 1
		cmd.skinid = arg.skinid
		cmd.time = 0
		cmd.item = {}
		player:SendToClient(SerializeCommand(cmd))
	else
		if dress_info.convert_item_num == 0 or dress_info.convert_item_id == 0 then
			resp.retcode = G_ERRCODE["SKIN_BUY_CAN_NOT_ITEM"]
			player:SendToClient(SerializeCommand(resp))
			return
		end

		if BACKPACK_DelItem(role, dress_info.convert_item_id, dress_info.convert_item_num) == false then
			resp.retcode = G_ERRCODE["SKIN_BUY_ITEM_LESS"]
			player:SendToClient(SerializeCommand(resp))
			return
		end
	
		if skin_info == nil then
			local insert_info = CACHE.SkinInfo()
			insert_info._id = arg.skinid
			insert_info._time = 0
			role._roledata._backpack._skin_items:Insert(arg.skinid, insert_info)
		else
			skin_info._time = 0
		end
		resp.retcode = G_ERRCODE["SUCCESS"]
		player:SendToClient(SerializeCommand(resp))

		local cmd = NewCommand("SkinUpdateInfo")
		cmd.addflag = 1
		cmd.skinid = arg.skinid
		cmd.time = 0
		cmd.item = {}
		player:SendToClient(SerializeCommand(cmd))
	end
end