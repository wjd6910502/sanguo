function OnMessage_RoleLogout(player, role, arg, others)
	player:Log("OnMessage_RoleLogout, "..DumpTable(arg).." "..DumpTable(others))

	--���������Լ����棬Ȼ��㲥���Լ����еĺ��ѣ��Լ���Ϣ�ı仯
	role._roledata._status._online = 0

	--�����Լ��ĺ��ѣ����Լ�����Ϣ����ȥ
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