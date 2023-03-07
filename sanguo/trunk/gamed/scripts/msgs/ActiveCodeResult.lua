function OnMessage_ActiveCodeResult(player, role, arg, others)
	player:Log("OnMessage_ActiveCodeResult, "..DumpTable(arg).." "..DumpTable(others))

	local resp = NewCommand("GetActiveCodeRward_Re")
	resp.retcode = arg.retcode

	if resp.retcode == 0 then
		local ed = DataPool_Find("elementdata")
		local codeinfo = ed:FindBy("redeemcode", arg.type) --OnCommand_GetActiveCodeRward这个里面已经验证了

		local Reward = DROPITEM_Reward(role, codeinfo.reward_id)
		resp.item = {}
		local item_count = table.getn(Reward.item)
		for i = 1, item_count do
			local reward_info = {}
			reward_info.tid = Reward.item[i].itemid
			reward_info.count = Reward.item[i].itemnum
			resp.item[#resp.item+1] = reward_info
		end
		ROLE_AddReward(role, Reward, 0)
		LIMIT_AddUseLimit(role, codeinfo.limit_id, 1)
	end
	player:SendToClient(SerializeCommand(resp))
end
