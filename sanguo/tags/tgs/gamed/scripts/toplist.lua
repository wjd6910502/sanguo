--注意这个排行榜上面只有极少数的一部分玩家的数据，不会有太多的玩家的数据

function TOP_InsertData(top,toptype,roleid,data,name,photoid,level,item_id,tid,typ)
	if roleid == 0 then
		return
	end
	local toplist = top:Find(toptype)
	if toplist~=nil then
		local toplist_id = toplist._new_top_list_by_id
		local toplist_data = toplist._new_top_list_by_data._data
		--首先检查这个玩家是否在当前的排行榜
		local r = toplist_id:Find(roleid)
		if r~=nil then
			--说明这个玩家在排行榜中
			--注意排行榜的规则，自己是不会把自己从排行榜中弄出去的。自己的数值变化只是会影响自己在排行榜中的顺序
			--自己如果在榜中的话，只能是别人把自己挤出去了。否则自己是不会出去的
			local old_data = r.data
			--如果分数没有发生改变的话，那就直接返回吧。没有必要进行操作了
			if old_data:ToStr() == tostring(data) then
				return
			end
			--r.data = data
			--现在开始处理根据数据来排序的map
			local r_data = toplist_data:Find(old_data)
			if r_data==nil then
				--输出错误日志
				return
			end
			--找到以后，就需要在这个里面的list里面寻找这个玩家了
			local rit_list = r_data:SeekToBegin()
			local r_list = rit_list:GetValue()
			while r_list ~= nil do
				if r_list._id:Equal(roleid) then
					--删除掉这个玩家
					rit_list:Pop()
				
					--注意这个删除一定要放在对r.data的重新赋值之前，因为old_data是一个指向r.data的指针，r.data的值变了以后
					--old_data的值也会跟着修改的。
					if r_data:Size() == 0 then
						toplist_data:Delete(old_data)
					end
					
					r.data:Set(data)
					
					local r2 = CACHE.TopListData:new()
					r2._id = r._id
					r2._name = r._name
					r2._photo = r._photo
					r2._level = r._level
					r2._item._item_id = r._item._item_id
					r2._item._tid = r._item._tid
					r2._item._typ = r._item._typ
					r2.data:Set(r.data)

					--查看当前表中是否有这个数值的，有的话直接插入，没有的话，需要自己创建以后再次删除
					local tmp_data = CACHE.Int64()
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
			--打出错误的日志
		else
			--说明这个玩家不在排行榜中
			--首先判断当前这个排行榜中的人数
			local num = toplist_id:Size()
			local ed = DataPool_Find("elementdata")
			local quanju = ed.gamedefine[1]
			if num < quanju.rank_max_storage then
				--当前排行榜人数小于50直接把这个玩家放进去
				local r2 = CACHE.TopListData:new()
				r2._id = roleid
				r2._name = name
				r2._photo = photoid
				r2._level = level
				r2._item._item_id = item_id
				r2._item._tid = tid
				r2._item._typ = typ
				r2.data:Set(data)
				toplist_id:Insert(roleid,r2)
				
				local tmp_data = CACHE.Int64()
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
				--这里需要注意了，因为排行榜的map的排序是从小到大的，所以检查第一个。
				local first = toplist_data:SeekToBegin();
				local first_value = first:GetValue()
				local rit_list = first_value:SeekToBegin()
				local r_list = rit_list:GetValue()
				if r_list.data:Great(data) or r_list.data:Equal(data) then
					--直接返回，什么都不做
					return
				else
					local r2 = CACHE.TopListData:new()
					r2._id = roleid
					r2._name = name
					r2._photo = photoid
					r2._level = level
					r2._item._item_id = item_id
					r2._item._tid = tid
					r2._item._typ = typ
					r2.data:Set(data)
					toplist_id:Insert(roleid,r2)

					local tmp_data = CACHE.Int64()
					tmp_data:Set(data)
					local second_data = toplist_data:Find(tmp_data)
					if second_data == nil then
						local data_list = CACHE.TopListMultiList:new()
						
						data_list:PushFront(r2)
						toplist_data:Insert(tmp_data, data_list)
					else
						second_data:PushFront(r2)
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

--在某一个排行榜上面删除某一个玩家
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
	end
end
