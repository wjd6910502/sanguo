function _Mode1WaitPVPReady_Heartbeat(pvp, arg, others)
	--�ȴ�PVPReady
	if arg.now-pvp._data._status_change_time > 60 then
		API_Log("_Mode1WaitPVPReady_Heartbeat, "..DumpTable(arg).." "..DumpTable(others).." �ȴ�PVPReady��ʱ")
		pvp._data._status = 99
		pvp._data._status_change_time = arg.now
		pvp._data._end_reason = 1 --�ȴ�PVPReady��ʱ
		return
	end

	if pvp._data._fighter1._status~=1 or pvp._data._fighter2._status~=1 then return end

	--�ͻ��˶���׼��������֪ͨpvpd��ʼ
	pvp._data._status = 1
	pvp._data._status_change_time = arg.now
	pvp._data._fight_start_time = API_GetTime()+5

	pvp:PVPD_Create()
end

function _Mode1WaitPVPCreateResult_Heartbeat(pvp, arg, others)
	--�ȴ�PVPCreateResult
	if arg.now-pvp._data._status_change_time > 3 then
		API_Log("_Mode1WaitPVPCreateResult_Heartbeat, "..DumpTable(arg).." "..DumpTable(others).." �ȴ�PVPCreateResult��ʱ")
		pvp._data._status = 99
		pvp._data._status_change_time = arg.now
		pvp._data._end_reason = 2 --�ȴ�PVPCreateResult��ʱ
		return
	end
end

function _Mode1Fighting_Heartbeat(pvp, arg, others)
	--API_Log("_Mode1Fighting_Heartbeat, "..DumpTable(arg).." "..DumpTable(others).." "..pvp._data._status_change_time)
	--ս����
	if arg.now-pvp._data._status_change_time > 5*60 then
		API_Log("_Mode1Fighting_Heartbeat, "..DumpTable(arg).." "..DumpTable(others).." ս����ʱ")
		pvp._data._status = 99 
		pvp._data._status_change_time = arg.now
		pvp._data._end_reason = 4 --ս����ʱ
		return
	end

	if pvp._data._fighter1._status==2 or pvp._data._fighter2._status==2 then
		--�Ѿ������ύ�����
		if pvp._data._fighter1._status==2 and pvp._data._fighter2._status==2 then
			pvp._data._status = 99
			pvp._data._status_change_time = arg.now
			pvp._data._end_reason = 0 --��������
		elseif pvp._data._end_counter>=5 then
			pvp._data._status = 99
			pvp._data._status_change_time = arg.now
			pvp._data._end_reason = 0
		else
			pvp._data._end_counter = pvp._data._end_counter+1
		end
		return
	end
end

function _Mode1End_Heartbeat(pvp, arg, others)
	--�ѽ���
	local cmd = NewCommand("PVPEnd")
	cmd.result = 0 --TODO:
	
	local role1 = others.roles[pvp._data._fighter1._id:ToStr()]
	local role2 = others.roles[pvp._data._fighter2._id:ToStr()]
	if role1~=nil then
		role1._roledata._pvp._id = 0
	end

	if role2~=nil then
		role2._roledata._pvp._id = 0
	end

	--���ߵ�ʱ��
	if pvp._data._end_reason == 5 then
		if role1~=nil then
			cmd.result = pvp._data._fighter1._result
			cmd.typ = pvp._data._fighter1._typ
			role1:SendToClient(SerializeCommand(cmd))
		end
		
		if role2~=nil then
			cmd.result = pvp._data._fighter2._result
			cmd.typ = pvp._data._fighter2._typ
			role2:SendToClient(SerializeCommand(cmd))
		end
	--����������ʱ��,Ŀǰû�п���˫����˵�Լ���Ӯ�˵����,�������������Ӧ���޸�
	elseif pvp._data._end_reason == 0 then
		if role1~=nil then
			cmd.result = pvp._data._fighter1._result
			cmd.typ = pvp._data._fighter1._typ
			role1:SendToClient(SerializeCommand(cmd))
		end
		
		if role2~=nil then
			cmd.result = pvp._data._fighter2._result
			cmd.typ = pvp._data._fighter2._typ
			role2:SendToClient(SerializeCommand(cmd))
		end
	elseif pvp._data._end_reason == 1 then
		local cmd = NewCommand("PVPError")	
		if role1~=nil then
			cmd.result = G_ERRCODE["PVP_INVITE_STATE_ERROR"]
			role1:SendToClient(SerializeCommand(cmd))
		end
		
		if role2~=nil then
			cmd.result = G_ERRCODE["PVP_INVITE_STATE_ERROR"]
			role2:SendToClient(SerializeCommand(cmd))
		end
	elseif pvp._data._end_reason == 2 then
		local cmd = NewCommand("PVPError")	
		if role1~=nil then
			cmd.result = G_ERRCODE["PVP_INVITE_STATE_ERROR"]
			role1:SendToClient(SerializeCommand(cmd))
		end
		
		if role2~=nil then
			cmd.result = G_ERRCODE["PVP_INVITE_STATE_ERROR"]
			role2:SendToClient(SerializeCommand(cmd))
		end
	elseif pvp._data._end_reason == 3 then
		local cmd = NewCommand("PVPError")	
		if role1~=nil then
			cmd.result = G_ERRCODE["PVP_INVITE_STATE_ERROR"]
			role1:SendToClient(SerializeCommand(cmd))
		end
		
		if role2~=nil then
			cmd.result = G_ERRCODE["PVP_INVITE_STATE_ERROR"]
			role2:SendToClient(SerializeCommand(cmd))
		end
	elseif pvp._data._end_reason == 4 then
		if role1~=nil then
			cmd.result = 0
			cmd.typ = 5
			role1:SendToClient(SerializeCommand(cmd))
		end
		
		if role2~=nil then
			cmd.result = 0
			cmd.typ = 5
			role2:SendToClient(SerializeCommand(cmd))
		end
	end

	pvp:PVPD_Delete()
	API_PVP_Delete(pvp._data._id)
