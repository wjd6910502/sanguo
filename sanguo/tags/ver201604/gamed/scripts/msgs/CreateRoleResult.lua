function OnMessage_CreateRoleResult(player, role, arg, others)
	player:Log("OnMessage_CreateRoleResult, "..DumpTable(arg).." "..DumpTable(others))

	local resp = NewCommand("CreateRole_Re")
	if arg.retcode==G_ERRCODE["SUCCESS"] then
		resp.retcode = 0
		ROLE_Init(role)--角色的一些数据进行初始化
		ROLE_Copy(role, others.roles["1"])
		ROLE_PostInit(role)
		TASK_RefreshTask(role)--角色的成就进行初始化
		resp.info = ROLE_MakeRoleInfo(role)
	end
	player:SendToClient(SerializeCommand(resp))
end
