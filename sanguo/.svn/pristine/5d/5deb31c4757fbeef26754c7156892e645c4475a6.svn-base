function OnMessage_CreateMafiaResult(player, role, arg, others)
	player:Log("OnMessage_CreateMafiaResult, "..DumpTable(arg).." "..DumpTable(others))

	if arg.retcode~=0 then return end --TODO:
	if role._roledata._mafia._id:ToStr()~="0" then return end
	--TODO: 其他验证，比如name/create_time

	local id = API_Mafia_AllocId()

	local data = CACHE.MafiaData()
	data._id = id
	data._name = role._roledata._mafia._name
	data._level = 1
	data._boss_id = role._roledata._base._id
	data._boss_name = role._roledata._base._name

	local member = CACHE.MafiaMember()
	member._id = role._roledata._base._id
	member._name = role._roledata._base._name
	member._photo = role._roledata._base._photo
	member._level = role._roledata._status._level
	data._member_map:Insert(member._id, member)

	local resp = NewCommand("MafiaCreate_Re")
	resp.retcode = G_ERRCODE["SUCCESS"]
	resp.mafia = MAFIA_MakeMafia(data)
	player:SendToClient(SerializeCommand(resp))

	role._roledata._mafia._id = id
	role._roledata._mafia._invites:Clear()
	API_Mafia_Insert(id, data)
end
