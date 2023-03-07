--这个接口需要根据返回值进行判断，才可以进行下一步的操作，使用的时候一定要注意
function BACKPACK_AddItem(role, tid, count)
	if count<=0 or tid<=0 then
		return false
	end
	local ed = DataPool_Find("elementdata")
	local item = ed:FindBy("item_id", tid)
	if item == nil then
		return false
	end
	--判断一下，这个物品进背包的时候是否需要做相应的转化,类型是20的需要进行转化,在程序里面进行写死
	if item.item_type == 20 then
		local currency = ed:FindBy("currency_id", item.type_data1)
		if currency.currency_type == 1 then
			--金币
			ROLE_AddMoney(role, item.type_data2*count)
		elseif currency.currency_type == 2 then
			--元宝，勾玉
			ROLE_AddYuanBao(role, item.type_data2*count)
		elseif currency.currency_type == 3 then
			--体力
			ROLE_Addvp(role, item.type_data2*count, 1)
		elseif currency.currency_type == 4 then
			--声望
			ROLE_AddRep(role, currency.rep_id, item.type_data2*count)
		end
		return true
	elseif item.item_type == 21 then
		--转化成武将
		for i = 1, count do
			HERO_AddHero(role, item.type_data1, 1)
		end
		return true
	end

	local flag = false
	local backpack = role._roledata._backpack._items
	local iit = backpack:SeekToBegin()
	local i = iit:GetValue()
	while i~= nil do
		if i._tid == tid then
			if item.packlimit == 0 then
				local tmp = CACHE.Item:new()
				tmp._tid = tid
				tmp._count = count
				backpack:PushBack(tmp)
			else
				i._count = i._count + count
			end
			flag = true
			break
		end
		iit:Next();
		i = iit:GetValue()
	end

	if flag == false then
		local tmp = CACHE.Item:new()
		tmp._tid = tid
		tmp._count = count
		backpack:PushBack(tmp)
	end
	BACKPACK_SendBackPackOneItem(role, tid)
	return true
end

--这个接口需要根据返回值进行判断，才可以进行下一步的操作，使用的时候一定要注意
function BACKPACK_DelItem(role, tid, count)
	if count<=0 or tid<=0 then
		return false
	end
	local ed = DataPool_Find("elementdata")
	local item = ed:FindBy("item_id", tid)
	if item == nil then
		return false
	end
	
	local backpack = role._roledata._backpack._items
	local iit = backpack:SeekToBegin()
	local i = iit:GetValue()
	while i ~= nil do
		if i._tid == tid then
			if i._count >= count then
				i._count = i._count - count
				BACKPACK_SendBackPackOneItem(role, tid)
				return true
			else
				return false
			end
		end
		iit:Next();
		i = iit:GetValue()
	end
	return false
end

--查看玩家的背包里面某一个道具的数量是否达到一个值
function BACKPACK_HaveItem(role, tid, count)
	if count<=0 or tid<=0 then
		return false
	end
	local items = role._roledata._backpack._items
	
	local iit = items:SeekToBegin() --从头开始遍历
	local i = iit:GetValue()
	while i~=nil do
		if i._tid == tid and i._count >= count then
			return true
		end
		iit:Next()
		i = iit:GetValue()
	end
	return false
end

--告诉客户端，我的背包信息
function BACKPACK_SendBackPack(role)
	local resp = NewCommand("GetBackPack_Re")
	resp.info = {}
	local backpack = role._roledata._backpack._items
	local iit = backpack:SeekToBegin()
	local i = iit:GetValue()
	while i ~= nil do
		local item = {}
		item.tid = i._tid
		item.count = i._count
		resp.info[#resp.info+1] = item
		iit:Next()
		i = iit:GetValue()
	end
	resp.retcode = G_ERRCODE["SUCCESS"]
	role:SendToClient(SerializeCommand(resp))
end
--告诉客户端，我的某一个物品的当前数量
function BACKPACK_SendBackPackOneItem(role,itemid)
	local resp = NewCommand("ItemCountChange")
	resp.itemid = itemid
	resp.count = 0
	local items = role._roledata._backpack._items
	
	local iit = items:SeekToBegin() --从头开始遍历
	local i = iit:GetValue()
	while i~=nil do
		if i._tid == itemid then
			resp.count = i._count
			break
		end
		iit:Next()
		i = iit:GetValue()
	end
	role:SendToClient(SerializeCommand(resp))
end
