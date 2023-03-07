function OnCommand_FriendRequest(player, role, arg, others)
	player:Log("OnCommand_FriendRequest, "..DumpTable(arg).." others="..DumpTable(others))

	local resp = NewCommand("FriendRequest_Re")
	resp.dest_id = arg.dest_id

	local d_role = others.roles[arg.dest_id]
	if d_role==nil then
		resp.retcode = G_ERRCODE["FRIEND_REQUEST_NOT_ROLE"]
		player:SendToClient(SerializeCommand(resp))
		return
	end
	
	--不要发给自己
	if d_role._roledata._base._id:ToStr()==role._roledata._base._id:ToStr() then return end

	--已经是好友,这里也需要检查一下对面的好友列表里面是否有自己，
	--虽然目前的设计是双向的。但是还是有一定的概率造成好友是单向的
	local friends = role._roledata._friend._friends
	if friends:Find(d_role._roledata._base._id)~=nil then
		resp.retcode = G_ERRCODE["FRIEND_REQUEST_HAVE"]
		player:SendToClient(SerializeCommand(resp))
		return 
	end
	
	--查看双方的好友是否已经满了
	local dest_friends = d_role._roledata._friend._friends
	
	local ed = DataPool_Find("elementdata")
	local quanju = ed.gamedefine[1]
	if friends:Size() >= quanju.friends_max then
		resp.retcode = G_ERRCODE["FRIEND_REQUEST_SELF_MAX"]
		player:SendToClient(SerializeCommand(resp))
		return 
	end

	if dest_friends:Size() >= quanju.friends_max then
		resp.retcode = G_ERRCODE["FRIEND_REQUEST_OTHER_MAX"]
		player:SendToClient(SerializeCommand(resp))
		return 
	end

	--查看是否在黑名单里面
	if role._roledata._friend._blacklist:Find(d_role._roledata._base._id) ~= nil then
		resp.retcode = G_ERRCODE["FRIEND_REQUEST_SELF_BLACK_LIST"]
		player:SendToClient(SerializeCommand(resp))
		return 
	end
	
	if d_role._roledata._friend._blacklist:Find(role._roledata._base._id) ~= nil then
		resp.retcode = G_ERRCODE["FRIEND_REQUEST_OTHER_BLACK_LIST"]
		player:SendToClient(SerializeCommand(resp))
		return 
	end

	local find_friend_info = dest_friends:Find(role._roledata._base._id)
	if find_friend_info ~= nil then
		--如果是这种情况的话，那么直接把对面加到自己的好友里面，默认为对方已经同意了
		resp.retcode = G_ERRCODE["SUCCESS"]
		player:SendToClient(SerializeCommand(resp))
		
		--添加好友
		local insert_friend = CACHE.Friend()
		insert_friend._brief._id = d_role._roledata._base._id
		insert_friend._brief._name = role._roledata._base._name
		insert_friend._brief._photo = role._roledata._base._photo
		insert_friend._brief._level = role._roledata._status._level
		insert_friend._zhanli = role._roledata._status._zhanli
		insert_friend._faction = find_friend_info._faction
		insert_friend._online = 1

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
		player:SendToClient(SerializeCommand(resp))
		return
	end

	local reqs = d_role._roledata._friend._requests
	--已经申请过了?
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

	--申请太多, 则删掉早期的申请
	while reqs:Size()>=10 do
		local rit = reqs:SeekToBegin()
		local r = rit:GetValue()
		local del_resp = NewCommand("FriendDelRequest")
		del_resp.role_id = r._brief._id:ToStr()
		player:SendToClient(SerializeCommand(del_resp))
		
		reqs:PopFront() 
	end

	--保存到申请列表
	local nr = CACHE.FriendRequest:new()
	nr._brief._id = role._roledata._base._id
	nr._brief._name = role._roledata._base._name
	nr._brief._photo = role._roledata._base._photo
	nr._brief._level = role._roledata._status._level
	nr._zhanli = role._roledata._status._zhanli
	reqs:PushBack(nr)
	resp.retcode = G_ERRCODE["SUCCESS"]
	player:SendToClient(SerializeCommand(resp))

	--给被申请的人发送协议
	local cmd = NewCommand("FriendAddRequest")
	cmd.requests = {}
	cmd.requests.id = nr._brief._id:ToStr()
	cmd.requests.name = nr._brief._name
	cmd.requests.photo = nr._brief._photo
	cmd.requests.level = nr._brief._level
	cmd.requests.zhanli = nr._zhanli
	d_role:SendToClient(SerializeCommand(cmd))
end
