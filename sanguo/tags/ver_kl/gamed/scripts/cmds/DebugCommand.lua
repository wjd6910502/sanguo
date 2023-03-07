function OnCommand_DebugCommand(player, role, arg, others)
	player:Log("OnCommand_DebugCommand, "..DumpTable(arg))

	if string.lower(arg.typ)=="levelup" then
		--level up
		role._roledata._status._level = role._roledata._status._level+arg.count1
		local ed = DataPool_Find("elementdata")
		local quanju = ed.gamedefine[1]
		if role._roledata._status._level > quanju.legion_maxlv then
			role._roledata._status._level = quanju.legion_maxlv
		end
		--通知好友
		local friends = role._roledata._friend._friends
		local fit = friends:SeekToBegin()
		local f = fit:GetValue()
		while f~=nil do
			--同步方式
			--local d_player = others:FindPlayer(f._brief._id)
			--if d_player~=nil then 
			--	local d_friends = d_player._role_friend._friends
			--	local d_f = d_friends:Find(player._role_base._id)
			--	if d_f~=nil then
			--		--d_f._brief._id = arg.id 
			--		d_f._brief._name = player._role_base._name
			--		d_f._brief._photo = player._role_base._photo
			--		d_f._brief._level = player._role_status._level
			--	end
			--end
			--消息方式
			local msg = NewMessage("UpdateRoleInfo")
			msg.id = role._roledata._base._id:ToStr()
			msg.name = role._roledata._base._name
			msg.photo = role._roledata._base._photo
			msg.level = role.roledata._status._level
			player:SendMessageToRole(f._brief._id, SerializeMessage(msg))
			fit:Next()
			f = fit:GetValue()
		end
		local resp = NewCommand("Role_Mon_Exp")
		resp.level = role._roledata._status._level
		resp.exp = role._roledata._status._exp:ToStr()
		resp.money = role._roledata._status._money
		resp.yuanbao = role._roledata._status._yuanbao
		resp.vp = role._roledata._status._vp
		player:SendToClient(SerializeCommand(resp))
		TASK_ChangeCondition(role, G_ACH_TYPE["LEVEL_FINISH"], 0, role._roledata._status._level)
	elseif string.lower(arg.typ)=="testmessage4" then
		local msg = NewMessage("TestMessage4")
		player:SendMessage(role._roledata._base._id, SerializeMessage(msg))
	elseif string.lower(arg.typ)=="addvp" then
		ROLE_Addvp(role, 120, 1)
	elseif string.lower(arg.typ)=="addyuanbao" then
		ROLE_AddYuanBao(role, arg.count1*10)
		ROLE_AddChongZhi(role, arg.count1*10)
	elseif string.lower(arg.typ)=="changetime" then
		API_SetSystemTime(arg.count1, arg.count2)
	elseif string.lower(arg.typ)=="addinstance" then
		local ed = DataPool_Find("elementdata")
		local stage = ed:FindBy("stage_id", arg.count1)
		if stage == nil then
			return
		end
		local instance = role._roledata._status._instances
		local i = instance:Find(arg.count1)
		local first_flag = 0
		if i == nil then
			local value = CACHE.RoleInstance:new()
			value._tid = arg.count1
			value._score = 1
			value._star = 3
			instance:Insert(arg.count1, value)
			TASK_ChangeCondition(role, G_ACH_TYPE["STAGE_STAR"], stage.chapterid, 3)
		else
			TASK_ChangeCondition(role, G_ACH_TYPE["STAGE_STAR"], stage.chapterid, 3 - i._star)
			i._star = 3
		end
	
		local resp = NewCommand("GetInstance_Re")
		resp.info = {}

		local instance = role._roledata._status._instances
		local iit = instance:SeekToBegin()
		local i = iit:GetValue()
		while i ~= nil do
			local temp = {}
			temp.id = i._tid
			temp.star = i._star
			resp.info[#resp.info+1] = temp
			iit:Next()
			i = iit:GetValue()
		end
		resp.retcode = G_ERRCODE["SUCCESS"]
		player:SendToClient(SerializeCommand(resp))
	elseif string.lower(arg.typ)=="additem" then
		BACKPACK_AddItem(role, arg.count1, arg.count2)
	elseif string.lower(arg.typ)=="oneclickadditem" then
		local allitems = {4718,4720}
		for i =1,table.getn(allitems) do
			local item_id = allitems[i]
			local item_count = 9999
			BACKPACK_AddItem(role, item_id, item_count)
		end
		
		for i = 4807,4822 do
			local item_id = i
			local item_count = 9999
			BACKPACK_AddItem(role, item_id, item_count)	
		end


		for i = 4854,4868 do
			local item_id = i
			local item_count = 9999
			BACKPACK_AddItem(role, item_id, item_count)	
		end

		for i = 7224,7276 do
			local item_id = i
			local item_count = 9999
			BACKPACK_AddItem(role, item_id, item_count)
		end

	elseif arg.typ=="1" or string.lower(arg.typ)=="initrole1" then
		local ed = DataPool_Find("elementdata")
		
		local stage_one={1001, 1002, 1003, 1004, 1005, 1006, 1007, 1008, 1009, 1010, 1011, 1012, 1013, 1014, 1015}
		local stage_two={2001, 2002, 2003, 2004, 2005, 2006, 2007, 2008, 2009, 2010, 2011, 2012, 2013, 2014, 2015}
		local stage_three={3001, 3002, 3003, 3004, 3005, 3006, 3007, 3008, 3009, 3010, 3011, 3012, 3013, 3014, 3015}
		
		role._roledata._status._money = 1000000
		role._roledata._status._level = 20
		TASK_ChangeCondition(role, G_ACH_TYPE["LEVEL_FINISH"], 0, role._roledata._status._level)
		role._roledata._status._yuanbao = 50000
		for j = 1,table.getn(stage_one) do
			local stage_id = stage_one[j]
			local stage = ed:FindBy("stage_id", stage_id)
			if stage == nil then
				return
			end
			local instance = role._roledata._status._instances
			local i = instance:Find(stage_id)
			local first_flag = 0
			if i == nil then
				local value = CACHE.RoleInstance:new()
				value._tid = stage_id
				value._score = 1
				value._star = 3
				instance:Insert(stage_id, value)
				TASK_ChangeCondition(role, G_ACH_TYPE["STAGE_STAR"], stage.chapterid, 3)
			else
				TASK_ChangeCondition(role, G_ACH_TYPE["STAGE_STAR"], stage.chapterid, 3 - i._star)
				i._star = 3
			end
		end
		--local hero_id = {2,3,5,6}
		--for i = 1,table.getn(hero_id) do
		--	local hero = ed:FindBy("hero_id", hero_id[i])
		--	local tmp_hero = CACHE.RoleHero:new()
		--	tmp_hero._tid = hero_id[i]
		--	tmp_hero._level = 1
		--	tmp_hero._order = hero.originalgrade
		--	tmp_hero._exp = 0
		--	role._roledata._hero_hall._heros:Insert(hero_id[i], tmp_hero)
		--end
		player:KickoutSelf(1)
	elseif arg.typ=="2" or string.lower(arg.typ)=="initrole2" then
		local ed = DataPool_Find("elementdata")
	
		local stage_one={1001, 1002, 1003, 1004, 1005, 1006, 1007, 1008, 1009, 1010, 1011, 1012, 1013, 1014, 1015}
		local stage_two={2001, 2002, 2003, 2004, 2005, 2006, 2007, 2008, 2009, 2010, 2011, 2012, 2013, 2014, 2015}
		local stage_three={3001, 3002, 3003, 3004, 3005, 3006, 3007, 3008, 3009, 3010, 3011, 3012, 3013, 3014, 3015}

		role._roledata._status._money = 1000000
		role._roledata._status._level = 40
		TASK_ChangeCondition(role, G_ACH_TYPE["LEVEL_FINISH"], 0, role._roledata._status._level)
		role._roledata._status._yuanbao = 50000
		
		for j = 1,table.getn(stage_one) do
			local stage_id = stage_one[j]
			local stage = ed:FindBy("stage_id", stage_id)
			if stage == nil then
				return
			end
			local instance = role._roledata._status._instances
			local i = instance:Find(stage_id)
			local first_flag = 0
			if i == nil then
				local value = CACHE.RoleInstance:new()
				value._tid = stage_id
				value._score = 1
				value._star = 3
				instance:Insert(stage_id, value)
				TASK_ChangeCondition(role, G_ACH_TYPE["STAGE_STAR"], stage.chapterid, 3)
			else
				TASK_ChangeCondition(role, G_ACH_TYPE["STAGE_STAR"], stage.chapterid, 3 - i._star)
				i._star = 3
			end
		end
		for j = 1,table.getn(stage_two) do
			local stage_id = stage_two[j]
			local stage = ed:FindBy("stage_id", stage_id)
			if stage == nil then
				return
			end
			local instance = role._roledata._status._instances
			local i = instance:Find(stage_id)
			local first_flag = 0
			if i == nil then
				local value = CACHE.RoleInstance:new()
				value._tid = stage_id
				value._score = 1
				value._star = 3
				instance:Insert(stage_id, value)
				TASK_ChangeCondition(role, G_ACH_TYPE["STAGE_STAR"], stage.chapterid, 3)
			else
				TASK_ChangeCondition(role, G_ACH_TYPE["STAGE_STAR"], stage.chapterid, 3 - i._star)
				i._star = 3
			end
		end
		--local hero_id = {2,3,5,6}
		--for i = 1,table.getn(hero_id) do
		--	local hero = ed:FindBy("hero_id", hero_id[i])
		--	local tmp_hero = CACHE.RoleHero:new()
		--	tmp_hero._tid = hero_id[i]
		--	tmp_hero._level = 1
		--	tmp_hero._order = hero.originalgrade
		--	tmp_hero._exp = 0
		--	role._roledata._hero_hall._heros:Insert(hero_id[i], tmp_hero)
		--end
		player:KickoutSelf(1)
	elseif arg.typ=="3" or string.lower(arg.typ)=="initrole3" then
		local ed = DataPool_Find("elementdata")
		local stage_one={1001, 1002, 1003, 1004, 1005, 1006, 1007, 1008, 1009, 1010, 1011, 1012, 1013, 1014, 1015}
		local stage_two={2001, 2002, 2003, 2004, 2005, 2006, 2007, 2008, 2009, 2010, 2011, 2012, 2013, 2014, 2015}
		local stage_three={3001, 3002, 3003, 3004, 3005, 3006, 3007, 3008, 3009, 3010, 3011, 3012, 3013, 3014, 3015}

		role._roledata._status._money = 1000000
		role._roledata._status._level = 60
		TASK_ChangeCondition(role, G_ACH_TYPE["LEVEL_FINISH"], 0, role._roledata._status._level)
		role._roledata._status._yuanbao = 50000
		
		for j = 1,table.getn(stage_one) do
			local stage_id = stage_one[j]
			local stage = ed:FindBy("stage_id", stage_id)
			if stage == nil then
				return
			end
			local instance = role._roledata._status._instances
			local i = instance:Find(stage_id)
			local first_flag = 0
			if i == nil then
				local value = CACHE.RoleInstance:new()
				value._tid = stage_id
				value._score = 1
				value._star = 3
				instance:Insert(stage_id, value)
				TASK_ChangeCondition(role, G_ACH_TYPE["STAGE_STAR"], stage.chapterid, 3)
			else
				TASK_ChangeCondition(role, G_ACH_TYPE["STAGE_STAR"], stage.chapterid, 3 - i._star)
				i._star = 3
			end
		end
		for j = 1,table.getn(stage_two) do
			local stage_id = stage_two[j]
			local stage = ed:FindBy("stage_id", stage_id)
			if stage == nil then
				return
			end
			local instance = role._roledata._status._instances
			local i = instance:Find(stage_id)
			local first_flag = 0
			if i == nil then
				local value = CACHE.RoleInstance:new()
				value._tid = stage_id
				value._score = 1
				value._star = 3
				instance:Insert(stage_id, value)
				TASK_ChangeCondition(role, G_ACH_TYPE["STAGE_STAR"], stage.chapterid, 3)
			else
				TASK_ChangeCondition(role, G_ACH_TYPE["STAGE_STAR"], stage.chapterid, 3 - i._star)
				i._star = 3
			end
		end
		for j = 1,table.getn(stage_three) do
			local stage_id = stage_three[j]
			local stage = ed:FindBy("stage_id", stage_id)
			if stage == nil then
				return
			end
			local instance = role._roledata._status._instances
			local i = instance:Find(stage_id)
			local first_flag = 0
			if i == nil then
				local value = CACHE.RoleInstance:new()
				value._tid = stage_id
				value._score = 1
				value._star = 3
				instance:Insert(stage_id, value)
				TASK_ChangeCondition(role, G_ACH_TYPE["STAGE_STAR"], stage.chapterid, 3)
			else
				TASK_ChangeCondition(role, G_ACH_TYPE["STAGE_STAR"], stage.chapterid, 3 - i._star)
				i._star = 3
			end
		end
		--local hero_id = {2,3,5,6}
		--for i = 1,table.getn(hero_id) do
		--	local hero = ed:FindBy("hero_id", hero_id[i])
		--	local tmp_hero = CACHE.RoleHero:new()
		--	tmp_hero._tid = hero_id[i]
		--	tmp_hero._level = 1
		--	tmp_hero._order = hero.originalgrade
		--	tmp_hero._exp = 0
		--	role._roledata._hero_hall._heros:Insert(hero_id[i], tmp_hero)
		--end
		player:KickoutSelf(1)
	elseif arg.typ=="4" or string.lower(arg.typ)=="addheroexp" then
		HERO_AddExp(role, arg.count1, arg.count2)
	elseif arg.typ=="5" or string.lower(arg.typ)=="setlevel" then
		--level up
		role._roledata._status._level = arg.count1
		TASK_ChangeCondition(role, G_ACH_TYPE["LEVEL_FINISH"], 0, role._roledata._status._level)
		role._roledata._status._exp:Sub(role._roledata._status._exp)
		local resp = NewCommand("Role_Mon_Exp")
		resp.level = role._roledata._status._level
		resp.exp = role._roledata._status._exp:ToStr()
		resp.money = role._roledata._status._money
		resp.yuanbao = role._roledata._status._yuanbao
		resp.vp = role._roledata._status._vp
		player:SendToClient(SerializeCommand(resp))
	--测试代码。注释掉
--	elseif arg.typ=="6" or arg.typ=="finishtask" then
--		--finishtask
--		local current_task = role._roledata._task._current_task
--		local inv = current_task:Find(arg.count1)
--		if inv ~= nil then
--			current_task:Delete(arg.count1)
--		end
--		local finish_task =role._roledata._task._finish_task
--		local tmp_finish = CACHE.Finish_Task:new()
--		tmp_finish._task_id = arg.count1
--		tmp_finish._finish_time = API_GetTime()
--		finish_task:Insert(arg.count1, tmp_finish)
	elseif arg.typ=="7" or string.lower(arg.typ)=="refreshtask" then
		TASK_RefreshDailyTask(role,1)
	elseif arg.typ=="8" or string.lower(arg.typ)=="setpvpgrade" then
		role._roledata._pvp_info._pvp_grade = arg.count1
		role._roledata._pvp_info._cur_star = arg.count2
	elseif string.lower(arg.typ)=="testtransaction" then
		if arg.count1==0 then
			local map = role._roledata._overload
			local list = map:Find(arg.count2)
			print("map["..arg.count2.."].Size: "..list:Size())
		elseif arg.count1==1 then
			local map = role._roledata._overload
			local list = map:Find(arg.count2)
			print("1 map["..arg.count2.."].Size: "..list:Size())
			local str = CACHE.Str()
			str._value = "NEW NUMBER: 99999"
			list:PushBack(str)
			print("2 map["..arg.count2.."].Size: "..list:Size())
		elseif arg.count1==2 then
			local map = role._roledata._overload
			local list = map:Find(arg.count2)
			print("1 map["..arg.count2.."].Size: "..list:Size())
			local str = CACHE.Str()
			str._value = "NEW NUMBER: 99999"
			list:PushBack(str)
			print("2 map["..arg.count2.."].Size: "..list:Size())
			ThrowException()

			--local list = role._roledata._overload_list
			--print("1 Size: "..list:Size())
			--local str = CACHE.Str()
			--str._value = "NEW NUMBER: 99999"
			--list:PushBack(str)
			--print("2 Size: "..list:Size())
			--ThrowException()

			--local map = role._roledata._overload_map
			--print("1 Size: "..map:Size())
			--local str = CACHE.Str()
			--str._value = "NEW NUMBER: 99999"
			--map:Insert(99999, str)
			--print("2 Size: "..map:Size())
			--ThrowException()
		elseif arg.count1==3 then
			local msg = NewMessage("TestMessage1")
			for i=1,1000 do
				player:SendMessage(role._roledata._base._id, SerializeMessage(msg))
			end
		end
	elseif arg.typ=="9" or string.lower(arg.typ)=="initrole4" then
		local ed = DataPool_Find("elementdata")
		local stage_one={1001, 1002, 1003, 1004, 1005, 1006, 1007, 1008, 1009, 1010, 1011, 1012, 1013, 1014, 1015}
		local stage_two={2001, 2002, 2003, 2004, 2005, 2006, 2007, 2008, 2009, 2010, 2011, 2012, 2013, 2014, 2015}
		local stage_three={3001, 3002, 3003, 3004, 3005, 3006, 3007, 3008, 3009, 3010, 3011, 3012, 3013, 3014, 3015}
		local stage_four={4001, 4002, 4003, 4004, 4005, 4006, 4007, 4008, 4009, 4010, 4011, 4012, 4013, 4014, 4015}

		role._roledata._status._money = 1000000
		role._roledata._status._level = 60
		TASK_ChangeCondition(role, G_ACH_TYPE["LEVEL_FINISH"], 0, role._roledata._status._level)
		role._roledata._status._yuanbao = 50000
		
		for j = 1,table.getn(stage_one) do
			local stage_id = stage_one[j]
			local stage = ed:FindBy("stage_id", stage_id)
			if stage == nil then
				return
			end
			local instance = role._roledata._status._instances
			local i = instance:Find(stage_id)
			local first_flag = 0
			if i == nil then
				local value = CACHE.RoleInstance:new()
				value._tid = stage_id
				value._score = 1
				value._star = 3
				instance:Insert(stage_id, value)
				TASK_ChangeCondition(role, G_ACH_TYPE["STAGE_STAR"], stage.chapterid, 3)
			else
				TASK_ChangeCondition(role, G_ACH_TYPE["STAGE_STAR"], stage.chapterid, 3 - i._star)
				i._star = 3
			end
		end
		for j = 1,table.getn(stage_two) do
			local stage_id = stage_two[j]
			local stage = ed:FindBy("stage_id", stage_id)
			if stage == nil then
				return
			end
			local instance = role._roledata._status._instances
			local i = instance:Find(stage_id)
			local first_flag = 0
			if i == nil then
				local value = CACHE.RoleInstance:new()
				value._tid = stage_id
				value._score = 1
				value._star = 3
				instance:Insert(stage_id, value)
				TASK_ChangeCondition(role, G_ACH_TYPE["STAGE_STAR"], stage.chapterid, 3)
			else
				TASK_ChangeCondition(role, G_ACH_TYPE["STAGE_STAR"], stage.chapterid, 3 - i._star)
				i._star = 3
			end
		end
		for j = 1,table.getn(stage_three) do
			local stage_id = stage_three[j]
			local stage = ed:FindBy("stage_id", stage_id)
			if stage == nil then
				return
			end
			local instance = role._roledata._status._instances
			local i = instance:Find(stage_id)
			local first_flag = 0
			if i == nil then
				local value = CACHE.RoleInstance:new()
				value._tid = stage_id
				value._score = 1
				value._star = 3
				instance:Insert(stage_id, value)
				TASK_ChangeCondition(role, G_ACH_TYPE["STAGE_STAR"], stage.chapterid, 3)
			else
				TASK_ChangeCondition(role, G_ACH_TYPE["STAGE_STAR"], stage.chapterid, 3 - i._star)
				i._star = 3
			end
		end
		for j = 1,table.getn(stage_four) do
			local stage_id = stage_four[j]
			local stage = ed:FindBy("stage_id", stage_id)
			if stage == nil then
				return
			end
			local instance = role._roledata._status._instances
			local i = instance:Find(stage_id)
			local first_flag = 0
			if i == nil then
				local value = CACHE.RoleInstance:new()
				value._tid = stage_id
				value._score = 1
				value._star = 3
				instance:Insert(stage_id, value)
				TASK_ChangeCondition(role, G_ACH_TYPE["STAGE_STAR"], stage.chapterid, 3)
			else
				TASK_ChangeCondition(role, G_ACH_TYPE["STAGE_STAR"], stage.chapterid, 3 - i._star)
				i._star = 3
			end
		end
		--local hero_id = {2,3,5,6}
		--for i = 1,table.getn(hero_id) do
		--	local hero = ed:FindBy("hero_id", hero_id[i])
		--	local tmp_hero = CACHE.RoleHero:new()
		--	tmp_hero._tid = hero_id[i]
		--	tmp_hero._level = 1
		--	tmp_hero._order = hero.originalgrade
		--	tmp_hero._exp = 0
		--	role._roledata._hero_hall._heros:Insert(hero_id[i], tmp_hero)
		--end
		player:KickoutSelf(1)
	elseif arg.typ=="10" or string.lower(arg.typ)=="addskillpoint" then
		role._roledata._status._hero_skill_point = arg.count1
		local resp = NewCommand("UpdateHeroSkillPoint")
		resp.point = role._roledata._status._hero_skill_point
		role:SendToClient(SerializeCommand(resp))
	elseif arg.typ=="11" or string.lower(arg.typ)=="openstage" then
		local ed = DataPool_Find("elementdata")
	
		local stage_chapter = {}
		stage_chapter[1] = {1001, 1002, 1003, 1004, 1005, 1006, 1007, 1008, 1009, 1010, 1011, 1012, 1013, 1014, 1015}
		stage_chapter[2] = {2001, 2002, 2003, 2004, 2005, 2006, 2007, 2008, 2009, 2010, 2011, 2012, 2013, 2014, 2015}
		stage_chapter[3] = {3001, 3002, 3003, 3004, 3005, 3006, 3007, 3008, 3009, 3010, 3011, 3012, 3013, 3014, 3015}
		stage_chapter[4] = {4001, 4002, 4003, 4004, 4005, 4006, 4007, 4008, 4009, 4010, 4011, 4012, 4013, 4014, 4015}
		stage_chapter[5] = {5001, 5002, 5003, 5004, 5005, 5006, 5007, 5008, 5009, 5010, 5011, 5012, 5013, 5014, 5015}
		stage_chapter[6] = {6001, 6002, 6003, 6004, 6005, 6006, 6007, 6008, 6009, 6010, 6011, 6012, 6013, 6014, 6015}
		stage_chapter[7] = {7001, 7002, 7003, 7004, 7005, 7006, 7007, 7008, 7009, 7010, 7011, 7012, 7013, 7014, 7015}
		stage_chapter[8] = {8001, 8002, 8003, 8004, 8005, 8006, 8007, 8008, 8009, 8010, 8011, 8012, 8013, 8014, 8015}
		stage_chapter[9] = {9001, 9002, 9003, 9004, 9005, 9006, 9007, 9008, 9009, 9010, 9011, 9012, 9013, 9014, 9015}
		stage_chapter[10] = {10001, 10002, 10003, 10004, 10005, 10006, 10007, 10008, 10009, 10010, 10011, 10012, 10013, 10014, 10015}

		if arg.count1 > table.getn(stage_chapter) then
			return
		end
		role._roledata._status._money = 1000000
		role._roledata._status._level = 60
		TASK_ChangeCondition(role, G_ACH_TYPE["LEVEL_FINISH"], 0, role._roledata._status._level)
		role._roledata._status._yuanbao = 50000
		for i = 1, arg.count1 do
			local stage_stage = stage_chapter[i]
		
			for j = 1, table.getn(stage_stage) do
				local stage_id = stage_stage[j]
				local stage = ed:FindBy("stage_id", stage_id)
				if stage == nil then
					return
				end
				local instance = role._roledata._status._instances
				local i = instance:Find(stage_id)
				local first_flag = 0
				if i == nil then
					local value = CACHE.RoleInstance:new()
					value._tid = stage_id
					value._score = 1
					value._star = 3
					instance:Insert(stage_id, value)
					TASK_ChangeCondition(role, G_ACH_TYPE["STAGE_STAR"], stage.chapterid, 3)
				else
					TASK_ChangeCondition(role, G_ACH_TYPE["STAGE_STAR"], stage.chapterid, 3 - i._star)
					i._star = 3
				end
			end
		end
		--local hero_id = {2,3,5,6}
		--for i = 1,table.getn(hero_id) do
		--	local hero = ed:FindBy("hero_id", hero_id[i])
		--	local tmp_hero = CACHE.RoleHero:new()
		--	tmp_hero._tid = hero_id[i]
		--	tmp_hero._level = 1
		--	tmp_hero._order = hero.originalgrade
		--	tmp_hero._exp = 0
		--	role._roledata._hero_hall._heros:Insert(hero_id[i], tmp_hero)
		--end
		player:KickoutSelf(1)
	elseif arg.typ=="12" then
		for j = 1, 10000 do
			local s1 = os.clock()
			API_Log("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa  "..s1)
			local item = DROPITEM_DropItem(role, arg.count1)
			local s2 = os.clock()
			API_Log("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa  "..s2)
		end

		--打印出来每一个物品的掉落次数
		for i = 5850, 5870 do
			local count = LIMIT_GetUseLimit(role, i)
			API_Log("1111111111111111111111111111111111111111111111111111    count = "..count)
		end
	elseif arg.typ=="13" then
		role:GetPVPVideo(arg.count1)
	elseif arg.typ=="14" then
		local msg = NewMessage("SendMail")
		msg.mail_id = arg.count1
		msg.arg1 = ""
		API_SendMsg(role._roledata._base._id:ToStr(), SerializeMessage(msg), 0)
	elseif arg.typ=="15" then
		local msg = NewMessage("SendMail")
		msg.mail_id = 1005
		msg.arg1 = "1"
		API_SendMsg(role._roledata._base._id:ToStr(), SerializeMessage(msg), 0)
	elseif arg.typ=="16" then
		ROLE_AddYuanBao(role, arg.count1)
		ROLE_AddChongZhi(role, arg.count1)
	elseif arg.typ=="17" then
		ROLE_AddYuanBao(role, arg.count1)
	elseif arg.typ=="18" then
		local msg = NewMessage("PvpSeasonFinish")
		API_SendMsg("0", SerializeMessage(msg), 0)
	elseif arg.typ=="19" then
		ROLE_AddMoney(role, arg.count1)
	elseif arg.typ=="20" then
		ROLE_AddRep(role, arg.count1, arg.count2)
	elseif arg.typ=="21" then
		local now = API_GetTime()
		local now_time = os.date("*t", now)
		local last_time = os.date("*t", role._roledata._status._last_heartbeat)
		if now_time.wday == 1 then
			now_time.wday = now_time.wday + 7
		end
		if last_time.wday == 1 then
			last_time.wday = last_time.wday + 7
		end
		
		local diff_time = {}
		diff_time.last_year = last_time.year
		diff_time.cur_year = now_time.year
		diff_time.last_month = last_time.month
		diff_time.cur_month = now_time.month
		diff_time.last_week = last_time.wday - 1
		diff_time.cur_week = now_time.wday - 1
		diff_time.last_day = last_time.yday
		diff_time.cur_day = now_time.yday
		diff_time.last_hour = last_time.hour
		diff_time.cur_hour = now_time.hour
		
		LIMIT_RefreshUseLimit(role, diff_time)
		--TASK_RefreshDailyTask(role, diff_time)

		--刷新玩家的个人商店
		--PRIVATE_RefreshAllShop(role)
	elseif arg.typ=="22" then
		HERO_AddHero(role, arg.count1, 1)
	elseif arg.typ=="23" then
		local battle = role._roledata._battle_info:Find(arg.count1)
		if battle == nil then
			return
		end
		battle._state = arg.count2
		local resp = NewCommand("ChangeBattleState")
		resp.battle_id = arg.battle_id
		resp.state = battle._state
		player:SendToClient(SerializeCommand(resp))
	elseif arg.typ=="24" then
		if arg.count1 > 0 then
			role._roledata._status._vp = arg.count1
			local resp = NewCommand("Role_Mon_Exp")
			resp.level = role._roledata._status._level
			resp.exp = role._roledata._status._exp:ToStr()
			resp.money = role._roledata._status._money
			resp.yuanbao = role._roledata._status._yuanbao
			resp.vp = role._roledata._status._vp
			role:SendToClient(SerializeCommand(resp))
		end
	elseif arg.typ=="25" then
		local now = API_GetTime()
		local now_time = os.date("*t", now)
		local last_time = os.date("*t", role._roledata._status._last_heartbeat)
		if now_time.wday == 1 then
			now_time.wday = now_time.wday + 7
		end
		if last_time.wday == 1 then
			last_time.wday = last_time.wday + 7
		end
		
		local diff_time = {}
		diff_time.last_year = last_time.year
		diff_time.cur_year = now_time.year
		diff_time.last_month = last_time.month
		diff_time.cur_month = now_time.month
		diff_time.last_week = last_time.wday - 1
		diff_time.cur_week = now_time.wday - 1
		diff_time.last_day = last_time.yday
		diff_time.cur_day = now_time.yday
		diff_time.last_hour = last_time.hour
		diff_time.cur_hour = now_time.hour
		
		TASK_RefreshDailyTask(role, diff_time)

	elseif arg.typ=="26" then
		--local ed = DataPool_Find("elementdata")
		--local quanju = ed.gamedefine[1]
		--	
		--role._roledata._pve_arena_info._score = quanju.arena_initial_score

		--local hero_it = role._roledata._status._last_hero:SeekToBegin()
		--local hero = hero_it:GetValue()
		--while hero ~= nil do
		--	local value = CACHE.Int:new()
		--	value._value = hero._value
		--	role._roledata._pve_arena_info._defence_hero_info:PushBack(value)
		--	hero_it:Next()
		--	hero = hero_it:GetValue()
		--end

		--local msg = NewMessage("RoleUpdatePveArenaTop")
		--API_SendMsg(role._roledata._base._id:ToStr(), SerializeMessage(msg), 0)
		--
		--local msg = NewMessage("RoleUpdatePveArenaMisc")
		--API_SendMsg(role._roledata._base._id:ToStr(), SerializeMessage(msg), 0)

	elseif arg.typ=="27" then
	--	local msg = NewMessage("ClearPveArenaTop")
	--	API_SendMsg(role._roledata._base._id:ToStr(), SerializeMessage(msg), 0)
	--	
	--	local msg = NewMessage("ClearPveArenaMisc")
	--	API_SendMsg(role._roledata._base._id:ToStr(), SerializeMessage(msg), 0)

	elseif arg.typ=="28" then
		local msg = NewMessage("PrintPveArenaMisc")
		API_SendMsg(role._roledata._base._id:ToStr(), SerializeMessage(msg), 0)

	elseif arg.typ=="29" then
		role_addexp(role, nil)
	elseif arg.typ=="30" then	--发JJC奖励
		local msg = NewMessage("PveArenaSendReward")
		API_SendMsg(0, SerializeMessage(msg), 0)
	elseif arg.typ=="31" then	--给所有的玩家发送一个消息
		local msg = NewMessage("TestMessage4")
		player:SendMessage(role._roledata._base._id, SerializeMessage(msg))
	elseif arg.typ=="32" then
		
		local ed = DataPool_Find("elementdata")
		local boss_infos = ed.shilianboss
		for boss_info in DataPool_Array(boss_infos) do
			API_Log("boss_info       id="..boss_info.id)
		end
		local boss_infos = ed:FindBy("boss_id", 17241)
		if boss_infos == nil then
			API_Log("111111111111111111111111111111111111111111111111111")
		end
	elseif arg.typ=="DUXG" then
		--API_Log("DUXG, ------------------------------ size="..role._roledata._overload_list:Size())
		--role._roledata._overload_list:Clear()
		--error("DUXG")
		--local msg = NewMessage("TestMessage4")
		--player:SendMessage(role._roledata._base._id, SerializeMessage(msg))
		local msg = NewMessage("TestMessage2")
		player:SendMessage(CACHE.Int64("1"), SerializeMessage(msg))
	end
end
