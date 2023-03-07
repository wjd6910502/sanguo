function OnCommand_LegionJunXueGuanGetInfo(player, role, arg, others)
	player:Log("OnCommand_LegionJunXueGuanGetInfo, "..DumpTable(arg).." "..DumpTable(others))

	local resp = NewCommand("LegionJunXueGuanGetInfo_Re")
	resp.info = {}
	
	local xiangmu_info_it = role._roledata._legion_info._junxueguan._junxueinfo:SeekToBegin()
	local xiangmu_info = xiangmu_info_it:GetValue()
	while xiangmu_info ~= nil do
		local tmp_info = {}
		tmp_info.id = xiangmu_info._id
		tmp_info.level = xiangmu_info._level
		tmp_info.learned = {}

		local learne_info_it = xiangmu_info._learned:SeekToBegin()
		local learne_info = learne_info_it:GetValue()
		while learne_info ~= nil do
			tmp_info.learned[#tmp_info.learned+1] = learne_info._value
			learne_info_it:Next()
			learne_info = learne_info_it:GetValue()
		end

		xiangmu_info_it:Next()
		xiangmu_info = xiangmu_info_it:GetValue()

		resp.info[#resp.info+1] = tmp_info
	end
	
	player:SendToClient(SerializeCommand(resp))
end
