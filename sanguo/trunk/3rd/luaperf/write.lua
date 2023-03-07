
----1, normal
--tab = {}


----2, lua mt
--tab = {}
----lua mt
--mt = {}
--mt.__index = function(t, k) return 0 end
--mt.__newindex = function(t, k, v) end
--setmetatable(tab, mt)


----3, c mt
--tab = {}
----c mt
--mt = {}
--mt.__index = API_Return0
--setmetatable(tab, mt)


----4, userdata
--tab = API_CreateVersionTable()


--5, version table
dofile "VersionTable.lua"
tab = CreateVersionTable()













--count
local count=0

for i=1,10000000 do
	tab[i%10000] = i
	--tab["xxx"] = i
	count = count+1
end

print(count)





