function OnMessage_CreateRoleResult(player, role, arg, others)
	player:Log("OnMessage_CreateRoleResult, "..DumpTable(arg).." "..DumpTable(others))

	local resp = NewCommand("CreateRole_Re")
	if arg.retcode==G_ERRCODE["SUCCESS"] then
		resp.retcode = 0
		ROLE_Init(role)--角色的一些数据进行初始化
		ROLE_Copy(role, others.roles["1"])
		ROLE_PostInit(role)
		TASK_RefreshTask(role)--角色的成就进行初始化
		TASK_ChangeCondition(role, G_ACH_TYPE["LEVEL_FINISH"], 0, role._roledata._status._level)
		resp.info = ROLE_MakeRoleInfo(role)
	else
		--永远没有机会调用到
	end
	player:SendToClient(SerializeCommand(resp))
end
