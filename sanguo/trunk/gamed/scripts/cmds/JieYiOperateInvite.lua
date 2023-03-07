function OnCommand_JieYiOperateInvite(player, role, arg, others)
	player:Log("OnCommand_JieYiOperateInvite, "..DumpTable(arg).." "..DumpTable(others))
	
	local resp = NewCommand("JieYiOperateInvite_Re")	
	local jieyi_info = others.jieyi_info._data
	--δ֪����
	resp.retcode = arg.agreement
	resp.name = arg.name
	resp.role_id = role._roledata._base._id:ToStr()
	
	local tmp_id = CACHE.Int64(arg.id)
	--tmp_id.Set(arg.id)
	if role._roledata._jieyi_info._jieyi_id:ToStr() ~= "0" then
		--�Ѿ����岻���Բ���
		return
	end

	local fit = {}
	--׼������Ĵ�������
	if arg.typ == 2 then	
		fit = jieyi_info._compare_jieyi_info:Find(tmp_id)
	elseif  arg.typ == 1   then
		fit = jieyi_info._jieyi_info:Find(tmp_id)	
	else
		--��������
		throw()
	end
		
	if fit ~= nil then
		local v = fit
		resp.id = v._id:ToStr()
		player:Log("OnCommand_JieYiOperateInvite, ".."111111111111111111111")					
		--���agreement  1����ͬ�� 0������ͬ��
		if arg.agreement == 0 then
			resp.retcode = 0
			local v = fit
			local s = v._brother_info:Find(role._roledata._base._id)
			if s ~= nil then
				v._brother_info:Delete(role._roledata._base._id)
			else
				--zhaobudao
			end
			--�����������������ɾ��
			role._roledata._jieyi_info._invite_member:Delete(tmp_id)
	
		elseif arg.agreement == 1 then
			resp.retcode = 1
			--����״̬
			local v = fit
			local s = v._brother_info:Find(role._roledata._base._id)
			if s ~= nil then
				player:Log("OnCommand_JieYiOperateInvite, ".."333333333333333333333333")
				player:Log("OnCommand_JieYiOperateInvite, ".."22222222222222222222222222")
				s._accept = 1 --��������
			else
				--zhaobudao
			end
			
		else
			--δ֪�������
			throw()
			return
		end
	else
		return
	end						
		
	--�������˶���һ��
	local brotherall = GetbrotherIds(jieyi_info,arg.typ,tmp_id )
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
end

