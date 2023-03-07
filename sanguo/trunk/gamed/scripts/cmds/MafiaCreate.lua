function OnCommand_MafiaCreate(player, role, arg, others)
	player:Log("OnCommand_MafiaCreate, "..DumpTable(arg).." "..DumpTable(others))

	--TODO: 非法名字检查
	if player:IsValidRolename(arg.name) == false then
		local resp = NewCommand("MafiaCreate_Re")
		resp.retcode = G_ERRCODE["INVALID_NAME"]
		player:SendToClient(SerializeCommand(resp))
		player:Log("OnCommand_MafiaCreate, error=INVALID_NAME")
		return
	end

	local now = API_GetTime()

	if role._roledata._mafia._id:ToStr()~="0" then
		--已经有mafia了还要创建, 外挂? 踢掉吧
		player:Err("OnCommand_MafiaCreate, HaveMafia")
		player:KickoutSelf(1)
		return
	elseif role._roledata._mafia._create_time ~= 0 then
		if now-role._roledata._mafia._create_time<=10 then
			--已经在创建mafia中, 耐心等一会
			local resp = NewCommand("MafiaCreate_Re")
			resp.retcode = G_ERRCODE["CREATING_MAFIA"]
			player:SendToClient(SerializeCommand(resp))
			player:Log("OnCommand_MafiaCreate, error=CREATING_MAFIA")
			return
		end
	end
	
	local ed = DataPool_Find("elementdata")
	local quanju = ed.gamedefine[1]
	if role._roledata._status._yuanbao < quanju.league_build_cost then
		local resp = NewCommand("MafiaCreate_Re")
		resp.retcode = G_ERRCODE["YUANBAO_LESS"]
		player:SendToClient(SerializeCommand(resp))
		player:Log("OnCommand_MafiaCreate, error=CREATING_MAFIA")
		return
	end

	role._roledata._mafia._create_time = now

	player:AllocMafiaName(arg.name, now)
	--local msg = NewMessage("CreateMafiaResult")
	--msg.retcode = 0
	--player:SendMessage(role._roledata._base._id, SerializeMessage(msg))
end