end

--function _Mode2WaitPVPReady_Heartbeat(pvp, arg, others)
--	--�ȴ�PVPReady
--	if arg.now-pvp._data._status_change_time > 60 then
--		API_Log("_Mode2WaitPVPReady_Heartbeat, "..DumpTable(arg).." "..DumpTable(others).." �ȴ�PVPReady��ʱ")
--		pvp._data._status = 99
--		pvp._data._status_change_time = arg.now
--		pvp._data._end_reason = 1 --�ȴ�PVPReady��ʱ
--		return
--	end
--
--	if pvp._data._fighter1._status~=1 or pvp._data._fighter2._status~=1 then return end
--
--	--�ͻ��˶���׼��������֪ͨpvpd��ʼ
--	pvp._data._status = 1
--	pvp._data._status_change_time = arg.now
--	pvp._data._fight_start_time = arg.now+5
--
--	pvp:PVPD_Create()
--end
--
--function _Mode2WaitPVPCreateResult_Heartbeat(pvp, arg, others)
--	--�ȴ�PVPCreateResult
--	if arg.now-pvp._data._status_change_time > 3 then
--		API_Log("_Mode2WaitPVPCreateResult_Heartbeat, "..DumpTable(arg).." "..DumpTable(others).." �ȴ�PVPCreateResult��ʱ")
--		pvp._data._status = 99
--		pvp._data._status_change_time = arg.now
--		pvp._data._end_reason = 2 --�ȴ�PVPCreateResult��ʱ
--		return
--	end
--end
--
--function _Mode2Fighting_Heartbeat(pvp, arg, others)
--	--ս����
--	if arg.now-pvp._data._status_change_time > 5*60 then
--		API_Log("_Mode2Fighting_Heartbeat, "..DumpTable(arg).." "..DumpTable(others).." ս����ʱ")
--		pvp._data._status = 99 
--		pvp._data._status_change_time = arg.now
--		pvp._data._end_reason = 4 --ս����ʱ
--		return
--	end
--
--	if pvp._data._fighter1._status==2 and pvp._data._fighter2._status==2 then
--		pvp._data._status = 99
--		pvp._data._status_change_time = arg.now
--		pvp._data._end_reason = 0 --��������
--		return
--	end
--end
--
--function _Mode2End_Heartbeat(pvp, arg, others)
--	--�ѽ���
--	if pvp._data._fighter1._status~=2 then
--		pvp._data._fighter1._status = 2
--		local role1 = others.roles[pvp._data._fighter1._id:ToStr()]
--		if role1~=nil then
--			local cmd = NewCommand("PVPEnd")
--			cmd.result = 0 --TODO:
--			role1:SendToClient(SerializeCommand(cmd))
--			role1._pvp._id = 0
--		end
--	end
--
--	if pvp._data._fighter2._status~=2 then
--		pvp._data._fighter2._status = 2
--		local role2 = others.roles[pvp._data._fighter2._id:ToStr()]
--		if role2~=nil then
--			local cmd = NewCommand("PVPEnd")
--			cmd.result = 0 --TODO:
--			role2:SendToClient(SerializeCommand(cmd))
--			role2._pvp._id = 0
--		end
--	end
--
--	
--	pvp:PVPD_Delete()
--	API_PVP_Delete(pvp._data._id)
--end

function OnMessage_PVPHeartbeat(pvp, arg, others)
	--API_Log("OnMessage_PVPHeartbeat, "..DumpTable(arg).." "..DumpTable(others))
	if pvp._data._mode==1 then
		if pvp._data._status==0 then
			_Mode1WaitPVPReady_Heartbeat(pvp, arg, others)
		elseif pvp._data._status==1 then
			_Mode1WaitPVPCreateResult_Heartbeat(pvp, arg, others)
		elseif pvp._data._status==2 then
			_Mode1Fighting_Heartbeat(pvp, arg, others)
		elseif pvp._data._status==99 then
			_Mode1End_Heartbeat(pvp, arg, others)
		else
			ThrowException()
		end
	--elseif pvp._data._mode==2 then
	--	if pvp._data._status==0 then
	--		_Mode2WaitPVPReady_Heartbeat(pvp, arg, others)
	--	elseif pvp._data._status==1 then
	--		_Mode2WaitPVPCreateResult_Heartbeat(pvp, arg, others)
	--	elseif pvp._data._status==2 then
	--		_Mode2Fighting_Heartbeat(pvp, arg, others)
	--	elseif pvp._data._status==99 then
	--		_Mode2End_Heartbeat(pvp, arg, others)
	--	else
	--		ThrowException()
	--	end
	else
		ThrowException()
	end
end
