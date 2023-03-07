function OnCommand_PVPInvite(player, role, arg, others)
	player:Log("OnCommand_PVPInvite, "..DumpTable(arg).." "..DumpTable(others))

	--if string.byte(arg.dest_id)==48 then --"0"开始表示采用mode1
	--	arg.dest_id = tostring(tonumber(arg.dest_id))
	--	arg.mode = 1
	--end

	if arg.dest_id==role._roledata._base._id:ToStr() then return end
	--if arg.mode~=1 then arg.mode=2 end --默认采用瞎打模式
	arg.mode = 1 --只有精确模式

	local d_role = others.roles[arg.dest_id]
	if d_role==nil then return end

	local invs = d_role._roledata._pvp._invites
	--申请太多, 则删掉早期的申请
	while invs:Size()>=10 do invs:PopFront() end
	--已经申请过了?
	local it = invs:SeekToBegin()
	local inv = it:GetValue()
	while inv~=nil do
		if inv._src._id:ToStr()==role._roledata._base._id:ToStr() then
			if API_GetTime()-inv._time<10 then
				return
			else
				it:Pop()
				break
			end
		end
		it:Next()
		inv = it:GetValue()
	end
	--保存到申请列表
	local ninv = CACHE.PVPInvite:new()
	ninv._src._id = role._roledata._base._id
	ninv._src._name = role._roledata._base._name
	ninv._src._photo = role._roledata._base._photo
	ninv._src._level = role._roledata._status._level
	ninv._src._mafia_id = role._roledata._mafia._id
	ninv._src._mafia_name = role._roledata._mafia._name
	ninv._mode = arg.mode
	ninv._time = API_GetTime()
	invs:PushBack(ninv)

	--通知目标
	local cmd = NewCommand("PVPInvite")
	cmd.dest_id = arg.dest_id
	cmd.src = ROLE_MakeRoleBrief(role)
	cmd.mode = arg.mode
	d_role:SendToClient(SerializeCommand(cmd))
end
