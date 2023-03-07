--DONT CHANGE ME!

local func_list = {}

function DeserializeStruct(is, is_idx, __type__)
	local item = {}

	if func_list[__type__] ~= nil then
		return	func_list[__type__](is, is_idx, item)
	else
		error("wrong structure type: "..__type__)		
	end
end


func_list["RoleHeroHall"] =
function(is, is_idx, item)
	local count = 0
	is_idx, count = Deserialize(is, is_idx, "number")
	item.heros = {}
	for i = 1, count do
		is_idx, item.heros[i] = DeserializeStruct(is, is_idx, "RoleHero")
	end

	return is_idx, item
end

func_list["MaShuFightFriendInfo"] =
function(is, is_idx, item)
	is_idx, item.role_id = Deserialize(is, is_idx, "string")
	is_idx, item.name = Deserialize(is, is_idx, "string")
	is_idx, item.zhanli = Deserialize(is, is_idx, "number")

	return is_idx, item
end

func_list["MilitaryStageInfo"] =
function(is, is_idx, item)
	is_idx, item.stage_id = Deserialize(is, is_idx, "number")
	is_idx, item.times = Deserialize(is, is_idx, "number")
	is_idx, item.cd = Deserialize(is, is_idx, "number")

	return is_idx, item
end

func_list["RolePVPInfo"] =
function(is, is_idx, item)
	is_idx, item.brief = DeserializeStruct(is, is_idx, "RoleBrief")
	local count = 0
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

	return is_idx, item
end

func_list["AnotherRoleData"] =
function(is, is_idx, item)
	is_idx, item.brief = DeserializeStruct(is, is_idx, "RoleBrief")
	is_idx, item.zhanli = Deserialize(is, is_idx, "number")
	is_idx, item.mafia_position = Deserialize(is, is_idx, "number")
	is_idx, item.time = Deserialize(is, is_idx, "number")

	return is_idx, item
end

func_list["PVEOperation"] =
function(is, is_idx, item)
	is_idx, item.client_tick = Deserialize(is, is_idx, "number")
	is_idx, item.op = Deserialize(is, is_idx, "string")

	return is_idx, item
end

func_list["ShiLianHeroInfo"] =
function(is, is_idx, item)
	is_idx, item.id = Deserialize(is, is_idx, "number")
	is_idx, item.hp = Deserialize(is, is_idx, "number")
	is_idx, item.anger = Deserialize(is, is_idx, "number")

	return is_idx, item
end

func_list["BattleInfo"] =
function(is, is_idx, item)
	is_idx, item.battle_id = Deserialize(is, is_idx, "number")
	is_idx, item.cur_pos = Deserialize(is, is_idx, "number")
	is_idx, item.state = Deserialize(is, is_idx, "number")
	local count = 0
	is_idx, count = Deserialize(is, is_idx, "number")
	item.hero_info = {}
	for i = 1, count do
		is_idx, item.hero_info[i] = DeserializeStruct(is, is_idx, "BattleHeroInfo")
	end
	local count = 0
	is_idx, count = Deserialize(is, is_idx, "number")
	item.cur_hero = {}
	for i = 1, count do
		is_idx, item.cur_hero[i] = Deserialize(is, is_idx, "number")
	end
	local count = 0
	is_idx, count = Deserialize(is, is_idx, "number")
	item.cur_horse_hero = {}
	for i = 1, count do
		is_idx, item.cur_horse_hero[i] = DeserializeStruct(is, is_idx, "BattleHorseHero")
	end
	local count = 0
	is_idx, count = Deserialize(is, is_idx, "number")
	item.position_data = {}
	for i = 1, count do
		is_idx, item.position_data[i] = DeserializeStruct(is, is_idx, "BattlePositionInfo")
	end
	is_idx, item.round_num = Deserialize(is, is_idx, "number")
	is_idx, item.round_flag = Deserialize(is, is_idx, "number")
	is_idx, item.round_state = Deserialize(is, is_idx, "number")
	is_idx, item.cur_morale = Deserialize(is, is_idx, "number")
	is_idx, item.attacked_flag = Deserialize(is, is_idx, "number")
	local count = 0
	is_idx, count = Deserialize(is, is_idx, "number")
	item.info_history = {}
	for i = 1, count do
		is_idx, item.info_history[i] = Deserialize(is, is_idx, "number")
	end

	return is_idx, item
end

func_list["FlowerGiftInfo"] =
function(is, is_idx, item)
	is_idx, item.info = DeserializeStruct(is, is_idx, "RoleBrief")
	is_idx, item.count = Deserialize(is, is_idx, "number")
	is_idx, item.time = Deserialize(is, is_idx, "number")
	is_idx, item.flowermask = Deserialize(is, is_idx, "number")

	return is_idx, item
end

func_list["NoticeParaInfo"] =
function(is, is_idx, item)
	is_idx, item.typ = Deserialize(is, is_idx, "number")
	is_idx, item.id = Deserialize(is, is_idx, "string")
	is_idx, item.name = Deserialize(is, is_idx, "string")
	is_idx, item.num = Deserialize(is, is_idx, "number")
	is_idx, item.text = Deserialize(is, is_idx, "string")

	return is_idx, item
end

func_list["RoleHorseHall"] =
function(is, is_idx, item)
	local count = 0
	is_idx, count = Deserialize(is, is_idx, "number")
	item.horses = {}
	for i = 1, count do
		is_idx, item.horses[i] = DeserializeStruct(is, is_idx, "RoleHorse")
	end

	return is_idx, item
end

func_list["PvpVideoBrief"] =
function(is, is_idx, item)
	is_idx, item.video_id = Deserialize(is, is_idx, "string")
	is_idx, item.player1 = DeserializeStruct(is, is_idx, "RoleClientPVPInfo")
	is_idx, item.player2 = DeserializeStruct(is, is_idx, "RoleClientPVPInfo")
	is_idx, item.win_flag = Deserialize(is, is_idx, "number")
	is_idx, item.time = Deserialize(is, is_idx, "number")
	is_idx, item.match_pvp = Deserialize(is, is_idx, "number")
	is_idx, item.duration = Deserialize(is, is_idx, "number")

	return is_idx, item
end

func_list["InstanceHero"] =
function(is, is_idx, item)
	is_idx, item.typ = Deserialize(is, is_idx, "number")
	is_idx, item.battle_id = Deserialize(is, is_idx, "number")
	is_idx, item.heroinfo = DeserializeStruct(is, is_idx, "RoleLastHero")
	is_idx, item.horse = Deserialize(is, is_idx, "number")

	return is_idx, item
end

func_list["MaShuFriendInfo"] =
function(is, is_idx, item)
	is_idx, item.role_id = Deserialize(is, is_idx, "string")
	is_idx, item.count = Deserialize(is, is_idx, "number")

	return is_idx, item
end

func_list["MafiaApplyRoleInfo"] =
function(is, is_idx, item)
	is_idx, item.id = Deserialize(is, is_idx, "string")
	is_idx, item.name = Deserialize(is, is_idx, "string")
	is_idx, item.photo = Deserialize(is, is_idx, "number")
	is_idx, item.photo_frame = Deserialize(is, is_idx, "number")
	local count = 0
	is_idx, count = Deserialize(is, is_idx, "number")
	item.badge_info = {}
	for i = 1, count do
		is_idx, item.badge_info[i] = DeserializeStruct(is, is_idx, "PhotoInfo")
	end
	is_idx, item.sex = Deserialize(is, is_idx, "number")
	is_idx, item.level = Deserialize(is, is_idx, "number")
	is_idx, item.zhanli = Deserialize(is, is_idx, "number")

	return is_idx, item
end

func_list["FightInfo"] =
function(is, is_idx, item)
	is_idx, item.room_id = Deserialize(is, is_idx, "number")
	is_idx, item.fight1_id = Deserialize(is, is_idx, "string")
	is_idx, item.fight2_id = Deserialize(is, is_idx, "string")
	is_idx, item.fight1_name = Deserialize(is, is_idx, "string")
	is_idx, item.fight2_name = Deserialize(is, is_idx, "string")
	local count = 0
	is_idx, count = Deserialize(is, is_idx, "number")
	item.fight1_hero_hall = {}
	for i = 1, count do
		is_idx, item.fight1_hero_hall[i] = DeserializeStruct(is, is_idx, "RolePVPHero")
	end
	local count = 0
	is_idx, count = Deserialize(is, is_idx, "number")
	item.fight2_hero_hall = {}
	for i = 1, count do
		is_idx, item.fight2_hero_hall[i] = DeserializeStruct(is, is_idx, "RolePVPHero")
	end

	return is_idx, item
