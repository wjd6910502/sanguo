function OnCommand_TeXingGetInfo(player, role, arg, others)
	player:Log("OnCommand_TeXingGetInfo, "..DumpTable(arg).." "..DumpTable(others))

	local resp = NewCommand("TeXingGetInfo_Re")

	resp.texing_info = {}
	local texing_it = role._roledata._status._texing:SeekToBegin()
	local texing = texing_it:GetValue()
	while texing ~= nil do
		resp.texing_info[#resp.texing_info+1] = texing._value
		texing_it:Next()
		texing = texing_it:GetValue()
	end

	player:SendToClient(SerializeCommand(resp))
end
