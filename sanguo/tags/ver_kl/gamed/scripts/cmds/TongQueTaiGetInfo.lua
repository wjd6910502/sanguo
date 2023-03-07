function OnCommand_TongQueTaiGetInfo(player, role, arg, others)
	player:Log("OnCommand_TongQueTaiGetInfo, "..DumpTable(arg).." "..DumpTable(others))

	local resp = NewCommand("TongQueTaiGetInfo_Re")
	resp.reward_flag = role._roledata._tongquetai_data._reward_flag
	resp.hero = {}

	local hero_it = role._roledata._tongquetai_data._hero_info:SeekToBegin()
	local hero = hero_it:GetValue()
	while hero ~= nil do
		resp.hero[#resp.hero+1] = hero._value

		hero_it:Next()
		hero = hero_it:GetValue()
	end

	player:SendToClient(SerializeCommand(resp))
end
