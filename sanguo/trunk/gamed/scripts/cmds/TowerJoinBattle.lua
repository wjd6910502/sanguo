function OnCommand_TowerJoinBattle(player, role, arg, others)
	player:Log("OnCommand_TowerJoinBattle, "..DumpTable(arg).." "..DumpTable(others))

	
	local resp = NewCommand("TowerJoinBattle_Re")
	
	if #arg.hero < 1 then
        resp.retcode = G_ERRCODE["TOWER_HERO_NOT_SELECTED"]
        player:SendToClient(SerializeCommand(resp))
		player:Log("OnCommand_TowerJoinBattle, error=TOWER_HERO_NOT_SELECTED")
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
		player:Log("OnCommand_TowerJoinBattle, error=TOWER_ERROR_DATA")
		return
	end
	
	if towerstage.stage_category ~= 1 then
		resp.retcode = G_ERRCODE["TOWER_ERROR_TYPE"]
		player:SendToClient(SerializeCommand(resp))
		player:Log("OnCommand_TowerJoinBattle, error=TOWER_ERROR_TYPE")
		return
	end

	local tower_data = role._roledata._tower_data
	if tower_data._cur_army_info:Size() == 0 or tower_data._cur_army_info:Find(tower_data._select_layer_difficulty):Size() == 0 then
		resp.retcode = G_ERRCODE["TOWER_ERROR_ATTACK_ARMY_INFO"]
		player:SendToClient(SerializeCommand(resp))
		player:Log("OnCommand_TowerJoinBattle, error=TOWER_ERROR_ATTACK_ARMY_INFO")
		return
	end
	
	for i = 1, #arg.hero do
		local hero_id = arg.hero[i]
		local f = role._roledata._hero_hall._heros:Find(hero_id)
		if f == nil then
			resp.restcode = G_ERRCODE["TOWER_PARAM_HERO_NOT_EXIST"]
			player:SendToClient(SerializeCommand(resp))
			player:Log("OnCommand_TowerJoinBattle, error=TOWER_PARAM_HERO_NOT_EXIST")
			return
		end

		local s = role._roledata._tower_data._dead_hero:Find(hero_id)
		if s ~= nil then
			resp.retcode = G_ERRCODE["TOWER_PARAM_HERO_DEAD"]
			player:SendToClient(SerializeCommand(resp))
			player:Log("OnCommand_TowerJoinBattle, error=TOWER_PARAM_HERO_DEAD")
			return
		end
	end

	resp.retcode = G_ERRCODE["SUCCESS"]
	resp.layer = role._roledata._tower_data._cur_layer

--	resp.seed = math.random(1000000) --TODO:
    role._roledata._status._fight_seed = math.random(1000000)
    role._roledata._status._time_line = G_ROLE_STATE["TOWER"]
	player:SendToClient(SerializeCommand(resp))
end
