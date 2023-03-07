function OnMessage_TongQueTaiHeartBeat(arg, others)
	--API_Log("OnMessage_TongQueTaiHeartBeat, "..DumpTable(arg))
	
	local tongquetai = others.tongquetai._data
	
	local easy_difficulty = tongquetai._easy_difficulty
	local hard_difficulty = tongquetai._hard_difficulty
	
	local easy_count = 0
	local hard_count = 0

	local easy_difficulty_role_it = easy_difficulty:SeekToBegin()
	local easy_difficulty_role = easy_difficulty_role_it:GetValue()
	while easy_difficulty_role ~= nil do
		easy_count = easy_count + easy_difficulty_role:Size()

		easy_difficulty_role_it:Next()
		easy_difficulty_role = easy_difficulty_role_it:GetValue()
	end

	local hard_difficulty_role_it = hard_difficulty:SeekToBegin()
	local hard_difficulty_role = hard_difficulty_role_it:GetValue()
	while hard_difficulty_role ~= nil do
		hard_count = hard_count + hard_difficulty_role:Size()

		hard_difficulty_role_it:Next()
		hard_difficulty_role = hard_difficulty_role_it:GetValue()
	end

	if easy_count >= 3 then
		MatchPlayer(easy_difficulty)
	end

	if hard_count >= 3 then
		MatchPlayer(hard_difficulty)
	end

	--�Ѵ���Ľ���ɾ����ɾ����ʱ����Ҫ��ƥ���е����Ҳ����ɾ����,���Ұ���Ӧ����Ϣ�����޸�
	local del_list_it = tongquetai._del_list:SeekToBegin()
	local del_list = del_list_it:GetValue()
	while del_list ~= nil do
		tongquetai._match_data:Delete(del_list._value)
		
		del_list_it:Next()
		del_list = del_list_it:GetValue()
	end
	
	--��ƥ��ɹ������ݽ��в鿴
	--_cur_state 0�����ȴ����е���ҽ���Load���������30�뻹�����û��Load�꣬��ô�ͻ�ֱ�ӿ�ʼ
	--_cur_state 1��������ҷ��ͳ�ȥ�������д��������5�뻹û�и����������лظ�����ôֱ����Ϊ������
	--_cur_state 2�����������ս��״̬���������3���ӣ����������������ͽ�������Ϣ����ô������ֱ����Ϊ������
	local match_data_it = tongquetai._match_data:SeekToBegin()
	local match_data = match_data_it:GetValue()
	while match_data ~= nil do
		MatchDataState(tongquetai, match_data)
		
		match_data_it:Next()
		match_data = match_data_it:GetValue()
	end
end

