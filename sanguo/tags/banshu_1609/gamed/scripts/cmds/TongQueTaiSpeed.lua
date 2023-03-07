function OnCommand_TongQueTaiSpeed(player, role, arg, others)
	player:Log("OnCommand_TongQueTaiSpeed, "..DumpTable(arg).." "..DumpTable(others))

	--在这里把这个Speed发给其余的两个玩家
	local dest_role1 = others.roles[arg.role_id1]
	local dest_role2 = others.roles[arg.role_id2]

	local resp = NewCommand("TongQueTaiSpeed_Re")
	resp.speed = arg.speed
	resp.role_id = role._roledata._base._id:ToStr()

	dest_role1:SendToClient(SerializeCommand(resp))
	dest_role1:SendToClient(SerializeCommand(resp))
end
