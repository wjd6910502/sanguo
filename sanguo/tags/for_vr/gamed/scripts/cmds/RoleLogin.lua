function OnCommand_RoleLogin(player, role, arg, others)
	player:Log("OnCommand_RoleLogin, "..DumpTable(arg).." "..DumpTable(others))

	--����ҵ�˽����Ϣ�������
	
	--local resp = NewCommand("PrivateChatHistory")
	--resp.private_chat = {}
	--local chats = role._roledata._chat._received_private_chats

	--local cit = chats:SeekToBegin()
	--local c = cit:GetValue()
	--while c~=nil do
	--	local c2 = {}
	--	c2.src = {}
	--	c2.src.id = c._brief._id:ToStr()
	--	c2.src.name = c._brief._name
	--	c2.src.photo = c._brief._photo
	--	c2.src.level = c._brief._level
	--	c2.src.mafia_id = c._brief._mafia_id:ToStr()
	--	c2.src.mafia_name = c._brief._mafia_name
	--	c2.content = c._content
	--	c2.time = c._time

	--	resp.private_chat[#resp.private_chat+1] = c2
	--	cit:Next()
	--	c = cit:GetValue()
	--end
	--player:SendToClient(SerializeCommand(resp))

	--�鿴ȫ���¼��������д���
	local msg = NewMessage("RoleUpdateServerEvent")
	player:SendMessage(role._roledata._base._id, SerializeMessage(msg))

	--ˢ����ҵĸ����̵�
	PRIVATE_RefreshAllShop(role)
	--ˢ����ҵ�ս����Ϣ
	ROLE_RefreshAllBattleInfo(role)
	--local now = API_GetTime()
	--role._roledata._status._update_server_event = now
	
	--�鿴����Ƿ��������ƥ��ͭȸ̨
	if role._roledata._tongquetai_data._cur_state == 1 then
		local msg = NewMessage("TongQueTaiCancle")
		player:SendMessage(role._roledata._base._id, SerializeMessage(msg))
	end

	--����һ�¾�����Ϣ,�ŵ�Load���ݵ�ʱ��ȥ��һ��
	--ROLE_UpdateLegionInfo(role)
	

	--�����Լ����ߣ�Ȼ����Լ��ĺ��ѹ㲥���Լ���Ϣ�ı仯
	role._roledata._status._online = 1
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