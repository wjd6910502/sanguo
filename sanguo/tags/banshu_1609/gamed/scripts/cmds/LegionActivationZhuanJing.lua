function OnCommand_LegionActivationZhuanJing(player, role, arg, others)
	player:Log("OnCommand_LegionActivationZhuanJing, "..DumpTable(arg).." "..DumpTable(others))

	local resp = NewCommand("LegionActivationZhuanJing_Re")
	resp.retcode = G_ERRCODE["SUCCESS"]
	resp.id = arg.id
	resp.info = {}
	
	local ed = DataPool_Find("elementdata")
	local legionspec_info = ed:FindBy("legionspec_id", arg.id)

	if legionspec_info == nil then
		resp.retcode = G_ERRCODE["SYSTEM_DATA_ERR"]
		player:SendToClient(SerializeCommand(resp))
		return
	end
	--��ʼ�ж����еĳɾ��Ƿ��Ѿ����
	local open_flag = true
	if legionspec_info.spec_unlock_achievement ~= 0 then
		--�ж�����ɾ��Ƿ������
		local task_info = role._roledata._task._current_task:Find(legionspec_info.spec_unlock_achievement)
		if task_info ~= nil then
			local task_condition = task_info._task_condition
			local it2 = task_condition:SeekToBegin()
			local inv2 = it2:GetValue()
			while inv2~=nil do
				if inv2._num < inv2._maxnum then
					open_flag = false
					break
				end
				it2:Next()
				inv2 = it2:GetValue()
			end
		end
	end

	if open_flag == false then
		resp.retcode = G_ERRCODE["LEGION_ACH_NOT_FINISH"]
		player:SendToClient(SerializeCommand(resp))
		return
	end

	local find_info = role._roledata._legion_info._junxueguan._junxueinfo:Find(arg.id)
	if find_info == nil then
		--���¸��ͻ��˿������µľ�ѧר��
		resp.info.id = arg.id
		resp.info.level = 1
		resp.info.learned = {}
		
		local insert_info = CACHE.JunXueZhuanJingData()
		insert_info._id = arg.id
		insert_info._level = 1
		
		local insert_learned = CACHE.Int()
		insert_learned._value = legionspec_info.spec_original_tech
		insert_info._learned:Insert(legionspec_info.spec_original_tech, insert_learned)
	
		resp.info.learned[#resp.info.learned+1] = legionspec_info.spec_original_tech
		role._roledata._legion_info._junxueguan._junxueinfo:Insert(arg.id, insert_info)
	else
		--֪ͨ�ͻ����Ѿ����������ר��
		resp.retcode = G_ERRCODE["LEGION_HAVE_ACTIVE"]
	end

	ROLE_UpdateZhanli(role)
	player:SendToClient(SerializeCommand(resp))
end