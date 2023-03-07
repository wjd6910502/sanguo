function OnCommand_MaShuGetRoleInfo(player, role, arg, others)
	player:Log("OnCommand_MaShuGetRoleInfo, "..DumpTable(arg).." "..DumpTable(others))

	local resp = NewCommand("MaShuGetRoleInfo_Re")
	if role._roledata._mashu_info._today_max_score == 0 then
		resp.rank = 0
	else
		resp.rank = TOP_ALL_Role_GetRoleRank(others.toplist_all_role._data._data, 1,
				role._roledata._base._id, role._roledata._mashu_info._today_max_score)
	end

	local now = API_GetTime()
	if now > role._roledata._mashu_info._timestamp then
		role._roledata._mashu_info._yestaday_rank = 0
	end

	resp.yestaday_rank = role._roledata._mashu_info._yestaday_rank
	resp.today_score = role._roledata._mashu_info._today_max_score
	resp.hisroty_score = role._roledata._mashu_info._history_max_score
	resp.today_stage = role._roledata._mashu_info._today_max_stage
	resp.history_stage = role._roledata._mashu_info._history_max_stage
	resp.get_prize_flag = role._roledata._mashu_info._get_prize_flag
	
	resp.hero_info = {}
	resp.hero_info.hero_id = role._roledata._mashu_info._hero_info._heroid
	resp.hero_info.horse_id = role._roledata._mashu_info._hero_info._horse_id
	
	resp.friend_info = {}
	local friend_info_it = role._roledata._mashu_info._friend_info:SeekToBegin()
	local friend_info = friend_info_it:GetValue()
	while friend_info ~= nil do
		local tmp_friend_info = {}
		tmp_friend_info.role_id = friend_info._roleid:ToStr()
		tmp_friend_info.count = friend_info._count
		resp.friend_info[#resp.friend_info+1] = tmp_friend_info
		
		friend_info_it:Next()
		friend_info = friend_info_it:GetValue()
	end

	resp.buff_info = {}
	local buff_info_it = role._roledata._mashu_info._buff:SeekToBegin()
	local buff_info = buff_info_it:GetValue()
	while buff_info ~= nil do
		local tmp_buff_info = {}
		tmp_buff_info.id = buff_info._id
		tmp_buff_info.buffer_id = buff_info._buff_id
		tmp_buff_info.typ = buff_info._typ
		resp.buff_info[#resp.buff_info+1] = tmp_buff_info

		buff_info_it:Next()
		buff_info = buff_info_it:GetValue()
	end

	resp.fight_friend = {}
	resp.fight_friend.role_id = role._roledata._mashu_info._fight_friend._roleid:ToStr()
	resp.fight_friend.name = role._roledata._mashu_info._fight_friend._name
	resp.fight_friend.zhanli = role._roledata._mashu_info._fight_friend._zhanli
	player:SendToClient(SerializeCommand(resp))
end
