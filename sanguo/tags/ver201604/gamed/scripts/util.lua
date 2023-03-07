--Alloc/AddNewIndex�����ڳ�ʼ��ʱ��
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

function InitInMainThread()
	API_DataPool_Clear()
	--Alloc/AddNewIndex�����ڳ�ʼ��ʱ��
	local dp = DataPool_Alloc("elementdata", "./elementdata.dpc")
	if dp~=nil then
		dp:AddNewIndex("id", "role", "id")
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
		dp:AddNewIndex("sign_id", "sign", "id")
	end
end

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

--API_Log("util END")
