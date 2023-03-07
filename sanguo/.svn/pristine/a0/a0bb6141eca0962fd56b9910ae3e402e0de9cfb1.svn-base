function MAFIA_MakeMafia(mafia)
	local ret = {}
	ret.id = mafia._id:ToStr()
	ret.name = mafia._name
	ret.flag = mafia._flag
	ret.announce = mafia._announce
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
		m2.level = m._level
		m2.activity = m._activity
		m2.position = m._position
		m2.logout_time = m._logout_time
		m2.online = m._online
		m2.zhanli = m._zhanli
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
		tmp_notice_info.role_info = {}
		
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

	msg.id = apply_info.id:ToStr()
	msg.name = apply_info.name
	msg.photo = apply_info.photo
	msg.level = apply_info.level
	msg.zhanli = apply_info.zhanli

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
