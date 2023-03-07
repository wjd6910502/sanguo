function OnCommand_MaShuSelectFriendToHelp(player, role, arg, others)
	player:Log("OnCommand_MaShuSelectFriendToHelp, "..DumpTable(arg).." "..DumpTable(others))

	local resp = NewCommand("MaShuSelectFriendToHelp_Re")
	resp.roleid = arg.roleid
	
	if role._roledata._mashu_info._fight_friend._zhanli ~= 0 then
		return
	end

	--���Ȳ鿴�������Ƿ�����ҵĺ��ѣ���β鿴�����Ѿ���ս�Ĵ������������3�Σ���ô�Ͳ�������
	local friend_info_map = role._roledata._friend._friends
	local friend_info = friend_info_map:Find(CACHE.Int64(arg.roleid))
	if friend_info == nil then
		resp.retcode = G_ERRCODE["MASHU_NOT_FRIEND"]
		player:SendToClient(SerializeCommand(resp))
		return
	end

	--�鿴����Ĵ���
	local friend_count_map = role._roledata._mashu_info._friend_info
	local friend_count = friend_count_map:Find(CACHE.Int64(arg.roleid))
	if friend_count ~= nil and friend_count._count >= 3 then
		resp.retcode = G_ERRCODE["MASHU_NOT_FRIEND"]
		player:SendToClient(SerializeCommand(resp))
		return
	end
	
	--���ݴ����鿴��Ҫ�۳���Ǯ�Ƿ��㹻
	if friend_count ~= nil then
		local ed = DataPool_Find("elementdata")
		local quanju = ed.gamedefine[1]
		local need_money = friend_count._count*quanju.equestrain_zhuzhan_cost_coefficient
		if role._roledata._status._yuanbao < need_money then
			resp.retcode = G_ERRCODE["MASHU_FRIEND_MONEY_LESS"]
			player:SendToClient(SerializeCommand(resp))
			return
		end
		ROLE_SubYuanBao(role, need_money)
	end

	role._roledata._mashu_info._fight_friend._roleid = friend_info._brief._id
	role._roledata._mashu_info._fight_friend._name = friend_info._brief._name
	role._roledata._mashu_info._fight_friend._zhanli = friend_info._zhanli

	if friend_count == nil then
		local insert_friend_count = CACHE.MaShu_FriendInfo()
		insert_friend_count._roleid = friend_info._brief._id
		insert_friend_count._count = 1
		friend_count_map:Insert(friend_info._brief._id, insert_friend_count)
	else
		friend_count._count = friend_count._count + 1
	end
	
	--�������Լ��ĺ��ѷ���һ����л�ʼ�
	local msg = NewMessage("MaShuHelpMail")
	msg.role_name = role._roledata._base._name
	API_SendMsg(friend_info._brief._id:ToStr(), SerializeMessage(msg), 0)

	resp.retcode = G_ERRCODE["SUCCESS"]
	player:SendToClient(SerializeCommand(resp))
	return
end