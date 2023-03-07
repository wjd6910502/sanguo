function OnCommand_DebugCommand(player, role, arg, others)
	player:Log("OnCommand_DebugCommand, "..DumpTable(arg))
if G_CONF_DEBUG_COMMAND_ENABLE==true then
local ed = DataPool_Find("elementdata")
local quanju = ed.gamedefine[1]
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
			msg.level = role._roledata._status._level
			player:SendMessage(f._brief._id, SerializeMessage(msg))
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

		if role._roledata._pve_arena_info._score == 0 and role._roledata._status._level >= quanju.arena_open_lv then
			role._roledata._pve_arena_info._score = quanju.arena_initial_score
			TASK_ChangeCondition(role, G_ACH_TYPE["YONGJIU"], G_ACH_TWENTY_TYPE["JJCSCORE"], role._roledata._pve_arena_info._score)
		end

	elseif string.lower(arg.typ)=="testmessage4" then
		local msg = NewMessage("TestMessage4")
		player:SendMessage(role._roledata._base._id, SerializeMessage(msg))
	elseif string.lower(arg.typ)=="addvp" then
		ROLE_Addvp(role, arg.count1, 1)
	elseif string.lower(arg.typ)=="addyuanbao" then
		ROLE_AddYuanBao(role, arg.count1*10, 0)
		ROLE_AddChongZhi(role, arg.count1*10)
	elseif string.lower(arg.typ)=="gettime" then
		--send PublicChat
		local resp = NewCommand("PublicChat")
		resp.src = ROLE_MakeRoleBrief(role)
		resp.text_content = API_GetTimeStr()
		resp.time = API_GetTime()
		resp.channel = 2
		player:SendToClient(SerializeCommand(resp))
	elseif string.lower(arg.typ)=="settime" then
		API_SetTimeOffset(arg.count1, arg.count2)
		--send PublicChat
		local resp = NewCommand("PublicChat")
		resp.src = ROLE_MakeRoleBrief(role)
		resp.text_content = API_GetTimeStr()
		resp.time = API_GetTime()
		resp.channel = 2
		player:SendToClient(SerializeCommand(resp))
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
			local value = CACHE.RoleInstance()
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
		BACKPACK_AddItem(role, arg.count1, arg.count2, 0)
	elseif string.lower(arg.typ)=="oneclickadditem" then
		local allitems = {4718,4720,11289}
		for i =1,table.getn(allitems) do
			local item_id = allitems[i]
			local item_count = 9999
			BACKPACK_AddItem(role, item_id, item_count, 0)
		end
		
		for i = 4807,4822 do
			local item_id = i
			local item_count = 9999
			BACKPACK_AddItem(role, item_id, item_count, 0)	
		end


		for i = 4854,4868 do
			local item_id = i
			local item_count = 9999
			BACKPACK_AddItem(role, item_id, item_count, 0)	
		end

		for i = 7224,7276 do
			local item_id = i
			local item_count = 99992
			BACKPACK_AddItem(role, item_id, item_count, 0)
		end

	elseif string.lower(arg.typ)=="ctime" then
		player:SendMessageToAllRole(SerializeMessage(NewMessage("ClientTimeRequest")))

	elseif arg.typ=="1" or string.lower(arg.typ)=="initrole1" then
		local ed = DataPool_Find("elementdata")
		
		local stage_one={1001, 1002, 1003, 1004, 1005, 1006, 1007, 1008, 1009, 1010, 1011, 1012, 1013, 1014, 1015}
		local stage_two={2001, 2002, 2003, 2004, 2005, 2006, 2007, 2008, 2009, 2010, 2011, 2012, 2013, 2014, 2015}
		local stage_three={3001, 3002, 3003, 3004, 3005, 3006, 3007, 3008, 3009, 3010, 3011, 3012, 3013, 3014, 3015}

		role._roledata._status._money = 1000000
		role._roledata._status._level = 20
		TASK_ChangeCondition(role, G_ACH_TYPE["LEVEL_FINISH"], 0, role._roledata._status._level)
		if role._roledata._pve_arena_info._score == 0 and role._roledata._status._level >= quanju.arena_open_lv then
			role._roledata._pve_arena_info._score = quanju.arena_initial_score
			TASK_ChangeCondition(role, G_ACH_TYPE["YONGJIU"], G_ACH_TWENTY_TYPE["JJCSCORE"], role._roledata._pve_arena_info._score)
		end

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
				local value = CACHE.RoleInstance()
				value._tid = stage_id
				value._score = 1
				value._star = 3
				instance:Insert(stage_id, value)
				if stage.isifstage == 0 then
					TASK_ChangeCondition(role, G_ACH_TYPE["STAGE_STAR"], stage.chapterid, 3)
				end
			else
				if stage.isifstage == 0 then
					TASK_ChangeCondition(role, G_ACH_TYPE["STAGE_STAR"], stage.chapterid, 3 - i._star)
				end
				i._star = 3
			end
			--修改成就
			if stage.isifstage == 0 then
				TASK_ChangeCondition(role, G_ACH_TYPE["STAGE_FINISH"], stage_id, 1)
				TASK_ChangeCondition(role, G_ACH_TYPE["STAGE_COUNT"], G_ACH_EIGHT_TYPE["STAGE"] , 1)
			elseif stage.isifstage == 1 then
				TASK_ChangeCondition(role, G_ACH_TYPE["STAGE_JINGYING_FINISH"], stage_id, 1)
				TASK_ChangeCondition(role, G_ACH_TYPE["STAGE_JINGYING_COUNT"], 0 ,1)
			elseif stage.isifstage == 2 then
				TASK_ChangeCondition(role, G_ACH_TYPE["STAGE_FINISH"], stage_id, 1)
				TASK_ChangeCondition(role, G_ACH_TYPE["STAGE_COUNT"], G_ACH_EIGHT_TYPE["YANWUCHANG"] , 1)
			end
			TASK_RefreshTask(role)
		end

		--local hero_id = {2,3,5,6}
		--for i = 1,table.getn(hero_id) do
		--	local hero = ed:FindBy("hero_id", hero_id[i])
		--	local tmp_hero = CACHE.RoleHero()
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
		if role._roledata._pve_arena_info._score == 0 and role._roledata._status._level >= quanju.arena_open_lv then
			role._roledata._pve_arena_info._score = quanju.arena_initial_score
			TASK_ChangeCondition(role, G_ACH_TYPE["YONGJIU"], G_ACH_TWENTY_TYPE["JJCSCORE"], role._roledata._pve_arena_info._score)
		end
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
				local value = CACHE.RoleInstance()
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
				local value = CACHE.RoleInstance()
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
		--	local tmp_hero = CACHE.RoleHero()
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
		if role._roledata._pve_arena_info._score == 0 and role._roledata._status._level >= quanju.arena_open_lv then
			role._roledata._pve_arena_info._score = quanju.arena_initial_score	
			TASK_ChangeCondition(role, G_ACH_TYPE["YONGJIU"], G_ACH_TWENTY_TYPE["JJCSCORE"], role._roledata._pve_arena_info._score)
		end
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
				local value = CACHE.RoleInstance()
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
				local value = CACHE.RoleInstance()
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
				local value = CACHE.RoleInstance()
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
		--	local tmp_hero = CACHE.RoleHero()
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
		if role._roledata._pve_arena_info._score == 0 and role._roledata._status._level >= quanju.arena_open_lv then
			role._roledata._pve_arena_info._score = quanju.arena_initial_score
			TASK_ChangeCondition(role, G_ACH_TYPE["YONGJIU"], G_ACH_TWENTY_TYPE["JJCSCORE"], role._roledata._pve_arena_info._score)
		end
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
--		local tmp_finish = CACHE.Finish_Task()
--		tmp_finish._task_id = arg.count1
--		tmp_finish._finish_time = API_GetTime()
--		finish_task:Insert(arg.count1, tmp_finish)
	elseif arg.typ=="7" or string.lower(arg.typ)=="refreshtask" then
		TASK_RefreshDailyTask(role,1)
	elseif arg.typ=="8" or string.lower(arg.typ)=="setpvpgrade" then
		role._roledata._pvp_info._pvp_grade = arg.count1
		role._roledata._pvp_info._cur_star = arg.count2
		if arg.count1 == 0 then
			TASK_ChangeCondition(role, G_ACH_TYPE["YONGJIU"], G_ACH_TWENTY_TYPE["3V3CHUANSHUOSCORE"], 1000)		
		end
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
		if role._roledata._pve_arena_info._score == 0 and role._roledata._status._level >= quanju.arena_open_lv then
			role._roledata._pve_arena_info._score = quanju.arena_initial_score
			TASK_ChangeCondition(role, G_ACH_TYPE["YONGJIU"], G_ACH_TWENTY_TYPE["JJCSCORE"], role._roledata._pve_arena_info._score)
		end
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
				local value = CACHE.RoleInstance()
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
				local value = CACHE.RoleInstance()
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
				local value = CACHE.RoleInstance()
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
				local value = CACHE.RoleInstance()
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
		--	local tmp_hero = CACHE.RoleHero()
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
		stage_chapter[1] = {1001, 1002, 1003, 1004, 1005, 1006, 1007, 1008, 1009, 1010, 1011, 1012, 1013}
		stage_chapter[2] = {2001, 2002, 2003, 2004, 2005, 2006, 2007, 2008, 2009, 2010, 2011, 2012, 2013}
		stage_chapter[3] = {3001, 3002, 3003, 3004, 3005, 3006, 3007, 3008, 3009, 3010, 3011, 3012, 3013}
		stage_chapter[4] = {4001, 4002, 4003, 4004, 4005, 4006, 4007, 4008, 4009, 4010, 4011, 4012, 4013}
		stage_chapter[5] = {5001, 5002, 5003, 5004, 5005, 5006, 5007, 5008, 5009, 5010, 5011, 5012, 5013}
		stage_chapter[6] = {6001, 6002, 6003, 6004, 6005, 6006, 6007, 6008, 6009, 6010, 6011, 6012, 6013}
		stage_chapter[7] = {7001, 7002, 7003, 7004, 7005, 7006, 7007, 7008, 7009, 7010, 7011, 7012, 7013}
		stage_chapter[8] = {8001, 8002, 8003, 8004, 8005, 8006, 8007, 8008, 8009, 8010, 8011, 8012, 8013}
		stage_chapter[9] = {9001, 9002, 9003, 9004, 9005, 9006, 9007, 9008, 9009, 9010, 9011, 9012, 9013}
		stage_chapter[10] = {10001, 10002, 10003, 10004, 10005, 10006, 10007, 10008, 10009, 10010, 10011, 10012, 10013}
		stage_chapter[11] = {11001, 11002, 11003, 11004, 11005, 11006, 11007, 11008, 11009, 11010, 11011, 11012, 11013}
		stage_chapter[12] = {12001, 12002, 12003, 12004, 12005, 12006, 12007, 12008, 12009, 12010, 12011, 12012, 12013}
		stage_chapter[13] = {13001, 13002, 13003, 13004, 13005, 13006, 13007, 13008, 13009, 13010, 13011, 13012, 13013}
		stage_chapter[14] = {14001, 14002, 14003, 14004, 14005, 14006, 14007, 14008, 14009, 14010, 14011, 14012, 14013}
		stage_chapter[15] = {15001, 15002, 15003, 15004, 15005, 15006, 15007, 15008, 15009, 15010, 15011, 15012, 15013}
		stage_chapter[16] = {16001, 16002, 16003, 16004, 16005, 16006, 16007, 16008, 16009, 16010, 16011, 16012, 16013}
		stage_chapter[17] = {17001, 17002, 17003, 17004, 17005, 17006, 17007, 17008, 17009, 17010, 17011, 17012, 17013}
		stage_chapter[18] = {18001, 18002, 18003, 18004, 18005, 18006, 18007, 18008, 18009, 18010, 18011, 18012, 18013}
		stage_chapter[19] = {19001, 19002, 19003, 19004, 19005, 19006, 19007, 19008, 19009, 19010, 19011, 19012, 19013}
		stage_chapter[20] = {20001, 20002, 20003, 20004, 20005, 20006, 20007, 20008, 20009, 20010, 20011, 20012, 20013}
		stage_chapter[21] = {21001, 21002, 21003, 21004, 21005, 21006, 21007, 21008, 21009, 21010, 21011, 21012, 21013}
		stage_chapter[22] = {22001, 22002, 22003, 22004, 22005, 22006, 22007, 22008, 22009, 22010, 22011, 22012, 22013}

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
					local value = CACHE.RoleInstance()
					value._tid = stage_id
					value._score = 1
					value._star = 3
					instance:Insert(stage_id, value)
					if stage.isifstage == 0 then
						TASK_ChangeCondition(role, G_ACH_TYPE["STAGE_STAR"], stage.chapterid, 3)
					end
				else
					if stage.isifstage == 0 then
						TASK_ChangeCondition(role, G_ACH_TYPE["STAGE_STAR"], stage.chapterid, 3 - i._star)
					end
					i._star = 3
				end
			end
		end
		TASK_RefreshTask(role)
		--local hero_id = {2,3,5,6}
		--for i = 1,table.getn(hero_id) do
		--	local hero = ed:FindBy("hero_id", hero_id[i])
		--	local tmp_hero = CACHE.RoleHero()
		--	tmp_hero._tid = hero_id[i]
		--	tmp_hero._level = 1
		--	tmp_hero._order = hero.originalgrade
		--	tmp_hero._exp = 0
		--	role._roledata._hero_hall._heros:Insert(hero_id[i], tmp_hero)
		--end
		if role._roledata._pve_arena_info._score == 0 and role._roledata._status._level >= quanju.arena_open_lv then
			role._roledata._pve_arena_info._score = quanju.arena_initial_score
			TASK_ChangeCondition(role, G_ACH_TYPE["YONGJIU"], G_ACH_TWENTY_TYPE["JJCSCORE"], role._roledata._pve_arena_info._score)
		end
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
		ROLE_AddYuanBao(role, arg.count1, 0)
		ROLE_AddChongZhi(role, arg.count1)
	elseif arg.typ=="17" then
		ROLE_AddYuanBao(role, arg.count1, 0)
	elseif arg.typ=="18" then
		local msg = NewMessage("PvpSeasonFinish")
		API_SendMsg("0", SerializeMessage(msg), 0)
	elseif arg.typ=="19" then
		ROLE_AddMoney(role, arg.count1, 0)
	elseif arg.typ=="20" then
		ROLE_AddRep(role, arg.count1, arg.count2, 0)
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
		--	local value = CACHE.Int()
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
	elseif arg.typ=="33" then
		--扔一个消息去排行榜中删除数据去
		local msg = NewMessage("TestDeleteTop")
		msg.id = arg.count1
		API_SendMsg(role._roledata._base._id:ToStr(), SerializeMessage(msg), 0)
	elseif arg.typ=="34" then
		--扔一个消息去排行榜中删除数据去
		local zhanli = HERO_CalZhanli(role, arg.count1)
		API_Log("1111111111111111111111111111111111111   zhanli="..zhanli)
	elseif arg.typ=="35" then
		--更新一下玩家的数据去进行处理
		local msg = NewMessage("UpdateRoleMaShuScoreAllRoleTop")
		API_SendMsg(role._roledata._base._id:ToStr(), SerializeMessage(msg), 0)
	elseif arg.typ=="36" then
		--打印玩家所有武将的战力
		local hero_info_it = role._roledata._hero_hall._heros:SeekToBegin()
		local hero_info = hero_info_it:GetValue()
		while hero_info ~= nil do
			API_Log("heroid="..hero_info._tid.."    zhanli="..hero_info._zhanli)
			
			hero_info_it:Next()
			hero_info = hero_info_it:GetValue()
		end
	elseif arg.typ=="37" then
		--更新一下玩家的数据去进行处理
		local msg = NewMessage("TestSendMailToMafia")
		API_SendMsg(role._roledata._base._id:ToStr(), SerializeMessage(msg), 0)
	elseif arg.typ=="38" then
		--帮会升级测试
		local msg = NewMessage("TestMafiaLevelUp")
		local mafia_list = CACHE.Int64List()
		if role._roledata._mafia._id:ToStr() ~= "0" then
			local mafia_list = CACHE.Int64List()
			mafia_list:PushBack(role._roledata._mafia._id)
			API_SendMessage(role._roledata._base._id, SerializeMessage(msg), CACHE.Int64List(), mafia_list, CACHE.IntList())
		end
	elseif arg.typ=="39" then
		--创建约战
		local msg = NewMessage("TestYueZhanCreate")
		API_SendMsg(role._roledata._base._id:ToStr(), SerializeMessage(msg), 0)
	elseif arg.typ=="40" then
		--加入约战
		local msg = NewMessage("TestYueZhanJoin")
		msg.room_id = arg.count1
		API_SendMsg(role._roledata._base._id:ToStr(), SerializeMessage(msg), 0)
	elseif arg.typ=="41" then
		--加入约战
		local msg = NewMessage("CloseServer")
		msg.reason = 1
		player:SendMessage(role._roledata._base._id, SerializeMessage(msg))
	elseif arg.typ=="42" then
		--充值消息
		local msg = NewMessage("ChongZhi")
		msg.money = arg.count1
		player:SendMessage(role._roledata._base._id, SerializeMessage(msg))
		--local cmd = NewCommand("ErrorInfo")
		--cmd.error_id = G_ERRCODE["CHONGZHI_DISABLE"]
		--player:SendToClient(SerializeCommand(cmd))
	elseif arg.typ=="43" then
		local ed = DataPool_Find("elementdata")
		local stage_id = arg.count1
		local stage = ed:FindBy("stage_id", stage_id)
		if stage == nil then
			return
		end
		local instance = role._roledata._status._instances
		local i = instance:Find(stage_id)
		local first_flag = 0
		if i == nil then
			local value = CACHE.RoleInstance()
			value._tid = stage_id
			value._score = 1
			value._star = 3
			instance:Insert(stage_id, value)
			TASK_ChangeCondition(role, G_ACH_TYPE["STAGE_STAR"], stage.chapterid, 3)
		else
			TASK_ChangeCondition(role, G_ACH_TYPE["STAGE_STAR"], stage.chapterid, 3 - i._star)
			i._star = 3
		end
		player:KickoutSelf(1)
	elseif arg.typ=="100" then
		local heros = role._roledata._hero_hall._heros
		local hero = heros:Find(arg.count1)
		if hero == nil then
			return
		end

		--判断界别是否达到了最高  这个最大值 可否写在表里读出来
		local hero_order = hero._order
		if hero_order >= 14 or (hero._order + arg.count2) > 14 then
			return
		end

		hero._order = hero._order + arg.count2
		
		local ed = DataPool_Find("elementdata")
		local herograde = ed:FindBy("herograde_id", arg.count1)
		local learn_skill = 0
		for grade in DataPool_Array(herograde.grade) do
			if grade.grade > hero_order and grade.grade <= hero._order then
				if grade.unlockspeciality ~= 0 then
					local speciality_info = ed:FindBy("speciality_id", grade.unlockspeciality)
					learn_skill = speciality_info.tejiid*1000+speciality_info.tejilv
					
					local insert_value = CACHE.Int()
					insert_value._value = learn_skill
					hero._beidong_skill:PushBack(insert_value)
				end
			end
		end
		HERO_UpdateHeroSkill(role, arg.count1)
	elseif arg.typ=="101" then
		local hero = role._roledata._hero_hall._heros:Find(arg.count1)
		if hero == nil then
			return
		end

		local ed = DataPool_Find("elementdata")
		local hero_info = ed:FindBy("hero_id", arg.count1)
		if hero_info == nil then
			return
		end

		if hero._star >= hero_info.maxstar or (hero._star+arg.count2) > hero_info.maxstar then
			return
		end

		local star_info = ed:FindBy("hero_star", arg.count1)
		if star_info == nil then
			return
		end
		
		hero._star = hero._star + arg.count2
	elseif arg.typ=="102" then
		local ed = DataPool_Find("elementdata")
		local item = ed:FindBy("item_id", arg.count2)
		if item == nil then
			return
		end
		
		local hero_info = role._roledata._hero_hall._heros:Find(arg.count1)
		if hero_info == nil then
			return
		end
	
		if item.item_type == 7 then
			BACKPACK_AddWeapon(role, arg.count2, item.type_data1, true)
			local weapon_items = role._roledata._backpack._weapon_items

			local weapon_item_it = weapon_items._weapon_items:SeekToBegin()
			local weapon_item = weapon_item_it:GetValue()
			while weapon_item ~= nil do
				if weapon_item._weapon_pro._tid == role._roledata._backpack._weapon_items._id then
					hero_info._weapon_id = role._roledata._backpack._weapon_items._id
					return
				end
				weapon_item_it:Next()
				weapon_item = weapon_item_it:GetValue()
			end
		elseif item.item_type == 23 then
			BACKPACK_AddEquipment(role, arg.count2, item.type_data1)
			local find_equipment = role._roledata._backpack._equipment_items._equipment_items:Find(role._roledata._backpack._equipment_items._id)
			local equipment_info = ed:FindBy("equip_id", item.type_data1)
			local pos_info = hero_info._equipment:Find(equipment_info.equip_type)
			if pos_info == nil then
				--这个武将还没有装备这个格子的装备
				local insert_pos_info = CACHE.EquipmentPosInfo()
				insert_pos_info._pos = equipment_info.equip_type
				insert_pos_info._id = role._roledata._backpack._equipment_items._id
				hero_info._equipment:Insert(equipment_info.equip_type, insert_pos_info)
				find_equipment._equipment_pro._wear_flag = 1
			else
				--进行这个格子装备的替换,如果当前装备的装备就是这个，直接赋值就可以了，没有必要返回一个错误码了
				--这个装备替换的时候查看是直接销毁还是卸下
				local tmp_find_equipment = role._roledata._backpack._equipment_items._equipment_items:Find(pos_info._id)
				tmp_find_equipment._equipment_pro._wear_flag = 0
				pos_info._id = role._roledata._backpack._equipment_items._id
				find_equipment._equipment_pro._wear_flag = 1
			end

			if find_equipment._equipment_pro._hero_id == 0 then
				find_equipment._equipment_pro._hero_id = arg.count1
			end
		end
	elseif arg.typ=="103" then
		local hero_info = role._roledata._hero_hall._heros:Find(arg.count1)

		if hero_info == nil then
			return
		end

		--找到需要升级的武器
		local weapon_items = role._roledata._backpack._weapon_items

		local weapon_item_it = weapon_items._weapon_items:SeekToBegin()
		local weapon_item = weapon_item_it:GetValue()
		while weapon_item ~= nil do
			if weapon_item._weapon_pro._tid == hero_info._weapon_id then
			
				if weapon_item._weapon_pro._level_up >= role._roledata._status._level*2 or 
				(weapon_item._weapon_pro._level_up + arg.count2) > role._roledata._status._level*2 then
					return
				end
				
				weapon_item._weapon_pro._level_up = weapon_item._weapon_pro._level_up + arg.count2
				return
			end
			weapon_item_it:Next()
			weapon_item = weapon_item_it:GetValue()
		end
	elseif arg.typ=="104" then
		local ed = DataPool_Find("elementdata")
		local hero_info = role._roledata._hero_hall._heros:Find(arg.count1)

		if hero_info == nil then
			return
		end

		--找到需要强化的武器
		local weapon_items = role._roledata._backpack._weapon_items

		local weapon_item_it = weapon_items._weapon_items:SeekToBegin()
		local weapon_item = weapon_item_it:GetValue()
		while weapon_item ~= nil do
			if weapon_item._weapon_pro._tid == hero_info._weapon_id then
				
				local quanju = ed.gamedefine[1]
				if weapon_item._weapon_pro._strengthen >= quanju.maxweaponintensify or 
				(weapon_item._weapon_pro._strengthen + arg.count2) > quanju.maxweaponintensify then
					return
				end

				weapon_item._weapon_pro._strengthen = weapon_item._weapon_pro._strengthen + arg.count2
				return
			end
			weapon_item_it:Next()
			weapon_item = weapon_item_it:GetValue()
		end
	elseif arg.typ=="105" then
		local ed = DataPool_Find("elementdata")
		local quanju = ed.gamedefine[1]
	
		local hero_info = role._roledata._hero_hall._heros:Find(arg.count1)

		if hero_info == nil then
			return
		end

		--找到需要升级的武器
		local weapon_items = role._roledata._backpack._weapon_items

		local weapon_item_it = weapon_items._weapon_items:SeekToBegin()
		local weapon_item = weapon_item_it:GetValue()
		while weapon_item ~= nil do
			if weapon_item._weapon_pro._tid == hero_info._weapon_id then
				--在这里优先让等级最低的升级,反正基本后面需要修改
				local skill_info_it = weapon_item._weapon_pro._skill_pro:SeekToBegin()
				local skill_info = skill_info_it:GetValue()
				local select_skill_id = 0
				local select_skill_level = quanju.weaponspecialpropmaxlv
				while skill_info ~= nil do
					if select_skill_level > skill_info._skill_level then
						select_skill_id = skill_info._skill_id
						select_skill_level = skill_info._skill_level
					end
					skill_info_it:Next()
					skill_info = skill_info_it:GetValue()
				end

				if select_skill_level ~= quanju.weaponspecialpropmaxlv then
					--装备印的等级都达到了满级，没有什么可以进行修改的了
					local skill_info = weapon_item._weapon_pro._skill_pro:Find(select_skill_id)
					skill_info._skill_level = skill_info._skill_level + arg.count2
					if skill_info._skill_level > quanju.weaponspecialpropmaxlv then
						skill_info._skill_level = quanju.weaponspecialpropmaxlv
					end
				end
			end
			weapon_item_it:Next()
			weapon_item = weapon_item_it:GetValue()
		end
	elseif arg.typ=="106" then
		TASK_SetTaskFinish(role, arg.count1)
	elseif arg.typ=="107" then
		local hero_info = role._roledata._hero_hall._heros:Find(arg.count1)
		if hero_info == nil then
			return
		end
		
		local pos_info = hero_info._equipment:Find(arg.count2)
		if pos_info == nil then
			return
		else
			local find_equipment = role._roledata._backpack._equipment_items._equipment_items:Find(pos_info._id)
			if find_equipment == nil then
				return
			end

			if find_equipment._equipment_pro._level_up >= role._roledata._status._level*2 or 
			(find_equipment._equipment_pro._level_up + arg.count3) > role._roledata._status._level*2 then
				return
			end

			find_equipment._equipment_pro._level_up = find_equipment._equipment_pro._level_up + arg.count3
		end
	elseif arg.typ=="108" then
		local tmp = {}
		tmp.right_flag = 1
		tmp.num = 1
		OnCommand_DaTiAnswer(player, role, tmp, others)
	elseif arg.typ=="109" then
		role._roledata._tower_data._history_layer = arg.count1
	elseif arg.typ=="110" then
		local cmd = NewCommand("TestFloat")
		cmd.seed = arg.count1
		cmd.count = arg.count2
		player:SendToClient(SerializeCommand(cmd))
	elseif arg.typ=="111" then
		local msg = NewMessage("TestFloat")
		msg.seed = arg.count1
		msg.count = arg.count2
		player:SendMessageToAllRole(SerializeMessage(msg))
	elseif arg.typ=="112" then
		role._roledata._tower_data._timestamp = API_GetTime() + 86400
		role._roledata._tower_data._yestaday_difficulty = arg.count1
		role._roledata._tower_data._yestaday_rank = arg.count2
	elseif arg.typ=="113" then
		local resp = NewCommand("TowerUpdateRoleInfo")
		resp.difficulty = role._roledata._tower_data._difficulty
		player:SendToClient(SerializeCommand(resp))	
	elseif arg.typ=="114" then
		local ed = DataPool_Find("elementdata")
		local quanju = ed.gamedefine[1]
		LIMIT_AddUseLimit(role, quanju.reward_limit_id_send_99flower, arg.count1)
	elseif arg.typ=="115" then
		role._roledata._military_data._stage_id = 0 
		role._roledata._military_data._stage_difficult = 0
		role._roledata._military_data._stage_data:Clear()
		OnCommand_MilitaryGetInfo(player, role, arg, others)
	elseif arg.typ=="116" then	
		role._roledata._military_data._stage_id = arg.count1
		role._roledata._military_data._stage_difficult = 1
		arg.reward_param = 100
		OnCommand_MilitaryEndBattle(player, role, arg, others)
	elseif arg.typ=="117" then
		arg.stage_id = arg.count1	
		OnCommand_MilitarySweep(player, role, arg, others)
	elseif arg.typ=="118" then
		role._roledata._pve_arena_info._score = role._roledata._pve_arena_info._score + arg.count1
		TASK_ChangeCondition(role, G_ACH_TYPE["YONGJIU"], G_ACH_TWENTY_TYPE["JJCSCORE"], arg.count1)
	elseif arg.typ=="119" then
		local ed = DataPool_Find("elementdata")
		local quanju = ed.gamedefine[1]
		local tim = LIMIT_GetUseLimit(role, quanju.arena_free_times)
		LIMIT_AddUseLimit(role, quanju.arena_free_times, 5-tim)	
	elseif arg.typ=="999" then
		local ed = DataPool_Find("elementdata")
		local stage = ed:FindBy("stage_id", 1001)
		ROLE_SetBattleRoleData(role, stage, 1, 1, 1, 1, 6, 0, 0)
	elseif arg.typ=="DUXG" then
		--API_Log("DUXG, ------------------------------ size="..role._roledata._overload_list:Size())
		--role._roledata._overload_list:Clear()
		--error("DUXG")
		--local msg = NewMessage("TestMessage4")
		--player:SendMessage(role._roledata._base._id, SerializeMessage(msg))
		--local msg = NewMessage("TestMessage2")
		--player:SendMessage(CACHE.Int64("1"), SerializeMessage(msg))
		local biglist = {}
		local i=0
		while i<1000000 do
			biglist[#biglist+1] = i
			i = i+1
		end
	elseif string.lower(arg.typ) == "liang" then
		arg.reward_param = 100
		OnCommand_MilitaryEndBattle(player, role, arg, others)
	elseif string.lower(arg.typ) == "refreshdailytask" then
		local now = API_GetTime()
		local now_time = os.date("*t", role._roledata._status._last_heartbeat-24*3600)
		local last_time = os.date("*t", role._roledata._status._last_heartbeat)
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
		diff_time.last_date = last_time.day
		diff_time.cur_date = now_time.day
		TASK_RefreshDailyTask(role, diff_time)
	elseif string.lower(arg.typ) == "refreshdailysign" then
		API_Log("##### debug dailysign refresh #####")
		role._roledata._status._dailly_sign._today_flag = role._roledata._status._dailly_sign._today_flag - 1
		local resp = NewCommand("DailySignUpdate")
		resp.sign_date = role._roledata._status._dailly_sign._sign_date
		resp.today_flag = 0
		player:SendToClient(SerializeCommand(resp))
	elseif string.lower(arg.typ) == "datirefresh" then
		role._roledata._dati_data._cur_num = 0
		role._roledata._dati_data._cur_right_num = 0
		role._roledata._dati_data._today_reward = 0
		role._roledata._dati_data._exp = 0
		role._roledata._dati_data._yuanbao = 0
		
		local resp = NewCommand("DaTiUpdateInfo")
		
		resp.cur_num = role._roledata._dati_data._cur_num
		resp.cur_right_num = role._roledata._dati_data._cur_right_num
		resp.today_reward = role._roledata._dati_data._today_reward
		resp.exp = role._roledata._dati_data._exp
		resp.yuanbao = role._roledata._dati_data._yuanbao
		player:SendToClient(SerializeCommand(resp))
	elseif string.lower(arg.typ) == "say100" then
		local resp = NewCommand("PublicChat")
		resp.src = ROLE_MakeRoleBrief(role)
		resp.text_content = "\230\184\184\230\136\143\230\156\141\229\138\161\229\153\168\230\151\182\233\151\180\232\162\171\228\191\174\230\148\185\228\186\134\239\188\140\228\185\139\229\144\142\230\137\128\230\156\137\230\149\176\230\141\174\229\176\134\228\184\141\228\188\154\229\173\152\231\155\152\239\188\140\232\175\183\230\181\139\232\175\149\229\174\140\229\144\142\229\143\138\230\151\182\233\135\141\229\144\175\230\156\141\229\138\161\229\153\168\239\188\129"
		resp.time = API_GetTime()
		resp.channel = 2
		local s = SerializeCommand(resp)
		for i=1,100 do player:SendToClient(s) end
	elseif string.lower(arg.typ) == "say100r" then
		local resp = NewCommand("PublicChat")
		resp.src = ROLE_MakeRoleBrief(role)
		--resp.text_content = "\230\184\184\230\136\143\230\156\141\229\138\161\229\153\168\230\151\182\233\151\180\232\162\171\228\191\174\230\148\185\228\186\134\239\188\140\228\185\139\229\144\142\230\137\128\230\156\137\230\149\176\230\141\174\229\176\134\228\184\141\228\188\154\229\173\152\231\155\152\239\188\140\232\175\183\230\181\139\232\175\149\229\174\140\229\144\142\229\143\138\230\151\182\233\135\141\229\144\175\230\156\141\229\138\161\229\153\168\239\188\129"
		resp.time = API_GetTime()
		resp.channel = 2
		for i=1,100 do
			resp.text_content = ""
			for j=1,10 do
				resp.text_content = resp.text_content.." "..math.random()
			end
			player:SendToClient(SerializeCommand(resp))
		end
	elseif string.lower(arg.typ) == "getopenservertime" then
		local mist = API_GetLuaMisc()
		local openservertime = mist._miscdata._open_server_time
		local resp = NewCommand("PublicChat")
		resp.src = ROLE_MakeRoleBrief(role)
		local text = "open_server_time: "..os.date("%Y-%m-%d %H:%M:%S", openservertime)
		resp.text_content = text
		resp.time = API_GetTime() 
		resp.channel = 2
		player:SendToClient(SerializeCommand(resp))
	elseif string.lower(arg.typ) == "setopenservertime" then	
		API_SetOpenServerOffset(arg.count1)
		local mist = API_GetLuaMisc()
		mist._miscdata._open_server_time = mist._miscdata._open_server_time + arg.count1*3600*24
		local resp = NewCommand("PublicChat")
		resp.src = ROLE_MakeRoleBrief(role)
		local text = "open_server_time: "..os.date("%Y-%m-%d %H:%M:%S", mist._miscdata._open_server_time)
		resp.text_content = text
		resp.time = API_GetTime() 
		resp.channel = 2
		player:SendToClient(SerializeCommand(resp))

	elseif string.lower(arg.typ) == "zhanlirewardreset" then
		local toplist = API_GetLuaTopList()
		local top = toplist._data._top_data
		local tit = top:SeekToBegin()
		local tmp_toplist = tit:GetValue()
		while tmp_toplist ~= nil do
			if tmp_toplist._top_list_type == 2 then
				tmp_toplist._openserver_reward = 0
			end
			tit:Next()
			tmp_toplist = tit:GetValue()
		end
	elseif string.lower(arg.typ) == "getpvptime" then
		local mist = API_GetLuaMisc()
		local resp = NewCommand("PublicChat")
		resp.src = ROLE_MakeRoleBrief(role)
		local text = "pvp_time: "..os.date("%Y-%m-%d %H:%M:%S", mist._miscdata._pvp_season_end_time)
		resp.text_content = text
		resp.time = API_GetTime() 
		resp.channel = 2
		player:SendToClient(SerializeCommand(resp))
	elseif string.lower(arg.typ) == "pvp" then
		arg = {}
		--typ=1499415783.19;heroinfo={1=24;};__type__=136;
		arg.typ = 0
		arg.heroinfo = {}
		arg.heroinfo[1] = 24
		arg.__type__ = 136
		OnCommand_PvpJoin(player, role, arg, others)
	end

end --G_CONF_DEBUG_COMMAND_ENABLE==true
end
