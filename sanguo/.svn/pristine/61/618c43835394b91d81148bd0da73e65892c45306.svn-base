function OnCommand_PvpEnter(player, role, arg, others)
	player:Log("OnCommand_PvpEnter, "..DumpTable(arg).." "..DumpTable(others))

	if role._roledata._pvp._state == 0 then
		player:Log("OnCommand_PvpEnter, "..role._roledata._pvp._state)
		return
	end
	role:SendPVPEnter(arg.flag)
	
	--数据统计日志
	local date = os.date("%Y-%m-%d %H:%M:%S")
	player:BILog("{\"logtime\":\""..date.."\",\"logname\":\"startarena\",\"serverid\":\""..API_GetZoneId().."\",\"os\":\""
		..role._roledata._device_info._os.."\",\"platform\":\"".."laohu".."\",\"userid\":\""..role._roledata._status._account..
		"\",\"account\":\""..role._roledata._status._account.."\",\"roleid\":\""..role._roledata._base._id:ToStr()..
		"\",\"rolename\":\""..role._roledata._base._name.."\",\"lev\":\""..role._roledata._status._level.."\",\"totalcash\":\""
		.."0".."\",\"arenaid\":\"1\",\"fight\":\""..role._roledata._status._zhanli.."\"}")

end
