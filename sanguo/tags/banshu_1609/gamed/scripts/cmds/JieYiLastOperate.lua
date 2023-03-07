function OnCommand_JieYiLastOperate(player, role, arg, others)
	player:Log("OnCommand_JieYiLastOperate, "..DumpTable(arg).." "..DumpTable(others))
	--
	local resp = NewCommand("JieYiLastOperate_Re")	
	resp.name = arg.name
	resp.roleId = role._roledata._base._id:ToStr() 
	resp.retcode = arg.agreement
	
	local jieyi_info = others.jieyi_info._data
	
	local tmp_id = CACHE.Int64()
	tmp_id:Set(arg.id)
	
	local fit = {}
	--准备结义的处理方法
	if arg.typ == 2 then
		fit = jieyi_info._compare_jieyi_info:Find(tmp_id)
	elseif arg.typ == 1 then
		fit = jieyi_info._jieyi_info:Find(tmp_id)	
	else
		throw()
	end
	
	--验证所有状态都是邀请状态
	if fit ~= nil then
		local v = fit
			
		local sit = v._brother_info:SeekToBegin()
		local s = sit:GetValue()
		while s ~= nil do
			if s._accept ~= 1 then
				--这个人没有接受邀请
				return
			end
	
			sit:Next()
			s = sit:GetValue()
		end		
		resp.id = v._id:ToStr()
							
		--如果agreement  1代表同意 0代表不同意
		if arg.agreement == 0 then
			resp.retcode = 0
		elseif arg.agreement == 1 then
			resp.retcode = 1
			--设置状态
			local v = fit
			local s = v._brother_info:Find(role._roledata._base._id) 
			if s ~= nil then
				s._ready = 1 --二次确认完成
			end
		else
			return
		end						
	else
		throw()
	end

	--给所有人都发一下
	local brotherall = GetbrotherIds(jieyi_info,arg.typ,tmp_id )
	for i = 1, #brotherall	do
		local dest_id = brotherall[i]
		if dest_id == role._roledata._base._id:ToStr() then
			player:Log("OnCommand_JieYiLastOperate, ".."send self")
			role:SendToClient(SerializeCommand(resp))
		else
			player:Log("OnCommand_JieYiLastOperate, ".."send other") 
			local dest_role = others.roles[dest_id]
			dest_role:SendToClient(SerializeCommand(resp))
		end
	end

	if arg.typ == 2 or arg.typ == 1 then
		
		local fit = {}
		if arg.typ == 2 then
			fit = jieyi_info._compare_jieyi_info:Find(tmp_id)
		elseif arg.typ == 1 then
			fit = jieyi_info._jieyi_info:Find(tmp_id)
		else
			return
		end
		if fit ~= nil then

			local v = fit	
			local sit = v._brother_info:SeekToBegin()
			local s = sit:GetValue()
			while s ~= nil do
				
				if s._accept ~= 1 or s._ready ~= 1 then
					--这个人没有接受邀请
					return
				end
				
				sit:Next()
				s = sit:GetValue()
			end	
		end
	end
	--如果所有人都确认了 直接给用户发确认的消息

	local brotherall = GetbrotherIds(jieyi_info,arg.typ,tmp_id )
	for i = 1, #brotherall	do
		local dest_id = brotherall[i]
		if dest_id == role._roledata._base._id:ToStr() then
			--这个tmp_id 需要从主A身上获取	
			role._roledata._jieyi_info._jieyi_id = tmp_id
			role._roledata._jieyi_info._cur_operate_id = CACHE.Int64(0)
			role._roledata._jieyi_info._cur_operate_typ = 1
			role._roledata._jieyi_info._jieyi_name = arg.name
			role._roledata._jieyi_info._invite_member:Clear()
			--level
			--exp
		else
			local dest_role = others.roles[dest_id]
			dest_role._roledata._jieyi_info._jieyi_id = tmp_id
			dest_role._roledata._jieyi_info._cur_operate_id = CACHE.Int64(0)
			dest_role._roledata._jieyi_info._cur_operate_typ = 1
			dest_role._roledata._jieyi_info._jieyi_name = arg.name
			dest_role._roledata._jieyi_info._invite_member:Clear()
			--level
			--exp
		end
	end
	
	--结义成功 修改jieyi_info信息	
	if arg.typ == 2 then
		local compare_info = jieyi_info._compare_jieyi_info:Find(tmp_id)
		
		local j_info = CACHE.JieYiInfo()
		j_info._id = compare_info._id
		j_info._name = arg.name
		--level 
		--exp

		j_info._boss_info._id = compare_info._boss_info._id
		j_info._boss_info._name = compare_info._boss_info._name
		j_info._boss_info._level = compare_info._boss_info._level
		j_info._boss_info._photo = compare_info._boss_info._photo
		j_info._boss_info._accept = compare_info._boss_info._accept --自己肯定接受 1 接受 0 不接受
		j_info._boss_info._ready = compare_info._boss_info._ready -- 这个后面处理 1 接受 0 不接受
		j_info._boss_info._time = API_GetTime()  --需要时间接口
		
		player:Log("OnCommand_JieYiLastOperate, ".."turn on"..arg.id)
		--加boss信息
		local sit = compare_info._brother_info:SeekToBegin()
		local s = sit:GetValue()
		while s ~= nil do
			local bro = CACHE.JieYiRoleInfo()
			bro._id = s._id
			bro._name = s._name
			bro._level = s._level
			bro._photo = s._photo
			bro._accept = s._accept
			bro._ready = s._ready
			bro._time = s._time	
			j_info._brother_info:Insert(bro._id,bro)

			sit:Next()
			s = sit:GetValue()
		end
		player:Log("OnCommand_JieYiLastOperate, ".."turn off")
		jieyi_info._jieyi_info:Insert(j_info._id,j_info)
		jieyi_info._compare_jieyi_info:Delete(tmp_id)
		arg.typ = 1
	elseif arg.typ == 1 then
		local fit = jieyi_info._jieyi_info:Find(tmp_id)
		--这个用的本身列表 前面代码已经做了插入处理
	else
		throw()
	end
 		
	--role._roledata._jieyi_info._jieyi_name = arg.name	
	--则给所有人发结义成功	
	local resp_suc = NewCommand("JieYiResult")
	resp_suc.id = role._roledata._jieyi_info._jieyi_id:ToStr() 
	resp_suc.name = role._roledata._jieyi_info._jieyi_name
	resp_suc.retcode  = 0 --成功 0  失败 1
	
	--给所有人都发一下
	local brotherall = GetbrotherIds(jieyi_info,arg.typ,tmp_id )
	for i = 1, #brotherall	do
		local dest_id = brotherall[i]
		if dest_id == role._roledata._base._id:ToStr() then
			player:Log("OnCommand_JieYiLastOperate, ".."send self"..resp_suc.id) 
			role:SendToClient(SerializeCommand(resp_suc))
		else
			player:Log("OnCommand_JieYiLastOperate, ".."send other"..resp_suc.id)
			local dest_role = others.roles[dest_id]
			dest_role:SendToClient(SerializeCommand(resp_suc))
		end
	end

end


