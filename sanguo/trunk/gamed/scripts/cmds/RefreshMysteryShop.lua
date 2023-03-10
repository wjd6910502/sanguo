function OnCommand_RefreshMysteryShop(player, role, arg, others)
	player:Log("OnCommand_RefreshMysteryShop, "..DumpTable(arg).." "..DumpTable(others))

	local resp = NewCommand("RefreshMysteryShop_Re")
	resp.shop_id = arg.shop_id

	local ed = DataPool_Find("elementdata")
	local shop = ed:FindBy("shop_id", arg.shop_id)
	if shop == nil then
		resp.retcode = G_ERRCODE["PRIVATE_SHOP_ERR"]
		player:SendToClient(SerializeCommand(resp))
		player:Log("OnCommand_RefreshMysteryShop, error=PRIVATE_SHOP_ERR")
		return
	end
	
	local private_shop = role._roledata._private_shop:Find(arg.shop_id)

	--查看商店是否有手动刷新限次
	if shop.refresh_times ~= 0 then
		if private_shop._refresh_times > 0 then
			PRIVATE_RefreshShop(role, arg.shop_id)
			private_shop._refresh_times = private_shop._refresh_times - 1
			if private_shop._refresh_times < shop.refresh_times then
				if shop.refresh_times_auto_renew ~= 0 and private_shop._recovery_time == 0 then
					private_shop._recovery_time = API_GetTime()
				end
			end

			player:Log("OnCommand_RefreshMysteryShop, by refresh_times, cur_refresh_times:"..private_shop._refresh_times)
			resp.retcode = G_ERRCODE["SUCCESS"]
			resp.shop_id = arg.shop_id
			player:SendToClient(SerializeCommand(resp))

			local resp = NewCommand("GetShopRecoveryTime_Re")
			resp.shop_id = arg.shop_id
			resp.refresh_times = private_shop._refresh_times
			resp.recovery_time = private_shop._recovery_time
			player:SendToClient(SerializeCommand(resp))
			return
		else
			resp.retcode = G_ERRCODE["PRIVATE_SHOP_REFRESH_MAX"]
			player:SendToClient(SerializeCommand(resp))
			player:Log("OnCommand_RefreshMysteryShop, error=PRIVATE_SHOP_REFRESH_MAX")
			return
		end
	end
	
	--查看这个商店的付费刷新次数
	local limit_id = 0
	if shop.refresh_id ~= 0 then
		if LIMIT_TestUseLimit(role, shop.refresh_id, 1) == false then
			resp.retcode = G_ERRCODE["PRIVATE_SHOP_REFRESH_MAX"]
			player:SendToClient(SerializeCommand(resp))
			player:Log("OnCommand_RefreshMysteryShop, error=PRIVATE_SHOP_REFRESH_MAX")
			return
		else
			limit_id = shop.refresh_id
		end
	else
		resp.retcode = G_ERRCODE["PRIVATE_SHOP_CANOT_REFRESH"]
		player:SendToClient(SerializeCommand(resp))
		player:Log("OnCommand_RefreshMysteryShop, error=PRIVATE_SHOP_CANOT_REFRESH")
		return
	end

	local need_money = 0
	local buy_count = LIMIT_GetUseLimit(role, limit_id)
	local buy_flag = 0
	for money in DataPool_Array(shop.refresh_cost) do
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
		player:Log("OnCommand_RefreshMysteryShop, error=PRIVATE_SHOP_REFRESH_PRICE_ERR")
		return
	end
	local currency = ed:FindBy("currency_id", shop.refresh_currency_type)

	if currency.currency_type == 1 then
		if need_money > role._roledata._status._money then
			resp.retcode = G_ERRCODE["PRIVATE_SHOP_MONEY_LESS"]
			player:SendToClient(SerializeCommand(resp))
			player:Log("OnCommand_RefreshMysteryShop, error=PRIVATE_SHOP_MONEY_LESS")
			return
		end
		ROLE_SubMoney(role, need_money)
		PRIVATE_RefreshShop(role, arg.shop_id)
	elseif currency.currency_type == 2 then
		if need_money > role._roledata._status._yuanbao then
			resp.retcode = G_ERRCODE["PRIVATE_SHOP_YUANBAO_LESS"]
			player:SendToClient(SerializeCommand(resp))
			player:Log("OnCommand_RefreshMysteryShop, error=PRIVATE_SHOP_YUANBAO_LESS")
			return
		end
		ROLE_SubYuanBao(role, need_money)
		PRIVATE_RefreshShop(role, arg.shop_id)
	elseif currency.currency_type == 4 then
		local repnum = ROLE_GetRep(role, currency.rep_id)
		if need_money > repnum then
			resp.retcode = G_ERRCODE["PRIVATE_SHOP_REP_LESS"]
			player:SendToClient(SerializeCommand(resp))
			player:Log("OnCommand_RefreshMysteryShop, error=PRIVATE_SHOP_REP_LESS")
			return
		end
		ROLE_SubRep(role, currency.rep_id, need_money)
		PRIVATE_RefreshShop(role, arg.shop_id)
	else
		resp.retcode = G_ERRCODE["PRIVATE_SHOP_MONEY_TYPE_ERR"]
		player:SendToClient(SerializeCommand(resp))
		player:Log("OnCommand_RefreshMysteryShop, error=PRIVATE_SHOP_MONEY_TYPE_ERR")
		return
	end
	LIMIT_AddUseLimit(role, limit_id, 1)
	resp.retcode = G_ERRCODE["SUCCESS"]
	player:SendToClient(SerializeCommand(resp))
	return
end
