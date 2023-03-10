--全局状态变量

--常量
g_COUNT = 1000

--pvp
g_pvp_invites = {}
g_pvp_id = 0
g_opponent_id = 0
g_i_am_player1 = false
g_got_PVPBegin = false
g_pvp_fight_start_time = 0
g_received_client_tick_max = 0
g_received_client_tick_max_p2p = 0
g_player1_hash = 5381
g_player2_hash = 5381
g_player1_hash_p2p = 5381
g_player2_hash_p2p = 5381
g_got_PVPEnd = false

--模拟PVP过程
function TestPVP()
	Init()
	Login()

	--主循环
	while true
	do
		g_pvp_invites = {}
		g_pvp_id = 0
		g_opponent_id = 0
		g_i_am_player1 = false
		g_got_PVPBegin = false
		g_pvp_fight_start_time = 0
		g_received_client_tick_max = 0
		g_received_client_tick_max_p2p = 0
		g_player1_hash = 5381
		g_player2_hash = 5381
		g_player1_hash_p2p = 5381
		g_player2_hash_p2p = 5381
		g_got_PVPEnd = false

		while g_pvp_id==0
		do
			--大世界喊话，让别人知道自己
			local cmd = NewCommand("PublicChat")
			cmd.content = "hello, all, I'm Player"..g_main_thread_index.."!"
			API_SendGameProtocol(SerializeCommand(cmd))
			Sleep(1)
			--看到有人喊话，邀请PVP
			for k,_ in pairs(g_others)
			do
				if k~=g_role_id then
					local cmd = NewCommand("PVPInvite")
					cmd.dest_id = k
					API_SendGameProtocol(SerializeCommand(cmd), "R"..k)
					g_others[k] = nil
				end
			end
			Sleep(1)
			--处理已收到的PVP邀请
			for k,_ in pairs(g_pvp_invites)
			do
				local cmd = NewCommand("PVPReply")
				cmd.src_id = k
				cmd.accept = true
				API_SendGameProtocol(SerializeCommand(cmd), "R"..k)
				g_pvp_invites[k] = nil
			end
			Sleep(1)
		end

		API_SendGameProtocol(SerializeCommand(NewCommand("PVPReady")), "P"..g_pvp_id)
		while not g_got_PVPBegin do Nop() end

		--local cmd3 = NewCommand("UDPPing")
		--cmd3.client_send_time = API_GetTime2();
		--API_SendUDPGameProtocol(SerializeCommand(cmd3))

		API_FastSess_Open()

		while true
		do
			--local now = API_GetServerTime()
			local now = API_GetTime()
			if now>=g_pvp_fight_start_time then break end
			Nop()
		end

		local client_tick = 0
		while not g_got_PVPEnd
		do
			client_tick = client_tick+1

			while client_tick-g_received_client_tick_max>3 and client_tick-g_received_client_tick_max_p2p>3--网络帧=10*client_tick
			do
				--API_Log("waiting...")
				Nop() --卡住等
				if g_got_PVPEnd then break end
			end
			if g_got_PVPEnd then break end

			if client_tick>g_COUNT then break end

			local cmd = NewCommand("PVPOperation")
			cmd.client_tick = client_tick
			cmd.op = ""..math.random(0,99)
			API_FastSess_Send(SerializeCommand(cmd), "R"..g_opponent_id, "P"..g_pvp_id)

			API_Log("latency: "..API_GetLatency().." pvp latency: "..API_GetPVPLatency())

			if g_i_am_player1 then
				g_player1_hash_p2p = g_player1_hash_p2p*33 + cmd.op
				if g_player1_hash_p2p>=65536 then g_player1_hash_p2p=g_player1_hash_p2p%65536 end
			else
				g_player2_hash_p2p = g_player2_hash_p2p*33 + cmd.op
				if g_player2_hash_p2p>=65536 then g_player2_hash_p2p=g_player2_hash_p2p%65536 end
			end

			Nop()
		end

		while g_received_client_tick_max<g_COUNT and g_received_client_tick_max_p2p<g_COUNT do Nop() end --wait all

		API_Log("END: "..g_player1_hash.." "..g_player2_hash.." "..g_player1_hash-g_player2_hash)
		API_Log("P2P: "..g_player1_hash_p2p.." "..g_player2_hash_p2p.." "..g_player1_hash_p2p-g_player2_hash_p2p)

		if not g_got_PVPEnd then
			local cmd = NewCommand("PVPEnd")
			cmd.result = g_player1_hash-g_player2_hash
			API_SendGameProtocol(SerializeCommand(cmd), "P"..g_pvp_id)
			while not g_got_PVPEnd do Nop() end
		end

		API_FastSess_Reset()

		Nop()
	end
end

