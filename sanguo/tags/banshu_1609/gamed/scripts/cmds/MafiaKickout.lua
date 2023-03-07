function OnCommand_MafiaKickout(player, role, arg, others)
	player:Log("OnCommand_MafiaKickout, "..DumpTable(arg))

	--��ĳһ������߳�ȥ���,������Ҫע�ⱻ�߳�ȥ����Ҳ�һ�������ҵ�
	--����Ҫ�԰���е���ϢΪ׼��ֻҪ�����ҵ����Ϳ��԰����ߵ���
	--Ȼ�������ǰ�����ҵ���ҵĻ���������ҵ���Ϣ��
	--Ҫ��û���ҵ��Ļ����͵�����Լ����ߵ�ʱ��ȥ������Ϣ
	local mafia_data = others.mafias[role._roledata._mafia._id:ToStr()]
	local dest_role = others.roles[arg.role_id]
	local resp = NewCommand("MafiaKickout_Re")

	--���Ȳ������Լ��߳��Լ���
	if arg.role_id == role._roledata._base._id:ToStr() then
		resp.retcode = G_ERRCODE["MAFIA_KICKOUT_NO_SELF"]
		player:SendToClient(SerializeCommand(resp))
		return
	end

	if mafia_data == nil then
		resp.retcode = G_ERRCODE["NO_MAFIA"]
		player:SendToClient(SerializeCommand(resp))
		return
	end

	local mafia_info = mafia_data._data

	if role._roledata._mafia._position ~= G_MAFIA_POSITION["BANGZHU"] and role._roledata._mafia._position ~= G_MAFIA_POSITION["JUNSHI"] then
		resp.retcode = G_ERRCODE["MAFIA_SET_LEVEL_ERR"]
		player:SendToClient(SerializeCommand(resp))
		return
	end

	--�鿴��ǰ������Ƿ���������
	local find_member = mafia_info._member_map:Find(CACHE.Int64(arg.role_id))
	if find_member == nil then
		resp.retcode = G_ERRCODE["MAFIA_KICKOUT_NO_ROLE"]
		player:SendToClient(SerializeCommand(resp))
		return
	end

	--�鿴�Լ��Ƿ���Ȩ���߳�������
	if role._roledata._mafia._position >= find_member._position then
		resp.retcode = G_ERRCODE["MAFIA_KICKOUT_NO_POWER"]
		player:SendToClient(SerializeCommand(resp))
		return
	end

	--������ֱ�Ӱ�������ɾ����Ȼ��㲥������е���
	mafia_info._member_map:Delete(CACHE.Int64(arg.role_id))

	MAFIA_MafiaDelMember(mafia_info, CACHE.Int64(arg.role_id))

	--������鿴�Ƿ��ҵ��������ң��ҵ��˵Ļ��ͽ��в�����û���ҵ��Ͳ��ù���
	if dest_role ~= nil then
		--�޸�ͷ����µ���Ϣ
		if dest_role._roledata._mafia._position == G_MAFIA_POSITION["JUNSHI"] then
			ROLE_UpdateBadge(role, 1, 2, 0)
		end
		
		dest_role._roledata._mafia._create_time = 0
		dest_role._roledata._mafia._id:Set("0")
		dest_role._roledata._mafia._name = ""
		dest_role._roledata._mafia._position = 0
		dest_role._roledata._mafia._invites:Clear()
		dest_role._roledata._mafia._apply_mafia:Clear()
		MAFIA_UpdateSelfInfo(dest_role)
		TASK_ChangeCondition(dest_role, G_ACH_TYPE["MAFIA_QUIT"], 0, -1)

		--�鿴�����ҵ��������֣��������0�Ļ�����Ҫȥɾ���������ҵ������Ϣ
		if dest_role._roledata._mashu_info._today_max_score > 0 then
			local msg = NewMessage("TestDeleteTop")
			msg.id = mafia_info._mashu_toplist_id
			API_SendMsg(dest_role._roledata._base._id:ToStr(), SerializeMessage(msg), 0)
	
			mafia_info._all_mashu_score = mafia_info._all_mashu_score - role._roledata._mashu_info._today_max_score
			local msg = NewMessage("RoleUpdateMafiaMaShuScore")
			player:SendMessage(mafia_info._id, SerializeMessage(msg))
		end

		--�������ҷ��ͱ��߳�ȥ���ʼ�
		local msg = NewMessage("SendMail")
		msg.mail_id = 1801
		player:SendMessage(dest_role._roledata._base._id, SerializeMessage(msg))
	end
end