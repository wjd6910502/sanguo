function DESIGNER_PVPVsRobot(arg, rank_data)
	--arg: {rank,failed_count_in_succession}
	if rank_data==nil then return 0,999 end
	if arg.failed_count_in_succession>=rank_data.lose_robot then
		return 1, 0
	end
	return 0, rank_data.overtime_robot_time
end

