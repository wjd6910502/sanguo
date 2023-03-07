function OnCommand_AgreeHeroComments(player, role, arg, others)
	player:Log("OnCommand_AgreeHeroComments, "..DumpTable(arg).." "..DumpTable(others))

	local resp = NewCommand("AgreeHeroComments_Re")
	resp.retcode = 0
	resp.hero_id = arg.hero_id
	resp.role_id = arg.role_id
	resp.time_stamp = arg.time_stamp

	local mist = others.misc
	local comments = mist._miscdata._hero_comments

	local com = comments:Find(arg.hero_id)
	if com == nil then
		--这个武将目前还没有评论，怎么进行评价
	else
		--查看要点赞的这个玩家是否存在，并且是否已经点过攒了
		local com_it = com:SeekToBegin()
		local com_it_value = com_it:GetValue()
		while com_it_value ~= nil do
			if com_it_value._roleid:ToStr() == arg.role_id and com_it_value._time_stamp == arg.time_stamp then
				if role._roledata._base._id:Equal(com_it_value._roleid) then
					--不可以给自己点赞
					resp.retcode = G_ERRCODE["HERO_COMMENTS_SELF"]
					player:SendToClient(SerializeCommand(resp))
					return
				end

				--查看是否已经给这个评论点过赞了
				local find_flag = com_it_value._agree:Find(role._roledata._base._id)
				if find_flag ~= nil then
					resp.retcode = G_ERRCODE["HERO_COMMENTS_DID"]
					player:SendToClient(SerializeCommand(resp))
					return
				end

				--进行点赞
				local value = CACHE.Int:new()
				value._value = 1
				com_it_value._agree:Insert(role._roledata._base._id, value)
				player:SendToClient(SerializeCommand(resp))
				return
			end
			com_it:Next()
			com_it_value = com_it:GetValue()
		end
		--没有这个玩家的评论
		resp.retcode = G_ERRCODE["HERO_COMMENTS_NOT_HAVE"]
		player:SendToClient(SerializeCommand(resp))
		return
	end
end
