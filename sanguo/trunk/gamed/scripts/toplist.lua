--ע��������а�����ֻ�м�������һ������ҵ����ݣ�������̫�����ҵ�����

function TOP_InsertData(top, toptype, roleid, data, data2, name, photoid, photoframe, badge, level, item_id, tid, typ)
	if roleid == 0 or roleid:Less("100") then
		return
	end
	local toplist = top:Find(toptype)
	if toplist~=nil then
		local toplist_id = toplist._new_top_list_by_id
		local toplist_data = toplist._new_top_list_by_data._data
		--���ȼ���������Ƿ��ڵ�ǰ�����а�
		local r = toplist_id:Find(roleid)
		if r~=nil then
			--˵�������������а���
			--ע�����а�Ĺ����Լ��ǲ�����Լ������а���Ū��ȥ�ġ��Լ�����ֵ�仯ֻ�ǻ�Ӱ���Լ������а��е�˳��
			--�Լ�����ڰ��еĻ���ֻ���Ǳ��˰��Լ�����ȥ�ˡ������Լ��ǲ����ȥ��
			local old_data = r.data
			--�������û�з����ı�Ļ����Ǿ�ֱ�ӷ��ذɡ�û�б�Ҫ���в�����
			if old_data:ToStr() == tostring(data) then
				if tostring(data2) == "0" or r.data2 == tostring(data2) then
					return
				end
			end
			--r.data = data
			--���ڿ�ʼ�������������������map
			local r_data = toplist_data:Find(old_data)
			if r_data==nil then
				--���������־
				return
			end
			--�ҵ��Ժ󣬾���Ҫ����������list����Ѱ����������
			local rit_list = r_data:SeekToBegin()
			local r_list = rit_list:GetValue()
			while r_list ~= nil do
				if r_list._id:Equal(roleid) then
					--ɾ����������
					rit_list:Pop()
				
					--ע�����ɾ��һ��Ҫ���ڶ�r.data�����¸�ֵ֮ǰ����Ϊold_data��һ��ָ��r.data��ָ�룬r.data��ֵ�����Ժ�
					--old_data��ֵҲ������޸ĵġ�
					if r_data:Size() == 0 then
						toplist_data:Delete(old_data)
					end
					
					r.data:Set(data)
					
					local r2 = CACHE.TopListData()
					r2._id = r._id
					r2._name = r._name
					r2._photo = r._photo
					r2._level = r._level
					r2._photoframe = r._photoframe
					r2._badge = r._badge
					r2._item._item_id = r._item._item_id
					r2._item._tid = r._item._tid
					r2._item._typ = r._item._typ
					r2.data:Set(data)
					r2.data2:Set(data2)

					--�鿴��ǰ�����Ƿ��������ֵ�ģ��еĻ�ֱ�Ӳ��룬û�еĻ�����Ҫ�Լ������Ժ��ٴ�ɾ��
					local tmp_data = CACHE.Int64()
					tmp_data:Set(data)
					local second_data = toplist_data:Find(tmp_data)
					if second_data == nil then
						local data_list = CACHE.TopListMultiList()
						
						data_list:PushFront(r2)
						toplist_data:Insert(tmp_data, data_list)
					else
						if tostring(data2) == "0" then
							second_data:PushFront(r2)
						else
							local insert_flag = 0
							local it = second_data:SeekToBegin()
							local topdata = it:GetValue()
							while topdata ~= nil do
								if topdata.data2:Less(data2) or topdata.data2:Equal(data2) then
									it:PushBefore(r2)
									insert_flag = 1
									break
								end
								it:Next()
								topdata = it:GetValue()
							end
							if insert_flag == 0 then
								second_data:PushBack(r2)
							end
						end
					end
					return
				end
				rit_list:Next()
				r_list = rit_list:GetValue()
			end
			--����������־
		else
			--˵�������Ҳ������а���
			--�����жϵ�ǰ������а��е�����
			local num = toplist_id:Size()
			local ed = DataPool_Find("elementdata")
			local quanju = ed.gamedefine[1]
			if num < quanju.rank_max_storage then
				--��ǰ���а�����С��50ֱ�Ӱ������ҷŽ�ȥ
				local r2 = CACHE.TopListData()
				r2._id = roleid
				r2._name = name
				r2._photo = photoid
				r2._level = level
				r2._photoframe = photoframe
				r2._badge = badge
				r2._item._item_id = item_id
				r2._item._tid = tid
				r2._item._typ = typ
				r2.data:Set(data)
				r2.data2:Set(data2)
				toplist_id:Insert(roleid,r2)
				
				local tmp_data = CACHE.Int64()
				tmp_data:Set(data)
				local second_data = toplist_data:Find(tmp_data)
				if second_data == nil then
					local data_list = CACHE.TopListMultiList()
					
					data_list:PushFront(r2)
					toplist_data:Insert(tmp_data, data_list)
				else
					if tostring(data2) == "0" then
						second_data:PushFront(r2)
					else
						local insert_flag = 0
						local it = second_data:SeekToBegin()
						local topdata = it:GetValue()
						while topdata ~= nil do
							if topdata.data2:Less(data2) or topdata.data2:Equal(data2) then
								it:PushBefore(r2)
								insert_flag = 1
								break
							end
							it:Next()
							topdata = it:GetValue()
						end
						if insert_flag == 0 then
							second_data:PushBack(r2)
						end
					end
				end
			else
				--������Ҫע���ˣ���Ϊ���а��map�������Ǵ�С����ģ����Լ���һ����
				local first = toplist_data:SeekToBegin();
				local first_value = first:GetValue()
				local rit_list = first_value:SeekToBegin()
				local r_list = rit_list:GetValue()
				if r_list.data:Great(data) or r_list.data:Equal(data) then
					if tostring(data2) == "0" or r_list.data2 <= tostring(data2) then
						--ֱ�ӷ��أ�ʲô������
						return
					end
				else
					local r2 = CACHE.TopListData()
					r2._id = roleid
					r2._name = name
					r2._photo = photoid
					r2._level = level
					r2._photoframe = photoframe
					r2._badge = badge
					r2._item._item_id = item_id
					r2._item._tid = tid
					r2._item._typ = typ
					r2.data:Set(data)
					r2.data2:Set(data2)
					toplist_id:Insert(roleid,r2)

					local tmp_data = CACHE.Int64()
					tmp_data:Set(data)
					local second_data = toplist_data:Find(tmp_data)
					if second_data == nil then
						local data_list = CACHE.TopListMultiList()
						
						data_list:PushFront(r2)
						toplist_data:Insert(tmp_data, data_list)
					else
						if tostring(data2) == "0" then
							second_data:PushFront(r2)
						else
							local insert_flag = 0
							local it = second_data:SeekToBegin()
							local topdata = it:GetValue()
							while topdata ~= nil do
								if topdata.data2:Less(data2) or topdata.data2:Equal(data2) then
									it:PushBefore(r2)
									insert_flag = 1
									break
								end
								it:Next()
								topdata = it:GetValue()
							end
							if insert_flag == 0 then
								second_data:PushBack(r2)
							end
						end
					end
					toplist_id:Delete(r_list._id)
					if first_value:Size() == 1 then
						toplist_data:Delete(r_list.data)
					else
						first_value:PopFront()
					end
				end
			end
		end
	end
