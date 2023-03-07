function OnCommand_Lottery(player, role, arg, others)
	player:Log("OnCommand_Lottery, "..DumpTable(arg).." "..DumpTable(others))
	
	local resp = NewCommand("Lottery_Re")
	resp.retcode = G_ERRCODE["SUCCESS"]
	resp.lottery_id = arg.lottery_id
	resp.reward_ids = {}	
	--���ҳ齱id
	local ed = DataPool_Find("elementdata")
	local lottery = ed:FindBy("lottery_id",arg.lottery_id)
	
	if lottery == nil then
		resp.retcode = G_ERRCODE["NO_LOTTERY"] 
		player:SendToClient(SerializeCommand(resp))
		return
	end
	
	--������Ҫ������ģ��id
	local cost_type = arg.cost_type	
	local price = 0
	local drop_id = 0
	local flags = false
	local lottery_cnt = lottery.lottery_times
	for costdrop in DataPool_Array(lottery.costdrop) do		
		if costdrop.lottery_cost_type == cost_type then			
			price = costdrop.lottery_price
			drop_id = costdrop.drop_id
			flags = true
			break
		end		
	end
	

	--�����߻���ߵĶ���
	if flags ~= true then 
		throw()
	end
	

	--����ʱ�� Ȼ���ȡ����ʱ�� --����ˢ��ʱ��	
	local now = API_GetTime()	
	local time_map = role._roledata._status._last_lotterytime
	local find_time = time_map:Find(arg.lottery_id)
	local last_time = 0
	if find_time ~= nil then
		last_time = find_time._value
	end
	

	local now_s = CACHE.Int()
	now_s._value = now
	
	if  now - last_time > lottery.free_cd_loop and lottery.free_cd_loop > 0 then
		role._roledata._status._last_lotterytime:Insert(arg.lottery_id, now_s)
		cost_type = -1
	end
	 
	--1��������ͭ�ҹ���2��������Ԫ������, 7��������
	if cost_type == 1 then
		if role._roledata._status._money < price then
			resp.retcode = G_ERRCODE["LOTTERY_MONEY_NOTENOUGH"] 
			player:SendToClient(SerializeCommand(resp))
			return
		end
		ROLE_SubMoney(role, price)
	elseif cost_type == 2 then
		if role._roledata._status._yuanbao < price then
			resp.retcode = G_ERRCODE["LOTTERY_YUANBAO_NOTENOUGH"] 
			player:SendToClient(SerializeCommand(resp))
			return
		end
		ROLE_SubYuanBao(role, price)
	elseif cost_type == 7 then
		-- ����id 4
		if ROLE_CheckRep(role, 4, price) == false then
			resp.retcode = G_ERRCODE["LOTTERY_REP_NOTENOUGH"]
			player:SendToClient(SerializeCommand(resp)) 
			return
		end
		ROLE_SubRep(role, 4, price )
	elseif cost_type < 0 then
		player:Log("Lottery free cost_type ")					
	else
		resp.retcode = G_ERRCODE["LOTTERY_COSTTYPE_NOTKNOWN"]
		player:SendToClient(SerializeCommand(resp))
		return
	end
	
	local lottery_info = {}
	while lottery_cnt > 0 do	
		
		--���ݵ��������ÿ��ֻ���漴����һ����Ʒ
		local ditem = DROPITEM_DropItem(role, drop_id)
		if ditem == nil then
			throw()						
		end

		local item_count = table.getn(ditem)	
		if item_count ~= 1 then
			throw()
		end
		
		local tmp_item = {}
		tmp_item.id = ditem[1].id
		tmp_item.num = ditem[1].count
		
		print("id = "..ditem[1].id.."  cnt ="..ditem[1].count)
		--���佫 �Ƿ��״λ�ȡ��������û�� Ϊ�մ�������Ʒ
		local item = ed:FindBy("item_id",tmp_item.id)
		if item == nil then
			throw()
		end

		if item.item_type == 21 then
			--��һ���Ƿ��״λ��
			local heroid =  item.type_data1 --������佫id ����ģ��id 
			local hero_map = role._roledata._hero_hall._heros
			local h = hero_map:Find(heroid)	
			if h ~= nil then
				--ת���������Ʒ
				tmp_item.firstget = 0
			else
				--��һ�λ�ȡ
				tmp_item.firstget = 1 	
			end
			tmp_item.bproorhero = 1
			for i = 1, tmp_item.num do
				HERO_AddHero(role, item.type_data1, 0)
			end
		else	
			tmp_item.firstget = 0 	
			tmp_item.bproorhero = 0					
			BACKPACK_AddItem(role,tmp_item.id,tmp_item.num) 
		end

		resp.reward_ids[#resp.reward_ids+1]= tmp_item;		
		lottery_cnt = lottery_cnt - 1		
	end
	
	--������Ʒ���ͻ���
	player:SendToClient(SerializeCommand(resp)) 		
end

