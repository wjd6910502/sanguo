function OnCommand_MafiaQuit(player, role, arg, others)
	player:Log("OnCommand_MafiaQuit, "..DumpTable(arg))

	--����Լ��˳����
	local mafia_data = others.mafias[role._roledata._mafia._id:ToStr()]
	local resp = NewCommand("MafiaQuit_Re")
	resp.id = arg.id

	if mafia_data == nil then
		resp.retcode = G_ERRCODE["NO_MAFIA"]
		player:SendToClient(SerializeCommand(resp))
		player:Log("OnCommand_MafiaQuit, error=NO_MAFIA")
		return
	end

	local mafia_info = mafia_data._data
	--����˳������Ȳ鿴�Լ��Ƿ��а��
	--if role._roledata._mafia._id:ToStr() == "0" or role._roledata._mafia._name == "" then
	--	resp.retcode = G_ERRCODE["MAFIA_QUIT_NO_MAFIA"]
	--	player:SendToClient(SerializeCommand(resp))
	--	return
	--end

	--�鿴�Լ��Ƿ��ǰ���������ǰ����Ļ��������������������˳���ᣬ
	--����������ǰ������һ���ˣ���ô�����˳����˳�ȥ�Ժ���ͻ�ֱ�ӽ�ɢ
	if role._roledata._mafia._position == 1 and mafia_info._member_map:Size() > 1 then
		resp.retcode = G_ERRCODE["MAFIA_QUIT_BANGZHU_ERR"]
		player:SendToClient(SerializeCommand(resp))
		player:Log("OnCommand_MafiaQuit, error=MAFIA_QUIT_BANGZHU_ERR")
		return
	end

	mafia_info._member_map:Delete(role._roledata._base._id)

	--�����Լ���ͷ����µ���Ϣ
	if role._roledata._mafia._position == G_MAFIA_POSITION["BANGZHU"] then
		ROLE_UpdateBadge(role, 1, 1, 0)
	elseif role._roledata._mafia._position == G_MAFIA_POSITION["JUNSHI"] then
		ROLE_UpdateBadge(role, 1, 2, 0)
	end
	role._roledata._mafia._create_time = 0
	role._roledata._mafia._id:Set("0")
	role._roledata._mafia._name = ""
	role._roledata._mafia._position = 0
	role._roledata._mafia._invites:Clear()
	role._roledata._mafia._apply_mafia:Clear()

	--�����Լ�����Ϣ
	MAFIA_UpdateSelfInfo(role)

	--����Լ����������ִ���0�Ļ�����ô��Ҫ���Լ��Ӱ������а��������
	if role._roledata._mashu_info._today_max_score > 0 then
		local msg = NewMessage("TestDeleteTop")
		msg.id = mafia_info._mashu_toplist_id
		player:SendMessage(role._roledata._base._id, SerializeMessage(msg))
	
		mafia_info._all_mashu_score = mafia_info._all_mashu_score - role._roledata._mashu_info._today_max_score
		local msg = NewMessage("RoleUpdateMafiaMaShuScore")
		player:SendMessage(mafia_info._id, SerializeMessage(msg))
	end
	
	if mafia_info._member_map:Size() == 0 then
		--���ð����ɾ��״̬���������Ϣ�������޸ģ����ó����״̬�Ժ���Ҿ��޷����������������
		mafia_info._deleted = 1

		--ɾ�������������а�
		local msg = NewMessage("MafiaDeleteTopList")
		msg.id =mafia_info._mashu_toplist_id
		player:SendMessage(CACHE.Int64(0), SerializeMessage(msg))

		--���Լ��Ӱ��ļ�����Ϣ��ɾ����
		msg = NewMessage("DeleteMafiaInfoTop")
		msg.level = mafia_info._level
		msg.id = mafia_info._id:ToStr()
		player:SendMessage(CACHE.Int64(0), SerializeMessage(msg))
	else
		--�����������Ҫ֪ͨ�����һ������˳��˰�����
		MAFIA_MafiaDelMember(mafia_info, role._roledata._base._id)
		--���°�����Ϣ�����װ�����ȥ
		MAFIA_MafiaUpdateInfoTop(mafia_info, 0)
	end

	TASK_ChangeCondition(role, G_ACH_TYPE["MAFIA_QUIT"], 0, -1)
	resp.retcode = G_ERRCODE["SUCCESS"]
	player:SendToClient(SerializeCommand(resp))
end
