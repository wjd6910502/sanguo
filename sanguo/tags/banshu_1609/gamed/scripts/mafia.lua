function MAFIA_MakeMafia(mafia)
	local ret = {}
	ret.id = mafia._id:ToStr()
	ret.name = mafia._name
	ret.flag = mafia._flag
	ret.announce = mafia._announce
	ret.xuanyan = mafia._declaration
	ret.level = mafia._level
	ret.activity = mafia._activity
	ret.boss_id = mafia._boss_id:ToStr()
	ret.boss_name = mafia._boss_name
	ret.exp = mafia._exp
	ret.jisi = mafia._jisi
	ret.mashu_toplist_id = mafia._mashu_toplist_id
	ret.level_limit = mafia._level_limit
	ret.need_approval = mafia._need_approval
	ret.declaration = mafia._declaration
	--_member_map
	ret.members = {}
	for m in Cache_Map(mafia._member_map) do
		local m2 = {}
		m2.id = m._id:ToStr()
		m2.name = m._name
		m2.photo = m._photo
		m2.photo_frame = m._photo_frame
		m2.sex = m._sex
		m2.badge_info = {}
		
		local badge_info_it = m._badge_map:SeekToBegin()
		local badge_info = badge_info_it:GetValue()
		while badge_info ~= nil do
			local tmp_badge_info = {}
			tmp_badge_info.id = badge_info._id
			tmp_badge_info.typ = badge_info._pos
			m2.badge_info[#m2.badge_info+1] = tmp_badge_info

			badge_info_it:Next()
			badge_info = badge_info_it:GetValue()
		end
		m2.level = m._level
		m2.activity = m._activity
		m2.position = m._position
		m2.logout_time = m._logout_time
		m2.online = m._online
		m2.zhanli = m._zhanli
		m2.contrabution = {}
		local contrabution_it = m._week_contribution:SeekToBegin()
		local contrabution = contrabution_it:GetValue()
		while contrabution ~= nil do
			m2.contrabution[#m2.contrabution+1] = contrabution._value
			contrabution_it:Next()
			contrabution = contrabution_it:GetValue()
		end
		ret.members[#ret.members+1] = m2
	end

	--申请列表
	ret.apply_list = {}
	local apply_info_it = mafia._applylist:SeekToBegin()
	local apply_info = apply_info_it:GetValue()
	while apply_info ~= nil do
		local tmp_apply_info = {}
		tmp_apply_info.id = apply_info._id:ToStr()
		tmp_apply_info.name = apply_info._name
		tmp_apply_info.photo = apply_info._photo
		tmp_apply_info.level = apply_info._level
		tmp_apply_info.zhanli = apply_info._zhanli
		tmp_apply_info.photo_frame = apply_info._photo_frame
		tmp_apply_info.sex = apply_info._sex
		tmp_apply_info.badge_info = {}
		
		local badge_info_it = apply_info._badge_map:SeekToBegin()
		local badge_info = badge_info_it:GetValue()
		while badge_info ~= nil do
			local tmp_badge_info = {}
			tmp_badge_info.id = badge_info._id
			tmp_badge_info.typ = badge_info._pos
			tmp_apply_info.badge_info[#tmp_apply_info.badge_info+1] = tmp_badge_info

			badge_info_it:Next()
			badge_info = badge_info_it:GetValue()
		end

		ret.apply_list[#ret.apply_list+1] = tmp_apply_info
		apply_info_it:Next()
		apply_info = apply_info_it:GetValue()
	end
	
	--事件列表
	ret.notice = {}
	local notice_info_it = mafia._notice:SeekToBegin()
	local notice_info = notice_info_it:GetValue()
	while notice_info ~= nil do
		local tmp_notice_info = {}
		tmp_notice_info.typ = notice_info._typ
		tmp_notice_info.id = notice_info._id
		tmp_notice_info.time = notice_info._time
		tmp_notice_info.role_info = {}
		tmp_notice_info.num_info = {}

		local role_info_it = notice_info._role_info:SeekToBegin()
		local role_info = role_info_it:GetValue()
		while role_info ~= nil do
			local tmp_role_info = {}
			tmp_role_info.id = role_info._id:ToStr()
			tmp_role_info.name = role_info._name
			
			tmp_notice_info.role_info[#tmp_notice_info.role_info+1] = tmp_role_info
			role_info_it:Next()
			role_info = role_info_it:GetValue()
		end

		local num_info_it = notice_info._num_info:SeekToBegin()
		local num_info = num_info_it:GetValue()
		while num_info ~= nil do
			tmp_notice_info.num_info[#tmp_notice_info.num_info+1] = num_info._value

			num_info_it:Next()
			num_info = num_info_it:GetValue()
		end

		ret.notice[#ret.notice+1] = tmp_notice_info
		notice_info_it:Next()
		notice_info = notice_info_it:GetValue()
	end

	return ret
end

function MAFIA_UpdateSelfInfo(role)
	local update_resp = NewCommand("MafiaUpdateSelfInfo")
	update_resp.mafia_info = {}

	update_resp.mafia_info.id = role._roledata._mafia._id:ToStr()
	update_resp.mafia_info.name = role._roledata._mafia._name
	update_resp.mafia_info.position = role._roledata._mafia._position
	update_resp.mafia_info.apply_mafia = {}

	local apply_info_it = role._roledata._mafia._apply_mafia:SeekToBegin()
	local apply_info = apply_info_it:GetValue()
	while apply_info ~= nil do
		update_resp.mafia_info.apply_mafia[#update_resp.mafia_info.apply_mafia+1] = apply_info:ToStr()
	
		apply_info_it:Next()
		apply_info = apply_info_it:GetValue()
	end

	role:SendToClient(SerializeCommand(update_resp))
end

--1代表给所有的玩家发
function MAFIA_BroadcastMsg(mafia, msg, all_member)
	--在这里会进行判断是否在线
	local mafia_member_it = mafia._member_map:SeekToBegin()
	local mafia_member = mafia_member_it:GetValue()
	while mafia_member ~= nil do
		if all_member == 1 then
			API_SendMsg(mafia_member._id:ToStr(), msg, 0)
		else
			if mafia_member._online == 1 then
				API_SendMsg(mafia_member._id:ToStr(), msg, 0)
			end
		end

		mafia_member_it:Next()
		mafia_member = mafia_member_it:GetValue()
	end

end

function MAFIA_MafiaAddApply(mafia, apply_info)
	--扔一个消息去处理
	local msg = NewMessage("MafiaAddNewApply")

	msg.apply_info = {}

	msg.apply_info.id = apply_info.id:ToStr()
	msg.apply_info.name = apply_info.name
	msg.apply_info.photo = apply_info.photo
	msg.apply_info.level = apply_info.level
	msg.apply_info.zhanli = apply_info.zhanli
	msg.apply_info.photo_frame = apply_info.photo_frame
	msg.apply_info.sex = apply_info.sex
	msg.apply_info.badge_info = apply_info.badge_info

	MAFIA_BroadcastMsg(mafia, SerializeMessage(msg), 0)
end

function MAFIA_MafiaDelApply(mafia, apply_id)
	local msg = NewMessage("MafiaDelNewApply")

	msg.id = apply_id

	MAFIA_BroadcastMsg(mafia, SerializeMessage(msg), 0)
end

function MAFIA_MafiaAddMember(mafia, insert_mafia_member)
	--扔一个消息去处理
	local msg = NewMessage("MafiaAddMember")
	msg.member_info = {}
	msg.member_info.id = insert_mafia_member._id:ToStr()
	msg.member_info.name = insert_mafia_member._name
	msg.member_info.photo = insert_mafia_member._photo
	msg.member_info.level = insert_mafia_member._level
	msg.member_info.activity = insert_mafia_member._activity
	msg.member_info.zhanli = insert_mafia_member._zhanli
	msg.member_info.position = insert_mafia_member._position
	msg.member_info.logout_time = insert_mafia_member._logout_time
	msg.member_info.online = insert_mafia_member._online
	msg.member_info.photo_frame = insert_mafia_member._photo_frame
	msg.member_info.sex = insert_mafia_member._sex
	msg.member_info.badge_info = {}
	
	local badge_info_it = insert_mafia_member._badge_map:SeekToBegin()
	local badge_info = badge_info_it:GetValue()
	while badge_info ~= nil do
		local tmp_badge_info = {}
		tmp_badge_info.id = badge_info._id
		tmp_badge_info.typ = badge_info._pos
		msg.member_info.badge_info[#msg.member_info.badge_info+1] = tmp_badge_info

		badge_info_it:Next()
		badge_info = badge_info_it:GetValue()
	end

	
	msg.member_info.contrabution = {}
	local contrabution_it = insert_mafia_member._week_contribution:SeekToBegin()
	local contrabution = contrabution_it:GetValue()
	while contrabution ~= nil do
		msg.member_info.contrabution[#msg.member_info.contrabution+1] = contrabution._value
		contrabution_it:Next()
		contrabution = contrabution_it:GetValue()
	end

	MAFIA_BroadcastMsg(mafia, SerializeMessage(msg), 0)
end

function MAFIA_MafiaUpdateMember(mafia, insert_mafia_member)
	--扔一个消息去处理
	local msg = NewMessage("MafiaUpdateMember")
	msg.member_info = {}
	msg.member_info.id = insert_mafia_member._id:ToStr()
	msg.member_info.name = insert_mafia_member._name
	msg.member_info.photo = insert_mafia_member._photo
	msg.member_info.level = insert_mafia_member._level
	msg.member_info.activity = insert_mafia_member._activity
	msg.member_info.zhanli = insert_mafia_member._zhanli
	msg.member_info.position = insert_mafia_member._position
	msg.member_info.logout_time = insert_mafia_member._logout_time
	msg.member_info.online = insert_mafia_member._online

	msg.member_info.contrabution = {}
	local contrabution_it = insert_mafia_member._week_contribution:SeekToBegin()
	local contrabution = contrabution_it:GetValue()
	while contrabution ~= nil do
		msg.member_info.contrabution[#msg.member_info.contrabution+1] = contrabution._value
		contrabution_it:Next()
		contrabution = contrabution_it:GetValue()
	end
	MAFIA_BroadcastMsg(mafia, SerializeMessage(msg), 0)
end

function MAFIA_MafiaDelMember(mafia, del_id)
	--扔一个消息去处理
	local msg = NewMessage("MafiaDelMember")
	msg.id = del_id:ToStr()

	MAFIA_BroadcastMsg(mafia, SerializeMessage(msg), 0)
end

function MAFIA_MafiaUpdateInterfaceInfo(mafia)
	--扔一个消息去处理
	local msg = NewMessage("MafiaUpdateInterfaceInfo")

	msg.info = {}
	msg.info.id = mafia._id:ToStr()
	msg.info.name = mafia._name
	msg.info.flag = mafia._flag
	msg.info.announce = mafia._announce
	msg.info.activity = mafia._activity
	msg.info.boss_id = mafia._boss_id:ToStr()
	msg.info.boss_name = mafia._boss_name
	msg.info.level_limit = mafia._level_limit
	msg.info.need_approval = mafia._need_approval
	msg.info.declaration = mafia._declaration

	MAFIA_BroadcastMsg(mafia, SerializeMessage(msg), 0)
end

function MAFIA_MafiaUpdateExp(mafia)
	--扔一个消息去处理
	local msg = NewMessage("MafiaUpdateExp")

	msg.jisi = mafia._jisi
	msg.exp = mafia._exp
	msg.level = mafia._level

	MAFIA_BroadcastMsg(mafia, SerializeMessage(msg), 0)
end

function MAFIA_MafiaUpdateJiSi(mafia, jisi)
	--扔一个消息去处理
	local msg = NewMessage("MafiaUpdateJiSi")

	msg.jisi = jisi

	MAFIA_BroadcastMsg(mafia, SerializeMessage(msg), 1)
end

function MAFIA_MafiaSendMail(mafia, mail_id)
	--扔一个消息去处理
	local msg = NewMessage("SendMail")

	msg.mail_id = mail_id

	MAFIA_BroadcastMsg(mafia, SerializeMessage(msg), 1)
end

function MAFIA_MafiaUpdateNotice(mafia, notice_info)

	local msg = NewMessage("MafiaUpdateNoticeInfo")
	msg.notice_info = {}
	msg.notice_info.num_info = {}
	msg.notice_info.role_info = {}

	msg.notice_info.id = notice_info._id
	msg.notice_info.typ = notice_info._typ
	msg.notice_info.time = notice_info._time
	local numinfo_it = notice_info._num_info:SeekToBegin()
	local numinfo = numinfo_it:GetValue()
	while numinfo ~= nil do
		msg.notice_info.num_info[#msg.notice_info.num_info+1] = numinfo._value
		numinfo_it:Next()
		numinfo = numinfo_it:GetValue()
	end

	local role_info_it = notice_info._role_info:SeekToBegin()
	local role_info = role_info_it:GetValue()
	while role_info ~= nil do
		local tmp_role_info = {}
		tmp_role_info.id = role_info._id:ToStr()
		tmp_role_info.name = role_info._name
		msg.notice_info.role_info[#msg.notice_info.role_info+1] = tmp_role_info

		role_info_it:Next()
		role_info = role_info_it:GetValue()
	end
	
	MAFIA_BroadcastMsg(mafia, SerializeMessage(msg), 0)
end

function MAFIA_MafiaBangZhuSendMail(mafia, mail_info)
	--扔一个消息去处理
	local msg = NewMessage("MafiaBangZhuSendMail")

	msg.id = mail_info.id
	msg.name = mail_info.name
	msg.subject = mail_info.subject
	msg.context = mail_info.context

	MAFIA_BroadcastMsg(mafia, SerializeMessage(msg), 1)
end

function MAFIA_MafiaUpdateInfoTop(mafia_info, level_flag)
	--扔一个消息去处理
	local msg = NewMessage("UpdateMafiaInfoTop")
	
	msg.level_flag = level_flag
	msg.id = mafia_info._id:ToStr()
	msg.name = mafia_info._name
	msg.announce = mafia_info._announce
	msg.declaration = mafia_info._declaration
	msg.level = mafia_info._level
	msg.boss_id = mafia_info._boss_id:ToStr()
	msg.boss_name = mafia_info._boss_name
	msg.level_limit = mafia_info._level_limit
	msg.num = mafia_info._member_map:Size()

	API_SendMsg("0", SerializeMessage(msg), 0)
end
