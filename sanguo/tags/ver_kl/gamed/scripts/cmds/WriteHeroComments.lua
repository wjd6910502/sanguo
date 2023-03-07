function OnCommand_WriteHeroComments(player, role, arg, others)
	player:Log("OnCommand_WriteHeroComments, "..DumpTable(arg).." "..DumpTable(others))

	local resp = NewCommand("WriteHeroComments_Re")
	resp.hero_id = arg.hero_id

	--���Ȳ鿴�Ƿ�����Ѿ����۹�����佫�ˣ��Լ�����佫�Ƿ��������
	local ed = DataPool_Find("elementdata")
	local heroinfo = ed:FindBy("hero_id", arg.hero_id)
	
	if heroinfo.comment_limit == 0 then
		resp.retcode = G_ERRCODE["HERO_COMMENTS_CAN_NOT_WRITE"]
		player:SendToClient(SerializeCommand(resp))
		return
	else
		if LIMIT_TestUseLimit(role, heroinfo.comment_limit, 1) == false then
			resp.retcode = G_ERRCODE["HERO_COMMENTS_MAX"]
			player:SendToClient(SerializeCommand(resp))
			return
		end
	end

	local mist = others.misc
	local comments = mist._miscdata._hero_comments

	local com = comments:Find(arg.hero_id)
	if com == nil then
		--˵���������ǵ�һ����������佫��
		local com_list = CACHE.HeroCommentsList:new()
		local role_com = CACHE.HeroComments:new()
		role_com._roleid:Set(role._roledata._base._id)
		role_com._rolename = role._roledata._base._name
		role_com._comments = arg.comments
		role_com._agree = CACHE.Int64intMap:new()
		role_com._time_stamp = API_GetTime()

		com_list:PushFront(role_com)
		comments:Insert(arg.hero_id, com_list)
	else
		local role_com = CACHE.HeroComments:new()
		role_com._roleid:Set(role._roledata._base._id)
		role_com._rolename = role._roledata._base._name
		role_com._comments = arg.comments
		role_com._agree = CACHE.Int64intMap:new()
		role_com._time_stamp = API_GetTime()

		com:PushFront(role_com)
	end
	
	LIMIT_AddUseLimit(role, heroinfo.comment_limit, 1)
	resp.retcode = 0
	player:SendToClient(SerializeCommand(resp))
	return
end