function OnCommand_RoleLogin(player, role, arg, others)
	player:Log("OnCommand_RoleLogin, "..DumpTable(arg).." "..DumpTable(others))

	--把玩家的私聊信息发给玩家
	
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

	--查看全服事件，来进行处理
	local msg = NewMessage("RoleUpdateServerEvent")
	player:SendMessage(role._roledata._base._id, SerializeMessage(msg))

	--刷新玩家的个人商店
	PRIVATE_RefreshAllShop(role)
	--刷新玩家的战役信息
	ROLE_RefreshAllBattleInfo(role)
	--local now = API_GetTime()
	--role._roledata._status._update_server_event = now
	
	--查看玩家是否存在正在匹配铜雀台
	if role._roledata._tongquetai_data._cur_state == 1 then
		local msg = NewMessage("TongQueTaiCancle")
		player:SendMessage(role._roledata._base._id, SerializeMessage(msg))
	end

	--更新一下军团信息,放到Load数据的时候去做一次
	--ROLE_UpdateLegionInfo(role)
	

	--设置自己上线，然后给自己的好友广播，自己信息的变化
	role._roledata._status._online = 1
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
	--把自己的状态更新到帮会
	if role._roledata._mafia._id:ToStr() ~= "0" then
		local msg = NewMessage("RoleUpdateMafiaInfo")
		msg.roleid = role._roledata._base._id:ToStr()
		msg.level = role._roledata._status._level
		msg.zhanli = role._roledata._status._zhanli
		msg.online = role._roledata._status._online
		player:SendMessage(role._roledata._mafia._id, SerializeMessage(msg))
	end

	role._roledata._status._time_line = G_ROLE_STATE["FREE"]
	TASK_ChangeCondition(role, G_ACH_TYPE["CONTINUTY_DAY"], 0, 1)
end
