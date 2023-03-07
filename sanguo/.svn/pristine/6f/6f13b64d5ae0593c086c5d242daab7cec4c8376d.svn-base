function OnCommand_MafiaReply(player, role, arg, others)
	--player:Log("OnCommand_MafiaReply, "..DumpTable(arg))

 	----已有帮派?
	--if role._mafia._id:ToStr()~="0" then
	--	while role._mafia._invites:Size()>0 do role._mafia._invites:PopFront() end --TODO: Clear
	--	return
	--end

	--local mafia_id = "0"

	--local invs = role._mafia._invites
	----查找申请, 获取邀请中的mafia_id
	--local it = invs:SeekToBegin()
	--local inv = it:GetValue()
	--while inv~=nil do
	--	if inv._brief._id:ToStr()==arg.src_id then
	--		mafia_id = inv._brief._mafia_id:ToStr()
	--		it:Pop()
	--		break
	--	end
	--	it:Next()
	--	inv = it:GetValue()
	--end

	--if arg.accept~=true then return end

	----只有帮主才能邀请别人加入
	--local mafia = others.mafias[mafia_id]
	--if mafia==nil then return end
	--local s_role = others.roles[arg.src_id]
	--if s_role==nil then return end
	--if s_role._base._id:ToStr()~=mafia._boss_id:ToStr() then return end

	----加入
	--local member = CACHE.MafiaMember:new()
	--member._id = role._base._id
	--member._name = role._base._name
	--member._photo = role._base._photo
	--member._level = role._status._level
	--member._activity = 0
	--mafia._member_map:Insert(member._id, member)

	--role._mafia._id = mafia._id
	--role._mafia._name = mafia._name
	--while role._mafia._invites:Size()>0 do role._mafia._invites:PopFront() end --TODO: Clear

	--local msg = NewMessage("MafiaAddMember")
	--msg.member = ROLE_MakeRoleBrief(role)
	--local extra_mafias = CACHE.Int64List:new()
	--extra_mafias:PushBack(mafia._id);

	----TODO: 做个C++版的broadcast
	--local it = mafia._member_map:SeekToBegin()
	--local v = it:GetValue()
	--while v~=nil do
	--	--消息方式
	--	player:SendMessage(v._id, SerializeMessage(msg), CACHE.Int64List:new(), extra_mafias)
	--	it:Next()
	--	v = it:GetValue()
	--end
end
