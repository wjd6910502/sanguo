function TOP_InsertData(top,toptype,roleid,data,name,photoid)
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
				return
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
					
					local r2 = CACHE.TopListData:new()
					r2._id = r._id
					r2._name = r._name
					r2._photo = r._photo
					r2.data:Set(r.data)

					--�鿴��ǰ�����Ƿ��������ֵ�ģ��еĻ�ֱ�Ӳ��룬û�еĻ�����Ҫ�Լ������Ժ��ٴ�ɾ��
					local tmp_data = CACHE.Int64:new()
					tmp_data:Set(data)
					local second_data = toplist_data:Find(tmp_data)
					if second_data == nil then
						local data_list = CACHE.TopListMultiList:new()
						
						data_list:PushFront(r2)
						toplist_data:Insert(tmp_data, data_list)
					else
						second_data:PushFront(r2)
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
				local r2 = CACHE.TopListData:new()
				r2._id = roleid
				r2._name = name
				r2._photo = photoid
				r2.data:Set(data)
				toplist_id:Insert(roleid,r2)
				
				local tmp_data = CACHE.Int64:new()
				tmp_data:Set(data)
				local second_data = toplist_data:Find(tmp_data)
				if second_data == nil then
					local data_list = CACHE.TopListMultiList:new()
					
					data_list:PushFront(r2)
					toplist_data:Insert(tmp_data, data_list)
				else
					second_data:PushFront(r2)
				end
			else
				--������Ҫע���ˣ���Ϊ���а��map�������Ǵ�С����ģ����Լ���һ����
				local first = toplist_data:SeekToBegin();
				local first_value = first:GetValue()
				local rit_list = first_value:SeekToBegin()
				local r_list = rit_list:GetValue()
				if r_list.data:Great(data) or r_list.data:Equal(data) then
					--ֱ�ӷ��أ�ʲô������
					return
				else
					toplist_id:Delete(r_list._id)
					first_value:PopFront()
					if first_value:Size() == 0 then
						toplist_data:Delete(r_list.data)
					end

					local r2 = CACHE.TopListData:new()
					r2._id = roleid
					r2._name = name
					r2._photo = photoid
					r2.data:Set(data)
					toplist_id:Insert(roleid,r2)

					local tmp_data = CACHE.Int64:new()
					tmp_data:Set(data)
					local second_data = toplist_data:Find(tmp_data)
					if second_data == nil then
						local data_list = CACHE.TopListMultiList:new()
						
						data_list:PushFront(r2)
						toplist_data:Insert(tmp_data, data_list)
					else
						second_data:PushFront(r2)
					end
				end
			end
		end
	end
end