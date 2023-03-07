function OnCommand_BuySkillPoint(player, role, arg, others)
	player:Log("OnCommand_BuySkillPoint, "..DumpTable(arg).." "..DumpTable(others))

	local resp = NewCommand("BuySkillPoint_Re")

	--ֻ����0��ʱ��ſ��Թ���
	if role._roledata._status._hero_skill_point ~= 0 then
		resp.retcode = G_ERRCODE["HERO_SKILL_POINT_ZERO"]
		player:SendToClient(SerializeCommand(resp))
		return
	end
	--�鿴�Ƿ�ﵽ�˹�������
	local ed = DataPool_Find("elementdata")
	local quanju = ed.gamedefine[1]
	if LIMIT_TestUseLimit(role, quanju.skillpointlimitID, 1) == true then
		local buy_count = LIMIT_GetUseLimit(role, quanju.skillpointlimitID)
		
		local curr_yuanbao = role._roledata._status._yuanbao
		local need_yuanbao = 0
		local flag = 0
		for vp_price in DataPool_Array(quanju.skillpointprice) do
			if flag == buy_count then
				need_yuanbao = vp_price
			end
			flag = flag + 1
		end

		if need_yuanbao == 0 then
		end

		if need_yuanbao > curr_yuanbao then
			resp.retcode = G_ERRCODE["YUANBAO_LESS"]
			player:SendToClient(SerializeCommand(resp))
			return
		end
		
		ROLE_SubYuanBao(role, need_yuanbao)
		ROLE_AddHeroSkillPoint(role, quanju.skillpointpackage)
		LIMIT_AddUseLimit(role, quanju.skillpointlimitID, 1)
		
		resp.retcode = G_ERRCODE["SUCCESS"]
		resp.point = role._roledata._status._hero_skill_point
		player:SendToClient(SerializeCommand(resp))
		return
	end
end