end

func_list["MysteryShopInfo"] =
function(is, is_idx, item)
	is_idx, item.shop_id = Deserialize(is, is_idx, "number")
	local count = 0
	is_idx, count = Deserialize(is, is_idx, "number")
	item.shop_item = {}
	for i = 1, count do
		is_idx, item.shop_item[i] = DeserializeStruct(is, is_idx, "MysteryShopItem")
	end

	return is_idx, item
end

func_list["HeroSkill"] =
function(is, is_idx, item)
	is_idx, item.skill_id = Deserialize(is, is_idx, "number")
	is_idx, item.skill_level = Deserialize(is, is_idx, "number")

	return is_idx, item
end

func_list["ChatInfo"] =
function(is, is_idx, item)
	is_idx, item.src = DeserializeStruct(is, is_idx, "RoleBrief")
	is_idx, item.dest = DeserializeStruct(is, is_idx, "RoleBrief")
	is_idx, item.text_content = Deserialize(is, is_idx, "string")
	is_idx, item.speech_content = Deserialize(is, is_idx, "string")
	is_idx, item.time = Deserialize(is, is_idx, "number")
	is_idx, item.typ = Deserialize(is, is_idx, "number")

	return is_idx, item
end

func_list["RoleLastHero"] =
function(is, is_idx, item)
	local count = 0
	is_idx, count = Deserialize(is, is_idx, "number")
	item.info = {}
	for i = 1, count do
		is_idx, item.info[i] = Deserialize(is, is_idx, "number")
	end

	return is_idx, item
end

func_list["CommonUseLimit"] =
function(is, is_idx, item)
	is_idx, item.tid = Deserialize(is, is_idx, "number")
	is_idx, item.count = Deserialize(is, is_idx, "number")

	return is_idx, item
end

func_list["HeroComment"] =
function(is, is_idx, item)
	is_idx, item.role_id = Deserialize(is, is_idx, "string")
	is_idx, item.role_name = Deserialize(is, is_idx, "string")
	is_idx, item.comment = Deserialize(is, is_idx, "string")
	is_idx, item.agree_count = Deserialize(is, is_idx, "number")
	is_idx, item.agree_flag = Deserialize(is, is_idx, "number")
	is_idx, item.time_stamp = Deserialize(is, is_idx, "number")

	return is_idx, item
end

func_list["RoleBrief"] =
function(is, is_idx, item)
	is_idx, item.id = Deserialize(is, is_idx, "string")
	is_idx, item.name = Deserialize(is, is_idx, "string")
	is_idx, item.photo = Deserialize(is, is_idx, "number")
	is_idx, item.photo_frame = Deserialize(is, is_idx, "number")
	local count = 0
	is_idx, count = Deserialize(is, is_idx, "number")
	item.badge_info = {}
	for i = 1, count do
		is_idx, item.badge_info[i] = DeserializeStruct(is, is_idx, "PhotoInfo")
	end
	is_idx, item.sex = Deserialize(is, is_idx, "number")
	is_idx, item.level = Deserialize(is, is_idx, "number")
	is_idx, item.mafia_id = Deserialize(is, is_idx, "string")
	is_idx, item.mafia_name = Deserialize(is, is_idx, "string")
	is_idx, item.zhanli = Deserialize(is, is_idx, "number")

	return is_idx, item
end

func_list["DanMuDataVector"] =
function(is, is_idx, item)
	local count = 0
	is_idx, count = Deserialize(is, is_idx, "number")
	item.info = {}
	for i = 1, count do
		is_idx, item.info[i] = DeserializeStruct(is, is_idx, "DanMuData")
	end

	return is_idx, item
end

func_list["RoleMafia"] =
function(is, is_idx, item)
	is_idx, item.id = Deserialize(is, is_idx, "string")
	is_idx, item.name = Deserialize(is, is_idx, "string")

	return is_idx, item
end

func_list["RefinableData"] =
function(is, is_idx, item)
	is_idx, item.typ = Deserialize(is, is_idx, "number")
	is_idx, item.data = Deserialize(is, is_idx, "number")

	return is_idx, item
end

func_list["BattleHorseHero"] =
function(is, is_idx, item)
	local count = 0
	is_idx, count = Deserialize(is, is_idx, "number")
	item.hero = {}
	for i = 1, count do
		is_idx, item.hero[i] = Deserialize(is, is_idx, "number")
	end
	is_idx, item.horse = Deserialize(is, is_idx, "number")

	return is_idx, item
end

func_list["DifficultyInfo"] =
function(is, is_idx, item)
	is_idx, item.difficulty = Deserialize(is, is_idx, "number")
	is_idx, item.camp = Deserialize(is, is_idx, "number")

	return is_idx, item
end

func_list["WeaponSkill"] =
function(is, is_idx, item)
	is_idx, item.skill_id = Deserialize(is, is_idx, "number")
	is_idx, item.skill_level = Deserialize(is, is_idx, "number")

	return is_idx, item
end

func_list["OpponentInfo"] =
function(is, is_idx, item)
	is_idx, item.id = Deserialize(is, is_idx, "number")
	is_idx, item.alive = Deserialize(is, is_idx, "number")
	is_idx, item.level = Deserialize(is, is_idx, "number")
	is_idx, item.stage = Deserialize(is, is_idx, "number")
	is_idx, item.hp = Deserialize(is, is_idx, "number")
	is_idx, item.anger = Deserialize(is, is_idx, "number")
	is_idx, item.rewardflag = Deserialize(is, is_idx, "number")

	return is_idx, item
end

func_list["DanMuData"] =
function(is, is_idx, item)
	is_idx, item.role_id = Deserialize(is, is_idx, "string")
	is_idx, item.role_name = Deserialize(is, is_idx, "string")
	is_idx, item.tick = Deserialize(is, is_idx, "number")
	is_idx, item.danmu_info = Deserialize(is, is_idx, "string")

	return is_idx, item
end

func_list["PveArenaFighterInfo"] =
function(is, is_idx, item)
	is_idx, item.name = Deserialize(is, is_idx, "string")
	is_idx, item.id = Deserialize(is, is_idx, "string")
	is_idx, item.level = Deserialize(is, is_idx, "number")
	is_idx, item.rank = Deserialize(is, is_idx, "number")
	is_idx, item.score = Deserialize(is, is_idx, "number")
	is_idx, item.hero_score = Deserialize(is, is_idx, "number")
	is_idx, item.mafia_name = Deserialize(is, is_idx, "string")
	is_idx, item.hero_info = DeserializeStruct(is, is_idx, "RolePveArenaInfo")
	is_idx, item.photo = Deserialize(is, is_idx, "number")
	is_idx, item.photo_frame = Deserialize(is, is_idx, "number")
	local count = 0
	is_idx, count = Deserialize(is, is_idx, "number")
	item.badge_info = {}
	for i = 1, count do
		is_idx, item.badge_info[i] = DeserializeStruct(is, is_idx, "PhotoInfo")
	end

	return is_idx, item
end

func_list["SweepInstanceData"] =
function(is, is_idx, item)
	is_idx, item.exp = Deserialize(is, is_idx, "number")
	is_idx, item.heroexp = Deserialize(is, is_idx, "number")
	local count = 0
	is_idx, count = Deserialize(is, is_idx, "number")
	item.item = {}
	for i = 1, count do
		is_idx, item.item[i] = DeserializeStruct(is, is_idx, "DropItem")
	end

	return is_idx, item
end

func_list["MysteryShopItem"] =
function(is, is_idx, item)
	is_idx, item.item_id = Deserialize(is, is_idx, "number")
	is_idx, item.buy_count = Deserialize(is, is_idx, "number")
	is_idx, item.max_count = Deserialize(is, is_idx, "number")

	return is_idx, item
end

func_list["TowerArmyInfoList"] =
function(is, is_idx, item)
	local count = 0
	is_idx, count = Deserialize(is, is_idx, "number")
	item.armyinfo = {}
	for i = 1, count do
		is_idx, item.armyinfo[i] = DeserializeStruct(is, is_idx, "TowerArmyInfo")
	end

	return is_idx, item
end

func_list["RoleCurrentTask"] =
function(is, is_idx, item)
	is_idx, item.id = Deserialize(is, is_idx, "number")
	local count = 0
	is_idx, count = Deserialize(is, is_idx, "number")
	item.condition = {}
	for i = 1, count do
		is_idx, item.condition[i] = DeserializeStruct(is, is_idx, "RoleTaskCondition")
	end

	return is_idx, item
end

