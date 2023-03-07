--����ű���������ҵ����а�,Ŀǰ������а�ֻ�����������ʹ�ã��ͻ����ǲ�֪����������Ĵ��ڵ�
function TOP_ALL_Role_UpdateData(top,toptype,roleid,name,photoid,level,mafia_name,new_data,old_data)
	--��������ȶ�֮ǰ��ֵ����ɾ����Ȼ���ٽ�������
	API_Log("new_data="..new_data.."     old_data="..old_data)
	if new_data == 0 then
		return
	end

	if new_data == old_data then
		return
	end

	local toplist = top:Find(toptype)
	if toplist == nil then
		return
	end

	local toplist_data = toplist._data_map
	--��ʼɾ��
	if old_data ~= 0 then
		local toplist_data_info_it = toplist_data:SeekToBegin()
		local toplist_data_info = toplist_data_info_it:GetValue()
		while toplist_data_info ~= nil do
			local role_score = old_data
			if role_score >= toplist_data_info._begin_score and role_score <= toplist_data_info._end_score then
				local toplist_role_list = toplist_data_info._toplist_data_map:Find(role_score)
				if toplist_role_list ~= nil then
					API_Log("111111111111    toplist_role_list._score = "..toplist_role_list._score)
					API_Log("222222222222    toplist_role_list._list_data:Size() = "..toplist_role_list._list_data:Size())
					local toplist_role_list_info_it = toplist_role_list._list_data:SeekToBegin()
					local toplist_role_list_info = toplist_role_list_info_it:GetValue()
					while toplist_role_list_info ~= nil do
						if toplist_role_list_info._role_id:ToStr() == roleid:ToStr() then
							toplist._all_num = toplist._all_num - 1
							toplist_data_info._cur_num = toplist_data_info._cur_num - 1
							toplist_role_list_info_it:Pop()
							break
						end

						toplist_role_list_info_it:Next()
						toplist_role_list_info = toplist_role_list_info_it:GetValue()
					end
				else
					API_Log("TOP_ALL_Role_UpdateData   TOP_ALL_Role_UpdateData   ERR")
				end
				break
			end
			toplist_data_info_it:Next()
			toplist_data_info = toplist_data_info_it:GetValue()
		end
	end
	
	--��ʼ����
	toplist._all_num = toplist._all_num + 1

	local step_num = 200
	local insert_flag = 1
	local minimum = 0
	if toplist_data:Size() == 0 then
		--��һ��Ͱ��Ū���Ե�һ����ҵķ�����Ϊ��׼��ǰ���200�ķ�Χ
		local data = CACHE.TopListAllRoleData()
		data._begin_score = new_data - step_num
		data._end_score = new_data + step_num
		if data._begin_score < 0 then
			data._begin_score = 0
		end
		data._cur_num = 1

		local role_top_data = CACHE.RoleTopListData()
		role_top_data._role_id = roleid
		role_top_data._name = name
		role_top_data._level = level
		role_top_data._photoid = photoid
		role_top_data._mafia_name = mafia_name

		local role_top_list = CACHE.RoleTopListDataMapData()
		role_top_list._score = new_data
		role_top_list._list_data:PushBack(role_top_data)
		
		data._toplist_data_map:Insert(new_data, role_top_list)
		
		toplist_data:Insert(data._begin_score, data)
		insert_flag = 0
	else
		local toplist_data_info_it = toplist_data:SeekToBegin()
		local toplist_data_info = toplist_data_info_it:GetValue()
		while toplist_data_info ~= nil do
			local role_score = new_data
			if role_score < toplist_data_info._begin_score and role_score > minimum then
				--˵��������������滹��û���˵�
				local data = CACHE.TopListAllRoleData()
				data._begin_score = minimum
				data._end_score = toplist_data_info._begin_score - 1
				data._cur_num = 1

				local role_top_data = CACHE.RoleTopListData()
				role_top_data._role_id = roleid
				role_top_data._name = name
				role_top_data._level = level
				role_top_data._photoid = photoid
				role_top_data._mafia_name = mafia_name

				local role_top_list = CACHE.RoleTopListDataMapData()
				role_top_list._score = new_data
				role_top_list._list_data:PushBack(role_top_data)
				
				data._toplist_data_map:Insert(new_data, role_top_list)
				
				toplist_data:Insert(data._begin_score, data)
				insert_flag = 0
				break
			elseif role_score >= toplist_data_info._begin_score and role_score <= toplist_data_info._end_score then
				toplist_data_info._cur_num = toplist_data_info._cur_num + 1
			
				local find_info = toplist_data_info._toplist_data_map:Find(role_score)
				if find_info == nil then
					local role_top_data = CACHE.RoleTopListData()
					role_top_data._role_id = roleid
					role_top_data._name = name
					role_top_data._level = level
					role_top_data._photoid = photoid
					role_top_data._mafia_name = mafia_name

					local role_top_list = CACHE.RoleTopListDataMapData()
					role_top_list._score = new_data
					role_top_list._list_data:PushBack(role_top_data)
					
					toplist_data_info._toplist_data_map:Insert(new_data, role_top_list)
					
					--toplist_data:Insert(data._begin_score, data)
					insert_flag = 0
					break
				else
					local role_top_data = CACHE.RoleTopListData()
					role_top_data._role_id = roleid
					role_top_data._name = name
					role_top_data._level = level
					role_top_data._photoid = photoid
					role_top_data._mafia_name = mafia_name
					
					find_info._list_data:PushBack(role_top_data)
					insert_flag = 0
					break
				end
			end
			minimum = toplist_data_info._end_score
			toplist_data_info_it:Next()
			toplist_data_info = toplist_data_info_it:GetValue()
		end
	end

	if insert_flag == 1 then
		--�Ѿ������Ǹ���Χ�����ˣ����Ծ��µĽ���һ��
		local data = CACHE.TopListAllRoleData()
		data._begin_score = new_data - step_num
		if minimum >= data._begin_score then
			data._begin_score = minimum + 1
		end
		data._end_score = new_data + step_num
		data._cur_num = 1

		local role_top_data = CACHE.RoleTopListData()
		role_top_data._role_id = roleid
		role_top_data._name = name
		role_top_data._level = level
		role_top_data._photoid = photoid
		role_top_data._mafia_name = mafia_name

		local role_top_list = CACHE.RoleTopListDataMapData()
		role_top_list._score = new_data
		role_top_list._list_data:PushBack(role_top_data)
		
		data._toplist_data_map:Insert(new_data, role_top_list)
		
		toplist_data:Insert(data._begin_score, data)
	end
