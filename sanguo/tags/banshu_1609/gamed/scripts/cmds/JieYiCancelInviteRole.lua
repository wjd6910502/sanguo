function OnCommand_JieYiCancelInviteRole(player, role, arg, others)
	player:Log("OnCommand_JieYiCancelInviteRole, "..DumpTable(arg).." "..DumpTable(others))
	
	local jieyi_info = others.jieyi_info._data

	local resp = NewCommand("JieYiCancelInviteRole_Re")
	resp.retcode = 0
	resp.id = arg.id
	resp.name = arg.name
	resp.brother_id = arg.brother_id
	
	local tmp_id = CACHE.Int64(arg.id)
	local tmp_typ = 2	
	local fit = jieyi_info._compare_jieyi_info:Find(tmp_id)
	if fit == nil then
		fit = jieyi_info._jieyi_info:Find(tmp_id) 
		if fit == nil then
			return
		end
		tmp_typ = 1
	end
	

	--�������A�����ȡ������ ֱ�ӰѴ���������ֵ����ݶ�ɾ��
	if fit._boss_info._id:ToStr() == role._roledata._base._id:ToStr() then		
		--���û�н���
		if role._roledata._jieyi_info._cur_operate_typ == 2 then
			
			fit._brother_info:Clear()
		elseif role._roledata._jieyi_info._cur_operate_typ == 1 then
			local broid = CACHE.Int64(arg.brother_id)
			local sit = fit._brother_info:Find(broid)
			player:Log("OnCommand_JieYiCancelInviteRole, ".."1333333")
			if sit ~= nil then
				player:Log("OnCommand_JieYiCancelInviteRole, ".."1444444")		
				fit._brother_info:Delete(broid)
			end
		else
			player:Log("OnCommand_JieYiCancelInviteRole, ".."15555")
			fit._brother_info:Clear()
		end
	end
	

	--�ѱ������ϵ�����ɾ����
	local dest_role = others.roles[arg.brother_id]
	player:Log("OnCommand_JieYiCancelInviteRole, ".."11111111111111111111111111")
	local ffit =  dest_role._roledata._jieyi_info._invite_member:Find(tmp_id)
	player:Log("OnCommand_JieYiCancelInviteRole, ".."22222222222222222222222222")
	if ffit ~= nil then
		player:Log("OnCommand_JieYiCancelInviteRole, ".."33333333333333333333333")
		dest_role._roledata._jieyi_info._invite_member:Delete(tmp_id)
		
	else
		player:Log("OnCommand_JieYiCancelInviteRole, ".."4444444444444444444444444")
		--����û�б������ ����ȡ������ ��Ч
		return
	end
	
	--���б���ɾ��
	local bid =CACHE.Int64(arg.brother_id)
	fit._brother_info:Delete(bid)
	
	player:Log("OnCommand_JieYiCancelInviteRole, ".."555555555555555555555555") 
	--���Լ���Ŀ�귢һ��
	player:Log("OnCommand_JieYiCancelInviteRole, ".."send other........")
	dest_role:SendToClient(SerializeCommand(resp))
	player:Log("OnCommand_JieYiCancelInviteRole, ".."send self........")
	role:SendToClient(SerializeCommand(resp))
		
end


