function OnCommand_RemoveFriend(player, role, arg, others)
	player:Log("OnCommand_RemoveFriend, dest_id="..arg.dest_id)

	local resp = NewCommand("RemoveFriend_Re")

	resp.dest_id = arg.dest_id
	resp.retcode = G_ERRCODE["SUCCESS"]
	--���Լ��ĺ����б��������ɾ����
	if role._roledata._friend._friends:Find(CACHE.Int64(arg.dest_id)) ~= nil then
		role._roledata._friend._friends:Delete(CACHE.Int64(arg.dest_id))

		--����ɾ���������һ����Ϣ���޸����Ǹ�����ĺ�����Ϣ
		local msg = NewMessage("DelFriend")
		msg.roleid = role._roledata._base._id:ToStr()
		API_SendMsg(arg.dest_id, SerializeMessage(msg), 0)
	end
	player:SendToClient(SerializeCommand(resp))
end
