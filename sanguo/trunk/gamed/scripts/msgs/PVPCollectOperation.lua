function OnMessage_PVPCollectOperation(pvp, arg, others)
	--API_Log("OnMessage_PVPCollectOperation, "..DumpTable(arg).." "..DumpTable(others))

	--local op_tick = CACHE.PVPOpTick()
	--pvp._prev_op_tick = pvp._prev_op_tick+10
	--op_tick._tick = pvp._prev_op_tick
	--local it = pvp._fighters:SeekToBegin()
	--local ft = it:GetValue()
	--while ft~=nil do
	--	op_tick._fighters:PushBack(ft)
	--	ft._ops:Clear();
	--	it:Next()
	--	ft = it:GetValue()
	--end
	--pvp._op_ticks:PushBack(op_tick)

	--pvp._auto_sync:SetDirty()
	--pvp._auto_sync:BeginSync()
end
