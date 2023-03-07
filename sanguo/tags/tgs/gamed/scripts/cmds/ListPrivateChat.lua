function OnCommand_ListPrivateChat(player, role, arg, others)
	player:Log("ListPrivateChat")

	local resp = NewCommand("ListPrivateChat_Re")
	resp.chats = {}
	--Ìî³ächats
	local chats = player._role_chat._received_private_chats
	local cit = chats:SeekToBegin()
	local c = cit:GetValue()
	while c~=nil do
		local p = others:FindPlayer(c._id)
		if p~=nil then
			local c2 = {}
			c2.src_id = p._role_base._id:ToStr()
			c2.src_name = p._role_base._name
			c2.time = c._time
			c2.content = c._content
			resp.chats[#resp.chats+1] = c2
		end
		cit:Next()
		c = cit:GetValue()
	end
	player:SendToClient(SerializeCommand(resp))
end
