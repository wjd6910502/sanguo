function OnCommand_SendFlowerGift(player, role, arg, others)
	player:Log("OnCommand_SendFlowerGift, "..DumpTable(arg).." "..DumpTable(others))
	
	local cmd = NewCommand("SendFlowerGift_Re")

    local dest_role = others.roles[arg.dest_id]
	if dest_role == nil then
		return
	end
	--不可以给自己发花
	if role._roledata._base._id:ToStr() == dest_role._roledata._base._id:ToStr() then
		local cmd = NewCommand("ErrorInfo")
		cmd.error_id = G_ERRCODE["SENDFLOWER_TO_SELF"]
		role:SendToClient(SerializeCommand(cmd))
		player:Log("OnCommand_SendFlowerGift, error=SENDFLOWER_TO_SELF")
		return
	end
		
	local ed = DataPool_Find("elementdata")
	local flower_data = ed:FindBy("flower_id",arg.typ)	
	if flower_data == nil then
		local cmd = NewCommand("ErrorInfo")
		cmd.error_id = G_ERRCODE["SENDFLOWER_TYPE_NOT_RIGHT"]
		role:SendToClient(SerializeCommand(cmd))
		player:Log("OnCommand_SendFlowerGift, error=SENDFLOWER_TYPE_NOT_RIGHT")
		return	
	end

	--数量从item表读取
	local ed = DataPool_Find("elementdata")
	local item = ed:FindBy("reward_id", flower_data.receiver_reward_id)
	if item == nil then
		local cmd = NewCommand("ErrorInfo")
		cmd.error_id = G_ERRCODE["SENDFLOWER_REWARD_TEMPLAT_ERROR"]
		role:SendToClient(SerializeCommand(cmd))
		return
	end
	local count = item.items[1].itemnum

	local ed = DataPool_Find("elementdata")
	local quanju = ed.gamedefine[1]

	--only one time for count 1 , 9 design so c c c c .....
	local now = API_GetTime()
	local has_send = 0
	if count == 1 or count == 9 then
		local ffit = role._roledata._flower_info._send_record:SeekToBegin()
		local ff = ffit:GetValue()
		while ff ~= nil do
			if ff._info._id:ToStr() == dest_role._roledata._base._id:ToStr() then
				local now_time = os.date("*t", now)
				local last_time = os.date("*t", ff._time)
				if now_time.year == last_time.year and now_time.month == last_time.month then
					if last_time.yday - now_time.yday == -1 then
						if now_time.hour < 5 and last_time.hour >= 5 then
							if ff._count == 1 or ff._count == 9 then
								local cmd = NewCommand("ErrorInfo")
								cmd.error_id = G_ERRCODE["SENDFLOWER_HAS_SEND"]
								role:SendToClient(SerializeCommand(cmd))
								player:Log("OnCommand_SendFlowerGift, error=SENDFLOWER_HAS_SEND")
								return
							end
						end
					elseif last_time.yday - now_time.yday == 0 then
						if now_time.hour < 5 or last_time.hour >= 5 then
							if ff._count == 1 or ff._count == 9 then
								local cmd = NewCommand("ErrorInfo")
								cmd.error_id = G_ERRCODE["SENDFLOWER_HAS_SEND"]
								role:SendToClient(SerializeCommand(cmd))
								player:Log("OnCommand_SendFlowerGift, error=SENDFLOWER_HAS_SEND")
								return
							end
						end	
					end
				end
			end
			ffit:Next()
			ff = ffit:GetValue()	
		end
	elseif count == 99 then
		--vip开启限制
		if ROLE_GetVIP(role) < quanju.send_flower_vip then
			return --外挂才会进，不用提示了
		end

		--每天最多送100次
		if LIMIT_TestUseLimit(role, quanju.reward_limit_id_send_99flower, 1) ~= true then
			local cmd = NewCommand("ErrorInfo")
			cmd.error_id = G_ERRCODE["SENDFLOWER_TIMES_UPPER"]
			role:SendToClient(SerializeCommand(cmd))
			player:Log("OnCommand_SendFlowerGift, error=SENDFLOWER_TIMES_UPPER")
			return
		end

		local ffit = role._roledata._flower_info._send_record:SeekToBegin()
		local ff = ffit:GetValue()
		while ff ~= nil do
			if ff._info._id:ToStr() == dest_role._roledata._base._id:ToStr() then
				local now_time = os.date("*t", now)
				local last_time = os.date("*t", ff._time)
				if now_time.year == last_time.year and now_time.month == last_time.month then
					if last_time.yday - now_time.yday == -1 then
						if now_time.hour < 5 and last_time.hour >= 5 then
							if ff._count == 1 or ff._count == 9 or ff._count == 99 then
								has_send = 1
								break
							end
						end
					elseif last_time.yday - now_time.yday == 0 then
						if now_time.hour < 5 or last_time.hour >= 5 then
							if ff._count == 1 or ff._count == 9 or ff._count == 99  then
								has_send = 1
								break
							end
						end
					end
				end
			end
			ffit:Next()
			ff = ffit:GetValue()
		end
	end

	--是否给这个人送花达到上线
	local ed = DataPool_Find("elementdata")
	local quanju = ed.gamedefine[1]
	if LIMIT_TestUseLimit(dest_role, quanju.receive_flower_limit_id, count) ~= true then
		local cmd = NewCommand("ErrorInfo")
		cmd.error_id = G_ERRCODE["SENDFLOWER_TIMES_UPPER"]
		role:SendToClient(SerializeCommand(cmd))	
		player:Log("OnCommand_SendFlowerGift, error=SENDFLOWER_TIMES_UPPER")
		return		
	end

	--vip 99朵每天能免费一次
	local vip_free = 0
	if count == 99 then
		if LIMIT_TestUseLimit(role, quanju.limit_id_send_99flower_free, 1) == true then
			vip_free = 1
			LIMIT_AddUseLimit(role, quanju.limit_id_send_99flower_free, 1)
		end
	end
	
	--扣钱 添加奖励
	if vip_free == 0 then
		local cost_type = flower_data.sender_cost_currency_id
		local price = flower_data.sender_cost_currency_num
		if cost_type == 1 then
			if role._roledata._status._money < price then	
				local cmd = NewCommand("ErrorInfo")
				cmd.error_id = G_ERRCODE["SENDFLOWER_MONEY_NOT_ENOUGH"]
				role:SendToClient(SerializeCommand(cmd))
				player:Log("OnCommand_SendFlowerGift, error=SENDFLOWER_MONEY_NOT_ENOUGH")
				return
			end
			ROLE_SubMoney(role, price)
		elseif cost_type == 2 then
			if role._roledata._status._yuanbao < price then
				local cmd = NewCommand("ErrorInfo")
				cmd.error_id = G_ERRCODE["SENDFLOWER_YUANBAO_NOT_ENOUGH"]
				role:SendToClient(SerializeCommand(cmd))
				player:Log("OnCommand_SendFlowerGift, error=SENDFLOWER_YUANBAO_NOT_ENOUGH")
				return
			end
			ROLE_SubYuanBao(role, price)
		else	
			local cmd = NewCommand("ErrorInfo")
			cmd.error_id = G_ERRCODE["SENDFLOWER_COSTTYPE_NOT_EXIST"]
			role:SendToClient(SerializeCommand(cmd))	
			player:Log("OnCommand_SendFlowerGift, error=SENDFLOWER_COSTTYPE_NOT_EXIST")
			return
		end
	end
	
	--送花方奖励
	if LIMIT_TestUseLimit(role, quanju.send_flower_reward_limit_id, 1) == true and has_send ~= 1 then 
		local reward_id = flower_data.sender_reward	
		local Reward = DROPITEM_Reward(role, reward_id)
		ROLE_AddReward(role, Reward)
		LIMIT_AddUseLimit(role, quanju.send_flower_reward_limit_id, 1)
	end
		
	local tmp = CACHE.Int()
	tmp._value = 1	
	role._roledata._flower_info._sendflower:Insert(CACHE.Int64(arg.dest_id), tmp)

	if count == 1 or count == 9 then
		LIMIT_AddUseLimit(dest_role, quanju.receive_flower_limit_id, count)
	elseif count == 99 then
		LIMIT_AddUseLimit(role, quanju.reward_limit_id_send_99flower, 1)
	end
	
	--被送花方奖励
	local reward_id = flower_data.receiver_reward_id
	local Reward = DROPITEM_Reward(dest_role, reward_id)
	ROLE_AddReward(dest_role, Reward)

	--dest_role身上加一下送花记录
	local flowerRecord = CACHE.SendFlowerRecord()
	flowerRecord._info._id = role._roledata._base._id
	flowerRecord._info._name = role._roledata._base._name
	flowerRecord._info._photo = role._roledata._base._photo
	flowerRecord._info._level = role._roledata._status._level
	flowerRecord._info._mafia_id = role._roledata._mafia._id
	flowerRecord._info._mafia_name = role._roledata._mafia._name
	flowerRecord._info._photo_frame = role._roledata._base._photo_frame		
	flowerRecord._count = count
	flowerRecord._time = now
	
	--如果大于100条数据 删除头 插入尾巴
	if dest_role._roledata._flower_info._record:Size() >= 100 then
		dest_role._roledata._flower_info._record:PopFront()
		dest_role._roledata._flower_info._record:PushBack(flowerRecord)
	else
		dest_role._roledata._flower_info._record:PushBack(flowerRecord)
	end
	
	local flowerRecord = CACHE.SendFlowerRecord()
	flowerRecord._info._id = dest_role._roledata._base._id
	flowerRecord._info._name = dest_role._roledata._base._name
	flowerRecord._info._photo = dest_role._roledata._base._photo
	flowerRecord._info._level = dest_role._roledata._status._level
	flowerRecord._info._mafia_id = dest_role._roledata._mafia._id
	flowerRecord._info._mafia_name = dest_role._roledata._mafia._name
	flowerRecord._info._photo_frame = dest_role._roledata._base._photo_frame		
	flowerRecord._count = count
	flowerRecord._time = now
	
	if role._roledata._flower_info._send_record:Size() >= 100 then
		role._roledata._flower_info._send_record:PopFront()
		role._roledata._flower_info._send_record:PushBack(flowerRecord)
	else
		role._roledata._flower_info._send_record:PushBack(flowerRecord)
	end
		
	cmd.src=ROLE_MakeRoleBrief(role)	
	cmd.dest=ROLE_MakeRoleBrief(dest_role)
	cmd.dest_id = arg.dest_id
	cmd.typ = arg.typ
	cmd.time = now
	cmd.count = count
	cmd.mask = 1	
	role:SendToClient(SerializeCommand(cmd))
	--在dest_role的送花列表中找role
	local fit = dest_role._roledata._flower_info._sendflower:Find(role._roledata._base._id)
	if fit == nil then
		cmd.mask = 0
	end
	dest_role:SendToClient(SerializeCommand(cmd))

	local rep = dest_role._roledata._rep_info:Find(11)
	if rep ~= nil then
		local msg = NewMessage("TopListInsertInfo")
		msg.typ = 9
		msg.data = tostring(rep._rep_num)
		player:SendMessage(dest_role._roledata._base._id, SerializeMessage(msg))
	end

	--判断被赠送玩家是否在线
	if dest_role._roledata._status._online == 1 then
		--update红点提示	
		local cmd_u = NewCommand("UpdateFlowerGiftInfo")
		role:SendToClient(SerializeCommand(cmd_u))
		dest_role:SendToClient(SerializeCommand(cmd_u))
	else
		dest_role._roledata._flower_info._recive_flag = 1	
	end
	TASK_ChangeCondition(role, G_ACH_TYPE["STAGE_COUNT"], G_ACH_EIGHT_TYPE["FLOWER"], 1)
end