end

function TOP_ALL_Role_GetRoleRank(top,toptype,roleid,data)
	local toplist = top:Find(toptype)
	if toplist == nil then
		return 0
	end

	TOP_ALL_Role_Print(top,toptype)

	local toplist_data = toplist._data_map

	local toplist_info_it = toplist_data:SeekToLast()
	local toplist_info = toplist_info_it:GetValue()
	local num = 1
	while toplist_info ~= nil do
		if toplist_info._begin_score <= data and  data <= toplist_info._end_score then
			local toplist_info_data_it = toplist_info._toplist_data_map:SeekToLast()
			local toplist_info_data = toplist_info_data_it:GetValue()
			while toplist_info_data ~= nil do
				if toplist_info_data._score == data then
					local list_role_data_it = toplist_info_data._list_data:SeekToBegin()
					local list_role_data = list_role_data_it:GetValue()
					while list_role_data ~= nil do
						if list_role_data._role_id:ToStr() == roleid:ToStr() then
							API_Log("222222222222222222222222222222222222222222222222222222222")
							return num
						else
							API_Log("3333333333333333333333333333333333333333333333333333333333")
							num = num + 1
						end
						
						list_role_data_it:Next()
						list_role_data = list_role_data_it:GetValue()
					end
				else
					API_Log("44444444444444444444444444444444444    Size="..toplist_info_data._list_data:Size())
					num = num + toplist_info_data._list_data:Size()
				end
				toplist_info_data_it:Prev()
				toplist_info_data = toplist_info_data_it:GetValue()
			end
			return 0
		end

		API_Log("11111111111111111111111111111111111111111111111    _cur_num="..toplist_info._cur_num)
		num = num + toplist_info._cur_num
		toplist_info_it:Prev()
		toplist_info = toplist_info_it:GetValue()
	end
	return 0
end

function TOP_ALL_Role_SendDailyReward(top,toptype)
	--���������ÿһ���ڰ��ϵ���ҷ����Լ������Σ�Ȼ���������Ϣ������Ҫ����ҵ�������Ϣ���кܶ��������Ϣ
	
	API_Log("1111111111111111111111111111   TOP_ALL_Role_SendDailyReward")
	local toplist = top:Find(toptype)
	if toplist == nil then
		return
	end

	local toplist_data = toplist._data_map

	local toplist_info_it = toplist_data:SeekToLast()
	local toplist_info = toplist_info_it:GetValue()
	local num = 1
	while toplist_info ~= nil do
		local toplist_info_data_it = toplist_info._toplist_data_map:SeekToLast()
		local toplist_info_data = toplist_info_data_it:GetValue()
		while toplist_info_data ~= nil do
			local list_role_data_it = toplist_info_data._list_data:SeekToBegin()
			local list_role_data = list_role_data_it:GetValue()
			while list_role_data ~= nil do
				local msg = NewMessage("MaShuUpdateRoleRank")
				msg.rank = num
				API_SendMsg(list_role_data._role_id:ToStr(), SerializeMessage(msg), 0)
				
				list_role_data_it:Next()
				list_role_data = list_role_data_it:GetValue()
				num = num + 1
			end
			toplist_info_data_it:Prev()
			toplist_info_data = toplist_info_data_it:GetValue()
		end

		toplist_info_it:Prev()
		toplist_info = toplist_info_it:GetValue()
	end
	return

end

function TOP_ALL_Role_Print(top,toptype)
	local toplist = top:Find(toptype)
	if toplist == nil then
		return 0
	end

	local toplist_data = toplist._data_map

	local toplist_info_it = toplist_data:SeekToLast()
	local toplist_info = toplist_info_it:GetValue()
	local num = 1
	while toplist_info ~= nil do
		local toplist_info_data_it = toplist_info._toplist_data_map:SeekToLast()
		local toplist_info_data = toplist_info_data_it:GetValue()
		while toplist_info_data ~= nil do
			
			local list_role_data_it = toplist_info_data._list_data:SeekToBegin()
			local list_role_data = list_role_data_it:GetValue()
			while list_role_data ~= nil do
				API_Log("111111111111    num="..num.."     roleid="..list_role_data._role_id:ToStr().."   score="..toplist_info_data._score)
				
				num = num + 1
				list_role_data_it:Next()
				list_role_data = list_role_data_it:GetValue()
			end
			toplist_info_data_it:Prev()
			toplist_info_data = toplist_info_data_it:GetValue()
		end

		toplist_info_it:Prev()
		toplist_info = toplist_info_it:GetValue()
	end
	return 0
end