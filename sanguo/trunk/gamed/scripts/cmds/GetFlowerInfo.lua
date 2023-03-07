function OnCommand_GetFlowerInfo(player, role, arg, others)
	player:Log("OnCommand_GetFlowerInfo, "..DumpTable(arg).." "..DumpTable(others))
	
	local cmd = NewCommand("GetFlowerInfo_Re")
	cmd.info={}
	
	local dest_role = {}
	if arg.id == role._roledata._base._id:ToStr() then
		dest_role = role
		if dest_role == nil then
			return
		end
	else
		dest_role = others.roles[arg.id]
		if dest_role == nil then
			player:Log("OnCommand_GetFlowerInfo, ".."not lock role")			
			return
		end
	end
	
	cmd.info = ROLE_MakeRoleBrief(dest_role)
	-- 10 代表余香  11 代表鲜花
	local rep = dest_role._roledata._rep_info:Find(10)
	if rep == nil then
		cmd.lingering = 0
	else
		cmd.lingering = rep._rep_num
	end
		
	local rep = dest_role._roledata._rep_info:Find(11)
	if rep == nil then
		cmd.flower_count = 0
	else
		cmd.flower_count = rep._rep_num
	end	
	
	player:Log("OnCommand_GetFlowerInfo, ".."linger num = "..cmd.flower_count)			

	--别人送自己的送花记录
	local fit = dest_role._roledata._flower_info._record:SeekToBegin()
	local f = fit:GetValue()
	cmd.flowergift_info={}
	while f ~= nil do			
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
		local tt = dest_role._roledata._flower_info._sendflower:Find(f._info._id)
		if tt ==nil then
			giftinfo.flowermask = 0
		else
			giftinfo.flowermask = 1
		end

		cmd.flowergift_info[#cmd.flowergift_info+1]=giftinfo				
		fit:Next()
		f = fit:GetValue()
	end
	
	--dest_role._roledata._flower_info._sendflower:Clear()
	--自己的送花记录
	local sfit = dest_role._roledata._flower_info._send_record:SeekToBegin()
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
		local tt = dest_role._roledata._flower_info._sendflower:Find(sf._info._id)
		if tt ==nil then
			giftinfo.flowermask = 0
		else
			giftinfo.flowermask = 1
		end
		
		cmd.sendflowergift_info[#cmd.sendflowergift_info+1]=giftinfo			
		sfit:Next()
		sf = sfit:GetValue()
	end

	cmd.recive_flag = role._roledata._flower_info._recive_flag

	--成就称号
	cmd.title_id = 0
	for task_id = 32026, 32032 do --对应成就表的成就id
		local task = dest_role._roledata._task._finish_task:Find(task_id)
		if task == nil then break end
		cmd.title_id = task_id
	end
	
	role:SendToClient(SerializeCommand(cmd))
end	
	
	
