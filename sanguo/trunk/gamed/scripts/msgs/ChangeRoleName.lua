function OnMessage_ChangeRoleName(player, role, arg, others)
	player:Log("OnMessage_ChangeRoleName, "..DumpTable(arg).." "..DumpTable(others))

	local resp = NewCommand("ChangeRoleName_Re")

	if arg.retcode == 0 then	--�����ɹ�
		--�����������
		role._roledata._base._name = arg.name

		--���°���������Ϣ
		ROLE_UpdateMafiaInfo(role)

		--�������а������Ϣ
		TOP_UpdateData(others.toplist._data._top_data, role._roledata._base._id, role._roledata._base._name, 
			role._roledata._status._level,role._roledata._base._photo, role._roledata._base._photo_frame, 
			role._roledata._base._badge_map)

		--��������ں��ѵ��б��е���Ϣ
		local msg = NewMessage("RoleUpdateFriendInfo")
		msg.roleid = role._roledata._base._id:ToStr()
		msg.name = role._roledata._base._name
		msg.level = role._roledata._status._level
		msg.zhanli = role._roledata._status._zhanli
		msg.online = role._roledata._status._online
		msg.mashu_score = role._roledata._mashu_info._today_max_score
		msg.photo = role._roledata._base._photo
		msg.photo_frame = role._roledata._base._photo_frame
		msg.badge_info = {}

		local badge_info_it = role._roledata._base._badge_map:SeekToBegin()
		local badge_info = badge_info_it:GetValue()
		while badge_info ~= nil do
			local tmp_badge_info = {}
			tmp_badge_info.id = badge_info._id
			tmp_badge_info.typ = badge_info._pos
			msg.badge_info[#msg.badge_info+1] = tmp_badge_info

			badge_info_it:Next()
			badge_info = badge_info_it:GetValue()
		end
		
		local friend_info_it = role._roledata._friend._friends:SeekToBegin()
		local friend_info = friend_info_it:GetValue()
		while friend_info ~= nil do
		
			player:SendMessage(friend_info._brief._id, SerializeMessage(msg))

			friend_info_it:Next()
			friend_info = friend_info_it:GetValue()
		end
	elseif arg.retcode == -1 then	--���ݿ��������
		resp.retcode = G_ERRCODE["USED_NAME"]
		player:SendToClient(SerializeCommand(resp))
                player:Log("OnCommand_ChangeRoleName, error=INSERT_ERR")
		return
	else	--�����Ѵ���
		resp.retcode = G_ERRCODE["USED_NAME"]
		player:SendToClient(SerializeCommand(resp))
                player:Log("OnCommand_ChangeRoleName, error=USED_NAME")
		return
	end

	resp.retcode = G_ERRCODE["SUCCESS"]
	resp.name = arg.name
        player:SendToClient(SerializeCommand(resp))
        return
end
