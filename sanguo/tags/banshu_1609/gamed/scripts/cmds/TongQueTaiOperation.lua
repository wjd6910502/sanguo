function OnCommand_TongQueTaiOperation(player, role, arg, others)
	--player:Log("OnCommand_TongQueTaiOperation, "..DumpTable(arg).." "..DumpTable(others))

	local resp = NewCommand("TongQueTaiOperation_Re")
	local tongquetai = others.tongquetai._data
	local match_data = tongquetai._match_data:Find(role._roledata._tongquetai_data._cur_tongquetai_id)
	local dest_role1 = others.roles[arg.role_id1]
	local dest_role2 = others.roles[arg.role_id2]

	local role_info_it = match_data._role_info:SeekToBegin()
	local index = 1
	local role_info = role_info_it:GetValue()
	while role_info ~= nil do
		if role_info._role_base._id:ToStr() == role._roledata._base._id:ToStr() then
			--������ֱ��return,�϶���������������
			if index ~= match_data._cur_fight_role then
				return
			else
				break
			end
		end
		index = index + 1
		role_info_it:Next()
		role_info = role_info_it:GetValue()
	end
	
	resp.operation = arg.operation
	
	--���������ս��״̬����ô��ֱ�Ӳ��������
	if role._roledata._tongquetai_data._cur_state == 2 then
		--�������ж�һ���Ƿ����������ڴ�ɣ��ǵĻ��ͼ��������ǵĻ���ֱ���ӵ�
		dest_role1:SendToClient(SerializeCommand(resp))
		dest_role2:SendToClient(SerializeCommand(resp))
		match_data._time = API_GetTime()
	end
end
