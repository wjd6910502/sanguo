function OnCommand_MaShuGetBuff(player, role, arg, others)
	player:Log("OnCommand_MaShuGetBuff, "..DumpTable(arg).." "..DumpTable(others))

	--����ͳ����־
	local source_id = G_SOURCE_TYP["MASHU"]

	local resp = NewCommand("MaShuGetBuff_Re")
	resp.id = arg.id
	resp.retcode = G_ERRCODE["SUCCESS"]

	local ed = DataPool_Find("elementdata")
	local buff_info = ed:FindBy("buff_id", arg.id)

	if buff_info == nil then
		resp.retcode = G_ERRCODE["SYSTEM_DATA_ERR"]
		player:SendToClient(SerializeCommand(resp))
		player:Log("OnCommand_MaShuGetBuff, error=SYSTEM_DATA_ERR")
		return
	end

	--�鿴��������Ƿ��Ѿ�����BUFF��������˵Ļ����鿴���BUFF�Ƿ���Ե���
	local mashu_buff_map = role._roledata._mashu_info._buff
	local mashu_buff = mashu_buff_map:Find(arg.id)

	if mashu_buff == nil or (mashu_buff ~= nil and buff_info.if_repeat_buy == 1) then
		--�鿴���BUFF�Ƿ����ͨ��ʹ����Ʒ���
		local insert_buff_info = CACHE.MaShu_BuffInfo()
		insert_buff_info._id = arg.id
		local del_item_flag = false
		if buff_info.itemid ~= 0 then
			if BACKPACK_HaveItem(role, buff_info.itemid, 1) == true then
				BACKPACK_DelItem(role, buff_info.itemid, 1, source_id)
				del_item_flag = true
				insert_buff_info._typ = 1
			end
		end

		--�����￪ʼ����Ƿ���Ҫ��Ǯ
		if del_item_flag == false then
			if buff_info.cost_type == 1 then
				if role._roledata._status._money < buff_info.cost_num then
					resp.retcode = G_ERRCODE["MASHU_BUY_BUFF_MONEY_LESS"]
					player:SendToClient(SerializeCommand(resp))
					player:Log("OnCommand_MaShuGetBuff, error=MASHU_BUY_BUFF_MONEY_LESS")
					return
				end
				--��Ǯ
				ROLE_SubMoney(role, buff_info.cost_num, source_id)
			elseif buff_info.cost_type == 2 then
				if role._roledata._status._yuanbao < buff_info.cost_num then
					resp.retcode = G_ERRCODE["MASHU_BUY_BUFF_GOUYU_LESS"]
					player:SendToClient(SerializeCommand(resp))
					player:Log("OnCommand_MaShuGetBuff, error=MASHU_BUY_BUFF_GOUYU_LESS")
					return
				end
				ROLE_SubYuanBao(role, buff_info.cost_num, source_id)
			else
				resp.retcode = G_ERRCODE["SYSTEM_DATA_ERR"]
			end
			insert_buff_info._typ = 2
		end
		--��ʼ���BUFF��
		local all_buff = {}
		for buff_effect in DataPool_Array(buff_info.buff_effect) do
			if buff_effect.buff_id ~= 0 then
				all_buff[#all_buff+1] = buff_effect.buff_id
			else
				break
			end
		end

		if table.getn(all_buff) == 0 then
			insert_buff_info._buff_id = 0
		else
			local random_num = math.random(1, table.getn(all_buff))
			insert_buff_info._buff_id = all_buff[random_num]
		end
		mashu_buff_map:Insert(arg.id, insert_buff_info)

		resp.buff_info = {}
		resp.buff_info.id = insert_buff_info._id
		resp.buff_info.buffer_id = insert_buff_info._buff_id
		resp.buff_info.typ = insert_buff_info._typ
		player:SendToClient(SerializeCommand(resp))
		return
	else
		resp.retcode = G_ERRCODE["MASHU_BUY_BUFF_HAVE_BUFF"]
		player:SendToClient(SerializeCommand(resp))
		return
	end
end