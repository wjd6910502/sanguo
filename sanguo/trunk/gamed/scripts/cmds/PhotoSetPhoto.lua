function OnCommand_PhotoSetPhoto(player, role, arg, others)
	player:Log("OnCommand_PhotoSetPhoto, "..DumpTable(arg).." "..DumpTable(others))

	local resp = NewCommand("PhotoSetPhoto_Re")
	resp.photo_id = arg.photo_id
	--�鿴�Լ��Ƿ������ͷ��
	local photo_info = role._roledata._base._photo_map:Find(arg.photo_id)

	if photo_info == nil then
		resp.retcode = G_ERRCODE["PHOTO_SET_NO_PHOTO"]
		player:SendToClient(SerializeCommand(resp))
		player:Log("OnCommand_PhotoSetPhoto, error=PHOTO_SET_NO_PHOTO")
		return
	end

	role._roledata._base._photo = arg.photo_id

	resp.retcode = G_ERRCODE["SUCCESS"]
	player:SendToClient(SerializeCommand(resp))
	
	local msg = NewMessage("TopListUpdateInfo")
	API_SendMsg(role._roledata._base._id:ToStr(), SerializeMessage(msg), 0)

	--���µ������Լ����
	local msg = NewMessage("RoleUpdateFriendInfo")
	msg.roleid = role._roledata._base._id:ToStr()
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
	
	--���Լ���״̬���µ����
	ROLE_UpdateMafiaInfo(role)
	--if role._roledata._mafia._id:ToStr() ~= "0" then
	--	local msg = NewMessage("RoleUpdateMafiaInfo")
	--	msg.roleid = role._roledata._base._id:ToStr()
	--	msg.level = role._roledata._status._level
	--	msg.zhanli = role._roledata._status._zhanli
	--	msg.online = role._roledata._status._online
	--	player:SendMessage(role._roledata._mafia._id, SerializeMessage(msg))
	--end
end