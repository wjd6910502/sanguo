
--�ṹ��
g_main_thread_index = 0
g_main_thread = nil

--ȫ��״̬����
--��¼���
g_got_GetVersion_Re = false
g_got_GetRoleInfo_Re = false
g_role_id = ""
--�������
g_got_ListFriends_Re = false
g_friends = {}
g_requests = {}
g_requesting = {}
g_others = {}
g_others_mafia_id = {}
--�������
g_got_EnterInstance_Re = false
g_got_CompleteInstance_Re = false
--mafia
g_got_MafiaGet_Re = false
g_mafia_id = ""
g_mafia_inviting = {}
g_mafia_invites = {} -- src_role_id=>mafia_id


dofile "scripts/duxg.lua"


--�ṹ��
function CreateThread(index, policy)
	g_main_thread_index = index 
	g_main_thread = coroutine.create(_G[policy])
end

function Heartbeat()
	if g_main_thread~=nil then coroutine.resume(g_main_thread) end
end

function Nop()
	coroutine.yield()
	return true
end

function Sleep(nsecs)
	local b = API_GetTime2()
	while Nop()
	do
		local now = API_GetTime2()
		if now-b>=nsecs*1000 then break end
	end
end

function Init()
	math.randomseed(API_GetTime2()+g_main_thread_index)
end

function Login()
	--��¼
	--�ϴ��汾��Ϣ
	local cmd = NewCommand("ReportClientVersion")
	cmd.client_id = "Android 2016-04-14"
	cmd.exe_ver = "10"
	cmd.data_ver = "100"
	API_SendGameProtocol(SerializeCommand(cmd))
	--��ȡ��ɫ��Ϣ
	API_SendGameProtocol(SerializeCommand(NewCommand("GetRoleInfo")))
	while not g_got_GetRoleInfo_Re do Nop() end
	--û�н�ɫ������ɫ
	if g_role_id=="" or g_role_id=="0" then
		local cmd = NewCommand("CreateRole")
		cmd.name = "Player_"..API_GetTime().."_"..g_main_thread_index
		cmd.photo = 1
		API_SendGameProtocol(SerializeCommand(cmd))
		--�ȴ�������ɫ���
		while g_role_id=="" or g_role_id=="0" do Nop() end
	end

	API_SetRoleId(g_role_id)
end

--���ɲ������
function Test()
	Init()
	Login()

	----���Ѳ���
	----��ȡfriends�б�
	--API_SendGameProtocol(SerializeCommand(NewCommand("ListFriends")))
	--while not g_got_ListFriends_Re do Nop() end
	--��ѭ��
	local loop = 0
	while Nop()
	do
		loop = loop+1

		----�����纰�����ñ���֪���Լ�
		--local cmd = NewCommand("PublicChat")
		--cmd.content = "hello, all! "..loop
		--API_SendGameProtocol(SerializeCommand(cmd))

		--��1��
		local cmd2 = NewCommand("DebugCommand")
		cmd2.typ = "levelup"
		API_SendGameProtocol(SerializeCommand(cmd2))

		----�������˺�����������Ǻ���������Ӻ���
		--for k,v in pairs(g_others)
		--do
		--	if k~=g_role_id and g_friends[k]==nil and g_requests[k]==nil and g_requesting[k]==nil then
		--		local cmd = NewCommand("FriendRequest")
		--		cmd.dest_id = k
		--		API_SendGameProtocol(SerializeCommand(cmd), "R"..cmd.dest_id)
		--		g_requesting[k] = true
		--	end
		--end
		----�������յ��ĺ�������
		--for k,v in pairs(g_requests)
		--do
		--	if v~=nil then
		--		if k~=g_role_id and g_friends[k]==nil then
		--			local cmd = NewCommand("FriendReply")
		--			cmd.src_id = k
		--			cmd.accept = true
		--			API_SendGameProtocol(SerializeCommand(cmd), "R"..cmd.src_id)
		--		end
		--		g_requests[k] = nil
		--	end
		--end
	end
end