func_list["RoleInfo"] =
function(is, is_idx, item)
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
	local count = 0
	is_idx, count = Deserialize(is, is_idx, "number")
	item.pvp_video = {}
	for i = 1, count do
		is_idx, item.pvp_video[i] = DeserializeStruct(is, is_idx, "PvpVideoData")
	end
	local count = 0
	is_idx, count = Deserialize(is, is_idx, "number")
	item.mail_list = {}
	for i = 1, count do
		is_idx, item.mail_list[i] = DeserializeStruct(is, is_idx, "MailInfo")
	end
	local count = 0
	is_idx, count = Deserialize(is, is_idx, "number")
	item.rep_list = {}
	for i = 1, count do
		is_idx, item.rep_list[i] = DeserializeStruct(is, is_idx, "RepInfo")
	end
	local count = 0
	is_idx, count = Deserialize(is, is_idx, "number")
	item.mysteryshop_list = {}
	for i = 1, count do
		is_idx, item.mysteryshop_list[i] = DeserializeStruct(is, is_idx, "MysteryShopInfo")
	end
	local count = 0
	is_idx, count = Deserialize(is, is_idx, "number")
	item.instancehero_info = {}
	for i = 1, count do
		is_idx, item.instancehero_info[i] = DeserializeStruct(is, is_idx, "InstanceHero")
	end
	is_idx, item.pve_arena = DeserializeStruct(is, is_idx, "PveArenaInfo")
	local count = 0
	is_idx, count = Deserialize(is, is_idx, "number")
	item.photo_info = {}
	for i = 1, count do
		is_idx, item.photo_info[i] = DeserializeStruct(is, is_idx, "PhotoInfo")
	end
	local count = 0
	is_idx, count = Deserialize(is, is_idx, "number")
	item.photoframe_info = {}
	for i = 1, count do
		is_idx, item.photoframe_info[i] = DeserializeStruct(is, is_idx, "PhotoInfo")
	end
	is_idx, item.pvp_ver = Deserialize(is, is_idx, "number")
	is_idx, item.daily_info = DeserializeStruct(is, is_idx, "DailyInfo")

	return is_idx, item
end

func_list["SkinItem"] =
function(is, is_idx, item)
	is_idx, item.id = Deserialize(is, is_idx, "number")
	is_idx, item.time = Deserialize(is, is_idx, "number")

	return is_idx, item
end

func_list["RepInfo"] =
function(is, is_idx, item)
	is_idx, item.rep_id = Deserialize(is, is_idx, "number")
	is_idx, item.rep_num = Deserialize(is, is_idx, "number")

	return is_idx, item
end

func_list["LegionJunXueGuanData"] =
function(is, is_idx, item)
	is_idx, item.id = Deserialize(is, is_idx, "number")
	is_idx, item.level = Deserialize(is, is_idx, "number")
	local count = 0
	is_idx, count = Deserialize(is, is_idx, "number")
	item.learned = {}
	for i = 1, count do
		is_idx, item.learned[i] = Deserialize(is, is_idx, "number")
	end

	return is_idx, item
end

func_list["WeaponInfo"] =
function(is, is_idx, item)
	is_idx, item.tid = Deserialize(is, is_idx, "number")
	is_idx, item.level = Deserialize(is, is_idx, "number")
	is_idx, item.star = Deserialize(is, is_idx, "number")
	is_idx, item.quality = Deserialize(is, is_idx, "number")
	is_idx, item.prop = Deserialize(is, is_idx, "number")
	is_idx, item.attack = Deserialize(is, is_idx, "number")
	is_idx, item.strength = Deserialize(is, is_idx, "number")
	is_idx, item.level_up = Deserialize(is, is_idx, "number")
	is_idx, item.weapon_skill = Deserialize(is, is_idx, "number")
	is_idx, item.strength_prob = Deserialize(is, is_idx, "number")
	local count = 0
	is_idx, count = Deserialize(is, is_idx, "number")
	item.skill_pro = {}
	for i = 1, count do
		is_idx, item.skill_pro[i] = DeserializeStruct(is, is_idx, "WeaponSkill")
	end
	is_idx, item.exp = Deserialize(is, is_idx, "number")

	return is_idx, item
end

func_list["MailInfo"] =
function(is, is_idx, item)
	is_idx, item.mail_id = Deserialize(is, is_idx, "number")
	is_idx, item.msg_id = Deserialize(is, is_idx, "number")
	is_idx, item.subject = Deserialize(is, is_idx, "string")
	is_idx, item.context = Deserialize(is, is_idx, "string")
	is_idx, item.time = Deserialize(is, is_idx, "number")
	is_idx, item.from_id = Deserialize(is, is_idx, "string")
	is_idx, item.from_name = Deserialize(is, is_idx, "string")
	local count = 0
	is_idx, count = Deserialize(is, is_idx, "number")
	item.item = {}
	for i = 1, count do
		is_idx, item.item[i] = DeserializeStruct(is, is_idx, "Item")
	end
	local count = 0
	is_idx, count = Deserialize(is, is_idx, "number")
	item.mail_arg = {}
	for i = 1, count do
		is_idx, item.mail_arg[i] = Deserialize(is, is_idx, "string")
	end
	is_idx, item.read_flag = Deserialize(is, is_idx, "number")

	return is_idx, item
end

func_list["BattleDelArmyInfo"] =
function(is, is_idx, item)
	is_idx, item.id = Deserialize(is, is_idx, "number")
	is_idx, item.pos = Deserialize(is, is_idx, "number")
	is_idx, item.npc_id = Deserialize(is, is_idx, "number")
	is_idx, item.army_id = Deserialize(is, is_idx, "number")

	return is_idx, item
end

func_list["RoleHorse"] =
function(is, is_idx, item)
	is_idx, item.tid = Deserialize(is, is_idx, "number")

	return is_idx, item
end

func_list["RolePVPHero"] =
function(is, is_idx, item)
	is_idx, item.tid = Deserialize(is, is_idx, "number")
	is_idx, item.level = Deserialize(is, is_idx, "number")
	is_idx, item.order = Deserialize(is, is_idx, "number")
	is_idx, item.star = Deserialize(is, is_idx, "number")
	is_idx, item.skin = Deserialize(is, is_idx, "number")
	local count = 0
	is_idx, count = Deserialize(is, is_idx, "number")
	item.skill = {}
	for i = 1, count do
		is_idx, item.skill[i] = DeserializeStruct(is, is_idx, "HeroSkill")
	end
	local count = 0
	is_idx, count = Deserialize(is, is_idx, "number")
	item.common_skill = {}
	for i = 1, count do
		is_idx, item.common_skill[i] = DeserializeStruct(is, is_idx, "HeroSkill")
	end
	local count = 0
	is_idx, count = Deserialize(is, is_idx, "number")
	item.select_skill = {}
	for i = 1, count do
		is_idx, item.select_skill[i] = Deserialize(is, is_idx, "number")
	end
	local count = 0
	is_idx, count = Deserialize(is, is_idx, "number")
	item.relations = {}
	for i = 1, count do
		is_idx, item.relations[i] = Deserialize(is, is_idx, "number")
	end
	is_idx, item.weapon = DeserializeStruct(is, is_idx, "WeaponItem")
	local count = 0
	is_idx, count = Deserialize(is, is_idx, "number")
	item.equipment = {}
	for i = 1, count do
		is_idx, item.equipment[i] = DeserializeStruct(is, is_idx, "RolePVPHeroEquipment")
	end

	return is_idx, item
end

func_list["Role_PvpInfo"] =
function(is, is_idx, item)
	is_idx, item.star = Deserialize(is, is_idx, "number")
	is_idx, item.join_count = Deserialize(is, is_idx, "number")
	is_idx, item.win_count = Deserialize(is, is_idx, "number")
	is_idx, item.end_time = Deserialize(is, is_idx, "number")

	return is_idx, item
end

func_list["TowerArmyInfo"] =
function(is, is_idx, item)
	is_idx, item.id = Deserialize(is, is_idx, "number")
	is_idx, item.hp = Deserialize(is, is_idx, "number")
	is_idx, item.anger = Deserialize(is, is_idx, "number")
	is_idx, item.alive = Deserialize(is, is_idx, "number")

	return is_idx, item
end

