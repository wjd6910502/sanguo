function OnCommand_JieYiExpelBrother(player, role, arg, others)
	player:Log("OnCommand_JieYiExpelBrother, "..DumpTable(arg).." "..DumpTable(others))
	
	local jieyi_info = others.jieyi_info._data
	
	--ֻ�н������A �ſ������˲���

	local resp = NewCommand("JieYiExpelBrother_Re")
	resp.retcode = 0
	resp.id = arg.id
	resp.name =arg.name
	resp.brother_id = arg.brother_id

	local tmp_id = CACHE.Int64(arg.id)
	local tmp_typ = role._roledata._jieyi_info._cur_operate_typ	
	if tmp_typ ~= 1 then
		return
	end
	
	local fit = jieyi_info._jieyi_info:Find(tmp_id) 
	if fit == nil then
		return
	end	
	
	--�Ƿ����� 
	local dest_role = others.roles[arg.brother_id]
	if dest_role._roledata._status._online == 0 then
		local cmd = NewCommand("ErrorInfo")
		cmd.error_id = G_ERRCODE["JIEYI_INVITEROLE_NOT_ONLINE"]
		role:SendToClient(SerializeCommand(cmd))
		return 
	end

	--�������������Ϊ���Ժ�����ɢ ɾ�������˵�����
	local brotherall = GetbrotherIds(jieyi_info,tmp_typ,tmp_id )

	--��Ҫ���������ɾ������	
	if fit ~= nil  then
		local v = fit
		local bossId = v._boss_info._id:ToStr()
		if bossId ~= role._roledata._base._id:ToStr()  then
				--��A������ ��������
			throw()
			return	
		end
		
		local bro_id = CACHE.Int64(arg.brother_id)
		if v._brother_info:Find(bro_id) ~= nil then
			v._brother_info:Delete( bro_id)
			--���õ�ǰ�˵Ľ���id״̬
			local dest_role = others.roles[arg.brother_id]
			dest_role._roledata._jieyi_info._jieyi_id = CACHE.Int64(0)
			dest_role._roledata._jieyi_info._cur_operate_id = CACHE.Int64(0)
			dest_role._roledata._jieyi_info._cur_operate_typ = 0
			dest_role._roledata._jieyi_info._jieyi_name = ""
			dest_role._roledata._jieyi_info._invite_member:Delete(tmp_id)
			--level
			--exp	
		else
			--�Ҳ����������
			return
		end
	end
	player:Log("OnCommand_JieYiExpelBrother, ".."111111111111111111111111111111111111111")	

	--�������˶���һ��
	--local brotherall_now = GetbrotherIds(jieyi_info,tmp_typ,tmp_id )
	for i = 1, #brotherall	do
		local dest_id = brotherall[i]
		if dest_id ~= role._roledata._base._id:ToStr() then
			player:Log("OnCommand_JieYiExpelBrother, ".."send other.......")
			local dest_role = others.roles[dest_id]
			dest_role:SendToClient(SerializeCommand(resp))
		end
	end
	
	player:Log("OnCommand_JieYiExpelBrother, ".."send self........")
	role:SendToClient(SerializeCommand(resp))

	--���ֻʣ�Լ�
	local brotherall_now = GetbrotherIds(jieyi_info,tmp_typ,tmp_id )
	for i = 1, #brotherall_now  do	
		local dest_id = brotherall_now[i] 
		if dest_id ~= role._roledata._base._id:ToStr() then
			 return
		end
	end

	--�޸����ݿ� ����Լ���ɫ���ϵ�����  ��������˵�����  ���jie_info��ȫ������
	for i = 1, #brotherall	do
		local dest_id = brotherall[i]
		if dest_id == role._roledata._base._id:ToStr() then
			--���tmp_id ��Ҫ����A���ϻ�ȡ	
			role._roledata._jieyi_info._jieyi_id = CACHE.Int64(0)
			role._roledata._jieyi_info._cur_operate_id = CACHE.Int64(0)
			role._roledata._jieyi_info._cur_operate_typ = 0
			role._roledata._jieyi_info._jieyi_name = ""
			role._roledata._jieyi_info._invite_member:Delete(tmp_id)
			--level
			--exp
			player:Log("OnCommand_JieYiExpelBrother, ".."set self........")
		else
			local dest_role = others.roles[dest_id]
			dest_role._roledata._jieyi_info._jieyi_id = CACHE.Int64(0)
			dest_role._roledata._jieyi_info._cur_operate_id = CACHE.Int64(0)
			dest_role._roledata._jieyi_info._cur_operate_typ = 0
			dest_role._roledata._jieyi_info._jieyi_name = ""
			dest_role._roledata._jieyi_info._invite_member:Delete(tmp_id)
			--level
			--exp
			player:Log("OnCommand_JieYiExpelBrother, ".."set other........")
		end	
	end
	
	--��map��ɾ����������
	local fit = jieyi_info._jieyi_info:Find(tmp_id)		
	if fit ~= nil then
		jieyi_info._jieyi_info:Delete(tmp_id)
	else
		--�Ѿ���ɢ
	end

	--�����ɢЭ��
	local resp = NewCommand("JieYiDisolve_Re")
	resp.retcode = 0
	for i = 1, #brotherall	do
		local dest_id = brotherall[i]
		if dest_id ~= role._roledata._base._id:ToStr() then
			player:Log("OnCommand_JieYiExpelBrother, ".."JieYiDisolve_Re send other.......")
			local dest_role = others.roles[dest_id]
			dest_role:SendToClient(SerializeCommand(resp))
			isonlyself = 1
		end
	end
	
	player:Log("OnCommand_JieYiExpelBrother, ".." JieYiDisolve_Re send self........")
	role:SendToClient(SerializeCommand(resp))

end

