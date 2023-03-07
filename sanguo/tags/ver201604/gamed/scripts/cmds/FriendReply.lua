function OnCommand_FriendReply(player, role, arg, others)
	player:Log("OnCommand_FriendReply, "..DumpTable(arg).." others="..DumpTable(others))
--if true then return end

	local s_role = others[arg.src_id]
	if s_role==nil then return end

	local reqs = role._friend._requests
	--查找申请
	local rit = reqs:SeekToBegin()
	local r = rit:GetValue()
	while r~=nil
	do
		if r._brief._id:ToStr()==s_role._base._id:ToStr() then
			--互加好友
			local nf = CACHE.Friend:new()
			nf._brief._id = role._base._id
			nf._brief._name = role._base._name
			nf._brief._photo = role._base._photo
			nf._brief._level = role._status._level
			s_role._friend._friends:Insert(nf._brief._id, nf)

			nf._brief._id = s_role._base._id
			nf._brief._name = s_role._base._name
			nf._brief._photo = s_role._base._photo
			nf._brief._level = s_role._status._level
			role._friend._friends:Insert(nf._brief._id, nf)

			--通知双方
			local cmd = NewCommand("NewFriend")
			cmd.friend = {}
			cmd.friend.id = role._base._id:ToStr()
			cmd.friend.name = role._base._name
			cmd.friend.photo = role._base._photo
			cmd.friend.level = role._status._level
			s_role:SendToClient(SerializeCommand(cmd))

			cmd.friend.id = s_role._base._id:ToStr()
			cmd.friend.name = s_role._base._name
			cmd.friend.photo = s_role._base._photo
			cmd.friend.level = s_role._status._level
			role:SendToClient(SerializeCommand(cmd))

			rit:Pop()
			return
		end

		rit:Next()
		r = rit:GetValue()
	end
end
