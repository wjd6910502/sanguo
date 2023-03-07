function OnCommand_MafiaCreate(player, role, arg, others)
	player:Log("OnCommand_MafiaCreate, "..DumpTable(arg).." "..DumpTable(others))

	--TODO: 非法名字检查
	if false then
		local resp = NewCommand("MafiaCreate_Re")
		resp.retcode = G_ERRCODE["INVALID_NAME"]
		player:SendToClient(SerializeCommand(resp))
		return
	end

	local now = API_GetTime()

	if role._roledata._mafia._id:ToStr()~="0" then
		--已经有mafia了还要创建, 外挂? 踢掉吧
		player:Err("OnCommand_MafiaCreate, HaveMafia")
		player:KickoutSelf(1)
		return
	elseif role._roledata._mafia._name~="" then
		if now-role._roledata._mafia._create_time<=10 then
			--已经在创建mafia中, 耐心等一会
			local resp = NewCommand("MafiaCreate_Re")
			resp.retcode = G_ERRCODE["CREATING_MAFIA"]
			player:SendToClient(SerializeCommand(resp))
			return
		end
		--收到上次MafiaCreate请求N秒种后还没创建好，则可以再次创建
	end

	role._roledata._mafia._name = arg.name
	role._roledata._mafia._create_time = now

	--TODO:
	--local resp = NewCommand("MafiaCreate_Re")
	--resp.retcode = G_ERRCODE["USED_NAME"]
	--player:AllocMafiaName(arg.name, now, SerializeCommand(resp))
	local msg = NewMessage("CreateMafiaResult")
	msg.retcode = 0
	player:SendMessage(role._roledata._base._id, SerializeMessage(msg))
end
