function OnCommand_One_Level_Up(player, role, arg, others)
	player:Log("OnCommand_One_Level_Up, "..DumpTable(arg).." "..DumpTable(others))

	--����ͳ����־
	local source_id = G_SOURCE_TYP["HERO"]

	local resp = NewCommand("One_Level_Up_Re")

	local ed = DataPool_Find("elementdata")
	local item_count = table.getn(arg.item)
	if item_count == 0 then
		return
	end
	--���ȼ����Ʒ�ĺϷ��ԣ��Լ���������Ƿ����㹻����Ʒ
	local all_exp = 0
	for i = 1, item_count do
		local item_info = ed:FindBy("item_id", arg.item[i].tid)
		if item_info == nil then
			resp.retcode = G_ERRCODE["NO_ITEM"]
			player:SendToClient(SerializeCommand(resp))
			player:Log("OnCommand_One_Level_Up, error=NO_ITEM")
			return
		end

		if item_info.item_type ~= 1 then
			resp.retcode = G_ERRCODE["NOT_EXP_ITEM"]
			player:SendToClient(SerializeCommand(resp))
			player:Log("OnCommand_One_Level_Up, error=NOT_EXP_ITEM")
			return
		end

		if BACKPACK_HaveItem(role, arg.item[i].tid, arg.item[i].count) == false then
			resp.retcode = G_ERRCODE["ITEM_COUNT_LESS"]
			player:SendToClient(SerializeCommand(resp))
			player:Log("OnCommand_One_Level_Up, error=ITEM_COUNT_LESS")
			return
		end
		all_exp = all_exp + item_info.type_data1*arg.item[i].count
	end

	--�ߵ�����˵����Ʒ���ǺϷ����ˣ���ʼ�۳���Ʒ���Ҹ��佫���Ӿ��顣
	resp.retcode = HERO_AddExp(role, arg.hero_id, all_exp)
	if resp.retcode == G_ERRCODE["SUCCESS"] then
		for i = 1, item_count do
			BACKPACK_DelItem(role, arg.item[i].tid, arg.item[i].count, source_id)
		end
		HERO_UpdateHeroInfo(role, arg.hero_id)
	end
	player:SendToClient(SerializeCommand(resp))
	return
end