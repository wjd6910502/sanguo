function OnCommand_ResetRoleInfo(player, role, arg, others)
	player:Log("OnCommand_ResetRoleInfo, "..DumpTable(arg).." "..DumpTable(others))

	--����Ŀǰ����һ��������Ҫ��������
	role._roledata._pvp._state = 0

	--���������centerȥ���Լ��ķ����ɾ��ȥ
	if role._roledata._pvp._id ~= 0 then
		role:SendPVPReset()
	end
end
