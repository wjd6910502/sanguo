function OnCommand_MafiaShanRang(player, role, arg, others)
	player:Log("OnCommand_MafiaShanRang, "..DumpTable(arg).." "..DumpTable(others))

	--禅让帮主
	local mafia_data = others.mafias[role._roledata._mafia._id:ToStr()]
	local dest_role = others.roles[arg.role_id]
	local resp = NewCommand("MafiaShanRang_Re")

	if role._roledata._base._id:ToStr() == arg.role_id then
		return
	end

	resp.role_id = arg.role_id

	if mafia_data == nil then
		resp.retcode = G_ERRCODE["NO_MAFIA"]
		player:SendToClient(SerializeCommand(resp))
		player:Log("OnCommand_MafiaShanRang, error=NO_MAFIA")
		return
	end

	local mafia_info = mafia_data._data

	if role._roledata._mafia._position ~= G_MAFIA_POSITION["BANGZHU"] then
		resp.retcode = G_ERRCODE["MAFIA_SHANRANG_ERR"]
		player:SendToClient(SerializeCommand(resp))
		player:Log("OnCommand_MafiaShanRang, error=MAFIA_SHANRANG_ERR")
		return
	end

	local member_info = mafia_info._member_map:Find(CACHE.Int64(arg.role_id))
	local self_member_info = mafia_info._member_map:Find(role._roledata._base._id)
	if member_info == nil then
		resp.retcode = G_ERRCODE["MAFIA_KICKOUT_NO_ROLE"]
		player:SendToClient(SerializeCommand(resp))
		player:Log("OnCommand_MafiaShanRang, error=MAFIA_KICKOUT_NO_ROLE")
		return
	end

	self_member_info._position = G_MAFIA_POSITION["PINGMIN"]
	role._roledata._mafia._position = G_MAFIA_POSITION["PINGMIN"]
	MAFIA_MafiaUpdateMember(mafia_info, self_member_info)
	MAFIA_MafiaUpdateMember(mafia_info, member_info)
	
	MAFIA_UpdateSelfInfo(role)
	ROLE_UpdateBadge(role, 1, 1, 0)

	member_info._position = G_MAFIA_POSITION["BANGZHU"]
	if dest_role ~= nil then
		dest_role._roledata._mafia._position = G_MAFIA_POSITION["BANGZHU"]
		MAFIA_UpdateSelfInfo(dest_role)
		ROLE_UpdateBadge(dest_role, 1, 1, 1)
	end

	--修改帮会的信息
	mafia_info._boss_id = member_info._id
	mafia_info._boss_name = member_info._name
	MAFIA_MafiaUpdateInterfaceInfo(mafia_info)
	
	--更新帮会的信息到简易帮会表中去
	MAFIA_MafiaUpdateInfoTop(mafia_info, 0)
	
	resp.retcode = G_ERRCODE["SUCCESS"]
	player:SendToClient(SerializeCommand(resp))
end
