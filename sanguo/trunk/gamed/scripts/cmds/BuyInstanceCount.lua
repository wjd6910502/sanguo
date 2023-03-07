function OnCommand_BuyInstanceCount(player, role, arg, others)
	player:Log("OnCommand_BuyInstanceCount, "..DumpTable(arg).." "..DumpTable(others))

	local resp = NewCommand("BuyInstanceCount_Re")
	local ed = DataPool_Find("elementdata")
	local stage = ed:FindBy("stage_id", arg.inst_tid)
	if stage == nil then
		resp.retcode = G_ERRCODE["NO_STAGE"]
		player:SendToClient(SerializeCommand(resp))
		player:Log("OnCommand_BuyInstanceCount, error=NO_STAGE")
		return
	end
	
	if stage.limittimes ~= 0 then
		if LIMIT_TestResetUseLimit(role, stage.limittimes) == false then
			resp.retcode = G_ERRCODE["BUY_INSTANCE_COUNT_HAVE"]
			player:SendToClient(SerializeCommand(resp))
			player:Log("OnCommand_BuyInstanceCount, error=BUY_INSTANCE_COUNT_HAVE")
			return
		else
			--�ж��������ʱ���Ѿ��ﵽ�˹�������
			if stage.maxpurchases ~= 0 then
				if LIMIT_TestUseLimit(role, stage.maxpurchases, 1) == false then
					resp.retcode = G_ERRCODE["INSTANCE_NO_COUNT"]
					player:SendToClient(SerializeCommand(resp))
					player:Log("OnCommand_BuyInstanceCount, error=INSTANCE_NO_COUNT")
					return
				end
			else
				resp.retcode = G_ERRCODE["INSTANCE_NO_COUNT"]
				player:SendToClient(SerializeCommand(resp))
				player:Log("OnCommand_BuyInstanceCount, error=INSTANCE_NO_COUNT")
				return
			end
			--�鿴��ǰ��Ǯ�Ƿ��㹻
			local quanju = ed.gamedefine[1]
			local buy_count = LIMIT_GetUseLimit(role, stage.maxpurchases)
			local need_yuanbao = 0
			local flag = 0
			for price in DataPool_Array(quanju.stage_reset_yb) do
				if flag == buy_count then
					need_yuanbao = price
					break
				end
				flag = flag + 1
			end
			if need_yuanbao == 0 then
				resp.retcode = G_ERRCODE["INSTANCE_SYSTEM_COUNT"]
				player:SendToClient(SerializeCommand(resp))
				player:Log("OnCommand_BuyInstanceCount, error=INSTANCE_SYSTEM_COUNT")
				return
			end
			local curr_yuanbao = role._roledata._status._yuanbao
			if curr_yuanbao < need_yuanbao then
				resp.retcode = G_ERRCODE["YUANBAO_LESS"]
				player:SendToClient(SerializeCommand(resp))
				player:Log("OnCommand_BuyInstanceCount, error=YUANBAO_LESS")
				return
			end
	
			ROLE_SubYuanBao(role, need_yuanbao)
			LIMIT_AddUseLimit(role, stage.maxpurchases, 1)
			LIMIT_ResetUseLimit(role, stage.limittimes)
			resp.retcode = G_ERRCODE["SUCCESS"]
			player:SendToClient(SerializeCommand(resp))
			return
		end
	else
		resp.retcode = G_ERRCODE["CAN_NOT_BUY_INSTANCE_COUNT"]
		player:SendToClient(SerializeCommand(resp))
		player:Log("OnCommand_BuyInstanceCount, error=CAN_NOT_BUY_INSTANCE_COUNT")
		return
	end
end