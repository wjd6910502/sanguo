function OnMessage_RoleInfoInit(player, role, arg, others)
	player:Log("OnMessage_RoleInfoInit, "..DumpTable(arg).." "..DumpTable(others))
	ROLE_OnlineInit(role)

	--�Ծ�����һЩ�����Ĵ���
	if role._roledata._mafia._apply_mafia:Size() ~= 0 then
		role._roledata._mafia._apply_mafia:Clear()
	end
	if role._roledata._mafia._id:ToStr() ~= "0" then
		--��һ����Ϣ��ȥ�鿴һ���Լ��ڵ�ǰ����е���Ϣ��
		local msg = NewMessage("RoleUpdateMafiaInfoLogin")
		local mafia_list = CACHE.Int64List()
		mafia_list:PushBack(role._roledata._mafia._id)
		API_SendMessage(role._roledata._base._id, SerializeMessage(msg), CACHE.Int64List(), mafia_list, CACHE.IntList())
	end
end
