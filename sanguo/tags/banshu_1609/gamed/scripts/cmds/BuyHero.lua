function OnCommand_BuyHero(player, role, arg, others)
	player:Log("OnCommand_BuyHero, "..DumpTable(arg).." "..DumpTable(others))

	local resp = NewCommand("BuyHero_Re")
	resp.retcode = G_ERRCODE["SUCCESS"]

	if arg.tid <= 0 then
		resp.retcode = G_ERRCODE["HERO_ID_ERROR"]
		player:SendToClient(SerializeCommand(resp))
		return
	end

	local hero_map = role._roledata._hero_hall._heros
	local h = hero_map:Find(arg.tid)
	if h ~= nil then
		resp.retcode = G_ERRCODE["HAVED_HERO"]
		player:SendToClient(SerializeCommand(resp))
		return
	end
	
	local ed = DataPool_Find("elementdata")
	local hero = ed:FindBy("hero_id", arg.tid)

	if hero == nil then
		resp.retcode = G_ERRCODE["HERO_ID_ERROR"]
		player:SendToClient(SerializeCommand(resp))
		return
	end

	if hero.purchasable == 0 then
		resp.retcode = G_ERRCODE["HERO_CAN_NOT_BUY"]
		player:SendToClient(SerializeCommand(resp))
		return
	end

	local need_money = 0
	local need_yuanbao = 0
	local need_soul = 0
	if hero.coindiscount ~= 0 then
		need_money = hero.coindiscount
	else
		need_money = hero.coinprice
	end

	if hero.bulliondiscount ~= 0 then
		need_yuanbao = hero.bulliondiscount
	else
		need_yuanbao = hero.bullionprice
	end

	if hero.soulID ~= 0 then
		need_soul = hero.composesoul
	end

	--1代表的是铜币购买，2代表的是元宝购买, 3代表的是使用碎片购买
	if arg.typ == 1 then
		if need_money == 0 then
			resp.retcode = G_ERRCODE["HERO_BUY_MONEY_LESS"]
			player:SendToClient(SerializeCommand(resp))
			return
		end
		if role._roledata._status._money < need_money then
			resp.retcode = G_ERRCODE["HERO_BUY_MONEY_LESS"]
			player:SendToClient(SerializeCommand(resp))
			return
		end
		ROLE_SubMoney(role, need_money)
	elseif arg.typ == 2 then
		if need_yuanbao == 0 then
			resp.retcode = G_ERRCODE["VP_LESS_YUANBAO"]
			player:SendToClient(SerializeCommand(resp))
			return
		end
		if role._roledata._status._yuanbao < need_yuanbao then
			resp.retcode = G_ERRCODE["VP_LESS_YUANBAO"]
			player:SendToClient(SerializeCommand(resp))
			return
		end
		ROLE_SubYuanBao(role, need_yuanbao)
	elseif arg.typ == 3 then
		--local soul = role._roledata._hero_soul:Find(hero.soulID)
		--if soul == nil or soul._num < need_soul then
		--	resp.retcode = G_ERRCODE["HERO_BUY_SOUL_LESS"]
		--	player:SendToClient(SerializeCommand(resp))
		--	return
		--end
		if need_soul == 0 then
			resp.retcode = G_ERRCODE["HERO_BUY_SOUL_LESS"]
			player:SendToClient(SerializeCommand(resp))
			return
		end
		if BACKPACK_HaveItem(role, hero.soulID, need_soul) == false then
			resp.retcode = G_ERRCODE["HERO_BUY_SOUL_LESS"]
			player:SendToClient(SerializeCommand(resp))
			return
		end
		BACKPACK_DelItem(role, hero.soulID, need_soul)
		--ROLE_SubSoul(role, hero.soulID, need_soul)
	else
		resp.retcode = G_ERRCODE["HERO_BUY_TYPE_ERROR"]
		player:SendToClient(SerializeCommand(resp))
		return
	end

	HERO_AddHero(role, arg.tid, 1)

	player:SendToClient(SerializeCommand(resp))

end
