function OnCommand_MafiaInvite(player, role, arg, others)
	--player:Log("OnCommand_MafiaInvite, "..DumpTable(arg).." "..DumpTable(others))

	----只有帮主才能邀请别人加入
	--local my_mafia = others.mafias[role._mafia._id:ToStr()]
	--if my_mafia==nil then return end
	--if role._base._id:ToStr()~=my_mafia._boss_id:ToStr() then return end

 	----目标已经有帮派了?
	--local d_role = others.roles[arg.dest_id]
	--if d_role==nil then return end
	--if d_role._mafia._id:ToStr()~="0" then return end

	--local invs = d_role._mafia._invites
	----申请太多, 则删掉早期的申请
	--while invs:Size()>=10 do invs:PopFront() end
	----已经申请过了?
	--local it = invs:SeekToBegin()
	--local inv = it:GetValue()
	--while inv~=nil do
	--	if inv._brief._id:ToStr()==role._base._id:ToStr() then return end
	--	it:Next()
	--	inv = it:GetValue()
	--end
	----保存到申请列表
	--local ninv = CACHE.MafiaInvite()
	--ninv._brief._id = role._base._id
	--ninv._brief._name = role._base._namme
	--ninv._brief._photo = role._base._photo
	--ninv._brief._level = role._status._level
	--ninv._brief._mafia_id = role._mafia._id
	--ninv._brief._mafia_name = role._mafia._name
	--invs:PushBack(ninv)

	----通知目标
	--local cmd = NewCommand("MafiaInvite")
	--cmd.dest_id = arg.dest_id
	--cmd.src = ROLE_MakeRoleBrief(role)
	--d_role:SendToClient(SerializeCommand(cmd))
end
