function OnCommand_JieYiExitCurrentJieYi(player, role, arg, others)
	player:Log("OnCommand_JieYiExitCurrentJieYi, "..DumpTable(arg).." "..DumpTable(others))
	
	local jieyi_info = others.jieyi_info._data
	
	local tmp_id = CACHE.Int64(arg.id)
	local tmp_typ = role._roledata._jieyi_info._cur_operate_typ	
	if tmp_typ ~= 1 then
		return
	end
	
	local fit = jieyi_info._jieyi_info:Find(tmp_id)
	if fit == nil then
		return
	end	
	
	--这个放在这里是为了以后结义解散 删除所有人的数据
	local brotherall = GetbrotherIds(jieyi_info,tmp_typ,tmp_id )
	if #brotherall < 2 then
		
		return	
	end

	--需要从这个结义删除此人	
	if fit ~= nil  then
		local v = fit
		local bossId = v._boss_info._id:ToStr()
		if bossId == role._roledata._base._id:ToStr() then
			--主 A 退出 需要其他接班人
			local sit = v._brother_info:SeekToBegin()
			s = sit:GetValue()
			v._boss_info._id = s._id
			v._boss_info._name = s._name
			v._boss_info._level = s._level
			v._boss_info._photo = s._photo
			v._boss_info._accept = s._accept
			v._boss_info._ready = s._ready
			v._boss_info._time = s._time

			v._brother_info:Delete(s._id)
		elseif v._brother_info:Find(role._roledata._base._id) ~= nil then
			v._brother_info:Delete(role._roledata._base._id)
			
		else
			--找不到驱逐的人
			return
		end
	end
	
	--设置当前人的结义id状态
	role._roledata._jieyi_info._jieyi_id = CACHE.Int64(0)
	role._roledata._jieyi_info._cur_operate_id = CACHE.Int64(0)
	role._roledata._jieyi_info._cur_operate_typ = 0
	role._roledata._jieyi_info._jieyi_name = ""
	----level
	----exp
	
	--给所有人都发一下
	local msg = NewMessage("JieYiUpdateExit")
	msg.id = arg.id
	msg.typ = arg.typ
	msg.name = arg.name
	msg.brother_id = role._roledata._base._id:ToStr()
	msg.retcode = 0
	
	--local brotherall = GetbrotherIds(jieyi_info,arg.typ,tmp_id ) 	
	for i = 1, #brotherall  do
		local dest_id =CACHE.Int64( brotherall[i])
		player:Log("OnCommand_JieYiExitCurrentJieYi".."send message.......")			
		player:SendMessage(dest_id, SerializeMessage(msg) )
	end
		
	local brotherall_now = GetbrotherIds(jieyi_info,tmp_typ,tmp_id )
	if #brotherall_now  > 1 then
		return
	end
	
	--清除数据
	for i = 1, #brotherall_now	do
		local dest_id = brotherall_now[i]
		if dest_id == role._roledata._base._id:ToStr() then
			--这个tmp_id 需要从主A身上获取	
			role._roledata._jieyi_info._jieyi_id = CACHE.Int64(0)
			role._roledata._jieyi_info._cur_operate_id = CACHE.Int64(0)
			role._roledata._jieyi_info._cur_operate_typ = 0
			role._roledata._jieyi_info._jieyi_name = ""
			--level
			--exp
		else
			local dest_role = others.roles[dest_id]
			dest_role._roledata._jieyi_info._jieyi_id = CACHE.Int64(0)
			dest_role._roledata._jieyi_info._cur_operate_id = CACHE.Int64(0)
			dest_role._roledata._jieyi_info._cur_operate_typ = 0
			dest_role._roledata._jieyi_info._jieyi_name = ""
			--level
			--exp
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


