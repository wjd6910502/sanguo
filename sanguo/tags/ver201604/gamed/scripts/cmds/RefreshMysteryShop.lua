function OnCommand_RefreshMysteryShop(player, role, arg, others)
	player:Log("OnCommand_RefreshMysteryShop, "..DumpTable(arg).." "..DumpTable(others))

	local resp = NewCommand("RefreshMysteryShop_Re")
	resp.shop_id = arg.shop_id

	local ed = DataPool_Find("elementdata")
	local shop = ed:FindBy("shop_id", arg.shop_id)
	if shop == nil then
		resp.retcode = G_ERRCODE["PRIVATE_SHOP_ERR"]
		player:SendToClient(SerializeCommand(resp))
		return
	end
	
	--查看这个商店的刷新次数
	if shop.refresh_id == 0 then
		resp.retcode = G_ERRCODE["PRIVATE_SHOP_CANOT_REFRESH"]
		player:SendToClient(SerializeCommand(resp))
		return
	end

	if LIMIT_TestUseLimit(role, shop.refresh_id, 1) == false then
		resp.retcode = G_ERRCODE["PRIVATE_SHOP_REFRESH_MAX"]
		player:SendToClient(SerializeCommand(resp))
		return
	end

	local need_money = 0
	local buy_count = LIMIT_GetUseLimit(role, shop.refresh_id)
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
		return
	end
	local currency = ed:FindBy("currency_id", shop.refresh_currency_type)

	if currency.currency_type == 1 then
		if need_money > role._roledata._status._money then
			resp.retcode = G_ERRCODE["PRIVATE_SHOP_MONEY_LESS"]
			player:SendToClient(SerializeCommand(resp))
			return
		end
		ROLE_SubMoney(role, need_money)
		PRIVATE_RefreshShop(role, arg.shop_id)
	elseif currency.currency_type == 2 then
		if need_money > role._roledata._status._yuanbao then
			resp.retcode = G_ERRCODE["PRIVATE_SHOP_YUANBAO_LESS"]
			player:SendToClient(SerializeCommand(resp))
			return
		end
		ROLE_SubYuanBao(role, need_money)
		PRIVATE_RefreshShop(role, arg.shop_id)
	elseif currency.currency_type == 4 then
		local repnum = ROLE_GetRep(role, currency.rep_id)
		if need_money > repnum then
			resp.retcode = G_ERRCODE["PRIVATE_SHOP_REP_LESS"]
			player:SendToClient(SerializeCommand(resp))
			return
		end
		ROLE_SubRep(role, currency.rep_id, need_money)
		PRIVATE_RefreshShop(role, arg.shop_id)
	else
		resp.retcode = G_ERRCODE["PRIVATE_SHOP_MONEY_TYPE_ERR"]
		player:SendToClient(SerializeCommand(resp))
		return
	end
	LIMIT_AddUseLimit(role, shop.refresh_id, 1)
	resp.retcode = G_ERRCODE["SUCCESS"]
	player:SendToClient(SerializeCommand(resp))
	return
end
