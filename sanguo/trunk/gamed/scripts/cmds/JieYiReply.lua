function OnCommand_JieYiReply(player, role, arg, others)
	player:Log("OnCommand_JieYiReply, "..DumpTable(arg).." "..DumpTable(others))
	
	--回复所有者信息 所有的数据回复	
	local jieyi_info = others.jieyi_info._data
	
	local tmp_id = CACHE.Int64()
	tmp_id:Set(arg.id)
	
	--判断一下 自己身上的邀请id 不存在 不让进去
	local fit =  role._roledata._jieyi_info._invite_member:Find(tmp_id)
	if fit == nil then	
		--该人没有被邀请过 发送replay无效
		local cmd = NewCommand("ErrorInfo")
		cmd.error_id = G_ERRCODE["JIEYI_INVITEREQUEST_CANCEL"]
		role:SendToClient(SerializeCommand(cmd))
		player:Log("OnCommand_JieYiReply, error=JIEYI_INVITEREQUEST_CANCEL")
		return
	end

	--提前处理一下加人操作
	local roleinfo = CACHE.JieYiRoleInfo()
	roleinfo._id = role._roledata._base._id
	roleinfo._level = role._roledata._status._level
	roleinfo._name = role._roledata._base._name
	roleinfo._photo = role._roledata._base._photo
	roleinfo._accept = 0
	roleinfo._ready = 0
	roleinfo._time = API_GetTime()
	
	if arg.typ == 1 then
		local roleinfo = CACHE.JieYiRoleInfo()
		roleinfo._id = role._roledata._base._id
		roleinfo._level = role._roledata._status._level
		roleinfo._name = role._roledata._base._name
		roleinfo._photo = role._roledata._base._photo
		roleinfo._accept = 0
		roleinfo._ready = 0
		roleinfo._time = API_GetTime()

		local info = jieyi_info._jieyi_info:Find(tmp_id)
		if info ~= nil then
			
			--结义兄弟判断是否存在 不存在加入 不存在不处理
			--local sit = info._brother_info:SeekToBegin()
			--s = sit:GetValue()
			
			-- 这里0代表未找到  1代表找到
			--local isfind = 0
			--while s ~= nil do
			--	if s._id == roleinfo._id then
			--		isfind = 1					
			--	end
			--	sit:Next()
			--	s = sit:GetValue()
			--end
			
			if  arg.agreement == 1 then
				if info._brother_info:Find(roleinfo._id) == nil then
	   				info._brother_info:Insert( roleinfo._id ,roleinfo )
				end
			else
				--删除自己身上的邀请数据
				role._roledata._jieyi_info._invite_member:Delete(tmp_id)
			end

		else			
			return
		end
		--这里考虑要不要到底放在俩个列表里面 因为里面状态可以区分这些东西
	elseif arg.typ == 2 then
		local roleinfo = CACHE.CompareJieYiRoleInfo()
		roleinfo._id = role._roledata._base._id
		roleinfo._level = role._roledata._status._level
		roleinfo._name = role._roledata._base._name
		roleinfo._photo = role._roledata._base._photo
		roleinfo._accept = 0
		roleinfo._ready = 0
		roleinfo._time = API_GetTime()

		local info = jieyi_info._compare_jieyi_info:Find(tmp_id)
		if info ~= nil then
			
			--结义兄弟判断是否存在 不存在加入 不存在不处理				
			if arg.agreement == 1 then
	   			if info._brother_info:Find(roleinfo._id) == nil then
					info._brother_info:Insert( roleinfo._id ,roleinfo )
				end
			else
			   --删除自己身上的邀请数据
				role._roledata._jieyi_info._invite_member:Delete(tmp_id)
			end

		else
			return
		end
	else
		local cmd = NewCommand("ErrorInfo")
		cmd.error_id = G_ERRCODE["JIEYI_INVITEROLE_NOT_CREATED"]
		role:SendToClient(SerializeCommand(cmd))
		player:Log("OnCommand_JieYiReply, error=JIEYI_INVITEROLE_NOT_CREATED")
		return
	end

	--这里扔一个message	
	local msg = NewMessage("JieYiUpdateReply")
	msg.id = arg.id
	msg.typ = arg.typ
	msg.name = arg.name
	msg.role_id = role._roledata._base._id:ToStr()
	msg.agreement = arg.agreement
	
	local brotherall = GetbrotherIds(jieyi_info,arg.typ,tmp_id ) 	
	for i = 1, #brotherall  do
		local dest_id =CACHE.Int64( brotherall[i])
		player:Log("OnCommand_JieYiReply".."send message.......")			
		player:SendMessage(dest_id, SerializeMessage(msg) )
	end
	
end


