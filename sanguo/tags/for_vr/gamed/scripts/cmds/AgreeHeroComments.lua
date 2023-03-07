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
		--����佫Ŀǰ��û�����ۣ���ô��������
	else
		--�鿴Ҫ���޵��������Ƿ���ڣ������Ƿ��Ѿ��������
		local com_it = com:SeekToBegin()
		local com_it_value = com_it:GetValue()
		while com_it_value ~= nil do
			if com_it_value._roleid:ToStr() == arg.role_id and com_it_value._time_stamp == arg.time_stamp then
				if role._roledata._base._id:Equal(com_it_value._roleid) then
					--�����Ը��Լ�����
					resp.retcode = G_ERRCODE["HERO_COMMENTS_SELF"]
					player:SendToClient(SerializeCommand(resp))
					return
				end

				--�鿴�Ƿ��Ѿ���������۵������
				local find_flag = com_it_value._agree:Find(role._roledata._base._id)
				if find_flag ~= nil then
					resp.retcode = G_ERRCODE["HERO_COMMENTS_DID"]
					player:SendToClient(SerializeCommand(resp))
					return
				end

				--���е���
				local value = CACHE.Int:new()
				value._value = 1
				com_it_value._agree:Insert(role._roledata._base._id, value)
				player:SendToClient(SerializeCommand(resp))
				return
			end
			com_it:Next()
			com_it_value = com_it:GetValue()
		end
		--û�������ҵ�����
		resp.retcode = G_ERRCODE["HERO_COMMENTS_NOT_HAVE"]
		player:SendToClient(SerializeCommand(resp))
		return
	end
end
