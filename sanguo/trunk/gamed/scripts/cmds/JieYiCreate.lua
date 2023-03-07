function OnCommand_JieYiCreate(player, role, arg, others)
	player:Log("OnCommand_JieYiCreate, "..DumpTable(arg).." "..DumpTable(others))
	local resp = NewCommand("JieYiCreate_Re")	
	local jieyi_info = others.jieyi_info._data	
	
	--判断 如果结义id 存在 代表已经结义 不能创建
	if role._roledata._jieyi_info._jieyi_id:ToStr() ~= "0" or role._roledata._jieyi_info._cur_operate_id:ToStr() ~= "0" then
		--返回已经结义不能创建
		local cmd = NewCommand("ErrorInfo")
		cmd.error_id = G_ERRCODE["JIEYI_HAS_CREATED"]
		role:SendToClient(SerializeCommand(cmd))	
		player:Log("OnCommand_JieYiCreate, error=JIEYI_HAS_CREATED")
		return
	end
	
	--全局临时结义id 加 1
	jieyi_info._id:Add(1)	
	
	--把这个准备结义的放到数据库
	local compareInfo = CACHE.CompareJieYiInfo()
	compareInfo._id = jieyi_info._id
	compareInfo._boss_info._id = role._roledata._base._id
	compareInfo._boss_info._name = role._roledata._base._name
	compareInfo._boss_info._level = role._roledata._status._level
	compareInfo._boss_info._photo = role._roledata._base._photo
	compareInfo._boss_info._accept = 1 --自己肯定接受 1 接受 0 不接受
	compareInfo._boss_info._ready = 1 -- 这个后面处理 1 接受 0 不接受
	compareInfo._boss_info._time = API_GetTime()  --需要时间接口
	jieyi_info._compare_jieyi_info:Insert(compareInfo._id,compareInfo)	
	
	--这里需要设置jieyiroleinfo type =1 代表已经结义 type =2 准备结义
	role._roledata._jieyi_info._cur_operate_id = jieyi_info._id
	role._roledata._jieyi_info._cur_operate_typ = 2
	
	resp.cur_operate_id = role._roledata._jieyi_info._cur_operate_id:ToStr()
	resp.cur_operate_typ = role._roledata._jieyi_info._cur_operate_typ
	
	player:SendToClient(SerializeCommand(resp))	
end

