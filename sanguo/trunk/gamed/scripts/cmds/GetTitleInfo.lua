function OnCommand_GetTitleInfo(player, role, arg, others)
	player:Log("OnCommand_GetTitleInfo, "..DumpTable(arg).." "..DumpTable(others))
	--[[	
	local cmd = NewCommand("GetTitleInfo_Re")
	
	if arg.id == role._roledata._base._id:ToStr() then
		cmd.info = ROLE_MakeRoleBrief(role)
		cmd.cur_title = role._roledata._flower_info._cur_title
		
		role:SendToClient(serialize(cmd))
	else
		local dest_role = others.roles[arg.id]
		cmd.info = ROLE_MakeRoleBrief(dest_role)
		cmd.cur_title = dest_role._roledata._flower_info._cur_title
	
		dest_role:SendToClient(serialize(cmd))
	end	
	--]]
	


















end
