function OnCommand_TongQueTaiLoad(player, role, arg, others)
	player:Log("OnCommand_TongQueTaiLoad, "..DumpTable(arg).." "..DumpTable(others))

	--������Load��������Ҫ�������ݵ������ˡ�
	local tongquetai = others.tongquetai._data
	local match_data = tongquetai._match_data:Find(role._roledata._tongquetai_data._cur_tongquetai_id)

	--����������״̬���ٷ��������Э���Ѿ���û���κε�������
	if match_data._cur_state == 0 then
		local role_info_it = match_data._role_info:SeekToBegin()
		local role_info = role_info_it:GetValue()
		while role_info ~= nil do
			if role_info._role_base._id:ToStr() == role._roledata._base._id:ToStr() then
				role_info._load_finish = 1
				--���͸�����������ң���������������˭�Ѿ�Load ������
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