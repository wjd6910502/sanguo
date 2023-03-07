function OnCommand_MafiaApply(player, role, arg, others)
	player:Log("OnCommand_MafiaApply, "..DumpTable(arg).." "..DumpTable(others))

	local mafia_data = others.mafias[arg.id]
	local resp = NewCommand("MafiaApply_Re")
	resp.id = arg.id

	if mafia_data == nil then
		resp.retcode = G_ERRCODE["NO_MAFIA"]
		player:SendToClient(SerializeCommand(resp))
		return
	end

	local mafia_info = mafia_data._data

	if mafia_info._deleted == 1 then
		return
	end

	--帮会申请，首先查看自己是否有帮会
	if role._roledata._mafia._id:ToStr() ~= "0" or role._roledata._mafia._name ~= "" then
		resp.retcode = G_ERRCODE["MAFIA_APPLY_HAVE_MAFIA"]
		player:SendToClient(SerializeCommand(resp))
		return
	end

	--查看自己是否符合帮会的申请条件
	if role._roledata._status._level < mafia_info._level_limit then
		resp.retcode = G_ERRCODE["MAFIA_APPLY_LEVEL_LESS"]
		player:SendToClient(SerializeCommand(resp))
		return
	end

	--查看自己是否已经在这个帮会的申请列表中了
	local apply_list_info_it = mafia_info._applylist:SeekToBegin()
	local apply_list_info = apply_list_info_it:GetValue()
	while apply_list_info ~= nil do
		if apply_list_info._id:ToStr() == role._roledata._base._id:ToStr() then
			resp.retcode = G_ERRCODE["MAFIA_APPLY_HAVE_IN_APPLY"]
			player:SendToClient(SerializeCommand(resp))
			return
		end

		apply_list_info_it:Next()
		apply_list_info = apply_list_info_it:GetValue()
	end

	--查看当前的申请列表是否达到了最高上限
	if mafia_info._applylist:Size() >= 30 then
		resp.retcode = G_ERRCODE["MAFIA_APPLY_LEVEL_LESS"]
		player:SendToClient(SerializeCommand(resp))
		return
	end

	--查看帮会是否需要批准
	--查看帮会是否人数达到了上限，如果达到了上限，那么就直接加到申请列表里面去
	local ed = DataPool_Find("elementdata")
	local league_level_info = ed:FindBy("league_level", mafia_info._level)
	if mafia_info._need_approval == 0 and mafia_info._member_map:Size() < league_level_info.member_num then
		--不需要批准那么直接加入帮会。
		local insert_mafia_member = CACHE.MafiaMember()
		insert_mafia_member._id = role._roledata._base._id
		insert_mafia_member._name = role._roledata._base._name
		insert_mafia_member._photo = role._roledata._base._photo
		insert_mafia_member._photo_frame = role._roledata._base._photo_frame
		insert_mafia_member._badge_map = role._roledata._base._badge_map
		insert_mafia_member._sex = role._roledata._base._sex
		insert_mafia_member._level = role._roledata._status._level
		insert_mafia_member._activity = 0
		insert_mafia_member._zhanli = role._roledata._status._zhanli
		insert_mafia_member._contribution = 0
		insert_mafia_member._position = G_MAFIA_POSITION["PINGMIN"]
		insert_mafia_member._logout_time = 0
		insert_mafia_member._join_time = API_GetTime()
		insert_mafia_member._online = role._roledata._status._online

		mafia_info._member_map:Insert(insert_mafia_member._id, insert_mafia_member)

		--更新帮会成员信息
		MAFIA_MafiaAddMember(mafia_info, insert_mafia_member)

		--设置玩家自己的数据
		role._roledata._mafia._create_time = 0
		role._roledata._mafia._id = mafia_info._id
		role._roledata._mafia._name = mafia_info._name
		role._roledata._mafia._position = insert_mafia_member._position
		role._roledata._mafia._invites:Clear()
		role._roledata._mafia._apply_mafia:Clear()
		MAFIA_UpdateSelfInfo(role)
		--更新自己的祭祀成就
		TASK_ChangeCondition(role, G_ACH_TYPE["MAFIA_JISI"], 0, mafia_info._jisi)
		
		--判断自己的马术积分，如果马术积分不为0的话，给自己发一个消息，让自己的马术积分上帮会的马术积分排行榜
		if role._roledata._mashu_info._today_max_score > 0 then
			local msg = NewMessage("RoleUpdateInfoMafiaTop")
			msg.mafia_id = role._roledata._mafia._id:ToStr()
			msg.data = role._roledata._mashu_info._today_max_score
			msg.score = role._roledata._mashu_info._today_max_score
			local mafia_list = CACHE.Int64List()
			mafia_list:PushBack(role._roledata._mafia._id)
			API_SendMessage(role._roledata._base._id, SerializeMessage(msg), CACHE.Int64List(), mafia_list, CACHE.IntList())
		end
		
		--更新帮会的信息到简易帮会表中去
		MAFIA_MafiaUpdateInfoTop(mafia_info, 0)

		--给这个玩家发送进入帮会的邮件
		local msg = NewMessage("SendMail")
		msg.mail_id = 1802
		player:SendMessage(role._roledata._base._id, SerializeMessage(msg))

	else
		--需要批准的话把玩家加入到申请列表
		local insert_apply_info = CACHE.MafiaApplyMemberData()
		insert_apply_info._id = role._roledata._base._id
		insert_apply_info._name = role._roledata._base._name
		insert_apply_info._photo = role._roledata._base._photo
		insert_apply_info._level = role._roledata._status._level
		insert_apply_info._zhanli = role._roledata._status._zhanli
		insert_apply_info._photo_frame = role._roledata._base._photo_frame
		insert_apply_info._badge_map = role._roledata._base._badge_map
		insert_apply_info._sex = role._roledata._base._sex

		mafia_info._applylist:PushBack(insert_apply_info)
		--更新帮会的申请列表
		local apply_info = {}
		apply_info.id = role._roledata._base._id
		apply_info.name = role._roledata._base._name
		apply_info.photo = role._roledata._base._photo
		apply_info.level = role._roledata._status._level
		apply_info.zhanli = role._roledata._status._zhanli
		apply_info.photo_frame = role._roledata._base._photo_frame
		apply_info.sex = role._roledata._base._sex
		apply_info.badge_info = {}
		
		local badge_info_it = role._roledata._base._badge_map:SeekToBegin()
		local badge_info = badge_info_it:GetValue()
		while badge_info ~= nil do
			local tmp_badge_info = {}
			tmp_badge_info.id = badge_info._id
			tmp_badge_info.typ = badge_info._pos
			apply_info.badge_info[#apply_info.badge_info+1] = tmp_badge_info

			badge_info_it:Next()
			badge_info = badge_info_it:GetValue()
		end

		MAFIA_MafiaAddApply(mafia_info, apply_info)
	
		--更新玩家自己的信息
		role._roledata._mafia._apply_mafia:PushBack(mafia_info._id)
		MAFIA_UpdateSelfInfo(role)
	end
	
	resp.retcode = G_ERRCODE["SUCCESS"]
	player:SendToClient(SerializeCommand(resp))
	return
end
