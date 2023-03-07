function OnCommand_GetSkillPointRefreshTime(player, role, arg, others)
	player:Log("OnCommand_GetSkillPointRefreshTime, "..DumpTable(arg).." "..DumpTable(others))

	local resp = NewCommand("GetSkillPointRefreshTime_Re")
	resp.refresh_time = role._roledata._status._hero_skill_point_refreshtime

	player:SendToClient(SerializeCommand(resp))
end
