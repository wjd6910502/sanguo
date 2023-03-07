function OnCommand_ListFriends(player, role, arg, others)
	player:Log("OnCommand_ListFriends, "..DumpTable(arg))

	local resp = NewCommand("ListFriends_Re")
	resp.friends = {}
	resp.requests = {}
	resp.black_list = {}
	--填充friends
	local friends = role._roledata._friend._friends
	local fit = friends:SeekToBegin() --从头开始遍历
	local f = fit:GetValue()
	while f~=nil do
		local f2 = {}
		f2.id = f._brief._id:ToStr()
		f2.name = f._brief._name
		f2.photo = f._brief._photo
		f2.level = f._brief._level
		f2.zhanli = f._zhanli
		f2.faction = f._faction
		f2.online = f._online
		f2.mashu_score = f._mashu_score
		f2.photo_frame = f._brief._photo_frame
		f2.sex = f._sex
		f2.badge_info = {}
		local badge_info_it = f._brief._badge_map:SeekToBegin()
		local badge_info = badge_info_it:GetValue()
		while badge_info ~= nil do
			local tmp_badge_info = {}
			tmp_badge_info.id = badge_info._id
			tmp_badge_info.typ = badge_info._pos
			f2.badge_info[#f2.badge_info+1] = tmp_badge_info

			badge_info_it:Next()
			badge_info = badge_info_it:GetValue()
		end
		
		resp.friends[#resp.friends+1] = f2
		fit:Next()
		f = fit:GetValue()
	end
	--填充requests
	local reqs = role._roledata._friend._requests
	local rit = reqs:SeekToBegin() --从头开始遍历
	local r = rit:GetValue()
	while r~=nil do
		local f2 = {}
		f2.id = r._brief._id:ToStr()
		f2.name = r._brief._name
		f2.photo = r._brief._photo
		f2.level = r._brief._level
		f2.zhanli = r._zhanli
		f2.sex = r._sex
		f2.photo_frame = r._brief._photo_frame

		f2.badge_info = {}
		local badge_info_it = r._brief._badge_map:SeekToBegin()
		local badge_info = badge_info_it:GetValue()
		while badge_info ~= nil do
			local tmp_badge_info = {}
			tmp_badge_info.id = badge_info._id
			tmp_badge_info.typ = badge_info._pos
			f2.badge_info[#f2.badge_info+1] = tmp_badge_info
	
			badge_info_it:Next()
			badge_info = badge_info_it:GetValue()
		end

		resp.requests[#resp.requests+1] = f2
		rit:Next()
		r = rit:GetValue()
	end
	--填充黑名单
	local black_list = role._roledata._friend._blacklist
	local black_info_it = black_list:SeekToBegin()
	local black_info = black_info_it:GetValue()
	while black_info ~= nil do
		local tmp_black = {}
		tmp_black.id = black_info._brief._id:ToStr()
		tmp_black.name = black_info._brief._name
		tmp_black.photo = black_info._brief._photo
		resp.black_list[#resp.black_list+1] = tmp_black

		black_info_it:Next()
		black_info = black_info_it:GetValue()
	end
	player:SendToClient(SerializeCommand(resp))
end
