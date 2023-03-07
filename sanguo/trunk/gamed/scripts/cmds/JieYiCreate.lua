function OnCommand_JieYiCreate(player, role, arg, others)
	player:Log("OnCommand_JieYiCreate, "..DumpTable(arg).." "..DumpTable(others))
	local resp = NewCommand("JieYiCreate_Re")	
	local jieyi_info = others.jieyi_info._data	
	
	--�ж� �������id ���� �����Ѿ����� ���ܴ���
	if role._roledata._jieyi_info._jieyi_id:ToStr() ~= "0" or role._roledata._jieyi_info._cur_operate_id:ToStr() ~= "0" then
		--�����Ѿ����岻�ܴ���
		local cmd = NewCommand("ErrorInfo")
		cmd.error_id = G_ERRCODE["JIEYI_HAS_CREATED"]
		role:SendToClient(SerializeCommand(cmd))	
		player:Log("OnCommand_JieYiCreate, error=JIEYI_HAS_CREATED")
		return
	end
	
	--ȫ����ʱ����id �� 1
	jieyi_info._id:Add(1)	
	
	--�����׼������ķŵ����ݿ�
	local compareInfo = CACHE.CompareJieYiInfo()
	compareInfo._id = jieyi_info._id
	compareInfo._boss_info._id = role._roledata._base._id
	compareInfo._boss_info._name = role._roledata._base._name
	compareInfo._boss_info._level = role._roledata._status._level
	compareInfo._boss_info._photo = role._roledata._base._photo
	compareInfo._boss_info._accept = 1 --�Լ��϶����� 1 ���� 0 ������
	compareInfo._boss_info._ready = 1 -- ������洦�� 1 ���� 0 ������
	compareInfo._boss_info._time = API_GetTime()  --��Ҫʱ��ӿ�
	jieyi_info._compare_jieyi_info:Insert(compareInfo._id,compareInfo)	
	
	--������Ҫ����jieyiroleinfo type =1 �����Ѿ����� type =2 ׼������
	role._roledata._jieyi_info._cur_operate_id = jieyi_info._id
	role._roledata._jieyi_info._cur_operate_typ = 2
	
	resp.cur_operate_id = role._roledata._jieyi_info._cur_operate_id:ToStr()
	resp.cur_operate_typ = role._roledata._jieyi_info._cur_operate_typ
	
	player:SendToClient(SerializeCommand(resp))	
end
