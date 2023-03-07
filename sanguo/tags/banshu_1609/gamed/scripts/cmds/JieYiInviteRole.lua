function OnCommand_JieYiInviteRole(player, role, arg, others)
	player:Log("OnCommand_JieYiInviteRole, "..DumpTable(arg).." "..DumpTable(others))
	local resp = NewCommand("JieYiInvite_Re")
	
	-- 考虑初次结义 和 已经结义的逻辑
	local jieyi_info = others.jieyi_info._data					
	local dest_role = others.roles[arg.dest_id]
	if dest_role == nil then
		--不存在的角色
		local cmd = NewCommand("ErrorInfo")
		cmd.error_id = G_ERRCODE["JIEYI_INVITEROLE_NOT_EXIST"]
		role:SendToClient(SerializeCommand(cmd))
		return 
	end

	--是否在线
	if dest_role._roledata._status._online == 0 then
		local cmd = NewCommand("ErrorInfo")
		cmd.error_id = G_ERRCODE["JIEYI_INVITEROLE_NOT_ONLINE"]
		role:SendToClient(SerializeCommand(cmd))
		return 
	end
	
	--对方已经结义
	local id = dest_role._roledata._jieyi_info._jieyi_id:ToStr()

	if dest_role._roledata._jieyi_info._jieyi_id:ToStr() ~= "0" then
		local cmd = NewCommand("ErrorInfo") 
		cmd.error_id = G_ERRCODE["JIEYI_INVITEROLE_HAS_JIEYI"] 
		role:SendToClient(SerializeCommand(cmd))
		return
	end
	
	--对方不满足结义等级
	if dest_role._roledata._status._level < 1 then
		local cmd = NewCommand("ErrorInfo") 
		cmd.error_id = G_ERRCODE["JIEYI_INVITEROLE_LEVEL_NOT_ENOUGH"]
		role:SendToClient(SerializeCommand(cmd))
		return	
	end

	--对方已经邀请了俩个好友
	local info = {}
	if role._roledata._jieyi_info._cur_operate_typ == 1 then	   							 	
		info = jieyi_info._jieyi_info:Find( role._roledata._jieyi_info._jieyi_id)
		if info ==nil then
			local cmd = NewCommand("ErrorInfo") 
			cmd.error_id = G_ERRCODE["JIEYI_INFO_NOT_FOUND"]
			role:SendToClient(SerializeCommand(cmd))
			return
		end
	elseif role._roledata._jieyi_info._cur_operate_typ == 2 then
	    info = jieyi_info._compare_jieyi_info:Find( role._roledata._jieyi_info._cur_operate_id)
		if info ==nil then
			local cmd = NewCommand("ErrorInfo") 
			cmd.error_id = G_ERRCODE["JIEYI_INFO_NOT_FOUND"]
			role:SendToClient(SerializeCommand(cmd))
			return
		end
	else
		local cmd = NewCommand("ErrorInfo") 
		cmd.error_id = G_ERRCODE["JIEYI_REQUEST_TYPE_WRONG"]
		role:SendToClient(SerializeCommand(cmd))
		return
	end
	
	--A->B 如果a和b 同时创建结义 不可以相互邀请
	--[[if dest_role._roledata._jieyi_info._cur_operate_id:ToStr() ~= "0" then
		local cmd = NewCommand("ErrorInfo")
		cmd.error_id = G_ERRCODE["JIEYI_BROTHER_NOT_INVITED"]
		role:SendToClient(SerializeCommand(cmd))
		player:Log("OnCommand_JieYiInviteRole, ".." ".."jieyi test") 
		return
	end
	--]]
	if info._brother_info:Size() >= 2 then	
		local cmd = NewCommand("ErrorInfo") 
		cmd.error_id = G_ERRCODE["JIEYI_INVITEROLE_NUMBER_SURPASS"]
		role:SendToClient(SerializeCommand(cmd))
		return
	end

	--type = 1 代表已经结义 type =2 准备结义
	resp.typ = role._roledata._jieyi_info._cur_operate_typ
	
	if resp.typ == 1 then
		resp.id = role._roledata._jieyi_info._jieyi_id:ToStr()
	elseif resp.typ == 2 then
		resp.id = role._roledata._jieyi_info._cur_operate_id:ToStr()
	else
		local cmd = NewCommand("ErrorInfo") 
		cmd.error_id = G_ERRCODE["JIEYI_INVITEROLE_NOT_CREATED"]
		role:SendToClient(SerializeCommand(cmd)) 
		return
	end
	player:Log("OnCommand_JieYiInviteRole, ".."00000000000000000000000000000000")
	resp.name = role._roledata._jieyi_info._jieyi_name	
	dest_role:SendToClient(SerializeCommand(resp))
	
	--这里代表成功 给自己发一个协议
	local resp = NewCommand("JieYiInviteRole_Re")
	resp.retcode = 0
	resp.role_id = arg.dest_id 
	role:SendToClient(SerializeCommand(resp))

	--这里需要考虑给被邀请用户 身上加一些邀请数据信息 保存到数据库
	local invite_info = CACHE.InviteJieInfo()
	if role._roledata._jieyi_info._cur_operate_typ == 2 then
		invite_info._id = role._roledata._jieyi_info._cur_operate_id
	end
	

	if role._roledata._jieyi_info._cur_operate_typ == 1 then
		invite_info._id = role._roledata._jieyi_info._jieyi_id
	end
	
	invite_info._typ = role._roledata._jieyi_info._cur_operate_typ
	invite_info._name = role._roledata._jieyi_info._jieyi_name
	invite_info._time = API_GetTime()
	
	player:Log("OnCommand_JieYiInviteRole, ".."3333333333333333333333"..invite_info._id:ToStr())
	local fit =  dest_role._roledata._jieyi_info._invite_member:Find(invite_info._id)
	if fit == nil then
		player:Log("OnCommand_JieYiInviteRole, ".."1111111111111111111111111111111111")
		dest_role._roledata._jieyi_info._invite_member:Insert(invite_info._id,invite_info)	
	else
		player:Log("OnCommand_JieYiInviteRole, ".."22222222222222222222222222222222222")
		--已经存在 不用添加
	end
end
