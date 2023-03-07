--Alloc/AddNewIndex必须在初始化时做
function DataPool_Alloc(name, path)
	local dp_ptr = API_DataPool_Alloc(name, path)
	if dp_ptr==nil then return nil end
	local dp = {}
	dp.__ptr__ = dp_ptr 
	dp.AddNewIndex = function(dp, index_name, array_name, key_name) API_DataPool_Sort(dp.__ptr__, index_name, array_name, key_name) end
	return dp
end

function DataPool_Find(name)
	local dp_ptr = API_DataPool_Find(name)
	if dp_ptr==nil then return nil end
	local dp = {}
	dp.__ptr__ = dp_ptr
	dp.FindBy = function(dp, index_name, key)
		return API_DataPool_FindBy(dp.__ptr__, index_name, key)
	end
	local mt = {}
	mt.__index = function(dp, key)
		return API_DataPool_LocateVar(dp.__ptr__, key)
	end
	setmetatable(dp, mt)
	return dp
end

DataPool = DataPool_Find

function DataPool_Array(array)
	local idx = 1 
	return function()
		local v = array[idx]
		idx = idx+1
		return v
	end
end

function Cache_Map(map)
	local it = map:SeekToBegin()
	return function()
		local v = it:GetValue()
		if v~=nil then
			it:Next()
		end
		return v
	end
end

function Cache_ReverseMap(map)
	local it = map:SeekToLast()
	return function()
		local v = it:GetValue()
		if v~=nil then
			it:Prev()
		end
		return v
	end
end

function Cache_List(list)
	local it = list:SeekToBegin()
	return function()
		local v = it:GetValue()
		if v~=nil then
			it:Next()
		end
		return v
	end
end

function Cache_ReverseList(list) --TODO:
	return function()
		return nil
	end
end

