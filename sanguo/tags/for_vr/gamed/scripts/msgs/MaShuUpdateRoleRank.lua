function OnMessage_MaShuUpdateRoleRank(player, role, arg, others)
	player:Log("OnMessage_MaShuUpdateRoleRank, "..DumpTable(arg).." "..DumpTable(others))

	local ed = DataPool_Find("elementdata")
	local quanju = ed.gamedefine[1]
	--�������Ϣ���������Լ���������Ϣ��������
	role._roledata._mashu_info._yestaday_rank = arg.rank
	role._roledata._mashu_info._timestamp = API_MakeTodayTime(quanju.mashu_daily_reward_time, 0, 0) + 24*3600
	
	--��ʼ���ÿ�յ�һЩ��Ϣ������ղ���
	role._roledata._mashu_info._friend_info:Clear()
	role._roledata._mashu_info._today_max_score = 0
	role._roledata._mashu_info._today_max_stage = 0

	local msg = NewMessage("RoleUpdateFriendInfo")
	msg.roleid = role._roledata._base._id:ToStr()
	msg.level = role._roledata._status._level
	msg.zhanli = role._roledata._status._zhanli
	msg.online = role._roledata._status._online
	msg.mashu_score = role._roledata._mashu_info._today_max_score
	local friend_info_it = role._roledata._friend._friends:SeekToBegin()
	local friend_info = friend_info_it:GetValue()
	while friend_info ~= nil do
		
		player:SendMessage(friend_info._brief._id, SerializeMessage(msg))

		friend_info_it:Next()
		friend_info = friend_info_it:GetValue()
	end

end