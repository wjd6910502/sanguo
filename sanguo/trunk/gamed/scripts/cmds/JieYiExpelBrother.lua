function OnCommand_JieYiExpelBrother(player, role, arg, others)
	player:Log("OnCommand_JieYiExpelBrother, "..DumpTable(arg).." "..DumpTable(others))
	
	local jieyi_info = others.jieyi_info._data
	
	--只有结义的主A 才可以做此操作

	local resp = NewCommand("JieYiExpelBrother_Re")
	resp.retcode = 0
	resp.id = arg.id
	resp.name =arg.name
	resp.brother_id = arg.brother_id

	local tmp_id = CACHE.Int64(arg.id)
	local tmp_typ = role._roledata._jieyi_info._cur_operate_typ	
	if tmp_typ ~= 1 then
		return
	end
	
	local fit = jieyi_info._jieyi_info:Find(tmp_id)
	if fit == nil then
		return
	end	
	
	--是否在线
	local dest_role = others.roles[arg.brother_id]
	if dest_role._roledata._status._online == 0 then
		local cmd = NewCommand("ErrorInfo")
		cmd.error_id = G_ERRCODE["JIEYI_INVITEROLE_NOT_ONLINE"]
		role:SendToClient(SerializeCommand(cmd))
		player:Log("OnCommand_JieYiExpelBrother, error=JIEYI_INVITEROLE_NOT_ONLINE")
		return
	end

	--这个放在这里是为了以后结义解散 删除所有人的数据
	local brotherall = GetbrotherIds(jieyi_info,tmp_typ,tmp_id )

	--需要从这个结义删除此人	
	if fit ~= nil  then
		local v = fit
		local bossId = v._boss_info._id:ToStr()
		if bossId ~= role._roledata._base._id:ToStr()  then
				--主A不存在 操作错误
			throw()
			return	
		end
		
		local bro_id = CACHE.Int64(arg.brother_id)
		if v._brother_info:Find(bro_id) ~= nil then
			v._brother_info:Delete( bro_id)
			--设置当前人的结义id状态
			local dest_role = others.roles[arg.brother_id]
			dest_role._roledata._jieyi_info._jieyi_id = CACHE.Int64(0)
			dest_role._roledata._jieyi_info._cur_operate_id = CACHE.Int64(0)
			dest_role._roledata._jieyi_info._cur_operate_typ = 0
			dest_role._roledata._jieyi_info._jieyi_name = ""
			dest_role._roledata._jieyi_info._invite_member:Delete(tmp_id)
			--level
			--exp	
		else
			--找不到驱逐的人
			return
		end
	end
	player:Log("OnCommand_JieYiExpelBrother, ".."111111111111111111111111111111111111111")	

	--给所有人都发一下
	--local brotherall_now = GetbrotherIds(jieyi_info,tmp_typ,tmp_id )
	for i = 1, #brotherall	do
		local dest_id = brotherall[i]
		if dest_id ~= role._roledata._base._id:ToStr() then
			player:Log("OnCommand_JieYiExpelBrother, ".."send other.......")
			local dest_role = others.roles[dest_id]
			dest_role:SendToClient(SerializeCommand(resp))
		end
	end
	
	player:Log("OnCommand_JieYiExpelBrother, ".."send self........")
	role:SendToClient(SerializeCommand(resp))

	--如果只剩自己
	local brotherall_now = GetbrotherIds(jieyi_info,tmp_typ,tmp_id )
	for i = 1, #brotherall_now  do	
		local dest_id = brotherall_now[i]
		if dest_id ~= role._roledata._base._id:ToStr() then
			 return
		end
	end

	--修改数据库 清掉自己角色身上的数据  清掉所有人的数据  清掉jie_info的全局数据
	for i = 1, #brotherall	do
		local dest_id = brotherall[i]
		if dest_id == role._roledata._base._id:ToStr() then
			--这个tmp_id 需要从主A身上获取	
			role._roledata._jieyi_info._jieyi_id = CACHE.Int64(0)
			role._roledata._jieyi_info._cur_operate_id = CACHE.Int64(0)
			role._roledata._jieyi_info._cur_operate_typ = 0
			role._roledata._jieyi_info._jieyi_name = ""
			role._roledata._jieyi_info._invite_member:Delete(tmp_id)
			--level
			--exp
			player:Log("OnCommand_JieYiExpelBrother, ".."set self........")
		else
			local dest_role = others.roles[dest_id]
			dest_role._roledata._jieyi_info._jieyi_id = CACHE.Int64(0)
			dest_role._roledata._jieyi_info._cur_operate_id = CACHE.Int64(0)
			dest_role._roledata._jieyi_info._cur_operate_typ = 0
			dest_role._roledata._jieyi_info._jieyi_name = ""
			dest_role._roledata._jieyi_info._invite_member:Delete(tmp_id)
			--level
			--exp
			player:Log("OnCommand_JieYiExpelBrother, ".."set other........")
		end	
	end
	
	--从map中删除所有数据
	local fit = jieyi_info._jieyi_info:Find(tmp_id)		
	if fit ~= nil then
		jieyi_info._jieyi_info:Delete(tmp_id)
	else
		--已经解散
	end

	--发起解散协议
	local resp = NewCommand("JieYiDisolve_Re")
	resp.retcode = 0
	for i = 1, #brotherall	do
		local dest_id = brotherall[i]
		if dest_id ~= role._roledata._base._id:ToStr() then
			player:Log("OnCommand_JieYiExpelBrother, ".."JieYiDisolve_Re send other.......")
			local dest_role = others.roles[dest_id]
			dest_role:SendToClient(SerializeCommand(resp))
			isonlyself = 1
		end
	end
	
	player:Log("OnCommand_JieYiExpelBrother, ".." JieYiDisolve_Re send self........")
	role:SendToClient(SerializeCommand(resp))

end


