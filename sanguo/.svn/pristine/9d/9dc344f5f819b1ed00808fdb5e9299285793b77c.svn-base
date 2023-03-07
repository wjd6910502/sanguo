function OnCommand_MafiaGetSelfInfo(player, role, arg, others)
	player:Log("OnCommand_MafiaGetSelfInfo, "..DumpTable(arg).." "..DumpTable(others))

	local resp = NewCommand("MafiaGetSelfInfo_Re")
	resp.mafia_info = {}

	resp.mafia_info.id = role._roledata._mafia._id:ToStr()
	resp.mafia_info.name = role._roledata._mafia._name
	resp.mafia_info.position = role._roledata._mafia._position
	resp.mafia_info.apply_mafia = {}

	local apply_info_it = role._roledata._mafia._apply_mafia:SeekToBegin()
	local apply_info = apply_info_it:GetValue()
	while apply_info ~= nil do
		resp.mafia_info.apply_mafia[#resp.mafia_info.apply_mafia+1] = apply_info:ToStr()
	
		apply_info_it:Next()
		apply_info = apply_info_it:GetValue()
	end

	player:SendToClient(SerializeCommand(resp))
end