--���Ը������
function TestInstance()
	Init()
	Login()

	--���Ͻ�������
	--��ѭ��
	loop = 0
	while Nop()
	do
		loop = loop+1
		--������
		g_got_EnterInstance_Re = false
		local cmd = NewCommand("EnterInstance")
		cmd.inst_tid = loop
		API_SendGameProtocol(SerializeCommand(cmd))
		while not g_got_EnterInstance_Re do Nop() end
		--��ɸ���
		g_got_CompleteInstance_Re = false
		local cmd = NewCommand("CompleteInstance")
		cmd.inst_tid = loop
		cmd.score = 100
		API_SendGameProtocol(SerializeCommand(cmd))
		while not g_got_CompleteInstance_Re do Nop() end
	end
end

--���԰���(����)
function TestMafiaAsBoss()
	Init()
	Login()

	--û�а�����������
	if g_mafia_id=="" or g_mafia_id=="0" then
		local cmd = NewCommand("MafiaCreate")
		cmd.name = "Mafia"..g_main_thread_index
		cmd.flag = 1
		API_SendGameProtocol(SerializeCommand(cmd))
		--�ȴ�������ɫ���
		while g_mafia_id=="" or g_mafia_id=="0" do Nop() end
	else
		--��ȡ������Ϣ
		API_SendGameProtocol(SerializeCommand(NewCommand("MafiaGet")), "M"..g_mafia_id)
		while not g_got_MafiaGet_Re do Nop() end
	end

	--��ѭ��
	local loop = 0
	while Nop()
	do
		--�������˺��������û�а���������
		for k,v in pairs(g_others_mafia_id)
		do
			if v=="0" and g_mafia_inviting[k]==nil then
				local cmd = NewCommand("MafiaInvite")
				cmd.dest_id = k
				API_SendGameProtocol(SerializeCommand(cmd), "R"..cmd.dest_id, "M"..g_mafia_id)
				g_mafia_inviting[k] = true
			end
		end
	end
end

--���԰���(����)
function TestMafia()
	Init()
	Login()

	--��ѭ��
	local loop = 0
	while Nop()
	do
		loop = loop+1

		if g_mafia_id=="" or g_mafia_id=="0" then
			--�����纰�����ñ���֪���Լ�
			local cmd = NewCommand("PublicChat")
			cmd.content = "hello, all, I'm Player"..g_main_thread_index.."! "..loop
			API_SendGameProtocol(SerializeCommand(cmd))

			--�������յ��İ�������
			for k,v in pairs(g_mafia_invites)
			do
				local cmd = NewCommand("MafiaReply")
				cmd.src_id = k
				cmd.accept = true
				API_SendGameProtocol(SerializeCommand(cmd), "R"..cmd.src_id, "M"..v)
				g_mafia_invites[k] = nil
			end
		end
	end
end

--���Է�������Ӧ�ٶ�
function TestPing()
	Init()
	Login()

	--��ѭ��
	loop = 0
	while Nop()
	do
		loop = loop+1
		--send Ping
		local cmd2 = NewCommand("Ping")
		cmd2.client_send_time = API_GetTime2();
		API_SendGameProtocol(SerializeCommand(cmd2))

		local cmd3 = NewCommand("UDPPing")
		cmd3.client_send_time = API_GetTime2();
		API_SendUDPGameProtocol(SerializeCommand(cmd3))

		Sleep(1)
	end
end

--���������������������ѹ��
function TestPublicChat()
	Init()
	Login()

	--��ѭ��
	local loop = 0
	while Nop()
	do
		loop = loop+1

		--�����纰�����ñ���֪���Լ�
		local cmd = NewCommand("PublicChat")
		cmd.content = "hello, all, I'm Player"..g_main_thread_index.."! "..loop
		API_SendGameProtocol(SerializeCommand(cmd))
	end
end

--���Ե�������
function TestDebugCommand()
	Init()
	Login()

	--��ѭ��
	loop = 0
	while Nop()
	do
		loop = loop+1

		local cmd2 = NewCommand("DebugCommand")
		cmd2.typ = "TestMessage4"
		API_SendGameProtocol(SerializeCommand(cmd2))
		Sleep(1)
	end
end

function TestGetBackPack()
	Init()
	Login()

	--��ѭ��
	local cmd = NewCommand("GetBackPack")
	API_SendGameProtocol(SerializeCommand(cmd))
end

function TestSweepInstance()
	Init()
	Login()

	--��ѭ��
	local cmd = NewCommand("SweepInstance")
	cmd.instance = 1
	cmd.count = 2
	API_SendGameProtocol(SerializeCommand(cmd))
end

