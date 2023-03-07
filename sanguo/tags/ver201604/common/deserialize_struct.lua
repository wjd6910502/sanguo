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
	elseif __type__ == "BattleInfo" then
		is_idx, item.battle_id = Deserialize(is, is_idx, "number")
		is_idx, item.cur_pos = Deserialize(is, is_idx, "number")
		is_idx, item.state = Deserialize(is, is_idx, "number")
		is_idx, count = Deserialize(is, is_idx, "number")
		item.hero_info = {}
		for i = 1, count do
			is_idx, item.hero_info[i] = DeserializeStruct(is, is_idx, "BattleHeroInfo")
		end
		is_idx, count = Deserialize(is, is_idx, "number")
		item.cur_hero = {}
		for i = 1, count do
			is_idx, item.cur_hero[i] = Deserialize(is, is_idx, "number")
		end
		is_idx, count = Deserialize(is, is_idx, "number")
		item.cur_horse_hero = {}
		for i = 1, count do
			is_idx, item.cur_horse_hero[i] = DeserializeStruct(is, is_idx, "BattleHorseHero")
		end
		is_idx, count = Deserialize(is, is_idx, "number")
		item.position_data = {}
		for i = 1, count do
			is_idx, item.position_data[i] = DeserializeStruct(is, is_idx, "BattlePositionInfo")
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
	elseif __type__ == "RoleHero" then
		is_idx, item.tid = Deserialize(is, is_idx, "number")
		is_idx, item.level = Deserialize(is, is_idx, "number")
		is_idx, item.order = Deserialize(is, is_idx, "number")
		is_idx, item.exp = Deserialize(is, is_idx, "number")
		is_idx, item.star = Deserialize(is, is_idx, "number")
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
		is_idx, item.hero_pvp_info = DeserializeStruct(is, is_idx, "HeroPvpInfoData")
		is_idx, count = Deserialize(is, is_idx, "number")
		item.select_skill = {}
		for i = 1, count do
			is_idx, item.select_skill[i] = Deserialize(is, is_idx, "number")
		end
	elseif __type__ == "MysteryShopItem" then
		is_idx, item.item_id = Deserialize(is, is_idx, "number")
		is_idx, item.buy_count = Deserialize(is, is_idx, "number")
		is_idx, item.max_count = Deserialize(is, is_idx, "number")
	elseif __type__ == "AnotherRoleData" then
		is_idx, item.brief = DeserializeStruct(is, is_idx, "RoleBrief")
	elseif __type__ == "RoleCurrentTask" then
		is_idx, item.id = Deserialize(is, is_idx, "number")
		is_idx, count = Deserialize(is, is_idx, "number")
		item.condition = {}
		for i = 1, count do
			is_idx, item.condition[i] = DeserializeStruct(is, is_idx, "RoleTaskCondition")
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
	elseif __type__ == "BattleNPCInfo" then
		is_idx, item.id = Deserialize(is, is_idx, "number")
		is_idx, item.camp = Deserialize(is, is_idx, "number")
		is_idx, item.armyid = Deserialize(is, is_idx, "number")
		is_idx, item.alive = Deserialize(is, is_idx, "number")
		is_idx, item.event_flag = Deserialize(is, is_idx, "number")
		is_idx, item.event_id = Deserialize(is, is_idx, "number")
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
	elseif __type__ == "HeroSoul" then
		is_idx, item.soul_id = Deserialize(is, is_idx, "number")
		is_idx, item.soul_num = Deserialize(is, is_idx, "number")
	elseif __type__ == "RepInfo" then
		is_idx, item.rep_id = Deserialize(is, is_idx, "number")
		is_idx, item.rep_num = Deserialize(is, is_idx, "number")
	elseif __type__ == "BattlePositionInfo" then
		is_idx, item.id = Deserialize(is, is_idx, "number")
		is_idx, item.position = Deserialize(is, is_idx, "number")
		is_idx, item.flag = Deserialize(is, is_idx, "number")
		is_idx, item.event_flag = Deserialize(is, is_idx, "number")
		is_idx, item.event_id = Deserialize(is, is_idx, "number")
		is_idx, count = Deserialize(is, is_idx, "number")
		item.npc_info = {}
		for i = 1, count do
			is_idx, item.npc_info[i] = DeserializeStruct(is, is_idx, "BattleNPCInfo")
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
		is_idx, count = Deserialize(is, is_idx, "number")
		item.pvp_video = {}
		for i = 1, count do
			is_idx, item.pvp_video[i] = DeserializeStruct(is, is_idx, "PvpVideoData")
		end
		is_idx, count = Deserialize(is, is_idx, "number")
		item.black_list = {}
		for i = 1, count do
			is_idx, item.black_list[i] = DeserializeStruct(is, is_idx, "RoleBase")
		end
		is_idx, count = Deserialize(is, is_idx, "number")
		item.mail_list = {}
		for i = 1, count do
			is_idx, item.mail_list[i] = DeserializeStruct(is, is_idx, "MailInfo")
		end
		is_idx, count = Deserialize(is, is_idx, "number")
		item.rep_list = {}
		for i = 1, count do
			is_idx, item.rep_list[i] = DeserializeStruct(is, is_idx, "RepInfo")
		end
		is_idx, count = Deserialize(is, is_idx, "number")
		item.mysteryshop_list = {}
		for i = 1, count do
			is_idx, item.mysteryshop_list[i] = DeserializeStruct(is, is_idx, "MysteryShopInfo")
		end
		is_idx, count = Deserialize(is, is_idx, "number")
		item.instancehero_info = {}
		for i = 1, count do
			is_idx, item.instancehero_info[i] = DeserializeStruct(is, is_idx, "InstanceHero")
		end
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
	elseif __type__ == "RolePVPHero" then
		is_idx, item.tid = Deserialize(is, is_idx, "number")
		is_idx, item.level = Deserialize(is, is_idx, "number")
		is_idx, item.order = Deserialize(is, is_idx, "number")
		is_idx, item.star = Deserialize(is, is_idx, "number")
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
		is_idx, count = Deserialize(is, is_idx, "number")
		item.select_skill = {}
		for i = 1, count do
			is_idx, item.select_skill[i] = Deserialize(is, is_idx, "number")
		end
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
	elseif __type__ == "InstanceHero" then
		is_idx, item.typ = Deserialize(is, is_idx, "number")
		is_idx, item.battle_id = Deserialize(is, is_idx, "number")
		is_idx, item.heroinfo = DeserializeStruct(is, is_idx, "RoleLastHero")
		is_idx, item.horse = Deserialize(is, is_idx, "number")
	elseif __type__ == "MafiaBrief" then
		is_idx, item.id = Deserialize(is, is_idx, "string")
		is_idx, item.name = Deserialize(is, is_idx, "string")
		is_idx, item.flag = Deserialize(is, is_idx, "number")
		is_idx, item.announce = Deserialize(is, is_idx, "string")
		is_idx, item.level = Deserialize(is, is_idx, "number")
		is_idx, item.activity = Deserialize(is, is_idx, "number")
		is_idx, item.boss_id = Deserialize(is, is_idx, "string")
		is_idx, item.boss_name = Deserialize(is, is_idx, "string")
	elseif __type__ == "MailInfo" then
		is_idx, item.mail_id = Deserialize(is, is_idx, "number")
		is_idx, item.msg_id = Deserialize(is, is_idx, "number")
		is_idx, item.subject = Deserialize(is, is_idx, "string")
		is_idx, item.context = Deserialize(is, is_idx, "string")
		is_idx, item.time = Deserialize(is, is_idx, "number")
		is_idx, item.from_id = Deserialize(is, is_idx, "string")
		is_idx, item.from_name = Deserialize(is, is_idx, "string")
		is_idx, count = Deserialize(is, is_idx, "number")
		item.item = {}
		for i = 1, count do
			is_idx, item.item[i] = DeserializeStruct(is, is_idx, "Item")
		end
		is_idx, count = Deserialize(is, is_idx, "number")
		item.mail_arg = {}
		for i = 1, count do
			is_idx, item.mail_arg[i] = Deserialize(is, is_idx, "string")
		end
		is_idx, item.read_flag = Deserialize(is, is_idx, "number")
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
	elseif __type__ == "HeroPvpInfoData" then
		is_idx, item.id = Deserialize(is, is_idx, "number")
		is_idx, item.join_count = Deserialize(is, is_idx, "number")
		is_idx, item.win_count = Deserialize(is, is_idx, "number")
	elseif __type__ == "Item" then
		is_idx, item.tid = Deserialize(is, is_idx, "number")
		is_idx, item.count = Deserialize(is, is_idx, "number")
	elseif __type__ == "LotteryRewardInfo" then
		is_idx, item.id = Deserialize(is, is_idx, "number")
		is_idx, item.num = Deserialize(is, is_idx, "number")
		is_idx, item.firstget = Deserialize(is, is_idx, "number")
		is_idx, item.bproorhero = Deserialize(is, is_idx, "number")
	elseif __type__ == "MysteryShopInfo" then
		is_idx, item.shop_id = Deserialize(is, is_idx, "number")
		is_idx, count = Deserialize(is, is_idx, "number")
		item.shop_item = {}
		for i = 1, count do
			is_idx, item.shop_item[i] = DeserializeStruct(is, is_idx, "MysteryShopItem")
		end
	elseif __type__ == "PvpOperation" then
		is_idx, item.tick = Deserialize(is, is_idx, "number")
		is_idx, item.first_operation = Deserialize(is, is_idx, "string")
		is_idx, item.second_operation = Deserialize(is, is_idx, "string")
	elseif __type__ == "HeroSkill" then
		is_idx, item.skill_id = Deserialize(is, is_idx, "number")
		is_idx, item.skill_level = Deserialize(is, is_idx, "number")
	elseif __type__ == "BattleHeroInfo" then
		is_idx, item.hero_id = Deserialize(is, is_idx, "number")
		is_idx, item.hp = Deserialize(is, is_idx, "number")
	elseif __type__ == "ChatInfo" then
		is_idx, item.src = DeserializeStruct(is, is_idx, "RoleBrief")
		is_idx, item.dest = DeserializeStruct(is, is_idx, "RoleBrief")
		is_idx, item.content = Deserialize(is, is_idx, "string")
		is_idx, item.time = Deserialize(is, is_idx, "number")
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
	elseif __type__ == "PvpVideoData" then
		is_idx, item.video = Deserialize(is, is_idx, "string")
		is_idx, item.player1 = DeserializeStruct(is, is_idx, "RoleClientPVPInfo")
		is_idx, item.player2 = DeserializeStruct(is, is_idx, "RoleClientPVPInfo")
		is_idx, item.win_flag = Deserialize(is, is_idx, "number")
		is_idx, item.time = Deserialize(is, is_idx, "number")
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
	elseif __type__ == "BattleHorseHero" then
		is_idx, count = Deserialize(is, is_idx, "number")
		item.hero = {}
		for i = 1, count do
			is_idx, item.hero[i] = Deserialize(is, is_idx, "number")
		end
		is_idx, item.horse = Deserialize(is, is_idx, "number")
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
		is_idx, item.join_count = Deserialize(is, is_idx, "number")
		is_idx, item.win_count = Deserialize(is, is_idx, "number")
		is_idx, item.end_time = Deserialize(is, is_idx, "number")
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
		is_idx, item.heroexp = Deserialize(is, is_idx, "number")
		is_idx, count = Deserialize(is, is_idx, "number")
		item.item = {}
		for i = 1, count do
			is_idx, item.item[i] = DeserializeStruct(is, is_idx, "DropItem")
		end
	elseif __type__ == "PvpVideo" then
		is_idx, count = Deserialize(is, is_idx, "number")
		item.video = {}
		for i = 1, count do
			is_idx, item.video[i] = DeserializeStruct(is, is_idx, "PvpOperation")
		end

	end

	return is_idx, item
end

