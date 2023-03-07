function OnMessage_RoleUpdateMafiaInfoLogin(player, role, arg, others)
	player:Log("OnMessage_RoleUpdateMafiaInfoLogin, "..DumpTable(arg).." "..DumpTable(others))

	--�鿴�Լ���ǰ�Ƿ�������������
	local mafia_data = others.mafias[role._roledata._mafia._id:ToStr()]	

	local mafia_info = mafia_data._data

	local find_member = mafia_info._member_map:Find(role._roledata._base._id)

	if find_member == nil then
		role._roledata._mafia._create_time = 0
		role._roledata._mafia._id:Set("0")
		role._roledata._mafia._name = ""
		role._roledata._mafia._position = 0
		role._roledata._mafia._invites:Clear()
		role._roledata._mafia._apply_mafia:Clear()

		--�������ҷ��ͱ��߳�ȥ���ʼ�
		local msg = NewMessage("SendMail")
		msg.mail_id = 1801
		player:SendMessage(role._roledata._base._id, SerializeMessage(msg))
	else
		--ְλ�ı�
		if role._roledata._mafia._position > find_member._position then
			local ed = DataPool_Find("elementdata")
			local league_position_info = ed:FindBy("league_position", find_member._position)
			--�������ҷ���ְλ�������ʼ�
			local msg = NewMessage("SendMail")
			msg.mail_id = 1800
			msg.arg1 = league_position_info.name
			player:SendMessage(role._roledata._base._id, SerializeMessage(msg))

			if role._roledata._mafia._position == G_MAFIA_POSITION["BANGZHU"] then
				local badge_info = CACHE.BadgeInfo()
				badge_info._id = 1
				badge_info._pos = 1
				role._roledata._base._badge_map:Insert(badge_info._pos, badge_info)
			elseif role._roledata._mafia._position == G_MAFIA_POSITION["JUNSHI"] then
				local badge_info = CACHE.BadgeInfo()
				badge_info._id = 2
				badge_info._pos = 1
				role._roledata._base._badge_map:Insert(badge_info._pos, badge_info)
			end
		end
		
		role._roledata._mafia._name = mafia_info._name
		role._roledata._mafia._position = find_member._position
		--�����Լ��ļ���ɾ�
		TASK_ChangeCondition(role, G_ACH_TYPE["MAFIA_JISI"], 0, mafia_info._jisi)
	end

	MAFIA_UpdateSelfInfo(role)
end
