--计算武器给武将的加成
function Property_UpdateWeaponInfo(weaponinfo)
	--weaponinfo.atk  代表的是武器的基础攻击力
	--weaponinfo.lvupatk 代表的是武器升级的加成
	--weaponinfo.levelup 代表的是武器的当前等级
	--weaponinfo.enhance_scale 代表的是武器当前的强化比例
	local weapon_property = {}
	weapon_property.atk = 0
	weapon_property.def = 0
	weapon_property.maxhp = 0

	weapon_property.atk = weaponinfo.atk + weaponinfo.lvupatk*weaponinfo.levelup
	return weapon_property
end

--计算装备给武将的加成
function Property_UpdateEquipInfo(equipinfo)
	--equipinfo.level 装备等级
	--equipinfo.order 装备阶别

	--equipinfo.base_atk	初始攻击
	--equipinfo.base_maxhp	初始血量
	--equipinfo.base_armor	初始护甲
	--equipinfo.base_atk_ratio	初始攻击加成比例
	--equipinfo.base_maxhp_ratio	初始血量加成比例
	--equipinfo.base_armor_ratio	初始护甲加成比例

	
	--equipinfo.grow_atk	攻击成长
	--equipinfo.grow_maxhp	血量成长
	--equipinfo.grow_armor  护甲成长
	--equipinfo.grow_atk_ratio	攻击加成比例成长
	--equipinfo.grow_maxhp_ratio	血量加成比例成长
	--equipinfo.grow_armor_ratio  护甲加成比例成长


	
	--equipinfo.refine_atk 洗练攻击
	--equipinfo.refine_maxhp 洗练血量
	--equipinfo.refine_armor 洗练护甲
	--equipinfo.refine_sub_dmg 洗练减伤
	--equipinfo.refine_add_dmg 洗练加伤
	--equipinfo.refine_enh_getrage 洗练怒气增长
	--equipinfo.refine_recover 洗练生命回复
	--equipinfo.refine_res_element 洗练元素抗性
	--equipinfo.refine_enh_element 洗练元素强化
	local level = equipinfo.level
	local order = equipinfo.order

	local equip_property = {}
	equip_property.atk = equipinfo.base_atk + equipinfo.grow_atk*level
	equip_property.maxhp = equipinfo.base_maxhp + equipinfo.grow_maxhp*level
	equip_property.armor = equipinfo.base_armor + equipinfo.grow_armor*level
	return equip_property
end

