function OnCommand_PVPReady(player, role, arg, others)
	player:Log("OnCommand_PVPReady, "..DumpTable(arg).." "..DumpTable(others))

	if role._roledata._pvp._typ == G_PVP_STATE_TYP["3V3"] or role._roledata._pvp._typ == G_PVP_STATE_TYP["YUEZHAN"] then
		--在这里告诉center可以准备了。
		if role._roledata._pvp._state == 0 then
			player:Log("OnCommand_PVPReady, "..role._roledata._pvp._state)
		end
		role:SendPVPReady()
	else
		local my_pvp = others.pvps[role._roledata._pvp._id]
		if my_pvp==nil then return end

		local fighter = nil
		if role._roledata._base._id:ToStr()==my_pvp._data._fighter1._id:ToStr() then
			fighter = my_pvp._data._fighter1
		elseif role._roledata._base._id:ToStr()==my_pvp._data._fighter2._id:ToStr() then
			fighter = my_pvp._data._fighter2
		end

		fighter._status = 1
	end
end
