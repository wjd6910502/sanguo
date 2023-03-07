function OnCommand_DaTiOpenBox(player, role, arg, others)
	player:Log("OnCommand_DaTiOpenBox, "..DumpTable(arg).." "..DumpTable(others))
	
	--����ͳ����־
	local source_id = G_SOURCE_TYP["WENDA"]

	local resp = NewCommand("DaTiOpenBox_Re")

	local ed = DataPool_Find("elementdata")
	local wenda_info = ed:FindBy("game_define", 2232)

	local Dati_Data = role._roledata._dati_data
	
	--��ҽ����Ѿ���������
	if Dati_Data._today_reward ~= 0 then
		resp.retcode = G_ERRCODE["DATI_HAVE_OPENBOX_ERR"]
		player:SendToClient(SerializeCommand(resp))
		player:Log("OnCommand_DaTiOpenBox, error=DATI_HAVE_OPENBOX")
		return
	end

	local rewardid = 0
	--��δ��ɽ��մ���
	if Dati_Data._cur_num ~= wenda_info.wenda_refresh_question_num then
		resp.retcode = G_ERRCODE["DATI_UNFINISHED"]
		player:SendToClient(SerializeCommand(resp))
		player:Log("OnCommand_DaTiOpenBox, error=DATI_UNFINISHED")
		return
	end

	--�鿴����Ƿ���Կ�������
	if Dati_Data._cur_num == Dati_Data._cur_right_num then		--��Ŀȫ����ԣ���������
		rewardid = wenda_info.wenda_random_reward_1
	elseif Dati_Data._cur_right_num == 0 then		--��Ŀȫ�������δ�ܿ�������
		resp.retcode = G_ERRCODE["DATI_OPENBOX_FAIL_ERR"]
		player:SendToClient(SerializeCommand(resp))
		ROLE_UpdateDaTiData(role, 4)
		return
	else							--��Ŀ���ִ�ԣ�����ͭ����
		rewardid = wenda_info.wenda_random_reward_2
	end
	
	local Reward = DROPITEM_DropItem(role, rewardid)
	resp.item = {}
        if #Reward >= 1 then
        	for i = 1, #Reward do
                	if Reward[i] ~= nil then
                        	local reward_info = {}
                                reward_info.tid = Reward[i].id
                                reward_info.count = Reward[i].count
                                resp.item[#resp.item+1] = reward_info
                                BACKPACK_AddItem(role, reward_info.tid, reward_info.count, source_id)
                        end
                end
        end

	ROLE_UpdateDaTiData(role, 3)

	resp.retcode = G_ERRCODE["SUCCESS"]
	--resp.exp = reward.exp
	player:SendToClient(SerializeCommand(resp))
	return
end