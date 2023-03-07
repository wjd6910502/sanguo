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
		return
	end

	local mafia_info = mafia_data._data

	if role._roledata._mafia._position ~= G_MAFIA_POSITION["BANGZHU"] then
		resp.retcode = G_ERRCODE["MAFIA_SHANRANG_ERR"]
		player:SendToClient(SerializeCommand(resp))
		return
	end

	local member_info = mafia_info._member_map:Find(CACHE.Int64(arg.role_id))
	local self_member_info = mafia_info._member_map:Find(role._roledata._base._id)
	if member_info == nil then
		resp.retcode = G_ERRCODE["MAFIA_KICKOUT_NO_ROLE"]
		player:SendToClient(SerializeCommand(resp))
		return
	end

	self_member_info._position = G_MAFIA_POSITION["PINGMIN"]
	role._roledata._mafia._position = G_MAFIA_POSITION["PINGMIN"]
	MAFIA_UpdateSelfInfo(role)

	member_info._position = G_MAFIA_POSITION["BANGZHU"]
	if dest_role ~= nil then
		dest_role._roledata._mafia._position = G_MAFIA_POSITION["BANGZHU"]
		MAFIA_UpdateSelfInfo(dest_role)
	end

	--修改帮会的信息
	mafia_info._boss_id = member_info._id
	mafia_info._boss_name = member_info._name
	MAFIA_MafiaUpdateMember(mafia_info, self_member_info)
	MAFIA_MafiaUpdateMember(mafia_info, member_info)
	MAFIA_MafiaUpdateInterfaceInfo(mafia_info)
	
	--更新帮会的信息到简易帮会表中去
	local msg = NewMessage("UpdateMafiaInfoTop")
	msg.level_flag = 0
	msg.id = mafia_info._id:ToStr()
	msg.name = mafia_info._name
	msg.announce = mafia_info._announce
	msg.level = mafia_info._level
	msg.boss_id = mafia_info._boss_id:ToStr()
	msg.boss_name = mafia_info._boss_name
	msg.level_limit = mafia_info._level_limit
	msg.num = mafia_info._member_map:Size()
	player:SendMessage(CACHE.Int64(0), SerializeMessage(msg))
	
	resp.retcode = G_ERRCODE["SUCCESS"]
	player:SendToClient(SerializeCommand(resp))
end
