function OnCommand_ChangeRoleName(player, role, arg, others)
        player:Log("OnCommand_ChangeRoleName, "..DumpTable(arg).." "..DumpTable(others))

        local resp = NewCommand("ChangeRoleName_Re")

	--����û�иı�
	if role._roledata._base._name == arg.name then
		resp.retcode = G_ERRCODE["USED_NAME"]
		player:SendToClient(SerializeCommand(resp))
                player:Log("OnCommand_ChangeRoleName, error=USED_NAME")
                return
        end

	--�Ƿ����ּ��
	if player:IsValidRolename(arg.name) == false then
                resp.retcode = G_ERRCODE["INVALID_NAME"]
                player:SendToClient(SerializeCommand(resp))
                player:Log("OnCommand_ChangeRoleName, error=INVALID_NAME")
                return
        end

	player:AllocRoleChangeName(arg.name)

        return
end