--PVP之友(mode 1): 陪练, 只挨揍不还手, 只接受邀请不主动邀请别人
function TestPVPFriend()
	Init()
	Login()

	--主循环
	while true
	do
		g_pvp_invites = {}
		g_pvp_id = 0
		g_opponent_id = 0
		g_got_PVPBegin = false
		g_pvp_fight_start_time = 0
		g_received_client_tick_max = 0
		g_received_client_tick_max_p2p = 0
		g_got_PVPEnd = false

		while g_pvp_id==0
		do
			--处理已收到的PVP邀请
			for k,_ in pairs(g_pvp_invites)
			do
				local cmd = NewCommand("PVPReply")
				cmd.src_id = k
				cmd.accept = true
				API_SendGameProtocol(SerializeCommand(cmd), "R"..k)
				g_pvp_invites[k] = nil
			end
			Sleep(1)
		end

		Sleep(3)

		API_SendGameProtocol(SerializeCommand(NewCommand("PVPReady")), "P"..g_pvp_id)
		while not g_got_PVPBegin do Nop() end

		--local cmd3 = NewCommand("UDPPing")
		--cmd3.client_send_time = API_GetTime2();
		--API_SendUDPGameProtocol(SerializeCommand(cmd3))

		API_FastSess_Open()

		while true
		do
			--local now = API_GetServerTime()
			local now = API_GetTime()
			if now>=g_pvp_fight_start_time then break end
			Nop()
		end

		local client_tick = 0
		while not g_got_PVPEnd
		do
			client_tick = client_tick+1

			--while client_tick-g_received_client_tick_max>3 --网络帧=10*client_tick
			while client_tick-g_received_client_tick_max>3 and client_tick-g_received_client_tick_max_p2p>3--网络帧=10*client_tick
			do
				--API_Log("waiting...     client_tick="..client_tick.." g_received_client_tick_max_p2p="..g_received_client_tick_max_p2p)
				Nop() --卡住等
				if g_got_PVPEnd then break end
			end
			if g_got_PVPEnd then break end

			local cmd = NewCommand("PVPOperation")
			cmd.client_tick = client_tick
			cmd.op = "300"
			API_FastSess_Send(SerializeCommand(cmd), "R"..g_opponent_id, "P"..g_pvp_id)

			Nop()
		end

		API_FastSess_Reset()

		API_Log("END")

		Nop()
	end
end

function TestGetServerTime()
	Init()
	Login()

	--主循环
	while Nop()
	do
		Sleep(10)

		API_Log("server time: "..API_GetServerTime())
		API_Log("local time: "..API_GetTime())
	end
end

function TestGetNetType()
	Init()
	Login()

	Sleep(3)

	local net_type = API_GetNetType()
	--if net_type==0 then
	--	if not API_IsGettingNetType() then API_TryGetNetType() end
	--	while API_IsGettingNetType() do Sleep(1) end
	--	net_type = API_GetNetType()
	--end

	API_Log("net type: "..net_type)
end

function TestTransaction0()
	Init()
	Login()

	local N = 1
	while Nop()
	do
		local cmd = NewCommand("DebugCommand")
		cmd.typ = "TestTransaction"
		cmd.count1 = 0
		cmd.count2 = N
		API_SendGameProtocol(SerializeCommand(cmd))

		N = N+1
		Sleep(1)
	end
end

function TestTransaction1()
	Init()
	Login()

	local N = 111
	while Nop()
	do
		local cmd = NewCommand("DebugCommand")
		cmd.typ = "TestTransaction"
		cmd.count1 = 1
		cmd.count2 = N
		API_SendGameProtocol(SerializeCommand(cmd))

		--N = N+1
		Sleep(1)
	end
end

function TestTransaction2()
	Init()
	Login()

	local N = 111
	while Nop()
	do
		local cmd = NewCommand("DebugCommand")
		cmd.typ = "TestTransaction"
		cmd.count1 = 2
		cmd.count2 = N
		API_SendGameProtocol(SerializeCommand(cmd))

		--N = N+1
		Sleep(1)
	end
end

function TestTransaction3()
	Init()
	Login()

	local cmd = NewCommand("DebugCommand")
	cmd.typ = "TestTransaction"
	cmd.count1 = 3
	API_SendGameProtocol(SerializeCommand(cmd))
end

function TestDuxg()
	Init()
	Login()

	while Nop()
	do
		local cmd = NewCommand("DebugCommand")
		cmd.typ = "DUXG"
		API_SendGameProtocol(SerializeCommand(cmd))

		Sleep(1)
	end
end

--PVP之友(mode 1): 匹配+陪练, 只挨揍不还手
g_Pvp = {}

