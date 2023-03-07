--DONT CHANGE ME!

local func_list = {}

function __SerializeStruct(os, __type__, obj)
	if obj==nil then obj={} end

	if func_list[__type__] ~= nil then
		func_list[__type__](os, obj)
	else
		error("wrong structure type: "..__type__)
	end
end


func_list["RoleHeroHall"] = 
function(os, obj)
	if obj.heros==nil then
		Serialize(os, 0)
	else
		Serialize(os, #obj.heros)
		for i = 1, #obj.heros do
			__SerializeStruct(os, "RoleHero", obj.heros[i])
		end
	end

end

func_list["MaShuFightFriendInfo"] = 
function(os, obj)
	Serialize(os, obj.role_id)
	Serialize(os, obj.name)
	Serialize(os, obj.zhanli)

end

func_list["MilitaryStageInfo"] = 
function(os, obj)
	Serialize(os, obj.stage_id)
	Serialize(os, obj.times)
	Serialize(os, obj.cd)

end

func_list["RolePVPInfo"] = 
function(os, obj)
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

end

func_list["AnotherRoleData"] = 
function(os, obj)
	__SerializeStruct(os, "RoleBrief", obj.brief)
	Serialize(os, obj.zhanli)
	Serialize(os, obj.mafia_position)
	Serialize(os, obj.time)

end

func_list["PVEOperation"] = 
function(os, obj)
	Serialize(os, obj.client_tick)
	Serialize(os, obj.op)

end

func_list["ShiLianHeroInfo"] = 
function(os, obj)
	Serialize(os, obj.id)
	Serialize(os, obj.hp)
	Serialize(os, obj.anger)

end

func_list["BattleInfo"] = 
function(os, obj)
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
	Serialize(os, obj.attacked_flag)
	if obj.info_history==nil then
		Serialize(os, 0)
	else
		Serialize(os, #obj.info_history)
		for i = 1, #obj.info_history do
			Serialize(os, obj.info_history[i])
		end
	end

end

func_list["FlowerGiftInfo"] = 
function(os, obj)
	__SerializeStruct(os, "RoleBrief", obj.info)
	Serialize(os, obj.count)
	Serialize(os, obj.time)
	Serialize(os, obj.flowermask)

end

func_list["NoticeParaInfo"] = 
function(os, obj)
	Serialize(os, obj.typ)
	Serialize(os, obj.id)
	Serialize(os, obj.name)
	Serialize(os, obj.num)
	Serialize(os, obj.text)

end

func_list["RoleHorseHall"] = 
function(os, obj)
	if obj.horses==nil then
		Serialize(os, 0)
	else
		Serialize(os, #obj.horses)
		for i = 1, #obj.horses do
			__SerializeStruct(os, "RoleHorse", obj.horses[i])
		end
	end

end

func_list["PvpVideoBrief"] = 
function(os, obj)
	Serialize(os, obj.video_id)
	__SerializeStruct(os, "RoleClientPVPInfo", obj.player1)
	__SerializeStruct(os, "RoleClientPVPInfo", obj.player2)
	Serialize(os, obj.win_flag)
	Serialize(os, obj.time)
	Serialize(os, obj.match_pvp)
	Serialize(os, obj.duration)

end

func_list["InstanceHero"] = 
function(os, obj)
	Serialize(os, obj.typ)
	Serialize(os, obj.battle_id)
	__SerializeStruct(os, "RoleLastHero", obj.heroinfo)
	Serialize(os, obj.horse)

end

func_list["MaShuFriendInfo"] = 
function(os, obj)
	Serialize(os, obj.role_id)
	Serialize(os, obj.count)

end

func_list["MafiaApplyRoleInfo"] = 
function(os, obj)
	Serialize(os, obj.id)
	Serialize(os, obj.name)
	Serialize(os, obj.photo)
	Serialize(os, obj.photo_frame)
	if obj.badge_info==nil then
		Serialize(os, 0)
	else
		Serialize(os, #obj.badge_info)
		for i = 1, #obj.badge_info do
			__SerializeStruct(os, "PhotoInfo", obj.badge_info[i])
		end
	end
	Serialize(os, obj.sex)
	Serialize(os, obj.level)
	Serialize(os, obj.zhanli)

end

func_list["FightInfo"] = 
function(os, obj)
	Serialize(os, obj.room_id)
	Serialize(os, obj.fight1_id)
	Serialize(os, obj.fight2_id)
	Serialize(os, obj.fight1_name)
	Serialize(os, obj.fight2_name)
	if obj.fight1_hero_hall==nil then
		Serialize(os, 0)
	else
		Serialize(os, #obj.fight1_hero_hall)
		for i = 1, #obj.fight1_hero_hall do
			__SerializeStruct(os, "RolePVPHero", obj.fight1_hero_hall[i])
		end
	end
	if obj.fight2_hero_hall==nil then
		Serialize(os, 0)
	else
		Serialize(os, #obj.fight2_hero_hall)
		for i = 1, #obj.fight2_hero_hall do
			__SerializeStruct(os, "RolePVPHero", obj.fight2_hero_hall[i])
		end
	end

end

func_list["MysteryShopInfo"] = 
function(os, obj)
	Serialize(os, obj.shop_id)
	if obj.shop_item==nil then
		Serialize(os, 0)
	else
		Serialize(os, #obj.shop_item)
		for i = 1, #obj.shop_item do
			__SerializeStruct(os, "MysteryShopItem", obj.shop_item[i])
		end
	end

end

func_list["HeroSkill"] = 
function(os, obj)
	Serialize(os, obj.skill_id)
	Serialize(os, obj.skill_level)

end

func_list["ChatInfo"] = 
function(os, obj)
	__SerializeStruct(os, "RoleBrief", obj.src)
	__SerializeStruct(os, "RoleBrief", obj.dest)
	Serialize(os, obj.text_content)
	Serialize(os, obj.speech_content)
	Serialize(os, obj.time)
	Serialize(os, obj.typ)

end

func_list["RoleLastHero"] = 
function(os, obj)
	if obj.info==nil then
		Serialize(os, 0)
	else
		Serialize(os, #obj.info)
		for i = 1, #obj.info do
			Serialize(os, obj.info[i])
		end
	end

end

func_list["CommonUseLimit"] = 
function(os, obj)
	Serialize(os, obj.tid)
	Serialize(os, obj.count)

end

func_list["HeroComment"] = 
function(os, obj)
	Serialize(os, obj.role_id)
	Serialize(os, obj.role_name)
	Serialize(os, obj.comment)
	Serialize(os, obj.agree_count)
	Serialize(os, obj.agree_flag)
	Serialize(os, obj.time_stamp)

end

func_list["RoleBrief"] = 
function(os, obj)
	Serialize(os, obj.id)
	Serialize(os, obj.name)
	Serialize(os, obj.photo)
	Serialize(os, obj.photo_frame)
	if obj.badge_info==nil then
		Serialize(os, 0)
	else
		Serialize(os, #obj.badge_info)
		for i = 1, #obj.badge_info do
			__SerializeStruct(os, "PhotoInfo", obj.badge_info[i])
		end
	end
	Serialize(os, obj.sex)
	Serialize(os, obj.level)
	Serialize(os, obj.mafia_id)
	Serialize(os, obj.mafia_name)
	Serialize(os, obj.zhanli)

end

func_list["DanMuDataVector"] = 
function(os, obj)
	if obj.info==nil then
		Serialize(os, 0)
	else
		Serialize(os, #obj.info)
		for i = 1, #obj.info do
			__SerializeStruct(os, "DanMuData", obj.info[i])
		end
	end

end

func_list["RoleMafia"] = 
function(os, obj)
	Serialize(os, obj.id)
	Serialize(os, obj.name)

end

func_list["RefinableData"] = 
function(os, obj)
	Serialize(os, obj.typ)
	Serialize(os, obj.data)

end

func_list["BattleHorseHero"] = 
function(os, obj)
	if obj.hero==nil then
		Serialize(os, 0)
	else
		Serialize(os, #obj.hero)
		for i = 1, #obj.hero do
			Serialize(os, obj.hero[i])
		end
	end
	Serialize(os, obj.horse)

end

func_list["DifficultyInfo"] = 
function(os, obj)
	Serialize(os, obj.difficulty)
	Serialize(os, obj.camp)

end

func_list["WeaponSkill"] = 
function(os, obj)
	Serialize(os, obj.skill_id)
	Serialize(os, obj.skill_level)

end

func_list["OpponentInfo"] = 
function(os, obj)
	Serialize(os, obj.id)
	Serialize(os, obj.alive)
	Serialize(os, obj.level)
	Serialize(os, obj.stage)
	Serialize(os, obj.hp)
	Serialize(os, obj.anger)
	Serialize(os, obj.rewardflag)

end

func_list["DanMuData"] = 
function(os, obj)
	Serialize(os, obj.role_id)
	Serialize(os, obj.role_name)
	Serialize(os, obj.tick)
	Serialize(os, obj.danmu_info)

end

func_list["PveArenaFighterInfo"] = 
function(os, obj)
	Serialize(os, obj.name)
	Serialize(os, obj.id)
	Serialize(os, obj.level)
	Serialize(os, obj.rank)
	Serialize(os, obj.score)
	Serialize(os, obj.hero_score)
	Serialize(os, obj.mafia_name)
	__SerializeStruct(os, "RolePveArenaInfo", obj.hero_info)
	Serialize(os, obj.photo)
	Serialize(os, obj.photo_frame)
	if obj.badge_info==nil then
		Serialize(os, 0)
	else
		Serialize(os, #obj.badge_info)
		for i = 1, #obj.badge_info do
			__SerializeStruct(os, "PhotoInfo", obj.badge_info[i])
		end
	end

end

func_list["SweepInstanceData"] = 
function(os, obj)
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

end

func_list["MysteryShopItem"] = 
function(os, obj)
	Serialize(os, obj.item_id)
	Serialize(os, obj.buy_count)
	Serialize(os, obj.max_count)

end

func_list["TowerArmyInfoList"] = 
function(os, obj)
	if obj.armyinfo==nil then
		Serialize(os, 0)
	else
		Serialize(os, #obj.armyinfo)
		for i = 1, #obj.armyinfo do
			__SerializeStruct(os, "TowerArmyInfo", obj.armyinfo[i])
		end
	end

end

func_list["RoleCurrentTask"] = 
function(os, obj)
	Serialize(os, obj.id)
	if obj.condition==nil then
		Serialize(os, 0)
	else
		Serialize(os, #obj.condition)
		for i = 1, #obj.condition do
			__SerializeStruct(os, "RoleTaskCondition", obj.condition[i])
		end
	end

end

func_list["RoleInfo"] = 
function(os, obj)
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
	if obj.photo_info==nil then
		Serialize(os, 0)
	else
		Serialize(os, #obj.photo_info)
		for i = 1, #obj.photo_info do
			__SerializeStruct(os, "PhotoInfo", obj.photo_info[i])
		end
	end
	if obj.photoframe_info==nil then
		Serialize(os, 0)
	else
		Serialize(os, #obj.photoframe_info)
		for i = 1, #obj.photoframe_info do
			__SerializeStruct(os, "PhotoInfo", obj.photoframe_info[i])
		end
	end
	Serialize(os, obj.pvp_ver)
	__SerializeStruct(os, "DailyInfo", obj.daily_info)

end

func_list["SkinItem"] = 
function(os, obj)
	Serialize(os, obj.id)
	Serialize(os, obj.time)

end

func_list["RepInfo"] = 
function(os, obj)
	Serialize(os, obj.rep_id)
	Serialize(os, obj.rep_num)

end

func_list["LegionJunXueGuanData"] = 
function(os, obj)
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

end

func_list["WeaponInfo"] = 
function(os, obj)
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
	Serialize(os, obj.exp)

end

func_list["MailInfo"] = 
function(os, obj)
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

end

func_list["BattleDelArmyInfo"] = 
function(os, obj)
	Serialize(os, obj.id)
	Serialize(os, obj.pos)
	Serialize(os, obj.npc_id)
	Serialize(os, obj.army_id)

end

func_list["RoleHorse"] = 
function(os, obj)
	Serialize(os, obj.tid)

end

func_list["RolePVPHero"] = 
function(os, obj)
	Serialize(os, obj.tid)
	Serialize(os, obj.level)
	Serialize(os, obj.order)
	Serialize(os, obj.star)
	Serialize(os, obj.skin)
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

end

func_list["Role_PvpInfo"] = 
function(os, obj)
	Serialize(os, obj.star)
	Serialize(os, obj.join_count)
	Serialize(os, obj.win_count)
	Serialize(os, obj.end_time)

end

func_list["TowerArmyInfo"] = 
function(os, obj)
	Serialize(os, obj.id)
	Serialize(os, obj.hp)
	Serialize(os, obj.anger)
	Serialize(os, obj.alive)

end

func_list["TongQueTaiPlayerInfo"] = 
function(os, obj)
	Serialize(os, obj.id)
	Serialize(os, obj.name)
	Serialize(os, obj.photo)
	Serialize(os, obj.photo_frame)
	if obj.badge_info==nil then
		Serialize(os, 0)
	else
		Serialize(os, #obj.badge_info)
		for i = 1, #obj.badge_info do
			__SerializeStruct(os, "PhotoInfo", obj.badge_info[i])
		end
	end
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

end

func_list["RolePveArenaHero"] = 
function(os, obj)
	Serialize(os, obj.id)
	Serialize(os, obj.level)
	Serialize(os, obj.star)
	Serialize(os, obj.grade)
	Serialize(os, obj.skin)
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

end

func_list["TongQueTaiMonsterState"] = 
function(os, obj)
	Serialize(os, obj.id)
	Serialize(os, obj.hp)
	Serialize(os, obj.anger)
	Serialize(os, obj.alive_flag)

end

func_list["MafiaBrief"] = 
function(os, obj)
	Serialize(os, obj.id)
	Serialize(os, obj.name)
	Serialize(os, obj.flag)
	Serialize(os, obj.announce)
	Serialize(os, obj.level)
	Serialize(os, obj.activity)
	Serialize(os, obj.boss_id)
	Serialize(os, obj.boss_name)
	Serialize(os, obj.level_limit)
	Serialize(os, obj.num)
	Serialize(os, obj.xuanyan)

end

func_list["RolePveArenaHistoryData"] = 
function(os, obj)
	Serialize(os, obj.level)
	Serialize(os, obj.score)
	Serialize(os, obj.score_change)
	Serialize(os, obj.zhanli)
	Serialize(os, obj.mafia)
	Serialize(os, obj.photo)
	Serialize(os, obj.photo_frame)
	if obj.badge_info==nil then
		Serialize(os, 0)
	else
		Serialize(os, #obj.badge_info)
		for i = 1, #obj.badge_info do
			__SerializeStruct(os, "PhotoInfo", obj.badge_info[i])
		end
	end

end

func_list["EquipmentItem"] = 
function(os, obj)
	__SerializeStruct(os, "Item", obj.base_item)
	__SerializeStruct(os, "EquipmentInfo", obj.equipment_info)

end

func_list["DropItem"] = 
function(os, obj)
	Serialize(os, obj.id)
	Serialize(os, obj.count)

end

func_list["LotteryRewardInfo"] = 
function(os, obj)
	Serialize(os, obj.id)
	Serialize(os, obj.num)
	Serialize(os, obj.firstget)
	Serialize(os, obj.bproorhero)

end

func_list["RoleInstance"] = 
function(os, obj)
	Serialize(os, obj.tid)
	Serialize(os, obj.score)

end

func_list["TopListItem"] = 
function(os, obj)
	Serialize(os, obj.item_id)
	Serialize(os, obj.tid)
	Serialize(os, obj.typ)

end

func_list["RolePveArenaInfo"] = 
function(os, obj)
	if obj.heroinfo==nil then
		Serialize(os, 0)
	else
		Serialize(os, #obj.heroinfo)
		for i = 1, #obj.heroinfo do
			__SerializeStruct(os, "RolePveArenaHero", obj.heroinfo[i])
		end
	end

end

func_list["MaShuHeroInfo"] = 
function(os, obj)
	Serialize(os, obj.hero_id)
	Serialize(os, obj.horse_id)

end

func_list["RolePVPHeroEquipment"] = 
function(os, obj)
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

end

func_list["BattleAddArmyInfo"] = 
function(os, obj)
	Serialize(os, obj.id)
	Serialize(os, obj.pos)
	Serialize(os, obj.npc_id)
	Serialize(os, obj.npc_camp)
	Serialize(os, obj.army_id)
	Serialize(os, obj.army_buff)

end

func_list["MafiaNoticeRoleInfo"] = 
function(os, obj)
	Serialize(os, obj.id)
	Serialize(os, obj.name)

end

func_list["Chat"] = 
function(os, obj)
	Serialize(os, obj.src_id)
	Serialize(os, obj.src_name)
	Serialize(os, obj.time)
	Serialize(os, obj.content)

end

func_list["Mafia"] = 
function(os, obj)
	Serialize(os, obj.id)
	Serialize(os, obj.name)
	Serialize(os, obj.flag)
	Serialize(os, obj.announce)
	Serialize(os, obj.xuanyan)
	Serialize(os, obj.level)
	Serialize(os, obj.activity)
	Serialize(os, obj.boss_id)
	Serialize(os, obj.boss_name)
	Serialize(os, obj.exp)
	Serialize(os, obj.jisi)
	Serialize(os, obj.mashu_toplist_id)
	Serialize(os, obj.level_limit)
	Serialize(os, obj.need_approval)
	Serialize(os, obj.declaration)
	if obj.members==nil then
		Serialize(os, 0)
	else
		Serialize(os, #obj.members)
		for i = 1, #obj.members do
			__SerializeStruct(os, "MafiaMember", obj.members[i])
		end
	end
	if obj.apply_list==nil then
		Serialize(os, 0)
	else
		Serialize(os, #obj.apply_list)
		for i = 1, #obj.apply_list do
			__SerializeStruct(os, "MafiaApplyRoleInfo", obj.apply_list[i])
		end
	end
	if obj.notice==nil then
		Serialize(os, 0)
	else
		Serialize(os, #obj.notice)
		for i = 1, #obj.notice do
			__SerializeStruct(os, "MafiaNoticeInfo", obj.notice[i])
		end
	end
	Serialize(os, obj.declaration_time)

end

func_list["PvpVideo"] = 
function(os, obj)
	if obj.video==nil then
		Serialize(os, 0)
	else
		Serialize(os, #obj.video)
		for i = 1, #obj.video do
			__SerializeStruct(os, "PvpOperation", obj.video[i])
		end
	end

end

func_list["CenterFightInfo"] = 
function(os, obj)
	if obj.info==nil then
		Serialize(os, 0)
	else
		Serialize(os, #obj.info)
		for i = 1, #obj.info do
			__SerializeStruct(os, "CenterFightInfoData", obj.info[i])
		end
	end

end

func_list["TopListData"] = 
function(os, obj)
	Serialize(os, obj.id)
	Serialize(os, obj.name)
	Serialize(os, obj.photo)
	Serialize(os, obj.data)
	Serialize(os, obj.data2)
	Serialize(os, obj.level)
	__SerializeStruct(os, "TopListItem", obj.item)
	Serialize(os, obj.photo_frame)
	if obj.badge_info==nil then
		Serialize(os, 0)
	else
		Serialize(os, #obj.badge_info)
		for i = 1, #obj.badge_info do
			__SerializeStruct(os, "PhotoInfo", obj.badge_info[i])
		end
	end

end

func_list["MafiaInterfaceInfo"] = 
function(os, obj)
	Serialize(os, obj.id)
	Serialize(os, obj.name)
	Serialize(os, obj.flag)
	Serialize(os, obj.announce)
	Serialize(os, obj.activity)
	Serialize(os, obj.boss_id)
	Serialize(os, obj.boss_name)
	Serialize(os, obj.level_limit)
	Serialize(os, obj.need_approval)
	Serialize(os, obj.declaration)
	Serialize(os, obj.declaration_time)

end

func_list["RoleClientPVPInfo"] = 
function(os, obj)
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

end

func_list["PhotoInfo"] = 
function(os, obj)
	Serialize(os, obj.id)
	Serialize(os, obj.typ)

end

func_list["BattlePosBuff"] = 
function(os, obj)
	Serialize(os, obj.pos)
	Serialize(os, obj.typ)
	Serialize(os, obj.num)

end

func_list["RoleHero"] = 
function(os, obj)
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
	Serialize(os, obj.skin_id)
	if obj.equipment==nil then
		Serialize(os, 0)
	else
		Serialize(os, #obj.equipment)
		for i = 1, #obj.equipment do
			__SerializeStruct(os, "EquipmentPosInfo", obj.equipment[i])
		end
	end

end

func_list["RolePveArenaHeroEquipment"] = 
function(os, obj)
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

end

func_list["BattleNPCInfo"] = 
function(os, obj)
	Serialize(os, obj.id)
	Serialize(os, obj.camp)
	Serialize(os, obj.armyid)
	Serialize(os, obj.alive)
	Serialize(os, obj.event_flag)
	Serialize(os, obj.army_buff)
	Serialize(os, obj.next_pos)

end

func_list["RoleStatus"] = 
function(os, obj)
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

end

func_list["RolePveArenaHistoryInfo"] = 
function(os, obj)
	Serialize(os, obj.match_id)
	Serialize(os, obj.id)
	Serialize(os, obj.name)
	Serialize(os, obj.win_flag)
	Serialize(os, obj.attack_flag)
	Serialize(os, obj.time)
	Serialize(os, obj.reply_flag)
	__SerializeStruct(os, "RolePveArenaHistoryData", obj.self_info)
	__SerializeStruct(os, "RolePveArenaHistoryData", obj.oppo_info)

end

func_list["BattlePositionInfo"] = 
function(os, obj)
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

end

func_list["EquipmentPosInfo"] = 
function(os, obj)
	Serialize(os, obj.pos)
	Serialize(os, obj.equipment_id)

end

func_list["RoleBase"] = 
function(os, obj)
	Serialize(os, obj.id)
	Serialize(os, obj.name)
	Serialize(os, obj.photo)
	Serialize(os, obj.sex)
	Serialize(os, obj.photo_frame)
	if obj.badge_info==nil then
		Serialize(os, 0)
	else
		Serialize(os, #obj.badge_info)
		for i = 1, #obj.badge_info do
			__SerializeStruct(os, "PhotoInfo", obj.badge_info[i])
		end
	end

end

func_list["InstanceInfo"] = 
function(os, obj)
	Serialize(os, obj.id)
	Serialize(os, obj.star)

end

func_list["Condition"] = 
function(os, obj)
	Serialize(os, obj.current)
	Serialize(os, obj.max)

end

func_list["LotteryInfo"] = 
function(os, obj)
	Serialize(os, obj.lottery_id)
	Serialize(os, obj.last_time)
	Serialize(os, obj.select_id)

end

func_list["BattleArmyBuff"] = 
function(os, obj)
	Serialize(os, obj.id)
	Serialize(os, obj.pos)
	Serialize(os, obj.army)
	Serialize(os, obj.typ)
	Serialize(os, obj.buff_id)

end

func_list["HeroPvpInfoData"] = 
function(os, obj)
	Serialize(os, obj.id)
	Serialize(os, obj.join_count)
	Serialize(os, obj.win_count)

end

func_list["UpgradeSkillInfo"] = 
function(os, obj)
	Serialize(os, obj.skill_id)
	Serialize(os, obj.level)

end

func_list["BattleHeroInfo"] = 
function(os, obj)
	Serialize(os, obj.hero_id)
	Serialize(os, obj.hp)

end

func_list["MaShuBuffInfo"] = 
function(os, obj)
	Serialize(os, obj.id)
	Serialize(os, obj.buffer_id)
	Serialize(os, obj.typ)

end

func_list["TowerBuffInfo"] = 
function(os, obj)
	Serialize(os, obj.typ)
	Serialize(os, obj.data)

end

func_list["TongQueTaiOperation"] = 
function(os, obj)
	Serialize(os, obj.client_tick)
	Serialize(os, obj.op)

end

func_list["RoleUserDefine"] = 
function(os, obj)
	if obj.role_define==nil then
		Serialize(os, 0)
	else
		Serialize(os, #obj.role_define)
		for i = 1, #obj.role_define do
			__SerializeStruct(os, "RoleUserDefineData", obj.role_define[i])
		end
	end

end

func_list["MafiaMember"] = 
function(os, obj)
	Serialize(os, obj.id)
	Serialize(os, obj.name)
	Serialize(os, obj.photo)
	Serialize(os, obj.photo_frame)
	if obj.badge_info==nil then
		Serialize(os, 0)
	else
		Serialize(os, #obj.badge_info)
		for i = 1, #obj.badge_info do
			__SerializeStruct(os, "PhotoInfo", obj.badge_info[i])
		end
	end
	Serialize(os, obj.sex)
	Serialize(os, obj.level)
	Serialize(os, obj.zhanli)
	Serialize(os, obj.activity)
	Serialize(os, obj.position)
	Serialize(os, obj.logout_time)
	Serialize(os, obj.online)
	if obj.contrabution==nil then
		Serialize(os, 0)
	else
		Serialize(os, #obj.contrabution)
		for i = 1, #obj.contrabution do
			Serialize(os, obj.contrabution[i])
		end
	end

end

func_list["PveArenaOperation"] = 
function(os, obj)
	if obj.operation==nil then
		Serialize(os, 0)
	else
		Serialize(os, #obj.operation)
		for i = 1, #obj.operation do
			__SerializeStruct(os, "PVEOperation", obj.operation[i])
		end
	end

end

func_list["PVPFighter"] = 
function(os, obj)
	Serialize(os, obj.id)
	if obj.ops==nil then
		Serialize(os, 0)
	else
		Serialize(os, #obj.ops)
		for i = 1, #obj.ops do
			Serialize(os, obj.ops[i])
		end
	end

end

func_list["BattleEventInfo"] = 
function(os, obj)
	Serialize(os, obj.event_id)
	Serialize(os, obj.plot_dia_id)
	Serialize(os, obj.battle_dialog_id)
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
	Serialize(os, obj.trigger_results)

end

func_list["PveArenaInfo"] = 
function(os, obj)
	Serialize(os, obj.video_flag)

end

func_list["Instance_Star_Condition"] = 
function(os, obj)
	Serialize(os, obj.tid)
	Serialize(os, obj.flag)

end

func_list["InjuredHeroInfo"] = 
function(os, obj)
	Serialize(os, obj.id)
	Serialize(os, obj.hp)
	Serialize(os, obj.anger)

end

func_list["TongQueTaiMonsterInfo"] = 
function(os, obj)
	Serialize(os, obj.id)
	Serialize(os, obj.name)
	Serialize(os, obj.photo)
	Serialize(os, obj.photo_frame)
	if obj.badge_info==nil then
		Serialize(os, 0)
	else
		Serialize(os, #obj.badge_info)
		for i = 1, #obj.badge_info do
			__SerializeStruct(os, "PhotoInfo", obj.badge_info[i])
		end
	end
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

end

func_list["MoraleData"] = 
function(os, obj)
	Serialize(os, obj.npc_id)
	Serialize(os, obj.morale)

end

func_list["RoleUserDefineData"] = 
function(os, obj)
	Serialize(os, obj.id)
	Serialize(os, obj.value_define)

end

func_list["TemporaryBackPackData"] = 
function(os, obj)
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

end

func_list["RoleBackPack"] = 
function(os, obj)
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
	if obj.skinitems==nil then
		Serialize(os, 0)
	else
		Serialize(os, #obj.skinitems)
		for i = 1, #obj.skinitems do
			__SerializeStruct(os, "SkinItem", obj.skinitems[i])
		end
	end

end

func_list["RoleTask"] = 
function(os, obj)
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

end

func_list["HeroSoul"] = 
function(os, obj)
	Serialize(os, obj.soul_id)
	Serialize(os, obj.soul_num)

end

func_list["CenterFightInfoData"] = 
function(os, obj)
	Serialize(os, obj.room_id)
	__SerializeStruct(os, "RolePVPInfo", obj.fight1_info)
	__SerializeStruct(os, "RolePVPInfo", obj.fight2_info)

end

func_list["MafiaSelfInfo"] = 
function(os, obj)
	Serialize(os, obj.id)
	Serialize(os, obj.name)
	Serialize(os, obj.position)
	if obj.apply_mafia==nil then
		Serialize(os, 0)
	else
		Serialize(os, #obj.apply_mafia)
		for i = 1, #obj.apply_mafia do
			Serialize(os, obj.apply_mafia[i])
		end
	end

end

func_list["Friend"] = 
function(os, obj)
	Serialize(os, obj.id)
	Serialize(os, obj.name)
	Serialize(os, obj.photo)
	Serialize(os, obj.photo_frame)
	if obj.badge_info==nil then
		Serialize(os, 0)
	else
		Serialize(os, #obj.badge_info)
		for i = 1, #obj.badge_info do
			__SerializeStruct(os, "PhotoInfo", obj.badge_info[i])
		end
	end
	Serialize(os, obj.sex)
	Serialize(os, obj.level)
	Serialize(os, obj.zhanli)
	Serialize(os, obj.faction)
	Serialize(os, obj.online)
	Serialize(os, obj.mashu_score)

end

func_list["PvpVideoData"] = 
function(os, obj)
	Serialize(os, obj.video)
	__SerializeStruct(os, "RoleClientPVPInfo", obj.player1)
	__SerializeStruct(os, "RoleClientPVPInfo", obj.player2)
	Serialize(os, obj.win_flag)
	Serialize(os, obj.time)
	Serialize(os, obj.match_pvp)

end

func_list["NameId"] = 
function(os, obj)
	Serialize(os, obj.name)
	Serialize(os, obj.id)

end

func_list["HotPvpVideo"] = 
function(os, obj)
	Serialize(os, obj.seq)
	__SerializeStruct(os, "PvpVideoBrief", obj.video)
	Serialize(os, obj.replayed_count)
	Serialize(os, obj.replayed)

end

func_list["EquipmentInfo"] = 
function(os, obj)
	Serialize(os, obj.tid)
	Serialize(os, obj.hero_id)
	Serialize(os, obj.level)
	Serialize(os, obj.order)
	Serialize(os, obj.level_up_money)
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

end

func_list["JieYiInfo"] = 
function(os, obj)
	Serialize(os, obj.id)
	Serialize(os, obj.name)
	Serialize(os, obj.level)
	Serialize(os, obj.photo)
	Serialize(os, obj.accept)
	Serialize(os, obj.ready)
	Serialize(os, obj.time)

end

func_list["MafiaNoticeInfo"] = 
function(os, obj)
	Serialize(os, obj.typ)
	Serialize(os, obj.id)
	Serialize(os, obj.time)
	if obj.num_info==nil then
		Serialize(os, 0)
	else
		Serialize(os, #obj.num_info)
		for i = 1, #obj.num_info do
			Serialize(os, obj.num_info[i])
		end
	end
	if obj.role_info==nil then
		Serialize(os, 0)
	else
		Serialize(os, #obj.role_info)
		for i = 1, #obj.role_info do
			__SerializeStruct(os, "MafiaNoticeRoleInfo", obj.role_info[i])
		end
	end

end

func_list["DailyInfo"] = 
function(os, obj)
	Serialize(os, obj.sign_date)
	Serialize(os, obj.today_flag)
	Serialize(os, obj.little_fudai)
	Serialize(os, obj.big_fudai)

end

func_list["Item"] = 
function(os, obj)
	Serialize(os, obj.tid)
	Serialize(os, obj.count)

end

func_list["WeaponItem"] = 
function(os, obj)
	__SerializeStruct(os, "Item", obj.base_item)
	__SerializeStruct(os, "WeaponInfo", obj.weapon_info)

end

func_list["PvpOperation"] = 
function(os, obj)
	Serialize(os, obj.tick)
	Serialize(os, obj.first_operation)
	Serialize(os, obj.second_operation)

end

func_list["BattlePositionBuff"] = 
function(os, obj)
	Serialize(os, obj.id)
	Serialize(os, obj.pos)
	Serialize(os, obj.buff_id)

end

func_list["BattleFieldNpcMoveInfo"] = 
function(os, obj)
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
	Serialize(os, obj.mymoraleresult)
	if obj.foemoraleresult==nil then
		Serialize(os, 0)
	else
		Serialize(os, #obj.foemoraleresult)
		for i = 1, #obj.foemoraleresult do
			__SerializeStruct(os, "MoraleData", obj.foemoraleresult[i])
		end
	end

end

func_list["RoleTaskCondition"] = 
function(os, obj)
	Serialize(os, obj.current_num)
	Serialize(os, obj.max_num)

end

func_list["MovePos"] = 
function(os, obj)
	Serialize(os, obj.npc_id)
	Serialize(os, obj.pos)

end

func_list["TongQueTaiHeroInfo"] = 
function(os, obj)
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

end


