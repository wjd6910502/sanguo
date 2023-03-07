function OnCommand_JieYiGetInviteInfo(player, role, arg, others)
	player:Log("OnCommand_JieYiGetInviteInfo, "..DumpTable(arg).." "..DumpTable(others))
	--获取被邀请的信息
	--这里涉及到数据库存储的修改  jieyi_id  time
		
	local resp = NewCommand("JieYiGetInviteInfo_Re")
	resp.invite_member = {}
	local fit = role._roledata._jieyi_info._invite_member:SeekToBegin()
	local f = fit:GetValue()
	while f ~= nil do
		local tmp_invited = f._id:ToStr()
		--判断时间 如果大于五分钟 直直接删除 有效时间
		local now_t = API_GetTime()
		player:Log("OnCommand_JieYiGetInviteInfo, ".."111111111111111111111111"..tmp_invited)	
		--if now_t - f._time <= 300 then
			resp.invite_member[#resp.invite_member+1] = tmp_invited
		--else
			--删除身上的数据
			--role._roledata._jieyi_info._invite_member:Delete(f._id)
			--还需要把全局的数据删掉
		--end
		player:Log("OnCommand_JieYiGetInviteInfo, ".."111111111111111111111111"..resp.invite_member[1])
		fit:Next()
		f = fit:GetValue()
	end
	player:Log("OnCommand_JieYiGetInviteInfo, ".."send......")
	role:SendToClient(SerializeCommand(resp))		
end
