function OnCommand_SeeAnotherRole(player, role, arg, others)
	player:Log("OnCommand_SeeAnotherRole, "..DumpTable(arg).." "..DumpTable(others))

	local dest_role = others.roles[arg.roleid]
	
	if dest_role == nil then
		return
	end


	--查看你自己的信息没有任何的意义呀
	if role._roledata._base._id:ToStr() == dest_role._roledata._base._id:ToStr() then
		return
	end

	local resp = NewCommand("SeeAnotherRole_Re")
	resp.roleinfo = {}
	resp.roleinfo.brief = {}
	resp.roleinfo.brief = ROLE_MakeRoleBrief(dest_role)

	resp.roleinfo.zhanli = role._roledata._status._zhanli
	resp.roleinfo.mafia_position = role._roledata._mafia._position
	if role._roledata._status._online == 1 then
		resp.roleinfo.time = 0
	else
		resp.roleinfo.time = role._roledata._status._last_heartbeat
	end

	role:SendToClient(SerializeCommand(resp))
	return
end
