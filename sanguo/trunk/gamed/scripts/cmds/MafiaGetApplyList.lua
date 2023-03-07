function OnCommand_MafiaGetApplyList(player, role, arg, others)
	player:Log("OnCommand_MafiaGetApplyList, "..DumpTable(arg).." "..DumpTable(others))

	local mafia_data = others.mafias[role._roledata._mafia._id:ToStr()]

	local resp = NewCommand("MafiaGetApplyList_Re")
	resp.apply_info = {}

	if mafia_data == nil then
		resp.retcode = G_ERRCODE["NO_MAFIA"]
		player:SendToClient(SerializeCommand(resp))
		player:Log("OnCommand_MafiaGetApplyList, error=NO_MAFIA")
		return
	end

	local mafia_info = mafia_data._data

	local apply_info_it = mafia_info._applylist:SeekToBegin()
	local apply_info = apply_info_it:GetValue()
	while apply_info ~= nil do
		local tmp_apply_info = {}
		tmp_apply_info.id = apply_info._id:ToStr()
		tmp_apply_info.name = apply_info._name
		tmp_apply_info.photo = apply_info._photo
		tmp_apply_info.level = apply_info._level
		tmp_apply_info.zhanli = apply_info._zhanli

		resp.apply_info[#resp.apply_info+1] = tmp_apply_info
		apply_info_it:Next()
		apply_info = apply_info_it:GetValue()
	end

	player:SendToClient(SerializeCommand(resp))
end
