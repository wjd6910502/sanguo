function OnCommand_JieYiGetRoleInfo(player, role, arg, others)
	player:Log("OnCommand_JieYiGetRoleInfo, "..DumpTable(arg).." "..DumpTable(others))

	local resp = NewCommand("JieYiGetRoleInfo_Re")

	--已经结义的id和结义名字
	resp.id = role._roledata._jieyi_info._jieyi_id:ToStr() 
	resp.name = role._roledata._jieyi_info._jieyi_name
	
	--准备结义的id
	resp.cur_operate_id = role._roledata._jieyi_info._cur_operate_id:ToStr()
	--代表什么类型 已经结义 还是准备结义
	resp.cur_operate_typ = role._roledata._jieyi_info._cur_operate_typ
	
	local jieyi_info = others.jieyi_info._data	
	if role._roledata._jieyi_info._cur_operate_typ == 1 then 
		local fit = jieyi_info._jieyi_info:Find(role._roledata._jieyi_info._jieyi_id)
		if fit ~= nil then 
			resp.level = fit._level
			resp.exp = fit._exp
		end
	elseif  role._roledata._jieyi_info._cur_operate_typ == 2 then
		local fit = jieyi_info._compare_jieyi_info:Find(role._roledata._jieyi_info._cur_operate_id)
		if fit ~= nil then   
			resp.level = fit._level
			resp.exp = fit._exp
		end
	else
		--do nothing	
	end

	player:SendToClient(SerializeCommand(resp)) 
end
