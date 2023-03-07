function OnCommand_LegionDecomposeWuHun(player, role, arg, others)
	player:Log("OnCommand_LegionDecomposeWuHun, "..DumpTable(arg).." "..DumpTable(others))

	local resp = NewCommand("LegionDecomposeWuHun_Re")
	resp.item = arg.item

	if table.getn(arg.item) == 0 then
		resp.retcode = G_ERRCODE["LEGION_DECOMPOSE_ITEM"]
		player:SendToClient(SerializeCommand(resp))
		return
	end

	--�鿴��Ҫ�ֽ����Ʒ�Ƿ�����꣬�Լ������Ƿ��
	
	local ed = DataPool_Find("elementdata")
	for index = 1, table.getn(arg.item) do
		local item = ed:FindBy("item_id", arg.item[index].tid)

		if item == nil then
			resp.retcode = G_ERRCODE["LEGION_DECOMPOSE_ITEM_NOT_EXIST"]
			player:SendToClient(SerializeCommand(resp))
			return
		end

		if item.item_type ~= 11 then
			resp.retcode = G_ERRCODE["LEGION_DECOMPOSE_ITEM_NOT_WUHUN"]
			player:SendToClient(SerializeCommand(resp))
			return
		end
		
		if BACKPACK_HaveItem(role, arg.item[index].tid, arg.item[index].count) == false then
			resp.retcode = G_ERRCODE["LEGION_DECOMPOSE_ITEM_COUNT_LESS"]
			player:SendToClient(SerializeCommand(resp))
			return
		end
	end

	--���濪ʼ����Ʒ����ɾ����Ȼ�������ϻ��ǵ�����
	local all_hunpo = 0
	for index = 1, table.getn(arg.item) do
		local item = ed:FindBy("item_id", arg.item[index].tid)

		BACKPACK_DelItem(role, arg.item[index].tid, arg.item[index].count)

		all_hunpo = all_hunpo + item.type_data2*arg.item[index].count
	end

	--���ӻ�������
	ROLE_AddRep(role, 9, all_hunpo)
			
	resp.retcode = G_ERRCODE["SUCCESS"]
	resp.count = all_hunpo
	player:SendToClient(SerializeCommand(resp))
	return
end