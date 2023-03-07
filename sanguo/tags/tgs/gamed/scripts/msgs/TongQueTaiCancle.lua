function OnMessage_TongQueTaiCancle(player, role, arg, others)
	player:Log("OnMessage_TongQueTaiCancle, "..DumpTable(arg).." "..DumpTable(others))

	if role._roledata._tongquetai_data._cur_state ~= 1 then
		return
	end
	
	local tongquetai = others.tongquetai._data

	local all_fight = tongquetai._join_role:Find(role._roledata._base._id)
	if all_fight == nil then
		return
	end

	local difficulty_info_list = 0
	if all_fight._difficulty == 1 then
		difficulty_info_list = tongquetai._hard_difficulty:Find(all_fight._fight)
	else
		difficulty_info_list = tongquetai._easy_difficulty:Find(all_fight._fight)
	end

	if difficulty_info_list ~= nil then
		local difficulty_info_it = difficulty_info_list:SeekToBegin()
		local difficulty_info = difficulty_info_it:GetValue()
		while difficulty_info ~= nil do
			if difficulty_info._role_base._id:ToStr() == role._roledata._base._id:ToStr() then
				difficulty_info_it:Pop()
				break
			end
			
			difficulty_info_it:Next()
			difficulty_info = difficulty_info_it:GetValue()
		end
	end

	role._roledata._tongquetai_data._cur_state = 0
	tongquetai._join_role:Delete(role._roledata._base._id)
end
