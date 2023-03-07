function OnMessage_RoleUpdateLevelTop(player, role, arg, others)
	player:Log("OnMessage_RoleUpdateLevelTop, "..DumpTable(arg).." "..DumpTable(others))

	--等级榜
	--TOP_InsertData(others.toplist._data._top_data, 1, role._roledata._base._id, role._roledata._status._level, 
	--		role._roledata._base._name, role._roledata._base._photo,
	--		role._roledata._base._photo_frame, role._roledata._base._badge_map,  role._roledata._status._level, 0, 0, 0)
	--PVP积分榜
	--local data = 0
	--if role._roledata._pvp_info._pvp_grade == 0 then
	--	--这里是为了在排行榜中做排列的时候，容易一些.
	--	--这里是做了一些假设的，假设玩家的传说分数不会低于10000
	--	data = role._roledata._pvp_info._cur_star + 10000
	--else
	--	for i = 25, role._roledata._pvp_info._pvp_grade + 1, -1 do
	--		local ed = DataPool_Find("elementdata")
	--		local ranking = ed:FindBy("ranking_id", i)
	--		data = data + ranking.ascending_order_star
	--	end
	--	data = data + role._roledata._pvp_info._cur_star
	--end
	--TOP_InsertData(others.toplist._data._top_data, 3, role._roledata._base._id, data, role._roledata._base._name, 
	--		role._roledata._base._photo, role._roledata._status._level, 0, 0, 0)
	----竞技榜
	--TOP_InsertData(others.toplist._data._top_data, 4, role._roledata._base._id, role._roledata._pve_arena_info._score, 
	--		role._roledata._base._name, role._roledata._base._photo, role._roledata._status._level, 0, 0, 0)
end
