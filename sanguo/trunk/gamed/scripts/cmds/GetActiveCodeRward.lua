function OnCommand_GetActiveCodeRward(player, role, arg, others)
	player:Log("OnCommand_GetActiveCodeRward, "..DumpTable(arg).." "..DumpTable(others))

	local resp = NewCommand("GetActiveCodeRward_Re")

	--ÅÐ¶ÏÈÕÆÚ
	local ed = DataPool_Find("elementdata")
	local type = role:GetActiveCodeType(arg.code)
	local codeinfo = ed:FindBy("redeemcode", type)
	if codeinfo == nil then
		resp.retcode = G_ERRCODE["ACTIVE_CODE_TYPE"]
		player:SendToClient(SerializeCommand(resp))
		return
	end

	local now = API_GetTime()
	local now_date = os.date("*t", now)
	local data = now_date.year*10000 + now_date.month*100 + now_date.day
	if data < codeinfo.start_time or data > codeinfo.end_time then
		resp.retcode = G_ERRCODE["ACTIVE_CODE_TIME"]
		player:SendToClient(SerializeCommand(resp))
		return
	end

	if LIMIT_TestUseLimit(role, codeinfo.limit_id, 1) ~= true then
		resp.retcode = G_ERRCODE["ACTIVE_CODE_USED"]
		player:SendToClient(SerializeCommand(resp))
		return
	end
	role:IsValidActiveCode(arg.code)
end
