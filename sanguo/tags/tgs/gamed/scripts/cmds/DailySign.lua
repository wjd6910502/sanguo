function OnCommand_DailySign(player, role, arg, others)
	player:Log("OnCommand_DailySign, "..DumpTable(arg).." "..DumpTable(others))

	local resp = NewCommand("DailySign_Re")
	resp.typ = arg.typ

	--�����ж����ǽ���ǩ�����ǽ��в�ǩ
	if arg.typ == 0 then
		--ǩ��
		if role._roledata._status._dailly_sign._today_flag == 1 then
			--�Ѿ�������ǩ����ֱ�ӷ���
			resp.retcode = G_ERRCODE["DAILY_SIGN_HAVE"]
			player:SendToClient(SerializeCommand(resp))
			return
		end

		local now = API_GetTime()
		local now_time = os.date("*t", now)
		local ed = DataPool_Find("elementdata")
		local sign_info = ed:FindBy("sign_id", now_time.month)
	
		local sign_prize = sign_info.rewards
		role._roledata._status._dailly_sign._sign_date = role._roledata._status._dailly_sign._sign_date + 1
		role._roledata._status._dailly_sign._today_flag = 1
	
		local sign_item = sign_prize[role._roledata._status._dailly_sign._sign_date]

		resp.item = {}
		
		resp.item.tid = sign_item.item_id
		resp.item.count = sign_item.item_num
		if sign_item.if_double == 1 then
			local vip_level = ROLE_GetVIP(role)
			if vip_level >= sign_item.vip_double then
				resp.item.count = sign_item.item_num*2
			end
		end

		resp.retcode = G_ERRCODE["SUCCESS"]
		player:SendToClient(SerializeCommand(resp))
		return
	elseif arg.typ == 1 then
		--��ǩ
		local now = API_GetTime()
		local now_time = os.date("*t", now)
		
		--���Ͻ���
		if (role._roledata._status._dailly_sign._sign_date+1) >= now_time.day then
			--û�в�ǩ�Ļ���
			resp.retcode = G_ERRCODE["DAILY_RESIGN_ERR"]
			player:SendToClient(SerializeCommand(resp))
			return
		end
		
		local ed = DataPool_Find("elementdata")
		local sign_info = ed:FindBy("sign_id", now_time.month)
	
		local sign_prize = sign_info.rewards
		role._roledata._status._dailly_sign._sign_date = role._roledata._status._dailly_sign._sign_date + 1
	
		local sign_item = sign_prize[role._roledata._status._dailly_sign._sign_date]

		resp.item = {}
		
		resp.item.tid = sign_item.item_id
		resp.item.count = sign_item.item_num
		if sign_item.if_double == 1 then
			local vip_level = ROLE_GetVIP(role)
			if vip_level >= sign_item.vip_double then
				resp.item.count = sign_item.item_num*2
			end
		end

		resp.retcode = G_ERRCODE["SUCCESS"]
		player:SendToClient(SerializeCommand(resp))
		return
	end
end
