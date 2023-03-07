function OnMessage_AudienceGetList(player, role, arg, others)
	player:Log("OnMessage_AudienceGetList, "..DumpTable(arg).." "..DumpTable(others))


	local is_idx,fight_info = DeserializeStruct(arg.fight_info, 1, "CenterFightInfo")

	local resp = NewCommand("AudienceGetList_Re")
	resp._fight_info = {}
	
	for i = 1, table.getn(fight_info.info) do
		
		local tmp_fight_info = {}
		tmp_fight_info.room_id = fight_info.info[i].room_id
		tmp_fight_info.fight1_id = fight_info.info[i].fight1_info.brief.id
		tmp_fight_info.fight2_id = fight_info.info[i].fight2_info.brief.id
		tmp_fight_info.fight1_name = fight_info.info[i].fight1_info.brief.name
		tmp_fight_info.fight2_name = fight_info.info[i].fight2_info.brief.name
		tmp_fight_info.fight1_hero_hall = fight_info.info[i].fight1_info.hero_hall
		tmp_fight_info.fight2_hero_hall = fight_info.info[i].fight2_info.hero_hall

		resp._fight_info[#resp._fight_info+1] = tmp_fight_info
	end
	player:SendToClient(SerializeCommand(resp))
end