function InitInMainThread()
	API_DataPool_Clear()
	--Alloc/AddNewIndex必须在初始化时做
	local dp = DataPool_Alloc("elementdata", "./elementdata.dpc")
	if dp~=nil then
		--dp:AddNewIndex("id", "role", "id")
		dp:AddNewIndex("stage_id", "stage", "stageid")
		dp:AddNewIndex("limit_id", "limittimes", "id")
		dp:AddNewIndex("randplan_id", "randplan", "id")
		dp:AddNewIndex("droparray_id", "droparray", "id")
		dp:AddNewIndex("itemgroup_id", "itemgroup", "id")
		dp:AddNewIndex("item_id", "item", "id")
		dp:AddNewIndex("reward_id", "rewards", "id")
		dp:AddNewIndex("level_id", "levelexp", "level")
		dp:AddNewIndex("task_id", "achievement", "id")
		dp:AddNewIndex("quanju_id", "gamedefine", "id")
		dp:AddNewIndex("hero_id", "role", "id")
		dp:AddNewIndex("herograde_id", "rolegrade", "role_id")
		dp:AddNewIndex("requisite_role", "dialogrequisiterole", "stageid")
		dp:AddNewIndex("ranking_id", "pvp3v3ranking", "rank")
		dp:AddNewIndex("vip_level", "vip", "vip_level")
		dp:AddNewIndex("skill_id", "charskill", "charid")
		dp:AddNewIndex("drop_id", "drop", "id")
		dp:AddNewIndex("itemset_id", "itemset", "id")
		dp:AddNewIndex("mail_id", "mail", "mailid")
		dp:AddNewIndex("currency_id", "currency", "currency_id")
		dp:AddNewIndex("mallitem_id", "mallitem", "id")
		dp:AddNewIndex("shop_id", "mysterymall", "id")
		dp:AddNewIndex("storage_id", "mysterymallstorage", "id")
		dp:AddNewIndex("shopitem_id", "shopitem", "id")
		dp:AddNewIndex("battle_id", "battle", "id")
		dp:AddNewIndex("battlefielddata_id", "battlefielddata", "id")
		dp:AddNewIndex("battlearmy_id", "battlearmy", "id")
		dp:AddNewIndex("lottery_id", "lottery", "id")
		dp:AddNewIndex("skillpackage_id", "skillpackage", "id")
		dp:AddNewIndex("battle_event_id", "battleevent", "id")
		dp:AddNewIndex("relation_id", "relation", "id")
		dp:AddNewIndex("rolelevel_id", "rolelevelup", "rolelevel")
		dp:AddNewIndex("weapon_id", "weapon", "id")
		dp:AddNewIndex("weaponlv_id", "weaponlvup", "weaponlv")
		dp:AddNewIndex("weaponstrength_id", "weaponintensify", "intensifylv")
		dp:AddNewIndex("weaponforge_id", "weaponforge", "forge_type_id")
		dp:AddNewIndex("boss_id", "shilianboss", "id")
		dp:AddNewIndex("trialstage_id", "shilianstage", "stage_id")
		dp:AddNewIndex("equip_id", "equip", "id")
		dp:AddNewIndex("equip_lv", "equiplvup", "lv")
		dp:AddNewIndex("equip_grade", "equipupgrade", "id")
		dp:AddNewIndex("equip_refine", "equiprefine", "id")
		dp:AddNewIndex("equip_refine_mode", "equiprefinemode", "mode")
		dp:AddNewIndex("equipprop_id", "equipprop", "propid")
		dp:AddNewIndex("equipset_id", "equipset", "id")
		dp:AddNewIndex("level_reward", "levelreward", "level")
		dp:AddNewIndex("hero_score", "rolescore", "role_id")
		dp:AddNewIndex("legionspec_id", "legionspec", "id")
		dp:AddNewIndex("construction_id", "construction", "id")
		dp:AddNewIndex("teji_id", "tejilevel", "teji_lvid")
		dp:AddNewIndex("speciality_id", "speciality", "id")
		dp:AddNewIndex("legiontech_id", "legiontech", "id")
		dp:AddNewIndex("buff_id", "buff", "buffid")
		dp:AddNewIndex("league_level", "leaguelevelup", "level")
		dp:AddNewIndex("league_position", "leagueposition", "type_id")
		dp:AddNewIndex("equestrainreward_id", "equestrainreward", "id")
		dp:AddNewIndex("leaguebuild_typ", "leaguebuild", "typ")
		dp:AddNewIndex("legionspeclvup_lv", "legionspeclvup", "lv")
		dp:AddNewIndex("hero_star", "rolestar", "role_id")
		dp:AddNewIndex("flower_id", "sendflower", "id")
		dp:AddNewIndex("sign_daily", "sign", "sign_day")
		dp:AddNewIndex("tower_stage", "towerstage", "stage_id")
		dp:AddNewIndex("tower_enemy", "towerenemy", "id")
		dp:AddNewIndex("tower_adds", "toweradds", "id")
		dp:AddNewIndex("robot_id", "arenarobot", "id")
		dp:AddNewIndex("dress_id", "dress", "id")
		dp:AddNewIndex("towerrewardgroup_id", "towerrewardgroup", "id")
		dp:AddNewIndex("wenda_reward", "wendareward", "question_order")
		dp:AddNewIndex("military", "dailybenefits", "fuli_type")
		dp:AddNewIndex("arenaexponent_id", "arenaexponent", "id")
		dp:AddNewIndex("game_define", "gamedefine", "id")
		dp:AddNewIndex("activity_id", "activity", "activity_id")
		dp:AddNewIndex("activitydetails_id", "activitydetails", "id")
		dp:AddNewIndex("rankactivity", "rankactivity", "id")
		dp:AddNewIndex("redeemcode", "redeemcode", "type_id")
		dp:AddNewIndex("rankinglist_id", "rankinglist", "ranking_list_id")
		dp:AddNewIndex("librarylevel_id", "librarylevel", "lv")
	end
	
	local dp = DataPool_Alloc("versiondata", "./version.dpc")
	if dp~=nil then
		dp:AddNewIndex("rmb_typ", "recharge", "recharge_id")
	end

	local version_info = API_GetLuaVersion_Info()
	--设置版本的信息
	local version_data = version_info._data._version_info
	version_data:Clear()
	for key, value in pairs(G_VERSION_INFO) do

		local find_version_info = version_data:Find(key)
		if find_version_info == nil then
			local insert_list = CACHE.VersionDataList()
			version_data:Insert(key, insert_list)
		end

		for i = 1, table.getn(value) do
			find_version_info = version_data:Find(key)
			local insert_data = CACHE.VersionData()
			insert_data._exe_ver = value[i].exe_ver
			insert_data._res_ver = value[i].res_ver
			find_version_info:PushBack(insert_data)
		end
	end
end

dofile "scripts/designer/misc.lua"
dofile "scripts/role.lua"
dofile "scripts/mafia.lua"
dofile "scripts/backpack.lua"
dofile "scripts/common_use_limit.lua"
dofile "scripts/dropitem.lua"
dofile "scripts/vp.lua"
dofile "scripts/prizemanager.lua"
dofile "scripts/hero.lua"
dofile "scripts/toplist.lua"
dofile "scripts/private_shop.lua"
dofile "scripts/pvearena.lua"
dofile "scripts/battle.lua"
dofile "scripts/hero_property.lua"
dofile "scripts/toplist_all_player.lua"
dofile "scripts/jieyi.lua"
dofile "scripts/version.lua"
--API_Log("util END")

