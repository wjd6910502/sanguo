function OnCommand_DaTiUseTime(player, role, arg, others)
	player:Log("OnCommand_DaTiUseTime, "..DumpTable(arg).." "..DumpTable(others))

	if arg.use_time < 0 then
		return
	end

	role._roledata._dati_data._use_time = math.ceil(arg.use_time)

end
