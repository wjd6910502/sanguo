--DONT CHANGE ME!

function __SerializeStruct(os, __type__, obj)
	if obj==nil then obj={} end

	if false then
		--never to here
	elseif __type__ == "RoleHeroHall" then
		if obj.heros==nil then
			Serialize(os, 0)
		else
			Serialize(os, #obj.heros)
			for i = 1, #obj.heros do
				__SerializeStruct(os, "RoleHero", obj.heros[i])
			end
		end
	elseif __type__ == "MaShuFightFriendInfo" then
		Serialize(os, obj.role_id)
		Serialize(os, obj.name)
		Serialize(os, obj.zhanli)
	elseif __type__ == "RolePVPInfo" then
		__SerializeStruct(os, "RoleBrief", obj.brief)
		if obj.hero_hall==nil then
			Serialize(os, 0)
		else
			Serialize(os, #obj.hero_hall)
			for i = 1, #obj.hero_hall do
				__SerializeStruct(os, "RolePVPHero", obj.hero_hall[i])
			end
		end
		Serialize(os, obj.p2p_magic)
		Serialize(os, obj.p2p_net_typ)
		Serialize(os, obj.p2p_public_ip)
		Serialize(os, obj.p2p_public_port)
		Serialize(os, obj.p2p_local_ip)
		Serialize(os, obj.p2p_local_port)
		Serialize(os, obj.pvp_score)
	elseif __type__ == "AnotherRoleData" then
		__SerializeStruct(os, "RoleBrief", obj.brief)
	elseif __type__ == "PVEOperation" then
		Serialize(os, obj.client_tick)
		Serialize(os, obj.op)
	elseif __type__ == "ShiLianHeroInfo" then
		Serialize(os, obj.id)
		Serialize(os, obj.hp)
		Serialize(os, obj.anger)
	elseif __type__ == "BattleInfo" then
		Serialize(os, obj.battle_id)
		Serialize(os, obj.cur_pos)
		Serialize(os, obj.state)
		if obj.hero_info==nil then
			Serialize(os, 0)
		else
			Serialize(os, #obj.hero_info)
			for i = 1, #obj.hero_info do
				__SerializeStruct(os, "BattleHeroInfo", obj.hero_info[i])
			end
		end
		if obj.cur_hero==nil then
			Serialize(os, 0)
		else
			Serialize(os, #obj.cur_hero)
			for i = 1, #obj.cur_hero do
				Serialize(os, obj.cur_hero[i])
			end
		end
		if obj.cur_horse_hero==nil then
			Serialize(os, 0)
		else
			Serialize(os, #obj.cur_horse_hero)
			for i = 1, #obj.cur_horse_hero do
				__SerializeStruct(os, "BattleHorseHero", obj.cur_horse_hero[i])
			end
		end
		if obj.position_data==nil then
			Serialize(os, 0)
		else
			Serialize(os, #obj.position_data)
			for i = 1, #obj.position_data do
				__SerializeStruct(os, "BattlePositionInfo", obj.position_data[i])
			end
		end
		Serialize(os, obj.round_num)
		Serialize(os, obj.round_flag)
		Serialize(os, obj.round_state)
		Serialize(os, obj.cur_morale)
	elseif __type__ == "RoleHorseHall" then
		if obj.horses==nil then
			Serialize(os, 0)
		else
			Serialize(os, #obj.horses)
			for i = 1, #obj.horses do
				__SerializeStruct(os, "RoleHorse", obj.horses[i])
			end
		end
	elseif __type__ == "InstanceHero" then
		Serialize(os, obj.typ)
		Serialize(os, obj.battle_id)
		__SerializeStruct(os, "RoleLastHero", obj.heroinfo)
		Serialize(os, obj.horse)
	elseif __type__ == "HeroComment" then
		Serialize(os, obj.role_id)
		Serialize(os, obj.role_name)
		Serialize(os, obj.comment)
		Serialize(os, obj.agree_count)
		Serialize(os, obj.agree_flag)
		Serialize(os, obj.time_stamp)
	elseif __type__ == "MysteryShopInfo" then
		Serialize(os, obj.shop_id)
		if obj.shop_item==nil then
			Serialize(os, 0)
		else
			Serialize(os, #obj.shop_item)
			for i = 1, #obj.shop_item do
				__SerializeStruct(os, "MysteryShopItem", obj.shop_item[i])
			end
		end
	elseif __type__ == "HeroSkill" then
		Serialize(os, obj.skill_id)
		Serialize(os, obj.skill_level)
	elseif __type__ == "ChatInfo" then
		__SerializeStruct(os, "RoleBrief", obj.src)
		__SerializeStruct(os, "RoleBrief", obj.dest)
		Serialize(os, obj.content)
		Serialize(os, obj.sp_content)
		Serialize(os, obj.time)
	elseif __type__ == "RoleLastHero" then
		if obj.info==nil then
			Serialize(os, 0)
		else
			Serialize(os, #obj.info)
			for i = 1, #obj.info do
				Serialize(os, obj.info[i])
			end
		end
	elseif __type__ == "CommonUseLimit" then
		Serialize(os, obj.tid)
		Serialize(os, obj.count)
	elseif __type__ == "RoleMafia" then
		Serialize(os, obj.id)
		Serialize(os, obj.name)
	elseif __type__ == "RefinableData" then
		Serialize(os, obj.typ)
		Serialize(os, obj.data)
	elseif __type__ == "BattleHorseHero" then
		if obj.hero==nil then
			Serialize(os, 0)
		else
			Serialize(os, #obj.hero)
			for i = 1, #obj.hero do
				Serialize(os, obj.hero[i])
			end
		end
		Serialize(os, obj.horse)
	elseif __type__ == "DifficultyInfo" then
		Serialize(os, obj.difficulty)
		Serialize(os, obj.camp)
	elseif __type__ == "WeaponSkill" then
		Serialize(os, obj.skill_id)
		Serialize(os, obj.skill_level)
	elseif __type__ == "OpponentInfo" then
		Serialize(os, obj.id)
		Serialize(os, obj.alive)
		Serialize(os, obj.level)
		Serialize(os, obj.stage)
		Serialize(os, obj.hp)
		Serialize(os, obj.anger)
		Serialize(os, obj.rewardflag)
	elseif __type__ == "PveArenaFighterInfo" then
		Serialize(os, obj.name)
		Serialize(os, obj.id)
		Serialize(os, obj.level)
		Serialize(os, obj.rank)
		Serialize(os, obj.score)
		Serialize(os, obj.hero_score)
		Serialize(os, obj.mafia_name)
		__SerializeStruct(os, "RolePveArenaInfo", obj.hero_info)
	elseif __type__ == "SweepInstanceData" then
		Serialize(os, obj.exp)
		Serialize(os, obj.heroexp)
		if obj.item==nil then
			Serialize(os, 0)
		else
			Serialize(os, #obj.item)
			for i = 1, #obj.item do
				__SerializeStruct(os, "DropItem", obj.item[i])
			end
		end
	elseif __type__ == "MysteryShopItem" then
		Serialize(os, obj.item_id)
		Serialize(os, obj.buy_count)
		Serialize(os, obj.max_count)
	elseif __type__ == "RoleCurrentTask" then
		Serialize(os, obj.id)
		if obj.condition==nil then
			Serialize(os, 0)
		else
			Serialize(os, #obj.condition)
			for i = 1, #obj.condition do
				__SerializeStruct(os, "RoleTaskCondition", obj.condition[i])
			end
		end
	elseif __type__ == "RoleInfo" then
		__SerializeStruct(os, "RoleBase", obj.base)
		__SerializeStruct(os, "RoleStatus", obj.status)
		__SerializeStruct(os, "RoleHeroHall", obj.hero_hall)
		__SerializeStruct(os, "RoleBackPack", obj.backpack)
		__SerializeStruct(os, "RoleMafia", obj.mafia)
		__SerializeStruct(os, "RoleTask", obj.task)
		__SerializeStruct(os, "RoleUserDefine", obj.user_define)
		__SerializeStruct(os, "RoleHorseHall", obj.horse_hall)
		__SerializeStruct(os, "RoleLastHero", obj.last_hero)
		__SerializeStruct(os, "RoleLastHero", obj.pvp_last_hero)
		__SerializeStruct(os, "Role_PvpInfo", obj.pvp_info)
		if obj.pvp_video==nil then
			Serialize(os, 0)
		else
			Serialize(os, #obj.pvp_video)
			for i = 1, #obj.pvp_video do
				__SerializeStruct(os, "PvpVideoData", obj.pvp_video[i])
			end
		end
		if obj.black_list==nil then
			Serialize(os, 0)
		else
			Serialize(os, #obj.black_list)
			for i = 1, #obj.black_list do
				__SerializeStruct(os, "RoleBase", obj.black_list[i])
			end
		end
		if obj.mail_list==nil then
			Serialize(os, 0)
		else
			Serialize(os, #obj.mail_list)
			for i = 1, #obj.mail_list do
				__SerializeStruct(os, "MailInfo", obj.mail_list[i])
			end
		end
		if obj.rep_list==nil then
			Serialize(os, 0)
		else
			Serialize(os, #obj.rep_list)
			for i = 1, #obj.rep_list do
				__SerializeStruct(os, "RepInfo", obj.rep_list[i])
			end
		end
		if obj.mysteryshop_list==nil then
			Serialize(os, 0)
		else
			Serialize(os, #obj.mysteryshop_list)
			for i = 1, #obj.mysteryshop_list do
				__SerializeStruct(os, "MysteryShopInfo", obj.mysteryshop_list[i])
			end
		end
		if obj.instancehero_info==nil then
			Serialize(os, 0)
		else
			Serialize(os, #obj.instancehero_info)
			for i = 1, #obj.instancehero_info do
				__SerializeStruct(os, "InstanceHero", obj.instancehero_info[i])
			end
		end
		__SerializeStruct(os, "PveArenaInfo", obj.pve_arena)
	elseif __type__ == "Friend" then
		Serialize(os, obj.id)
		Serialize(os, obj.name)
		Serialize(os, obj.photo)
		Serialize(os, obj.level)
		Serialize(os, obj.zhanli)
		Serialize(os, obj.faction)
		Serialize(os, obj.online)
		Serialize(os, obj.mashu_score)
	elseif __type__ == "RepInfo" then
		Serialize(os, obj.rep_id)
		Serialize(os, obj.rep_num)
	elseif __type__ == "LegionJunXueGuanData" then
		Serialize(os, obj.id)
		Serialize(os, obj.level)
		if obj.learned==nil then
			Serialize(os, 0)
		else
			Serialize(os, #obj.learned)
			for i = 1, #obj.learned do
				Serialize(os, obj.learned[i])
			end
		end
	elseif __type__ == "WeaponInfo" then
		Serialize(os, obj.tid)
		Serialize(os, obj.level)
		Serialize(os, obj.star)
		Serialize(os, obj.quality)
		Serialize(os, obj.prop)
		Serialize(os, obj.attack)
		Serialize(os, obj.strength)
		Serialize(os, obj.level_up)
		Serialize(os, obj.weapon_skill)
		Serialize(os, obj.strength_prob)
		if obj.skill_pro==nil then
			Serialize(os, 0)
		else
			Serialize(os, #obj.skill_pro)
			for i = 1, #obj.skill_pro do
				__SerializeStruct(os, "WeaponSkill", obj.skill_pro[i])
			end
		end
	elseif __type__ == "MaShuFriendInfo" then
		Serialize(os, obj.role_id)
		Serialize(os, obj.count)
	elseif __type__ == "BattleDelArmyInfo" then
		Serialize(os, obj.id)
		Serialize(os, obj.pos)
		Serialize(os, obj.npc_id)
		Serialize(os, obj.army_id)
	elseif __type__ == "RoleHorse" then
		Serialize(os, obj.tid)
	elseif __type__ == "RolePVPHero" then
		Serialize(os, obj.tid)
		Serialize(os, obj.level)
		Serialize(os, obj.order)
		Serialize(os, obj.star)
		if obj.skill==nil then
			Serialize(os, 0)
		else
			Serialize(os, #obj.skill)
			for i = 1, #obj.skill do
				__SerializeStruct(os, "HeroSkill", obj.skill[i])
			end
		end
		if obj.common_skill==nil then
			Serialize(os, 0)
		else
			Serialize(os, #obj.common_skill)
			for i = 1, #obj.common_skill do
				__SerializeStruct(os, "HeroSkill", obj.common_skill[i])
			end
		end
		if obj.select_skill==nil then
			Serialize(os, 0)
		else
			Serialize(os, #obj.select_skill)
			for i = 1, #obj.select_skill do
				Serialize(os, obj.select_skill[i])
			end
		end
		if obj.relations==nil then
			Serialize(os, 0)
		else
			Serialize(os, #obj.relations)
			for i = 1, #obj.relations do
				Serialize(os, obj.relations[i])
			end
		end
		__SerializeStruct(os, "WeaponItem", obj.weapon)
		if obj.equipment==nil then
			Serialize(os, 0)
		else
			Serialize(os, #obj.equipment)
			for i = 1, #obj.equipment do
				__SerializeStruct(os, "RolePVPHeroEquipment", obj.equipment[i])
			end
		end
	elseif __type__ == "Role_PvpInfo" then
		Serialize(os, obj.star)
		Serialize(os, obj.join_count)
		Serialize(os, obj.win_count)
		Serialize(os, obj.end_time)
	elseif __type__ == "TongQueTaiPlayerInfo" then
		Serialize(os, obj.id)
		Serialize(os, obj.name)
		Serialize(os, obj.photo)
		Serialize(os, obj.level)
		Serialize(os, obj.fight_num)
		Serialize(os, obj.auto_flag)
		if obj.hero_info==nil then
			Serialize(os, 0)
		else
			Serialize(os, #obj.hero_info)
			for i = 1, #obj.hero_info do
				__SerializeStruct(os, "TongQueTaiHeroInfo", obj.hero_info[i])
			end
		end
	elseif __type__ == "RolePveArenaHero" then
		Serialize(os, obj.id)
		Serialize(os, obj.level)
		Serialize(os, obj.star)
		Serialize(os, obj.grade)
		if obj.skill==nil then
			Serialize(os, 0)
		else
			Serialize(os, #obj.skill)
			for i = 1, #obj.skill do
				__SerializeStruct(os, "HeroSkill", obj.skill[i])
			end
		end
		if obj.common_skill==nil then
			Serialize(os, 0)
		else
			Serialize(os, #obj.common_skill)
			for i = 1, #obj.common_skill do
				__SerializeStruct(os, "HeroSkill", obj.common_skill[i])
			end
		end
		if obj.select_skill==nil then
			Serialize(os, 0)
		else
			Serialize(os, #obj.select_skill)
			for i = 1, #obj.select_skill do
				Serialize(os, obj.select_skill[i])
			end
		end
		if obj.relations==nil then
			Serialize(os, 0)
		else
			Serialize(os, #obj.relations)
			for i = 1, #obj.relations do
				Serialize(os, obj.relations[i])
			end
		end
		__SerializeStruct(os, "WeaponItem", obj.weapon)
		if obj.equipment==nil then
			Serialize(os, 0)
		else
			Serialize(os, #obj.equipment)
			for i = 1, #obj.equipment do
				__SerializeStruct(os, "RolePveArenaHeroEquipment", obj.equipment[i])
			end
		end
	elseif __type__ == "TongQueTaiMonsterState" then
		Serialize(os, obj.id)
		Serialize(os, obj.hp)
		Serialize(os, obj.anger)
		Serialize(os, obj.alive_flag)
	elseif __type__ == "MafiaBrief" then
		Serialize(os, obj.id)
		Serialize(os, obj.name)
		Serialize(os, obj.flag)
		Serialize(os, obj.announce)
		Serialize(os, obj.level)
		Serialize(os, obj.activity)
		Serialize(os, obj.boss_id)
		Serialize(os, obj.boss_name)
	elseif __type__ == "EquipmentItem" then
		__SerializeStruct(os, "Item", obj.base_item)
		__SerializeStruct(os, "EquipmentInfo", obj.equipment_info)
	elseif __type__ == "DropItem" then
		Serialize(os, obj.id)
		Serialize(os, obj.count)
	elseif __type__ == "LotteryRewardInfo" then
		Serialize(os, obj.id)
		Serialize(os, obj.num)
		Serialize(os, obj.firstget)
		Serialize(os, obj.bproorhero)
	elseif __type__ == "RoleInstance" then
		Serialize(os, obj.tid)
		Serialize(os, obj.score)
	elseif __type__ == "TopListItem" then
		Serialize(os, obj.item_id)
		Serialize(os, obj.tid)
		Serialize(os, obj.typ)
	elseif __type__ == "RolePveArenaInfo" then
		if obj.heroinfo==nil then
			Serialize(os, 0)
		else
			Serialize(os, #obj.heroinfo)
			for i = 1, #obj.heroinfo do
				__SerializeStruct(os, "RolePveArenaHero", obj.heroinfo[i])
			end
		end
	elseif __type__ == "MaShuHeroInfo" then
		Serialize(os, obj.hero_id)
		Serialize(os, obj.horse_id)
	elseif __type__ == "RolePVPHeroEquipment" then
		Serialize(os, obj.pos)
		Serialize(os, obj.item_id)
		Serialize(os, obj.level)
		Serialize(os, obj.order)
		if obj.refinable_pro==nil then
			Serialize(os, 0)
		else
			Serialize(os, #obj.refinable_pro)
			for i = 1, #obj.refinable_pro do
				__SerializeStruct(os, "RefinableData", obj.refinable_pro[i])
			end
		end
	elseif __type__ == "BattleAddArmyInfo" then
		Serialize(os, obj.id)
		Serialize(os, obj.pos)
		Serialize(os, obj.npc_id)
		Serialize(os, obj.npc_camp)
		Serialize(os, obj.army_id)
		Serialize(os, obj.army_buff)
	elseif __type__ == "Chat" then
		Serialize(os, obj.src_id)
		Serialize(os, obj.src_name)
		Serialize(os, obj.time)
		Serialize(os, obj.content)
	elseif __type__ == "Mafia" then
		Serialize(os, obj.id)
		Serialize(os, obj.name)
		Serialize(os, obj.flag)
		Serialize(os, obj.announce)
		Serialize(os, obj.level)
		Serialize(os, obj.activity)
		Serialize(os, obj.boss_id)
		Serialize(os, obj.boss_name)
		if obj.members==nil then
			Serialize(os, 0)
		else
			Serialize(os, #obj.members)
			for i = 1, #obj.members do
				__SerializeStruct(os, "MafiaMember", obj.members[i])
			end
		end
	elseif __type__ == "PvpVideo" then
		if obj.video==nil then
			Serialize(os, 0)
		else
			Serialize(os, #obj.video)
			for i = 1, #obj.video do
				__SerializeStruct(os, "PvpOperation", obj.video[i])
			end
		end
	elseif __type__ == "TopListData" then
		Serialize(os, obj.id)
		Serialize(os, obj.name)
		Serialize(os, obj.photo)
		Serialize(os, obj.data)
		Serialize(os, obj.level)
		__SerializeStruct(os, "TopListItem", obj.item)
	elseif __type__ == "RoleClientPVPInfo" then
		__SerializeStruct(os, "RoleBrief", obj.brief)
		if obj.hero_hall==nil then
			Serialize(os, 0)
		else
			Serialize(os, #obj.hero_hall)
			for i = 1, #obj.hero_hall do
				__SerializeStruct(os, "RolePVPHero", obj.hero_hall[i])
			end
		end
		Serialize(os, obj.pvp_score)
		Serialize(os, obj.role_id1)
		Serialize(os, obj.role_id2)
		Serialize(os, obj.role_id1)
		Serialize(os, obj.role_id2)
		Serialize(os, obj.role_id1)
		Serialize(os, obj.role_id2)
	elseif __type__ == "RoleBrief" then
		Serialize(os, obj.id)
		Serialize(os, obj.name)
		Serialize(os, obj.photo)
		Serialize(os, obj.level)
		Serialize(os, obj.mafia_id)
		Serialize(os, obj.mafia_name)
	elseif __type__ == "BattlePosBuff" then
		Serialize(os, obj.pos)
		Serialize(os, obj.typ)
		Serialize(os, obj.num)
	elseif __type__ == "RoleHero" then
		Serialize(os, obj.tid)
		Serialize(os, obj.level)
		Serialize(os, obj.order)
		Serialize(os, obj.exp)
		Serialize(os, obj.star)
		Serialize(os, obj.skillpoint)
		if obj.skill==nil then
			Serialize(os, 0)
		else
			Serialize(os, #obj.skill)
			for i = 1, #obj.skill do
				__SerializeStruct(os, "HeroSkill", obj.skill[i])
			end
		end
		if obj.common_skill==nil then
			Serialize(os, 0)
		else
			Serialize(os, #obj.common_skill)
			for i = 1, #obj.common_skill do
				__SerializeStruct(os, "HeroSkill", obj.common_skill[i])
			end
		end
		__SerializeStruct(os, "HeroPvpInfoData", obj.hero_pvp_info)
		if obj.select_skill==nil then
			Serialize(os, 0)
		else
			Serialize(os, #obj.select_skill)
			for i = 1, #obj.select_skill do
				Serialize(os, obj.select_skill[i])
			end
		end
		Serialize(os, obj.weapon_id)
		if obj.equipment==nil then
			Serialize(os, 0)
		else
			Serialize(os, #obj.equipment)
			for i = 1, #obj.equipment do
				__SerializeStruct(os, "EquipmentPosInfo", obj.equipment[i])
			end
		end
	elseif __type__ == "RolePveArenaHeroEquipment" then
		Serialize(os, obj.pos)
		Serialize(os, obj.item_id)
		Serialize(os, obj.level)
		Serialize(os, obj.order)
		if obj.refinable_pro==nil then
			Serialize(os, 0)
		else
			Serialize(os, #obj.refinable_pro)
			for i = 1, #obj.refinable_pro do
				__SerializeStruct(os, "RefinableData", obj.refinable_pro[i])
			end
		end
	elseif __type__ == "BattleNPCInfo" then
		Serialize(os, obj.id)
		Serialize(os, obj.camp)
		Serialize(os, obj.armyid)
		Serialize(os, obj.alive)
		Serialize(os, obj.event_flag)
		Serialize(os, obj.army_buff)
	elseif __type__ == "RoleStatus" then
		Serialize(os, obj.level)
		Serialize(os, obj.exp)
		Serialize(os, obj.vp)
		if obj.instances==nil then
			Serialize(os, 0)
		else
			Serialize(os, #obj.instances)
			for i = 1, #obj.instances do
				__SerializeStruct(os, "RoleInstance", obj.instances[i])
			end
		end
		Serialize(os, obj.money)
		Serialize(os, obj.yuanbao)
		if obj.common_use_limit==nil then
			Serialize(os, 0)
		else
			Serialize(os, #obj.common_use_limit)
			for i = 1, #obj.common_use_limit do
				__SerializeStruct(os, "CommonUseLimit", obj.common_use_limit[i])
			end
		end
		Serialize(os, obj.chongzhi)
		Serialize(os, obj.hero_skill_point)
		Serialize(os, obj.lottery_one_flag)
		Serialize(os, obj.lottery_ten_flag)
	elseif __type__ == "RolePveArenaHistoryInfo" then
		Serialize(os, obj.match_id)
		Serialize(os, obj.id)
		Serialize(os, obj.name)
		Serialize(os, obj.win_flag)
		Serialize(os, obj.attack_flag)
		Serialize(os, obj.time)
		Serialize(os, obj.self_level)
		Serialize(os, obj.oppo_level)
		Serialize(os, obj.self_mafia)
		Serialize(os, obj.oppo_mafia)
		Serialize(os, obj.reply_flag)
	elseif __type__ == "BattlePositionInfo" then
		Serialize(os, obj.id)
		Serialize(os, obj.position)
		Serialize(os, obj.flag)
		Serialize(os, obj.event_flag)
		Serialize(os, obj.pos_buff)
		if obj.npc_info==nil then
			Serialize(os, 0)
		else
			Serialize(os, #obj.npc_info)
			for i = 1, #obj.npc_info do
				__SerializeStruct(os, "BattleNPCInfo", obj.npc_info[i])
			end
		end
	elseif __type__ == "EquipmentPosInfo" then
		Serialize(os, obj.pos)
		Serialize(os, obj.equipment_id)
	elseif __type__ == "RoleBase" then
		Serialize(os, obj.id)
		Serialize(os, obj.name)
		Serialize(os, obj.photo)
	elseif __type__ == "InstanceInfo" then
		Serialize(os, obj.id)
		Serialize(os, obj.star)
	elseif __type__ == "Condition" then
		Serialize(os, obj.current)
		Serialize(os, obj.max)
	elseif __type__ == "BattleArmyBuff" then
		Serialize(os, obj.id)
		Serialize(os, obj.pos)
		Serialize(os, obj.army)
		Serialize(os, obj.typ)
		Serialize(os, obj.buff_id)
	elseif __type__ == "HeroPvpInfoData" then
		Serialize(os, obj.id)
		Serialize(os, obj.join_count)
		Serialize(os, obj.win_count)
	elseif __type__ == "TongQueTaiHeroInfo" then
		Serialize(os, obj.id)
		Serialize(os, obj.level)
		Serialize(os, obj.star)
		Serialize(os, obj.grade)
		if obj.skill==nil then
			Serialize(os, 0)
		else
			Serialize(os, #obj.skill)
			for i = 1, #obj.skill do
				__SerializeStruct(os, "HeroSkill", obj.skill[i])
			end
		end
		if obj.common_skill==nil then
			Serialize(os, 0)
		else
			Serialize(os, #obj.common_skill)
			for i = 1, #obj.common_skill do
				__SerializeStruct(os, "HeroSkill", obj.common_skill[i])
			end
		end
		if obj.select_skill==nil then
			Serialize(os, 0)
		else
			Serialize(os, #obj.select_skill)
			for i = 1, #obj.select_skill do
				Serialize(os, obj.select_skill[i])
			end
		end
		if obj.relations==nil then
			Serialize(os, 0)
		else
			Serialize(os, #obj.relations)
			for i = 1, #obj.relations do
				Serialize(os, obj.relations[i])
			end
		end
		__SerializeStruct(os, "WeaponItem", obj.weapon)
		if obj.equipment==nil then
			Serialize(os, 0)
		else
			Serialize(os, #obj.equipment)
			for i = 1, #obj.equipment do
				__SerializeStruct(os, "RolePveArenaHeroEquipment", obj.equipment[i])
			end
		end
		Serialize(os, obj.cur_hp)
		Serialize(os, obj.cur_anger)
		Serialize(os, obj.alive_flag)
	elseif __type__ == "BattleHeroInfo" then
		Serialize(os, obj.hero_id)
		Serialize(os, obj.hp)
	elseif __type__ == "MaShuBuffInfo" then
		Serialize(os, obj.id)
		Serialize(os, obj.buffer_id)
		Serialize(os, obj.typ)
	elseif __type__ == "TongQueTaiOperation" then
		Serialize(os, obj.client_tick)
		Serialize(os, obj.op)
	elseif __type__ == "RoleUserDefine" then
		if obj.role_define==nil then
			Serialize(os, 0)
		else
			Serialize(os, #obj.role_define)
			for i = 1, #obj.role_define do
				__SerializeStruct(os, "RoleUserDefineData", obj.role_define[i])
			end
		end
	elseif __type__ == "MafiaMember" then
		Serialize(os, obj.id)
		Serialize(os, obj.name)
		Serialize(os, obj.photo)
		Serialize(os, obj.level)
		Serialize(os, obj.activity)
	elseif __type__ == "PveArenaOperation" then
		if obj.operation==nil then
			Serialize(os, 0)
		else
			Serialize(os, #obj.operation)
			for i = 1, #obj.operation do
				__SerializeStruct(os, "PVEOperation", obj.operation[i])
			end
		end
	elseif __type__ == "PVPFighter" then
		Serialize(os, obj.id)
		if obj.ops==nil then
			Serialize(os, 0)
		else
			Serialize(os, #obj.ops)
			for i = 1, #obj.ops do
				Serialize(os, obj.ops[i])
			end
		end
	elseif __type__ == "BattleEventInfo" then
		Serialize(os, obj.event_id)
		Serialize(os, obj.plot_dia_id)
		if obj.del_army_id==nil then
			Serialize(os, 0)
		else
			Serialize(os, #obj.del_army_id)
			for i = 1, #obj.del_army_id do
				__SerializeStruct(os, "BattleDelArmyInfo", obj.del_army_id[i])
			end
		end
		if obj.add_army_info==nil then
			Serialize(os, 0)
		else
			Serialize(os, #obj.add_army_info)
			for i = 1, #obj.add_army_info do
				__SerializeStruct(os, "BattleAddArmyInfo", obj.add_army_info[i])
			end
		end
		if obj.item==nil then
			Serialize(os, 0)
		else
			Serialize(os, #obj.item)
			for i = 1, #obj.item do
				__SerializeStruct(os, "Item", obj.item[i])
			end
		end
		if obj.position_buff==nil then
			Serialize(os, 0)
		else
			Serialize(os, #obj.position_buff)
			for i = 1, #obj.position_buff do
				__SerializeStruct(os, "BattlePositionBuff", obj.position_buff[i])
			end
		end
		if obj.army_buff==nil then
			Serialize(os, 0)
		else
			Serialize(os, #obj.army_buff)
			for i = 1, #obj.army_buff do
				__SerializeStruct(os, "BattleArmyBuff", obj.army_buff[i])
			end
		end
		if obj.del_pos_buff==nil then
			Serialize(os, 0)
		else
			Serialize(os, #obj.del_pos_buff)
			for i = 1, #obj.del_pos_buff do
				Serialize(os, obj.del_pos_buff[i])
			end
		end
		if obj.pos_army_buff==nil then
			Serialize(os, 0)
		else
			Serialize(os, #obj.pos_army_buff)
			for i = 1, #obj.pos_army_buff do
				__SerializeStruct(os, "BattlePosBuff", obj.pos_army_buff[i])
			end
		end
		Serialize(os, obj.remove_round_limit)
		Serialize(os, obj.self_morale_change_typ)
		Serialize(os, obj.self_morale_change_num)
	elseif __type__ == "PveArenaInfo" then
		Serialize(os, obj.video_flag)
	elseif __type__ == "Instance_Star_Condition" then
		Serialize(os, obj.tid)
		Serialize(os, obj.flag)
	elseif __type__ == "InjuredHeroInfo" then
		Serialize(os, obj.id)
		Serialize(os, obj.hp)
		Serialize(os, obj.anger)
	elseif __type__ == "TongQueTaiMonsterInfo" then
		Serialize(os, obj.id)
		Serialize(os, obj.name)
		Serialize(os, obj.photo)
		Serialize(os, obj.level)
		Serialize(os, obj.fight_num)
		Serialize(os, obj.npc_flag)
		if obj.hero_info==nil then
			Serialize(os, 0)
		else
			Serialize(os, #obj.hero_info)
			for i = 1, #obj.hero_info do
				__SerializeStruct(os, "TongQueTaiHeroInfo", obj.hero_info[i])
			end
		end
	elseif __type__ == "RoleUserDefineData" then
		Serialize(os, obj.id)
		Serialize(os, obj.value_define)
	elseif __type__ == "TemporaryBackPackData" then
		Serialize(os, obj.id)
		Serialize(os, obj.typ)
		if obj.items==nil then
			Serialize(os, 0)
		else
			Serialize(os, #obj.items)
			for i = 1, #obj.items do
				__SerializeStruct(os, "Item", obj.items[i])
			end
		end
	elseif __type__ == "RoleBackPack" then
		Serialize(os, obj.capacity)
		if obj.items==nil then
			Serialize(os, 0)
		else
			Serialize(os, #obj.items)
			for i = 1, #obj.items do
				__SerializeStruct(os, "Item", obj.items[i])
			end
		end
		if obj.weaponitems==nil then
			Serialize(os, 0)
		else
			Serialize(os, #obj.weaponitems)
			for i = 1, #obj.weaponitems do
				__SerializeStruct(os, "WeaponItem", obj.weaponitems[i])
			end
		end
		if obj.equipmentitems==nil then
			Serialize(os, 0)
		else
			Serialize(os, #obj.equipmentitems)
			for i = 1, #obj.equipmentitems do
				__SerializeStruct(os, "EquipmentItem", obj.equipmentitems[i])
			end
		end
	elseif __type__ == "RoleTask" then
		if obj.finish==nil then
			Serialize(os, 0)
		else
			Serialize(os, #obj.finish)
			for i = 1, #obj.finish do
				Serialize(os, obj.finish[i])
			end
		end
		if obj.current==nil then
			Serialize(os, 0)
		else
			Serialize(os, #obj.current)
			for i = 1, #obj.current do
				__SerializeStruct(os, "RoleCurrentTask", obj.current[i])
			end
		end
	elseif __type__ == "HeroSoul" then
		Serialize(os, obj.soul_id)
		Serialize(os, obj.soul_num)
	elseif __type__ == "PvpVideoData" then
		Serialize(os, obj.video)
		__SerializeStruct(os, "RoleClientPVPInfo", obj.player1)
		__SerializeStruct(os, "RoleClientPVPInfo", obj.player2)
		Serialize(os, obj.win_flag)
		Serialize(os, obj.time)
	elseif __type__ == "EquipmentInfo" then
		Serialize(os, obj.tid)
		Serialize(os, obj.hero_id)
		Serialize(os, obj.level)
		Serialize(os, obj.order)
		if obj.refinable_pro==nil then
			Serialize(os, 0)
		else
			Serialize(os, #obj.refinable_pro)
			for i = 1, #obj.refinable_pro do
				__SerializeStruct(os, "RefinableData", obj.refinable_pro[i])
			end
		end
		if obj.tmp_refinable_pro==nil then
			Serialize(os, 0)
		else
			Serialize(os, #obj.tmp_refinable_pro)
			for i = 1, #obj.tmp_refinable_pro do
				__SerializeStruct(os, "RefinableData", obj.tmp_refinable_pro[i])
			end
		end
	elseif __type__ == "MailInfo" then
		Serialize(os, obj.mail_id)
		Serialize(os, obj.msg_id)
		Serialize(os, obj.subject)
		Serialize(os, obj.context)
		Serialize(os, obj.time)
		Serialize(os, obj.from_id)
		Serialize(os, obj.from_name)
		if obj.item==nil then
			Serialize(os, 0)
		else
			Serialize(os, #obj.item)
			for i = 1, #obj.item do
				__SerializeStruct(os, "Item", obj.item[i])
			end
		end
		if obj.mail_arg==nil then
			Serialize(os, 0)
		else
			Serialize(os, #obj.mail_arg)
			for i = 1, #obj.mail_arg do
				Serialize(os, obj.mail_arg[i])
			end
		end
		Serialize(os, obj.read_flag)
	elseif __type__ == "Item" then
		Serialize(os, obj.tid)
		Serialize(os, obj.count)
	elseif __type__ == "WeaponItem" then
		__SerializeStruct(os, "Item", obj.base_item)
		__SerializeStruct(os, "WeaponInfo", obj.weapon_info)
	elseif __type__ == "PvpOperation" then
		Serialize(os, obj.tick)
		Serialize(os, obj.first_operation)
		Serialize(os, obj.second_operation)
	elseif __type__ == "BattlePositionBuff" then
		Serialize(os, obj.id)
		Serialize(os, obj.pos)
		Serialize(os, obj.buff_id)
	elseif __type__ == "BattleFieldNpcMoveInfo" then
		Serialize(os, obj.npc_id)
		Serialize(os, obj.source_pos)
		Serialize(os, obj.move_pos)
		Serialize(os, obj.battle_flag)
		if obj.move_event==nil then
			Serialize(os, 0)
		else
			Serialize(os, #obj.move_event)
			for i = 1, #obj.move_event do
				__SerializeStruct(os, "BattleEventInfo", obj.move_event[i])
			end
		end
		if obj.capture_event==nil then
			Serialize(os, 0)
		else
			Serialize(os, #obj.capture_event)
			for i = 1, #obj.capture_event do
				__SerializeStruct(os, "BattleEventInfo", obj.capture_event[i])
			end
		end
	elseif __type__ == "RoleTaskCondition" then
		Serialize(os, obj.current_num)
		Serialize(os, obj.max_num)
	elseif __type__ == "UpgradeSkillInfo" then
		Serialize(os, obj.skill_id)
		Serialize(os, obj.level)

	end
end