function Property_UpdateHeroInfo(hero_info, legion_info)
	
	local ed = DataPool_Find("elementdata")
	local weaponinfo = {}
	weaponinfo.atk = 0
	weaponinfo.lvupatk = 0
	weaponinfo.levelup = 0
	weaponinfo.enhance_scale = 0
	--技能所有的效果
	local all_skill_id = {}

	if hero_info.weapon.base_item.tid ~= 0 then
		local ed = DataPool_Find("elementdata")
		local item = ed:FindBy("item_id", hero_info.weapon.base_item.tid)
		local weapon_info = ed:FindBy("weapon_id", item.type_data1)
		weaponinfo.atk = weapon_info.atk
		weaponinfo.lvupatk = weapon_info.lvupatk
		weaponinfo.levelup = hero_info.weapon.weapon_info.level_up
		
		for index = 0, hero_info.weapon.weapon_info.strength-1 do
			local strength_info = ed:FindBy("weaponstrength_id", index)
			weaponinfo.enhance_scale = weaponinfo.enhance_scale + strength_info.lvintensifyeffect
			weaponinfo.enhance_scale = weaponinfo.enhance_scale + 
			strength_info.onceintensifyeffect*strength_info.weaponintensifytimes
		end

		local strength_info = ed:FindBy("weaponstrength_id", hero_info.weapon.weapon_info.strength)
		weaponinfo.enhance_scale = weaponinfo.enhance_scale + strength_info.lvintensifyeffect
		weaponinfo.enhance_scale = weaponinfo.enhance_scale + strength_info.onceintensifyeffect*hero_info.weapon.weapon_info.strength_prob
		
		--武器印，武器技做成的影响
		if hero_info.weapon.weapon_info.weapon_skill ~= 0 then
			all_skill_id[#all_skill_id+1] = hero_info.weapon.weapon_info.weapon_skill*1000+1
		end
		
		for index = 1, table.getn(hero_info.weapon.weapon_info.skill_pro) do
			local tmp_skill = hero_info.weapon.weapon_info.skill_pro[index]
			all_skill_id[#all_skill_id+1] = tmp_skill.skill_id*1000+tmp_skill.skill_level
		end
	end

	--武器对武将的数据加成
	local weapon_property = Property_UpdateWeaponInfo(weaponinfo)

	--装备对武将的数据加成
	local equip_property = {}
	equip_property.atk = 0
	equip_property.maxhp = 0
	equip_property.armor = 0

	for index = 1,table.getn(hero_info.equipment) do
		local equip_item = hero_info.equipment[index]
		local find_item_info = ed:FindBy("item_id", equip_item.item_id)
		local find_equip_info = ed:FindBy("equip_id", find_item_info.type_data1)
		if find_equip_info ~= nil then
			local equipinfo = {}
			equipinfo.level = equip_item.level
			equipinfo.order = equip_item.order

			--初始属性，以及初始成长
			equipinfo.base_atk = 0
			equipinfo.base_maxhp = 0
			equipinfo.base_armor = 0

			
			for initial_prop in DataPool_Array(find_equip_info.initial_prop) do
				if initial_prop.prop_type == 0 then
					break
				elseif initial_prop.prop_type == 1 then
					equipinfo.base_atk = initial_prop.prop_num
				elseif initial_prop.prop_type == 2 then
					equipinfo.base_maxhp = initial_prop.prop_num
				elseif initial_prop.prop_type == 3 then
					equipinfo.base_armor = initial_prop.prop_num
				end
			end

			equipinfo.grow_atk = 0
			equipinfo.grow_maxhp = 0
			equipinfo.grow_armor = 0
			equipinfo.grow_atk_ratio = 0
			equipinfo.grow_maxhp_ratio = 0
			equipinfo.grow_armor_ratio = 0
			equipinfo.grow_add_dmg = 0
			equipinfo.grow_sub_dmg = 0
			
			for grow_prop in DataPool_Array(find_equip_info.grow_prop) do
				if grow_prop.prop_type == 0 then
					break
				elseif grow_prop.prop_type == 1 then
					equipinfo.grow_atk = grow_prop.prop_num
				elseif grow_prop.prop_type == 2 then
					equipinfo.grow_maxhp = grow_prop.prop_num
				elseif grow_prop.prop_type == 3 then
					equipinfo.grow_armor = grow_prop.prop_num
				end
			end
			
			local tmp_equip_info = Property_UpdateEquipInfo(equipinfo)
			equip_property.atk = equip_property.atk + tmp_equip_info.atk
			equip_property.maxhp = equip_property.maxhp + tmp_equip_info.maxhp
			equip_property.armor = equip_property.armor + tmp_equip_info.armor
		end
	end

	--装备套装
	local equip_set_property = {}
	equip_set_property.teji_scale_atk = 0
	equip_set_property.teji_scale_maxhp = 0
	equip_set_property.teji_scale_armor = 0
	equip_set_property.teji_atk = 0
	equip_set_property.teji_maxhp = 0
	equip_set_property.teji_armor = 0

		for key,value in pairs(hero_info.equipment_set) do
			local equip_set = ed:FindBy("equipset_id", key)
			if equip_set ~= nil then
				for effect in DataPool_Array(equip_set.set_effect) do
					if effect.need_equip_num <= value then
						local teji = ed:FindBy("teji_id", effect.teji_id*1000+1)
						if teji ~= nil then
							equip_set_property.teji_scale_atk = equip_set_property.teji_scale_atk + teji.teji_scale_atk
							equip_set_property.teji_scale_maxhp = equip_set_property.teji_scale_maxhp + teji.teji_scale_maxhp
							equip_set_property.teji_scale_armor = equip_set_property.teji_scale_armor + teji.teji_scale_armor
							equip_set_property.teji_atk = equip_set_property.teji_atk + teji.teji_atk
							equip_set_property.teji_maxhp = equip_set_property.teji_maxhp + teji.teji_maxhp
							equip_set_property.teji_armor = equip_set_property.teji_armor + teji.teji_armor
						end
					end
				end
			end
		end

	--武将羁绊造成的影响
	local relation_property = {}
	relation_property.relationatkratio = 0
	relation_property.relationmaxhpratio = 0
	relation_property.relationarmorratio = 0

	for index = 1, table.getn(hero_info.relation) do
		local relation_info = ed:FindBy("relation_id", hero_info.relation[index])
		relation_property.relationatkratio = relation_property.relationatkratio + relation_info.relationatkratio
		relation_property.relationmaxhpratio = relation_property.relationmaxhpratio + relation_info.relationmaxhpratio
		relation_property.relationarmorratio = relation_property.relationarmorratio + relation_info.relationarmorratio
	end

	--武将的自身属性
	local hero_property = {}
	hero_property.level = hero_info.level
	hero_property.star = hero_info.star 

	local init_atk = 200;	--武将初始攻击
	local init_armor = 100;	--武将初始护甲
	local init_maxhp = 1000;	--武将初始气血
	local grow_perlv_atk = 12;	--武将攻击成长
	local grow_perlv_armor = 6;	--武将护甲成长
	local grow_perlv_maxhp = 60;	--武将气血成长
	
	local find_hero_info = ed:FindBy("hero_id", hero_info.tid)
	hero_property.init_atk = init_atk * find_hero_info.atk_pve_capacity / 1000
	hero_property.init_maxhp = init_maxhp * find_hero_info.maxhp_pve_capacity / 1000
	hero_property.init_armor = init_armor * find_hero_info.armor_pve_capacity / 1000
	
	hero_property.grow_perlv_atk = grow_perlv_atk * find_hero_info.atk_pve_capacity / 1000
	hero_property.grow_perlv_maxhp = grow_perlv_maxhp * find_hero_info.maxhp_pve_capacity / 1000
	hero_property.grow_perlv_armor = grow_perlv_armor * find_hero_info.armor_pve_capacity / 1000
	hero_property.gender_male = find_hero_info.gender_male
	hero_property.gender_female = find_hero_info.gender_female
	hero_property.kingdom_wei = find_hero_info.kingdom_wei
	hero_property.kingdom_shu = find_hero_info.kingdom_shu
	hero_property.kingdom_wu = find_hero_info.kingdom_wu
	hero_property.kingdom_qun = find_hero_info.kingdom_qun

	--进阶属性
	hero_property.add_atk = 0
	hero_property.add_maxhp = 0
	hero_property.add_armor = 0

	if find_hero_info.rolegradeID ~= 0 then
		local find_order_info = ed:FindBy("herograde_id", hero_info.tid)

		for grade in DataPool_Array(find_order_info.grade) do
			if grade.grade == hero_info.order then
				hero_property.add_atk = grade.add_atk
				hero_property.add_maxhp = grade.add_maxhp
				hero_property.add_armor = grade.add_armor
				break
			end
		end
	end

	--自身的被动技能
	for index = 1, table.getn(hero_info.beidong_skill) do
		all_skill_id[#all_skill_id+1] = hero_info.beidong_skill[index]
	end

	--特技带来的影响
	local weapon_skill_property = {}
	weapon_skill_property.teji_zhanli = 0
	weapon_skill_property.teji_scale_atk = 0
	weapon_skill_property.teji_scale_maxhp = 0
	weapon_skill_property.teji_scale_armor = 0
	weapon_skill_property.teji_atk = 0
	weapon_skill_property.teji_maxhp = 0
	weapon_skill_property.teji_armor = 0
	weapon_skill_property.teji_add_dmg = 0
	weapon_skill_property.teji_sub_dmg = 0
	weapon_skill_property.teji_enh_getrage = 0
	weapon_skill_property.teji_enh_element = 0
	weapon_skill_property.teji_res_element = 0
	weapon_skill_property.teji_recover = 0
	weapon_skill_property.teji_enh_air = 0
	weapon_skill_property.teji_enh_defence = 0
	weapon_skill_property.teji_enh_ground = 0
	weapon_skill_property.teji_res_air = 0
	weapon_skill_property.teji_res_defence = 0
	weapon_skill_property.teji_res_ground = 0
	weapon_skill_property.teji_enh_dmg = 0
	weapon_skill_property.teji_res_dmg = 0
	weapon_skill_property.teji_reflict_dmg = 0
	weapon_skill_property.teji_miror_dmg = 0
	weapon_skill_property.teji_leech = 0
	weapon_skill_property.teji_hit_hprecover = 0
	weapon_skill_property.teji_ice_atk = 0
	weapon_skill_property.teji_fire_atk = 0
	weapon_skill_property.teji_thunder_atk = 0
	weapon_skill_property.teji_poison_atk = 0
	weapon_skill_property.teji_qiren_atk = 0
	weapon_skill_property.teji_wind_atk = 0
	weapon_skill_property.teji_res_ice = 0
	weapon_skill_property.teji_res_fire = 0
	weapon_skill_property.teji_res_thunder = 0
	weapon_skill_property.teji_res_poison = 0
	weapon_skill_property.teji_res_qiren = 0
	weapon_skill_property.teji_res_wind = 0
	weapon_skill_property.teji_enh_ice = 0
	weapon_skill_property.teji_enh_fire = 0
	weapon_skill_property.teji_enh_thunder = 0
	weapon_skill_property.teji_enh_poison = 0
	weapon_skill_property.teji_enh_qiren = 0
	weapon_skill_property.teji_enh_wind = 0

	for index = 1,table.getn(all_skill_id) do
		local teji_info = ed:FindBy("teji_id", all_skill_id[index])
		if teji_info ~= nil then
			weapon_skill_property.teji_zhanli = weapon_skill_property.teji_zhanli + teji_info.teji_zhanli
			weapon_skill_property.teji_scale_atk = weapon_skill_property.teji_scale_atk + teji_info.teji_scale_atk
			weapon_skill_property.teji_scale_maxhp = weapon_skill_property.teji_scale_maxhp + teji_info.teji_scale_maxhp
			weapon_skill_property.teji_scale_armor = weapon_skill_property.teji_scale_armor + teji_info.teji_scale_armor
			weapon_skill_property.teji_atk = weapon_skill_property.teji_atk + teji_info.teji_atk
			weapon_skill_property.teji_maxhp = weapon_skill_property.teji_maxhp + teji_info.teji_maxhp
			weapon_skill_property.teji_armor = weapon_skill_property.teji_armor + teji_info.teji_armor
		else
			API_Log("1111111111111111111111111111111111111111111111111  teji_id="..all_skill_id[index])
		end
	end

	return Property_Zhanli(weapon_property, equip_property, relation_property, hero_property, weapon_skill_property, legion_info, equip_set_property)
end

--战力的计算,变量分别代表的是武器，装备，羁绊，武将本身，特效带来的影响
function Property_Zhanli(weapon_property, equip_property, relation_property, hero_property, weapon_skill_property, legion_info, equip_set_property)
	--weapon_property.atk
	--weapon_property.def
	--weapon_property.maxhp

	--equip_property.atk
	--equip_property.maxhp
	--equip_property.armor
	--equip_property.sub_dmg
	--equip_property.add_dmg
	--equip_property.enh_getrage
	--equip_property.recover
	--equip_property.res_element
	--equip_property.enh_element
	
	--relation_property.relationatkratio
	--relation_property.relationmaxhpratio
	--relation_property.relationarmorratio
	
	--hero_property.level = hero_info._level
	--hero_property.star = hero_info._star 
	--hero_property.init_atk = find_hero_info.init_atk
	--hero_property.init_maxhp = find_hero_info.init_maxhp
	--hero_property.init_armor = find_hero_info.init_armor
	--hero_property.grow_perlv_atk = find_hero_info.grow_perlv_atk
	--hero_property.grow_perlv_maxhp = find_hero_info.grow_perlv_maxhp
	--hero_property.grow_perlv_armor = find_hero_info.grow_perlv_armor
	--hero_property.gender_male = find_hero_info.gender_male
	--hero_property.gender_female = find_hero_info.gender_female
	--hero_property.kingdom_wei = find_hero_info.kingdom_wei
	--hero_property.kingdom_shu = find_hero_info.kingdom_shu
	--hero_property.kingdom_wu = find_hero_info.kingdom_wu
	--hero_property.kingdom_qun = find_hero_info.kingdom_qun
	--hero_property.add_atk = 0
	--hero_property.add_maxhp = 0
	--hero_property.add_armor = 0
	
	--weapon_skill_property.teji_zhanli
	--weapon_skill_property.teji_scale_atk
	--weapon_skill_property.teji_scale_maxhp
	--weapon_skill_property.teji_scale_armor
	--weapon_skill_property.teji_atk
	--weapon_skill_property.teji_maxhp
	--weapon_skill_property.teji_armor
	--weapon_skill_property.teji_add_dmg
	--weapon_skill_property.teji_sub_dmg
	--weapon_skill_property.teji_enh_getrage
	--weapon_skill_property.teji_enh_element
	--weapon_skill_property.teji_res_element
	--weapon_skill_property.teji_recover
	--weapon_skill_property.teji_enh_air
	--weapon_skill_property.teji_enh_defence
	--weapon_skill_property.teji_enh_ground
	--weapon_skill_property.teji_res_air
	--weapon_skill_property.teji_res_defence
	--weapon_skill_property.teji_res_ground
	--weapon_skill_property.teji_enh_dmg
	--weapon_skill_property.teji_res_dmg
	--weapon_skill_property.teji_reflict_dmg
	--weapon_skill_property.teji_miror_dmg
	--weapon_skill_property.teji_leech
	--weapon_skill_property.teji_hit_hprecover
	--weapon_skill_property.teji_ice_atk
	--weapon_skill_property.teji_fire_atk
	--weapon_skill_property.teji_thunder_atk
	--weapon_skill_property.teji_poison_atk
	--weapon_skill_property.teji_qiren_atk
	--weapon_skill_property.teji_wind_atk
	--weapon_skill_property.teji_res_ice
	--weapon_skill_property.teji_res_fire
	--weapon_skill_property.teji_res_thunder
	--weapon_skill_property.teji_res_poison
	--weapon_skill_property.teji_res_qiren
	--weapon_skill_property.teji_res_wind
	--weapon_skill_property.teji_enh_ice
	--weapon_skill_property.teji_enh_fire
	--weapon_skill_property.teji_enh_thunder
	--weapon_skill_property.teji_enh_poison
	--weapon_skill_property.teji_enh_qiren
	--weapon_skill_property.teji_enh_wind
	

	
	--定义用到的变量
	local star_enhance = 0;
	local role_atk = 0;
	local role_maxhp = 0;
	local role_armor = 0;
	local base_atk = 0;
	local base_maxhp = 0;
	local base_armor = 0;
	local hero_scale_atk = 0;
	local hero_scale_maxhp = 0;
	local hero_scale_armor = 0;
	local hero_atk = 0;
	local hero_maxhp = 0;
	local hero_armor = 0;
	local legion_add_atk = 0;
	local legion_add_maxhp = 0;
	local legion_add_armor = 0;
	
	--定义星级系数
	local star1_enhance = 1;
	local star2_enhance = 1;
	local star3_enhance = 1;
	local star4_enhance = 1.15;
	local star5_enhance = 1.3;
	local star6_enhance = 1.4;
	local star7_enhance = 1.5;
	local star8_enhance = 1.6;
	local star9_enhance = 1.7;
	local star10_enhance = 1.8;
	
	--计算星级加成比例
	if hero_property.star == 1 then
		star_enhance = star1_enhance;
	elseif hero_property.star == 2 then
		star_enhance = star2_enhance;
	elseif hero_property.star == 3 then
		star_enhance = star3_enhance;
	elseif hero_property.star == 4 then
		star_enhance = star4_enhance;
	elseif hero_property.star == 5 then
		star_enhance = star5_enhance;
	elseif hero_property.star == 6 then
		star_enhance = star6_enhance;
	elseif hero_property.star == 7 then
		star_enhance = star7_enhance;
	elseif hero_property.star == 8 then
		star_enhance = star8_enhance;
	elseif hero_property.star == 9 then
		star_enhance = star9_enhance;
	elseif hero_property.star == 10 then
		star_enhance = star10_enhance;
	end
	
	--计算军学属性加成比例
	local ed = DataPool_Find("elementdata")
	for index = 1, table.getn(legion_info) do
		--legion_info[index].id	军学专精的id
		--legion_info[index].level 军学专精的等级
		local legion_spec_info = ed:FindBy("legionspec_id", legion_info[index].id)
		--为军团属性叠加军学专精带来的固定属性加成，包括基础属性和等级成长
		if legion_spec_info ~= nil then
			legion_add_atk = legion_add_atk + legion_spec_info.spec_prop[1].base_prop + legion_spec_info.spec_prop[1].base_grow * legion_info[index].level ;
			legion_add_maxhp = legion_add_maxhp + legion_spec_info.spec_prop[2].base_prop + legion_spec_info.spec_prop[2].base_grow * legion_info[index].level ;
			legion_add_armor = legion_add_armor + legion_spec_info.spec_prop[3].base_prop + legion_spec_info.spec_prop[3].base_grow * legion_info[index].level ;
		end
		--为军团属性叠加军学技能项目的固定属性加成
		for learn_index = 1, table.getn(legion_info[index].learned) do
			local legion_learn_info = ed:FindBy("legiontech_id",legion_info[index].learned[learn_index])
			if legion_learn_info ~= nil then
				legion_add_atk = legion_add_atk + legion_learn_info.atk ;
				legion_add_maxhp = legion_add_maxhp + legion_learn_info.maxhp ;
				legion_add_armor = legion_add_armor + legion_learn_info.armor ;
			end
		end
	end
	
	--计算主角加成属性
	hero_atk = legion_add_atk;
	hero_maxhp = legion_add_maxhp;
	hero_armor = legion_add_armor;
	
	--定义各个属性的战斗力系数
	local atkratio = 1;
	local maxhpratio = 0.16;
	local armorratio = 1;

	--计算人物属性
	role_atk = ( weapon_skill_property.teji_atk + (hero_property.init_atk + hero_property.add_atk + hero_property.grow_perlv_atk * hero_property.level)*(equip_set_property.teji_scale_atk + 1000)/1000)*(1000 + weapon_skill_property.teji_scale_atk + relation_property.relationatkratio) / 1000 * star_enhance + equip_property.atk + weapon_skill_property.teji_atk + weapon_property.atk + equip_set_property.teji_atk;
	role_maxhp = ( weapon_skill_property.teji_maxhp + (hero_property.init_maxhp + hero_property.add_maxhp + hero_property.grow_perlv_maxhp * hero_property.level)*(equip_set_property.teji_scale_maxhp+1000)/1000)*(1000 + weapon_skill_property.teji_scale_maxhp + relation_property.relationmaxhpratio) / 1000 * star_enhance + equip_property.maxhp + weapon_skill_property.teji_maxhp + weapon_property.maxhp + equip_set_property.teji_maxhp;
	role_armor = ( weapon_skill_property.teji_armor + (hero_property.init_armor + hero_property.add_armor + hero_property.grow_perlv_armor * hero_property.level)*(equip_set_property.teji_scale_armor+1000)/1000)*(1000 + weapon_skill_property.teji_scale_armor + relation_property.relationarmorratio) / 1000 * star_enhance + equip_property.armor + weapon_skill_property.teji_armor + weapon_property.def + equip_set_property.teji_armor;
	base_atk = role_atk * ( 1 + hero_scale_atk/1000 ) + hero_atk;
	base_maxhp = role_maxhp * ( 1 + hero_scale_maxhp/1000 ) + hero_maxhp;
	base_armor = role_armor * ( 1 + hero_scale_armor/1000 ) + hero_armor;
	
	--计算战斗力
	local zhanli = math.ceil(weapon_skill_property.teji_zhanli + atkratio * base_atk + maxhpratio * base_maxhp + armorratio * base_armor);
	return zhanli,base_maxhp
	


end
