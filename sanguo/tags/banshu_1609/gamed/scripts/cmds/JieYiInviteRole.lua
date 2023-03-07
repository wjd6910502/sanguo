function OnCommand_JieYiInviteRole(player, role, arg, others)
	player:Log("OnCommand_JieYiInviteRole, "..DumpTable(arg).." "..DumpTable(others))
	local resp = NewCommand("JieYiInvite_Re")
	
	-- ���ǳ��ν��� �� �Ѿ�������߼�
	local jieyi_info = others.jieyi_info._data					
	local dest_role = others.roles[arg.dest_id]
	if dest_role == nil then
		--�����ڵĽ�ɫ
		local cmd = NewCommand("ErrorInfo")
		cmd.error_id = G_ERRCODE["JIEYI_INVITEROLE_NOT_EXIST"]
		role:SendToClient(SerializeCommand(cmd))
		return 
	end

	--�Ƿ�����
	if dest_role._roledata._status._online == 0 then
		local cmd = NewCommand("ErrorInfo")
		cmd.error_id = G_ERRCODE["JIEYI_INVITEROLE_NOT_ONLINE"]
		role:SendToClient(SerializeCommand(cmd))
		return 
	end
	
	--�Է��Ѿ�����
	local id = dest_role._roledata._jieyi_info._jieyi_id:ToStr()

	if dest_role._roledata._jieyi_info._jieyi_id:ToStr() ~= "0" then
		local cmd = NewCommand("ErrorInfo") 
		cmd.error_id = G_ERRCODE["JIEYI_INVITEROLE_HAS_JIEYI"] 
		role:SendToClient(SerializeCommand(cmd))
		return
	end
	
	--�Է����������ȼ�
	if dest_role._roledata._status._level < 1 then
		local cmd = NewCommand("ErrorInfo") 
		cmd.error_id = G_ERRCODE["JIEYI_INVITEROLE_LEVEL_NOT_ENOUGH"]
		role:SendToClient(SerializeCommand(cmd))
		return	
	end

	--�Է��Ѿ���������������
	local info = {}
	if role._roledata._jieyi_info._cur_operate_typ == 1 then	   							 	
		info = jieyi_info._jieyi_info:Find( role._roledata._jieyi_info._jieyi_id)
		if info ==nil then
			local cmd = NewCommand("ErrorInfo") 
			cmd.error_id = G_ERRCODE["JIEYI_INFO_NOT_FOUND"]
			role:SendToClient(SerializeCommand(cmd))
			return
		end
	elseif role._roledata._jieyi_info._cur_operate_typ == 2 then
	    info = jieyi_info._compare_jieyi_info:Find( role._roledata._jieyi_info._cur_operate_id)
		if info ==nil then
			local cmd = NewCommand("ErrorInfo") 
			cmd.error_id = G_ERRCODE["JIEYI_INFO_NOT_FOUND"]
			role:SendToClient(SerializeCommand(cmd))
			return
		end
	else
		local cmd = NewCommand("ErrorInfo") 
		cmd.error_id = G_ERRCODE["JIEYI_REQUEST_TYPE_WRONG"]
		role:SendToClient(SerializeCommand(cmd))
		return
	end
	
	--A->B ���a��b ͬʱ�������� �������໥����
	--[[if dest_role._roledata._jieyi_info._cur_operate_id:ToStr() ~= "0" then
		local cmd = NewCommand("ErrorInfo")
		cmd.error_id = G_ERRCODE["JIEYI_BROTHER_NOT_INVITED"]
		role:SendToClient(SerializeCommand(cmd))
		player:Log("OnCommand_JieYiInviteRole, ".." ".."jieyi test") 
		return
	end
	--]]
	if info._brother_info:Size() >= 2 then	
		local cmd = NewCommand("ErrorInfo") 
		cmd.error_id = G_ERRCODE["JIEYI_INVITEROLE_NUMBER_SURPASS"]
		role:SendToClient(SerializeCommand(cmd))
		return
	end

	--type = 1 �����Ѿ����� type =2 ׼������
	resp.typ = role._roledata._jieyi_info._cur_operate_typ
	
	if resp.typ == 1 then
		resp.id = role._roledata._jieyi_info._jieyi_id:ToStr()
	elseif resp.typ == 2 then
		resp.id = role._roledata._jieyi_info._cur_operate_id:ToStr()
	else
		local cmd = NewCommand("ErrorInfo") 
		cmd.error_id = G_ERRCODE["JIEYI_INVITEROLE_NOT_CREATED"]
		role:SendToClient(SerializeCommand(cmd)) 
		return
	end
	player:Log("OnCommand_JieYiInviteRole, ".."00000000000000000000000000000000")
	resp.name = role._roledata._jieyi_info._jieyi_name	
	dest_role:SendToClient(SerializeCommand(resp))
	
	--�������ɹ� ���Լ���һ��Э��
	local resp = NewCommand("JieYiInviteRole_Re")
	resp.retcode = 0
	resp.role_id = arg.dest_id 
	role:SendToClient(SerializeCommand(resp))

	--������Ҫ���Ǹ��������û� ���ϼ�һЩ����������Ϣ ���浽���ݿ�
	local invite_info = CACHE.InviteJieInfo()
	if role._roledata._jieyi_info._cur_operate_typ == 2 then
		invite_info._id = role._roledata._jieyi_info._cur_operate_id
	end
	

	if role._roledata._jieyi_info._cur_operate_typ == 1 then
		invite_info._id = role._roledata._jieyi_info._jieyi_id
	end
	
	invite_info._typ = role._roledata._jieyi_info._cur_operate_typ
	invite_info._name = role._roledata._jieyi_info._jieyi_name
	invite_info._time = API_GetTime()
	
	player:Log("OnCommand_JieYiInviteRole, ".."3333333333333333333333"..invite_info._id:ToStr())
	local fit =  dest_role._roledata._jieyi_info._invite_member:Find(invite_info._id)
	if fit == nil then
		player:Log("OnCommand_JieYiInviteRole, ".."1111111111111111111111111111111111")
		dest_role._roledata._jieyi_info._invite_member:Insert(invite_info._id,invite_info)	
	else
		player:Log("OnCommand_JieYiInviteRole, ".."22222222222222222222222222222222222")
		--�Ѿ����� �������
	end
end
