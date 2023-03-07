function OnCommand_PvpJoin(player, role, arg, others)
	player:Log("OnCommand_PvpJoin, "..DumpTable(arg).." "..DumpTable(others))

	--��鵱ǰ��ҵ�״̬�Ƿ���Խ���PVP
	if role._roledata._pvp._id ~= 0 or role._roledata._pvp._state ~= 0 then
		player:Log("OnCommand_PvpJoin, "..role._roledata._pvp._id.."  ".."  "..role._roledata._pvp._state)
		return
	end

	--�����ﲻ�����κε���֤��ֱ�ӾͰ���Ϣ�������ķ�����ȥ
	if role._roledata._pvp_info._last_hero:Size() == 0 then
		local resp = NewCommand("ErrorInfo")
		resp.error_id = G_ERRCODE["PVP_HERO_COUNT_ERR"]
		player:SendToClient(SerializeCommand(resp))
		return
	end
	
	local rolebrief = ROLE_MakeRoleBrief(role)
	local pvpinfo ={}
	pvpinfo.brief = {}
	pvpinfo.brief = rolebrief
	pvpinfo.hero_hall = {}

	local heros = role._roledata._hero_hall._heros
	local last_hero = role._roledata._pvp_info._last_hero
	local lit = last_hero:SeekToBegin()
	local l = lit:GetValue()
	while l ~= nil do
		local hero = {}
		local h = heros:Find(l._value)
		hero.tid = l._value
		hero.level = h._level
		hero.order = h._order
		hero.star = h._star
		hero.skill = {}
		hero.common_skill = {}
		hero.select_skill = {}
		--�佫��˫���ܸ�ֵ
		local skills = h._skill
		local sit = skills:SeekToBegin()
		local s = sit:GetValue()
		while s ~= nil do
			local h3 = {}
			h3.skill_id = s._skill_id
			h3.skill_level = s._skill_level
			hero.skill[#hero.skill+1] = h3
			sit:Next()
			s = sit:GetValue()
		end
		--�佫��ͨ���ܸ�ֵ
		local common_skills = h._common_skill
		local com_it = common_skills:SeekToBegin()
		local com = com_it:GetValue()
		while com ~= nil do
			local h3 = {}
			h3.skill_id = com._skill_id
			h3.skill_level = com._skill_level
			hero.common_skill[#hero.common_skill+1] = h3
			com_it:Next()
			com = com_it:GetValue()
		end

		--�佫�Ѿ�ѡ�����˫����
		local select_skills = h._select_skill
		local select_skill_it = select_skills:SeekToBegin()
		local select_skill = select_skill_it:GetValue()
		while select_skill ~= nil do
			hero.select_skill[#hero.select_skill+1] = select_skill._value
			select_skill_it:Next()
			select_skill = select_skill_it:GetValue()
		end
		
		pvpinfo.hero_hall[#pvpinfo.hero_hall+1] = hero
		lit:Next()
		l = lit:GetValue()
	end

	pvpinfo.p2p_magic = math.random(1000000)
	pvpinfo.p2p_net_typ = role._roledata._device_info._net_type
	pvpinfo.p2p_public_ip = role._roledata._device_info._public_ip
	pvpinfo.p2p_public_port = role._roledata._device_info._public_port
	pvpinfo.p2p_local_ip = role._roledata._device_info._local_ip
	pvpinfo.p2p_local_port = role._roledata._device_info._local_port
		
	--���������ҵĵ�ǰ�Ǽ����ͽ�ȥ
	local data = 0
	local data1 = 0
	if role._roledata._pvp_info._pvp_grade == 0 then
		local ed = DataPool_Find("elementdata")
		for i = 25, role._roledata._pvp_info._pvp_grade + 1, -1 do
			local ranking = ed:FindBy("ranking_id", i)
			data = data + ranking.ascending_order_star
		end
		data = data + 1
		data1 = role._roledata._pvp_info._cur_star + 10000
	else
		local ed = DataPool_Find("elementdata")
		for i = 25, role._roledata._pvp_info._pvp_grade + 1, -1 do
			local ranking = ed:FindBy("ranking_id", i)
			data = data + ranking.ascending_order_star
		end
		data = data + role._roledata._pvp_info._cur_star
		data1 = data
	end
	--typ����1��ʱ��������ǿ��ս��
	pvpinfo.pvp_score = data1
	local os = {}
	SerializeStruct(os, "RolePVPInfo", pvpinfo)
	role._roledata._pvp._pvpcenterinfo = table.concat(os)
	role._roledata._pvp._typ = arg.typ
	role:SendPVPJoin(data)

	--���õ�ǰ������PVP״̬
	role._roledata._pvp._state = 1
	role._roledata._status._instance_id = 0
end