function OnMessage_PVPTriggerSend(pvp, arg, others)
	----API_Log("OnMessage_PVPTriggerSend, "..DumpTable(arg).." "..DumpTable(others))

	--if pvp._status~=1 then return end

	--local role1 = others.roles[pvp._fighter1._id:ToStr()]
	--if role1==nil then ThrowExecption() end --FIXME: $_$
	--role1:FastSess_TriggerSend()

	--local role2 = others.roles[pvp._fighter2._id:ToStr()]
	--if role2==nil then ThrowExecption() end
	--role2:FastSess_TriggerSend()
end
