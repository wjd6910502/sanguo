function OnCommand_ResetSkilllevel(player, role, arg, others)
	player:Log("OnCommand_ResetSkilllevel, "..DumpTable(arg).." "..DumpTable(others))
	
	local resp = NewCommand("ResetSkilllevel_Re")	
	resp.retcode = ResetSkill(player,role,arg.hero_id)
	player:SendToClient(SerializeCommand(resp))
	--给客户端发送武将信息的修改
	if resp.retcode == 0 then 
		HERO_UpdateHeroInfo(role, arg.hero_id)
	end

end

function ResetSkill(player,role, hero_id)

	local heros = role._roledata._hero_hall._heros
	local hero = heros:Find(hero_id)
	if hero == nil then
		return G_ERRCODE["NO_HERO"]
	end
	
	local skill_level = 0
	local skills = hero._skill
	local common_skills = hero._common_skill
	
	local ed = DataPool_Find("elementdata")
	local hero_skilllevelup = ed.skilllvup
	local quanju = ed.gamedefine[1]

	--如果技能都为1级不用重置
	local bneedReset = false
	local fit = skills:SeekToBegin()
	local f = fit:GetValue()			
	while f ~= nil do
		--计算金钱
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
	
	--超过40级 查看勾玉够不够	
	local num = quanju.resetskillcost
	if hero._level > quanju.skillresetfreelv and role._roledata._status._yuanbao  < num  then
		return G_ERRCODE["HERO_SKILLLV_RESET_MONEY_LACK"]		
	end
	
	
	
	--遍历所有技能 计算技能点 计算金钱 * 50%
	local spendmoney = 0
	local skillpoints = 0
	local fit = skills:SeekToBegin()
	local f = fit:GetValue()			
	while f ~= nil do
		local skillid = f._skill_id 		
		local skill_level = f._skill_level
		
		--计算技能点
		skillpoints = skillpoints + skill_level - 1
		
		--计算金钱
		if skill_level > 1 then			
			for i = 2,skill_level do		
				local tmp_money = hero_skilllevelup.skilllvupprice[i-1]
				
				if tmp_money ==nil then 
					throw()
				end
				spendmoney = spendmoney + tmp_money
			end
		end
		
		--重置技能为1级
		f._skill_level = 1
		fit:Next()
		f = fit:GetValue()
	end

	--遍历所有技能 计算技能点 计算金钱 * 50%	
	local cfit = common_skills:SeekToBegin()
	local cf = cfit:GetValue()			
	while cf ~= nil do
		local skillid = cf._skill_id 		
		local skill_level = cf._skill_level
		
		--计算技能点
		skillpoints = skillpoints + skill_level - 1
		
		--计算金钱
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
	
	--根据等级限制来扣除勾玉

	if hero._level > quanju.skillresetfreelv then
		local num = quanju.resetskillcost
		ROLE_SubYuanBao(role, num)
	end
	--返回给用户身上技能点和金钱	
	--这里会有一个金钱的小数问题
	spendmoney = math.floor(spendmoney*0.5)

	ROLE_AddMoney(role,spendmoney)	
	hero._cur_skill_point = hero._cur_skill_point + skillpoints
	
	return G_ERRCODE["SUCCESS"]
end