func_list["TongQueTaiPlayerInfo"] =
function(is, is_idx, item)
	is_idx, item.id = Deserialize(is, is_idx, "string")
	is_idx, item.name = Deserialize(is, is_idx, "string")
	is_idx, item.photo = Deserialize(is, is_idx, "number")
	is_idx, item.photo_frame = Deserialize(is, is_idx, "number")
	local count = 0
	is_idx, count = Deserialize(is, is_idx, "number")
	item.badge_info = {}
	for i = 1, count do
		is_idx, item.badge_info[i] = DeserializeStruct(is, is_idx, "PhotoInfo")
	end
	is_idx, item.level = Deserialize(is, is_idx, "number")
	is_idx, item.fight_num = Deserialize(is, is_idx, "number")
	is_idx, item.auto_flag = Deserialize(is, is_idx, "number")
	local count = 0
	is_idx, count = Deserialize(is, is_idx, "number")
	item.hero_info = {}
	for i = 1, count do
		is_idx, item.hero_info[i] = DeserializeStruct(is, is_idx, "TongQueTaiHeroInfo")
	end

	return is_idx, item
end

func_list["RolePveArenaHero"] =
function(is, is_idx, item)
	is_idx, item.id = Deserialize(is, is_idx, "number")
	is_idx, item.level = Deserialize(is, is_idx, "number")
	is_idx, item.star = Deserialize(is, is_idx, "number")
	is_idx, item.grade = Deserialize(is, is_idx, "number")
	is_idx, item.skin = Deserialize(is, is_idx, "number")
	local count = 0
	is_idx, count = Deserialize(is, is_idx, "number")
	item.skill = {}
	for i = 1, count do
		is_idx, item.skill[i] = DeserializeStruct(is, is_idx, "HeroSkill")
	end
	local count = 0
	is_idx, count = Deserialize(is, is_idx, "number")
	item.common_skill = {}
	for i = 1, count do
		is_idx, item.common_skill[i] = DeserializeStruct(is, is_idx, "HeroSkill")
	end
	local count = 0
	is_idx, count = Deserialize(is, is_idx, "number")
	item.select_skill = {}
	for i = 1, count do
		is_idx, item.select_skill[i] = Deserialize(is, is_idx, "number")
	end
	local count = 0
	is_idx, count = Deserialize(is, is_idx, "number")
	item.relations = {}
	for i = 1, count do
		is_idx, item.relations[i] = Deserialize(is, is_idx, "number")
	end
	is_idx, item.weapon = DeserializeStruct(is, is_idx, "WeaponItem")
	local count = 0
	is_idx, count = Deserialize(is, is_idx, "number")
	item.equipment = {}
	for i = 1, count do
		is_idx, item.equipment[i] = DeserializeStruct(is, is_idx, "RolePveArenaHeroEquipment")
	end

	return is_idx, item
end

func_list["TongQueTaiMonsterState"] =
function(is, is_idx, item)
	is_idx, item.id = Deserialize(is, is_idx, "number")
	is_idx, item.hp = Deserialize(is, is_idx, "number")
	is_idx, item.anger = Deserialize(is, is_idx, "number")
	is_idx, item.alive_flag = Deserialize(is, is_idx, "number")

	return is_idx, item
end

func_list["MafiaBrief"] =
function(is, is_idx, item)
	is_idx, item.id = Deserialize(is, is_idx, "string")
	is_idx, item.name = Deserialize(is, is_idx, "string")
	is_idx, item.flag = Deserialize(is, is_idx, "number")
	is_idx, item.announce = Deserialize(is, is_idx, "string")
	is_idx, item.level = Deserialize(is, is_idx, "number")
	is_idx, item.activity = Deserialize(is, is_idx, "number")
	is_idx, item.boss_id = Deserialize(is, is_idx, "string")
	is_idx, item.boss_name = Deserialize(is, is_idx, "string")
	is_idx, item.level_limit = Deserialize(is, is_idx, "number")
	is_idx, item.num = Deserialize(is, is_idx, "number")
	is_idx, item.xuanyan = Deserialize(is, is_idx, "string")

	return is_idx, item
end

func_list["RolePveArenaHistoryData"] =
function(is, is_idx, item)
	is_idx, item.level = Deserialize(is, is_idx, "number")
	is_idx, item.score = Deserialize(is, is_idx, "number")
	is_idx, item.score_change = Deserialize(is, is_idx, "number")
	is_idx, item.zhanli = Deserialize(is, is_idx, "number")
	is_idx, item.mafia = Deserialize(is, is_idx, "string")
	is_idx, item.photo = Deserialize(is, is_idx, "number")
	is_idx, item.photo_frame = Deserialize(is, is_idx, "number")
	local count = 0
	is_idx, count = Deserialize(is, is_idx, "number")
	item.badge_info = {}
	for i = 1, count do
		is_idx, item.badge_info[i] = DeserializeStruct(is, is_idx, "PhotoInfo")
	end

	return is_idx, item
end

func_list["EquipmentItem"] =
function(is, is_idx, item)
	is_idx, item.base_item = DeserializeStruct(is, is_idx, "Item")
	is_idx, item.equipment_info = DeserializeStruct(is, is_idx, "EquipmentInfo")

	return is_idx, item
end

func_list["DropItem"] =
function(is, is_idx, item)
	is_idx, item.id = Deserialize(is, is_idx, "number")
	is_idx, item.count = Deserialize(is, is_idx, "number")

	return is_idx, item
end

func_list["LotteryRewardInfo"] =
function(is, is_idx, item)
	is_idx, item.id = Deserialize(is, is_idx, "number")
	is_idx, item.num = Deserialize(is, is_idx, "number")
	is_idx, item.firstget = Deserialize(is, is_idx, "number")
	is_idx, item.bproorhero = Deserialize(is, is_idx, "number")

	return is_idx, item
end

func_list["RoleInstance"] =
function(is, is_idx, item)
	is_idx, item.tid = Deserialize(is, is_idx, "number")
	is_idx, item.score = Deserialize(is, is_idx, "number")

	return is_idx, item
end

func_list["TopListItem"] =
function(is, is_idx, item)
	is_idx, item.item_id = Deserialize(is, is_idx, "number")
	is_idx, item.tid = Deserialize(is, is_idx, "number")
	is_idx, item.typ = Deserialize(is, is_idx, "number")

	return is_idx, item
end

func_list["RolePveArenaInfo"] =
function(is, is_idx, item)
	local count = 0
	is_idx, count = Deserialize(is, is_idx, "number")
	item.heroinfo = {}
	for i = 1, count do
		is_idx, item.heroinfo[i] = DeserializeStruct(is, is_idx, "RolePveArenaHero")
	end

	return is_idx, item
end

func_list["MaShuHeroInfo"] =
function(is, is_idx, item)
	is_idx, item.hero_id = Deserialize(is, is_idx, "number")
	is_idx, item.horse_id = Deserialize(is, is_idx, "number")

	return is_idx, item
end

func_list["RolePVPHeroEquipment"] =
function(is, is_idx, item)
	is_idx, item.pos = Deserialize(is, is_idx, "number")
	is_idx, item.item_id = Deserialize(is, is_idx, "number")
	is_idx, item.level = Deserialize(is, is_idx, "number")
	is_idx, item.order = Deserialize(is, is_idx, "number")
	local count = 0
	is_idx, count = Deserialize(is, is_idx, "number")
	item.refinable_pro = {}
	for i = 1, count do
		is_idx, item.refinable_pro[i] = DeserializeStruct(is, is_idx, "RefinableData")
	end

	return is_idx, item
end

func_list["BattleAddArmyInfo"] =
function(is, is_idx, item)
	is_idx, item.id = Deserialize(is, is_idx, "number")
	is_idx, item.pos = Deserialize(is, is_idx, "number")
	is_idx, item.npc_id = Deserialize(is, is_idx, "number")
	is_idx, item.npc_camp = Deserialize(is, is_idx, "number")
	is_idx, item.army_id = Deserialize(is, is_idx, "number")
	is_idx, item.army_buff = Deserialize(is, is_idx, "number")

	return is_idx, item
end

func_list["MafiaNoticeRoleInfo"] =
function(is, is_idx, item)
	is_idx, item.id = Deserialize(is, is_idx, "string")
	is_idx, item.name = Deserialize(is, is_idx, "string")

	return is_idx, item
end

func_list["Chat"] =
function(is, is_idx, item)
	is_idx, item.src_id = Deserialize(is, is_idx, "string")
	is_idx, item.src_name = Deserialize(is, is_idx, "string")
	is_idx, item.time = Deserialize(is, is_idx, "number")
	is_idx, item.content = Deserialize(is, is_idx, "string")

	return is_idx, item
end

