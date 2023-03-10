function OnCommand_ChangeHeroSelectSkill(player, role, arg, others)
	player:Log("OnCommand_ChangeHeroSelectSkill, "..DumpTable(arg).." "..DumpTable(others))

	local resp = NewCommand("ChangeHeroSelectSkill_Re")
	resp.retcode = G_ERRCODE["SUCCESS"]
	
	local heros = role._roledata._hero_hall._heros
	local hero = heros:Find(arg.hero_id)
	
	if hero == nil then
		--不存在的武将怎么进行设置
		resp.retcode = G_ERRCODE["SELECT_SKILL_NO_HERO"]
		player:SendToClient(SerializeCommand(resp))
	end

	if table.getn(arg.skill_id) ~= 1 then
		--有错误的，必须是1呀
		resp.retcode = G_ERRCODE["SELECT_SKILL_NUM_ERROR"]
		player:SendToClient(SerializeCommand(resp))
		return
	end

	--进行这个技能的查看
	local ed = DataPool_Find("elementdata")
	local heroinfo = ed:FindBy("hero_id", arg.hero_id)
	local skill = ed:FindBy("skill_id", heroinfo.fightscriptid)
	local flag = 0
	
	for tmp_skill in DataPool_Array(skill.musou) do
		if tmp_skill.skillpackageID == arg.skill_id[1] then
			if hero._level < tmp_skill.skillunlocklv then
				resp.retcode = G_ERRCODE["SELECT_SKILL_LEVEL_LESS"]
				player:SendToClient(SerializeCommand(resp))
				return
			end
			flag = 1
			break
		end
	end

	if flag == 0 then
		resp.retcode = G_ERRCODE["SELECT_SKILL_ID_ERROR"]
		player:SendToClient(SerializeCommand(resp))
		return
	end

	--在这里开始进行设置
	hero._select_skill:Clear()
	for i = 1, table.getn(arg.skill_id) do
		local skill_id = CACHE.Int()
		skill_id._value = arg.skill_id[i]
		hero._select_skill:PushBack(skill_id)
	end
	--然后需要把大无双的技能ID放进去
	resp.skill_id = arg.skill_id
	if hero._level >= skill.shinmusou.skillunlocklv then
		local skill_id = CACHE.Int()
		skill_id._value = skill.shinmusou.skillpackageID
		hero._select_skill:PushBack(skill_id)
		resp.skill_id[#resp.skill_id+1] = skill_id._value
	end
	--返回给客户端，成功
	resp.hero_id = arg.hero_id

	player:SendToClient(SerializeCommand(resp))

end