function TestPVPFriend2()
	Init()
	Login()

	--主循环
	while true do
		while true do
			g_Pvp = {}

			--send SetInstanceHeroInfo
			local cmd = NewCommand("SetInstanceHeroInfo")
			cmd.typ = 2
			cmd.battle_id = 0
			cmd.horse = 0
			cmd.heros = {6, }
			API_SendGameProtocol(SerializeCommand(cmd))

			--send PvpJoin
			local cmd = NewCommand("PvpJoin")
			cmd.typ = 1
		--	cmd.heroinfo = {6, } --赵云
			API_SendGameProtocol(SerializeCommand(cmd))

			--wait PvpJoin_Re
			API_Log("wait PvpJoin_Re")
			local timeout = 0
			while g_Pvp["PvpJoin_Re"]==nil do
				if timeout>10 then break end
				Sleep(1)
				timeout = timeout+1
			end
			if timeout>10 then break end

			local PvpJoin_Re = g_Pvp["PvpJoin_Re"]
			if PvpJoin_Re.retcode~=0 then break end

			--wait PvpMatchSuccess
			API_Log("wait PvpMatchSuccess")
			local timeout = 0
			while g_Pvp["PvpMatchSuccess"]==nil do
				if timeout>60 then break end
				Sleep(1)
				timeout = timeout+1
			end
			if timeout>60 then break end

			local PvpMatchSuccess = g_Pvp["PvpMatchSuccess"]
			if PvpMatchSuccess.retcode~=0 then break end

			--send PvpEnter
			local cmd = NewCommand("PvpEnter")
			cmd.index = PvpMatchSuccess.index
			cmd.flag = 1
			API_SendGameProtocol(SerializeCommand(cmd))

			--wait PvpEnter_Re
			API_Log("wait PvpEnter_Re")
			local timeout = 0
			while g_Pvp["PvpEnter_Re"]==nil do
				if timeout>10 then break end
				Sleep(1)
				timeout = timeout+1
			end
			if timeout>10 then break end

			local PvpEnter_Re = g_Pvp["PvpEnter_Re"]
			if PvpEnter_Re.retcode~=0 then break end

			--send PvpSpeed
			local cmd = NewCommand("PvpSpeed")
			cmd.speed = 100
			API_SendGameProtocol(SerializeCommand(cmd))

			--send PVPReady
			local cmd = NewCommand("PVPReady")
			API_SendGameProtocol(SerializeCommand(cmd))

			--wait PVPBegin
			API_Log("wait PVPBegin")
			local timeout = 0
			while g_Pvp["PVPBegin"]==nil do
				if timeout>60 then break end
				Sleep(1)
				timeout = timeout+1
			end
			if timeout>60 then break end

			local PVPBegin = g_Pvp["PVPBegin"]
			API_SetPVPDInfo(PVPBegin.ip, PVPBegin.port)

			API_FastSess_Open()

			while true do
				local now = API_GetServerTime()
				if now>=PVPBegin.fight_start_time then break end
				Nop()
			end

			--send PVPOperation
			local client_tick = 0
			local PVPEnd = g_Pvp["PVPEnd"]
			while not PVPEnd do
				client_tick = client_tick+1

				if client_tick%100==0 then
					local cmd = NewCommand("PVPPeerLatency")
					cmd.latency = 400
					API_FastSess_Send(SerializeCommand(cmd))
				end

				local cmd = NewCommand("PVPOperation")
				cmd.client_tick = client_tick
				cmd.op = "300"
				API_FastSess_Send(SerializeCommand(cmd))

				Nop()
				PVPEnd = g_Pvp["PVPEnd"]
			end

			API_FastSess_Reset()

			break
		end

		Sleep(3)
		API_SendGameProtocol(SerializeCommand(NewCommand("PvpCancle")))
		Sleep(3)
		API_SendGameProtocol(SerializeCommand(NewCommand("GetRoleInfo")))
		Sleep(3)
		API_Log("NEXT PVP LOOP")
	end
end

--测试帮派
function TestMafia2()
	Init()
	Login()

	--没有帮派则建立帮派
	if g_mafia_id=="" or g_mafia_id=="0" then
		local cmd = NewCommand("MafiaCreate")
		cmd.name = "Mafia_"..API_GetTime().."_"..g_main_thread_index
		--cmd.flag = 1
		API_SendGameProtocol(SerializeCommand(cmd))
		--等待创建mafia结果
		while g_mafia_id=="" or g_mafia_id=="0" do Nop() end
	else
		--获取帮派信息
		API_SendGameProtocol(SerializeCommand(NewCommand("MafiaGet")), "M"..g_mafia_id)
		while not g_got_MafiaGet_Re do Nop() end
	end

	--主循环
	local loop = 0
	while Nop()
	do
	end
end

