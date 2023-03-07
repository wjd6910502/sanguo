function OnCommand_EnterInstance(player, role, arg, others)
	player:Log("OnCommand_EnterInstance, "..DumpTable(arg))

	local msg = NewMessage("CheckClientVersion")
	player:SendMessage(role._roledata._base._id, SerializeMessage(msg))

	local resp = NewCommand("EnterInstance_Re")
	resp.retcode = 0
	resp.inst_tid = arg.inst_tid
	--�ж���������Ƿ�����������
	local ed = DataPool_Find("elementdata")
	local stage = ed:FindBy("stage_id", arg.inst_tid)
	if stage == nil then
		resp.retcode = G_ERRCODE["NO_STAGE"]--û������ؿ�
		player:SendToClient(SerializeCommand(resp))
		player:Log("OnCommand_EnterInstance, error=NO_STAGE")
		return
	end
	
	--���PVP�汾
	local cur_pvp_ver = ROLE_GetPVPVersion(role._roledata._client_ver._client_id, role._roledata._client_ver._exe_ver, role._roledata._client_ver._data_ver)
	if cur_pvp_ver <= 0 then
		local resp = NewCommand("ErrorInfo")
		resp.error_id = G_ERRCODE["EXE_OUT_OF_DATE"]
		player:SendToClient(SerializeCommand(resp))
		player:Log("OnCommand_EnterInstance, error=EXE_OUT_OF_DATE")
		return
	end

	local first_flag = 0
	if role._roledata._status._instances:Find(arg.inst_tid) == nil then
		first_flag = 1
	end
	local vp = role._roledata._status._vp
	local need_vp = 0
	if first_flag == 0 then
		need_vp = (stage.enter_tili + stage.finish_tili)
	else
		need_vp = stage.first_enter_tili + stage.first_finish_tili
	end
	if need_vp > vp then
		resp.retcode = G_ERRCODE["NO_ENOUGHVP"]--��ҵ���������
		player:SendToClient(SerializeCommand(resp))
		player:Log("OnCommand_EnterInstance, error=NO_ENOUGHVP")
		return
	end

	if stage.limittimes ~= 0 then
		if LIMIT_TestUseLimit(role, stage.limittimes, 1) == false then
			resp.retcode = G_ERRCODE["NO_COUNT"]--�������û���˴���
			player:SendToClient(SerializeCommand(resp))
			player:Log("OnCommand_EnterInstance, error=NO_COUNT")
			return
		end
	end

	--ǰ�ùؿ��Ƿ�����,�Լ��Ǽ�
	local instance = role._roledata._status._instances
	if stage.req_stage ~= 0 then
		local i = instance:Find(stage.req_stage)
		if i == nil then
			resp.retcode = G_ERRCODE["NO_REQSTAGE"]--��û�д�ͨǰ�ùؿ�
			player:SendToClient(SerializeCommand(resp))
			player:Log("OnCommand_EnterInstance, error=NO_REQSTAGE")
			return
		else
			if i._star < stage.req_stagestars then
				resp.retcode = G_ERRCODE["NO_REQSTAR"]--ǰ�ùؿ����Ǽ���������Ҫ��
				player:SendToClient(SerializeCommand(resp))
				player:Log("OnCommand_EnterInstance, error=NO_REQSTAR")
				return
		end
		end
	end

	if stage.req_stage2 ~= 0 then
		local i = instance:Find(stage.req_stage2)
		if i == nil then
			resp.retcode = G_ERRCODE["NO_REQSTAGE"]--��û�д�ͨǰ�ùؿ�
			player:SendToClient(SerializeCommand(resp))
			player:Log("OnCommand_EnterInstance, error=NO_REQSTAGE")
			return
		else
			if i._star < stage.req_stagestars2 then
				resp.retcode = G_ERRCODE["NO_REQSTAR"]--ǰ�ùؿ����Ǽ���������Ҫ��
				player:SendToClient(SerializeCommand(resp))
				player:Log("OnCommand_EnterInstance, error=NO_REQSTAR")
				return
			end
		end
	end

	--�ж���ҵĵȼ��Ƿ�ﵽ��
	local level = role._roledata._status._level
	if level < stage.req_level then
		resp.retcode = G_ERRCODE["NO_LEVEL"]--��ҵĵȼ�û�дﵽ����ؿ���Ҫ��
		player:SendToClient(SerializeCommand(resp))
		player:Log("OnCommand_EnterInstance, error=NO_LEVEL")
		return
	end
	--��ʼ�ж��佫��Ϣ
	local req_hero = ed:FindBy("requisite_role", arg.inst_tid)
	if req_hero == nil then
		if stage.stagetype == 1 then
			if role._roledata._status._last_horse_hero._horse == 0 or role._roledata._status._last_horse_hero._heroinfo:Size() == 0 then
				resp.retcode = G_ERRCODE["INSTANCE_NO_HERO"]--�������ó�ս���佫
				player:SendToClient(SerializeCommand(resp))
				player:Log("OnCommand_EnterInstance, error=INSTANCE_NO_HERO")
				return
			end
		else
			if role._roledata._status._last_hero:Size() == 0 then
				resp.retcode = G_ERRCODE["INSTANCE_NO_HERO"]--�������ó�ս���佫
				player:SendToClient(SerializeCommand(resp))
				player:Log("OnCommand_EnterInstance, error=INSTANCE_NO_HERO")
				return
			end
		end
	else
		--����佫�ĺϷ���,�������Ƿ�����Щ�佫
		local heros = role._roledata._hero_hall._heros

		for i = 1, table.getn(arg.heros) do
			local h = heros:Find(arg.heros[i])
			if h == nil then
				resp.retcode = G_ERRCODE["NO_HERO"]
				player:SendToClient(SerializeCommand(resp))
				player:Log("OnCommand_EnterInstance, error=NO_HERO")
				return
			end
		end

		--if role._roledata._status._last_horse_hero._horse == 0 then
		--	resp.retcode = G_ERRCODE["INSTANCE_NO_HERO"]--�������ó�ս���佫
		--	player:SendToClient(SerializeCommand(resp))
		--	return
		--end
	end
	if first_flag == 0 then
		ROLE_Subvp(role, stage.enter_tili)
	else
		ROLE_Subvp(role, stage.first_enter_tili)
	end
	role._roledata._status._instance_id = arg.inst_tid
	resp.seed = math.random(1000000) --TODO:
	role._roledata._status._fight_seed = resp.seed
	role._roledata._status._time_line = G_ROLE_STATE["INSTANCE"]
	player:SendToClient(SerializeCommand(resp))

	--����ͳ����־
	local date = os.date("%Y-%m-%d %H:%M:%S")
	player:BILog("{\"logtime\":\""..date.."\",\"logname\":\"startinstance\",\"serverid\":\""..API_GetZoneId().."\",\"os\":\""
		..role._roledata._device_info._os.."\",\"platform\":\"".."laohu".."\",\"userid\":\""..role._roledata._status._account..
		"\",\"account\":\""..role._roledata._status._account.."\",\"roleid\":\""..role._roledata._base._id:ToStr()..
		"\",\"rolename\":\""..role._roledata._base._name.."\",\"lev\":\""..role._roledata._status._level.."\",\"totalcash\":\""
		.."0".."\",\"chapterid\":\""..stage.chapterid.."\",\"ectypeid\":\""..stage.stageid.."\",\"stagetype\":\""..stage.isifstage..
		"\",\"fight\":\""..role._roledata._status._zhanli.."\"}")


	--����������BattleRoleData
	--ROLE_SetBattleRoleData(role, stage, 1, 1, 3, resp.seed, arg.heros[1], arg.heros[2], arg.heros[3])
end