function OnCommand_RoleNameQuery(player, role, arg, others)
	player:Log("OnCommand_RoleNameQuery, "..DumpTable(arg).." "..DumpTable(others))

	local resp = NewCommand("RoleNameQuery_Re")
	resp.pattern = arg.pattern
	resp.results = {}
	resp.reason = arg.reason

	local cache = others.rolenamecache
	local rets = cache:Query(arg.pattern)
	if rets~=nil then
		for ret in Cache_List(rets) do
			if ret._id:ToStr() ~= role._roledata._base._id:ToStr() then
				local tmp_brief = {}
				tmp_brief.id = ret._id:ToStr()
				tmp_brief.name = ret._name
				tmp_brief.photo = ret._photo
				tmp_brief.photo_frame = ret._photo_frame
				tmp_brief.badge_info = {}
				for badge in Cache_Map(ret._badge_map) do
					local tmp_badge = {}
					tmp_badge.id = badge._id
					tmp_badge.typ = badge._pos
					tmp_brief.badge_info[#tmp_brief.badge_info+1] = tmp_badge
				end
				tmp_brief.sex = ret._sex
				tmp_brief.level = ret._level
				tmp_brief.mafia_id = ret._mafia_id:ToStr()
				tmp_brief.mafia_name = ret._mafia_name
				
				resp.results[#resp.results+1] = tmp_brief
			end
			if #resp.results == 5 then
				break
			end
		end
		cache:ReleaseResult(rets)
	end

	player:SendToClient(SerializeCommand(resp))
end
