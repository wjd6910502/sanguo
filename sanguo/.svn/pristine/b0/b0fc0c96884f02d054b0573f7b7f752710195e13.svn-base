function OnCommand_ListFriends(player, role, arg, others)
	player:Log("OnCommand_ListFriends, "..DumpTable(arg))

	local resp = NewCommand("ListFriends_Re")
	resp.friends = {}
	resp.requests = {}
	--填充friends
	local friends = role._friend._friends
	local fit = friends:SeekToBegin() --从头开始遍历
	local f = fit:GetValue()
	while f~=nil do
		local f2 = {}
		f2.id = f._brief._id:ToStr()
		f2.name = f._brief._name
		f2.photo = f._brief._photo
		f2.level = f._brief._level
		resp.friends[#resp.friends+1] = f2
		fit:Next()
		f = fit:GetValue()
	end
	--填充requests
	local reqs = role._friend._requests
	local rit = reqs:SeekToBegin() --从头开始遍历
	local r = rit:GetValue()
	while r~=nil do
		local f2 = {}
		f2.id = r._brief._id:ToStr()
		f2.name = r._brief._name
		f2.photo = r._brief._photo
		f2.level = r._brief._level
		resp.friends[#resp.friends+1] = f2
		rit:Next()
		r = rit:GetValue()
	end
	player:SendToClient(SerializeCommand(resp))
end