function TestGetInstance()
	Init()
	Login()

	--��ѭ��
	local cmd = NewCommand("GetInstance")
	API_SendGameProtocol(SerializeCommand(cmd))
end

function TestVIP(count)

	--��ѭ��
	local cmd = NewCommand("BuyYuanBao")
	cmd.yuanbao = count
	cmd.chongzhi = count
	API_SendGameProtocol(SerializeCommand(cmd))
end

function TestCompleteInstance()
	Init()
	Login()

	local cmd2 = NewCommand("DebugCommand")
	cmd2.typ = "AddYuanBao"
	cmd2.count1 = 100000
	API_SendGameProtocol(SerializeCommand(cmd2))
	Sleep(2)

	local cmd2 = NewCommand("BuyHero")
	cmd2.tid = 1782
	cmd2.typ = 2
	API_SendGameProtocol(SerializeCommand(cmd2))
	Sleep(2)

	cmd2.tid = 1783
	cmd2.typ = 2
	API_SendGameProtocol(SerializeCommand(cmd2))
	Sleep(2)

	cmd2.tid = 1784
	cmd2.typ = 2
	API_SendGameProtocol(SerializeCommand(cmd2))
	Sleep(2)

	API_Log("11111111111111111111111111111111111111111111")
	cmd2 = NewCommand("EnterInstance")
	API_Log("11111111111111111111111111111111111111111111")
	cmd2.inst_tid = 1001
	API_Log("11111111111111111111111111111111111111111111")
	cmd2.heros = {}
	cmd2.heros[1] = 1782
	API_Log("11111111111111111111111111111111111111111111")
	cmd2.heros[2] = 1783
	API_Log("11111111111111111111111111111111111111111111")
	cmd2.heros[3] = 1784
	API_Log("11111111111111111111111111111111111111111111")

	API_SendGameProtocol(SerializeCommand(cmd2))
	Sleep(2)
	API_Log("11111111111111111111111111111111111111111111")

	cmd2 = NewCommand("CompleteInstance")
	cmd2.inst_tid = 1001
	cmd2.flag = 1
	cmd2.heros = {}
	cmd2.heros[1] = 1782
	cmd2.heros[2] = 1783
	cmd2.heros[3] = 1784

	cmd2.star = {}
	cmd2.star[1] = {}
	cmd2.star[1].tid = 1
	cmd2.star[1].flag = 1
	
	cmd2.star[2] = {}
	cmd2.star[2].tid = 1
	cmd2.star[2].flag = 1
	
	cmd2.star[3] = {}
	cmd2.star[3].tid = 1
	cmd2.star[3].flag = 1
	API_SendGameProtocol(SerializeCommand(cmd2))
	Sleep(2)

	cmd2 = NewCommand("GetLastHero")

	API_SendGameProtocol(SerializeCommand(cmd2))
end

function SetSystemTime()
	Init()
	Login()

	local cmd2 = NewCommand("DebugCommand")
	cmd2.typ = "ChangeTime"
	cmd2.count1 = 1
	cmd2.count2 = 20
	API_SendGameProtocol(SerializeCommand(cmd2))
end

function SetUserDefine()
	Init()
	Login()

	local cmd2 = NewCommand("Client_User_Define")
	cmd2.user_key = 1
	cmd2.user_value = "20"
	API_SendGameProtocol(SerializeCommand(cmd2))

end

