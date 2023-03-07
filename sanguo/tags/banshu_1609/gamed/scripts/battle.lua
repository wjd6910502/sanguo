
-----------------------------------------------------------
--battle_info����ǰս������
-----------------------------------------------------------
--battle_id��ս�۵�ID
--cur_position����ҵ�ǰ��λ��pos
--round_num����ǰ�غ���
--round_state, 1�غ��¼� 2����ƶ� 3NPC�ƶ���1��3ʱ����ú���BattleCeHuaEvent��
--round_flag���غ�������
--cur_morale�����ʿ��
--position_info��table���ݵ����ݣ�һ��ս�۰���������ݵ�����
--		id���ݵ��index
--		position���ݵ��pos
--		flag���ݵ������1�ҷ� 2�з� 3�з�BOSS
--		pos_buff���ݵ�ĵ�ǰbuff��0Ϊû��
--		npc_info��table���ݵ��ϵ�npc���ݣ�һ���ݵ��������ɸ�npc����
--				id��NPC��index
--				camp��NPC������1-�ң�2-�У�3-��
--				armyid��NPC��ģ��id
--				alive��NPC�Ƿ��1���0����
--				army_buff��NPC��ʿ��

--for index = 1, table.getn(battle_info.position_info) do
--	battle_info.position_info[index]
--end
-----------------------------------------------------------
--local battle_info = {}
--battle_info.battle_id = battle._battle_id
--battle_info.cur_position = battle._cur_position
--battle_info.round_num = battle._round_num
--battle_info.round_state = battle._round_state
--battle_info.round_flag = battle._round_flag
--battle_info.cur_morale = battle._cur_morale
--battle_info.position_info = {}
--local position_info_it = battle._position_info:SeekToBegin()
--local position_info = position_info_it:GetValue()
--while position_info ~= nil do
--	local tmp_position_info = {}
--	tmp_position_info.id = position_info._id
--	tmp_position_info.position = position_info._position
--	tmp_position_info.flag = position_info._flag
--	tmp_position_info.pos_buff = position_info._pos_buff
--	tmp_position_info.npc_info = {}
--
--	local npc_info_it = position_info._npc_info:SeekToBegin()
--	local npc_info = npc_info_it:GetValue()
--	while npc_info ~= nil do
--		local tmp_npc_info = {}
--		tmp_npc_info.id = npc_info._id
--		tmp_npc_info.camp = npc_info._camp
--		tmp_npc_info.armyid = npc_info._armyid
--		tmp_npc_info.alive = npc_info._alive
--		tmp_npc_info.army_buff = npc_info._army_buff
--			  
--		tmp_position_info.npc_info[#tmp_position_info.npc_info+1] = tmp_npc_info
--		npc_info_it:Next()
--		npc_info = npc_info_it:GetValue()
--	end
--	battle_info.position_info[#battle_info.position_info+1] = tmp_position_info
--	position_info_it:Next()
--	position_info = position_info_it:GetValue()
--end

-----------------------------------------------------------
--���²����ɲ߻�ά��
-----------------------------------------------------------
--BattleCeHuaEvent���߻����㷵�����ݣ�������
--1. eventid
--2. movedata������NPC�ƶ����ݣ����飩��ÿ��NPC��ÿ���ƶ�Ϊ1�����ݡ�ÿ���������ݰ�����
--			npcindex		int		Ҫ�ƶ���NPC��index
--			nowpos			int		Ҫ�ƶ���NPC�ĵ�ǰpos
--			movepos			int		NPC�ƶ���Ŀ��ݵ�pos��ֻ��Ϊ�ٽ�1��ľݵ�
--			battleresult	int		0 �ƶ�����NPCս��ʤ�����ƹ�ȥ��Ŀ��ݵ㴦פ���ж���NPC������֮��ռ��þݵ㣩
--									1 �ƶ�����NPCս��ʧ�ܣ��ƹ�ȥ��Ŀ��ݵ㴦פ���ж���NPC���Լ�������
--									2 ��ս���������ƹ�ȥռ��ݵ㣩
--			battleevent		int		����ս��ǰ�������¼�id��0��ʾ���¼�
--			occupyevent		int		ռ��ݵ�ʱ�������¼�id��0��ʾ���¼�
--ע�⣺NPC��ʱ��������������ľݵ��ƶ�������
-----------------------------------------------------------
function BattleCeHuaEvent(battle_info)
	local battledata = {}
	battledata.eventid = 0
	battledata.movedata = {}
	local movenum = 0
	
	----���������Խű���ʼ������--��������id7344
	--�غ�1ʱ���غ��¼��Ի����غ�1��ʼ���������ɶ����桱
	--�غ�10ʱ����غ�������δ������غ��¼��Ի����غ�10��ʼ�����غ����ٲ������Ͱ���Ŷ��
	------��ͼ��ʽ------
	--1 2 3
	--4 5 6
	--    9
	--------------------
	--һ��ʼλ�ã����5		����9���У�id7298��		���ιؾ���2���У�id7307����3�鶼��λ��2��		���4���ѣ�id7310��
	----//��ҽӴ��������������������ιؾ���//----
	--�����Ų��λ��4�������4������4->1
	--��������1������1->2�������ȫ�����ιؾ�������ǰ�����¼��Ի������ͻ��ιؾ�������á���ռ��󴥷��¼��Ի���������կ���ҵ��ˡ�
	----//���Ų��λ��2�����ɻ������Ȼ����2356�������Ȧ��//----
	--�����Ų��λ��2ʱ��������9�����ɳ�������9->6
	--��������6ʱ�������3�����ɴ�6->5	
	--��������6ʱ�������5�����ɴ�6->3		
	--��������5ʱ�������2�����ɴ�5->6	
	--��������5ʱ�������6�����ɴ�5->2��������ᣬռ��󴥷��¼��Ի�����������ұ����ƿ��ˣ�����군�ˡ�	
	--��������2ʱ�������3�����ɴ�2->5	
	--��������2ʱ�������5�����ɴ�2->3	
	--��������3ʱ�������5�����ɴ�3->2��������ᣬռ��󴥷��¼��Ի�����������ұ����ƿ��ˣ�����군�ˡ�		
	--��������3ʱ�������2�����ɴ�3->6
	if battle_info.battle_id == 7344 and battle_info.round_state == 1 then
		if battle_info.round_num == 1 then	
			battledata.eventid = 21961
		elseif battle_info.round_num == 10 and battle_info.round_flag > 0 then	
			battledata.eventid = 21962
		end
	end
	if battle_info.battle_id == 7344 and battle_info.round_state == 3 then
		local data_7298 = GetArmyData(battle_info, 7298)
		local data_7310 = GetArmyData(battle_info, 7310)
		if data_7310[3] == 1 then	
			if battle_info.cur_position == 4 and data_7310[2] == 4 then	
				movenum = movenum + 1
				battledata.movedata[movenum] = SortMoveData({data_7310[1],4,1,2,0,0})
			end	
			if data_7310[2] == 1 then		
				movenum = movenum + 1
				battledata.movedata[movenum] = SortMoveData({data_7310[1],1,2,0,21963,21964}) 
			end	
		end
		if data_7298[3] == 1 then
			if battle_info.cur_position == 2 and data_7298[2] == 9 then		
				movenum = movenum + 1
				battledata.movedata[movenum] = SortMoveData({data_7298[1],9,6,2,0,0}) 
			end	
			if battle_info.cur_position == 3 then 
				if data_7298[2] == 6 then		
					movenum = movenum + 1
					battledata.movedata[movenum] = SortMoveData({data_7298[1],6,5,2,0,0}) 
				elseif data_7298[2] == 2 then		
					movenum = movenum + 1
					battledata.movedata[movenum] = SortMoveData( {data_7298[1],2,5,2,0,0}) 				
				end
			end	
			if battle_info.cur_position == 5 then 
				if data_7298[2] == 6 then			
					movenum = movenum + 1
					battledata.movedata[movenum] = SortMoveData({data_7298[1],6,3,2,0,0}) 
				elseif data_7298[2] == 2 then		
					movenum = movenum + 1
					battledata.movedata[movenum] = SortMoveData({data_7298[1],2,3,2,0,0}) 			
				end
			end	
			if battle_info.cur_position == 2 then 
				if data_7298[2] == 5 then				
					movenum = movenum + 1
					battledata.movedata[movenum] = SortMoveData({data_7298[1],5,6,2,0,0}) 
				elseif data_7298[2] == 3 then		
					movenum = movenum + 1
					battledata.movedata[movenum] = SortMoveData({data_7298[1],3,6,2,0,0}) 		
				end
			end			
			if battle_info.cur_position == 6 then 
				if data_7298[2] == 3 then				
					if data_7310[3] == 1 and data_7310[2] == 2 then
						movenum = movenum + 1
						battledata.movedata[movenum] = SortMoveData({data_7298[1],3,2,0,0,21965}) 
					else
						movenum = movenum + 1
						battledata.movedata[movenum] = SortMoveData({data_7298[1],3,2,2,0,0}) 
					end
				elseif data_7298[2] == 5 then		
					if data_7310[3] == 1 and data_7310[2] == 2 then
						movenum = movenum + 1
						battledata.movedata[movenum] = SortMoveData({data_7298[1],5,2,0,0,21965}) 						
					else
						movenum = movenum + 1
						battledata.movedata[movenum] = SortMoveData({data_7298[1],5,2,2,0,0}) 	
					end
				end
			end		
		end 		
	end
	----���������Խű�����������--
	
	return battledata
end

--��ʱ�����ú���
function GetArmyData(battle_info, armyid)
	local armydata = {0,0,0}		--index, pos, alive
	for index = 1, table.getn(battle_info.position_info) do
		if battle_info.position_info[index]["npc_info"] ~= nil then
			for num = 1 , table.getn(battle_info.position_info[index]["npc_info"]) do
				if battle_info.position_info[index]["npc_info"][num]["armyid"] == armyid then
					armydata[1] = battle_info.position_info[index]["npc_info"][num]["id"]
					armydata[2] = battle_info.position_info[index]["position"]
					armydata[3] = battle_info.position_info[index]["npc_info"][num]["alive"]
					break
				end
			end
		end
	end	
	return armydata
end

function SortMoveData(tab)
	local movedata = {}
	movedata.npcindex = tab[1]
	movedata.nowpos = tab[2]
	movedata.movepos = tab[3]
	movedata.battleresult = tab[4]
	movedata.battleevent = tab[5]	
	movedata.occupyevent = tab[6]
	API_Log("111111111111111111111111111   tab[1] ="..tab[1])
	API_Log("111111111111111111111111111   tab[2] ="..tab[2])
	API_Log("111111111111111111111111111   tab[3] ="..tab[3])
	API_Log("111111111111111111111111111   tab[4] ="..tab[4])
	API_Log("111111111111111111111111111   tab[5] ="..tab[5])
	API_Log("111111111111111111111111111   tab[6] ="..tab[6])
	return movedata
end
