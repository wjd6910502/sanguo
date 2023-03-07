function OnMessage_Pay(player, role, arg, others)
	player:Log("OnMessage_Pay, "..DumpTable(arg).." "..DumpTable(others))

	local version_dpc = DataPool_Find("versiondata")
	local chongzhi_info = version_dpc:FindBy("rmb_typ", arg.id)

	if chongzhi_info == nil then
		player:Err("OnMessage_Pay, id not found, "..DumpTable(arg).." "..DumpTable(others))
		return
	end

	if chongzhi_info.rmb*100 ~= arg.amount then
		player:Err("OnMessage_Pay, amount error, "..DumpTable(arg).." "..DumpTable(others))
		return
	end

	local order = role._roledata._misc._pay_orders:Find(arg.order)
	if order~=nil then
		player:Err("OnMessage_Pay, duplicated, "..DumpTable(arg).." "..DumpTable(others))
		player:SendLaohuPayRe(-2, arg.order, arg.amount, arg.id, arg.sid)
		return
	end

	local mount = CACHE.Int();
	mount._value = arg.amount;
	role._roledata._misc._pay_orders:Insert(arg.order, mount)
	
	local add_yuanbao = 0
	add_yuanbao = chongzhi_info.yb
	--查看是否有双倍效果
	if LIMIT_TestUseLimit(role, chongzhi_info.double_yb_limit_id, 1) == true then
		add_yuanbao = add_yuanbao*2
		LIMIT_AddUseLimit(role, chongzhi_info.double_yb_limit_id, 1)
	end
	add_yuanbao = add_yuanbao + chongzhi_info.present_yb

	--查看是否是月卡充值
	if chongzhi_info.recharge_type == 1 then
		local now = API_GetTime()
		if role._roledata._status._little_fudai<now then role._roledata._status._little_fudai=0 end
		if role._roledata._status._little_fudai == 0 then
			local begin_time = API_MakeTodayTime(5, 0, 0)
			if now >= begin_time then
				role._roledata._status._little_fudai = begin_time + chongzhi_info.actuation_duration*24*3600
			else
				role._roledata._status._little_fudai = begin_time + (chongzhi_info.actuation_duration-1)*24*3600
			end
		else
			role._roledata._status._little_fudai = role._roledata._status._little_fudai + chongzhi_info.actuation_duration*24*3600 --FIXME:
		end
		local resp = NewCommand("UpdateFuDaiTime")
		resp.fudai_flag = chongzhi_info.recharge_type
		resp.fudai_time = role._roledata._status._little_fudai
	elseif chongzhi_info.recharge_type == 2 then
		local now = API_GetTime()
		if role._roledata._status._little_fudai<now then role._roledata._status._little_fudai=0 end
		if role._roledata._status._big_fudai == 0 then
			local begin_time = API_MakeTodayTime(5, 0, 0)
			if now >= begin_time then
				role._roledata._status._big_fudai = begin_time + chongzhi_info.actuation_duration*24*3600
			else
				role._roledata._status._big_fudai = begin_time + (chongzhi_info.actuation_duration-1)*24*3600
			end
		else
			role._roledata._status._big_fudai = role._roledata._status._big_fudai + chongzhi_info.actuation_duration*24*3600
		end
		local resp = NewCommand("UpdateFuDaiTime")
		resp.fudai_flag = chongzhi_info.recharge_type
		resp.fudai_time = role._roledata._status._big_fudai
	end

	--添加元宝修改VIP等级
	ROLE_AddYuanBao(role, add_yuanbao)
	ROLE_AddChongZhi(role, chongzhi_info.yb)

	local resp = NewCommand("ChongZhi")
	resp.yuanbao = chongzhi_info.yb
	resp.extra_yuanbao = add_yuanbao - chongzhi_info.yb
	resp.fudai_flag = chongzhi_info.recharge_type
	if resp.fudai_flag == 1 then
		resp.fudai_time = role._roledata._status._little_fudai
	elseif resp.fudai_flag == 2 then
		resp.fudai_time = role._roledata._status._big_fudai
	end

	player:SendToClient(SerializeCommand(resp))

	--修改累计充值的成就
	TASK_ChangeCondition(role, G_ACH_TYPE["CHONGZHI"], G_ACH_NINTEEN_TYPE["LEIJICHONGZHI"], chongzhi_info.yb)
	TASK_ChangeCondition(role, G_ACH_TYPE["CHONGZHI"], G_ACH_NINTEEN_TYPE["SHOUCHONG"], chongzhi_info.yb)

	player:SendLaohuPayRe(0, arg.order, arg.amount, arg.id, arg.sid)

	--数据统计日志
	local date = os.date("%Y-%m-%d %H:%M:%S")
	player:BILog("{\"logtime\":\""..date.."\",\"logname\":\"addcash\",\"serverid\":\""..API_GetZoneId()..
		"\",\"os\":\""..role._roledata._device_info._os.."\",\"platform\":\"".."laohu".."\",\"userid\":\""
		..role._roledata._status._account.."\",\"account\":\""..role._roledata._status._account.."\",\"roleid\":\""
		..role._roledata._base._id:ToStr().."\",\"rolename\":\""..role._roledata._base._name.."\",\"lev\":\""
		..role._roledata._status._level.."\",\"totalcash\":\"".."0".."\",\"cash\":\"".."0"..
		"\",\"gameorder\":\"".."0".."\",\"platformorder\":\"".."0".."\"}")
end
