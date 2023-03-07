function OnCommand_LegionJunXueZhuanJingLevelUp(player, role, arg, others)
	player:Log("OnCommand_LegionJunXueZhuanJingLevelUp, "..DumpTable(arg).." "..DumpTable(others))

	local resp = NewCommand("LegionJunXueZhuanJingLevelUp_Re")
	resp.retcode = G_ERRCODE["SUCCESS"]
	resp.id = arg.id

	local ed = DataPool_Find("elementdata")
	local legion_spec_info = ed:FindBy("legionspec_id", arg.id)
	if legion_spec_info == nil then
		resp.retcode = G_ERRCODE["SYSTEM_DATA_ERR"]
		player:SendToClient(SerializeCommand(resp))
		return
	end

	local junxue_info = role._roledata._legion_info._junxueguan._junxueinfo:Find(arg.id)
	if junxue_info == nil then
		resp.retcode = G_ERRCODE["SYSTEM_DATA_ERR"]
		player:SendToClient(SerializeCommand(resp))
		return
	end

	--满级了，无法再进行升级了
	if junxue_info._level >= 300 then
		resp.retcode = G_ERRCODE["LEGION_SPEC_MAX_LEVEL"]
		player:SendToClient(SerializeCommand(resp))
		return
	end

	local success_flag = false
	local legion_spec_lv_info = ed:FindBy("legionspeclvup_lv", junxue_info._level)
	
	for lvup_info in DataPool_Array(legion_spec_lv_info.lvup_info) do
		if lvup_info.lvup_type == legion_spec_info.spec_lvup_type then
			success_flag = true
			--查看升级所需要的物品和军学经验是否足够
			if lvup_info.lvup_item_id ~= 0 and BACKPACK_HaveItem(role, lvup_info.lvup_item_id, lvup_info.lvup_item_num) == false then
				resp.retcode = G_ERRCODE["LEGION_SPEC_ITEM_LESS"]
				player:SendToClient(SerializeCommand(resp))
				return
			end
			if ROLE_CheckRep(role, 8, lvup_info.lvup_exp) == false then
				resp.retcode = G_ERRCODE["LEGION_SPEC_EXP_LESS"]
				player:SendToClient(SerializeCommand(resp))
				return
			end
		end
	end
	
	if success_flag == false then
		resp.retcode = G_ERRCODE["SYSTEM_DATA_ERR"]
		player:SendToClient(SerializeCommand(resp))
		return
	end
	
	--下面开始扣除物品
	for lvup_info in DataPool_Array(legion_spec_lv_info.lvup_info) do
		if lvup_info.lvup_type == legion_spec_info.spec_lvup_type then
			--查看升级所需要的物品和军学经验是否足够
			if lvup_info.lvup_item_id ~= 0 then
				BACKPACK_DelItem(role, lvup_info.lvup_item_id, lvup_info.lvup_item_num)
			end
			ROLE_SubRep(role, 8, lvup_info.lvup_exp)
		end
	end

	junxue_info._level = junxue_info._level + 1
	resp.level = junxue_info._level

	ROLE_UpdateZhanli(role)
	player:SendToClient(SerializeCommand(resp))
end
