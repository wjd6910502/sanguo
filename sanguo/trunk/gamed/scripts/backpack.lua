--����ӿ���Ҫ���ݷ���ֵ�����жϣ��ſ��Խ�����һ���Ĳ�����ʹ�õ�ʱ��һ��Ҫע��
function BACKPACK_AddItem(role, tid, count, path, data)
	local add_item = {}
	local flag= BACKPACK_ActualAddItem(role, tid, count, 1, add_item, path, data)
	return flag, add_item
end

function BACKPACK_ActualAddItem(role, tid, count, layer, add_item, path, data)
	if layer >= 3 then
		API_Log("BACKPACK_ActualAddItem      layer too large")
		return false
	end

	if count<=0 or tid<=0 then
		API_Log("BACKPACK_ActualAddItem      1")
		return false
	end

	local ed = DataPool_Find("elementdata")
	local item = ed:FindBy("item_id", tid)
	if item == nil then
		API_Log("BACKPACK_ActualAddItem      2")
		return false
	end

	if item.item_type ~= G_ITEM_TYP["LOTTERY_ITEM"] then --����
		--�����vip���¿�Ӱ�����⴦��
		if path == G_SOURCE_TYP["FULIHUODONG"] then
			count = math.ceil(count*data)
		end

		local tmp_item = {}
		tmp_item.tid = tid
		tmp_item.count = count
		tmp_item.typ = item.item_type
		add_item[#add_item+1] = tmp_item
	end
	--�ж�һ�£������Ʒ��������ʱ���Ƿ���Ҫ����Ӧ��ת��,������20����Ҫ����ת��,�ڳ����������д��
	if item.item_type == G_ITEM_TYP["COIN"] then
		--local tmp_item = {}
		--tmp_item.tid = tid
		--tmp_item.count = count
		--tmp_item.typ = 5
		--add_item[#add_item+1] = tmp_item
		local currency = ed:FindBy("currency_id", item.type_data1)
		if currency.currency_type == 1 then
			--���
			ROLE_AddMoney(role, item.type_data2*count, path)
		elseif currency.currency_type == 2 then
			--Ԫ��������
			ROLE_AddYuanBao(role, item.type_data2*count, path)
		elseif currency.currency_type == 3 then
			--����
			ROLE_Addvp(role, item.type_data2*count, 1)
		elseif currency.currency_type == 4 then
			--����
			ROLE_AddRep(role, currency.rep_id, item.type_data2*count, path)
		elseif currency.currency_type == 5 then
			--��Ծ
			TASK_ChangeCondition(role, G_ACH_TYPE["HUODONG_HUOYUE"], 0, item.type_data2*count)
		end
		API_Log("BACKPACK_ActualAddItem      3")
		--return true
	elseif item.item_type == G_ITEM_TYP["HERO"] then
		--ת�����佫
		for i = 1, count do
			HERO_AddHero(role, item.type_data1, 1, path)
			
			--local tmp_item = {}
			--tmp_item.tid = tid
			--tmp_item.count = 1
			--tmp_item.typ = 4
			--add_item[#add_item+1] = tmp_item
		end
		API_Log("BACKPACK_ActualAddItem      4")
		--return true
	elseif item.item_type == G_ITEM_TYP["WEAPON"] then
		--������Ʒת��������
		for i = 1, count do
			BACKPACK_AddWeapon(role, tid, item.type_data1, true)
			
			--local tmp_item = {}
			--tmp_item.tid = tid
			--tmp_item.count = 1
			--tmp_item.typ = 3
			--add_item[#add_item+1] = tmp_item
		end
		API_Log("BACKPACK_ActualAddItem      5")
		--return true
	elseif item.item_type == G_ITEM_TYP["LOTTERY_ITEM"] then
		--�����ӵõ���Ʒ
		for z = 1, count do
			for i = 1, item.type_data2 do
				local Item = DROPITEM_DropItem(role, item.type_data1)
				for j = 1, table.getn(Item) do
					BACKPACK_ActualAddItem(role, Item[j].id, Item[j].count, layer+1, add_item, path, data)
				end
			end
		end
		API_Log("BACKPACK_ActualAddItem      6")
		return true
	elseif item.item_type == G_ITEM_TYP["EQUIP"] then
		--װ����Ʒת����װ��
		for i = 1, count do
			BACKPACK_AddEquipment(role, tid, item.type_data1)
			--local tmp_item = {}
			--tmp_item.tid = tid
			--tmp_item.count = 1
			--tmp_item.typ = 2
			--add_item[#add_item+1] = tmp_item
		end
		API_Log("BACKPACK_ActualAddItem      7")
		--return true
	elseif item.item_type == G_ITEM_TYP["PHOTO"] then
		--ͷ����Ʒת��Ϊͷ��
		for index = 1, count do
			ROLE_AddPhoto(role,item.type_data1,item.type_data2)
		end
		--return true
	elseif item.item_type == G_ITEM_TYP["PHOTO_FRAME"] then
		--ͷ�����Ʒת��Ϊͷ���
		for index = 1, count do
			ROLE_AddPhotoFrame(role,item.type_data1)
		end
		--return true
	elseif item.item_type == G_ITEM_TYP["BADGE"] then
		--������Ʒת��Ϊ����
		for index = 1, count do
			ROLE_UpdateBadge(role,item.type_data2,item.type_data1,1)
		end
		--return true
	elseif item.item_type == G_ITEM_TYP["CHENGHAO"] then
		--��Ʒת��������
		for index = 1, count do
			ROLE_UpdateTeXing(role, item.type_data1)
		end
		--return true
	elseif item.item_type == G_ITEM_TYP["FUDAI"] then
		--��Ʒת���ɸ�����Ʊ
		for index = 1, count do
			ROLE_GainFudai(role, item.type_data1)
		end
	else
		API_Log("BACKPACK_ActualAddItem      18")

		local flag = false
		local backpack = role._roledata._backpack._items
		local iit = backpack:SeekToBegin()
		local i = iit:GetValue()
		while i~= nil do
			if i._tid == tid then
				if item.packlimit == 0 then
					for index = 1, count do
						local tmp = CACHE.Item()
						tmp._tid = tid
						tmp._count = 1
						backpack:PushBack(tmp)
					end
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
			if item.packlimit == 0 then
				for index = 1, count do
					local tmp = CACHE.Item()
					tmp._tid = tid
					tmp._count = 1
					backpack:PushBack(tmp)
				end
			else
				local tmp = CACHE.Item()
				tmp._tid = tid
				tmp._count = count
				backpack:PushBack(tmp)
			end
		end
		BACKPACK_SendBackPackOneItem(role, tid)

		--�鿴�Ƿ񲥷�ȫ������
		--����ȫ���Ĺ���
		if path~=nil and path>0 and path<1000 and item.billboard_id>0 then
			local notice_para = {}
			
			local tmp_notice_para = {}
			tmp_notice_para.typ = G_NOTICE_TYP["ROLE"]
			tmp_notice_para.id = role._roledata._base._id:ToStr()
			tmp_notice_para.name = role._roledata._base._name
			notice_para[#notice_para+1] = tmp_notice_para
			
			local tmp_notice_para = {}
			tmp_notice_para.typ = G_NOTICE_TYP["SOURCE"]
			tmp_notice_para.num = path
			notice_para[#notice_para+1] = tmp_notice_para
			
			local tmp_notice_para = {}
			tmp_notice_para.typ = G_NOTICE_TYP["ITEM"]
			tmp_notice_para.id = tostring(tid)
			tmp_notice_para.num = count
			notice_para[#notice_para+1] = tmp_notice_para

			ROLE_SendNotice(item.billboard_id, notice_para)
		end

		--����Ʒ�ӵ��б�����ȥ
		--local tmp_item = {}
		--tmp_item.tid = tid
		--tmp_item.count = count
		--tmp_item.typ = 1
		--add_item[#add_item+1] = tmp_item
		API_Log("BACKPACK_ActualAddItem      28")
	end

	--����ͳ����־
	local date = os.date("%Y-%m-%d %H:%M:%S")
	path = path or 0
	API_BILog("{\"logtime\":\""..date.."\",\"logname\":\"gainitem\",\"serverid\":\""..API_GetZoneId()..
		"\",\"os\":\""..role._roledata._device_info._os.."\",\"platform\":\"".."laohu".."\",\"userid\":\""
		..role._roledata._status._account.."\",\"account\":\""..role._roledata._status._account..
		"\",\"roleid\":\""..role._roledata._base._id:ToStr().."\",\"rolename\":\""..role._roledata._base._name..
		"\",\"lev\":\""..role._roledata._status._level.."\",\"itemtype\":\""..item.item_type.."\",\"itemid\":\""
		..tid.."\",\"itemcount\":\""..count.."\",\"itempath\":\""..path.."\"}")

	return true
end

function BACKPACK_AddInitWeapon(role, tid, count, path) --FIXME: ר�Ÿ����佫��һ�������Ľӿ�
	local add_item = {}
	local flag= BACKPACK_ActualAddInitWeapon(role, tid, count, 1, add_item, path)
	return flag, add_item
end

function BACKPACK_ActualAddInitWeapon(role, tid, count, layer, add_item, path)
	if count<=0 or tid<=0 then
		API_Log("BACKPACK_ActualAddInitWeapon 1")
		return false
	end

	local ed = DataPool_Find("elementdata")
	local item = ed:FindBy("item_id", tid)
	if item == nil then
		API_Log("BACKPACK_ActualAddInitWeapon 2")
		return false
	end
	if item.item_type ~= G_ITEM_TYP["LOTTERY_ITEM"] then --����
		local tmp_item = {}
		tmp_item.tid = tid
		tmp_item.count = count
		tmp_item.typ = item.item_type
		add_item[#add_item+1] = tmp_item
	end
	--�ж�һ�£������Ʒ��������ʱ���Ƿ���Ҫ����Ӧ��ת��,������20����Ҫ����ת��,�ڳ����������д��
	if item.item_type == G_ITEM_TYP["WEAPON"] then
		--������Ʒת��������
		for i = 1, count do
			BACKPACK_AddWeapon(role, tid, item.type_data1, false)
			
			--local tmp_item = {}
			--tmp_item.tid = tid
			--tmp_item.count = 1
			--tmp_item.typ = 3
			--add_item[#add_item+1] = tmp_item
		end
		--return true
	else
		API_Log("BACKPACK_ActualAddInitWeapon 3")
		return false
	end

	--����ͳ����־
	local date = os.date("%Y-%m-%d %H:%M:%S")
	path = path or 0
	API_BILog("{\"logtime\":\""..date.."\",\"logname\":\"gainitem\",\"serverid\":\""..API_GetZoneId()..
		"\",\"os\":\""..role._roledata._device_info._os.."\",\"platform\":\"".."laohu".."\",\"userid\":\""
		..role._roledata._status._account.."\",\"account\":\""..role._roledata._status._account.."\",\"roleid\":\""
		..role._roledata._base._id:ToStr().."\",\"rolename\":\""..role._roledata._base._name.."\",\"lev\":\""
		..role._roledata._status._level.."\",\"itemtype\":\""..item.item_type.."\",\"itemid\":\""..tid.."\",\"itemcount\":\""
		..count.."\",\"itempath\":\""..path.."\"}")

	return true
end

--����ӿ���Ҫ���ݷ���ֵ�����жϣ��ſ��Խ�����һ���Ĳ�����ʹ�õ�ʱ��һ��Ҫע��
function BACKPACK_DelItem(role, tid, count, path)
	if count<=0 or tid<=0 then
		return false
	end
	
	if BACKPACK_HaveItem(role, tid, count) == false then
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
			else
				count = count - i._count
				i._count = 0
			end
		end
		iit:Next()
		i = iit:GetValue()
	end
	BACKPACK_SendBackPackOneItem(role, tid)
	--����һ�£���Ҫ�ǰ�������0������ɾ����
	local break_flag = true
	while break_flag do
		break_flag = false
		local iit = backpack:SeekToBegin()
		local i = iit:GetValue()
		while i ~= nil do
			if i._count == 0 then
				iit:Pop()
				break_flag = true
				break
			end
			iit:Next()
			i = iit:GetValue()
		end
	end

	--����ͳ����־
	local date = os.date("%Y-%m-%d %H:%M:%S")
    path = path or 0
	API_BILog("{\"logtime\":\""..date.."\",\"logname\":\"lostitem\",\"serverid\":\""..API_GetZoneId()..
		"\",\"os\":\""..role._roledata._device_info._os.."\",\"platform\":\"".."laohu".."\",\"userid\":\""
		..role._roledata._status._account.."\",\"account\":\""..role._roledata._status._account.."\",\"roleid\":\""
		..role._roledata._base._id:ToStr().."\",\"rolename\":\""..role._roledata._base._name.."\",\"lev\":\""
		..role._roledata._status._level.."\",\"itemtype\":\""..item.item_type.."\",\"itemid\":\""..tid.."\",\"itemcount\":\""
		..count.."\",\"itempath\":\""..path.."\"}")

	return true
end

--�鿴��ҵı�������ĳһ�����ߵ������Ƿ�ﵽһ��ֵ
function BACKPACK_HaveItem(role, tid, count)
	if count<=0 or tid<=0 then
		return false
	end
	local items = role._roledata._backpack._items

	local all_count = 0
	local iit = items:SeekToBegin() --��ͷ��ʼ����
	local i = iit:GetValue()
	while i~=nil do
		if i._tid == tid then
			all_count = all_count + i._count
		end
		iit:Next()
		i = iit:GetValue()
	end
	if all_count >= count then
		return true
	else
		return false
	end
end

--���߿ͻ��ˣ��ҵı�����Ϣ
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

--���߿ͻ��ˣ��ҵ�ĳһ����Ʒ�ĵ�ǰ����
function BACKPACK_SendBackPackOneItem(role,itemid)
	local resp = NewCommand("ItemCountChange")
	resp.itemid = itemid
	resp.count = 0
	local items = role._roledata._backpack._items
	
	local iit = items:SeekToBegin() --��ͷ��ʼ����
	local i = iit:GetValue()
	while i~=nil do
		if i._tid == itemid then
			resp.count = resp.count + i._count
		end
		iit:Next()
		i = iit:GetValue()
	end
	role:SendToClient(SerializeCommand(resp))
end

--�ֱ�����Ʒ��ID���Լ��������Ե�ģ��ID
function BACKPACK_AddWeapon(role, item_id, tid, show_panel)
	local ed = DataPool_Find("elementdata")
	local weapon_info = ed:FindBy("weapon_id", tid)

	local insert_weapon = CACHE.WeaponItem()

	role._roledata._backpack._weapon_items._id = role._roledata._backpack._weapon_items._id + 1

	insert_weapon._base_item._tid = item_id
	insert_weapon._base_item._count = 1

	insert_weapon._weapon_pro._tid = role._roledata._backpack._weapon_items._id
	insert_weapon._weapon_pro._level = weapon_info.wearlv
	insert_weapon._weapon_pro._star = weapon_info.star
	insert_weapon._weapon_pro._quality = weapon_info.grade
	insert_weapon._weapon_pro._prop = weapon_info.weapontype
	insert_weapon._weapon_pro._attack = weapon_info.atk
	insert_weapon._weapon_pro._weapon_skill = 0
	insert_weapon._weapon_pro._level_up = 1 

	local max_skill_num = weapon_info.specialpropnummax
	local min_skill_num = weapon_info.specialpropnummin

	--���������봿��Ϊ�˷�ֹ�߻�д������������������һ��������
	local num = 0
	for tmp_skill in DataPool_Array(weapon_info.specialprop) do
		if tmp_skill == 0 then
			break
		end
		num = num + 1
	end

	if max_skill_num > num then
		max_skill_num = num
	end

	if min_skill_num > max_skill_num then
		min_skill_num = max_skill_num
	end

	local need_num = math.random(min_skill_num, max_skill_num)
	while insert_weapon._weapon_pro._skill_pro:Size() < need_num do
		local tmp_num = math.random(num)
		local insert_skill_id = weapon_info.specialprop[tmp_num]
		if insert_weapon._weapon_pro._skill_pro:Find(insert_skill_id) == nil then
			local insert_skill = CACHE.WeaponSkill()
			insert_skill._skill_id = insert_skill_id
			insert_skill._skill_level = math.random(weapon_info.specialproplvmin, weapon_info.specialproplvmax)
			insert_weapon._weapon_pro._skill_pro:Insert(insert_skill_id, insert_skill)
		end
	end
	
	role._roledata._backpack._weapon_items._weapon_items:PushBack(insert_weapon)
	
	--�ɾ��޸�
	TASK_ChangeCondition_Special(role, G_ACH_TYPE["WEAPON_LEVELUP"], insert_weapon._weapon_pro._level, 0, 1)

	--���߿ͻ��˻����һ���µ�����
	local resp = NewCommand("WeaponAdd")
	resp.weapon_info = {}
	resp.weapon_info.base_item = {}
	resp.weapon_info.base_item.tid = item_id
	resp.weapon_info.base_item.count = 1
	resp.weapon_info.weapon_info = {}
	resp.weapon_info.weapon_info.tid = insert_weapon._weapon_pro._tid
	resp.weapon_info.weapon_info.level = insert_weapon._weapon_pro._level
	resp.weapon_info.weapon_info.star = insert_weapon._weapon_pro._star
	resp.weapon_info.weapon_info.quality = insert_weapon._weapon_pro._quality
	resp.weapon_info.weapon_info.prop = insert_weapon._weapon_pro._prop
	resp.weapon_info.weapon_info.attack = insert_weapon._weapon_pro._attack
	resp.weapon_info.weapon_info.strength = 0
	resp.weapon_info.weapon_info.level_up = 1
	resp.weapon_info.weapon_info.weapon_skill = insert_weapon._weapon_pro._weapon_skill
	resp.weapon_info.weapon_info.strength_prob = 0
	resp.weapon_info.weapon_info.skill_pro = {}
	resp.weapon_info.weapon_info.exp = 0
	
	local tmp_skill_it = insert_weapon._weapon_pro._skill_pro:SeekToBegin()
	local tmp_skill = tmp_skill_it:GetValue()
	while tmp_skill ~= nil do
		local xxxx = {}
		xxxx.skill_id = tmp_skill._skill_id
		xxxx.skill_level = tmp_skill._skill_level
		resp.weapon_info.weapon_info.skill_pro[#resp.weapon_info.weapon_info.skill_pro+1] = xxxx
		tmp_skill_it:Next()
		tmp_skill = tmp_skill_it:GetValue()
	end

	resp.show_panel = show_panel
	
	role:SendToClient(SerializeCommand(resp))

	--�����Ĺ���
	if weapon_info.billboardid ~= 0 then
		local notice_para = {}
		
		local tmp_notice_para = {}
		tmp_notice_para.typ = 1
		tmp_notice_para.id = role._roledata._base._id:ToStr()
		tmp_notice_para.name = role._roledata._base._name
		tmp_notice_para.num = 0
		notice_para[#notice_para+1] = tmp_notice_para
		
		local tmp_notice_para = {}
		tmp_notice_para.typ = 2
		tmp_notice_para.id = tostring(weapon_info.ownerid)
		tmp_notice_para.name = weapon_info.owner_name
		tmp_notice_para.num = 0
		notice_para[#notice_para+1] = tmp_notice_para
		
		local tmp_notice_para = {}
		tmp_notice_para.typ = 4
		tmp_notice_para.id = tostring(weapon_info.id)
		tmp_notice_para.name = weapon_info.name
		tmp_notice_para.num = 0
		notice_para[#notice_para+1] = tmp_notice_para

		ROLE_SendNotice(weapon_info.billboardid, notice_para)
	end
end

function BACKPACK_UpdateWeaponItem(role, weapon_id)
	local weapon_items = role._roledata._backpack._weapon_items

	local weapon_item_it = weapon_items._weapon_items:SeekToBegin()
	local weapon_item = weapon_item_it:GetValue()
	while weapon_item ~= nil do
		if weapon_item._weapon_pro._tid == weapon_id then
			--���߿ͻ��˻����һ���µ�����
			local resp = NewCommand("WeaponUpdate")
			resp.weapon_info = {}
			resp.weapon_info.base_item = {}
			resp.weapon_info.base_item.tid = weapon_item._base_item._tid
			resp.weapon_info.base_item.count = 1
			resp.weapon_info.weapon_info = {}
			resp.weapon_info.weapon_info.tid = weapon_item._weapon_pro._tid
			resp.weapon_info.weapon_info.level = weapon_item._weapon_pro._level
			resp.weapon_info.weapon_info.star = weapon_item._weapon_pro._star
			resp.weapon_info.weapon_info.quality = weapon_item._weapon_pro._quality
			resp.weapon_info.weapon_info.prop = weapon_item._weapon_pro._prop
			resp.weapon_info.weapon_info.attack = weapon_item._weapon_pro._attack
			resp.weapon_info.weapon_info.strength = weapon_item._weapon_pro._strengthen
			resp.weapon_info.weapon_info.level_up = weapon_item._weapon_pro._level_up
			resp.weapon_info.weapon_info.weapon_skill = weapon_item._weapon_pro._weapon_skill
			resp.weapon_info.weapon_info.strength_prob = weapon_item._weapon_pro._strengthen_prob
			resp.weapon_info.weapon_info.skill_pro = {}
			local tmp_skill_it = weapon_item._weapon_pro._skill_pro:SeekToBegin()
			local tmp_skill = tmp_skill_it:GetValue()
			while tmp_skill ~= nil do
				local xxxx = {}
				xxxx.skill_id = tmp_skill._skill_id
				xxxx.skill_level = tmp_skill._skill_level
				resp.weapon_info.weapon_info.skill_pro[#resp.weapon_info.weapon_info.skill_pro+1] = xxxx
				tmp_skill_it:Next()
				tmp_skill = tmp_skill_it:GetValue()
			end
			resp.weapon_info.weapon_info.exp = weapon_item._weapon_pro._exp
			
			role:SendToClient(SerializeCommand(resp))
			return
		end
		weapon_item_it:Next()
		weapon_item = weapon_item_it:GetValue()
	end
end

--�õ�һ���µ�װ��
function BACKPACK_AddEquipment(role, item_id, equipment_id)
	local ed = DataPool_Find("elementdata")
	local equip_info = ed:FindBy("equip_id", equipment_id)

	local insert_equip = CACHE.EquipmentItem()
	
	insert_equip._base_item._tid = item_id
	insert_equip._base_item._count = 1

	role._roledata._backpack._equipment_items._id = role._roledata._backpack._equipment_items._id + 1

	insert_equip._equipment_pro._tid = role._roledata._backpack._equipment_items._id
	insert_equip._equipment_pro._level_up = 1

	role._roledata._backpack._equipment_items._equipment_items:Insert(insert_equip._equipment_pro._tid, insert_equip)

	--�ɾ��޸�
	TASK_ChangeCondition_Special(role, G_ACH_TYPE["EQUIPMENT_LEVELUP"], insert_equip._equipment_pro._level_up, 0, 1)

	--֪ͨ�ͻ��˵õ���һ���µ�װ��
	local resp = NewCommand("EquipmentAdd")
	resp.equipment_info = {}
	resp.equipment_info.base_item = {}
	resp.equipment_info.equipment_info = {}

	resp.equipment_info.base_item.tid = insert_equip._base_item._tid
	resp.equipment_info.base_item.count = 1

	resp.equipment_info.equipment_info.tid = insert_equip._equipment_pro._tid
	resp.equipment_info.equipment_info.hero_id = 0
	resp.equipment_info.equipment_info.level = 1
	resp.equipment_info.equipment_info.order = 0
	resp.equipment_info.equipment_info.refinable_pro = {}
	resp.equipment_info.equipment_info.tmp_refinable_pro = {}
			
	role:SendToClient(SerializeCommand(resp))

end

--����һ��װ��������
function BACKPACK_UpdateEquipment(role, equipment_id)
	
	local find_equipment = role._roledata._backpack._equipment_items._equipment_items:Find(equipment_id)
	if find_equipment ~= nil then
		--���¿ͻ��˵�һ��װ����Ϣ
		local resp = NewCommand("EquipmentUpdate")
		resp.equipment_info = {}
		resp.equipment_info.base_item = {}
		resp.equipment_info.equipment_info = {}

		resp.equipment_info.base_item.tid = find_equipment._base_item._tid
		resp.equipment_info.base_item.count = 1

		resp.equipment_info.equipment_info.tid = find_equipment._equipment_pro._tid
		resp.equipment_info.equipment_info.hero_id = find_equipment._equipment_pro._hero_id
		resp.equipment_info.equipment_info.level = find_equipment._equipment_pro._level_up
		resp.equipment_info.equipment_info.order = find_equipment._equipment_pro._order
		resp.equipment_info.equipment_info.level_up_money = find_equipment._equipment_pro._level_up_money
		resp.equipment_info.equipment_info.refinable_pro = {}
		resp.equipment_info.equipment_info.tmp_refinable_pro = {}

		local refinable_it = find_equipment._equipment_pro._refinable_pro:SeekToBegin()
		local refinable = refinable_it:GetValue()
		while refinable ~= nil do
			local tmp_refinable = {}
			tmp_refinable.typ = refinable._typ
			tmp_refinable.data = refinable._num
			resp.equipment_info.equipment_info.refinable_pro[#resp.equipment_info.equipment_info.refinable_pro+1] = tmp_refinable

			refinable_it:Next()
			refinable = refinable_it:GetValue()
		end
		
		local refinable_it = find_equipment._equipment_pro._tmp_refinable_pro:SeekToBegin()
		local refinable = refinable_it:GetValue()
		while refinable ~= nil do
			local tmp_refinable = {}
			tmp_refinable.typ = refinable._typ
			tmp_refinable.data = refinable._num
			resp.equipment_info.equipment_info.tmp_refinable_pro[#resp.equipment_info.equipment_info.tmp_refinable_pro+1] = tmp_refinable

			refinable_it:Next()
			refinable = refinable_it:GetValue()
		end
				
		role:SendToClient(SerializeCommand(resp))
	end
end

--ɾ��һ��װ��
function BACKPACK_DelEquipment(role, equipment_id)
	role._roledata._backpack._equipment_items._equipment_items:Delete(equipment_id)

	--֪ͨ�ͻ��˵õ���һ���µ�װ��
	local resp = NewCommand("EquipmentDel")
	resp.id = equipment_id
	role:SendToClient(SerializeCommand(resp))
end

--����ʱ������������Ʒ
function BACKPACK_TemporaryAddItem(role, drop_id, reward_id, typ)
	role._roledata._temporary_backpack._id = role._roledata._temporary_backpack._id + 1
	local insert_data = CACHE.TemporaryBackPackData()
	insert_data._id = role._roledata._temporary_backpack._id
	insert_data._typ = typ
	
	if drop_id ~= 0 then
		local drop_item = DROPITEM_DropItem(role, drop_id)

		for index = 1,table.getn(drop_item) do
			local item = ed:FindBy("item_id", drop_item[index].id)
			if item.packlimit == 0 then
				for index = 1,drop_item[index].count do
					local tmp = CACHE.Item()
					tmp._tid = drop_item[index].id
					tmp._count = 1
					insert_data._iteminfo:PushBack(tmp)
				end
			else
				local insert_flag = true
				local iteminfo_it = insert_data._iteminfo:SeekToBegin()
				local iteminfo = iteminfo_it:GetValue()
				while iteminfo ~= nil do
					if iteminfo._tid == drop_item[index].id then
						iteminfo._count = iteminfo._count + drop_item[index].count
						insert_flag = false
						break
					end
					iteminfo_it:Next()
					iteminfo = iteminfo_it:GetValue()
				end
				if insert_flag == true then
					local tmp = CACHE.Item()
					tmp._tid = drop_item[index].id
					tmp._count = drop_item[index].count
					insert_data._iteminfo:PushBack(tmp)
				end
			end
		end
	end

	if reward_id ~= 0 then
		local reward = DROPITEM_Reward(role, reward_id)
		for index = 1,table.getn(reward.item) do
			local item = ed:FindBy("item_id", reward.item[index].itemid)
			if item.packlimit == 0 then
				for index = 1,reward.item[index].itemnum do
					local tmp = CACHE.Item()
					tmp._tid = reward.item[index].itemid
					tmp._count = 1
					insert_data._iteminfo:PushBack(tmp)
				end
			else
				local insert_flag = true
				local iteminfo_it = insert_data._iteminfo:SeekToBegin()
				local iteminfo = iteminfo_it:GetValue()
				while iteminfo ~= nil do
					if iteminfo._tid == reward.item[index].itemid then
						iteminfo._count = iteminfo._count + reward.item[index].itemnum
						insert_flag = false
						break
					end
					iteminfo_it:Next()
					iteminfo = iteminfo_it:GetValue()
				end
				if insert_flag == true then
					local tmp = CACHE.Item()
					tmp._tid = reward.item[index].itemid
					tmp._count = reward.item[index].itemnum
					insert_data._iteminfo:PushBack(tmp)
				end
			end
		end
	end
	role._roledata._temporary_backpack._data:Insert(insert_data._id, insert_data)
	return insert_data
end
