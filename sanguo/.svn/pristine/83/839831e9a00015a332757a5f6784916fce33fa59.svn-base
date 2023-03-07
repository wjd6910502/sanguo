function OnCommand_BuyRefreshShopTimes(player, role, arg, others)
	player:Log("OnCommand_BuyRefreshShopTimes, "..DumpTable(arg).." "..DumpTable(others))
	local resp = NewCommand("BuyRefreshShopTimes_Re")

	local shop = role._roledata._private_shop:Find(arg.shop_id)
	if shop == nil then
		resp.retcode = G_ERRCODE["PRIVATE_SHOP_ERR"]
		player:SendToClient(SerializeCommand(resp))
		player:Log("OnCommand_BuyRefreshShopTimes, error=PRIVATE_SHOP_ERR")
		return
	end
	
	local ed = DataPool_Find("elementdata")
	local private_shop = ed:FindBy("shop_id", arg.shop_id)

	if private_shop.refresh_times_buy_max == 0 then
		resp.retcode = G_ERRCODE["PRIVATE_SHOP_CONNOT_BUY_REFRESH_TIME"]
		player:SendToClient(SerializeCommand(resp))
		player:Log("OnCommand_BuyRefreshShopTimes, error=PRIVATE_SHOP_CONNOT_BUY_REFRESH_TIME")
		return
	end

	if LIMIT_TestUseLimit(role, private_shop.refresh_times_buy_max, 1) == false then
		resp.retcode = G_ERRCODE["PRIVATE_SHOP_REFRESH_TIME_MAX"]
		player:SendToClient(SerializeCommand(resp))
		player:Log("OnCommand_BuyRefreshShopTimes, error=PRIVATE_SHOP_REFRESH_TIME_MAX")
		return
	end

	local need_money = 0
	local buy_count = LIMIT_GetUseLimit(role, private_shop.refresh_times_buy_max)
	local buy_flag = 0
	for money in DataPool_Array(private_shop.refresh_cost) do
		if buy_flag == buy_count then
			need_money = money
			break
		end
		if money > need_money then
			need_money = money
		end
		buy_flag = buy_flag + 1
	end
	if need_money == 0 then
		resp.retcode = G_ERRCODE["PRIVATE_SHOP_REFRESH_PRICE_ERR"]
		player:SendToClient(SerializeCommand(resp))
		player:Log("OnCommand_BuyRefreshShopTimes, error=PRIVATE_SHOP_REFRESH_PRICE_ERR")
		return
	end
	local currency = ed:FindBy("currency_id", private_shop.refresh_currency_type)

	if currency.currency_type == 1 then
		if need_money > role._roledata._status._money then
			resp.retcode = G_ERRCODE["PRIVATE_SHOP_MONEY_LESS"]
			player:SendToClient(SerializeCommand(resp))
			player:Log("OnCommand_BuyRefreshShopTimes, error=PRIVATE_SHOP_MONEY_LESS")
			return
		end
		ROLE_SubMoney(role, need_money)
	elseif currency.currency_type == 2 then
		if need_money > role._roledata._status._yuanbao then
			resp.retcode = G_ERRCODE["PRIVATE_SHOP_YUANBAO_LESS"]
			player:SendToClient(SerializeCommand(resp))
			player:Log("OnCommand_BuyRefreshShopTimes, error=PRIVATE_SHOP_YUANBAO_LESS")
			return
		end
		ROLE_SubYuanBao(role, need_money)
	elseif currency.currency_type == 4 then
		local repnum = ROLE_GetRep(role, currency.rep_id)
		if need_money > repnum then
			resp.retcode = G_ERRCODE["PRIVATE_SHOP_REP_LESS"]
			player:SendToClient(SerializeCommand(resp))
			player:Log("OnCommand_BuyRefreshShopTimes, error=PRIVATE_SHOP_REP_LESS")
			return
		end
		ROLE_SubRep(role, currency.rep_id, need_money)
	else
		resp.retcode = G_ERRCODE["PRIVATE_SHOP_MONEY_TYPE_ERR"]
		player:SendToClient(SerializeCommand(resp))
		player:Log("OnCommand_BuyRefreshShopTimes, error=PRIVATE_SHOP_MONEY_TYPE_ERR")
		return
	end
	LIMIT_AddUseLimit(role, private_shop.refresh_times_buy_max, 1)

	shop._refresh_times = shop._refresh_times + 1
	if shop._refresh_times >= private_shop.refresh_times then
		shop._recovery_time = 0
	end

	resp.retcode = G_ERRCODE["SUCCESS"]
	resp.shop_id = arg.shop_id
	player:SendToClient(SerializeCommand(resp))

	local resp = NewCommand("GetShopRecoveryTime_Re")
	resp.shop_id = arg.shop_id
	resp.refresh_times = shop._refresh_times
	resp.recovery_time = shop._recovery_time
	player:SendToClient(SerializeCommand(resp))
	
	return
end
