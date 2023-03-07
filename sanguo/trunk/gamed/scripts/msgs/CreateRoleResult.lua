function OnMessage_CreateRoleResult(player, role, arg, others)
	player:Log("OnMessage_CreateRoleResult, "..DumpTable(arg).." "..DumpTable(others))

	local resp = NewCommand("CreateRole_Re")
	if arg.retcode==G_ERRCODE["SUCCESS"] then
		resp.retcode = 0
		ROLE_Init(role)--��ɫ��һЩ���ݽ��г�ʼ��
		--if role._roledata._base._sex == 1 and role._roledata._base._photo == 4 then
		--	ROLE_Copy(role, others.roles[tostring(role._roledata._base._photo)])
		--if role._roledata._base._sex == 1 and role._roledata._base._photo == 1 then
		--	ROLE_Copy(role, others.roles["4"])
		--	ROLE_PostInit(role)
		--end
		TASK_RefreshTask(role)--��ɫ�ĳɾͽ��г�ʼ��
		TASK_ChangeCondition(role, G_ACH_TYPE["LEVEL_FINISH"], 0, role._roledata._status._level)
		resp.info = ROLE_MakeRoleInfo(role)
	else
		--��Զû�л�����õ�
	end
	player:SendToClient(SerializeCommand(resp))
	
	role:SendRoleInfoToRegister(role._roledata._base._name, role._roledata._status._level,  role._roledata._base._photo)
	
	--ģ�����ҽ�ɫ��
	local cache = others.rolenamecache
	local rolebrief = CACHE.RoleBrief()
	rolebrief._id = role._roledata._base._id
	rolebrief._name = role._roledata._base._name
	rolebrief._photo = role._roledata._base._photo
	rolebrief._level = role._roledata._status._level
	rolebrief._mafia_id = role._roledata._mafia._id
	rolebrief._mafia_name = role._roledata._mafia._name
	rolebrief._sex = role._roledata._base._sex
	rolebrief._photo_frame = role._roledata._base._photo_frame
	rolebrief._badge_map = CACHE.BadgeInfoMap()
	local badge_info_it = role._roledata._base._badge_map:SeekToBegin()
	local badge_info = badge_info_it:GetValue()
	while badge_info ~= nil do
		local tmp_badge_info = CACHE.BadgeInfo()
		tmp_badge_info._id = badge_info._id
		tmp_badge_info._pos = badge_info._pos
		rolebrief._badge_map:Insert(tmp_badge_info._id, tmp_badge_info)

		badge_info_it:Next()
		badge_info = badge_info_it:GetValue()
	end

	cache:Insert(rolebrief)
	
	--����ͳ����־
	local date = os.date("%Y-%m-%d %H:%M:%S")
	player:BILog("{\"logtime\":\""..date.."\",\"logname\":\"createrole\",\"serverid\":\""..API_GetZoneId()..
		"\",\"os\":\""..role._roledata._device_info._os.."\",\"platform\":\"".."laohu".."\",\"mac\":\""
		..role._roledata._device_info._mac.."\",\"userid\":\""..role._roledata._status._account.."\",\"account\":\""
		..role._roledata._status._account.."\",\"roleid\":\""..role._roledata._base._id:ToStr().."\",\"rolename\":\""
		..role._roledata._base._name.."\",\"occupation\":\"0\",\"ip\":\""..role._roledata._device_info._public_ip..
		"\",\"device_model\":\""..role._roledata._device_info._device_model.."\",\"device_sys\":\""
		..role._roledata._device_info._device_sys.."\",\"device_ram\":\""..role._roledata._device_info._device_ram..
		"\",\"idfa\":\"".."0".."\",\"device_id\":\"".."0".."\"}")

end
