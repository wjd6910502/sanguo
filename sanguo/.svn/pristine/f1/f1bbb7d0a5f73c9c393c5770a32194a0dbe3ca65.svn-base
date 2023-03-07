function OnMessage_FlowerGiftUpdate(player, role, arg, others)
	player:Log("OnMessage_FlowerGiftUpdate, "..DumpTable(arg).." "..DumpTable(others))
	
	local cmd = NewCommand("UpdateFlowerGiftInfo")
	cmd.info = ROLE_MakeRoleBrief(role)
	cmd.money = role._roledata._status._money
	cmd.coin = role._roledata._status._yuanbao
	cmd.vp = role._roledata._status._vp
	cmd.cur_title = role._roledata._flower_info._cur_title	
	-- 10 代表余香  11 代表鲜花 
	local rep = role._roledata._rep_info:Find(10)
	if rep == nil then
		cmd.lingering = 0
	else
		cmd.lingering = rep._rep_num
	end
		
	local rep = role._roledata._rep_info:Find(11)
	if rep == nil then
		cmd.flower_count = 0
	else
		cmd.flower_count = rep._rep_num
	end	

	--别人送自己的送花记录
	local fit = role._roledata._flower_info._record:SeekToBegin()
	local f = fit:GetValue()
	cmd.flowergift_info={}
	while f ~= nil do			
		player:Log("OnCommand_GetFlowerInfo, 111111111111111111111111111111")
		local giftinfo={}
		giftinfo.info={}
		giftinfo.info.id = f._info._id:ToStr()
		giftinfo.info.name = f._info._name
		giftinfo.info.photo = f._info._photo
 		giftinfo.info.level = f._info._level
		giftinfo.info.mafia_id = f._info._mafia_id:ToStr()
		giftinfo.info.mafia_name = f._info._mafia_name
		giftinfo.info.photo_frame = f._info._photo_frame
		giftinfo.count= f._count
		giftinfo.time = f._time
		giftinfo.mask = f._mask
		giftinfo.flowermask = 0				
		cmd.flowergift_info[#cmd.flowergift_info+1]=giftinfo
				
		fit:Next()
		f = fit:GetValue()
	end

	--自己的送花记录
	local sfit = role._roledata._flower_info._send_record:SeekToBegin()
	local sf = sfit:GetValue()			
	cmd.sendflowergift_info={}
	while sf ~= nil do
		local giftinfo={}
		giftinfo.info={}
		giftinfo.info.id = sf._info._id:ToStr()
		giftinfo.info.name = sf._info._name
		giftinfo.info.photo = sf._info._photo
 		giftinfo.info.level = sf._info._level
		giftinfo.info.mafia_id = sf._info._mafia_id:ToStr()
		giftinfo.info.mafia_name = sf._info._mafia_name
		giftinfo.info.photo_frame = sf._info._photo_frame
		giftinfo.count= sf._count
		giftinfo.time = sf._time
		giftinfo.mask = sf._mask
		giftinfo.flowermask = 0
			
		cmd.sendflowergift_info[#cmd.sendflowergift_info+1]=giftinfo
			
		sfit:Next()
		sf = sfit:GetValue()
	end
			
	player:Log("OnMessage_GetFlowerInfo, ".."send..................")
	role:SendToClient(SerializeCommand(cmd))

end
