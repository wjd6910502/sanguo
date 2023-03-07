function OnCommand_HeroUpgradeSkill(player, role, arg, others)
	player:Log("OnCommand_HeroUpgradeSkill, "..DumpTable(arg).." "..DumpTable(others))

	local resp = NewCommand("HeroUpgradeSkill_Re")

	resp.retcode = HERO_UpgradeSkill(role, arg.hero_id, arg.skill_id)
	player:SendToClient(SerializeCommand(resp))
	if resp.retcode == 0 then
		HERO_UpdateHeroInfo(role, arg.hero_id)
	end
	return
end
