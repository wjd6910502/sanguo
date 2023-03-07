function OnCommand_TongQueTaiFinish(player, role, arg, others)
	player:Log("OnCommand_TongQueTaiFinish, "..DumpTable(arg).." "..DumpTable(others))

	if role._roledata._status._time_line ~= G_ROLE_STATE["TONGQUETAI"] then
		return
	end

	local dest_role1 = others.roles[arg.role_id1]
	local dest_role2 = others.roles[arg.role_id2]
	local tongquetai = others.tongquetai._data
	
	local resp = NewCommand("TongQueTaiFinish_Re")
	resp.win_flag = arg.win_flag
	resp.hero_info = arg.hero_info
	resp.monster_info = arg.monster_info
	local match_data = tongquetai._match_data:Find(role._roledata._tongquetai_data._cur_tongquetai_id)
	resp.monster_index = match_data._cur_monster_index

	local role_info_it = match_data._role_info:SeekToBegin()
	local index = 1
	local role_info = role_info_it:GetValue()
	while role_info ~= nil do
		if role_info._role_base._id:ToStr() == role._roledata._base._id:ToStr() then
			--������ֱ��return,�϶���������������
			if index ~= match_data._cur_fight_role then
				return
			else
				break
			end
		end
		index = index + 1
		role_info_it:Next()
		role_info = role_info_it:GetValue()
	end
	--��������ȸ��ͻ��˰�Э�鷢��ȥ
	dest_role1:SendToClient(SerializeCommand(resp))
	dest_role2:SendToClient(SerializeCommand(resp))
	role:SendToClient(SerializeCommand(resp))
	
	local monster_list_info = match_data._defence_info:Find(match_data._cur_monster_index)
	--������ֶ����ó�����״̬
	for index = 1, table.getn(arg.monster_info) do
		local monster_info_it = monster_list_info._hero_info:SeekToBegin()
		local monster_info = monster_info_it:GetValue()
		while monster_info ~= nil do
			if monster_info._heroid == arg.monster_info[index].id then
				monster_info._cur_hp = arg.monster_info[index].hp
				monster_info._cur_anger = arg.monster_info[index].anger
				monster_info._alive_flag = arg.monster_info[index].alive_flag
				break
			end
			monster_info_it:Next()
			monster_info = monster_info_it:GetValue()
		end
	end
	--������ҵ��佫��״̬
	local player_info = match_data._role_info:Find(match_data._cur_fight_role)
	for index = 1, table.getn(arg.hero_info) do
		local hero_info_it = player_info._hero_info:SeekToBegin()
		local hero_info = hero_info_it:GetValue()
		while hero_info ~= nil do
			if hero_info._heroid == arg.hero_info[index].id then
				hero_info._cur_hp = arg.hero_info[index].hp
				hero_info._cur_anger = arg.hero_info[index].anger
				hero_info._alive_flag = arg.hero_info[index].alive_flag
				break
			end

			hero_info_it:Next()
			hero_info = hero_info_it:GetValue()
		end
	end
	--��������Ҫ�жϣ�Ӯ�˻���ֱ�Ӵ���һ�������˵Ļ���һ����ҿ�ʼ��
	--������Ҫע�⣬��Ϊ�п����������ֱ�ӻ�ʤ�ˡ�
	if role._roledata._tongquetai_data._cur_state == 2 then
		if arg.win_flag == 1 then
			--�ж��Ƿ�����һ��������
			if match_data._cur_monster_index == match_data._defence_info:Size() then
				--���ͻ��˷���һ����Ϣ���ɹ�������ͭȸ̨��������ʾ�ͻ��˿�����ȡͭȸ̨������
				local resp = NewCommand("TongQueTaiEnd")
				resp.retcode = G_ERRCODE["SUCCESS"]
				
				--��Ҫ����ͭȸ̨ɾ��������
				tongquetai._join_role:Delete(role._roledata._base._id)
				tongquetai._join_role:Delete(dest_role1._roledata._base._id)
				tongquetai._join_role:Delete(dest_role2._roledata._base._id)
				local insert_id = CACHE.Int()
				insert_id._value = role._roledata._tongquetai_data._cur_tongquetai_id
				tongquetai._del_list:PushBack(insert_id)

				role._roledata._tongquetai_data._cur_tongquetai_id = 0
				role._roledata._tongquetai_data._cur_state = 0
				role._roledata._tongquetai_data._reward_flag = 1

				dest_role1._roledata._tongquetai_data._cur_tongquetai_id = 0
				dest_role1._roledata._tongquetai_data._cur_state = 0
				dest_role1._roledata._tongquetai_data._reward_flag = 1

				dest_role2._roledata._tongquetai_data._cur_tongquetai_id = 0
				dest_role2._roledata._tongquetai_data._cur_state = 0
				dest_role2._roledata._tongquetai_data._reward_flag = 1
				
				dest_role1:SendToClient(SerializeCommand(resp))
				dest_role2:SendToClient(SerializeCommand(resp))
				role:SendToClient(SerializeCommand(resp))

			else
				--��������������״̬��Ȼ����ʾ�ͻ��˽������е�����
				match_data._cur_monster_index = match_data._cur_monster_index + 1
				match_data._cur_state = 0
				match_data._time = API_GetTime()
				
				local resp = NewCommand("TongQueTaiReLoad")
				resp.retcode = G_ERRCODE["TONGQUETAI_ATTACK_SUCCESS"]
				resp.role_index = match_data._cur_fight_role
				resp.monster_index = match_data._cur_monster_index
				
				dest_role1:SendToClient(SerializeCommand(resp))
				dest_role2:SendToClient(SerializeCommand(resp))
				role:SendToClient(SerializeCommand(resp))
			end
		else
			--ʧ���ˣ��������ݵ���֤
			if match_data._cur_fight_role == match_data._role_info:Size() then
				--���ͻ��˷���һ����Ϣ�����ǳ�Աȫ�������ˣ����ͭȸ̨ʧ��
				local resp = NewCommand("TongQueTaiEnd")
				resp.retcode = G_ERRCODE["TONGQUETAI_FAIL_ALL_DEAD"]
				
				--��Ҫ����ͭȸ̨ɾ��������
				tongquetai._join_role:Delete(role._roledata._base._id)
				tongquetai._join_role:Delete(dest_role1._roledata._base._id)
				tongquetai._join_role:Delete(dest_role2._roledata._base._id)
				local insert_id = CACHE.Int()
				insert_id._value = role._roledata._tongquetai_data._cur_tongquetai_id
				tongquetai._del_list:PushBack(insert_id)
				
				role._roledata._tongquetai_data._cur_tongquetai_id = 0
				role._roledata._tongquetai_data._cur_state = 0
				role._roledata._tongquetai_data._double_flag = 0

				dest_role1._roledata._tongquetai_data._cur_tongquetai_id = 0
				dest_role1._roledata._tongquetai_data._cur_state = 0
				dest_role1._roledata._tongquetai_data._double_flag = 0

				dest_role2._roledata._tongquetai_data._cur_tongquetai_id = 0
				dest_role2._roledata._tongquetai_data._cur_state = 0
				dest_role2._roledata._tongquetai_data._double_flag = 0
				
				dest_role1:SendToClient(SerializeCommand(resp))
				dest_role2:SendToClient(SerializeCommand(resp))
				role:SendToClient(SerializeCommand(resp))
			else
				--��������������״̬��Ȼ����ʾ�ͻ��˽������е�����
				match_data._cur_fight_role = match_data._cur_fight_role + 1
				match_data._cur_state = 0
				match_data._time = API_GetTime()
				
				local resp = NewCommand("TongQueTaiReLoad")
				resp.retcode = G_ERRCODE["TONGQUETAI_ATTACK_SUCCESS"]
				resp.role_index = match_data._cur_fight_role
				resp.monster_index = match_data._cur_monster_index
				
				dest_role1:SendToClient(SerializeCommand(resp))
				dest_role2:SendToClient(SerializeCommand(resp))
				role:SendToClient(SerializeCommand(resp))
			end
		end
	end

	--�鿴���������ӣ�׼�����������֤
	--arg.operations
	--role._roledata._status._fight_seed
	role._roledata._status._time_line = G_ROLE_STATE["FREE"]
end