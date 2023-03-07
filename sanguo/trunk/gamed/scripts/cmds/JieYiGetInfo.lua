function OnCommand_JieYiGetInfo(player, role, arg, others)
	player:Log("OnCommand_JieYiGetInfo, "..DumpTable(arg).." "..DumpTable(others))
	
	local resp = NewCommand("JieYiGetInfo_Re")
	--ȫ�ֵĽ�����Ϣ�� �Ȼ�ȡ������Ϣ �����������н�����Ϣ��1 �Ѿ������ 2 ׼���������Ϣ ��
	local jieyi_info = others.jieyi_info._data	
	
	resp.brotherinfo = {}
	resp.bossinfo = {}
	resp.level = 0
	resp.exp = 0
	--�Ѿ������
	local tmp_id = CACHE.Int64()
	tmp_id:Set(arg.id)
	local fit = jieyi_info._jieyi_info:Find(tmp_id)
	if fit ~= nil then
		
		local v =  fit;
		resp.id = v._id:ToStr()
		resp.name = v._name
		resp.level = v._level
		resp.exp = v._exp
		resp.typ = 1
		--resp.bossinfo = {}
		resp.bossinfo.id = v._boss_info._id:ToStr()
		resp.bossinfo.name = v._boss_info._name
		resp.bossinfo.level = v._boss_info._level
		resp.bossinfo.photo = v._boss_info._photo
		resp.bossinfo.accept = v._boss_info._accept
		resp.bossinfo.ready  = v._boss_info._ready
		resp.bossinfo.time  = v._boss_info._time
		--�ֵ���Ϣ
		local sit = v._brother_info:SeekToBegin()
		local s = sit:GetValue()
		while s ~= nil do
			local tmp_brother = {}
			tmp_brother.id = s._id:ToStr()
			tmp_brother.name = s._name
			tmp_brother.level = s._level
			tmp_brother.photo = s._photo
			tmp_brother.accept = s._accept
			tmp_brother.ready = s._ready
			tmp_brother.time = s._time
			resp.brotherinfo[#resp.brotherinfo+1] = tmp_brother
			sit:Next()
			s = sit:GetValue()
		end
		
		player:SendToClient(SerializeCommand(resp))
		return
	end	
	
	--׼�������		
	local fit = jieyi_info._compare_jieyi_info:Find(tmp_id)
	if fit ~= nil then
		
		player:Log("OnCommand_JieYiGetInfo, "..fit._id:ToStr())
		resp.id = fit._id:ToStr()
		resp.name = fit._name
		resp.level = fit._level
		resp.exp = fit._exp
		resp.typ = 2
		--resp.bossinfo = {}
		resp.bossinfo.id = fit._boss_info._id:ToStr()
		resp.bossinfo.name = fit._boss_info._name
		resp.bossinfo.level = fit._boss_info._level
		resp.bossinfo.photo = fit._boss_info._photo
		resp.bossinfo.accept = fit._boss_info._accept
		resp.bossinfo.ready  = fit._boss_info._ready
		resp.bossinfo.time  = fit._boss_info._time
	
		--�ֵ���Ϣ
		--resp.brotherInfo = {}
		local sit = fit._brother_info:SeekToBegin()
		local s = sit:GetValue()
		while s ~= nil do
			local tmp_brother = {}
			tmp_brother.id = s._id:ToStr()
			tmp_brother.name = s._name
			tmp_brother.level = s._level
			tmp_brother.photo = s._photo
			tmp_brother.accept = s._accept
			tmp_brother.ready = s._ready
			tmp_brother.time = s._time
	
			resp.brotherinfo[#resp.brotherinfo+1] = tmp_brother
			sit:Next()
			s = sit:GetValue()
		end
			
		player:SendToClient(SerializeCommand(resp))
		return
	end	
	
	--û�������� Ҳû�н��� idĬ��Ϊ0
	resp.id = arg.id
	resp.name = role._roledata._jieyi_info._jieyi_name
	player:SendToClient(SerializeCommand(resp))	
	
end