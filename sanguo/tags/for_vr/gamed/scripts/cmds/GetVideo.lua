function OnCommand_GetVideo(player, role, arg, others)
	player:Log("OnCommand_GetVideo, "..DumpTable(arg).." "..DumpTable(others))

	--��Center��������¼�����Ϣ
	role:GetPVPVideo(arg.video_id)
end
