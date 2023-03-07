function OnMessage_UpdateRoleInfo(player, role, arg, others)
	player:Log("OnMessage_UpdateRoleInfo, "..DumpTable(arg))

	local friends = role._roledata._friend._friends
	local f = friends:Find(CACHE.Int64:new(arg.id))
	if f==nil then return end

	--f._brief._id = arg.id 
	f._brief._name = arg.name
	f._brief._photo = arg.photo
	f._brief._level = arg.level
end
