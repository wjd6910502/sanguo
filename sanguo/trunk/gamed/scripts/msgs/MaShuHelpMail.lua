function OnMessage_MaShuHelpMail(player, role, arg, others)
	player:Log("OnMessage_MaShuHelpMail, "..DumpTable(arg).." "..DumpTable(others))

	--查看这个玩家今天已经得到了几次好友奖励了
	local ed = DataPool_Find("elementdata")
	local quanju = ed.gamedefine[1]
	if LIMIT_TestUseLimit(role, quanju.equestrain_zhuzhan_rewards_limit_id, 1) == true then
		LIMIT_AddUseLimit(role, quanju.equestrain_zhuzhan_rewards_limit_id, 1)

		--给自己仍一个消息，去发邮件，这里没有必要再对发邮件写一份一样的代码了。目前先这么用吧。
		local msg = NewMessage("SendMail")
		msg.mail_id = 1700
		msg.arg1 = arg.role_name
		API_SendMsg(role._roledata._base._id:ToStr(), SerializeMessage(msg), 0)
	end
end
