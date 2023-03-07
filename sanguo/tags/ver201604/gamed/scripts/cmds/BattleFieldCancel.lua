function OnCommand_BattleFieldCancel(player, role, arg, others)
	player:Log("OnCommand_BattleFieldCancel, "..DumpTable(arg).." "..DumpTable(others))

	local resp = NewCommand("BattleFieldCancel_Re")
	resp.battle_id = arg.battle_id
	--�����������Ҫ������Ķ�����ֻ��Ҫ�ص�ԭ����λ�þͿ�����
	
	--������Ϣ���ж�
	local battle = role._roledata._battle_info:Find(arg.battle_id)
	if battle == nil then
		--ֱ�Ӹ��ͻ��˷��أ���Ϊ���������
		resp.retcode = G_ERRCODE["BATTLE_ID_NOT_EXIST"]
		player:SendToClient(SerializeCommand(resp))
		return
	end

	battle._cur_position = battle._last_position
	resp.retcode = G_ERRCODE["SUCCESS"]
	resp.position = battle._cur_position
	player:SendToClient(SerializeCommand(resp))
	return
end