func_list["Mafia"] =
function(is, is_idx, item)
	is_idx, item.id = Deserialize(is, is_idx, "string")
	is_idx, item.name = Deserialize(is, is_idx, "string")
	is_idx, item.flag = Deserialize(is, is_idx, "number")
	is_idx, item.announce = Deserialize(is, is_idx, "string")
	is_idx, item.xuanyan = Deserialize(is, is_idx, "string")
	is_idx, item.level = Deserialize(is, is_idx, "number")
	is_idx, item.activity = Deserialize(is, is_idx, "number")
	is_idx, item.boss_id = Deserialize(is, is_idx, "string")
	is_idx, item.boss_name = Deserialize(is, is_idx, "string")
	is_idx, item.exp = Deserialize(is, is_idx, "number")
	is_idx, item.jisi = Deserialize(is, is_idx, "number")
	is_idx, item.mashu_toplist_id = Deserialize(is, is_idx, "number")
	is_idx, item.level_limit = Deserialize(is, is_idx, "number")
	is_idx, item.need_approval = Deserialize(is, is_idx, "number")
	is_idx, item.declaration = Deserialize(is, is_idx, "string")
	local count = 0
	is_idx, count = Deserialize(is, is_idx, "number")
	item.members = {}
	for i = 1, count do
		is_idx, item.members[i] = DeserializeStruct(is, is_idx, "MafiaMember")
	end
	local count = 0
	is_idx, count = Deserialize(is, is_idx, "number")
	item.apply_list = {}
	for i = 1, count do
		is_idx, item.apply_list[i] = DeserializeStruct(is, is_idx, "MafiaApplyRoleInfo")
	end
	local count = 0
	is_idx, count = Deserialize(is, is_idx, "number")
	item.notice = {}
	for i = 1, count do
		is_idx, item.notice[i] = DeserializeStruct(is, is_idx, "MafiaNoticeInfo")
	end
	is_idx, item.declaration_time = Deserialize(is, is_idx, "number")

	return is_idx, item
end

func_list["PvpVideo"] =
function(is, is_idx, item)
	local count = 0
	is_idx, count = Deserialize(is, is_idx, "number")
	item.video = {}
	for i = 1, count do
		is_idx, item.video[i] = DeserializeStruct(is, is_idx, "PvpOperation")
	end

	return is_idx, item
end

func_list["CenterFightInfo"] =
function(is, is_idx, item)
	local count = 0
	is_idx, count = Deserialize(is, is_idx, "number")
	item.info = {}
	for i = 1, count do
		is_idx, item.info[i] = DeserializeStruct(is, is_idx, "CenterFightInfoData")
	end

	return is_idx, item
end

func_list["TopListData"] =
function(is, is_idx, item)
	is_idx, item.id = Deserialize(is, is_idx, "string")
	is_idx, item.name = Deserialize(is, is_idx, "string")
	is_idx, item.photo = Deserialize(is, is_idx, "number")
	is_idx, item.data = Deserialize(is, is_idx, "string")
	is_idx, item.data2 = Deserialize(is, is_idx, "string")
	is_idx, item.level = Deserialize(is, is_idx, "number")
	is_idx, item.item = DeserializeStruct(is, is_idx, "TopListItem")
	is_idx, item.photo_frame = Deserialize(is, is_idx, "number")
	local count = 0
	is_idx, count = Deserialize(is, is_idx, "number")
	item.badge_info = {}
	for i = 1, count do
		is_idx, item.badge_info[i] = DeserializeStruct(is, is_idx, "PhotoInfo")
	end

	return is_idx, item
end

func_list["MafiaInterfaceInfo"] =
function(is, is_idx, item)
	is_idx, item.id = Deserialize(is, is_idx, "string")
	is_idx, item.name = Deserialize(is, is_idx, "string")
	is_idx, item.flag = Deserialize(is, is_idx, "number")
	is_idx, item.announce = Deserialize(is, is_idx, "string")
	is_idx, item.activity = Deserialize(is, is_idx, "number")
	is_idx, item.boss_id = Deserialize(is, is_idx, "string")
	is_idx, item.boss_name = Deserialize(is, is_idx, "string")
	is_idx, item.level_limit = Deserialize(is, is_idx, "number")
	is_idx, item.need_approval = Deserialize(is, is_idx, "number")
	is_idx, item.declaration = Deserialize(is, is_idx, "string")
	is_idx, item.declaration_time = Deserialize(is, is_idx, "number")

	return is_idx, item
end

func_list["RoleClientPVPInfo"] =
function(is, is_idx, item)
	is_idx, item.brief = DeserializeStruct(is, is_idx, "RoleBrief")
	local count = 0
	is_idx, count = Deserialize(is, is_idx, "number")
	item.hero_hall = {}
	for i = 1, count do
		is_idx, item.hero_hall[i] = DeserializeStruct(is, is_idx, "RolePVPHero")
	end
	is_idx, item.pvp_score = Deserialize(is, is_idx, "number")

	return is_idx, item
end

func_list["PhotoInfo"] =
function(is, is_idx, item)
	is_idx, item.id = Deserialize(is, is_idx, "number")
	is_idx, item.typ = Deserialize(is, is_idx, "number")

	return is_idx, item
end

func_list["BattlePosBuff"] =
function(is, is_idx, item)
	is_idx, item.pos = Deserialize(is, is_idx, "number")
	is_idx, item.typ = Deserialize(is, is_idx, "number")
	is_idx, item.num = Deserialize(is, is_idx, "number")

	return is_idx, item
end

func_list["RoleHero"] =
function(is, is_idx, item)
	is_idx, item.tid = Deserialize(is, is_idx, "number")
	is_idx, item.level = Deserialize(is, is_idx, "number")
	is_idx, item.order = Deserialize(is, is_idx, "number")
	is_idx, item.exp = Deserialize(is, is_idx, "number")
	is_idx, item.star = Deserialize(is, is_idx, "number")
	is_idx, item.skillpoint = Deserialize(is, is_idx, "number")
	local count = 0
	is_idx, count = Deserialize(is, is_idx, "number")
	item.skill = {}
	for i = 1, count do
		is_idx, item.skill[i] = DeserializeStruct(is, is_idx, "HeroSkill")
	end
	local count = 0
	is_idx, count = Deserialize(is, is_idx, "number")
	item.common_skill = {}
	for i = 1, count do
		is_idx, item.common_skill[i] = DeserializeStruct(is, is_idx, "HeroSkill")
	end
	is_idx, item.hero_pvp_info = DeserializeStruct(is, is_idx, "HeroPvpInfoData")
	local count = 0
	is_idx, count = Deserialize(is, is_idx, "number")
	item.select_skill = {}
	for i = 1, count do
		is_idx, item.select_skill[i] = Deserialize(is, is_idx, "number")
	end
	is_idx, item.weapon_id = Deserialize(is, is_idx, "number")
	is_idx, item.skin_id = Deserialize(is, is_idx, "number")
	local count = 0
	is_idx, count = Deserialize(is, is_idx, "number")
	item.equipment = {}
	for i = 1, count do
		is_idx, item.equipment[i] = DeserializeStruct(is, is_idx, "EquipmentPosInfo")
	end

	return is_idx, item
end

func_list["RolePveArenaHeroEquipment"] =
function(is, is_idx, item)
	is_idx, item.pos = Deserialize(is, is_idx, "number")
	is_idx, item.item_id = Deserialize(is, is_idx, "number")
	is_idx, item.level = Deserialize(is, is_idx, "number")
	is_idx, item.order = Deserialize(is, is_idx, "number")
	local count = 0
	is_idx, count = Deserialize(is, is_idx, "number")
	item.refinable_pro = {}
	for i = 1, count do
		is_idx, item.refinable_pro[i] = DeserializeStruct(is, is_idx, "RefinableData")
	end

	return is_idx, item
end

func_list["BattleNPCInfo"] =
function(is, is_idx, item)
	is_idx, item.id = Deserialize(is, is_idx, "number")
	is_idx, item.camp = Deserialize(is, is_idx, "number")
	is_idx, item.armyid = Deserialize(is, is_idx, "number")
	is_idx, item.alive = Deserialize(is, is_idx, "number")
	is_idx, item.event_flag = Deserialize(is, is_idx, "number")
	is_idx, item.army_buff = Deserialize(is, is_idx, "number")
	is_idx, item.next_pos = Deserialize(is, is_idx, "number")

	return is_idx, item
end

func_list["RoleStatus"] =
function(is, is_idx, item)
	is_idx, item.level = Deserialize(is, is_idx, "number")
	is_idx, item.exp = Deserialize(is, is_idx, "string")
	is_idx, item.vp = Deserialize(is, is_idx, "number")
	local count = 0
	is_idx, count = Deserialize(is, is_idx, "number")
	item.instances = {}
	for i = 1, count do
		is_idx, item.instances[i] = DeserializeStruct(is, is_idx, "RoleInstance")
	end
	is_idx, item.money = Deserialize(is, is_idx, "number")
	is_idx, item.yuanbao = Deserialize(is, is_idx, "number")
	local count = 0
	is_idx, count = Deserialize(is, is_idx, "number")
	item.common_use_limit = {}
	for i = 1, count do
		is_idx, item.common_use_limit[i] = DeserializeStruct(is, is_idx, "CommonUseLimit")
	end
	is_idx, item.chongzhi = Deserialize(is, is_idx, "number")
	is_idx, item.hero_skill_point = Deserialize(is, is_idx, "number")
	is_idx, item.lottery_one_flag = Deserialize(is, is_idx, "number")
	is_idx, item.lottery_ten_flag = Deserialize(is, is_idx, "number")

	return is_idx, item
