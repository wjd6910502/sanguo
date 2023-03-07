function OnCommand_WuZheShiLianGetHeroInfo(player, role, arg, others)
	player:Log("OnCommand_WuZheShiLianGetHeroInfo, "..DumpTable(arg).." "..DumpTable(others))
	
	local resp = NewCommand("WuZheShiLianGetHeroInfo_Re")
	resp.retcode = 0

	local hero_trial = role._roledata._wuzhe_shilian	
	
	resp.dead_hero = {} 
	local fit = hero_trial._dead_hero_info:SeekToBegin()
	local f = fit:GetValue()
	while f ~= nil do
		resp.dead_hero[#resp.dead_hero+1] = f._value	
		fit:Next()
		f = fit:GetValue()
	end
	
	resp.injured_hero = {}
	local fit = hero_trial._injured_hero_info:SeekToBegin()
	local f = fit:GetValue()
	while f ~= nil do
		local injuredhero = {}
		injuredhero.id = f._id
		injuredhero.hp = f._hp
		injuredhero.anger = f._anger
		resp.injured_hero[#resp.injured_hero+1] = injuredhero
		fit:Next()
		f = fit:GetValue()
	end

	player:SendToClient(SerializeCommand(resp))	
	
end