end

--�������а�����ķ���������,����˵��ҵ����֣�ͷ���
function TOP_UpdateData(top, roleid, name, level, photoid, photoframe, badge)
	if roleid == 0 then
		return
	end
	
	local toplist_it= top:SeekToBegin()
	local toplist = toplist_it:GetValue()
	while toplist~=nil do
		--�պ������˵
		--local toplist_typ = toplist._top_list_type
		--if toplist_typ >= 1000 then
		--	return
		--end
		local toplist_id = toplist._new_top_list_by_id
		local toplist_data = toplist._new_top_list_by_data._data
		--���ȼ���������Ƿ��ڵ�ǰ�����а�
		local r = toplist_id:Find(roleid)
		if r~=nil then
			local old_data = r.data
			
			local r_data = toplist_data:Find(old_data)
			if r_data==nil then
				return
			end
			
			--�ҵ��Ժ󣬾���Ҫ����������list����Ѱ����������
			local rit_list = r_data:SeekToBegin()
			local r_list = rit_list:GetValue()
			while r_list ~= nil do
				if r_list._id:Equal(roleid) then
					r_list._name = name
					r_list._photo = photoid
					r_list._level = level
					r_list._photoframe = photoframe
					r_list._badge = badge

					r._name = name
					r._photo = photoid
					r._level = level
					r._photoframe = photoframe
					r._badge = badge
					--return
				end
				rit_list:Next()
				r_list = rit_list:GetValue()
			end
		end

		toplist_it:Next()
		toplist = toplist_it:GetValue()
	end
