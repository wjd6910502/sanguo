function OnCommand_PVPEnd(player, role, arg, others)
	player:Log("OnCommand_PVPEnd, "..DumpTable(arg).." "..DumpTable(others))
	
	if role._roledata._pvp._typ == G_PVP_STATE_TYP["3V3"] or role._roledata._pvp._typ == G_PVP_STATE_TYP["YUEZHAN"] then
		if role._roledata._pvp._state == 0 then
			player:Log("OnCommand_PVPEnd, "..role._roledata._pvp._state)
		end
		role:SendPVPLeave(arg.result, arg.typ, arg.score, arg.duration)
		--数据统计日志
		local date = os.date("%Y-%m-%d %H:%M:%S")
		player:BILog("{\"logtime\":\""..date.."\",\"logname\":\"endtarena\",\"serverid\":\""..API_GetZoneId().."\",\"os\":\""
			..role._roledata._device_info._os.."\",\"platform\":\"".."laohu".."\",\"userid\":\""..role._roledata._status._account..
			"\",\"account\":\""..role._roledata._status._account.."\",\"roleid\":\""..role._roledata._base._id:ToStr()..
			"\",\"rolename\":\""..role._roledata._base._name.."\",\"lev\":\""..role._roledata._status._level.."\",\"totalcash\":\""
			.."0".."\",\"arenaid\":\"1\",\"fight\":\""..role._roledata._status._zhanli.."\",\"result\":\""..arg.result.."\"}")
	else
		player:KickoutSelf(1)
		local my_pvp = others.pvps[role._roledata._pvp._id]
		if my_pvp==nil then return end
		local fighter = nil
		if role._roledata._base._id:ToStr()==my_pvp._data._fighter1._id:ToStr() then
			fighter = my_pvp._data._fighter1
		elseif role._roledata._base._id:ToStr()==my_pvp._data._fighter2._id:ToStr() then
			fighter = my_pvp._data._fighter2
		end

		fighter._status = 2
		fighter._result = arg.result
		fighter._typ = arg.typ

		--if my_pvp._data._mode==2 then
		--	--对于瞎打模式, 自己认为结束时就算结束, 另外玩家不受影响
		--	local cmd = NewCommand("PVPEnd")
		--	cmd.result = arg.result
		--	role:SendToClient(SerializeCommand(cmd))
		--	role._roledata._pvp._id = 0

		--	my_pvp:PVPD_Leave(role._base._id)
		--end
	end
end
