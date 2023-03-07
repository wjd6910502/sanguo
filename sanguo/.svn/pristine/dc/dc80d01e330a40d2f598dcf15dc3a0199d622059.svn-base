function OnCommand_FlowerGiftTipsClear(player, role, arg, others)
	player:Log("OnCommand_FlowerGiftTipsClear, "..DumpTable(arg).." "..DumpTable(others))
	role._roledata._flower_info._recive_flag = 0
	local cmd = NewCommand("FlowerGiftTipsClear_Re")
	cmd.flag = role._roledata._flower_info._recive_flag
	role:SendToClient(SerializeCommand(cmd))
end
