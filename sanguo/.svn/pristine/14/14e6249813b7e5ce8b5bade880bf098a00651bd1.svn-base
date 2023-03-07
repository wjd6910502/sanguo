
-----------------------------------------------------------
--battle_info，当前战场数据
-----------------------------------------------------------
--battle_id，战役的ID
--cur_position，玩家当前的位置pos
--round_num，当前回合数
--round_state, 1回合事件 2玩家移动 3NPC移动（1和3时会调用函数BattleCeHuaEvent）
--round_flag，回合数限制
--cur_morale，玩家士气
--position_info，table，据点数据，一个战役包含若干组据点数据
--		id，据点的index
--		position，据点的pos
--		flag，据点的类型1我方 2敌方 3敌方BOSS
--		pos_buff，据点的当前buff，0为没有
--		npc_info，table，据点上的npc数据，一个据点上有若干个npc数据
--				id，NPC的index
--				camp，NPC的类型1-我，2-敌，3-友
--				armyid，NPC的模板id
--				alive，NPC是否存活，1存活0挂了
--				army_buff，NPC的士气

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
--以下部分由策划维护
-----------------------------------------------------------
--BattleCeHuaEvent，策划计算返回数据，包括：
--1. eventid
--2. movedata：本轮NPC移动数据（数组）。每个NPC的每次移动为1项数据。每项数据内容包括：
--			npcindex		int		要移动的NPC的index
--			nowpos			int		要移动的NPC的当前pos
--			movepos			int		NPC移动的目标据点pos，只能为临近1格的据点
--			battleresult	int		0 移动方的NPC战斗胜利（移过去，目标据点处驻扎有对立NPC，消灭之并占领该据点）
--									1 移动方的NPC战斗失败（移过去，目标据点处驻扎有对立NPC，自己被消灭）
--									2 无战斗发生（移过去占领据点）
--			battleevent		int		遇敌战斗前触发的事件id，0表示无事件
--			occupyevent		int		占领据点时触发的事件id，0表示无事件
--注意：NPC暂时不能向玩家所处的据点移动！！！
-----------------------------------------------------------
function BattleCeHuaEvent(battle_info)
	local battledata = {}
	battledata.eventid = 0
	battledata.movedata = {}
	local movenum = 0
	
	----！！！测试脚本开始！！！--测试下邳id7344
	--回合1时，回合事件对话“回合1开始，我是张辽逗你玩”
	--回合10时如果回合数限制未解除，回合事件对话“回合10开始，本回合你再不结束就败了哦”
	------地图格式------
	--1 2 3
	--4 5 6
	--    9
	--------------------
	--一开始位置：玩家5		张辽9（敌，id7298）		虎牢关精锐2（敌，id7307，有3组都在位置2）		孙坚4（友，id7310）
	----//玩家接触到孙坚后，孙坚出击，消灭虎牢关精锐//----
	--当玩家挪到位置4且孙坚在4，孙坚从4->1
	--如果孙坚在1，孙坚从1->2并消灭掉全部虎牢关精锐，遇敌前触发事件对话“孙坚和虎牢关精锐哥俩好”，占领后触发事件对话“东部城寨是我的了”
	----//玩家挪到位置2后，张辽会出击，然后在2356和玩家绕圈玩//----
	--当玩家挪到位置2时且张辽在9，张辽出击，从9->6
	--当张辽在6时且玩家在3，张辽从6->5	
	--当张辽在6时且玩家在5，张辽从6->3		
	--当张辽在5时且玩家在2，张辽从5->6	
	--当张辽在5时且玩家在6，张辽从5->2并消灭孙坚，占领后触发事件对话“哈哈，玩家被我绕开了，孙坚完蛋了”	
	--当张辽在2时且玩家在3，张辽从2->5	
	--当张辽在2时且玩家在5，张辽从2->3	
	--当张辽在3时且玩家在5，张辽从3->2并消灭孙坚，占领后触发事件对话“哈哈，玩家被我绕开了，孙坚完蛋了”		
	--当张辽在3时且玩家在2，张辽从3->6
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
	----！！！测试脚本结束！！！--
	
	return battledata
end

--临时测试用函数
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
