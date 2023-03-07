function OnCommand_TongQueTaiJoin(player, role, arg, others)
	player:Log("OnCommand_TongQueTaiJoin, "..DumpTable(arg).." "..DumpTable(others))

	--在这里必须判断是否轮到这个玩家进行战斗.以及战斗的目标是否正确
	local dest_role1 = others.roles[arg.role_id1]
	local dest_role2 = others.roles[arg.role_id2]
	
	local tongquetai = others.tongquetai._data
	local match_data = tongquetai._match_data:Find(role._roledata._tongquetai_data._cur_tongquetai_id)

	--只有在这个状态下面才会收到这个协议
	if match_data._cur_state == 1 then
		local role_info_it = match_data._role_info:SeekToBegin()
		local index = 1
		local role_info = role_info_it:GetValue()
		while role_info ~= nil do
			if role_info._role_base._id:ToStr() == role._roledata._base._id:ToStr() then
				--在这里直接return,肯定是哪里出了问题的
				if index ~= match_data._cur_fight_role then
					return
				end
			end
			index = index + 1
			role_info_it:Next()
			role_info = role_info_it:GetValue()
		end

		match_data._cur_state = 2
		match_data._time = API_GetTime()

		local resp = NewCommand("TongQueTaiJoin_Re")
		resp.role_id = role._roledata._base._id:ToStr()
		resp.retcode = G_ERRCODE["SUCCESS"]

		role:SendToClient(SerializeCommand(resp))
		dest_role1:SendToClient(SerializeCommand(resp))
		dest_role2:SendToClient(SerializeCommand(resp))

		resp.seed = math.random(1000000) --TODO:
		role._roledata._status._fight_seed = resp.seed
		role._roledata._status._time_line = G_ROLE_STATE["TONGQUETAI"]
	end
end
