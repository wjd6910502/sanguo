function OnCommand_JieYiLastCreate(player, role, arg, others)
	player:Log("OnCommand_JieYiLastCreate, "..DumpTable(arg).." "..DumpTable(others))
	
	--��ʽ�������� ������С�ܷ���Ϣ ȷ���Ƿ�ͬ��
	local resp = NewCommand("JieYiLastCreate_Re")	
	local jieyi_info = others.jieyi_info._data
	resp.name = arg.name
	resp.dest_id = role._roledata._base._id:ToStr()
	
	--��������� �������� ��ôֱ���Ƴ�
	--[[
	local isjieyi = 1
	local brotherall = GetbrotherIds(jieyi_info,arg.typ,role._roledata._jieyi_info._jieyi_id )
	player:Log("OnCommand_JieYiLastCreate, ".."111111111111111111111111")
	for i = 1, #brotherall	do
		local dest_id = brotherall[i]
		if dest_id ~= role._roledata._base._id:ToStr() then
			local dest_role = others.roles[dest_id]
			player:Log("OnCommand_JieYiLastCreate, ".."222222233333")
			if dest_role._roledata._jieyi_info._jieyi_id:ToStr() == "0" then
				player:Log("OnCommand_JieYiLastCreate, ".."222222222222222222")
				isjieyi = 0
				break
			end
		end
	end
	
	if isjieyi == 1 then
		--�Ѿ�����
		return
	end
	--]]

	--׼�������
	local fit = {}
	local tmp_id = 0	
	player:Log("OnCommand_JieYiLastCreate, ".."111111111111111111111111111111111111111")
	--type = 1 �����Ѿ����� type =2 ׼������
	if role._roledata._jieyi_info._cur_operate_typ == 1 then
		fit = jieyi_info._jieyi_info:Find(role._roledata._jieyi_info._jieyi_id)
		resp.id = role._roledata._jieyi_info._jieyi_id:ToStr()
		tmp_id = role._roledata._jieyi_info._jieyi_id
	elseif role._roledata._jieyi_info._cur_operate_typ == 2 then
		player:Log("OnCommand_JieYiLastCreate, ".."222222222222222233333333333333333333")
		fit = jieyi_info._compare_jieyi_info:Find(role._roledata._jieyi_info._cur_operate_id)
		resp.id = role._roledata._jieyi_info._cur_operate_id:ToStr()
		tmp_id = role._roledata._jieyi_info._cur_operate_id
	else
		--�����ڵ�����
		local cmd = NewCommand("ErrorInfo")
		cmd.error_id = G_ERRCODE["JIEYI_REQUEST_TYPE_WRONG"]
		role:SendToClient(SerializeCommand(cmd))
		player:Log("OnCommand_JieYiLastCreate, error=JIEYI_REQUEST_TYPE_WRONG")
		return
	end
	player:Log("OnCommand_JieYiLastCreate, ".."222222222222222222222222222222222")
	if fit ~= nil then
		player:Log("OnCommand_JieYiLastCreate, ".."4444444444444444444444444444444")
		--��֤�������Ƿ��ǽ���״̬
		local brother_ids = {}
		local v = fit
		local sit = v._brother_info:SeekToBegin()
		local s = sit:GetValue()
		while s ~= nil do	
			if s._accept ~= 1 then --��������
				-- ���ش�����
				local cmd = NewCommand("ErrorInfo")
				cmd.error_id = G_ERRCODE["JIEYI_INVITEROLE_NOT_ACCEPT"]
				role:SendToClient(SerializeCommand(cmd))
				player:Log("OnCommand_JieYiLastCreate, error=JIEYI_INVITEROLE_NOT_ACCEPT")
				return
			else
				s._time = API_GetTime()
			end

			sit:Next()
			s = sit:GetValue()
		end
	else
		throw()
	end
	
	role._roledata._jieyi_info._jieyi_name = arg.name
	--�������˶���һ��
	local brotherall = GetbrotherIds(jieyi_info,arg.typ,tmp_id )
	for i = 1, #brotherall	do
		local dest_id = brotherall[i]
		if dest_id == role._roledata._base._id:ToStr() then
			player:Log("OnCommand_JieYiLastCreate, ".."send self...........")
			role:SendToClient(SerializeCommand(resp))
		else
			player:Log("OnCommand_JieYiLastCreate, ".."send other...........")
			local dest_role = others.roles[dest_id]
			dest_role:SendToClient(SerializeCommand(resp))
		end
	end
				
end