end
--��ĳһ�����а�����ɾ��ĳһ�����
function TOP_DeleteData(top,toptype,roleid)
	local toplist = top:Find(toptype)
	if toplist ==nil then
		return
	end

	local toplist_id = toplist._new_top_list_by_id
	local toplist_data = toplist._new_top_list_by_data._data
	
	if toplist_id:Find(roleid) ~= nil then
		local toplist_data_info_it = toplist_data:SeekToBegin()
		local toplist_data_info = toplist_data_info_it:GetValue()

		toplist_id:Delete(roleid)
		
		while toplist_data_info ~= nil do
			local toplist_role_info_it = toplist_data_info:SeekToBegin()
			local toplist_role_info = toplist_role_info_it:GetValue()
			while toplist_role_info ~= nil do
				if toplist_role_info._id:ToStr() == roleid:ToStr() then
					if toplist_data_info:Size() == 1 then
						local tmp_data = toplist_role_info.data
						toplist_data:Delete(tmp_data)
					else
						toplist_role_info_it:Pop()
					end
					return
				end

				toplist_role_info_it:Next()
				toplist_role_info = toplist_role_info_it:GetValue()
			end

			toplist_data_info_it:Next()
			toplist_data_info = toplist_data_info_it:GetValue()
		end
	end
end

function TOP_DeleteTop(top,toptype)
	local toplist = top:Find(toptype)
	if toplist~=nil then
		toplist._old_top_list = toplist._new_top_list_by_data._data
		toplist._new_top_list_by_id:Clear()
		toplist._new_top_list_by_data._data:Clear()
		
		--����������а����
		if toptype == 8 then
			local toplist_data = toplist._old_top_list
			local rit = toplist_data:SeekToBegin()
			local r = rit:GetValue()
			local members = {}
			while r~=nil do
				local rit_list = r:SeekToBegin()
				local r_list = rit_list:GetValue()
				while r_list~=nil do
					members[#members+1] = r_list._id
					rit_list:Next()
					r_list = rit_list:GetValue()
				end
				rit:Next()
				r = rit:GetValue()
			end
			
			local mailid = 0
			local all_number = table.getn(members)
			for i = 1, all_number do
				if i == 1 then
					mailid = 1900
				elseif i == 2 then
					mailid = 1901
				elseif i == 3 then
					mailid = 1902
				else
					break
				end
				local msg = NewMessage("SendMailToMafia")
				msg.mail_id = mailid
				API_SendMsg(members[all_number -i + 1]:ToStr(), SerializeMessage(msg), 0)
			end
		end
	end
end

function TOP_TestSendMail(top)
	local now = API_GetTime()
	local tit = top:SeekToBegin()
	local tmp_toplist = tit:GetValue()
	while tmp_toplist ~= nil do
		local ed = DataPool_Find("elementdata")
		local quanju = ed.gamedefine[1]
		--����������а����
		if tmp_toplist._top_list_type == 8 then
			--����������а�������˷�ÿ�յĽ���
			local toplist_data = tmp_toplist._old_top_list
			local rit = toplist_data:SeekToBegin()
			local r = rit:GetValue()
			local members = {}
			while r~=nil do
				local rit_list = r:SeekToBegin()
				local r_list = rit_list:GetValue()
				while r_list~=nil do
					members[#members+1] = r_list._id
					rit_list:Next()
					r_list = rit_list:GetValue()
				end
				rit:Next()
				r = rit:GetValue()
			end
			
			local mailid = 0
			local all_number = table.getn(members)
			for i = 1, all_number do
				if i == 1 then
					mailid = 1900
				elseif i == 2 then
					mailid = 1901
				elseif i == 3 then
					mailid = 1902
				else
					break
				end
				local msg = NewMessage("SendMailToMafia")
				msg.mail_id = mailid
				API_SendMsg(members[all_number -i + 1]:ToStr(), SerializeMessage(msg), 0)
			end
		end
		tit:Next()
		tmp_toplist = tit:GetValue()
	end
end