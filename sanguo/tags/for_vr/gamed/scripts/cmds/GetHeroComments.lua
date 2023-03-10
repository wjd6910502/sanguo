function OnCommand_GetHeroComments(player, role, arg, others)
	player:Log("OnCommand_GetHeroComments, "..DumpTable(arg).." "..DumpTable(others))

	local resp = NewCommand("GetHeroComments_Re")
	resp.comment = {}
	resp.retcode = 0
	resp.hero_id = arg.hero_id

	local mist = others.misc
	local comments = mist._miscdata._hero_comments

	local com = comments:Find(arg.hero_id)
	if com == nil then
		--说明这个武将还没有评价，直接返回去一个空的数据
	else
		local com_it = com:SeekToBegin()
		local com_it_value = com_it:GetValue()
		while com_it_value ~= nil do
			local tmp = {}
			tmp.role_id = com_it_value._roleid:ToStr()
			tmp.role_name = com_it_value._rolename
			tmp.comment = com_it_value._comments
			tmp.agree_count = com_it_value._agree:Size()
			tmp.time_stamp = com_it_value._time_stamp
			if role._roledata._base._id:Equal(com_it_value._roleid) then
				tmp.agree_flag = 2
			else
				local find_flag = com_it_value._agree:Find(role._roledata._base._id)
				if find_flag ~= nil then
					tmp.agree_flag = 1
				else
					tmp.agree_flag = 0
				end
			end
			resp.comment[#resp.comment+1] = tmp
			com_it:Next()
			com_it_value = com_it:GetValue()
		end
	end
	
	player:SendToClient(SerializeCommand(resp))
	return
end
