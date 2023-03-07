function OnCommand_MallBuyItem(player, role, arg, others)
	player:Log("OnCommand_MallBuyItem, "..DumpTable(arg).." "..DumpTable(others))

	local resp = NewCommand("MallBuyItem_Re")

	local ed = DataPool_Find("elementdata")
	local mallitem = ed:FindBy("mallitem_id", arg.item_id)

	if arg.item_num <= 0 then
		resp.retcode = G_ERRCODE["MALLITEM_ID_ERR"]
		player:SendToClient(SerializeCommand(resp))
		return
	end

	if mallitem == nil then
		resp.retcode = G_ERRCODE["MALLITEM_ID_ERR"]
		player:SendToClient(SerializeCommand(resp))
		return
	end

	if mallitem.limit_times_id ~= 0 then
		--检查自己是否次数足够
		if LIMIT_TestUseLimit(role, mallitem.limit_times_id, arg.item_num) == false then
			resp.retcode = G_ERRCODE["MALLITEM_MAX_ERR"]
			player:SendToClient(SerializeCommand(resp))
			return
		end
	end

	--查看具体的支付方式去
	local currency = ed:FindBy("currency_id", mallitem.currency)
	if currency.currency_type == 1 then
		--检查需要的金币是否足够
		local needmoney = 0
		if mallitem.limit_times_id == 0 then
			if currency.price[1] <= 0 then
				resp.retcode = G_ERRCODE["MALLITEM_TEM_MONEY_ERR"]
				player:SendToClient(SerializeCommand(resp))
				return
			end
			needmoney = arg.item_num*currency.price[1]
		else
			local count = LIMIT_GetUseLimit(role, mallitem.limit_times_id)
			local flag = 0
			local buy_count = 0
			local max_price = 0
			for price in DataPool_Array(mallitem.price) do
				if price > max_price then
					max_price = price
				end
				if flag == count then
					if 0 >= price then
						if max_price == 0 then
							resp.retcode = G_ERRCODE["MALLITEM_TEM_MONEY_ERR"]
							player:SendToClient(SerializeCommand(resp))
							return
						end
						
						needmoney = needmoney + max_price
						buy_count = buy_count + 1
						count = count + 1
						if buy_count >= arg.item_num then
							break
						end

					else
						needmoney = needmoney + price
						buy_count = buy_count + 1
						count = count + 1
						if buy_count >= arg.item_num then
							break
						end
					end
				end
				flag = flag + 1
			end
			if buy_count < arg.item_num then
				--说明配置的有问题.配置的次数和购买的模板上限不一致了
				if max_price == 0 then
					resp.retcode = G_ERRCODE["MALLITEM_TEM_ERR"]
					player:SendToClient(SerializeCommand(resp))
					return
				end
				needmoney = needmoney + max_price*(arg.item_num - buy_count)
			end
		end
		if needmoney > role._roledata._status._money then
			resp.retcode = G_ERRCODE["MALLITEM_MONEY_LESS"]
			player:SendToClient(SerializeCommand(resp))
			return
		end

		--扣钱给物品，给客户端返回去正确
		ROLE_SubMoney(role, needmoney)
		if mallitem.limit_times_id ~= 0 then
			LIMIT_AddUseLimit(role, mallitem.limit_times_id, arg.item_num)
		end
		BACKPACK_AddItem(role, mallitem.itemid, mallitem.nums*arg.item_num)
		resp.retcode = G_ERRCODE["SUCCESS"]
		player:SendToClient(SerializeCommand(resp))
		return
	elseif currency.currency_type == 2 then
		--需要的勾玉是否足够
		local needmoney = 0
		if mallitem.limit_times_id == 0 then
			if currency.price[1] <= 0 then
				resp.retcode = G_ERRCODE["MALLITEM_TEM_MONEY_ERR"]
				player:SendToClient(SerializeCommand(resp))
				return
			end
			needmoney = arg.item_num*currency.price[1]
		else
			local count = LIMIT_GetUseLimit(role, mallitem.limit_times_id)
			local flag = 0
			local buy_count = 0
			local max_price = 0
			for price in DataPool_Array(mallitem.price) do
				if price > max_price then
					max_price = price
				end
				if flag == count then
					if 0 >= price then
						if max_price == 0 then
							resp.retcode = G_ERRCODE["MALLITEM_TEM_MONEY_ERR"]
							player:SendToClient(SerializeCommand(resp))
							return
						end

						needmoney = needmoney + max_price
						buy_count = buy_count + 1
						count = count + 1
						if buy_count >= arg.item_num then
							break
						end

					else
						needmoney = needmoney + price
						buy_count = buy_count + 1
						count = count + 1
						if buy_count >= arg.item_num then
							break
						end
					end
				end
				flag = flag + 1
			end
			if buy_count < arg.item_num then
				--说明配置的有问题.配置的次数和购买的模板上限不一致了
				if max_price == 0 then
					resp.retcode = G_ERRCODE["MALLITEM_TEM_ERR"]
					player:SendToClient(SerializeCommand(resp))
					return
				end
				needmoney = needmoney + max_price*(arg.item_num-buy_count)
			end
		end
		if needmoney > role._roledata._status._yuanbao then
			resp.retcode = G_ERRCODE["MALLITEM_YUANBAO_LESS"]
			player:SendToClient(SerializeCommand(resp))
			return
		end

		--扣钱给物品，给客户端返回去正确
		ROLE_SubYuanBao(role, needmoney)
		if mallitem.limit_times_id ~= 0 then
			LIMIT_AddUseLimit(role, mallitem.limit_times_id, arg.item_num)
		end
		BACKPACK_AddItem(role, mallitem.itemid, mallitem.nums*arg.item_num)
		resp.retcode = G_ERRCODE["SUCCESS"]
		player:SendToClient(SerializeCommand(resp))
		return
	elseif currency.currency_type == 4 then
		--使用的声望来进行购买
		local needmoney = 0
		if mallitem.limit_times_id == 0 then
			if currency.price[1] <= 0 then
				resp.retcode = G_ERRCODE["MALLITEM_TEM_MONEY_ERR"]
				player:SendToClient(SerializeCommand(resp))
				return
			end
			needmoney = arg.item_num*currency.price[1]
		else
			local count = LIMIT_GetUseLimit(role, mallitem.limit_times_id)
			local flag = 0
			local buy_count = 0
			local max_price = 0
			for price in DataPool_Array(mallitem.price) do
				if price > max_price then
					max_price = price
				end
				if flag == count then
					if 0 >= price then
						if max_price == 0 then
							resp.retcode = G_ERRCODE["MALLITEM_TEM_MONEY_ERR"]
							player:SendToClient(SerializeCommand(resp))
							return
						end
						
						needmoney = needmoney + max_price
						buy_count = buy_count + 1
						count = count + 1
						if buy_count >= arg.item_num then
							break
						end
					else
						needmoney = needmoney + price
						buy_count = buy_count + 1
						count = count + 1
						if buy_count >= arg.item_num then
							break
						end
					end
				end
				flag = flag + 1
			end
			if buy_count < arg.item_num then
				--说明配置的有问题.配置的次数和购买的模板上限不一致了
				if max_price == 0 then
					resp.retcode = G_ERRCODE["MALLITEM_TEM_ERR"]
					player:SendToClient(SerializeCommand(resp))
					return
				end
				needmoney = needmoney + max_price*(arg.item_num - buy_count)
			end
		end

		local repnum = ROLE_GetRep(role, currency.rep_id)
		if needmoney > repnum then
			resp.retcode = G_ERRCODE["MALLITEM_REP_LESS"]
			player:SendToClient(SerializeCommand(resp))
			return
		end

		--扣钱给物品，给客户端返回去正确
		ROLE_SubRep(role, currency.rep_id, needmoney)
		if mallitem.limit_times_id ~= 0 then
			LIMIT_AddUseLimit(role, mallitem.limit_times_id, arg.item_num)
		end
		BACKPACK_AddItem(role, mallitem.itemid, mallitem.nums*arg.item_num)
		resp.retcode = G_ERRCODE["SUCCESS"]
		player:SendToClient(SerializeCommand(resp))
		return
	end
end
