function OnCommand_TowerSelectDifficulty(player, role, arg, others)
	player:Log("OnCommand_TowerSelectDifficulty, "..DumpTable(arg).." "..DumpTable(others))
	
	local resp = NewCommand("TowerSelectDifficulty_Re")
	local ed = DataPool_Find("elementdata")
	local quanju = ed.gamedefine[1]

    if role._roledata._tower_data._difficulty ~= 0 then
        resp.retcode = G_ERRCODE["TOWER_ERROR_SELECTED"]
        player:SendToClient(SerializeCommand(resp))
		player:Log("OnCommand_TowerSelectDifficulty, error=TOWER_ERROR_SELECTED")
        return
    end

	if arg.difficulty == 1 then
		if role._roledata._status._level >= quanju.tower2_open_level or role._roledata._status._level < quanju.tower1_open_level then
			resp.retcode = G_ERRCODE["TOWER_ERROR_LEVEL"]
			player:SendToClient(SerializeCommand(resp))
			player:Log("OnCommand_TowerSelectDifficulty, error=TOWER_ERROR_LEVEL")
			return
		end
	elseif arg.difficulty == 2 then
		if role._roledata._status._level < quanju.tower2_open_level then
			resp.retcode = G_ERRCODE["TOWER_ERROR_LEVEL"]
			player:SendToClient(SerializeCommand(resp))
			player:Log("OnCommand_TowerSelectDifficulty, error=TOWER_ERROR_LEVEL")
			return
		end
	else
		resp.retcode = G_ERRCODE["TOWER_ERROR_ARG"]
		player:SendToClient(SerializeCommand(resp))
		player:Log("OnCommand_TowerSelectDifficulty, error=TOWER_ERROR_ARG")
		return
	end
	
	resp.retcode = G_ERRCODE["SUCCESS"]
	role._roledata._tower_data._difficulty = arg.difficulty
	resp.difficulty = role._roledata._tower_data._difficulty
	if role._roledata._tower_data._cur_layer == 0 then
		role._roledata._tower_data._cur_layer = 1
	end
	resp.layer = role._roledata._tower_data._cur_layer	

	player:SendToClient(SerializeCommand(resp))
end
