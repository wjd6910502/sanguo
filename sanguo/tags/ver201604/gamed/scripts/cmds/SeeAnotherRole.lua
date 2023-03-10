function OnCommand_SeeAnotherRole(player, role, arg, others)
	player:Log("OnCommand_SeeAnotherRole, "..DumpTable(arg).." "..DumpTable(others))

	local dest_role = others.roles[arg.roleid]

	--查看你自己的信息没有任何的意义呀
	if role._roledata._base._id:ToStr() == dest_role._roledata._base._id:ToStr() then
		return 
	end

	local resp = NewCommand("SeeAnotherRole_Re")
	resp.roleinfo = {}
	resp.roleinfo.brief = {}
	resp.roleinfo.brief = ROLE_MakeRoleBrief(dest_role)

	role:SendToClient(SerializeCommand(resp))
	return
end
