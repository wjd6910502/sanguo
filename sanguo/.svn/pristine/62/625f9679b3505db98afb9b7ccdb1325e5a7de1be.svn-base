function OnCommand_SkinTimeOut(player, role, arg, others)
	player:Log("OnCommand_SkinTimeOut, "..DumpTable(arg).." "..DumpTable(others))
	
	--判断玩家是否有这个皮肤
	local skin_info = role._roledata._backpack._skin_items:Find(arg.skinid)
	if skin_info == nil then
	--	resp.retcode = G_ERRCODE["SKIN_NOT_EXIST"]
	--	player:SendToClient(SerializeCommand(resp))
		return
	end

	local time = API_GetTime()
	if skin_info._time ~= 0 and time >= skin_info._time then
		role._roledata._backpack._skin_items:Delete(arg.skinid)
		local cmd = NewCommand("SkinUpdateInfo")
		cmd.addflag = 2
		cmd.skinid = arg.skinid
		player:SendToClient(SerializeCommand(cmd))
		
		--发相应的邮件
		local ed = DataPool_Find("elementdata")
		local dress_info = ed:FindBy("dress_id", arg.skinid)
		local hero_info = role._roledata._hero_hall._heros:Find(dress_info.owner_id)
		if hero_info._skin == arg.skinid then
			local tem_hero = ed:FindBy("hero_id", hero_info._tid)
			hero_info._skin = tem_hero.default_dress
		end
		local quanju = ed.gamedefine[1]
		local msg = NewMessage("SendMail")
		msg.mail_id = quanju.dress_expire_mail
		msg.mafia_mail_id = 0
		msg.arg1 = dress_info.name
		API_SendMessage(role._roledata._base._id, SerializeMessage(msg), CACHE.Int64List(), CACHE.Int64List(), CACHE.IntList())
	else
		return
	end
end
