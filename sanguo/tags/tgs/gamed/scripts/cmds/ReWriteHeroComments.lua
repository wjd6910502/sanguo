function OnCommand_ReWriteHeroComments(player, role, arg, others)
	player:Log("OnCommand_ReWriteHeroComments, "..DumpTable(arg).." "..DumpTable(others))

	local resp = NewCommand("ReWriteHeroComments_Re")
	resp.hero_id = arg.hero_id

	local mist = others.misc
	local comments = mist._miscdata._hero_comments

	local com = comments:Find(arg.hero_id)
	if com == nil then
		resp.retcode = G_ERRCODE["HERO_COMMENTS_NOT_WRITE"]
		player:SendToClient(SerializeCommand(resp))
		return
	end

	local com_it = com:SeekToBegin()
	local com_it_value = com_it:GetValue()
	while com_it_value ~= nil do
		if role._roledata._base._id:Equal(com_it_value._roleid) then
			com_it_value._comments = arg.comments
			resp.retcode = 0
			player:SendToClient(SerializeCommand(resp))
			return
		end
	end

	resp.retcode = G_ERRCODE["HERO_COMMENTS_NOT_WRITE"]
	player:SendToClient(SerializeCommand(resp))
	return
end
