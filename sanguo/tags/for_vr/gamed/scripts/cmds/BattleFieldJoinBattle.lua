function OnCommand_BattleFieldJoinBattle(player, role, arg, others)
	player:Log("OnCommand_BattleFieldJoinBattle, "..DumpTable(arg).." "..DumpTable(others))

	local resp = NewCommand("BattleFieldJoinBattle_Re")
	
	local battle = role._roledata._battle_info:Find(arg.battle_id)
	local position = battle._position_info:Find(battle._cur_position)
	
	local id = 0
	local army_id = 0
	local npc_it = position._npc_info:SeekToBegin()
	local npc = npc_it:GetValue()
	while npc ~= nil do
		if npc._camp == 2 then
			if arg.npc_id == npc._id and npc._alive == 1 then
				id = npc._id
				army_id = npc._armyid
				break
			end
		end
		npc_it:Next()
		npc = npc_it:GetValue()
	end

	if id == 0 then
		resp.retcode = G_ERRCODE["BATTLE_POSITION_NO_ARMY"]
		player:SendToClient(SerializeCommand(resp))
		return
	end

	if id ~= arg.npc_id then
		resp.retcode = G_ERRCODE["BATTLE_ARMY_NOT_SAME"]
		player:SendToClient(SerializeCommand(resp))
		return
	end

	--�����￪ʼ�жϣ��佫����Ϣ�Ƿ���ȷ
	local ed = DataPool_Find("elementdata")
	local battlearmy_info = ed:FindBy("battlearmy_id", army_id)
	--�ؿ����ͣ�0��ͨ��1��ս��
	if battlearmy_info.stagetype == 0 then
		if battle._cur_hero_info:Size() == 0 then
			resp.retcode = G_ERRCODE["BATTLE_SET_HERO_INFO"]
			player:SendToClient(SerializeCommand(resp))
			return
		end
		local cur_hero_it = battle._cur_hero_info:SeekToBegin()
		local cur_hero = cur_hero_it:GetValue()
		while cur_hero ~= nil do
			local find_hero = battle._hero_info:Find(cur_hero._value)
			if find_hero == nil then
				resp.retcode = G_ERRCODE["BATTLE_SET_HERO_INFO"]
				player:SendToClient(SerializeCommand(resp))
				return
			elseif find_hero._hp == 0 then
				resp.retcode = G_ERRCODE["BATTLE_SET_HERO_INFO"]
				player:SendToClient(SerializeCommand(resp))
				return
			end
			cur_hero_it:Next()
			cur_hero = cur_hero_it:GetValue()
		end
	else
		if battle._cur_hero_horse_info._horse == 0 or battle._cur_hero_horse_info._heroinfo:Size() == 0 then
			resp.retcode = G_ERRCODE["BATTLE_SET_HERO_INFO"]
			player:SendToClient(SerializeCommand(resp))
			return
		end
		local cur_hero_it = battle._cur_hero_horse_info._heroinfo:SeekToBegin()
		local cur_hero = cur_hero_it:GetValue()
		while cur_hero ~= nil do
			local find_hero = battle._hero_info:Find(cur_hero._value)
			if find_hero == nil then
				resp.retcode = G_ERRCODE["BATTLE_SET_HERO_INFO"]
				player:SendToClient(SerializeCommand(resp))
				return
			elseif find_hero._hp == 0 then
				resp.retcode = G_ERRCODE["BATTLE_SET_HERO_INFO"]
				player:SendToClient(SerializeCommand(resp))
				return
			end
			cur_hero_it:Next()
			cur_hero = cur_hero_it:GetValue()
		end
	end
	
	--�����￪ʼ�ж�������صĶ���
	if role._roledata._status._vp < (battlearmy_info.enter_tili + battlearmy_info.end_tili) then
		resp.retcode = G_ERRCODE["BATTLE_VP_LESS"]
		player:SendToClient(SerializeCommand(resp))

		--���������˻ص���һ�ε�λ��
		resp = NewCommand("BattleFieldCancel_Re")
		resp.battle_id = arg.battle_id
		battle._cur_position = battle._last_position
		resp.retcode = G_ERRCODE["SUCCESS"]
		resp.position = battle._cur_position
		player:SendToClient(SerializeCommand(resp))
		return
	end

	ROLE_Subvp(role, battlearmy_info.enter_tili)

	--����Ϳ��Է�����ȷ��
	resp.retcode = G_ERRCODE["SUCCESS"]
	resp.battle_id = arg.battle_id
	resp.npc_id = arg.npc_id
	player:SendToClient(SerializeCommand(resp))
	return
end
