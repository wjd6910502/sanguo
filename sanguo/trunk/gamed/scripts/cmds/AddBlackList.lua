function OnCommand_AddBlackList(player, role, arg, others)
	player:Log("OnCommand_AddBlackList, "..DumpTable(arg).." "..DumpTable(others))

	local dest_role = others.roles[arg.roleid]

	--不可以把自己加到黑名单里面去呀。
	if role._roledata._base._id:ToStr() == dest_role._roledata._base._id:ToStr() then
		return 
	end

	--查看这个玩家是否已经被加入到黑名单中了。
	local blacklist = role._roledata._friend._blacklist
	local value = blacklist:Find(dest_role._roledata._base._id)
	if value ~= nil then
		local cmd = NewCommand("ErrorInfo")
		cmd.error_id = G_ERRCODE["BLACKLIST_HAVE"]
		player:SendToClient(SerializeCommand(cmd))
		return
	end

	--查看这个人是否是好友，如果是好友的话那么就不可以添加黑名单
	if role._roledata._friend._friends:Find(dest_role._roledata._base._id) ~= nil then
		local cmd = NewCommand("ErrorInfo")
		cmd.error_id = G_ERRCODE["BLACKLIST_FRIEND"]
		player:SendToClient(SerializeCommand(cmd))
		player:Log("OnCommand_AddBlackList, error=BLACKLIST_FRIEND")                    
		return
	end

	local value = CACHE.BlackList()
	value._brief._id = dest_role._roledata._base._id
	value._brief._name = dest_role._roledata._base._name
	value._brief._photo = dest_role._roledata._base._photo
	--这几个信息先不保存的。因为改变性太大了。前面三个是比较准确的。
	--value._brief._level = role._roledata._status._level
	--value._brief._mafia_id:Set(role._roledata._mafia._id)
	--value._brief._mafia_name = role._roledata._mafia._name
	
	blacklist:Insert(dest_role._roledata._base._id, value)

	local resp = NewCommand("AddBlackList_Re")
	resp.roleinfo = {}
	resp.roleinfo.id = dest_role._roledata._base._id:ToStr()
	resp.roleinfo.name = dest_role._roledata._base._name
	resp.roleinfo.photo = dest_role._roledata._base._photo

	player:SendToClient(SerializeCommand(resp))
	return
end
