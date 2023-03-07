function OnCommand_BattleFieldGetRoundStateInfo(player, role, arg, others)
	player:Log("OnCommand_BattleFieldGetRoundStateInfo, "..DumpTable(arg).." "..DumpTable(others))

	local resp = NewCommand("BattleFieldGetRoundStateInfo_Re")
	resp.battle_id = arg.battle_id
	resp.round_state = arg.round_state

	local battle = role._roledata._battle_info:Find(arg.battle_id)

	if battle == nil then
		resp.retcode = G_ERRCODE["BATTLE_ID_NOT_EXIST"]
		player:SendToClient(SerializeCommand(resp))
		player:Log("OnCommand_BattleFieldGetRoundStateInfo, error=BATTLE_ID_NOT_EXIST")
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
		player:Log("OnCommand_BattleFieldGetRoundStateInfo, error=BATTLE_NOT_BEGIN")
		return
	elseif battle._state == 2 then
		resp.retcode = G_ERRCODE["BATTLE_HAVE_END"]
		player:SendToClient(SerializeCommand(resp))
		player:Log("OnCommand_BattleFieldGetRoundStateInfo, error=BATTLE_HAVE_END")
		return
	end

	if battle._round_state ~= arg.round_state then
		resp.retcode = G_ERRCODE["BATTLEFIELD_ROUND_STATE_ERR"]
		player:Log("OnCommand_BattleFieldGetRoundStateInfo, error=BATTLEFIELD_ROUND_STATE_ERR")
		player:SendToClient(SerializeCommand(resp))
		return
	end

	local battle_round_state = 0
	if battle._round_state == 1 then
		--在这里开始调用策划写的回合事件的脚本
		--处理完以后修改状态
		battle_round_state = ROLE_BattleRoundEvent(role, battle)
		battle._round_state = 2
	elseif battle._round_state == 3 then
		--在这里开始调用策划写的NPC移动触发的事件
		--在这里处理完以后，需要把当前的回合数加1，判断是否有回合限制
		--然后修改当前状态状态，发送给客户端
		battle_round_state = ROLE_BattleRoundEvent(role, battle)
		battle._round_state = 1
		battle._round_num = battle._round_num + 1
	elseif battle._round_state == 2 then
		resp.retcode = G_ERRCODE["SUCCESS"]
		player:SendToClient(SerializeCommand(resp))
		return
	else
		resp.retcode = G_ERRCODE["BATTLEFIELD_ROUND_STATE_ERR"]
		player:SendToClient(SerializeCommand(resp))
		player:Log("OnCommand_BattleFieldGetRoundStateInfo, error=BATTLEFIELD_ROUND_STATE_ERR")
		return
	end

	--同步战役当前回合状态
	resp.event_info = {}
	resp.npc_info = {}

	resp.info_history = {}
	for index = 1, table.getn(battle_round_state.info_history) do
		local tmp = CACHE.Int()
		tmp._value = battle_round_state.info_history[index]
		battle._info_history:PushBack(tmp)
		resp.info_history[#resp.info_history+1] = battle_round_state.info_history[index]
	end
	battle._parameter_record:Clear()
	for index = 1, table.getn(battle_round_state.para_record) do
		local tmp = CACHE.BattleEvent()
		tmp._value = battle_round_state.para_record[index].typ
		tmp._count = battle_round_state.para_record[index].count

		battle._parameter_record:Insert(tmp._value, tmp)
	end
	local capture_position = {}
	for index = 1, table.getn(battle_round_state.movedata) do
		local success_flag = false
		--在这里需要首先判断一下，这次移动是否成功，现在只需要判断一个东西，那就是一个据点里面的NPC不可以超过4个。
		--如果判断目的地当前有4个敌人的话，那么这次移动直接失败
		local position_info = battle._position_info:Find(battle_round_state.movedata[index].nowpos)
		if position_info ~= nil then
			API_Log("11111111111111111111111111111111111    npcindex="..battle_round_state.movedata[index].npcindex)
			local npc_info = position_info._npc_info:Find(battle_round_state.movedata[index].npcindex)
			if npc_info ~= nil then
				if npc_info._alive == 1 then
					--下面首先先对士兵的士气进行修改。省得后面根据不同的情况来进行处理了。
					npc_info._army_buff = battle_round_state.movedata[index].mymoraleresult
					--开始判断目标的信息,需要判断的信息是
					--如果是一个阵营的话，那么最多只可以有4个
					--如果不是一个阵营的话，那么就没有了。
					local move_position = battle._position_info:Find(battle_round_state.movedata[index].movepos)
					if move_position ~= nil then
						--下面首先对士气进行修改
						for morale_index = 1, table.getn(battle_round_state.movedata[index].foemoraleresult) do
							local tmp_army = battle_round_state.movedata[index].foemoraleresult[morale_index]
							local army_info = move_position._npc_info:Find(tmp_army.npcindex)
							if army_info ~= nil then
								army_info._army_buff = tmp_army.movemorale
							end
						end
						if battle_round_state.movedata[index].battleresult == 6 then
							--do nothing
						elseif battle_round_state.movedata[index].battleresult == 5 then
							--当前格子没有敌方和友方NPC或者是全部死了，只有玩家自己在这个格子里面
							local npc_num = move_position._npc_info:Size()
							--查看是否即使有人是不是全死了
							local alive_num = 0
							local move_npc_it =  move_position._npc_info:SeekToBegin()
							local move_npc = move_npc_it:GetValue()
							while move_npc ~= nil do
								if move_npc._alive == 1 and move_npc._camp ~= npc_info._camp then
									alive_num = alive_num + 1
								end
								move_npc_it:Next()
								move_npc = move_npc_it:GetValue()
							end
							
							if alive_num == 0 and battle._cur_position == battle_round_state.movedata[index].movepos then
								move_position._npc_info:Insert(battle_round_state.movedata[index].npcindex, npc_info)
								position_info._npc_info:Delete(battle_round_state.movedata[index].npcindex)
								success_flag = true
								battle._attacked_flag = battle._cur_position
								battle._last_position = battle_round_state.movedata[index].retreatpoint
							end

						elseif battle_round_state.movedata[index].battleresult == 4 then
							npc_info._alive = 0
							move_position._npc_info:Insert(battle_round_state.movedata[index].npcindex, npc_info)
							position_info._npc_info:Delete(battle_round_state.movedata[index].npcindex)
							success_flag = true
						elseif battle_round_state.movedata[index].battleresult == 3 then
							local npc_num = move_position._npc_info:Size()
							if npc_num ~= 0 then
								local move_npc_it =  move_position._npc_info:SeekToBegin()
								local move_npc = move_npc_it:GetValue()
								local tmp_flag = true
								while move_npc ~= nil do
									if move_npc._camp == npc_info._camp and move_npc._alive == 1 then
										tmp_flag = false
										break
									end
									move_npc_it:Next()
									move_npc = move_npc_it:GetValue()
								end

								if battle._cur_position == battle_round_state.movedata[index].movepos then
									if tmp_flag == true then
										--需要把格子里面所有的NPC全部干死
										local move_npc_it =  move_position._npc_info:SeekToBegin()
										local move_npc = move_npc_it:GetValue()
										local tmp_flag = true
										while move_npc ~= nil do
											if move_npc._alive == 1 then
												move_npc._alive = 0
											end
											move_npc_it:Next()
											move_npc = move_npc_it:GetValue()
										end
										move_position._npc_info:Insert(battle_round_state.movedata[index].npcindex, npc_info)
										position_info._npc_info:Delete(battle_round_state.movedata[index].npcindex)
										success_flag = true
										battle._attacked_flag = battle._cur_position
										battle._last_position = battle_round_state.movedata[index].retreatpoint
									end
								end
							end
						elseif battle_round_state.movedata[index].battleresult == 2 then
							--直接占领那么必须目标地方没有NPC,或者NPC的阵营跟自己是一样的
							local npc_num = move_position._npc_info:Size()
							--查看是否即使有人是不是全死了
							local alive_num = 0
							local move_npc_it =  move_position._npc_info:SeekToBegin()
							local move_npc = move_npc_it:GetValue()
							while move_npc ~= nil do
								if move_npc._alive == 1 then
									alive_num = alive_num + 1
								end
								move_npc_it:Next()
								move_npc = move_npc_it:GetValue()
							end
							
							if npc_num == 0 or alive_num == 0 then
								move_position._npc_info:Insert(battle_round_state.movedata[index].npcindex, npc_info)
								position_info._npc_info:Delete(battle_round_state.movedata[index].npcindex)
								if npc_info._camp == 3 or npc_info._camp == 1 then
									move_position._flag = 1
									capture_position[#capture_position+1] = battle_round_state.movedata[index].movepos
								elseif npc_info._camp == 2 then
									move_position._flag = 2
								end
								success_flag = true
							else
								local move_npc_it =  move_position._npc_info:SeekToBegin()
								local move_npc = move_npc_it:GetValue()
								local tmp_flag = true
								while move_npc ~= nil do
									if move_npc._camp ~= npc_info._camp and move_npc._alive == 1 then
										tmp_flag = false
										break
									end
									move_npc_it:Next()
									move_npc = move_npc_it:GetValue()
								end
								if tmp_flag == true and npc_num < 4 then
									move_position._npc_info:Insert(battle_round_state.movedata[index].npcindex, npc_info)
									position_info._npc_info:Delete(battle_round_state.movedata[index].npcindex)
									success_flag = true
								end
							end
						elseif battle_round_state.movedata[index].battleresult == 1 then
							--战斗失败了。NPC死亡
							npc_info._alive = 0
							move_position._npc_info:Insert(battle_round_state.movedata[index].npcindex, npc_info)
							position_info._npc_info:Delete(battle_round_state.movedata[index].npcindex)
							success_flag = true
						elseif battle_round_state.movedata[index].battleresult == 0 then
							--战斗胜利了，目标里面所有的NPC全部干死
							--两个条件，一个是目标位置有NPC
							--第二个是NPC的阵营跟自己不是一个阵营的
							local npc_num = move_position._npc_info:Size()
							if npc_num ~= 0 then
								local move_npc_it =  move_position._npc_info:SeekToBegin()
								local move_npc = move_npc_it:GetValue()
								local tmp_flag = true
								while move_npc ~= nil do
									if move_npc._camp == npc_info._camp and move_npc._alive == 1 then
										tmp_flag = false
										break
									end
									move_npc_it:Next()
									move_npc = move_npc_it:GetValue()
								end

								if tmp_flag == true then
									--需要把格子里面所有的NPC全部干死，然后把目标位置的阵营设置成NPC的阵营
									local move_npc_it =  move_position._npc_info:SeekToBegin()
									local move_npc = move_npc_it:GetValue()
									local tmp_flag = true
									while move_npc ~= nil do
										if move_npc._alive == 1 then
											move_npc._alive = 0
										end
										move_npc_it:Next()
										move_npc = move_npc_it:GetValue()
									end
									move_position._npc_info:Insert(battle_round_state.movedata[index].npcindex, npc_info)
									position_info._npc_info:Delete(battle_round_state.movedata[index].npcindex)
									
									if npc_info._camp == 3 or npc_info._camp == 1 then
										move_position._flag = 1
										capture_position[#capture_position+1] = battle_round_state.movedata[index].movepos
									elseif npc_info._camp == 2 then
										move_position._flag = 2
									end
									success_flag = true

									if battle_round_state.movedata[index].movepos == battle._attacked_flag then
										battle._attacked_flag = 0
									end
								end
							end
						end
					end
				end
			end
		end
	
		local tmp_npc_info = {}
		tmp_npc_info.battle_flag = battle_round_state.movedata[index].battleresult
		tmp_npc_info.npc_id = battle_round_state.movedata[index].npcindex
		tmp_npc_info.source_pos = battle_round_state.movedata[index].nowpos
		tmp_npc_info.move_pos = battle_round_state.movedata[index].movepos
		tmp_npc_info.mymoraleresult = battle_round_state.movedata[index].mymoraleresult
		tmp_npc_info.foemoraleresult = {}
		for morale_index = 1, table.getn(battle_round_state.movedata[index].foemoraleresult) do
			local tmp_army = battle_round_state.movedata[index].foemoraleresult[morale_index]
			local tmp = {}
			tmp.npc_id = tmp_army.npcindex
			tmp.morale = tmp_army.movemorale
			tmp_npc_info.foemoraleresult[#tmp_npc_info.foemoraleresult+1] = tmp
		end

		if success_flag == true then
			tmp_npc_info.move_event = {}
			tmp_npc_info.capture_event = {}
			for eventnum = 1, table.getn(battle_round_state.movedata[index].battleevent) do
				local tmp_event_id = battle_round_state.movedata[index].battleevent[eventnum]
				local tmp_find_event_info = battle._battleevent:Find(tmp_event_id)
				if tmp_find_event_info == nil then
					tmp_npc_info.move_event[#tmp_npc_info.move_event+1] = ROLE_GetBattleEventInfo(role, arg.battle_id, tmp_event_id)
					local insert_data = CACHE.BattleEvent()
					insert_data._value = tmp_event_id
					insert_data._count = 1
					battle._battleevent:Insert(insert_data._value, insert_data)
				else
					local ed = DataPool_Find("elementdata")
					local battleevent_info = ed:FindBy("battle_event_id", tmp_event_id)
					if tmp_find_event_info._count < battleevent_info.trigger_counts then
						tmp_find_event_info._count = tmp_find_event_info._count + 1
						tmp_npc_info.move_event[#tmp_npc_info.move_event+1] = ROLE_GetBattleEventInfo(role, arg.battle_id, tmp_event_id)
					end
				end
			end
			for eventnum = 1, table.getn(battle_round_state.movedata[index].occupyevent) do
				local tmp_event_id = battle_round_state.movedata[index].occupyevent[eventnum]
				local tmp_find_event_info = battle._occupyevent:Find(tmp_event_id)
				if tmp_find_event_info == nil then
					tmp_npc_info.capture_event[#tmp_npc_info.capture_event+1] = ROLE_GetBattleEventInfo(role, arg.battle_id, tmp_event_id)
					local insert_data = CACHE.BattleEvent()
					insert_data._value = tmp_event_id
					insert_data._count = 1
					battle._occupyevent:Insert(insert_data._value, insert_data)
				else
					local ed = DataPool_Find("elementdata")
					local battleevent_info = ed:FindBy("battle_event_id", tmp_event_id)
					if tmp_find_event_info._count < battleevent_info.trigger_counts then
						tmp_find_event_info._count = tmp_find_event_info._count + 1
						tmp_npc_info.capture_event[#tmp_npc_info.capture_event+1] = ROLE_GetBattleEventInfo(role, arg.battle_id, tmp_event_id)
					end
				end
			end
		elseif success_flag == false and tmp_npc_info.battle_flag == 6 then
			tmp_npc_info.move_event = {}
			for eventnum = 1, table.getn(battle_round_state.movedata[index].battleevent) do
				local tmp_event_id = battle_round_state.movedata[index].battleevent[eventnum]
				local tmp_find_event_info = battle._battleevent:Find(tmp_event_id)
				if tmp_find_event_info == nil then
					tmp_npc_info.move_event[#tmp_npc_info.move_event+1] = ROLE_GetBattleEventInfo(role, arg.battle_id, tmp_event_id)
					local insert_data = CACHE.BattleEvent()
					insert_data._value = tmp_event_id
					insert_data._count = 1
					battle._battleevent:Insert(insert_data._value, insert_data)
				else
					local ed = DataPool_Find("elementdata")
					local battleevent_info = ed:FindBy("battle_event_id", tmp_event_id)
					if tmp_find_event_info._count < battleevent_info.trigger_counts then
						tmp_find_event_info._count = tmp_find_event_info._count + 1
						tmp_npc_info.move_event[#tmp_npc_info.move_event+1] = ROLE_GetBattleEventInfo(role, arg.battle_id, tmp_event_id)
					end
				end
			end
		end
		resp.npc_info[#resp.npc_info+1] = tmp_npc_info
	end
	
	for index = 1, table.getn(battle_round_state.eventid) do
		--可以让事件多次触发，先取消掉这个判断
		local find_event_info = battle._cehuaeventid:Find(battle_round_state.eventid[index])
		if find_event_info == nil then
			resp.event_info[#resp.event_info+1] = ROLE_GetBattleEventInfo(role, arg.battle_id, battle_round_state.eventid[index])
			local insert_data = CACHE.BattleEvent()
			insert_data._value = battle_round_state.eventid[index]
			insert_data._count = 1
			battle._cehuaeventid:Insert(battle_round_state.eventid[index], insert_data)
		else
			local ed = DataPool_Find("elementdata")
			local battleevent_info = ed:FindBy("battle_event_id", battle_round_state.eventid[index])
			if find_event_info._count < battleevent_info.trigger_counts then
				find_event_info._count = find_event_info._count + 1
				resp.event_info[#resp.event_info+1] = ROLE_GetBattleEventInfo(role, arg.battle_id, battle_round_state.eventid[index])
			end
		end
	end

	--清掉下一回合的移动
	local position_info_it = battle._position_info:SeekToBegin()
	local position_info = position_info_it:GetValue()

	while position_info ~= nil do
		local npc_info_it = position_info._npc_info:SeekToBegin()
		local npc_info = npc_info_it:GetValue()
		while npc_info ~= nil do
			npc_info._next_pos = 0

			npc_info_it:Next()
			npc_info = npc_info_it:GetValue()
		end
		
		position_info_it:Next()
		position_info = position_info_it:GetValue()
	end

	resp.move_pos = {}
	for index = 1, table.getn(battle_round_state.npcnextpos) do
		local tmp = battle_round_state.npcnextpos[index]
		local tmp_info = {}
		tmp_info.npc_id = tmp.npcindex
		tmp_info.pos = tmp.nextpos
		
		local position_info = battle._position_info:Find(tmp.curpos)
		if position_info ~= nil then
			local npc_info = position_info._npc_info:Find(tmp.npcindex)
			if npc_info ~= nil then
				npc_info._next_pos = tmp.nextpos
			end
		end

		resp.move_pos[#resp.move_pos+1] = tmp_info
	end

	resp.morale_change = {}
	for index = 1, table.getn(battle_round_state.npcmorale) do
		local tmp = battle_round_state.npcmorale[index]
		local tmp_info = {}
		tmp_info.npc_id = tmp.npcindex
		tmp_info.morale = tmp.standmorale
		
		local position_info = battle._position_info:Find(tmp.curpos)
		local npc_info = position_info._npc_info:Find(tmp.npcindex)
		if npc_info ~= nil then
			npc_info._army_buff = tmp.standmorale
		end

		resp.morale_change[#resp.morale_change+1] = tmp_info
	end

	--修改玩家自己的士气变化
	battle._cur_morale = battle_round_state.curmorale
	resp.cur_morale = battle_round_state.curmorale

	player:SendToClient(SerializeCommand(resp))
	
	resp = NewCommand("BattleFieldUpdateRoundState")
	resp.battle_id = arg.battle_id
	resp.round_num = battle._round_num
	resp.round_state = battle._round_state
	player:SendToClient(SerializeCommand(resp))

	--判断占领的据点是否完成了
	for index = 1, table.getn(capture_position) do
		local ed = DataPool_Find("elementdata")
		local battle_info = ed:FindBy("battle_id", arg.battle_id)
		local battlefielddata_info = ed:FindBy("battlefielddata_id", battle_info.battlefieldid)

		if battlefielddata_info.battle_target_type == 0 then
			if battlefielddata_info.enemy_camp_pos == capture_position[index] then
				battle._state = 2
		
				resp = NewCommand("ChangeBattleState")
				resp.battle_id = arg.battle_id
				resp.state = battle._state
				player:SendToClient(SerializeCommand(resp))
				local insert_data = CACHE.Int()
				insert_data._value = arg.battle_id
				role._roledata._have_finish_battle:Insert(arg.battle_id, insert_data)
				ROLE_FinishFieldBattle(role, arg.battle_id, 1)
				ROLE_UpdateHaveFinishBattle(role)
			end
		end
	end

	--判断是否回合数结束了
	if battle._round_flag ~= 0 then
		if battle._round_num > battle._round_flag then
			battle._state = 3
			local resp = NewCommand("ChangeBattleState")
			resp.battle_id = arg.battle_id
			resp.state = battle._state
			player:SendToClient(SerializeCommand(resp))

			local resp = NewCommand("BattleFieldRoundCount_Re")
			resp.battle_id = arg.battle_id
			resp.retcode = G_ERRCODE["BATTLEFIELD_ROUND_COUNT_LESS"]
			player:SendToClient(SerializeCommand(resp))
		end
	end
end
