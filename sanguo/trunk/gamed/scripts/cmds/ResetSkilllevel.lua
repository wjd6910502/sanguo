function OnCommand_ResetSkilllevel(player, role, arg, others)
	player:Log("OnCommand_ResetSkilllevel, "..DumpTable(arg).." "..DumpTable(others))
	
	local resp = NewCommand("ResetSkilllevel_Re")	
	resp.retcode = ResetSkill(player,role,arg.hero_id)
	player:SendToClient(SerializeCommand(resp))
	--���ͻ��˷����佫��Ϣ���޸�
	if resp.retcode == 0 then
		HERO_UpdateHeroInfo(role, arg.hero_id)
	end

end

function ResetSkill(player,role, hero_id)

	local heros = role._roledata._hero_hall._heros
	local hero = heros:Find(hero_id)
	if hero == nil then
		player:Log("OnCommand_ResetSkilllevel, error=NO_HERO")
		return G_ERRCODE["NO_HERO"]
	end
	
	local skill_level = 0
	local skills = hero._skill
	local common_skills = hero._common_skill
	
	local ed = DataPool_Find("elementdata")
	local hero_skilllevelup = ed.skilllvup
	local quanju = ed.gamedefine[1]

	--������ܶ�Ϊ1����������
	local bneedReset = false
	local fit = skills:SeekToBegin()
	local f = fit:GetValue()			
	while f ~= nil do
		--�����Ǯ
		if f._skill_level > 1 then			
			bneedReset = true
		end	
		fit:Next()
		f = fit:GetValue()
	end
	
	local cfit = common_skills:SeekToBegin()
	local cf = cfit:GetValue()			
	while cf ~= nil do
		if cf._skill_level > 1 then
			bneedReset = true		
		end
		cfit:Next()
		cf = cfit:GetValue()
	end
	
	if bneedReset == false then
		return G_ERRCODE["HERO_SKILLLV_RESET_INVALID"]
	end
	
	--����40�� �鿴���񹻲���	
	local num = quanju.resetskillcost
	if hero._level > quanju.skillresetfreelv and role._roledata._status._yuanbao  < num  then
		player:Log("OnCommand_ResetSkilllevel, error=HERO_SKILLLV_RESET_MONEY_LACK")
		return G_ERRCODE["HERO_SKILLLV_RESET_MONEY_LACK"]		
	end
	
	
	
	--�������м��� ���㼼�ܵ� �����Ǯ * 50%
	local spendmoney = 0
	local skillpoints = 0
	local fit = skills:SeekToBegin()
	local f = fit:GetValue()			
	while f ~= nil do
		local skillid = f._skill_id 		
		local skill_level = f._skill_level
		
		--���㼼�ܵ�
		skillpoints = skillpoints + skill_level - 1
		
		--�����Ǯ
		if skill_level > 1 then			
			for i = 2,skill_level do		
				local tmp_money = hero_skilllevelup.skilllvupprice[i-1]
				
				if tmp_money ==nil then
					throw()
				end
				spendmoney = spendmoney + tmp_money
			end
		end
		
		--���ü���Ϊ1��
		f._skill_level = 1
		fit:Next()
		f = fit:GetValue()
	end

	--�������м��� ���㼼�ܵ� �����Ǯ * 50%	
	local cfit = common_skills:SeekToBegin()
	local cf = cfit:GetValue()			
	while cf ~= nil do
		local skillid = cf._skill_id 		
		local skill_level = cf._skill_level
		
		--���㼼�ܵ�
		skillpoints = skillpoints + skill_level - 1
		
		--�����Ǯ
		if skill_level > 1 then
			for i = 2,skill_level do
				local tmp_money = hero_skilllevelup.skilllvupprice[i-1]
				if tmp_money ==nil then
					throw()
				end
				spendmoney = spendmoney + tmp_money
			end
		end
		cf._skill_level = 1
		cfit:Next()
		cf = cfit:GetValue()
	end
	
	--���ݵȼ��������۳�����

	if hero._level > quanju.skillresetfreelv then
		local num = quanju.resetskillcost
		ROLE_SubYuanBao(role, num)
	end
	--���ظ��û����ϼ��ܵ�ͽ�Ǯ	
	--�������һ����Ǯ��С������
	spendmoney = math.floor(spendmoney*0.5)

	ROLE_AddMoney(role,spendmoney)
	hero._cur_skill_point = hero._cur_skill_point + skillpoints
	
	return G_ERRCODE["SUCCESS"]
end