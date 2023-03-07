function OnCommand_ChangeHeroSelectSkill(player, role, arg, others)
	player:Log("OnCommand_ChangeHeroSelectSkill, "..DumpTable(arg).." "..DumpTable(others))

	local resp = NewCommand("ChangeHeroSelectSkill_Re")
	resp.retcode = G_ERRCODE["SUCCESS"]
	
	local heros = role._roledata._hero_hall._heros
	local hero = heros:Find(arg.hero_id)
	
	if hero == nil then
		--�����ڵ��佫��ô��������
		resp.retcode = G_ERRCODE["SELECT_SKILL_NO_HERO"]
		player:SendToClient(SerializeCommand(resp))
		player:Log("OnCommand_ChangeHeroSelectSkill, error=SELECT_SKILL_NO_HERO")
	end

	if table.getn(arg.skill_id) ~= 1 then
		--�д���ģ�������1ѽ
		resp.retcode = G_ERRCODE["SELECT_SKILL_NUM_ERROR"]
		player:SendToClient(SerializeCommand(resp))
		player:Log("OnCommand_ChangeHeroSelectSkill, error=SELECT_SKILL_NUM_ERROR")
		return
	end

	--����������ܵĲ鿴
	local ed = DataPool_Find("elementdata")
	local heroinfo = ed:FindBy("hero_id", arg.hero_id)
	local skill = ed:FindBy("skill_id", heroinfo.fightscriptid)
	local flag = 0
	
	for tmp_skill in DataPool_Array(skill.musou) do
		if tmp_skill.skillpackageID == arg.skill_id[1] then
			if hero._order < tmp_skill.skillunlocktupo then
				resp.retcode = G_ERRCODE["SELECT_SKILL_LEVEL_LESS"]
				player:SendToClient(SerializeCommand(resp))
				player:Log("OnCommand_ChangeHeroSelectSkill, error=SELECT_SKILL_LEVEL_LESS")
				return
			end
			flag = 1
			break
		end
	end

	if flag == 0 then
		resp.retcode = G_ERRCODE["SELECT_SKILL_ID_ERROR"]
		player:SendToClient(SerializeCommand(resp))
		player:Log("OnCommand_ChangeHeroSelectSkill, error=SELECT_SKILL_ID_ERROR")
		return
	end

	--�����￪ʼ��������
	hero._select_skill:Clear()
	for i = 1, table.getn(arg.skill_id) do
		local skill_id = CACHE.Int()
		skill_id._value = arg.skill_id[i]
		hero._select_skill:PushBack(skill_id)
	end
	--Ȼ����Ҫ�Ѵ���˫�ļ���ID�Ž�ȥ
	resp.skill_id = arg.skill_id
	if hero._level >= skill.shinmusou.skillunlocklv then
		local skill_id = CACHE.Int()
		skill_id._value = skill.shinmusou.skillpackageID
		hero._select_skill:PushBack(skill_id)
		resp.skill_id[#resp.skill_id+1] = skill_id._value
	end
	--���ظ��ͻ��ˣ��ɹ�
	resp.hero_id = arg.hero_id

	player:SendToClient(SerializeCommand(resp))

end