
function GMCommand_Mail2Role()
	Init()
	Login()

	--send GMCommand
	local cmd = NewCommand("GMCommand")
	cmd.gm_id = "8Xesom4oHQAAAIBhmIEsKyTVeG2V3ybNZxBa5huH2IVUGAH3a5fzvNEcsEQhmuTgpqO5ktAeYixOhgrHqjBS5838exqiTnD1eYpm"
	cmd.typ = "Mail2Role"
	--cmd.arg1 = "281474977710673" --role_id
	--cmd.arg2 = "1347" --mailid

	dests = {}
	--dests[#dests+1] = "281474976712886"
	dests[#dests+1] = "281474977710673"

	for _,roleid in ipairs(dests) do
		cmd.arg1 = roleid --role_id
		--cmd.arg2 = "3001" --mailid
		cmd.arg2 = "1347" --mailid
		API_SendGameProtocol(SerializeCommand(cmd))

		Sleep(1)
	end

	API_Log("DONE!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
	API_Log("DONE!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
	API_Log("DONE!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
	API_Log("DONE!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
	API_Log("DONE!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")

        while true do
		Sleep(1)
	end
end

