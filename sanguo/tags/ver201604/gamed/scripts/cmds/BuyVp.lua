function OnCommand_BuyVp(player, role, arg, others)
	player:Log("OnCommand_BuyVp, "..DumpTable(arg).." "..DumpTable(others))
	
	local resp = NewCommand("BuyVp_Re")
	--在这里首先需要判断他已经买了几次了，判断是否还可以继续买。
	local ed = DataPool_Find("elementdata")
	local quanju = ed.gamedefine[1]
	if LIMIT_TestUseLimit(role, quanju.vp_buy_max_times, 1) == true then
		--得到已经购买了几次的
		local buy_count = LIMIT_GetUseLimit(role, quanju.vp_buy_max_times)
		--判断元宝
		local curr_yuanbao = role._roledata._status._yuanbao
		local need_yuanbao = 0
		local flag = 0
		for vp_price in DataPool_Array(quanju.vp_price) do
			if flag == buy_count then
				need_yuanbao = vp_price
				break
			end
			flag = flag + 1
		end
		if need_yuanbao == 0 then
			resp.retcode = G_ERRCODE["VP_SYSTEM_ERROR"]
			player:SendToClient(SerializeCommand(resp))
			return
		end
		if need_yuanbao > curr_yuanbao then
			resp.retcode = G_ERRCODE["VP_LESS_YUANBAO"]
			player:SendToClient(SerializeCommand(resp))
			return
		end
		--下面开始扣除元宝
		ROLE_SubYuanBao(role, need_yuanbao)
		--修改限次模板
		LIMIT_AddUseLimit(role, quanju.vp_buy_max_times, 1)
		ROLE_Addvp(role, quanju.vp_buy_up_num, 1)
		
		resp.retcode = G_ERRCODE["SUCCESS"]
		player:SendToClient(SerializeCommand(resp))
		return
	else
		resp.retcode = G_ERRCODE["VP_NO_COUNT"]
		player:SendToClient(SerializeCommand(resp))
		return
	end
end
