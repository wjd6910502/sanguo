function OnMessage_PVPEnterRe(player, role, arg, others)
	player:Log("OnMessage_PVPEnterRe, "..DumpTable(arg).." "..DumpTable(others))
	
	if role._roledata._pvp._state == 0 then
		player:Log("OnMessage_PVPEnterRe, "..role._roledata._pvp._state)
		return
	end
	local resp = NewCommand("PvpEnter_Re")
	resp.retcode = 0
	resp.mode = 1
	resp.N = 4

	--开始发送PVP信息
	local is_idx,player1 = DeserializeStruct(arg.role_pvpinfo, 1, "RolePVPInfo")
	local is_idx,player2 = DeserializeStruct(arg.fight_pvpinfo, 1, "RolePVPInfo")

	resp.player1 = {}
	resp.player2 = {}

	resp.player1.brief = player1.brief
	resp.player1.hero_hall = player1.hero_hall
	resp.player1.pvp_score = player1.pvp_score
	
	resp.player2.brief = player2.brief
	resp.player2.hero_hall = player2.hero_hall
	resp.player2.pvp_score = player2.pvp_score
	
	local can_p2p = true
	local net_type_1 = player1.p2p_net_typ
	local net_type_2 = player2.p2p_net_typ
	if net_type_1<2 or net_type_2<2 then
		can_p2p = false --至少一端不支持udp, 怎么会到这里?
	elseif net_type_1==2 and net_type_2~=3 and net_type_2~=4 then
		can_p2p = false --一端为symetric, 且对端不强
	elseif net_type_2==2 and net_type_1~=3 and net_type_1~=4 then
		can_p2p = false --另一端为symetric, 且对端不强
	end

	local use_inner = false
	--同一局域网内
	if player1.p2p_public_ip==player2.p2p_public_ip then 
		use_inner=true 
	end 

--can_p2p = false
--use_inner = false
	--进行数据的统一
	if resp.player1.brief.id == role._roledata._base._id:ToStr() then
		if use_inner then
			resp.p2p_peer_ip = player2.p2p_local_ip
			resp.p2p_peer_port = player2.p2p_local_port
		elseif can_p2p then
			resp.p2p_peer_ip = player2.p2p_public_ip
			resp.p2p_peer_port = player2.p2p_public_port
		else
			resp.p2p_peer_ip = ""
			resp.p2p_peer_port = 0
		end
		
	else
		if use_inner then
			resp.p2p_peer_ip = player1.p2p_local_ip
			resp.p2p_peer_port = player1.p2p_local_port
		elseif can_p2p then
			resp.p2p_peer_ip = player1.p2p_public_ip
			resp.p2p_peer_port = player1.p2p_public_port
		else
			resp.p2p_peer_ip = ""
			resp.p2p_peer_port = 0
		end
	end
	
	if player1.p2p_magic >= player2.p2p_magic then
		resp.p2p_magic = resp.player2.p2p_magic
	else
		resp.p2p_magic = resp.player1.p2p_magic
	end
	player:SendToClient(SerializeCommand(resp))
end
