function OnCommand_GetPrivateChatHistory(player, role, arg, others)
	player:Log("OnCommand_GetPrivateChatHistory, "..DumpTable(arg).." "..DumpTable(others))
	
	local resp = NewCommand("PrivateChatHistory")
	resp.private_chat = {}
	local chats = role._roledata._chat._received_private_chats

	local cit = chats:SeekToBegin()
	local c = cit:GetValue()
	while c~=nil do
		local c2 = {}
		c2.src = {}
		c2.dest = {}
		c2.src.id = c._brief._id:ToStr()
		c2.src.name = c._brief._name
		c2.src.photo = c._brief._photo
		c2.src.level = c._brief._level
		c2.src.mafia_id = c._brief._mafia_id:ToStr()
		c2.src.mafia_name = c._brief._mafia_name
		c2.src.photo_frame = c._brief._photo_frame
		c2.src.badge_info = {}
		local badge_info_it = c._brief._badge_map:SeekToBegin()
		local badge_info = badge_info_it:GetValue()
		while badge_info ~= nil do
			local tmp_badge_info = {}
			tmp_badge_info.id = badge_info._id
			tmp_badge_info.typ = badge_info._pos
			c2.src.badge_info[#c2.src.badge_info+1] = tmp_badge_info

			badge_info_it:Next()
			badge_info = badge_info_it:GetValue()
		end

		
		c2.dest.id = c._dest._id:ToStr()
		c2.dest.name = c._dest._name
		c2.dest.photo = c._dest._photo
		c2.dest.level = c._dest._level
		c2.dest.mafia_id = c._dest._mafia_id:ToStr()
		c2.dest.mafia_name = c._dest._mafia_name
		c2.dest.photo_frame = c._dest._photo_frame
		c2.dest.badge_info = {}
		local badge_info_it = c._dest._badge_map:SeekToBegin()
		local badge_info = badge_info_it:GetValue()
		while badge_info ~= nil do
			local tmp_badge_info = {}
			tmp_badge_info.id = badge_info._id
			tmp_badge_info.typ = badge_info._pos
			c2.dest.badge_info[#c2.dest.badge_info+1] = tmp_badge_info

			badge_info_it:Next()
			badge_info = badge_info_it:GetValue()
		end
		
		c2.text_content = c._content
		c2.time = c._time
		c2.speech_content = c._speech_content
		c2.typ =c._typ
		resp.private_chat[#resp.private_chat+1] = c2
		cit:Next()
		c = cit:GetValue()
	end
	player:SendToClient(SerializeCommand(resp))
end
