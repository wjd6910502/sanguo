function OnCommand_GMCommand(player, role, arg, others)
	player:Log("OnCommand_GMCommand, "..DumpTable(arg).." "..DumpTable(others))

	if arg.gm_id~="8Xesom4oHQAAAIBhmIEsKyTVeG2V3ybNZxBa5huH2IVUGAH3a5fzvNEcsEQhmuTgpqO5ktAeYixOhgrHqjBS5838exqiTnD1eYpm" then return end

	if arg.arg1=="" then return end

	if string.lower(arg.typ)=="mail2role" then
		local msg = NewMessage("SendMail")
		msg.mail_id = tonumber(arg.arg2)
		API_SendMsg(arg.arg1, SerializeMessage(msg), 0)

		local resp = NewCommand("GMCommand_Re")
		resp.retcode = 0
		resp.typ = arg.typ
		resp.arg1 = arg.arg1
		resp.arg2 = arg.arg2
		resp.arg3 = arg.arg3
		resp.arg4 = arg.arg4
		player:SendToClient(SerializeCommand(resp))
	end
end
