function OnCommand_BattleFieldGetPrize(player, role, arg, others)
	player:Log("OnCommand_BattleFieldGetPrize, "..DumpTable(arg).." "..DumpTable(others))
	
	local battle = role._roledata._battle_info:Find(arg.battle_id)

	if battle == nil then
		return
	end

	if battle._state ~= 2 then
		return
	end

	local resp = NewCommand("BattleFieldGetPrize_Re")
	resp.retcode = G_ERRCODE["SUCCESS"]
	resp.battle_id = arg.battle_id
	local ed = DataPool_Find("elementdata")
	local battle_info = ed:FindBy("battle_id", arg.battle_id)
	local Item = DROPITEM_DropItem(role, battle_info.reward_mould_id)
	local instance_info = {}
	instance_info.exp = 0
	instance_info.heroexp = 0
	instance_info.item = {}
	for i = 1, table.getn(Item) do
		local instance_item = {}
		local have_flag = 1
		for j = 1, #instance_info.item do
			if instance_info.item[j].id == Item[i].id then
				instance_info.item[j].count = instance_info.item[j].count + Item[i].count
				have_flag = 0
				break
			end
		end
		
		instance_item.id = Item[i].id
		instance_item.count = Item[i].count
		if have_flag == 1 then
			instance_info.item[#instance_info.item+1] = instance_item
		end
		BACKPACK_AddItem(role, instance_item.id, instance_item.count)
	end
	resp.rewards = instance_info
	player:SendToClient(SerializeCommand(resp))

	--把这个战役删除掉
	if role._roledata._status._cur_battle_id == arg.battle_id then
		role._roledata._status._cur_battle_id = 0
	end
	
	role._roledata._battle_info:Delete(arg.battle_id)
end
