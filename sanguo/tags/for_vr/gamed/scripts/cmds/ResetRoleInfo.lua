function OnCommand_ResetRoleInfo(player, role, arg, others)
	player:Log("OnCommand_ResetRoleInfo, "..DumpTable(arg).." "..DumpTable(others))

	--现在目前就这一个变量需要进行重置
	role._roledata._pvp._state = 0

	--在这里告诉center去把自己的房间号删掉去
	if role._roledata._pvp._id ~= 0 then
		role:SendPVPReset()
	end
end
