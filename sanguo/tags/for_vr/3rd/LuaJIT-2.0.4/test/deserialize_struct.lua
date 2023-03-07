--DONT CHANGE ME!

function DeserializeStruct(is, is_idx, __type__)
	local item = {}

	if false then
		--never to here
	elseif __type__ == "Instance_Star_Condition" then
		is_idx, item.tid = Deserialize(is, is_idx, "number")
		is_idx, item.flag = Deserialize(is, is_idx, "number")
	elseif __type__ == "TopListData" then
		is_idx, item.id = Deserialize(is, is_idx, "string")
		is_idx, item.name = Deserialize(is, is_idx, "string")
		is_idx, item.photo = Deserialize(is, is_idx, "number")
		is_idx, item.data = Deserialize(is, is_idx, "string")
	elseif __type__ == "RoleHeroHall" then
		is_idx, count = Deserialize(is, is_idx, "number")
		item.heros = {}
		for i = 1, count do
			is_idx, item.heros[i] = DeserializeStruct(is, is_idx, "RoleHero")
		end
	elseif __type__ == "PVEOperation" then
		is_idx, item.client_tick = Deserialize(is, is_idx, "number")
		is_idx, item.op = Deserialize(is, is_idx, "string")
	elseif __type__ == "RoleBrief" then
		is_idx, item.id = Deserialize(is, is_idx, "string")
		is_idx, item.name = Deserialize(is, is_idx, "string")
		is_idx, item.photo = Deserialize(is, is_idx, "number")
		is_idx, item.level = Deserialize(is, is_idx, "number")
		is_idx, item.mafia_id = Deserialize(is, is_idx, "string")
		is_idx, item.mafia_name = Deserialize(is, is_idx, "string")
	elseif __type__ == "RoleUserDefineData" then
		is_idx, item.id = Deserialize(is, is_idx, "number")
		is_idx, item.value_define = Deserialize(is, is_idx, "string")
	elseif __type__ == "RoleHero" then
		is_idx, item.tid = Deserialize(is, is_idx, "number")
		is_idx, item.level = Deserialize(is, is_idx, "number")
		is_idx, item.order = Deserialize(is, is_idx, "number")
		is_idx, item.exp = Deserialize(is, is_idx, "number")
		is_idx, count = Deserialize(is, is_idx, "number")
		item.skill = {}
		for i = 1, count do
			is_idx, item.skill[i] = DeserializeStruct(is, is_idx, "HeroSkill")
		end
		is_idx, count = Deserialize(is, is_idx, "number")
		item.common_skill = {}
		for i = 1, count do
			is_idx, item.common_skill[i] = DeserializeStruct(is, is_idx, "HeroSkill")
		end
	elseif __type__ == "RolePVPInfo" then
		is_idx, item.brief = DeserializeStruct(is, is_idx, "RoleBrief")
		is_idx, count = Deserialize(is, is_idx, "number")
		item.hero_hall = {}
		for i = 1, count do
			is_idx, item.hero_hall[i] = DeserializeStruct(is, is_idx, "RolePVPHero")
		end
		is_idx, item.p2p_magic = Deserialize(is, is_idx, "number")
		is_idx, item.p2p_net_typ = Deserialize(is, is_idx, "number")
		is_idx, item.p2p_public_ip = Deserialize(is, is_idx, "string")
		is_idx, item.p2p_public_port = Deserialize(is, is_idx, "number")
		is_idx, item.p2p_local_ip = Deserialize(is, is_idx, "string")
		is_idx, item.p2p_local_port = Deserialize(is, is_idx, "number")
		is_idx, item.pvp_score = Deserialize(is, is_idx, "number")
	elseif __type__ == "RoleCurrentTask" then
		is_idx, item.id = Deserialize(is, is_idx, "number")
		is_idx, count = Deserialize(is, is_idx, "number")
		item.condition = {}
		for i = 1, count do
			is_idx, item.condition[i] = DeserializeStruct(is, is_idx, "RoleTaskCondition")
		end
	elseif __type__ == "RoleInfo" then
		is_idx, item.base = DeserializeStruct(is, is_idx, "RoleBase")
		is_idx, item.status = DeserializeStruct(is, is_idx, "RoleStatus")
		is_idx, item.hero_hall = DeserializeStruct(is, is_idx, "RoleHeroHall")
		is_idx, item.backpack = DeserializeStruct(is, is_idx, "RoleBackPack")
		is_idx, item.mafia = DeserializeStruct(is, is_idx, "RoleMafia")
		is_idx, item.task = DeserializeStruct(is, is_idx, "RoleTask")
		is_idx, item.user_define = DeserializeStruct(is, is_idx, "RoleUserDefine")
		is_idx, item.horse_hall = DeserializeStruct(is, is_idx, "RoleHorseHall")
		is_idx, item.last_hero = DeserializeStruct(is, is_idx, "RoleLastHero")
		is_idx, item.pvp_last_hero = DeserializeStruct(is, is_idx, "RoleLastHero")
		is_idx, item.pvp_info = DeserializeStruct(is, is_idx, "Role_PvpInfo")
	elseif __type__ == "RoleBackPack" then
		is_idx, item.capacity = Deserialize(is, is_idx, "number")
		is_idx, count = Deserialize(is, is_idx, "number")
		item.items = {}
		for i = 1, count do
			is_idx, item.items[i] = DeserializeStruct(is, is_idx, "Item")
		end
	elseif __type__ == "RoleTask" then
		is_idx, count = Deserialize(is, is_idx, "number")
		item.finish = {}
		for i = 1, count do
			is_idx, item.finish[i] = Deserialize(is, is_idx, "number")
		end
		is_idx, count = Deserialize(is, is_idx, "number")
		item.current = {}
		for i = 1, count do
			is_idx, item.current[i] = DeserializeStruct(is, is_idx, "RoleCurrentTask")
		end
	elseif __type__ == "RoleStatus" then
		is_idx, item.level = Deserialize(is, is_idx, "number")
		is_idx, item.exp = Deserialize(is, is_idx, "string")
		is_idx, item.vp = Deserialize(is, is_idx, "number")
		is_idx, count = Deserialize(is, is_idx, "number")
		item.instances = {}
		for i = 1, count do
			is_idx, item.instances[i] = DeserializeStruct(is, is_idx, "RoleInstance")
		end
		is_idx, item.money = Deserialize(is, is_idx, "number")
		is_idx, item.yuanbao = Deserialize(is, is_idx, "number")
		is_idx, count = Deserialize(is, is_idx, "number")
		item.common_use_limit = {}
		for i = 1, count do
			is_idx, item.common_use_limit[i] = DeserializeStruct(is, is_idx, "CommonUseLimit")
		end
		is_idx, item.chongzhi = Deserialize(is, is_idx, "number")
		is_idx, item.hero_skill_point = Deserialize(is, is_idx, "number")
	elseif __type__ == "RoleClientPVPInfo" then
		is_idx, item.brief = DeserializeStruct(is, is_idx, "RoleBrief")
		is_idx, count = Deserialize(is, is_idx, "number")
		item.hero_hall = {}
		for i = 1, count do
			is_idx, item.hero_hall[i] = DeserializeStruct(is, is_idx, "RolePVPHero")
		end
		is_idx, item.pvp_score = Deserialize(is, is_idx, "number")
	elseif __type__ == "RoleBase" then
		is_idx, item.id = Deserialize(is, is_idx, "string")
		is_idx, item.name = Deserialize(is, is_idx, "string")
		is_idx, item.photo = Deserialize(is, is_idx, "number")
	elseif __type__ == "Friend" then
		is_idx, item.id = Deserialize(is, is_idx, "string")
		is_idx, item.name = Deserialize(is, is_idx, "string")
		is_idx, item.photo = Deserialize(is, is_idx, "number")
		is_idx, item.level = Deserialize(is, is_idx, "number")
	elseif __type__ == "InstanceInfo" then
		is_idx, item.id = Deserialize(is, is_idx, "number")
		is_idx, item.star = Deserialize(is, is_idx, "number")
	elseif __type__ == "RoleHorseHall" then
		is_idx, count = Deserialize(is, is_idx, "number")
		item.horses = {}
		for i = 1, count do
			is_idx, item.horses[i] = DeserializeStruct(is, is_idx, "RoleHorse")
		end
	elseif __type__ == "RoleHorse" then
		is_idx, item.tid = Deserialize(is, is_idx, "number")
	elseif __type__ == "MafiaBrief" then
		is_idx, item.id = Deserialize(is, is_idx, "string")
		is_idx, item.name = Deserialize(is, is_idx, "string")
		is_idx, item.flag = Deserialize(is, is_idx, "number")
		is_idx, item.announce = Deserialize(is, is_idx, "string")
		is_idx, item.level = Deserialize(is, is_idx, "number")
		is_idx, item.activity = Deserialize(is, is_idx, "number")
		is_idx, item.boss_id = Deserialize(is, is_idx, "string")
		is_idx, item.boss_name = Deserialize(is, is_idx, "string")
	elseif __type__ == "RolePVPHero" then
		is_idx, item.tid = Deserialize(is, is_idx, "number")
		is_idx, item.level = Deserialize(is, is_idx, "number")
		is_idx, item.order = Deserialize(is, is_idx, "number")
		is_idx, count = Deserialize(is, is_idx, "number")
		item.skill = {}
		for i = 1, count do
			is_idx, item.skill[i] = DeserializeStruct(is, is_idx, "HeroSkill")
		end
		is_idx, count = Deserialize(is, is_idx, "number")
		item.common_skill = {}
		for i = 1, count do
			is_idx, item.common_skill[i] = DeserializeStruct(is, is_idx, "HeroSkill")
		end
	elseif __type__ == "PVPFighter" then
		is_idx, item.id = Deserialize(is, is_idx, "string")
		is_idx, count = Deserialize(is, is_idx, "number")
		item.ops = {}
		for i = 1, count do
			is_idx, item.ops[i] = Deserialize(is, is_idx, "number")
		end
	elseif __type__ == "HeroComment" then
		is_idx, item.role_id = Deserialize(is, is_idx, "string")
		is_idx, item.role_name = Deserialize(is, is_idx, "string")
		is_idx, item.comment = Deserialize(is, is_idx, "string")
		is_idx, item.agree_count = Deserialize(is, is_idx, "number")
		is_idx, item.agree_flag = Deserialize(is, is_idx, "number")
		is_idx, item.time_stamp = Deserialize(is, is_idx, "number")
	elseif __type__ == "Item" then
		is_idx, item.tid = Deserialize(is, is_idx, "number")
		is_idx, item.count = Deserialize(is, is_idx, "number")
	elseif __type__ == "HeroSkill" then
		is_idx, item.skill_id = Deserialize(is, is_idx, "number")
		is_idx, item.skill_level = Deserialize(is, is_idx, "number")
	elseif __type__ == "RoleTaskCondition" then
		is_idx, item.current_num = Deserialize(is, is_idx, "number")
		is_idx, item.max_num = Deserialize(is, is_idx, "number")
	elseif __type__ == "RoleLastHero" then
		is_idx, count = Deserialize(is, is_idx, "number")
		item.info = {}
		for i = 1, count do
			is_idx, item.info[i] = Deserialize(is, is_idx, "number")
		end
	elseif __type__ == "CommonUseLimit" then
		is_idx, item.tid = Deserialize(is, is_idx, "number")
		is_idx, item.count = Deserialize(is, is_idx, "number")
	elseif __type__ == "DropItem" then
		is_idx, item.id = Deserialize(is, is_idx, "number")
		is_idx, item.count = Deserialize(is, is_idx, "number")
	elseif __type__ == "RoleInstance" then
		is_idx, item.tid = Deserialize(is, is_idx, "number")
		is_idx, item.score = Deserialize(is, is_idx, "number")
	elseif __type__ == "RoleUserDefine" then
		is_idx, count = Deserialize(is, is_idx, "number")
		item.role_define = {}
		for i = 1, count do
			is_idx, item.role_define[i] = DeserializeStruct(is, is_idx, "RoleUserDefineData")
		end
	elseif __type__ == "RoleMafia" then
		is_idx, item.id = Deserialize(is, is_idx, "string")
		is_idx, item.name = Deserialize(is, is_idx, "string")
	elseif __type__ == "MafiaMember" then
		is_idx, item.id = Deserialize(is, is_idx, "string")
		is_idx, item.name = Deserialize(is, is_idx, "string")
		is_idx, item.photo = Deserialize(is, is_idx, "number")
		is_idx, item.level = Deserialize(is, is_idx, "number")
		is_idx, item.activity = Deserialize(is, is_idx, "number")
	elseif __type__ == "Condition" then
		is_idx, item.current = Deserialize(is, is_idx, "number")
		is_idx, item.max = Deserialize(is, is_idx, "number")
	elseif __type__ == "Chat" then
		is_idx, item.src_id = Deserialize(is, is_idx, "string")
		is_idx, item.src_name = Deserialize(is, is_idx, "string")
		is_idx, item.time = Deserialize(is, is_idx, "number")
		is_idx, item.content = Deserialize(is, is_idx, "string")
	elseif __type__ == "Role_PvpInfo" then
		is_idx, item.star = Deserialize(is, is_idx, "number")
	elseif __type__ == "Mafia" then
		is_idx, item.id = Deserialize(is, is_idx, "string")
		is_idx, item.name = Deserialize(is, is_idx, "string")
		is_idx, item.flag = Deserialize(is, is_idx, "number")
		is_idx, item.announce = Deserialize(is, is_idx, "string")
		is_idx, item.level = Deserialize(is, is_idx, "number")
		is_idx, item.activity = Deserialize(is, is_idx, "number")
		is_idx, item.boss_id = Deserialize(is, is_idx, "string")
		is_idx, item.boss_name = Deserialize(is, is_idx, "string")
		is_idx, count = Deserialize(is, is_idx, "number")
		item.members = {}
		for i = 1, count do
			is_idx, item.members[i] = DeserializeStruct(is, is_idx, "MafiaMember")
		end
	elseif __type__ == "SweepInstanceData" then
		is_idx, item.exp = Deserialize(is, is_idx, "number")
		is_idx, item.money = Deserialize(is, is_idx, "number")
		is_idx, item.heroexp = Deserialize(is, is_idx, "number")
		is_idx, count = Deserialize(is, is_idx, "number")
		item.item = {}
		for i = 1, count do
			is_idx, item.item[i] = DeserializeStruct(is, is_idx, "DropItem")
		end

	end

	return is_idx, item
end

