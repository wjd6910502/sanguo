function OnMessage_PVPEnd(pvp, arg, others)
	API_Log("OnMessage_PVPEnd, "..DumpTable(arg).." "..DumpTable(others))

	--目前仅有超时
	if pvp._data._status~=2 then return end

	--在这里需要区分一下,是谁掉线，如果是fight1的话是5，如果是fight2的话就是6
	pvp._data._status = 99
	pvp._data._status_change_time = API_GetTime()
	pvp._data._end_reason = 5 --战斗中有人掉线
	if arg.reason < 100 then
		pvp._data._fighter1._result = 0
		pvp._data._fighter1._typ = 3
		pvp._data._fighter2._result = 1
		pvp._data._fighter2._typ = 3
	else
		pvp._data._fighter1._result = 1
		pvp._data._fighter1._typ = 3
		pvp._data._fighter2._result = 0
		pvp._data._fighter2._typ = 3
	end

end
