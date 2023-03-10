function OnMessage_RoleLogout(player, role, arg, others)
	player:Log("OnMessage_RoleLogout, "..DumpTable(arg).." "..DumpTable(others))

	if role._roledata._status._online==0 then return end

	--首先设置自己下面，然后广播给自己所有的好友，自己信息的变化
	role._roledata._status._online = 0

	--遍历自己的好友，把自己的信息发过去
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
	ROLE_UpdateMafiaInfo(role)
	--if role._roledata._mafia._id:ToStr() ~= "0" then
	--	local msg = NewMessage("RoleUpdateMafiaInfo")
	--	msg.roleid = role._roledata._base._id:ToStr()
	--	msg.level = role._roledata._status._level
	--	msg.zhanli = role._roledata._status._zhanli
	--	msg.online = role._roledata._status._online
	--	player:SendMessage(role._roledata._mafia._id, SerializeMessage(msg))
	--end
	
	--数据统计日志
	--角色登出日志
	local date = os.date("%Y-%m-%d %H:%M:%S")
	--local time = os.date("%H:%M:%S", API_GetTime()-role._roledata._status._login_time-288000)
	local time = API_GetTime()-role._roledata._status._login_time
	player:BILog("{\"logtime\":\""..date.."\",\"logname\":\"rolelogout\",\"serverid\":\""..API_GetZoneId()..
		"\",\"os\":\""..role._roledata._device_info._os.."\",\"platform\":\"".."laohu".."\",\"userid\":\""
		..role._roledata._status._account.."\",\"account\":\""..role._roledata._status._account.."\",\"roleid\":\""
		..role._roledata._base._id:ToStr().."\",\"rolename\":\""..role._roledata._base._name.."\",\"lev\":\""
		..role._roledata._status._level.."\",\"totalcash\":\"".."0".."\",\"time\":\""..time.."\",\"yuanbaoleft\":\""
		..role._roledata._status._yuanbao.."\"}")
	--角色快照日志
	local vip_level = ROLE_GetVIP(role)
	local mafiaid = 0
	if role._roledata._mafia ~= nil then
		mafiaid = role._roledata._mafia._id
	end
	local createtime = os.date("%Y-%m-%d %H:%M:%S", role._roledata._base._create_time)
	local repmap = role._roledata._rep_info
	local repid3 = 0
	local repid4 = 0
	local repid7 = 0
	local repid12 = 0
	local repid13 = 0
	local rep = repmap:Find(3)
	if rep ~= nil then
		repid3 = rep._rep_num
	end
	rep = repmap:Find(4)
	if rep ~= nil then
		repid4 = rep._rep_num
	end
	rep = repmap:Find(7)
	if rep ~= nil then
		repid7 = rep._rep_num
	end
	rep = repmap:Find(12)
	if rep ~= nil then
		repid12 = rep._rep_num
	end
	rep = repmap:Find(13)
	if rep ~= nil then
		repid13 = rep._rep_num
	end
	player:BILog("{\"logtime\":\""..date.."\",\"logname\":\"chardata\",\"serverid\":\""..API_GetZoneId()..
		"\",\"os\":\""..role._roledata._device_info._os.."\",\"platform\":\"".."laohu".."\",\"userid\":\""
		..role._roledata._status._account.."\",\"account\":\""..role._roledata._status._account.."\",\"roleid\":\""
		..role._roledata._base._id:ToStr().."\",\"rolename\":\""..role._roledata._base._name.."\",\"createtime\":\""
		..createtime.."\",\"occupation\":\"0\",\"faction\":\""..mafiaid:ToStr().."\",\"lev\":\""..role._roledata._status._level..
		"\",\"totalcash\":\"".."0".."\",\"viplev\":\""..vip_level.."\",\"exp\":\""..role._roledata._status._exp:ToStr()..
		"\",\"fight\":\""..role._roledata._status._zhanli.."\",\"yuanbao\":\""..role._roledata._status._yuanbao..
		"\",\"coin1\":\""..role._roledata._status._money.."\",\"cointype1\":\"".."99".."\",\"coin2\":\""
		..repid3.."\",\"cointype2\":\"".."3".."\",\"coin3\":\""..repid4.."\",\"cointype3\":\"".."4"..
		"\",\"coin4\":\""..repid7.."\",\"cointype4\":\"".."7".."\",\"coin5\":\""..repid12.."\",\"cointype5\":\"".."12"..
		"\",\"coin6\":\""..repid13.."\",\"cointype6\":\"".."13".."\"}")

end
