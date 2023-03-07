function OnCommand_TowerSetArmyInfo(player, role, arg, others)
	player:Log("OnCommand_TowerSetArmyInfo, "..DumpTable(arg).." "..DumpTable(others))

	local ed = DataPool_Find("elementdata")
	local layer = role._roledata._tower_data._cur_layer
	if role._roledata._tower_data._difficulty == 2 then
		layer = layer + 100
	end
	local towerstage = ed:FindBy("tower_stage", layer)
    if towerstage == nil then
        return
    end

    if towerstage.stage_category ~= 1 then
        return
    end	

	local size = table.getn(arg.army_info)
	for i = 1, size do
		local tower_data = role._roledata._tower_data
		local datas = tower_data._cur_army_info:Find(tower_data._select_layer_difficulty)
		if datas ~= nil then
			local info_it = datas:SeekToBegin()
			local info = info_it:GetValue()
			while info ~= nil do
				if info._id == arg.army_info[i].id then
					info._hp = arg.army_info[i].hp
					info._anger = arg.army_info[i].anger
					info._alive_flag = arg.army_info[i].alive
					break
				end
				info_it:Next()
				info = info_it:GetValue()
			end
		end
	end
end
