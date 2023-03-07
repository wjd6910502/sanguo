function OnCommand_TowerSelectArmyInfo(player, role, arg, others)
	player:Log("OnCommand_TowerSelectArmyInfo, "..DumpTable(arg).." "..DumpTable(others))

	local resp = NewCommand("TowerSelectArmyInfo_Re")
	if arg.difficulty ~= 1 and arg.difficulty ~= 2 and arg.difficulty ~= 3 then
		resp.retcode = G_ERRCODE["TOWER_ERROR_ARG"]
		player:SendToClient(SerializeCommand(resp))
		player:Log("OnCommand_TowerSelectArmyInfo, error=TOWER_ERROR_ARG")
		return
	end

	if role._roledata._tower_data._select_layer_difficulty ~= 0 then
		resp.retcode = G_ERRCODE["TOWER_ERROR_ARMY_SELECTED"]
		player:SendToClient(SerializeCommand(resp))
		player:Log("OnCommand_TowerSelectArmyInfo, error=TOWER_ERROR_ARMY_SELECTED")
		return
	end	

	local ed = DataPool_Find("elementdata")
	local layer = role._roledata._tower_data._cur_layer
	if role._roledata._tower_data._difficulty == 2 then
		layer = layer + 100
	end
	local towerstage = ed:FindBy("tower_stage", layer)
	if towerstage == nil then
		resp.retcode = G_ERRCODE["TOWER_ERROR_DATA"]
		player:SendToClient(SerializeCommand(resp))
		player:Log("OnCommand_TowerSelectArmyInfo, error=TOWER_ERROR_DATA")
		return
	end

	if towerstage.stage_category ~= 1 then
		resp.retcode = G_ERRCODE["TOWER_ERROR_TYPE"]
		player:SendToClient(SerializeCommand(resp))
		player:Log("OnCommand_TowerSelectArmyInfo, error=TOWER_ERROR_TYPE")
		return
	end

	local army_info = role._roledata._tower_data._cur_army_info
	if army_info:Size() == 0 or army_info:Find(arg.difficulty) == nil then
		resp.retcode = G_ERRCODE["TOWER_ERROR_ATTACK_ARMY_INFO"]
		player:SendToClient(SerializeCommand(resp))
		player:Log("OnCommand_TowerSelectArmyInfo, error=TOWER_ERROR_ATTACK_ARMY_INFO")
		return
	end

	role._roledata._tower_data._select_layer_difficulty = arg.difficulty
	resp.difficulty = role._roledata._tower_data._select_layer_difficulty

	if role._roledata._tower_data._select_layer_difficulty ~= 3 then
		role._roledata._tower_data._win_flag = 0
	end

	resp.retcode = G_ERRCODE["SUCCESS"]
	player:SendToClient(SerializeCommand(resp))
end