end

func_list["RolePveArenaHistoryInfo"] =
function(is, is_idx, item)
	is_idx, item.match_id = Deserialize(is, is_idx, "number")
	is_idx, item.id = Deserialize(is, is_idx, "string")
	is_idx, item.name = Deserialize(is, is_idx, "string")
	is_idx, item.win_flag = Deserialize(is, is_idx, "number")
	is_idx, item.attack_flag = Deserialize(is, is_idx, "number")
	is_idx, item.time = Deserialize(is, is_idx, "number")
	is_idx, item.reply_flag = Deserialize(is, is_idx, "number")
	is_idx, item.self_info = DeserializeStruct(is, is_idx, "RolePveArenaHistoryData")
	is_idx, item.oppo_info = DeserializeStruct(is, is_idx, "RolePveArenaHistoryData")

	return is_idx, item
end

func_list["BattlePositionInfo"] =
function(is, is_idx, item)
	is_idx, item.id = Deserialize(is, is_idx, "number")
	is_idx, item.position = Deserialize(is, is_idx, "number")
	is_idx, item.flag = Deserialize(is, is_idx, "number")
	is_idx, item.event_flag = Deserialize(is, is_idx, "number")
	is_idx, item.pos_buff = Deserialize(is, is_idx, "number")
	local count = 0
	is_idx, count = Deserialize(is, is_idx, "number")
	item.npc_info = {}
	for i = 1, count do
		is_idx, item.npc_info[i] = DeserializeStruct(is, is_idx, "BattleNPCInfo")
	end

	return is_idx, item
end

func_list["EquipmentPosInfo"] =
function(is, is_idx, item)
	is_idx, item.pos = Deserialize(is, is_idx, "number")
	is_idx, item.equipment_id = Deserialize(is, is_idx, "number")

	return is_idx, item
end

func_list["RoleBase"] =
function(is, is_idx, item)
	is_idx, item.id = Deserialize(is, is_idx, "string")
	is_idx, item.name = Deserialize(is, is_idx, "string")
	is_idx, item.photo = Deserialize(is, is_idx, "number")
	is_idx, item.sex = Deserialize(is, is_idx, "number")
	is_idx, item.photo_frame = Deserialize(is, is_idx, "number")
	local count = 0
	is_idx, count = Deserialize(is, is_idx, "number")
	item.badge_info = {}
	for i = 1, count do
		is_idx, item.badge_info[i] = DeserializeStruct(is, is_idx, "PhotoInfo")
	end

	return is_idx, item
end

func_list["InstanceInfo"] =
function(is, is_idx, item)
	is_idx, item.id = Deserialize(is, is_idx, "number")
	is_idx, item.star = Deserialize(is, is_idx, "number")

	return is_idx, item
end

func_list["Condition"] =
function(is, is_idx, item)
	is_idx, item.current = Deserialize(is, is_idx, "number")
	is_idx, item.max = Deserialize(is, is_idx, "number")

	return is_idx, item
end

func_list["LotteryInfo"] =
function(is, is_idx, item)
	is_idx, item.lottery_id = Deserialize(is, is_idx, "number")
	is_idx, item.last_time = Deserialize(is, is_idx, "number")
	is_idx, item.select_id = Deserialize(is, is_idx, "number")

	return is_idx, item
end

func_list["BattleArmyBuff"] =
function(is, is_idx, item)
	is_idx, item.id = Deserialize(is, is_idx, "number")
	is_idx, item.pos = Deserialize(is, is_idx, "number")
	is_idx, item.army = Deserialize(is, is_idx, "number")
	is_idx, item.typ = Deserialize(is, is_idx, "number")
	is_idx, item.buff_id = Deserialize(is, is_idx, "number")

	return is_idx, item
end

func_list["HeroPvpInfoData"] =
function(is, is_idx, item)
	is_idx, item.id = Deserialize(is, is_idx, "number")
	is_idx, item.join_count = Deserialize(is, is_idx, "number")
	is_idx, item.win_count = Deserialize(is, is_idx, "number")

	return is_idx, item
end

func_list["UpgradeSkillInfo"] =
function(is, is_idx, item)
	is_idx, item.skill_id = Deserialize(is, is_idx, "number")
	is_idx, item.level = Deserialize(is, is_idx, "number")

	return is_idx, item
end

func_list["BattleHeroInfo"] =
function(is, is_idx, item)
	is_idx, item.hero_id = Deserialize(is, is_idx, "number")
	is_idx, item.hp = Deserialize(is, is_idx, "number")

	return is_idx, item
end

func_list["MaShuBuffInfo"] =
function(is, is_idx, item)
	is_idx, item.id = Deserialize(is, is_idx, "number")
	is_idx, item.buffer_id = Deserialize(is, is_idx, "number")
	is_idx, item.typ = Deserialize(is, is_idx, "number")

	return is_idx, item
end

func_list["TowerBuffInfo"] =
function(is, is_idx, item)
	is_idx, item.typ = Deserialize(is, is_idx, "number")
	is_idx, item.data = Deserialize(is, is_idx, "number")

	return is_idx, item
end

func_list["TongQueTaiOperation"] =
function(is, is_idx, item)
	is_idx, item.client_tick = Deserialize(is, is_idx, "number")
	is_idx, item.op = Deserialize(is, is_idx, "string")

	return is_idx, item
end

func_list["RoleUserDefine"] =
function(is, is_idx, item)
	local count = 0
	is_idx, count = Deserialize(is, is_idx, "number")
	item.role_define = {}
	for i = 1, count do
		is_idx, item.role_define[i] = DeserializeStruct(is, is_idx, "RoleUserDefineData")
	end

	return is_idx, item
end

func_list["MafiaMember"] =
function(is, is_idx, item)
	is_idx, item.id = Deserialize(is, is_idx, "string")
	is_idx, item.name = Deserialize(is, is_idx, "string")
	is_idx, item.photo = Deserialize(is, is_idx, "number")
	is_idx, item.photo_frame = Deserialize(is, is_idx, "number")
	local count = 0
	is_idx, count = Deserialize(is, is_idx, "number")
	item.badge_info = {}
	for i = 1, count do
		is_idx, item.badge_info[i] = DeserializeStruct(is, is_idx, "PhotoInfo")
	end
	is_idx, item.sex = Deserialize(is, is_idx, "number")
	is_idx, item.level = Deserialize(is, is_idx, "number")
	is_idx, item.zhanli = Deserialize(is, is_idx, "number")
	is_idx, item.activity = Deserialize(is, is_idx, "number")
	is_idx, item.position = Deserialize(is, is_idx, "number")
	is_idx, item.logout_time = Deserialize(is, is_idx, "number")
	is_idx, item.online = Deserialize(is, is_idx, "number")
	local count = 0
	is_idx, count = Deserialize(is, is_idx, "number")
	item.contrabution = {}
	for i = 1, count do
		is_idx, item.contrabution[i] = Deserialize(is, is_idx, "number")
	end

	return is_idx, item
end

func_list["PveArenaOperation"] =
function(is, is_idx, item)
	local count = 0
	is_idx, count = Deserialize(is, is_idx, "number")
	item.operation = {}
	for i = 1, count do
		is_idx, item.operation[i] = DeserializeStruct(is, is_idx, "PVEOperation")
	end

	return is_idx, item
end

func_list["PVPFighter"] =
function(is, is_idx, item)
	is_idx, item.id = Deserialize(is, is_idx, "string")
	local count = 0
	is_idx, count = Deserialize(is, is_idx, "number")
	item.ops = {}
	for i = 1, count do
		is_idx, item.ops[i] = Deserialize(is, is_idx, "number")
	end

	return is_idx, item
end

