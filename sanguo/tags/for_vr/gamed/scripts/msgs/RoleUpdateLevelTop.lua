function OnMessage_RoleUpdateLevelTop(player, role, arg, others)
	player:Log("OnMessage_RoleUpdateLevelTop, "..DumpTable(arg).." "..DumpTable(others))

	--�����������Ҫ�����е����а�Ҫ����ˢһ�Σ���Ϊ�����ҵĵȼ��޸��ˡ��Ժ󿴿��ǲ�����ʲô�õİ취ȥ�����
	--�ȼ���
	TOP_InsertData(others.toplist._top_manager, 1, role._roledata._base._id, role._roledata._status._level, 
			role._roledata._base._name, role._roledata._base._photo, role._roledata._status._level, 0, 0, 0)
	--PVP���ְ�
	local data = 0
	if role._roledata._pvp_info._pvp_grade == 0 then
		--������Ϊ�������а��������е�ʱ������һЩ.
		--����������һЩ����ģ�������ҵĴ�˵�����������10000
		data = role._roledata._pvp_info._cur_star + 10000
	else
		for i = 25, role._roledata._pvp_info._pvp_grade + 1, -1 do
			local ed = DataPool_Find("elementdata")
			local ranking = ed:FindBy("ranking_id", i)
			data = data + ranking.ascending_order_star
		end
		data = data + role._roledata._pvp_info._cur_star
	end
	TOP_InsertData(others.toplist._top_manager, 3, role._roledata._base._id, data, role._roledata._base._name, 
			role._roledata._base._photo, role._roledata._status._level, 0, 0, 0)
	--������
	TOP_InsertData(others.toplist._top_manager, 4, role._roledata._base._id, role._roledata._pve_arena_info._score, 
			role._roledata._base._name, role._roledata._base._photo, role._roledata._status._level, 0, 0, 0)
end
