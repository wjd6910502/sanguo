function OnCommand_WuZheShiLianGetReward(player, role, arg, others)
	player:Log("OnCommand_WuZheShiLianGetReward, "..DumpTable(arg).." "..DumpTable(others))
	
	local resp = NewCommand("WuZheShiLianGetReward_Re")
	resp.difficulty = arg.difficulty
	resp.stage	= arg.stage
	resp.retcode =	G_ERRCODE["SUCCESS"]
	resp.rewards = {}
	
	local hero_trial = role._roledata._wuzhe_shilian

	--����ͳ����־
	local source_id = G_SOURCE_TYP["WUZHESHILIAN"]
	
	--0-��������ȡ  1-������ȡ 2-��ȡ����
	local curdifficulty = arg.difficulty
	local curstage = arg.stage
	if curdifficulty ~= hero_trial._cur_difficulty then
		resp.retcode = G_ERRCODE["TRIAL_ACTIVE_PARAM_DIFFICULTY_WRONG"]
		player:SendToClient(SerializeCommand(resp))
		player:Log("OnCommand_WuZheShiLianGetReward, error=TRIAL_ACTIVE_PARAM_DIFFICULTY_WRONG")
		return
	end

	local trialdifficultyinfo  = hero_trial._attack_info:Find(curdifficulty)
	if trialdifficultyinfo == nil then
		resp.retcode = G_ERRCODE["TRIAL_ACTIVE_DIFFICULTY_NOT_FOUND"]	
		player:SendToClient(SerializeCommand(resp))
		player:Log("OnCommand_WuZheShiLianGetReward, error=TRIAL_ACTIVE_DIFFICULTY_NOT_FOUND")
		return
	end

	local trialstageinfo = trialdifficultyinfo._difficulty_attackinfo:Find(curstage)
	if trialstageinfo == nil then
		resp.retcode = G_ERRCODE["TRIAL_ACTIVE_STAGE_NOT_FOUND"]		
		player:SendToClient(SerializeCommand(resp))
		player:Log("OnCommand_WuZheShiLianGetReward, error=TRIAL_ACTIVE_STAGE_NOT_FOUND")
		return
	end

	local bossid = trialstageinfo._id
	local suzhu_flag = trialstageinfo._suzhu_flag
	local stageid = trialstageinfo._stage
	if trialstageinfo._reward_flag ~= 1 then
		if trialstageinfo._reward_flag == 0  then
			resp.retcode = G_ERRCODE["TRIAL_ACTIVE_REWARD_NOT_TAKEN"]
			player:SendToClient(SerializeCommand(resp))
			player:Log("OnCommand_WuZheShiLianGetReward, error=TRIAL_ACTIVE_REWARD_NOT_TAKEN")
			return
		elseif trialstageinfo._reward_flag == 2 then
			resp.retcode = G_ERRCODE["TRIAL_ACTIVE_REWARD_HAS_TAKEN"]
			player:SendToClient(SerializeCommand(resp))
			player:Log("OnCommand_WuZheShiLianGetReward, error=TRIAL_ACTIVE_REWARD_HAS_TAKEN")
			return	
		else
			resp.retcode = G_ERRCODE["TRIAL_ACTIVE_REWARD_FLAG_NOT_RECONGIZE"]
			player:SendToClient(SerializeCommand(resp))
			return	
		end
	end

	--������ȡ
	local ed = DataPool_Find("elementdata")
	local stageinfo = ed:FindBy("trialstage_id", arg.stage)
	if stageinfo == nil then
		resp.retcode = G_ERRCODE["TRIAL_ACTIVE_STAGEINFO_NOT_FOUND"]
		player:SendToClient(SerializeCommand(resp))
		player:Log("OnCommand_WuZheShiLianGetReward, error=TRIAL_ACTIVE_STAGEINFO_NOT_FOUND")
		return
	end
	
	-- �̶����� + �漴���� + ����Ӣ�۽���
	local Reward = DROPITEM_Reward(role, stageinfo.reward_id)
	--ROLE_AddReward(role, Reward, source_id)
	local add_items = ROLE_AddReward(role, Reward, source_id)
		
	player:Log("OnCommand_WuZheShiLianGetReward, ".."reward_id = "..stageinfo.reward_id.."#Reward.item ="..#Reward.item)			
	for i =1 , #add_items do
		local tmp_item = {}
		tmp_item.tid = add_items[i].tid
		tmp_item.count = add_items[i].count
		
		player:Log("OnCommand_WuZheShiLianGetReward, Reward.item ".."reward_id = "..tmp_item.tid.."count ="..tmp_item.count)
		resp.rewards[#resp.rewards +1] = tmp_item				
	end
		
	local ditem = DROPITEM_DropItem(role, stageinfo.drop_id)
		
	if #ditem >= 1 then
		for i = 1, #ditem do
			if ditem[i] ~= nil then
				local tmp_item = {}
				
				player:Log("OnCommand_WuZheShiLianGetReward stage_reward, Reward.item ".."reward_id = "..tmp_item.tid.."count ="..tmp_item.count)
				
				local flag,add_item,flag_type = BACKPACK_AddItem(role,ditem[i].id,ditem[i].count, source_id)		
				for j = 1, #add_item do
					tmp_item.tid = add_item[j].tid
					tmp_item.count = add_item[j].count
					
					player:Log("OnCommand_WuZheShiLianGetReward, Reward.item ".."reward_id = "..tmp_item.tid.."count ="..tmp_item.count)
					resp.rewards[#resp.rewards +1] = tmp_item
				end

			end
		end
	end
			
	--��ȡ����Ӣ�۵Ľ���
	local suzhuwujiangreward = {}	
	suzhuwujiangreward[#suzhuwujiangreward+1] = stageinfo.speical_reward_id1
	suzhuwujiangreward[#suzhuwujiangreward+1] = stageinfo.speical_reward_id2
	suzhuwujiangreward[#suzhuwujiangreward+1] = stageinfo.speical_reward_id3
		
	--��ȡ����Ӣ��
	local ed = DataPool_Find("elementdata")
	local boss_infos = ed:FindBy("boss_id", bossid)	
	if boss_infos == nil then
		resp.retcode = G_ERRCODE["TRIAL_ACTIVE_BOSSINFO_NOT_FOUND"]
		player:SendToClient(SerializeCommand(resp))
		player:Log("OnCommand_WuZheShiLianGetReward, error=TRIAL_ACTIVE_BOSSINFO_NOT_FOUND")
		return	
	end
		
	local num_id = {}
	num_id[#num_id+1] = boss_infos.sudi_role1
	num_id[#num_id+1] = boss_infos.sudi_role2
	num_id[#num_id+1] = boss_infos.sudi_role3
		
	--����һ�� ��Щ�佫��ȡ����
	local a = {}
	a[#a+1] = math.floor(suzhu_flag/100)
	suzhu_flag = math.floor(suzhu_flag%100)
	a[#a+1] = math.floor(suzhu_flag/10)
	a[#a+1] = math.floor(suzhu_flag%10)

	--���������佫����
	for i =1,#a do
		local idx = a[i]
		player:Log("OnCommand_WuZheShiLianGetReward, bossid idx = "..idx)
		if idx ~= 0 then
			local Reward = DROPITEM_Reward(role, suzhuwujiangreward[idx])
			local add_item = ROLE_AddReward(role, Reward, source_id)
				
			--player:Log("OnCommand_WuZheShiLianGetReward, suzhu_add_item size = "..#add_item)
			for j = 1, #add_item do
				local tmp_item = {}
				tmp_item.tid = add_item[j].tid
				tmp_item.count = add_item[j].count
			
				player:Log("OnCommand_WuZheShiLianGetReward, additem_item id = "..add_item[j].tid.." cnt ="..add_item[j].count)
				resp.rewards[#resp.rewards +1] = tmp_item					
			end		
		end			
	end
	
	--������ȡ״̬
	trialstageinfo._reward_flag = 2
	
	player:SendToClient(SerializeCommand(resp))
	
end