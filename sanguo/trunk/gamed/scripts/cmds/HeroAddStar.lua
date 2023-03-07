function OnCommand_HeroAddStar(player, role, arg, others)
	player:Log("OnCommand_HeroAddStar, "..DumpTable(arg).." "..DumpTable(others))

	--����ͳ����־
	local source_id = G_SOURCE_TYP["HERO"]

	local resp = NewCommand("HeroAddStar_Re")
	resp.hero_id = arg.hero_id

	local hero = role._roledata._hero_hall._heros:Find(arg.hero_id)
	if hero == nil then
		resp.retcode = G_ERRCODE["NO_HERO"]
		player:SendToClient(SerializeCommand(resp))
		player:Log("OnCommand_HeroAddStar, error=NO_HERO")
		return
	end

	local ed = DataPool_Find("elementdata")
	local hero_info = ed:FindBy("hero_id", arg.hero_id)
	if hero_info == nil then
		resp.retcode = G_ERRCODE["SYSTEM_INVALID"]
		player:SendToClient(SerializeCommand(resp))
		player:Log("OnCommand_HeroAddStar, error=SYSTEM_INVALID")
		return
	end

	if hero._star >= hero_info.maxstar then
		resp.retcode = G_ERRCODE["HERO_MAX_STAR"]
		player:SendToClient(SerializeCommand(resp))
		player:Log("OnCommand_HeroAddStar, error=HERO_MAX_STAR")
		return
	end

	local star_info = ed:FindBy("hero_star", arg.hero_id)
	if star_info == nil then
		resp.retcode = G_ERRCODE["SYSTEM_INVALID"]
		player:SendToClient(SerializeCommand(resp))
		player:Log("OnCommand_HeroAddStar, error=SYSTEM_INVALID")
		return
	end

	local cur_star = 1
	local info_flag = false
	for startinfo in DataPool_Array(star_info.starinfo) do
		if cur_star == hero._star then
			if startinfo.cost_item_id == 0 or startinfo.cost_item_quantity == 0 then
				resp.retcode = G_ERRCODE["ITEM_COUNT_LESS"]
				player:SendToClient(SerializeCommand(resp))
				player:Log("OnCommand_HeroAddStar, error=ITEM_COUNT_LESS")
				return
			end
			--�ж���Ҫ����Ʒ�Ƿ��㹻
			if BACKPACK_HaveItem(role, startinfo.cost_item_id, startinfo.cost_item_quantity) == false then
				resp.retcode = G_ERRCODE["ITEM_COUNT_LESS"]
				player:SendToClient(SerializeCommand(resp))
				player:Log("OnCommand_HeroAddStar, error=ITEM_COUNT_LESS")
				return
			end
			info_flag = true
			break
		end
		cur_star = cur_star + 1
	end

	if info_flag == false then
		resp.retcode = G_ERRCODE["SYSTEM_INVALID"]
		player:SendToClient(SerializeCommand(resp))
		player:Log("OnCommand_HeroAddStar, error=SYSTEM_INVALID")
		return
	end
	--��ʼ�۳���Ʒ�����Ҽ���
	cur_star = 1
	
	for startinfo in DataPool_Array(star_info.starinfo) do
		if cur_star == hero._star then
			BACKPACK_DelItem(role, startinfo.cost_item_id, startinfo.cost_item_quantity, source_id)
			break
		end
		cur_star = cur_star + 1
	end

	hero._star = hero._star + 1

	--�ɾ��޸�
	TASK_ChangeCondition_Special(role, G_ACH_TYPE["HERO_STAR"], hero._star, hero._star-1, 1)

	resp.retcode = G_ERRCODE["SUCCESS"]
	resp.star = hero._star
	player:SendToClient(SerializeCommand(resp))

	HERO_UpdateHeroInfo(role, arg.hero_id)
end