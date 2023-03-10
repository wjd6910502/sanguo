function OnCommand_One_Level_Up(player, role, arg, others)
	player:Log("OnCommand_One_Level_Up, "..DumpTable(arg).." "..DumpTable(others))

	local resp = NewCommand("One_Level_Up_Re")

	local ed = DataPool_Find("elementdata")
	local item_count = table.getn(arg.item)
	if item_count == 0 then
		return
	end
	--首先检查物品的合法性，以及玩家身上是否有足够的物品
	local all_exp = 0
	for i = 1, item_count do
		local item_info = ed:FindBy("item_id", arg.item[i].tid)
		if item_info == nil then
			resp.retcode = G_ERRCODE["NO_ITEM"]
			player:SendToClient(SerializeCommand(resp))
			return
		end

		if item_info.item_type ~= 1 then
			resp.retcode = G_ERRCODE["NOT_EXP_ITEM"]
			player:SendToClient(SerializeCommand(resp))
			return
		end

		if BACKPACK_HaveItem(role, arg.item[i].tid, arg.item[i].count) == false then
			resp.retcode = G_ERRCODE["ITEM_COUNT_LESS"]
			player:SendToClient(SerializeCommand(resp))
			return
		end
		all_exp = all_exp + item_info.type_data1*arg.item[i].count
	end

	--走到这里说明物品都是合法的了，开始扣除物品并且给武将添加经验。
	resp.retcode = HERO_AddExp(role, arg.hero_id, all_exp)
	if resp.retcode == G_ERRCODE["SUCCESS"] then
		for i = 1, item_count do
			BACKPACK_DelItem(role, arg.item[i].tid, arg.item[i].count)
		end
	end
	player:SendToClient(SerializeCommand(resp))
	return
end
