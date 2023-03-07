function OnCommand_TowerOpenBox(player, role, arg, others)
	player:Log("OnCommand_TowerOpenBox, "..DumpTable(arg).." "..DumpTable(others))
	local resp = NewCommand("TowerOpenBox_Re")
	if role._roledata._tower_data._cur_layer ~= arg.layer then
		resp.retcode = G_ERRCODE["TOWER_ERROR_LEVEL"]
		player:SendToClient(SerializeCommand(resp))
		player:Log("OnCommand_TowerOpenBox, error=TOWER_ERROR_LEVEL")
		return
	end

	--Êı¾İÍ³¼ÆÈÕÖ¾
	local source_id = G_SOURCE_TYP["TOWER"]

	local ed = DataPool_Find("elementdata")
	local layer = role._roledata._tower_data._cur_layer
	if role._roledata._tower_data._difficulty == 2 then
		layer = layer + 100 
	end
	local towerstage = ed:FindBy("tower_stage", layer)
	if towerstage == nil then
		resp.retcode = G_ERRCODE["TOWER_ERROR_DATA"]
		player:SendToClient(SerializeCommand(resp))
		player:Log("OnCommand_TowerOpenBox, error=TOWER_ERROR_DATA")
		return
	end	
	
	if towerstage.stage_category ~= 2 and towerstage.stage_category~= 4 then --4ä¸ºç‰¹æ®Šå®ç®±
		resp.retcode = G_ERRCODE["TOWER_ERROR_TYPE"]
		player:SendToClient(SerializeCommand(resp))
		player:Log("OnCommand_TowerOpenBox, error=TOWER_ERROR_TYPE")
		return
	end

	local box_info = role._roledata._tower_data._box_info:Find(arg.layer)
	if box_info ~= nil then
		if box_info._get_flag ~= 0 then
			resp.retcode = G_ERRCODE["TOWER_ERROR_GET_BOX"]
			player:SendToClient(SerializeCommand(resp))
			player:Log("OnCommand_TowerOpenBox, error=TOWER_ERROR_GET_BOX")
			return
		end
	end
	resp.retcode = G_ERRCODE["SUCCESS"]
	resp.layer = role._roledata._tower_data._cur_layer
	resp.item = {}
--	local Reward = DROPITEM_DropItem(role, towerstage.drop_id)
--	if #Reward >= 1 then
--		for i = 1, #Reward do
--			if Reward[i] ~= nil then
--				local reward_info = {}
--				reward_info.tid = Reward[i].id
--				reward_info.count = Reward[i].count
--				resp.item[#resp.item+1] = reward_info
--				BACKPACK_AddItem(role, reward_info.tid, reward_info.count, source_id)
--			end
--		end
--	end
	
	local reward_id = 0
	local size = 0
	for id in DataPool_Array(towerstage.drop_infos) do
		size = size + 1
	end

	for i = 1, size do
		if role._roledata._tower_data._reward_star >= towerstage.min_star[i] and role._roledata._tower_data._reward_star <= towerstage.max_star[i] then
			reward_id = towerstage.drop_infos[i]
			break
		end
	end

	if reward_id ~= 0 then
		local Reward = DROPITEM_Reward(role, reward_id)
		ROLE_AddReward(role, Reward, source_id)
		
		local item_count = table.getn(Reward.item)
		for i = 1, item_count do
			local reward_info = {}
			reward_info.tid = Reward.item[i].itemid
			reward_info.count = Reward.item[i].itemnum
			resp.item[#resp.item+1] = reward_info
		end
	end
	

	role._roledata._tower_data._reward_star = 0
	local tmp = CACHE.TowerBoxInfo()
	tmp._layer = role._roledata._tower_data._cur_layer
	tmp._get_flag = 1
	role._roledata._tower_data._box_info:Insert(tmp._layer, tmp)
	
	local quanju = ed.gamedefine[1]
	local max_layer = 60
	if role._roledata._tower_data._difficult == 1 then
		max_layer = quanju.tower1_count
	elseif role._roledata._tower_data._difficult == 2 then
		max_layer = quanju.tower2_count
	end

	if role._roledata._tower_data._cur_layer < max_layer then
		role._roledata._tower_data._cur_layer = role._roledata._tower_data._cur_layer + 1
	end

	player:SendToClient(SerializeCommand(resp))
end
