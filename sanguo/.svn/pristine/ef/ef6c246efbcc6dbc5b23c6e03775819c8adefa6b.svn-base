function OnCommand_JieYiOperateInvite(player, role, arg, others)
	player:Log("OnCommand_JieYiOperateInvite, "..DumpTable(arg).." "..DumpTable(others))
	
	local resp = NewCommand("JieYiOperateInvite_Re")	
	local jieyi_info = others.jieyi_info._data
	--未知参数
	resp.retcode = arg.agreement
	resp.name = arg.name
	resp.role_id = role._roledata._base._id:ToStr()
	
	local tmp_id = CACHE.Int64(arg.id)
	--tmp_id.Set(arg.id)
	if role._roledata._jieyi_info._jieyi_id:ToStr() ~= "0" then
		--已经结义不可以操作
		return
	end

	local fit = {}
	--准备结义的处理方法
	if arg.typ == 2 then	
		fit = jieyi_info._compare_jieyi_info:Find(tmp_id)
	elseif  arg.typ == 1   then
		fit = jieyi_info._jieyi_info:Find(tmp_id)	
	else
		--参数错误
		throw()
	end
		
	if fit ~= nil then
		local v = fit
		resp.id = v._id:ToStr()
		player:Log("OnCommand_JieYiOperateInvite, ".."111111111111111111111")					
		--如果agreement  1代表同意 0代表不同意
		if arg.agreement == 0 then
			resp.retcode = 0
			local v = fit
			local s = v._brother_info:Find(role._roledata._base._id)
			if s ~= nil then
				v._brother_info:Delete(role._roledata._base._id)
			else
				--zhaobudao
			end
			--把这个数据邀请数据删除
			role._roledata._jieyi_info._invite_member:Delete(tmp_id)
	
		elseif arg.agreement == 1 then
			resp.retcode = 1
			--设置状态
			local v = fit
			local s = v._brother_info:Find(role._roledata._base._id)
			if s ~= nil then
				player:Log("OnCommand_JieYiOperateInvite, ".."333333333333333333333333")
				player:Log("OnCommand_JieYiOperateInvite, ".."22222222222222222222222222")
				s._accept = 1 --接受邀请
			else
				--zhaobudao
			end
			
		else
			--未知请求参数
			throw()
			return
		end
	else
		return
	end						
		
	--给所有人都发一下
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


