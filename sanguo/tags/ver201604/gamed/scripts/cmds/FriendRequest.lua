function OnCommand_FriendRequest(player, role, arg, others)
	player:Log("OnCommand_FriendRequest, "..DumpTable(arg).." others="..DumpTable(others))

	local d_role = others[arg.dest_id]
	if d_role==nil then return end
	--不要发给自己
	if d_role._base._id:ToStr()==role._base._id:ToStr() then return end

	--已经是好友?
	local friends = role._friend._friends
	if friends:Find(CACHE.Int64:new(arg.dest_id))~=nil then return end

	local reqs = d_role._friend._requests
	--已经申请过了?
	local rit = reqs:SeekToBegin()
	local r = rit:GetValue()
	while r~=nil do
		if r._brief._id:ToStr()==role._base._id:ToStr() then return end
		rit:Next()
		r = rit:GetValue()
	end

	--申请太多, 则删掉早期的申请
	while reqs:Size()>=10 do reqs:PopFront() end

	--保存到申请列表
	local nr = CACHE.FriendRequest:new()
	nr._brief._id = role._base._id
	nr._brief._name = role._base._namme
	nr._brief._photo = role._base._photo
	nr._brief._level = role._status._level
	reqs:PushBack(nr)
	
	--通知目标
	local cmd = NewCommand("FriendRequest")
	cmd.dest_id = d_role._base._id:ToStr()
	cmd.src = {}
	cmd.src.id = role._base._id:ToStr()
	cmd.src.name = role._base._name
	cmd.src.photo = role._base._photo
	cmd.src.level = role._status._level
	d_role:SendToClient(SerializeCommand(cmd))
end
