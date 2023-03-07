function OnCommand_WuZheShiLianGetReward(player, role, arg, others)
	player:Log("OnCommand_WuZheShiLianGetReward, "..DumpTable(arg).." "..DumpTable(others))
	
	local resp = NewCommand("WuZheShiLianGetReward_Re")
	resp.difficulty = arg.difficulty
	resp.stage	= arg.stage
	resp.retcode =	G_ERRCODE["SUCCESS"] 
	resp.rewards = {}
	
	local hero_trial = role._roledata._wuzhe_shilian  
	
	--0-不可以领取  1-可以领取 2-领取过了
	local curdifficulty = arg.difficulty
	local curstage = arg.stage
	if curdifficulty ~= hero_trial._cur_difficulty then
		resp.retcode = G_ERRCODE["TRIAL_ACTIVE_PARAM_DIFFICULTY_WRONG"] 
		player:SendToClient(SerializeCommand(resp))
		return
	end

	local trialdifficultyinfo  = hero_trial._attack_info:Find(curdifficulty)
	if trialdifficultyinfo == nil then
		resp.retcode = G_ERRCODE["TRIAL_ACTIVE_DIFFICULTY_NOT_FOUND"]	
		player:SendToClient(SerializeCommand(resp))
		return
	end

	local trialstageinfo = trialdifficultyinfo._difficulty_attackinfo:Find(curstage)
	if trialstageinfo == nil then
		resp.retcode = G_ERRCODE["TRIAL_ACTIVE_STAGE_NOT_FOUND"]		
		player:SendToClient(SerializeCommand(resp)) 
		return
	end

	local bossid = trialstageinfo._id
	local suzhu_flag = trialstageinfo._suzhu_flag
	local stageid = trialstageinfo._stage
	if trialstageinfo._reward_flag ~= 1 then
		if trialstageinfo._reward_flag == 0  then
			resp.retcode = G_ERRCODE["TRIAL_ACTIVE_REWARD_NOT_TAKEN"]
			player:SendToClient(SerializeCommand(resp))
			return
		elseif trialstageinfo._reward_flag == 2 then
			resp.retcode = G_ERRCODE["TRIAL_ACTIVE_REWARD_HAS_TAKEN"]
			player:SendToClient(SerializeCommand(resp))
			return	
		else
			throw()
		end
	end

	--奖励领取
	local ed = DataPool_Find("elementdata")
	local stageinfo = ed:FindBy("trialstage_id", arg.stage) 
	if stageinfo == nil then
		resp.retcode = G_ERRCODE["TRIAL_ACTIVE_STAGEINFO_NOT_FOUND"]
		player:SendToClient(SerializeCommand(resp))
		return
	end
	
	-- 固定奖励 + 随即奖励 + 宿主英雄奖励
	local Reward = DROPITEM_Reward(role, stageinfo.reward_id)
	ROLE_AddReward(role, Reward)
		
	player:Log("OnCommand_WuZheShiLianGetReward, ".."reward_id = "..stageinfo.reward_id.."#Reward.item ="..#Reward.item)			 
	for i =1 , #Reward.item do
		local tmp_item = {}
		tmp_item.tid = Reward.item[i].itemid
		tmp_item.count = Reward.item[i].itemnum
		player:Log("OnCommand_WuZheShiLianGetReward, Reward.item ".."reward_id = "..tmp_item.tid.."count ="..tmp_item.count) 
		resp.rewards[#resp.rewards +1] = tmp_item				
	end
		
	local ditem = DROPITEM_DropItem(role, stageinfo.drop_id)
		
	if #ditem >= 1 then
		for i = 1, #ditem do
			if ditem[i] ~= nil then
				local tmp_item = {}
				tmp_item.tid = ditem[i].id
				tmp_item.count = ditem[i].count
				BACKPACK_AddItem(role,tmp_item.tid,tmp_item.count)
				player:Log("OnCommand_WuZheShiLianGetReward, Reward.item ".."reward_id = "..tmp_item.tid.."count ="..tmp_item.count)
				resp.rewards[#resp.rewards +1] = tmp_item
			end
		end
	end
			
	--获取宿主英雄的奖励
	local suzhuwujiangreward = {}	
	suzhuwujiangreward[#suzhuwujiangreward+1] = stageinfo.speical_reward_id1
	suzhuwujiangreward[#suzhuwujiangreward+1] = stageinfo.speical_reward_id2
	suzhuwujiangreward[#suzhuwujiangreward+1] = stageinfo.speical_reward_id3
		
	--获取宿主英雄
	local ed = DataPool_Find("elementdata")
	local boss_infos = ed:FindBy("boss_id", bossid)	
	if boss_infos == nil then
		resp.retcode = G_ERRCODE["TRIAL_ACTIVE_BOSSINFO_NOT_FOUND"]
		player:SendToClient(SerializeCommand(resp))
		return	
	end
		
	local num_id = {}
	num_id[#num_id+1] = boss_infos.sudi_role1
	num_id[#num_id+1] = boss_infos.sudi_role2 
	num_id[#num_id+1] = boss_infos.sudi_role3
		
	--计算一下 那些武将领取奖励
	local a = {}
	a[#a+1] = math.floor(suzhu_flag/100)
	suzhu_flag = math.floor(suzhu_flag%100)
	a[#a+1] = math.floor(suzhu_flag/10)
	a[#a+1] = math.floor(suzhu_flag%10)

	--添加宿主武将奖励
	for i =1,#a do
		local idx = a[i]
		player:Log("OnCommand_WuZheShiLianGetReward, bossid idx = "..idx)
		if idx ~= 0 then
			local Reward = DROPITEM_Reward(role, suzhuwujiangreward[idx])
			ROLE_AddReward(role, Reward)		
				
			--添加物品
			for i =1 , #Reward.item do 
				local tmp_item = {}
				tmp_item.tid = Reward.item[i].itemid
				tmp_item.count = Reward.item[i].itemnum
				resp.rewards[#resp.rewards +1] = tmp_item			
				player:Log("OnCommand_WuZheShiLianGetReward, reward_item id = "..Reward.item[i].itemid)
			end		
		end			
	end
	
	--设置领取状态
	trialstageinfo._reward_flag = 2
	
	player:SendToClient(SerializeCommand(resp))
	
end
