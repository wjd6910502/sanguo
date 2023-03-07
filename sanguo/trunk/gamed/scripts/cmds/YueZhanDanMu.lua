function OnCommand_YueZhanDanMu(player, role, arg, others)
	player:Log("OnCommand_YueZhanDanMu, "..DumpTable(arg).." "..DumpTable(others))

	if arg.video_id == "" then
		arg.video_id = "0"
	end
	role:SendPvpDanMu(arg.pvp_id, arg.video_id, arg.tick, arg.word_info)
end
