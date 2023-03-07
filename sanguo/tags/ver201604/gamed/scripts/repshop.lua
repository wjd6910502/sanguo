--�����������ˢ����ҵ������̵꣬�Լ����������ҵ������̵�
--����������ķ���ʱ��ΪĿǰ�̵����п����ȼ��ģ����Ե��ﵽһ���ȼ�
--���Կ�����ʱ�򣬾Ϳ��Կ����ˡ�
function REPSHOP_RefreshShop(role, shop_id)
	local repshop = role._shopmap
	local shop = current_task:Find(shop_id)
	if shop ~= nil then
		local ed = DataPool_Find("elementdata")
		local ed_shop = ed.repshop[shop_id]
		if ed_shop ~= nil then
			--��������Ҫ�������·���
			shop._shop_id = ed_shop.shop_id
			shop._type = ed_shop.shop_type
			shop._level = ed_shop.level
			shop._itemlist.clear()
			--���濪ʼ����γ��ֵ���Ʒ�����������Ϊ��һЩ��Ʒʱ�س��ģ�һЩ���и��ʳ��ֵ�
			itemlist = ed_shop.itemlist --������ȡ�����е���Ʒ
			for r in DataPool_Array(itemlist) do
				if r.prob == 100 then
					local item = {}
					item._item_id = r.item_id
					item._count = 0
					item._max_count = r.max_count
					item._price = r.price
					shop._itemlist:PushBack(item)
				end
			end

			local pro_count = ed_shop.pro_count
			if pro_count > 0 then
				local prob_sum = 0	--�ܵĸ���֮��
				local prob_count = 0	--һ���ж�����Ʒ
				local prob_item = {}
				for r in DataPool_Array(itemlist) do
					if r.prob > 0 and r.prob < 100 then
						local item = {}
						item._item_id = r.item_id
						item._count = 0
						item._max_count = r.max_count
						item._price = r.price
						item._prob = r.prob
						prob_sum = prob_sum + item._prob
						prob_count = prob_count + 1
						prob_item[prob_count] = item
					end
				end

				if prob_count >= pro_count then
					local all_count = 0	--�Ѿ����������Ʒ����
					while all_count < pro_count do
						local tmp_prob = math.random(1,prob_sum)
						local tmp_sum = 0
						for i = 1, prob_count do
							tmp_sum = tmp_sum + prob_item[i]._prob
							if tmp_prob <= tmp_sum then
								local item = {}
								item._item_id = prob_item[i].item_id
								item._count = 0
								item._max_count = prob_item[i].max_count
								item._price = prob_item[i].price
								shop._itemlist:PushBack(item)
								
								--�޸ı�ѡ�е���Ʒ�ĸ������ó�0
								prob_sum = prob_sum - prob_item[i]._prob
								prob_item[i]._prob = 0
								all_count = all_count + 1
								break
							end
						end
					end
				else
					player:Log("shop_id prob_count is little" .. shop_id)
				end

			end
		else
			player:Log("shop_id is error" .. shop_id)
		end

	else
		
	end

	
end
