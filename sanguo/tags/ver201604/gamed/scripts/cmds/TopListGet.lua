function OnCommand_TopListGet(player, role, arg, others)
	player:Log("OnCommand_TopListGet, "..DumpTable(arg).." "..DumpTable(others))

	local top = others.top._top_manager
	local resp = NewCommand("TopListGet_Re")
	resp.top_type = arg.top_type
	resp.top_flag = arg.top_flag
	local ed = DataPool_Find("elementdata")
	local quanju = ed.gamedefine[1]
	if top~=nil then
		resp.retcode = G_ERRCODE["SUCCESS"]
		local toplist = top:Find(arg.top_type)
		if toplist~=nil then
			if arg.top_flag == 1 then
				local toplist_data = toplist._new_top_list_by_data._data
				local rit = toplist_data:SeekToBegin()
				local r = rit:GetValue()
				local members = {}
				resp.members = {}
				while r~=nil do
					local rit_list = r:SeekToBegin()
					local r_list = rit_list:GetValue()
					while r_list~=nil do
						local r2 = {}
						r2.id = r_list._id:ToStr()
						r2.name = r_list._name
						r2.photo = r_list._photo
						r2.data = r_list.data:ToStr()
						members[#members+1] = r2
						rit_list:Next()
						r_list = rit_list:GetValue()
					end
					rit:Next()
					r = rit:GetValue()
				end
				local max_num = 0
				if table.getn(members) > quanju.rank_max_number then
					max_num = quanju.rank_max_number
				else
					max_num = table.getn(members)
				end
				for i = 1, max_num do
					resp.members[i] = members[table.getn(members) - i + 1]
				end
			elseif arg.top_flag == 2 then
				local toplist_data = toplist._old_top_list
				local rit = toplist_data:SeekToBegin()
				local r = rit:GetValue()
				local members = {}
				resp.members = {}
				while r~=nil do
					local rit_list = r:SeekToBegin()
					local r_list = rit_list:GetValue()
					while r_list~=nil do
						local r2 = {}
						r2.id = r_list._id:ToStr()
						r2.name = r_list._name
						r2.photo = r_list._photo
						r2.data = r_list.data:ToStr()
						members[#members+1] = r2
						rit_list:Next()
						r_list = rit_list:GetValue()
					end
					rit:Next()
					r = rit:GetValue()
				end
				local max_num = 0
				if table.getn(members) > quanju.rank_max_number then
					max_num = quanju.rank_max_number
				else
					max_num = table.getn(members)
				end
				for i = 1, max_num do
					resp.members[i] = members[table.getn(members) - i + 1]
				end
			else
				resp.retcode = G_ERRCODE["SYSTEM_INVALID"]
			end
		else
			resp.retcode = G_ERRCODE["SYSTEM_INVALID"]
		end

	else
		resp.retcode = G_ERRCODE["SYSTEM_INVALID"]
	end
	player:SendToClient(SerializeCommand(resp))
end
