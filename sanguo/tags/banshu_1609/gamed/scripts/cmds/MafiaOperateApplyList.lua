function OnCommand_MafiaOperateApplyList(player, role, arg, others)
	player:Log("OnCommand_MafiaOperateApplyList, "..DumpTable(arg).." "..DumpTable(others))

	local mafia_data = others.mafias[role._roledata._mafia._id:ToStr()]
	local dest_role = others.roles[arg.role_id]

	local resp = NewCommand("MafiaOperateApplyList_Re")

	resp.accept = arg.accept
	resp.role_id = arg.role_id
	resp.mafia_id = arg.mafia_id

	if mafia_data == nil then
		resp.retcode = G_ERRCODE["NO_MAFIA"]
		player:SendToClient(SerializeCommand(resp))
		return
	end

	local mafia_info = mafia_data._data

	if role._roledata._mafia._position ~= 1 and role._roledata._mafia._position ~= 2 then
		resp.retcode = G_ERRCODE["MAFIA_SET_LEVEL_ERR"]
		player:SendToClient(SerializeCommand(resp))
		return
	end

	--�鿴����Ƿ��������б�����
	local have_flag = false
	local apply_info_it = mafia_info._applylist:SeekToBegin()
	local apply_info = apply_info_it:GetValue()
	while apply_info ~= nil do
		if apply_info._id:Equal(arg.role_id) then
			have_flag = true
			break
		end

		apply_info_it:Next()
		apply_info = apply_info_it:GetValue()
	end

	if have_flag == false then
		resp.retcode = G_ERRCODE["MAFIA_ACCEPT_NO_MEMBER"]
		player:SendToClient(SerializeCommand(resp))
		return
	end

	--�ߵ����ﲻ����ô��һ�������Ҵ������б��������
	local apply_info_it = mafia_info._applylist:SeekToBegin()
	local apply_info = apply_info_it:GetValue()
	while apply_info ~= nil do
		if apply_info._id:Equal(arg.role_id) then
			apply_info_it:Pop()
			break
		end
		apply_info_it:Next()
		apply_info = apply_info_it:GetValue()
	end

	MAFIA_MafiaDelApply(mafia_info, arg.role_id)

	--�����Ҳ����ڣ�ֱ�Ӹ��߿ͻ�����Ҳ����ڣ�Ȼ��ֱ�Ӱ���Ҵ��������ɾ����
	if dest_role == nil then
		resp.retcode = G_ERRCODE["MAFIA_ACCEPT_NO_ROLE"]
		player:SendToClient(SerializeCommand(resp))
		return
	end

	--ֻ��ͬ�����Ҫ�����飬�ܾ���Ҫ����ǰ���Ѿ������˴�����
	if arg.accept == 1 then
		--�鿴����Ƿ��Ѿ����˰��
		if dest_role._roledata._mafia._id:ToStr() ~= "0" then
			--MAFIA_MafiaDelApply(mafia_info, arg.role_id)
			resp.retcode = G_ERRCODE["MAFIA_ACCEPT_HAVE_MAFIA"]
			player:SendToClient(SerializeCommand(resp))
			return
		end

		--�鿴��������Ƿ�ﵽ������
		local ed = DataPool_Find("elementdata")
		local league_level_info = ed:FindBy("league_level", mafia_info._level)
		if mafia_info._member_map:Size() >= league_level_info.member_num then
			resp.retcode = G_ERRCODE["MAFIA_ACCEPT_MEMBER_MAX"]
			player:SendToClient(SerializeCommand(resp))
			return
		end

		--�������ӽ���
		local insert_mafia_member = CACHE.MafiaMember()
		insert_mafia_member._id = dest_role._roledata._base._id
		insert_mafia_member._name = dest_role._roledata._base._name
		insert_mafia_member._photo = dest_role._roledata._base._photo
		insert_mafia_member._photo_frame = dest_role._roledata._base._photo_frame
		insert_mafia_member._badge_map = dest_role._roledata._base._badge_map
		insert_mafia_member._sex = dest_role._roledata._base._sex
		insert_mafia_member._level = dest_role._roledata._status._level
		insert_mafia_member._activity = 0
		insert_mafia_member._zhanli = dest_role._roledata._status._zhanli
		insert_mafia_member._contribution = 0
		insert_mafia_member._position = G_MAFIA_POSITION["PINGMIN"]
		insert_mafia_member._online = dest_role._roledata._status._online
		insert_mafia_member._join_time = API_GetTime()
		if insert_mafia_member._online == 0 then
			--��������߾�α��һ������ʱ��
			insert_mafia_member._logout_time = API_GetTime()
		end

		mafia_info._member_map:Insert(insert_mafia_member._id, insert_mafia_member)

		--���°���Ա��Ϣ
		MAFIA_MafiaAddMember(mafia_info, insert_mafia_member)

		--��������Լ�������
		dest_role._roledata._mafia._create_time = 0
		dest_role._roledata._mafia._id = mafia_info._id
		dest_role._roledata._mafia._name = mafia_info._name
		dest_role._roledata._mafia._position = insert_mafia_member._position
		dest_role._roledata._mafia._invites:Clear()
		dest_role._roledata._mafia._apply_mafia:Clear()
		MAFIA_UpdateSelfInfo(dest_role)
		--�����Լ��ļ���ɾ�
		TASK_ChangeCondition(dest_role, G_ACH_TYPE["MAFIA_JISI"], 0, mafia_info._jisi)
		--�ж��Լ����������֣�����������ֲ�Ϊ0�Ļ������Լ���һ����Ϣ�����Լ������������ϰ��������������а�
		if dest_role._roledata._mashu_info._today_max_score > 0 then
			local msg = NewMessage("RoleUpdateInfoMafiaTop")
			msg.mafia_id = role._roledata._mafia._id:ToStr()
			msg.data = role._roledata._mashu_info._today_max_score
			msg.score = role._roledata._mashu_info._today_max_score
			local mafia_list = CACHE.Int64List()
			mafia_list:PushBack(role._roledata._mafia._id)
			API_SendMessage(role._roledata._base._id, SerializeMessage(msg), CACHE.Int64List(), mafia_list, CACHE.IntList())
		end
		
		--���°�����Ϣ�����װ�����ȥ
		MAFIA_MafiaUpdateInfoTop(mafia_info, 0)
		
		--�������ҷ��ͽ�������ʼ�
		local msg = NewMessage("SendMail")
		msg.mail_id = 1802
		player:SendMessage(dest_role._roledata._base._id, SerializeMessage(msg))
	else
		--����ܾ��Ļ���������ϵ���������б������޸ġ�
		local apply_info_it = dest_role._roledata._mafia._apply_mafia:SeekToBegin()
		local apply_info = apply_info_it:GetValue()
		while apply_info ~= nil do
			if apply_info:ToStr() == role._roledata._mafia._id:ToStr() then
				apply_info_it:Pop()
				break
			end
			apply_info_it:Next()
			apply_info = apply_info_it:GetValue()
		end
		MAFIA_UpdateSelfInfo(dest_role)
	end
	resp.retcode = G_ERRCODE["SUCCESS"]
	player:SendToClient(SerializeCommand(resp))
end