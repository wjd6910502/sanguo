function OnCommand_JieYiExitCurrentJieYi(player, role, arg, others)
	player:Log("OnCommand_JieYiExitCurrentJieYi, "..DumpTable(arg).." "..DumpTable(others))
	
	local jieyi_info = others.jieyi_info._data

	local resp = NewCommand("JieYiCancelInviteRole_Re")
	resp.retcode = 0
	resp.id = arg.id
	resp.name =arg.name
	resp.brother_id = role._roledata._base.id:ToStr()
	
	local tmp_id = CACHE.Int64(arg.id)
	local tmp_typ = role._roledata._jieyi_info._cur_operate_typ	
	if tmp_typ ~= 1 then
		return
	end
	
	local fit = jieyi_info._jieyi_info:Find(tmp_id) 
	if fit == nil then
		return
	end	
	
	--�������������Ϊ���Ժ�����ɢ ɾ�������˵�����
	local brotherall = GetbrotherIds(jieyi_info,tmp_typ,tmp_id )
	if #brotherall < 2 then
		
		return	
	end

	--��Ҫ���������ɾ������	
	if fit ~= nil  then
		local v = fit
		local bossId = v._boss_info._id:ToStr()
		if bossId == role._roledata._base._id:ToStr() then
			--�� A �˳� ��Ҫ�����Ӱ���
			local sit = v._brother_info:SeekToBegin()
			s = sit:GetValue()
			v._boss_info._id = s._id
			v._boss_info._name = s._name
			v._boss_info._level = s._level
			v._boss_info._photo = s._photo
			v._boss_info._accept = s._accept
			v._boss_info._ready = s._ready
			v._boss_info._time = s._time

			v._brother_info:Delete(s._id) 
		elseif v._brother_info:Find(role._roledata._base._id) ~= nil then
			v._brother_info:Delete(role._roledata._base._id)
			
		else
			--�Ҳ����������
			return
		end
	end
	
	--���õ�ǰ�˵Ľ���id״̬
	role._roledata._jieyi_info._jieyi_id = CACHE.Int64(0)
	role._roledata._jieyi_info._cur_operate_id = CACHE.Int64(0)
	role._roledata._jieyi_info._cur_operate_typ = 0
	role._roledata._jieyi_info._jieyi_name = ""
	----level
	----exp
	
	--�������˶���һ��
	local brotherall = GetbrotherIds(jieyi_info,tmp_typ,tmp_id )
	for i = 1, #brotherall	do
		local dest_id = brotherall[i]
		if dest_id ~= role._roledata._base._id:ToStr() then
			player:Log("OnCommand_JieYiOperateInvite, ".."send other.......")
			local dest_role = others.roles[dest_id]
			dest_role:SendToClient(SerializeCommand(resp))
		end
	end
	
	player:Log("OnCommand_JieYiOperateInvite, ".."send self........")
	role:SendToClient(SerializeCommand(resp))
		
	local brotherall_now = GetbrotherIds(jieyi_info,tmp_typ,tmp_id )
	if #brotherall_now  > 2 then
		return
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
			--level
			--exp
			player:Log("OnCommand_JieYiExpelBrother, ".."set self........")
		else
			local dest_role = others.roles[dest_id]
			dest_role._roledata._jieyi_info._jieyi_id = CACHE.Int64(0)
			dest_role._roledata._jieyi_info._cur_operate_id = CACHE.Int64(0)
			dest_role._roledata._jieyi_info._cur_operate_typ = 0
			role._roledata._jieyi_info._jieyi_name = ""
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

