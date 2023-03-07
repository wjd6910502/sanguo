function OnCommand_FriendRequest(player, role, arg, others)
	player:Log("OnCommand_FriendRequest, "..DumpTable(arg).." others="..DumpTable(others))

	local resp = NewCommand("FriendRequest_Re")
	resp.dest_id = arg.dest_id

	local d_role = others.roles[arg.dest_id]
	if d_role==nil then
		--resp.retcode = G_ERRCODE["FRIEND_REQUEST_NOT_ROLE"]
		--player:SendToClient(SerializeCommand(resp))
		--player:Log("OnCommand_FriendRequest, error=FRIEND_REQUEST_NOT_ROLE")
		resp.retcode = G_ERRCODE["LOAD_ROLE_DATA"]
		player:SendToClient(SerializeCommand(resp))
		player:Log("OnCommand_FriendRequest, error=LOAD_ROLE_DATA")
		return
	end
	
	--��Ҫ�����Լ�
	if d_role._roledata._base._id:ToStr()==role._roledata._base._id:ToStr() then return end

	--�Ѿ��Ǻ���,����Ҳ��Ҫ���һ�¶���ĺ����б������Ƿ����Լ���
	--��ȻĿǰ�������˫��ġ����ǻ�����һ���ĸ�����ɺ����ǵ����
	local friends = role._roledata._friend._friends
	if friends:Find(d_role._roledata._base._id)~=nil then
		resp.retcode = G_ERRCODE["FRIEND_REQUEST_HAVE"]
		player:SendToClient(SerializeCommand(resp))
		player:Log("OnCommand_FriendRequest, error=FRIEND_REQUEST_HAVE")
		return
	end
	
	--�鿴˫���ĺ����Ƿ��Ѿ�����
	local dest_friends = d_role._roledata._friend._friends
	
	local ed = DataPool_Find("elementdata")
	local quanju = ed.gamedefine[1]
	if friends:Size() >= quanju.friends_max then
		resp.retcode = G_ERRCODE["FRIEND_REQUEST_SELF_MAX"]
		player:SendToClient(SerializeCommand(resp))
		player:Log("OnCommand_FriendRequest, error=FRIEND_REQUEST_SELF_MAX")
		return
	end

	if dest_friends:Size() >= quanju.friends_max then
		resp.retcode = G_ERRCODE["FRIEND_REQUEST_OTHER_MAX"]
		player:SendToClient(SerializeCommand(resp))
		player:Log("OnCommand_FriendRequest, error=FRIEND_REQUEST_OTHER_MAX")
		return
	end

	--�鿴�Ƿ��ں���������
	if role._roledata._friend._blacklist:Find(d_role._roledata._base._id) ~= nil then
		resp.retcode = G_ERRCODE["FRIEND_REQUEST_SELF_BLACK_LIST"]
		player:SendToClient(SerializeCommand(resp))
		player:Log("OnCommand_FriendRequest, error=FRIEND_REQUEST_SELF_BLACK_LIST")
		return
	end
	
	if d_role._roledata._friend._blacklist:Find(role._roledata._base._id) ~= nil then
		resp.retcode = G_ERRCODE["FRIEND_REQUEST_OTHER_BLACK_LIST"]
		player:SendToClient(SerializeCommand(resp))
		player:Log("OnCommand_FriendRequest, error=FRIEND_REQUEST_OTHER_BLACK_LIST")
		return
	end

	local find_friend_info = dest_friends:Find(role._roledata._base._id)
	if find_friend_info ~= nil then
		--�������������Ļ�����ôֱ�ӰѶ���ӵ��Լ��ĺ������棬Ĭ��Ϊ�Է��Ѿ�ͬ����
		resp.retcode = G_ERRCODE["SUCCESS"]
		player:SendToClient(SerializeCommand(resp))
		
		--���Ӻ���
		local insert_friend = CACHE.Friend()
		insert_friend._brief._id = d_role._roledata._base._id
		insert_friend._brief._name = role._roledata._base._name
		insert_friend._brief._photo = role._roledata._base._photo
		insert_friend._brief._level = role._roledata._status._level
		insert_friend._zhanli = role._roledata._status._zhanli
		insert_friend._faction = find_friend_info._faction
		insert_friend._online = 1
		insert_friend._brief._photo_frame = role._roledata._base._photo_frame
		insert_friend._brief._badge_map = role._roledata._base._badge_map
		insert_friend._sex = role._roledata._base._sex

		role._roledata._friend._friends:Insert(insert_friend._brief._id, insert_friend)

		resp = NewCommand("NewFriend")
		resp.friend = {}
		resp.friend.id = insert_friend._brief._id
		resp.friend.name = insert_friend._brief._name
		resp.friend.photo = insert_friend._brief._photo
		resp.friend.level = insert_friend._brief._level
		resp.friend.zhanli = insert_friend._zhanli
		resp.friend.faction = insert_friend._faction
		resp.friend.online = insert_friend._online
		resp.friend.photo_frame = insert_friend._brief._photo_frame
		resp.friend.sex = insert_friend._sex
		
		resp.friend.badge_info = {}
		local badge_info_it = insert_friend._brief._badge_map:SeekToBegin()
		local badge_info = badge_info_it:GetValue()
		while badge_info ~= nil do
			local tmp_badge_info = {}
			tmp_badge_info.id = badge_info._id
			tmp_badge_info.typ = badge_info._pos
			resp.friend.badge_info[#resp.friend.badge_info+1] = tmp_badge_info

			badge_info_it:Next()
			badge_info = badge_info_it:GetValue()
		end
		player:SendToClient(SerializeCommand(resp))
		return
	end

	local reqs = d_role._roledata._friend._requests
	--�Ѿ��������?
	local rit = reqs:SeekToBegin()
	local r = rit:GetValue()
	while r~=nil do
		if r._brief._id:ToStr()==role._roledata._base._id:ToStr() then
			resp.retcode = G_ERRCODE["FRIEND_REQUEST_HAVE_REQ"]
			player:SendToClient(SerializeCommand(resp))
			return
		end
		rit:Next()
		r = rit:GetValue()
	end

	--����̫��, ��ɾ�����ڵ�����
	while reqs:Size()>=10 do
		local rit = reqs:SeekToBegin()
		local r = rit:GetValue()
		local del_resp = NewCommand("FriendDelRequest")
		del_resp.role_id = r._brief._id:ToStr()
		player:SendToClient(SerializeCommand(del_resp))
		
		reqs:PopFront()
	end

	--���浽�����б�
	local nr = CACHE.FriendRequest()
	nr._brief._id = role._roledata._base._id
	nr._brief._name = role._roledata._base._name
	nr._brief._photo = role._roledata._base._photo
	nr._brief._level = role._roledata._status._level
	nr._brief._photo_frame = role._roledata._base._photo_frame
	nr._brief._badge_map = role._roledata._base._badge_map
	nr._zhanli = role._roledata._status._zhanli
	nr._sex = role._roledata._base._sex
	reqs:PushBack(nr)
	resp.retcode = G_ERRCODE["SUCCESS"]
	player:SendToClient(SerializeCommand(resp))

	--����������˷���Э��
	local cmd = NewCommand("FriendAddRequest")
	cmd.requests = {}
	cmd.requests.id = nr._brief._id:ToStr()
	cmd.requests.name = nr._brief._name
	cmd.requests.photo = nr._brief._photo
	cmd.requests.photo_frame = nr._brief._photo_frame
	cmd.requests.level = nr._brief._level
	cmd.requests.zhanli = nr._zhanli
	cmd.requests.sex = nr._sex

	cmd.requests.badge_info = {}
	local badge_info_it = nr._brief._badge_map:SeekToBegin()
	local badge_info = badge_info_it:GetValue()
	while badge_info ~= nil do
		local tmp_badge_info = {}
		tmp_badge_info.id = badge_info._id
		tmp_badge_info.typ = badge_info._pos
		cmd.requests.badge_info[#cmd.requests.badge_info+1] = tmp_badge_info

		badge_info_it:Next()
		badge_info = badge_info_it:GetValue()
	end

	d_role:SendToClient(SerializeCommand(cmd))
end