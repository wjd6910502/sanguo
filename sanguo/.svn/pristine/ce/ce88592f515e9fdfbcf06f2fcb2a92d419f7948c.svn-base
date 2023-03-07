function OnCommand_BuyFuDai(player, role, arg, others)
	player:Log("OnCommand_BuyFuDai, "..DumpTable(arg).." "..DumpTable(others))

	local resp = NewCommand("BuyFuDai_Re")
	resp.fudai_flag = arg.fudai_flag

	local fudai_ticket_map = role._roledata._backpack._fudai_ticket
	local fudai_ticket = fudai_ticket_map:Find(arg.fudai_flag) 
	if fudai_ticket == nil then
		resp.retcode = G_ERRCODE["FUDAI_TICKET_NOT_EXIST"]
		player:SendToClient(SerializeCommand(resp))
		player:Log("OnCommand_BuyFuDai, error=FUDAI_TICKET_NOT_EXIST")
		return
	end

	--扣除福袋彩票，转化为福袋加到玩家身上
	fudai_ticket._count = fudai_ticket._count - 1
	if fudai_ticket._count == 0 then
		fudai_ticket_map:Delete(arg.fudai_flag)
	end

	ROLE_GainFudai(role, arg.fudai_flag)

	resp.retcode = G_ERRCODE["SUCCESS"]
	player:SendToClient(SerializeCommand(resp))
end
