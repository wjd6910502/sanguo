function OnCommand_MysteryShopBuyItem(player, role, arg, others)
	player:Log("OnCommand_MysteryShopBuyItem, "..DumpTable(arg).." "..DumpTable(others))

	local resp = NewCommand("MysteryShopBuyItem_Re")
	resp.shop_id = arg.shop_id
	resp.position = arg.position
	resp.item_id = arg.item_id

	local shop = role._roledata._private_shop:Find(arg.shop_id)
	if shop == nil then
		resp.retcode = G_ERRCODE["PRIVATE_SHOP_ERR"]
		player:SendToClient(SerializeCommand(resp))
		return
	end

	local shop_data = shop._shop_data
	local shop_data_it = shop_data:SeekToBegin()
	local item_data = shop_data_it:GetValue()
	local position = 1
	while item_data ~= nil do
		if position == arg.position then
			if item_data._item_id == arg.item_id then
				if item_data._buy_count >= item_data._max_count then
					resp.retcode = G_ERRCODE["PRIVATE_SHOP_BUY_MAX"]
					role:SendToClient(SerializeCommand(resp))
					return
				end
				local ed = DataPool_Find("elementdata")
				local shopitem_info = ed:FindBy("shopitem_id", arg.item_id)
				if shopitem_info == nil then
					resp.retcode = G_ERRCODE["PRIVATE_SHOP_ITEM_NOT_EXIST"]
					role:SendToClient(SerializeCommand(resp))
					return
				end
				local need_money = shopitem_info.price
				local currency = ed:FindBy("currency_id", shopitem_info.currency)
				if currency.currency_type == 1 then
					if need_money > role._roledata._status._money then
						resp.retcode = G_ERRCODE["PRIVATE_SHOP_MONEY_LESS"]
						player:SendToClient(SerializeCommand(resp))
						return
					end
					ROLE_SubMoney(role, need_money)
				elseif currency.currency_type == 2 then
					if need_money > role._roledata._status._yuanbao then
						resp.retcode = G_ERRCODE["PRIVATE_SHOP_YUANBAO_LESS"]
						player:SendToClient(SerializeCommand(resp))
						return
					end
					ROLE_SubYuanBao(role, need_money)
				elseif currency.currency_type == 4 then
					local repnum = ROLE_GetRep(role, currency.rep_id)
					if need_money > repnum then
						resp.retcode = G_ERRCODE["PRIVATE_SHOP_REP_LESS"]
						player:SendToClient(SerializeCommand(resp))
						return
					end
					ROLE_SubRep(role, currency.rep_id, need_money)
				else
					resp.retcode = G_ERRCODE["PRIVATE_SHOP_MONEY_TYPE_ERR"]
					player:SendToClient(SerializeCommand(resp))
					return
				end
				item_data._buy_count = item_data._buy_count + 1
				BACKPACK_AddItem(role, shopitem_info.itemid, shopitem_info.nums)
				resp.retcode = G_ERRCODE["SUCCESS"]
				resp.buy_count = item_data._buy_count
				player:SendToClient(SerializeCommand(resp))
				return
			else
				resp.retcode = G_ERRCODE["PRIVATE_SHOP_ITEM_INFO_ERR"]
				role:SendToClient(SerializeCommand(resp))
				return
			end
		end
		position = position + 1
		shop_data_it:Next()
		item_data = shop_data_it:GetValue()
	end
	resp.retcode = G_ERRCODE["PRIVATE_SHOP_ERR"]
	player:SendToClient(SerializeCommand(resp))
	return
end
