function OnCommand_GetShopRecoveryTime(player, role, arg, others)
	player:Log("OnCommand_GetShopRecoveryTime, "..DumpTable(arg).." "..DumpTable(others))

	local shop = role._roledata._private_shop:Find(arg.shop_id)
	if shop == nil then
		player:Log("OnCommand_GetShopRecoveryTime, error=PRIVATE_SHOP_ERR")
		return
	end 

	local resp = NewCommand("GetShopRecoveryTime_Re")
	resp.shop_id = arg.shop_id
	resp.refresh_times = shop._refresh_times
	resp.recovery_time = shop._recovery_time
	player:SendToClient(SerializeCommand(resp))
	return
end
