function OnMessage_RoleUpdateTopList(player, role, arg, others)
	player:Log("OnMessage_RoleUpdateTopList, "..DumpTable(arg).." "..DumpTable(others))
	
	TOP_InsertData(others.top._top_manager, arg.top_type, role._roledata._base._id, arg.data, role._roledata._base._name, role._roledata._base._photo)
end
