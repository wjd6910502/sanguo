
--initialize
local dp = DP:new()
dp:Load("../elementdata.dpc")
dp:AddKey("role_id_key", "role", "id")
DPManager:AddDP("elementdata", dp)



--find 1
local dp = DPManager:Find("elementdata")
local r = dp:Find("role_id_key", 29)
if r~=nil then
	--print(r.a.b.c)
	print(r.soulID) --TODO:
end



--find 2
local dp = DPManager:Find("elementdata")
local v = dp:GetVariable("role[0].soulID")
if r~=nil then
	print(v)
end



--walk
local dp = DPManager:Find("elementdata")
local roles = dp:GetArray("role")
for r in roles do --TODO:
	--print(r.a.b.c)
	print(r.soulID)
end












--initialize
local dp = DataPool_Alloc("elementdata", "../elementdata.dpc")
dp:AddKey("role_id_key", "role", "id")

function DataPool_Alloc(name, path)
	local p = API_DataPool_Alloc(name, path)
	dp = {}
	dp.__ptr__ = p
	dp.AddKey = function(dp, key_name, arr, key)
		API_DataPool_AddKey(dp.__ptr__, key_name, arr, key)
	end
	return dp
end



--find/get
local dp = DataPool_Find("elementdata")
local r = dp:Find("role_id_key", 29)
if r~=nil then
	--print(r.a.b.c)
	print(r.soulID) --TODO:
end
local v = dp:Get("role[0].soulID")
if v~=nil then
	print(v)
end
local v2 = dp:Get("role[1]")
if v2~=nil then
	print(v2.soulID)
end

function DataPool_Find(name)
	local p = API_DataPool_Find(name)
	dp = {}
	dp.__ptr__ = p

	--dp.Find = function(dp, key_name, key)
	--	return API_DataPool_Find(dp.__ptr__, key_name, key)
	--end

	dp.Get = function(dp, expr)
		local v = API_DataPool_Get(dp.__ptr__, expr)
		var = {}
		var.__ptr__ = v

		mt = {}
		mt.__index__ = function(table, key)
			return API_DataPool_XXX(table.__ptr__, key)
		end

		setmetatable(var, mt)

		return var
	end

	return dp
end



--walk
local dp = DataPool_Find("elementdata")
local roles = dp:Get("role")
for r in array_members(roles) do --TODO: only for array
	--print(r.a.b.c)
	print(r.soulID)
end




















--initialize
local dp = DataPool_Alloc("elementdata", "../elementdata.dpc")
--dp:AddKey("role_id_key", "role", "id")

--get
local dp = DataPool_Find("elementdata")
--local v = dp:Get("role[0].soulID")
--if v~=nil then
--	print(v)
--end
--local v2 = dp:Get("role[1]")
--if v2~=nil then
--	print(v2.soulID)
--end
--local roles = dp:Get("role")
--for r in DataPool_Array(roles) do
--	print(r.soulID)
--end

local v = dp.role[0].soulID
if v~=nil then
	print(v)
end
local v2 = dp.role[1]
if v2~=nil then
	print(v2.soulID)
end
local roles = dp.role
for r in array_members(roles) do
	print(r.soulID)
end

--find
--local r = dp:Find("role_id_key", 29)
--if r~=nil then
--	print(r.soulID) --TODO:
--end





function DataPool_Alloc(name, path)
	local dp_ptr = API_DataPool_Alloc(name, path)
	dp = {}
	dp.__ptr__ = dp_ptr 
	return dp
end

function DataPool_MakeVar(v_ptr)
	local var = {}
	var.__ptr__ = v_ptr
	local mt = {}
	mt.__tostring = function(var)
		return API_DataPool_VarToString(var.__ptr__)
	end
	mt.__index = function(var, key)
		local v_ptr = API_DataPool_VarIndex(var.__ptr__, key)
		return DataPool_MakeVar(v_ptr)
	end
	setmetatable(var, mt)
	return var
end

function DataPool_Find(name)
	local dp_ptr = API_DataPool_Find(name)
	dp = {}
	dp.__ptr__ = dp_ptr

	dp.Get = function(dp, expr)
		local v_ptr = API_DataPool_Get(dp.__ptr__, expr)
		return DataPool_MakeVar(v_ptr)
	end

	local mt = {}
	mt.__index = function(dp, key)
		local v_ptr = API_DataPool_Get(dp.__ptr__, expr)
		return DataPool_MakeVar(v_ptr)
	end
	setmetatable(dp, mt)

	return dp
end

function DataPool_Array(array)
	local idx = 0
	return function(array)
		local v_ptr = API_DataPool_Array(dp.__ptr__, idx)
		if v_ptr==nil then return nil end
		idx = idx+1
		return DataPool_MakeVar(v_ptr)
	end
end




