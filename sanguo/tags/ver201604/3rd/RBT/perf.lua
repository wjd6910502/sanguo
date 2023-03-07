
--local tbl = {}
local tbl = API_RBT_Create()

for tick=1,1000000 do
	API_RBT_Next(false)
	
	tbl.x = tick*100+1
	tbl.y = tick*100+2
	tbl.z = tick*100+3
	
	--print(tbl.x, tbl.y, tbl.z)

	if tick>10 then
		API_RBT_Confirm()
	end
end