function MatchDataState(tongquetai, match_data)
	if match_data._cur_state == 0 then
		--�鿴�Ƿ�ʱ�������Ƿ������е�����Ѿ�׼�����ˡ������ʱ������������Ѿ�׼�����ˣ���ô������ҿ�ʼ���д򣬽�����һ��״̬
		local cur_time = API_GetTime()
		local change_state =  false
		if (cur_time - match_data._time) > 30 then
			change_state = true
		end

		local load_finish = 0
		local role_info_it = match_data._role_info:SeekToBegin()
		local role_info = role_info_it:GetValue()
		while role_info ~= nil do
			if role_info._load_finish == 1 then
				load_finish = load_finish + 1
			end
			role_info_it:Next()
			role_info = role_info_it:GetValue()
		end

		if change_state == true or load_finish == 3 then
			local role_info_it = match_data._role_info:SeekToBegin()
			local role_info = role_info_it:GetValue()
			local index = 1
			while role_info ~= nil do
				if index == match_data._cur_fight_role then
					local msg = NewMessage("TongQueTaiNoticeRoleJoin")
					API_SendMessage(role_info._role_base._id, SerializeMessage(msg), CACHE.Int64List(), CACHE.Int64List(), CACHE.IntList())
					break
				end
				index = index + 1
				role_info_it:Next()
				role_info = role_info_it:GetValue()
			end

			--��������Ҫ�����޸ģ������е���ҵ�Load ״̬ȫ���޸ĳ�û��Load��״̬
			local role_info_it = match_data._role_info:SeekToBegin()
			local role_info = role_info_it:GetValue()
			while role_info ~= nil do
				role_info._load_finish = 0
				role_info_it:Next()
				role_info = role_info_it:GetValue()
			end
			
			match_data._cur_state = 1
			match_data._time = cur_time
		end
	elseif match_data._cur_state == 1 then
		local cur_time = API_GetTime()
		--����5�뻹û�и��������ؽ���ս������Ϣ��ֱ�Ӱ�����ҵ��ߴ���������һ����ҽ��в�������������һ����ҵĻ���ֱ�Ӱ���ʧ�������д���
		if (cur_time - match_data._time) > 5 then
			if match_data._cur_fight_role == match_data._role_info:Size() then
				--��������Ҫ֪ͨ��ҽ����ˡ�������ʧ����
				local role_info_it = match_data._role_info:SeekToBegin()
				local role_info = role_info_it:GetValue()
				while role_info ~= nil do
					local msg = NewMessage("TongQueTaiFail")
					API_SendMessage(role_info._role_base._id, SerializeMessage(msg), CACHE.Int64List(), CACHE.Int64List(), CACHE.IntList())
				
					--��ʼ����Щ�����ͭȸ̨�е����ݽ��д���
					tongquetai._join_role:Delete(role_info._role_base._id)
					role_info_it:Next()
					role_info = role_info_it:GetValue()
				end

				local insert_id = CACHE.Int()
				insert_id._value = match_data._tongquetai_id
				tongquetai._del_list:PushBack(insert_id)
			else
				--��������½���һ��Load��Ȼ���������������߼���
				--�����ٸ�ÿһ����ҷ���һ����Ϣ��������ң����˵��ߣ���������һ����ҿ�ʼ��
				match_data._cur_fight_role = match_data._cur_fight_role + 1
				match_data._cur_state = 0
				match_data._time = API_GetTime()
				local role_info_it = match_data._role_info:SeekToBegin()
				local role_info = role_info_it:GetValue()
				while role_info ~= nil do
					local msg = NewMessage("TongQueTaiReload")
					msg.retcode = G_ERRCODE["TONGQUETAI_PLAYER_DROP"]
					msg.role_index = match_data._cur_fight_role
					msg.monster_index = match_data._cur_monster_index
					API_SendMessage(role_info._role_base._id, SerializeMessage(msg), CACHE.Int64List(), CACHE.Int64List(), CACHE.IntList())
					
					role_info_it:Next()
					role_info = role_info_it:GetValue()
				end
			end
		end
	elseif match_data._cur_state == 2 then
		local cur_time = API_GetTime()
		--���ÿ���յ�operation�������޸ĵġ�
		if (cur_time - match_data._time) > 10 then
			if match_data._cur_fight_role == match_data._role_info:Size() then
				--��������Ҫ֪ͨ��ҽ����ˡ�������ʧ����
				local role_info_it = match_data._role_info:SeekToBegin()
				local role_info = role_info_it:GetValue()
				while role_info ~= nil do
					local msg = NewMessage("TongQueTaiFail")
					API_SendMessage(role_info._role_base._id, SerializeMessage(msg), CACHE.Int64List(), CACHE.Int64List(), CACHE.IntList())
				
					--��ʼ����Щ�����ͭȸ̨�е����ݽ��д���
					tongquetai._join_role:Delete(role_info._role_base._id)
					role_info_it:Next()
					role_info = role_info_it:GetValue()
				end

				local insert_id = CACHE.Int()
				insert_id._value = match_data._tongquetai_id
				tongquetai._del_list:PushBack(insert_id)
			else
				--��������½���һ��Load��Ȼ���������������߼���
				--�����ٸ�ÿһ����ҷ���һ����Ϣ��������ң����˵��ߣ���������һ����ҿ�ʼ��
				match_data._cur_fight_role = match_data._cur_fight_role + 1
				local role_info_it = match_data._role_info:SeekToBegin()
				local role_info = role_info_it:GetValue()
				while role_info ~= nil do
					local msg = NewMessage("TongQueTaiReload")
					msg.retcode = G_ERRCODE["TONGQUETAI_PLAYER_DROP"]
					msg.role_index = match_data._cur_fight_role
					msg.monster_index = match_data._cur_monster_index
					API_SendMessage(role_info._role_base._id, SerializeMessage(msg), CACHE.Int64List(), CACHE.Int64List(), CACHE.IntList())
					
					role_info_it:Next()
					role_info = role_info_it:GetValue()
				end
				match_data._cur_state = 0
				match_data._time = cur_time
			end
		end
	end
end

function MatchPlayer(difficulty_map)
	local target_player = CACHE.Int64()
	local lock_player = CACHE.Int64List()
	local tmp_player = CACHE.Int64()

	local difficulty_list_it = difficulty_map:SeekToBegin()
	local difficulty_list = difficulty_list_it:GetValue()
	while difficulty_list ~= nil do
		local difficulty_info_it = difficulty_list:SeekToBegin()
		local difficulty_info = difficulty_info_it:GetValue()
		while difficulty_info ~= nil do
			if difficulty_info._match_success == 0 then
				if target_player:Equal(0) then
					target_player = difficulty_info._role_base._id
				else
					lock_player:PushBack(difficulty_info._role_base._id)
				end
	
				difficulty_info._match_success = 1

				if lock_player:Size() == 2 then
					--��������һ����Ϣ
					local msg = NewMessage("TongQueTaiMatchSuccess")
					local tmp_roleid_it = lock_player:SeekToBegin()
					local tmp_roleid = tmp_roleid_it:GetValue()
					msg.player_roleid1 = tmp_roleid:ToStr()
					
					tmp_roleid_it:Next()
					tmp_roleid = tmp_roleid_it:GetValue()
					msg.player_roleid2 = tmp_roleid:ToStr()
					API_SendMessage(target_player, SerializeMessage(msg), lock_player, CACHE.Int64List(), CACHE.IntList())
					
					target_player = tmp_player
					lock_player:Clear()
				end
			end
			
			difficulty_info_it:Next()
			difficulty_info = difficulty_info_it:GetValue()
		end

		difficulty_list_it:Next()
		difficulty_list = difficulty_list_it:GetValue()
	end
end