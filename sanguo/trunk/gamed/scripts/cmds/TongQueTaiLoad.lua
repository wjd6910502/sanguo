function OnCommand_TongQueTaiLoad(player, role, arg, others)
	player:Log("OnCommand_TongQueTaiLoad, "..DumpTable(arg).." "..DumpTable(others))

	--在这里Load结束就需要进行数据的设置了。
	local tongquetai = others.tongquetai._data
	local match_data = tongquetai._match_data:Find(role._roledata._tongquetai_data._cur_tongquetai_id)

	--如果不是这个状态，再发过来这个协议已经是没有任何的意义了
	if match_data._cur_state == 0 then
		local role_info_it = match_data._role_info:SeekToBegin()
		local role_info = role_info_it:GetValue()
		while role_info ~= nil do
			if role_info._role_base._id:ToStr() == role._roledata._base._id:ToStr() then
				role_info._load_finish = 1
				--发送给另外两个玩家，告诉他们两个，谁已经Load 结束了
				local dest_role1 = others.roles[arg.role_id1]
				local dest_role2 = others.roles[arg.role_id2]
				local resp = NewCommand("TongQueTaiLoad_Re")
				resp.role_id = role._roledata._base._id:ToStr()
				dest_role1:SendToClient(SerializeCommand(resp))
				dest_role2:SendToClient(SerializeCommand(resp))
				break
			end
			role_info_it:Next()
			role_info = role_info_it:GetValue()
		end
	end
end
