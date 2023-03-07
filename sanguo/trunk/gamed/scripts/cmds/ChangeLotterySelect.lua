function OnCommand_ChangeLotterySelect(player, role, arg, others)
	player:Log("OnCommand_ChangeLotterySelect, "..DumpTable(arg).." "..DumpTable(others))

	local resp = NewCommand("ChangeLotterySelect_Re")
	resp.lottery_id = arg.lottery_id
	resp.select_id = arg.select_id
	
	local ed = DataPool_Find("elementdata")
	local lottery = ed:FindBy("lottery_id",arg.lottery_id)	
	if lottery == nil then
		return
	end

	local select_flag = false
	for vip_drop in DataPool_Array(lottery.vip_drop) do
		if vip_drop ~= 0 then
			if arg.select_id == vip_drop then
				select_flag = true
				break
			end
		end
	end

	if select_flag == false then
		return
	end

	--���Ԫ���Ƿ��㹻
	local ed = DataPool_Find("elementdata")
	local quanju = ed.gamedefine[1]
	if role._roledata._status._yuanbao < quanju.lottery_limit_change_cost then
		resp.retcode = G_ERRCODE["YUANBAO_LESS"]
		player:SendToClient(SerializeCommand(resp))
		player:Log("OnCommand_ChangeLotterySelect, error=YUANBAO_LESS")
		return
	end

	ROLE_SubYuanBao(role, quanju.lottery_limit_change_cost)

	local lottery_map = role._roledata._status._lottery_info
	local lottery_info = lottery_map:Find(arg.lottery_id)
	if lottery_info ~= nil then
		lottery_info._select = arg.select_id
	else
		local insert_info = CACHE.Lottery_Info()
		insert_info._lottery_id = arg.lottery_id
		insert_info._time = 0
		insert_info._count = 0
		insert_info._select = arg.select_id
		lottery_map:Insert(arg.lottery_id, insert_info)
	end
	
	resp.retcode = G_ERRCODE["SUCCESS"]
	ROLE_UpdateLotteryInfo(role)
	player:SendToClient(SerializeCommand(resp))
end
