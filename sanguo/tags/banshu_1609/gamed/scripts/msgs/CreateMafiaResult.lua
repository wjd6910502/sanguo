function OnMessage_CreateMafiaResult(player, role, arg, others)
	player:Log("OnMessage_CreateMafiaResult, "..DumpTable(arg).." "..DumpTable(others))

	local resp = NewCommand("MafiaCreate_Re")

	if arg.retcode == 0 then
		if role._roledata._mafia._id:ToStr()~="0" then
			resp.retcode = G_ERRCODE["MAFIA_HAVE"]
			player:SendToClient(SerializeCommand(resp))
			role._roledata._mafia._create_time = 0
			return
		elseif role._roledata._mafia._create_time ~= arg.create_time then
			--������ʲô�������Ϳ�����,��Ϊ�϶���������һ����Ϣ�����ģ���һ����Ϣ������ʱ��������һ���Ĵ���
			return
		end

		--�������а�
		local topdata = API_GetLuaTopList()._data
		local top = topdata._top_data
		
		local id = API_Mafia_AllocId()

		local data = CACHE.MafiaData()
		data._id = id
		data._name = arg.name
		data._level = 1
		data._boss_id = role._roledata._base._id
		data._boss_name = role._roledata._base._name
		data._mashu_toplist_id = topdata._top_list_type

		local member = CACHE.MafiaMember()
		member._id = role._roledata._base._id
		member._name = role._roledata._base._name
		member._photo = role._roledata._base._photo
		member._level = role._roledata._status._level
		member._zhanli = role._roledata._status._zhanli
		member._position = G_MAFIA_POSITION["BANGZHU"]
		member._online = role._roledata._status._online
		member._join_time = API_GetTime()
		data._member_map:Insert(member._id, member)

		resp.retcode = G_ERRCODE["SUCCESS"]
		resp.mafia = MAFIA_MakeMafia(data)
		player:SendToClient(SerializeCommand(resp))

		role._roledata._mafia._create_time = 0
		role._roledata._mafia._id = id
		role._roledata._mafia._name = arg.name
		role._roledata._mafia._position = member._position
		role._roledata._mafia._invites:Clear()
		role._roledata._mafia._apply_mafia:Clear()
		
		local top_list = CACHE.TopList()
		top_list._top_list_type = topdata._top_list_type
		top:Insert(topdata._top_list_type, top_list)
		topdata._top_list_type = topdata._top_list_type + 1

		--�ж��Լ����������֣�����������ֲ�Ϊ0�Ļ������Լ���һ����Ϣ�����Լ������������ϰ��������������а�
		if role._roledata._mashu_info._today_max_score > 0 then
			local msg = NewMessage("RoleUpdateInfoMafiaTop")
			msg.mafia_id = role._roledata._mafia._id:ToStr()
			msg.data = role._roledata._mashu_info._today_max_score
			msg.score = role._roledata._mashu_info._today_max_score
			local mafia_list = CACHE.Int64List()
			mafia_list:PushBack(role._roledata._mafia._id)
			API_SendMessage(role._roledata._base._id, SerializeMessage(msg), CACHE.Int64List(), mafia_list, CACHE.IntList())
		end

		--���°�����Ϣ�����װ�����ȥ
		MAFIA_MafiaUpdateInfoTop(data, 0)

		--�����Լ��İ����Ϣ���ͻ���
		MAFIA_UpdateSelfInfo(role)
	
		--�����Լ���ͷ�������Ϣ
		ROLE_UpdateBadge(role, 1, 1, 1)

		--ע���������һ��Ҫ�ŵ�����档��Ϊ�������û�����ع�����
		API_Mafia_Insert(id, data)

	elseif arg.retcode == 3 then
		role._roledata._mafia._create_time = 0
		resp.retcode = G_ERRCODE["MAFIA_NAME_USED"]
		player:SendToClient(SerializeCommand(resp))
		return
	else
		role._roledata._mafia._create_time = 0
		resp.retcode = G_ERRCODE["MAFIA_NAME_USED"]
		player:SendToClient(SerializeCommand(resp))
		return
	end

end