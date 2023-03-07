function OnCommand_CreateRole(player, role, arg, others)
	player:Log("OnCommand_CreateRole, "..DumpTable(arg))

	--TODO: 非法名字检查
	if false then
		local resp = NewCommand("CreateRole_Re")
		resp.retcode = G_ERRCODE["INVALID_NAME"]
		player:SendToClient(SerializeCommand(resp))
		return
	end

	local now = API_GetTime()

	if role._roledata._base._id:ToStr()~="0" then
		--已经有角色了还要创建, 外挂? 踢掉吧
		player:Err("OnCommand_CreateRole, HaveRole")
		player:KickoutSelf(1)
		return
	elseif role._roledata._base._name~="" then
		if now-role._roledata._base._create_time<=10 then
			--已经在创建角色中, 耐心等一会
			local resp = NewCommand("CreateRole_Re")
			resp.retcode = G_ERRCODE["CREATING_ROLE"]
			player:SendToClient(SerializeCommand(resp))
			return
		end
		--收到上次CreateRole请求N秒种后还没创建好，则可以再次创建角色
	end

	role._roledata._base._name = arg.name
	role._roledata._base._photo = arg.photo
	role._roledata._base._create_time = now

	local resp = NewCommand("CreateRole_Re")
	resp.retcode = G_ERRCODE["USED_NAME"]
	player:AllocRoleName(arg.name, now, SerializeCommand(resp))
end
