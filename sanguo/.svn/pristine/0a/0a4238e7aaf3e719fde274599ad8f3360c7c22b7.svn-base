function OnCommand_BattleFieldMove(player, role, arg, others)
	player:Log("OnCommand_BattleFieldMove, "..DumpTable(arg).." "..DumpTable(others))

	local resp = NewCommand("BattleFieldMove_Re")
	resp.battle_id = arg.battle_id
	resp.src_id = arg.src_id
	resp.dst_id = arg.dst_id
	resp.dst_position = arg.dst_position

	--基本信息的判断
	local battle = role._roledata._battle_info:Find(arg.battle_id)
	if battle == nil then
		--直接给客户端返回，认为这个不存在
		resp.retcode = G_ERRCODE["BATTLE_ID_NOT_EXIST"]
		player:SendToClient(SerializeCommand(resp))
		return
	end

	--判断是否回合数结束了
	if battle._round_flag ~= 0 then
		if battle._round_num > battle._round_flag then
			return
		end
	end
	
	if battle._state == 0 then
		--战役还没有开始
		resp.retcode = G_ERRCODE["BATTLE_NOT_BEGIN"]
		player:SendToClient(SerializeCommand(resp))
		return
	elseif battle._state == 2 then
		resp.retcode = G_ERRCODE["BATTLE_HAVE_END"]
		player:SendToClient(SerializeCommand(resp))
		return
	end

	if battle._cur_position ~= arg.src_position then
		--直接给客户端返回，认为这个不存在
		resp.retcode = G_ERRCODE["BATTLE_MOVE_SRC_ERR"]
		player:SendToClient(SerializeCommand(resp))
		return
	end

	local cur_position_info = battle._position_info:Find(battle._cur_position)
	local cur_id = cur_position_info._id

	--判断当前格子是否属于自己，是的话才可以移动
	if cur_position_info._flag ~= 1 then
		resp.retcode = G_ERRCODE["BATTLE_MOVE_SRC_ERR"]
		player:SendToClient(SerializeCommand(resp))
		return
	end

	local ed = DataPool_Find("elementdata")
	local battle_info = ed:FindBy("battle_id", arg.battle_id)
	local battlefielddata_info = ed:FindBy("battlefielddata_id", battle_info.battlefieldid)

	local received_flag = 0
	for slot in DataPool_Array(battlefielddata_info.init_slots) do
		if slot.id == cur_id then
			for near_pos in DataPool_Array(slot.nearpos) do
				if near_pos == arg.dst_position then
					received_flag = 1
					break
				end
			end
			break
		end
	end

	if received_flag ~= 1 then
		--直接给客户端返回，不可以到达这个位置
		resp.retcode = G_ERRCODE["BATTLE_MOVE_DST_ERR"]
		player:SendToClient(SerializeCommand(resp))
		return
	end
	
	battle._last_position = battle._cur_position
	battle._cur_position = arg.dst_position

	resp.retcode = G_ERRCODE["SUCCESS"]
	player:SendToClient(SerializeCommand(resp))

	return
end
