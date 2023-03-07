function OnCommand_DaTiAnswer(player, role, arg, others)
	player:Log("OnCommand_DaTiAnswer, "..DumpTable(arg).." "..DumpTable(others))
	
	--����ͳ����־
	local source_id = G_SOURCE_TYP["WENDA"]

	local resp = NewCommand("DaTiAnswer_Re")

	local DaTi_Data = role._roledata._dati_data

	local ed = DataPool_Find("elementdata")
	local DaTi_num = ed:FindBy("game_define", 2232)

	--������Ŀ����
	if arg.num <= 0 or arg.num > DaTi_num.wenda_refresh_question_num then
		resp.retcode = G_ERRCODE["DATI_NUM_ERR"]
		player:SendToClient(SerializeCommand(resp))
		player:Log("OnCommand_DaTiAnswer, error=DATI_NUM")
		return
	end
	if (DaTi_Data._cur_num + 1) ~= arg.num then
		resp.retcode = G_ERRCODE["DATI_NUM_ERR"]
		player:SendToClient(SerializeCommand(resp))
		player:Log("OnCommand_DaTiAnswer, error=DATI_NUM")
		return
	end

	--������ʱ��������0��
	if arg.use_time < 0 then
		resp.retcode = G_ERRCODE["DATI_USETIME_ERR"]
		player:SendToClient(SerializeCommand(resp))
		player:Log("OnCommand_DaTiAnswer, error=DATI_USETIME")
		return
	end

	local right_flag = arg.right_flag
	local reward = {}
	if right_flag == 1 then
		local wendareward = ed:FindBy("wenda_reward", arg.num)
		reward = DROPITEM_Reward(role, wendareward.reward_id)
		ROLE_AddReward(role, reward, source_id)
		ROLE_UpdateDaTiData(role, right_flag, reward, math.ceil(arg.use_time))
	
		--�ɾ�
		TASK_ChangeCondition(role, G_ACH_TYPE["YONGJIU"], G_ACH_TWENTY_TYPE["DATIRIGHTNUM"], 1)
		if role._roledata._dati_data._cur_right_num == DaTi_num.wenda_refresh_question_num then
			TASK_ChangeCondition(role, G_ACH_TYPE["YONGJIU"], G_ACH_TWENTY_TYPE["DATIALLRIGHTTIME"], 1)
		end

		local msg = NewMessage("TopListInsertInfo")
		msg.typ = 12
		msg.data = tostring(role._roledata._dati_data._history_right_num)
		msg.data2 = tostring(role._roledata._dati_data._history_use_time)
		player:SendMessage(role._roledata._base._id, SerializeMessage(msg), 0)
	elseif right_flag == 2 then
		ROLE_UpdateDaTiData(role, right_flag, 0, math.ceil(arg.use_time))
		resp.retcode = G_ERRCODE["SUCCESS"]
		resp.num = arg.num
		resp.right_flag = arg.right_flag
		player:SendToClient(SerializeCommand(resp))

		if role._roledata._dati_data._history_right_num > 0 then
			local msg = NewMessage("TopListInsertInfo")
			msg.typ = 12
			msg.data = tostring(role._roledata._dati_data._history_right_num)
			msg.data2 = tostring(role._roledata._dati_data._history_use_time)
			player:SendMessage(role._roledata._base._id, SerializeMessage(msg), 0)
		end

		--�����һ���Ƿ�ȫ����Ŀ���겢ȫ��������жϣ�Ϊ�˺��淵�ظ��ͻ�������
		if arg.num == DaTi_num.wenda_refresh_question_num and role._roledata._dati_data._cur_right_num == 0 then
			role._roledata._dati_data._today_reward = 2
		end
		return
	else
		--��Դ����ʶ����
		resp.retcode = G_ERRCODE["DATI_RIGHT_FLAG_ERR"]
		player:SendToClient(SerializeCommand(resp))
		player:Log("OnCommand_DaTiAnswer, error=DATI_RIGHT_FLAG")
		return
	end

	--����Ӧ��ֻ��Ԫ��һ��
	if #reward.item ~= 1 then
		resp.retcode = G_ERRCODE["DATI_REWARD_ERR"]
		player:SendToClient(SerializeCommand(resp))
        player:Log("OnCommand_DaTiAnswer, error=DATI_REWARD")
        return
	end

	local reward_info = {}
	reward_info.tid = reward.item[1].itemid
	reward_info.count = reward.item[1].itemnum
	
	resp.item = {}
	resp.item[1] = reward_info
	--[[
	if #reward.item >= 1 then
                for i = 1, #reward.item do
                        if reward.item[i] ~= nil then
                                local reward_info = {}
                                reward_info.tid = reward.item[i].itemid
                                reward_info.count = reward.item[i].itemnum
                                resp.item[#resp.item+1] = reward_info
                        end
                end
        end
	--]]

	resp.retcode = G_ERRCODE["SUCCESS"]
	resp.num = arg.num
	resp.right_flag = arg.right_flag
	resp.exp = reward.exp
	player:SendToClient(SerializeCommand(resp))
	return
end