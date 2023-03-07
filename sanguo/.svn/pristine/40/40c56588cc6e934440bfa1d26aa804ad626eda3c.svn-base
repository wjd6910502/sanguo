function OnCommand_WeaponMakeLevelUp(player, role, arg, others)
	player:Log("OnCommand_WeaponMakeLevelUp, "..DumpTable(arg).." "..DumpTable(others))
	
	local resp = NewCommand("WeaponMakeLevelUp_Re")
	
	local ed = DataPool_Find("elementdata")
	while 1 do
		local library = ed:FindBy("librarylevel_id", role._roledata._make_data._level)
		if library == nil or
		   library.lvup_need_score == 0 or
		   library.lvup_need_score > role._roledata._make_data._exp then
			break
		end
		role._roledata._make_data._level = role._roledata._make_data._level + 1
	end

	resp.level = role._roledata._make_data._level
	player:SendToClient(SerializeCommand(resp))	
end
