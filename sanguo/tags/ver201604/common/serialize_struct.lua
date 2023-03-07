--DONT CHANGE ME!

function SerializeStruct(os, __type__, obj)
	if obj==nil then obj={} end

	if false then
		--never to here
	elseif __type__ == "Instance_Star_Condition" then
		Serialize(os, obj.tid)
		Serialize(os, obj.flag)
	elseif __type__ == "TopListData" then
		Serialize(os, obj.id)
		Serialize(os, obj.name)
		Serialize(os, obj.photo)
		Serialize(os, obj.data)
	elseif __type__ == "RoleHeroHall" then
		if obj.heros==nil then
			Serialize(os, 0)
		else
			Serialize(os, #obj.heros)
			for i = 1, #obj.heros do
				SerializeStruct(os, "RoleHero", obj.heros[i])
			end
		end
	elseif __type__ == "BattleInfo" then
		Serialize(os, obj.battle_id)
		Serialize(os, obj.cur_pos)
		Serialize(os, obj.state)
		if obj.hero_info==nil then
			Serialize(os, 0)
		else
			Serialize(os, #obj.hero_info)
			for i = 1, #obj.hero_info do
				SerializeStruct(os, "BattleHeroInfo", obj.hero_info[i])
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
				SerializeStruct(os, "BattleHorseHero", obj.cur_horse_hero[i])
			end
		end
		if obj.position_data==nil then
			Serialize(os, 0)
		else
			Serialize(os, #obj.position_data)
			for i = 1, #obj.position_data do
				SerializeStruct(os, "BattlePositionInfo", obj.position_data[i])
			end
		end
	elseif __type__ == "PVEOperation" then
		Serialize(os, obj.client_tick)
		Serialize(os, obj.op)
	elseif __type__ == "RoleBrief" then
		Serialize(os, obj.id)
		Serialize(os, obj.name)
		Serialize(os, obj.photo)
		Serialize(os, obj.level)
		Serialize(os, obj.mafia_id)
		Serialize(os, obj.mafia_name)
	elseif __type__ == "RoleUserDefineData" then
		Serialize(os, obj.id)
		Serialize(os, obj.value_define)
	elseif __type__ == "RolePVPInfo" then
		SerializeStruct(os, "RoleBrief", obj.brief)
		if obj.hero_hall==nil then
			Serialize(os, 0)
		else
			Serialize(os, #obj.hero_hall)
			for i = 1, #obj.hero_hall do
				SerializeStruct(os, "RolePVPHero", obj.hero_hall[i])
			end
		end
		Serialize(os, obj.p2p_magic)
		Serialize(os, obj.p2p_net_typ)
		Serialize(os, obj.p2p_public_ip)
		Serialize(os, obj.p2p_public_port)
		Serialize(os, obj.p2p_local_ip)
		Serialize(os, obj.p2p_local_port)
		Serialize(os, obj.pvp_score)
	elseif __type__ == "RoleHero" then
		Serialize(os, obj.tid)
		Serialize(os, obj.level)
		Serialize(os, obj.order)
		Serialize(os, obj.exp)
		Serialize(os, obj.star)
		if obj.skill==nil then
			Serialize(os, 0)
		else
			Serialize(os, #obj.skill)
			for i = 1, #obj.skill do
				SerializeStruct(os, "HeroSkill", obj.skill[i])
			end
		end
		if obj.common_skill==nil then
			Serialize(os, 0)
		else
			Serialize(os, #obj.common_skill)
			for i = 1, #obj.common_skill do
				SerializeStruct(os, "HeroSkill", obj.common_skill[i])
			end
		end
		SerializeStruct(os, "HeroPvpInfoData", obj.hero_pvp_info)
		if obj.select_skill==nil then
			Serialize(os, 0)
		else
			Serialize(os, #obj.select_skill)
			for i = 1, #obj.select_skill do
				Serialize(os, obj.select_skill[i])
			end
		end
	elseif __type__ == "MysteryShopItem" then
		Serialize(os, obj.item_id)
		Serialize(os, obj.buy_count)
		Serialize(os, obj.max_count)
	elseif __type__ == "AnotherRoleData" then
		SerializeStruct(os, "RoleBrief", obj.brief)
	elseif __type__ == "RoleCurrentTask" then
		Serialize(os, obj.id)
		if obj.condition==nil then
			Serialize(os, 0)
		else
			Serialize(os, #obj.condition)
			for i = 1, #obj.condition do
				SerializeStruct(os, "RoleTaskCondition", obj.condition[i])
			end
		end
	elseif __type__ == "RoleStatus" then
		Serialize(os, obj.level)
		Serialize(os, obj.exp)
		Serialize(os, obj.vp)
		if obj.instances==nil then
			Serialize(os, 0)
		else
			Serialize(os, #obj.instances)
			for i = 1, #obj.instances do
				SerializeStruct(os, "RoleInstance", obj.instances[i])
			end
		end
		Serialize(os, obj.money)
		Serialize(os, obj.yuanbao)
		if obj.common_use_limit==nil then
			Serialize(os, 0)
		else
			Serialize(os, #obj.common_use_limit)
			for i = 1, #obj.common_use_limit do
				SerializeStruct(os, "CommonUseLimit", obj.common_use_limit[i])
			end
		end
		Serialize(os, obj.chongzhi)
		Serialize(os, obj.hero_skill_point)
	elseif __type__ == "BattleNPCInfo" then
		Serialize(os, obj.id)
		Serialize(os, obj.camp)
		Serialize(os, obj.armyid)
		Serialize(os, obj.alive)
		Serialize(os, obj.event_flag)
		Serialize(os, obj.event_id)
	elseif __type__ == "RoleBackPack" then
		Serialize(os, obj.capacity)
		if obj.items==nil then
			Serialize(os, 0)
		else
			Serialize(os, #obj.items)
			for i = 1, #obj.items do
				SerializeStruct(os, "Item", obj.items[i])
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
				SerializeStruct(os, "RoleCurrentTask", obj.current[i])
			end
		end
	elseif __type__ == "HeroSoul" then
		Serialize(os, obj.soul_id)
		Serialize(os, obj.soul_num)
	elseif __type__ == "RepInfo" then
		Serialize(os, obj.rep_id)
		Serialize(os, obj.rep_num)
	elseif __type__ == "BattlePositionInfo" then
		Serialize(os, obj.id)
		Serialize(os, obj.position)
		Serialize(os, obj.flag)
		Serialize(os, obj.event_flag)
		Serialize(os, obj.event_id)
		if obj.npc_info==nil then
			Serialize(os, 0)
		else
			Serialize(os, #obj.npc_info)
			for i = 1, #obj.npc_info do
				SerializeStruct(os, "BattleNPCInfo", obj.npc_info[i])
			end
		end
	elseif __type__ == "RoleInfo" then
		SerializeStruct(os, "RoleBase", obj.base)
		SerializeStruct(os, "RoleStatus", obj.status)
		SerializeStruct(os, "RoleHeroHall", obj.hero_hall)
		SerializeStruct(os, "RoleBackPack", obj.backpack)
		SerializeStruct(os, "RoleMafia", obj.mafia)
		SerializeStruct(os, "RoleTask", obj.task)
		SerializeStruct(os, "RoleUserDefine", obj.user_define)
		SerializeStruct(os, "RoleHorseHall", obj.horse_hall)
		SerializeStruct(os, "RoleLastHero", obj.last_hero)
		SerializeStruct(os, "RoleLastHero", obj.pvp_last_hero)
		SerializeStruct(os, "Role_PvpInfo", obj.pvp_info)
		if obj.pvp_video==nil then
			Serialize(os, 0)
		else
			Serialize(os, #obj.pvp_video)
			for i = 1, #obj.pvp_video do
				SerializeStruct(os, "PvpVideoData", obj.pvp_video[i])
			end
		end
		if obj.black_list==nil then
			Serialize(os, 0)
		else
			Serialize(os, #obj.black_list)
			for i = 1, #obj.black_list do
				SerializeStruct(os, "RoleBase", obj.black_list[i])
			end
		end
		if obj.mail_list==nil then
			Serialize(os, 0)
		else
			Serialize(os, #obj.mail_list)
			for i = 1, #obj.mail_list do
				SerializeStruct(os, "MailInfo", obj.mail_list[i])
			end
		end
		if obj.rep_list==nil then
			Serialize(os, 0)
		else
			Serialize(os, #obj.rep_list)
			for i = 1, #obj.rep_list do
				SerializeStruct(os, "RepInfo", obj.rep_list[i])
			end
		end
		if obj.mysteryshop_list==nil then
			Serialize(os, 0)
		else
			Serialize(os, #obj.mysteryshop_list)
			for i = 1, #obj.mysteryshop_list do
				SerializeStruct(os, "MysteryShopInfo", obj.mysteryshop_list[i])
			end
		end
		if obj.instancehero_info==nil then
			Serialize(os, 0)
		else
			Serialize(os, #obj.instancehero_info)
			for i = 1, #obj.instancehero_info do
				SerializeStruct(os, "InstanceHero", obj.instancehero_info[i])
			end
		end
	elseif __type__ == "RoleClientPVPInfo" then
		SerializeStruct(os, "RoleBrief", obj.brief)
		if obj.hero_hall==nil then
			Serialize(os, 0)
		else
			Serialize(os, #obj.hero_hall)
			for i = 1, #obj.hero_hall do
				SerializeStruct(os, "RolePVPHero", obj.hero_hall[i])
			end
		end
		Serialize(os, obj.pvp_score)
	elseif __type__ == "RoleBase" then
		Serialize(os, obj.id)
		Serialize(os, obj.name)
		Serialize(os, obj.photo)
	elseif __type__ == "Friend" then
		Serialize(os, obj.id)
		Serialize(os, obj.name)
		Serialize(os, obj.photo)
		Serialize(os, obj.level)
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
				SerializeStruct(os, "HeroSkill", obj.skill[i])
			end
		end
		if obj.common_skill==nil then
			Serialize(os, 0)
		else
			Serialize(os, #obj.common_skill)
			for i = 1, #obj.common_skill do
				SerializeStruct(os, "HeroSkill", obj.common_skill[i])
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
	elseif __type__ == "InstanceInfo" then
		Serialize(os, obj.id)
		Serialize(os, obj.star)
	elseif __type__ == "RoleHorseHall" then
		if obj.horses==nil then
			Serialize(os, 0)
		else
			Serialize(os, #obj.horses)
			for i = 1, #obj.horses do
				SerializeStruct(os, "RoleHorse", obj.horses[i])
			end
		end
	elseif __type__ == "RoleHorse" then
		Serialize(os, obj.tid)
	elseif __type__ == "InstanceHero" then
		Serialize(os, obj.typ)
		Serialize(os, obj.battle_id)
		SerializeStruct(os, "RoleLastHero", obj.heroinfo)
		Serialize(os, obj.horse)
	elseif __type__ == "MafiaBrief" then
		Serialize(os, obj.id)
		Serialize(os, obj.name)
		Serialize(os, obj.flag)
		Serialize(os, obj.announce)
		Serialize(os, obj.level)
		Serialize(os, obj.activity)
		Serialize(os, obj.boss_id)
		Serialize(os, obj.boss_name)
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
				SerializeStruct(os, "Item", obj.item[i])
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
	elseif __type__ == "HeroComment" then
		Serialize(os, obj.role_id)
		Serialize(os, obj.role_name)
		Serialize(os, obj.comment)
		Serialize(os, obj.agree_count)
		Serialize(os, obj.agree_flag)
		Serialize(os, obj.time_stamp)
	elseif __type__ == "HeroPvpInfoData" then
		Serialize(os, obj.id)
		Serialize(os, obj.join_count)
		Serialize(os, obj.win_count)
	elseif __type__ == "Item" then
		Serialize(os, obj.tid)
		Serialize(os, obj.count)
	elseif __type__ == "LotteryRewardInfo" then
		Serialize(os, obj.id)
		Serialize(os, obj.num)
		Serialize(os, obj.firstget)
		Serialize(os, obj.bproorhero)
	elseif __type__ == "MysteryShopInfo" then
		Serialize(os, obj.shop_id)
		if obj.shop_item==nil then
			Serialize(os, 0)
		else
			Serialize(os, #obj.shop_item)
			for i = 1, #obj.shop_item do
				SerializeStruct(os, "MysteryShopItem", obj.shop_item[i])
			end
		end
	elseif __type__ == "PvpOperation" then
		Serialize(os, obj.tick)
		Serialize(os, obj.first_operation)
		Serialize(os, obj.second_operation)
	elseif __type__ == "HeroSkill" then
		Serialize(os, obj.skill_id)
		Serialize(os, obj.skill_level)
	elseif __type__ == "BattleHeroInfo" then
		Serialize(os, obj.hero_id)
		Serialize(os, obj.hp)
	elseif __type__ == "ChatInfo" then
		SerializeStruct(os, "RoleBrief", obj.src)
		SerializeStruct(os, "RoleBrief", obj.dest)
		Serialize(os, obj.content)
		Serialize(os, obj.time)
	elseif __type__ == "RoleTaskCondition" then
		Serialize(os, obj.current_num)
		Serialize(os, obj.max_num)
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
	elseif __type__ == "DropItem" then
		Serialize(os, obj.id)
		Serialize(os, obj.count)
	elseif __type__ == "PvpVideoData" then
		Serialize(os, obj.video)
		SerializeStruct(os, "RoleClientPVPInfo", obj.player1)
		SerializeStruct(os, "RoleClientPVPInfo", obj.player2)
		Serialize(os, obj.win_flag)
		Serialize(os, obj.time)
	elseif __type__ == "RoleInstance" then
		Serialize(os, obj.tid)
		Serialize(os, obj.score)
	elseif __type__ == "RoleUserDefine" then
		if obj.role_define==nil then
			Serialize(os, 0)
		else
			Serialize(os, #obj.role_define)
			for i = 1, #obj.role_define do
				SerializeStruct(os, "RoleUserDefineData", obj.role_define[i])
			end
		end
	elseif __type__ == "RoleMafia" then
		Serialize(os, obj.id)
		Serialize(os, obj.name)
	elseif __type__ == "MafiaMember" then
		Serialize(os, obj.id)
		Serialize(os, obj.name)
		Serialize(os, obj.photo)
		Serialize(os, obj.level)
		Serialize(os, obj.activity)
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
	elseif __type__ == "Condition" then
		Serialize(os, obj.current)
		Serialize(os, obj.max)
	elseif __type__ == "Chat" then
		Serialize(os, obj.src_id)
		Serialize(os, obj.src_name)
		Serialize(os, obj.time)
		Serialize(os, obj.content)
	elseif __type__ == "Role_PvpInfo" then
		Serialize(os, obj.star)
		Serialize(os, obj.join_count)
		Serialize(os, obj.win_count)
		Serialize(os, obj.end_time)
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
				SerializeStruct(os, "MafiaMember", obj.members[i])
			end
		end
	elseif __type__ == "SweepInstanceData" then
		Serialize(os, obj.exp)
		Serialize(os, obj.heroexp)
		if obj.item==nil then
			Serialize(os, 0)
		else
			Serialize(os, #obj.item)
			for i = 1, #obj.item do
				SerializeStruct(os, "DropItem", obj.item[i])
			end
		end
	elseif __type__ == "PvpVideo" then
		if obj.video==nil then
			Serialize(os, 0)
		else
			Serialize(os, #obj.video)
			for i = 1, #obj.video do
				SerializeStruct(os, "PvpOperation", obj.video[i])
			end
		end

	end
end