function BuyHero()
	Init()
	Login()
	Sleep(2)
	
	local cmd2 = NewCommand("DebugCommand")
	cmd2.typ = "AddYuanBao"
	cmd2.count1 = 100000
	API_SendGameProtocol(SerializeCommand(cmd2))
	Sleep(2)

	local cmd2 = NewCommand("BuyHero")
	cmd2.tid = 1782
	cmd2.typ = 2
	API_SendGameProtocol(SerializeCommand(cmd2))
	Sleep(2)

	cmd2.tid = 1783
	cmd2.typ = 2
	API_SendGameProtocol(SerializeCommand(cmd2))
	Sleep(2)

	cmd2.tid = 1784
	cmd2.typ = 2
	API_SendGameProtocol(SerializeCommand(cmd2))
	Sleep(2)

	--��ȷ��1001��
	cmd2 = NewCommand("EnterInstance")
	cmd2.inst_tid = 1001
	API_SendGameProtocol(SerializeCommand(cmd2))
	Sleep(2)

	cmd2 = NewCommand("CompleteInstance")
	cmd2.inst_tid = 1001
	cmd2.flag = 1
	cmd2.heros = {}
	cmd2.heros[1] = 1782
	cmd2.heros[2] = 1783
	cmd2.heros[3] = 1784

	cmd2.star = {}
	cmd2.star[1] = {}
	cmd2.star[1].tid = 1
	cmd2.star[1].flag = 1
	
	cmd2.star[2] = {}
	cmd2.star[2].tid = 1
	cmd2.star[2].flag = 1
	
	cmd2.star[3] = {}
	cmd2.star[3].tid = 1
	cmd2.star[3].flag = 1
	API_SendGameProtocol(SerializeCommand(cmd2))

	Sleep(10)

	--��ȷ��1002��
	cmd2 = NewCommand("EnterInstance")
	cmd2.inst_tid = 1002
	API_SendGameProtocol(SerializeCommand(cmd2))
	Sleep(2)

	cmd2 = NewCommand("CompleteInstance")
	cmd2.inst_tid = 1002
	cmd2.flag = 1
	cmd2.heros = {}
	cmd2.heros[1] = 1782
	cmd2.heros[2] = 1783
	cmd2.heros[3] = 1784

	cmd2.star = {}
	cmd2.star[1] = {}
	cmd2.star[1].tid = 1
	cmd2.star[1].flag = 1
	
	cmd2.star[2] = {}
	cmd2.star[2].tid = 1
	cmd2.star[2].flag = 1
	
	cmd2.star[3] = {}
	cmd2.star[3].tid = 1
	cmd2.star[3].flag = 1
	API_SendGameProtocol(SerializeCommand(cmd2))
	
	Sleep(10)

	--��ȷ��1003��
	cmd2 = NewCommand("EnterInstance")
	cmd2.inst_tid = 1003
	API_SendGameProtocol(SerializeCommand(cmd2))
	Sleep(2)

	cmd2 = NewCommand("CompleteInstance")
	cmd2.inst_tid = 1003
	cmd2.flag = 1
	cmd2.heros = {}
	cmd2.heros[1] = 1782
	cmd2.heros[2] = 1783
	cmd2.heros[3] = 1784

	--cmd2.req_heros = {}
	--cmd2.req_heros[1] = 3905

	cmd2.star = {}
	cmd2.star[1] = {}
	cmd2.star[1].tid = 1
	cmd2.star[1].flag = 1
	
	cmd2.star[2] = {}
	cmd2.star[2].tid = 1
	cmd2.star[2].flag = 1
	
	cmd2.star[3] = {}
	cmd2.star[3].tid = 1
	cmd2.star[3].flag = 1
	API_SendGameProtocol(SerializeCommand(cmd2))
end

function BuyHorse()
	Init()
	Login()
	Sleep(2)
	
	local cmd2 = NewCommand("DebugCommand")
	cmd2.typ = "AddYuanBao"
	cmd2.count1 = 100000
	API_SendGameProtocol(SerializeCommand(cmd2))
	Sleep(2)

	local cmd2 = NewCommand("BuyHorse")
	cmd2.tid = 1782
	cmd2.typ = 2
	API_SendGameProtocol(SerializeCommand(cmd2))
	Sleep(2)

end

function PvpJoin()
	Init()
	Login()
	Sleep(2)
	
	local cmd2 = NewCommand("PvpJoin")
	cmd2.typ = 1
	cmd2.heroinfo = {}
	cmd2.heroinfo[1] = 2
	cmd2.heroinfo[2] = 5
	cmd2.heroinfo[3] = 17
	API_SendGameProtocol(SerializeCommand(cmd2))
	Sleep(2)

end

function TestLottery()
	Init()
	Login()
	Sleep(2)
	local cmd2 = NewCommand("GetRefreshTime")
	cmd2.typ = 8575
	API_SendGameProtocol(SerializeCommand(cmd2))
	
	local cmd2 = NewCommand("GetRefreshTime")
	cmd2.typ = 8576
	API_SendGameProtocol(SerializeCommand(cmd2))

	local cmd2 = NewCommand("Lottery")
	cmd2.lottery_id = 8575 
	cmd2.cost_type = 2
	API_SendGameProtocol(SerializeCommand(cmd2)) 

end