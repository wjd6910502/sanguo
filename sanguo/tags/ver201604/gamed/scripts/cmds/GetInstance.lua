function OnCommand_GetInstance(player, role, arg, others)
	player:Log("OnCommand_GetInstance, "..DumpTable(arg))
	local resp = NewCommand("GetInstance_Re")
	resp.info = {}

	local instance = role._roledata._status._instances
	local iit = instance:SeekToBegin()
	local i = iit:GetValue()
	while i ~= nil do
		local temp = {}
		temp.id = i._tid
		temp.star = i._star
		resp.info[#resp.info+1] = temp
		iit:Next()
		i = iit:GetValue()
	end
	resp.retcode = G_ERRCODE["SUCCESS"]
	player:SendToClient(SerializeCommand(resp))

end
