function OnCommand_MilitaryGetInfo(player, role, arg, others)
	player:Log("OnCommand_MilitaryGetInfo, "..DumpTable(arg).." "..DumpTable(others))

	local resp = NewCommand("MilitaryGetInfo_Re")

	resp.stage_id = role._roledata._military_data._stage_id
	resp.stage_difficult = role._roledata._military_data._stage_difficult
	resp.horse_id = role._roledata._military_data._horse_id
	resp.stage_info = {}
	for data in Cache_Map(role._roledata._military_data._stage_data) do
		local tmp = {}
		tmp.stage_id = data._id 
		tmp.times = data._times
		tmp.cd = data._cd
		resp.stage_info[#resp.stage_info + 1] = tmp
	end

	player:SendToClient(SerializeCommand(resp))
end
