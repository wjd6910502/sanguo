


function FUNC()
	--print("FUNC()")
	--local info = debug.getinfo(3)
	--if info~=nil then
	--	for k,v in pairs(info) do
	--		print(k, v)
	--	end
	--end
	print(debug.traceback())
end

--print(debug.getinfo)

--local info = debug.getinfo(FUNC)
--local info = debug.getinfo(API_RBT_Create)
--local info = debug.getinfo(1)
--if info~=nil then
--	for k,v in pairs(info) do
--		print(k, v)
--	end
--end


FUNC()