func_list["BattleEventInfo"] =
function(is, is_idx, item)
	is_idx, item.event_id = Deserialize(is, is_idx, "number")
	is_idx, item.plot_dia_id = Deserialize(is, is_idx, "number")
	is_idx, item.battle_dialog_id = Deserialize(is, is_idx, "number")
	local count = 0
	is_idx, count = Deserialize(is, is_idx, "number")
	item.del_army_id = {}
	for i = 1, count do
		is_idx, item.del_army_id[i] = DeserializeStruct(is, is_idx, "BattleDelArmyInfo")
	end
	local count = 0
	is_idx, count = Deserialize(is, is_idx, "number")
	item.add_army_info = {}
	for i = 1, count do
		is_idx, item.add_army_info[i] = DeserializeStruct(is, is_idx, "BattleAddArmyInfo")
	end
	local count = 0
	is_idx, count = Deserialize(is, is_idx, "number")
	item.item = {}
	for i = 1, count do
		is_idx, item.item[i] = DeserializeStruct(is, is_idx, "Item")
	end
	local count = 0
	is_idx, count = Deserialize(is, is_idx, "number")
	item.position_buff = {}
	for i = 1, count do
		is_idx, item.position_buff[i] = DeserializeStruct(is, is_idx, "BattlePositionBuff")
	end
	local count = 0
	is_idx, count = Deserialize(is, is_idx, "number")
	item.army_buff = {}
	for i = 1, count do
		is_idx, item.army_buff[i] = DeserializeStruct(is, is_idx, "BattleArmyBuff")
	end
	local count = 0
	is_idx, count = Deserialize(is, is_idx, "number")
	item.del_pos_buff = {}
	for i = 1, count do
		is_idx, item.del_pos_buff[i] = Deserialize(is, is_idx, "number")
	end
	local count = 0
	is_idx, count = Deserialize(is, is_idx, "number")
	item.pos_army_buff = {}
	for i = 1, count do
		is_idx, item.pos_army_buff[i] = DeserializeStruct(is, is_idx, "BattlePosBuff")
	end
	is_idx, item.remove_round_limit = Deserialize(is, is_idx, "number")
	is_idx, item.self_morale_change_typ = Deserialize(is, is_idx, "number")
	is_idx, item.self_morale_change_num = Deserialize(is, is_idx, "number")
	is_idx, item.trigger_results = Deserialize(is, is_idx, "number")

	return is_idx, item
end

func_list["PveArenaInfo"] =
function(is, is_idx, item)
	is_idx, item.video_flag = Deserialize(is, is_idx, "number")

	return is_idx, item
end

func_list["Instance_Star_Condition"] =
function(is, is_idx, item)
	is_idx, item.tid = Deserialize(is, is_idx, "number")
	is_idx, item.flag = Deserialize(is, is_idx, "number")

	return is_idx, item
end

func_list["InjuredHeroInfo"] =
function(is, is_idx, item)
	is_idx, item.id = Deserialize(is, is_idx, "number")
	is_idx, item.hp = Deserialize(is, is_idx, "number")
	is_idx, item.anger = Deserialize(is, is_idx, "number")

	return is_idx, item
end

func_list["TongQueTaiMonsterInfo"] =
function(is, is_idx, item)
	is_idx, item.id = Deserialize(is, is_idx, "string")
	is_idx, item.name = Deserialize(is, is_idx, "string")
	is_idx, item.photo = Deserialize(is, is_idx, "number")
	is_idx, item.photo_frame = Deserialize(is, is_idx, "number")
	local count = 0
	is_idx, count = Deserialize(is, is_idx, "number")
	item.badge_info = {}
	for i = 1, count do
		is_idx, item.badge_info[i] = DeserializeStruct(is, is_idx, "PhotoInfo")
	end
	is_idx, item.level = Deserialize(is, is_idx, "number")
	is_idx, item.fight_num = Deserialize(is, is_idx, "number")
	is_idx, item.npc_flag = Deserialize(is, is_idx, "number")
	local count = 0
	is_idx, count = Deserialize(is, is_idx, "number")
	item.hero_info = {}
	for i = 1, count do
		is_idx, item.hero_info[i] = DeserializeStruct(is, is_idx, "TongQueTaiHeroInfo")
	end

	return is_idx, item
end

func_list["MoraleData"] =
function(is, is_idx, item)
	is_idx, item.npc_id = Deserialize(is, is_idx, "number")
	is_idx, item.morale = Deserialize(is, is_idx, "number")

	return is_idx, item
end

func_list["RoleUserDefineData"] =
function(is, is_idx, item)
	is_idx, item.id = Deserialize(is, is_idx, "number")
	is_idx, item.value_define = Deserialize(is, is_idx, "string")

	return is_idx, item
end

func_list["TemporaryBackPackData"] =
function(is, is_idx, item)
	is_idx, item.id = Deserialize(is, is_idx, "number")
	is_idx, item.typ = Deserialize(is, is_idx, "number")
	local count = 0
	is_idx, count = Deserialize(is, is_idx, "number")
	item.items = {}
	for i = 1, count do
		is_idx, item.items[i] = DeserializeStruct(is, is_idx, "Item")
	end

	return is_idx, item
end

func_list["RoleBackPack"] =
function(is, is_idx, item)
	is_idx, item.capacity = Deserialize(is, is_idx, "number")
	local count = 0
	is_idx, count = Deserialize(is, is_idx, "number")
	item.items = {}
	for i = 1, count do
		is_idx, item.items[i] = DeserializeStruct(is, is_idx, "Item")
	end
	local count = 0
	is_idx, count = Deserialize(is, is_idx, "number")
	item.weaponitems = {}
	for i = 1, count do
		is_idx, item.weaponitems[i] = DeserializeStruct(is, is_idx, "WeaponItem")
	end
	local count = 0
	is_idx, count = Deserialize(is, is_idx, "number")
	item.equipmentitems = {}
	for i = 1, count do
		is_idx, item.equipmentitems[i] = DeserializeStruct(is, is_idx, "EquipmentItem")
	end
	local count = 0
	is_idx, count = Deserialize(is, is_idx, "number")
	item.skinitems = {}
	for i = 1, count do
		is_idx, item.skinitems[i] = DeserializeStruct(is, is_idx, "SkinItem")
	end

	return is_idx, item
end

func_list["RoleTask"] =
function(is, is_idx, item)
	local count = 0
	is_idx, count = Deserialize(is, is_idx, "number")
	item.finish = {}
	for i = 1, count do
		is_idx, item.finish[i] = Deserialize(is, is_idx, "number")
	end
	local count = 0
	is_idx, count = Deserialize(is, is_idx, "number")
	item.current = {}
	for i = 1, count do
		is_idx, item.current[i] = DeserializeStruct(is, is_idx, "RoleCurrentTask")
	end

	return is_idx, item
end

func_list["HeroSoul"] =
function(is, is_idx, item)
	is_idx, item.soul_id = Deserialize(is, is_idx, "number")
	is_idx, item.soul_num = Deserialize(is, is_idx, "number")

	return is_idx, item
end

func_list["CenterFightInfoData"] =
function(is, is_idx, item)
	is_idx, item.room_id = Deserialize(is, is_idx, "number")
	is_idx, item.fight1_info = DeserializeStruct(is, is_idx, "RolePVPInfo")
	is_idx, item.fight2_info = DeserializeStruct(is, is_idx, "RolePVPInfo")

	return is_idx, item
end

func_list["MafiaSelfInfo"] =
function(is, is_idx, item)
	is_idx, item.id = Deserialize(is, is_idx, "string")
	is_idx, item.name = Deserialize(is, is_idx, "string")
	is_idx, item.position = Deserialize(is, is_idx, "number")
	local count = 0
	is_idx, count = Deserialize(is, is_idx, "number")
	item.apply_mafia = {}
	for i = 1, count do
		is_idx, item.apply_mafia[i] = Deserialize(is, is_idx, "string")
	end

	return is_idx, item
end

func_list["Friend"] =
function(is, is_idx, item)
	is_idx, item.id = Deserialize(is, is_idx, "string")
	is_idx, item.name = Deserialize(is, is_idx, "string")
	is_idx, item.photo = Deserialize(is, is_idx, "number")
	is_idx, item.photo_frame = Deserialize(is, is_idx, "number")
	local count = 0
	is_idx, count = Deserialize(is, is_idx, "number")
	item.badge_info = {}
	for i = 1, count do
		is_idx, item.badge_info[i] = DeserializeStruct(is, is_idx, "PhotoInfo")
	end
	is_idx, item.sex = Deserialize(is, is_idx, "number")
	is_idx, item.level = Deserialize(is, is_idx, "number")
	is_idx, item.zhanli = Deserialize(is, is_idx, "number")
	is_idx, item.faction = Deserialize(is, is_idx, "number")
	is_idx, item.online = Deserialize(is, is_idx, "number")
	is_idx, item.mashu_score = Deserialize(is, is_idx, "number")

	return is_idx, item
end

