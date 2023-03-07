function OnMessage_GMCmd_GetChar(player, role, arg, others)
	player:Log("OnMessage_GmCmd_GetChar, "..DumpTable(arg).." "..DumpTable(others))

	local resp = CACHE.GMCmdGetCharRe()
	resp.roleid = role._roledata._base._id
	resp.rolename = role._roledata._base._name
	resp.zoneid = API_GetZoneId()
	resp.level = role._roledata._status._level
	resp.sex = role._roledata._base._sex
	resp.createtime = os.date("%Y-%m-%d %H:%M:%S", role._roledata._base._create_time)
	if role._roledata._status._login_time == 0 then
		resp.lastlogintime = 0
	else
		resp.lastlogintime = os.date("%Y-%m-%d %H:%M:%S", role._roledata._status._login_time)
	end
	resp.ip = role._roledata._device_info._public_ip
	resp.exp = role._roledata._status._exp
	resp.mafianame = role._roledata._mafia._name
	resp.yuanbao = role._roledata._status._yuanbao
	resp.money = role._roledata._status._money
	resp.bdyuanbao = role._roledata._status._chongzhi
	resp.vip = ROLE_GetVIP(role) 
	resp.totalcash = 0	--上线前修改
	ROLE_UpdateZhanli(role)
	resp.zhanli = role._roledata._status._zhanli

	player:GMCmdGetCharReply(resp, arg.session_id, arg.sid)
end
