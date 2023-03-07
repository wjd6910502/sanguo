function OnCommand_PVPReply(player, role, arg, others)
	player:Log("OnCommand_PVPReply, "..DumpTable(arg).." "..DumpTable(others))

	if role._roledata._pvp._id~=0 then 
		return 
	end

	local found = false
	local mode = 1
	local invs = role._roledata._pvp._invites
	--查找申请, 获取邀请中的mafia_id
	local it = invs:SeekToBegin()
	local inv = it:GetValue()
	while inv~=nil do
		if inv._src._id:ToStr()==arg.src_id then
			found = true
			mode = inv._mode
			it:Pop()
			break
		end
		it:Next()
		inv = it:GetValue()
	end
	if not found then return end

	if not arg.accept then return end

	local s_role = others.roles[arg.src_id]
	if s_role==nil then return end
	if s_role._roledata._pvp._id~=0 then return end --TODO: 喊句话吧，加个通用协议

	--建立PVP
	local pvp_id = API_PVP_Create(mode, s_role._roledata._base._id, role._roledata._base._id)
	if pvp_id<=0 then return end
	s_role._roledata._pvp._id = pvp_id
	role._roledata._pvp._id = pvp_id

	local cmd = NewCommand("PVPPrepare")
	cmd.id = pvp_id
	cmd.player1 = ROLE_MakeRoleBrief(s_role)
	cmd.player2 = ROLE_MakeRoleBrief(role)
	cmd.N = 2
	if mode==1 then cmd.N=4 end --精准同步模式: 66ms
	cmd.mode = mode
	cmd.p2p_magic = math.random(1000000)

	local can_p2p = true
	local net_type_1 = role._roledata._device_info._net_type
	local net_type_2 = s_role._roledata._device_info._net_type
	if net_type_1<2 or net_type_2<2 then
		can_p2p = false --至少一端不支持udp, 怎么会到这里?
	elseif net_type_1==2 and net_type_2~=3 and net_type_2~=4 then
		can_p2p = false --一端为symetric, 且对端不强
	elseif net_type_2==2 and net_type_1~=3 and net_type_1~=4 then
		can_p2p = false --另一端为symetric, 且对端不强
	end

	local use_inner = false
	if role._roledata._device_info._public_ip==s_role._roledata._device_info._public_ip then use_inner=true end --同一局域网内

	if use_inner then
		cmd.p2p_peer_ip = role._roledata._device_info._local_ip
		cmd.p2p_peer_port = role._roledata._device_info._local_port
	elseif can_p2p then
		cmd.p2p_peer_ip = role._roledata._device_info._public_ip
		cmd.p2p_peer_port = role._roledata._device_info._public_port
	else
		cmd.p2p_peer_ip = ""
		cmd.p2p_peer_port = 0
	end
	s_role:SendToClient(SerializeCommand(cmd))

	if use_inner then
		cmd.p2p_peer_ip = s_role._roledata._device_info._local_ip
		cmd.p2p_peer_port = s_role._roledata._device_info._local_port
	elseif can_p2p then
		cmd.p2p_peer_ip = s_role._roledata._device_info._public_ip
		cmd.p2p_peer_port = s_role._roledata._device_info._public_port
	else
		cmd.p2p_peer_ip = ""
		cmd.p2p_peer_port = 0
	end
	role:SendToClient(SerializeCommand(cmd))
end