func_list["PvpVideoData"] =
function(is, is_idx, item)
	is_idx, item.video = Deserialize(is, is_idx, "string")
	is_idx, item.player1 = DeserializeStruct(is, is_idx, "RoleClientPVPInfo")
	is_idx, item.player2 = DeserializeStruct(is, is_idx, "RoleClientPVPInfo")
	is_idx, item.win_flag = Deserialize(is, is_idx, "number")
	is_idx, item.time = Deserialize(is, is_idx, "number")
	is_idx, item.match_pvp = Deserialize(is, is_idx, "number")

	return is_idx, item
end

func_list["NameId"] =
function(is, is_idx, item)
	is_idx, item.name = Deserialize(is, is_idx, "string")
	is_idx, item.id = Deserialize(is, is_idx, "string")

	return is_idx, item
end

func_list["HotPvpVideo"] =
function(is, is_idx, item)
	is_idx, item.seq = Deserialize(is, is_idx, "number")
	is_idx, item.video = DeserializeStruct(is, is_idx, "PvpVideoBrief")
	is_idx, item.replayed_count = Deserialize(is, is_idx, "number")
	is_idx, item.replayed = Deserialize(is, is_idx, "boolean")

	return is_idx, item
end

func_list["EquipmentInfo"] =
function(is, is_idx, item)
	is_idx, item.tid = Deserialize(is, is_idx, "number")
	is_idx, item.hero_id = Deserialize(is, is_idx, "number")
	is_idx, item.level = Deserialize(is, is_idx, "number")
	is_idx, item.order = Deserialize(is, is_idx, "number")
	is_idx, item.level_up_money = Deserialize(is, is_idx, "number")
	local count = 0
	is_idx, count = Deserialize(is, is_idx, "number")
	item.refinable_pro = {}
	for i = 1, count do
		is_idx, item.refinable_pro[i] = DeserializeStruct(is, is_idx, "RefinableData")
	end
	local count = 0
	is_idx, count = Deserialize(is, is_idx, "number")
	item.tmp_refinable_pro = {}
	for i = 1, count do
		is_idx, item.tmp_refinable_pro[i] = DeserializeStruct(is, is_idx, "RefinableData")
	end

	return is_idx, item
end

func_list["JieYiInfo"] =
function(is, is_idx, item)
	is_idx, item.id = Deserialize(is, is_idx, "string")
	is_idx, item.name = Deserialize(is, is_idx, "string")
	is_idx, item.level = Deserialize(is, is_idx, "number")
	is_idx, item.photo = Deserialize(is, is_idx, "number")
	is_idx, item.accept = Deserialize(is, is_idx, "number")
	is_idx, item.ready = Deserialize(is, is_idx, "number")
	is_idx, item.time = Deserialize(is, is_idx, "number")

	return is_idx, item
end

func_list["MafiaNoticeInfo"] =
function(is, is_idx, item)
	is_idx, item.typ = Deserialize(is, is_idx, "number")
	is_idx, item.id = Deserialize(is, is_idx, "number")
	is_idx, item.time = Deserialize(is, is_idx, "number")
	local count = 0
	is_idx, count = Deserialize(is, is_idx, "number")
	item.num_info = {}
	for i = 1, count do
		is_idx, item.num_info[i] = Deserialize(is, is_idx, "number")
	end
	local count = 0
	is_idx, count = Deserialize(is, is_idx, "number")
	item.role_info = {}
	for i = 1, count do
		is_idx, item.role_info[i] = DeserializeStruct(is, is_idx, "MafiaNoticeRoleInfo")
	end

	return is_idx, item
end

func_list["DailyInfo"] =
function(is, is_idx, item)
	is_idx, item.sign_date = Deserialize(is, is_idx, "number")
	is_idx, item.today_flag = Deserialize(is, is_idx, "number")
	is_idx, item.little_fudai = Deserialize(is, is_idx, "number")
	is_idx, item.big_fudai = Deserialize(is, is_idx, "number")

	return is_idx, item
end

func_list["Item"] =
function(is, is_idx, item)
	is_idx, item.tid = Deserialize(is, is_idx, "number")
	is_idx, item.count = Deserialize(is, is_idx, "number")

	return is_idx, item
end

func_list["WeaponItem"] =
function(is, is_idx, item)
	is_idx, item.base_item = DeserializeStruct(is, is_idx, "Item")
	is_idx, item.weapon_info = DeserializeStruct(is, is_idx, "WeaponInfo")

	return is_idx, item
end

func_list["PvpOperation"] =
function(is, is_idx, item)
	is_idx, item.tick = Deserialize(is, is_idx, "number")
	is_idx, item.first_operation = Deserialize(is, is_idx, "string")
	is_idx, item.second_operation = Deserialize(is, is_idx, "string")

	return is_idx, item
end

func_list["BattlePositionBuff"] =
function(is, is_idx, item)
	is_idx, item.id = Deserialize(is, is_idx, "number")
	is_idx, item.pos = Deserialize(is, is_idx, "number")
	is_idx, item.buff_id = Deserialize(is, is_idx, "number")

	return is_idx, item
end

func_list["BattleFieldNpcMoveInfo"] =
function(is, is_idx, item)
	is_idx, item.npc_id = Deserialize(is, is_idx, "number")
	is_idx, item.source_pos = Deserialize(is, is_idx, "number")
	is_idx, item.move_pos = Deserialize(is, is_idx, "number")
	is_idx, item.battle_flag = Deserialize(is, is_idx, "number")
	local count = 0
	is_idx, count = Deserialize(is, is_idx, "number")
	item.move_event = {}
	for i = 1, count do
		is_idx, item.move_event[i] = DeserializeStruct(is, is_idx, "BattleEventInfo")
	end
	local count = 0
	is_idx, count = Deserialize(is, is_idx, "number")
	item.capture_event = {}
	for i = 1, count do
		is_idx, item.capture_event[i] = DeserializeStruct(is, is_idx, "BattleEventInfo")
	end
	is_idx, item.mymoraleresult = Deserialize(is, is_idx, "number")
	local count = 0
	is_idx, count = Deserialize(is, is_idx, "number")
	item.foemoraleresult = {}
	for i = 1, count do
		is_idx, item.foemoraleresult[i] = DeserializeStruct(is, is_idx, "MoraleData")
	end

	return is_idx, item
end

func_list["RoleTaskCondition"] =
function(is, is_idx, item)
	is_idx, item.current_num = Deserialize(is, is_idx, "number")
	is_idx, item.max_num = Deserialize(is, is_idx, "number")

	return is_idx, item
end

func_list["MovePos"] =
function(is, is_idx, item)
	is_idx, item.npc_id = Deserialize(is, is_idx, "number")
	is_idx, item.pos = Deserialize(is, is_idx, "number")

	return is_idx, item
end

func_list["TongQueTaiHeroInfo"] =
function(is, is_idx, item)
	is_idx, item.id = Deserialize(is, is_idx, "number")
	is_idx, item.level = Deserialize(is, is_idx, "number")
	is_idx, item.star = Deserialize(is, is_idx, "number")
	is_idx, item.grade = Deserialize(is, is_idx, "number")
	local count = 0
	is_idx, count = Deserialize(is, is_idx, "number")
	item.skill = {}
	for i = 1, count do
		is_idx, item.skill[i] = DeserializeStruct(is, is_idx, "HeroSkill")
	end
	local count = 0
	is_idx, count = Deserialize(is, is_idx, "number")
	item.common_skill = {}
	for i = 1, count do
		is_idx, item.common_skill[i] = DeserializeStruct(is, is_idx, "HeroSkill")
	end
	local count = 0
	is_idx, count = Deserialize(is, is_idx, "number")
	item.select_skill = {}
	for i = 1, count do
		is_idx, item.select_skill[i] = Deserialize(is, is_idx, "number")
	end
	local count = 0
	is_idx, count = Deserialize(is, is_idx, "number")
	item.relations = {}
	for i = 1, count do
		is_idx, item.relations[i] = Deserialize(is, is_idx, "number")
	end
	is_idx, item.weapon = DeserializeStruct(is, is_idx, "WeaponItem")
	local count = 0
	is_idx, count = Deserialize(is, is_idx, "number")
	item.equipment = {}
	for i = 1, count do
		is_idx, item.equipment[i] = DeserializeStruct(is, is_idx, "RolePveArenaHeroEquipment")
	end
	is_idx, item.cur_hp = Deserialize(is, is_idx, "number")
	is_idx, item.cur_anger = Deserialize(is, is_idx, "number")
	is_idx, item.alive_flag = Deserialize(is, is_idx, "number")

	return is_idx, item
end


