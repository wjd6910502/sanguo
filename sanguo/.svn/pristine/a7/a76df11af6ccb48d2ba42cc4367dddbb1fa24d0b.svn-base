function OnCommand_TestFloat(player, role, arg, others)
	player:Log("OnCommand_TestFloat, "..DumpTable(arg).." "..DumpTable(others))

	local rand_seed = 0
	
	function mysrand(seed)
		rand_seed = seed
	end
	
	function myrand()
		rand_seed = (rand_seed*16807-1)%1073741824
		return rand_seed
	end
	
	function test_float(seed, count)
		mysrand(seed)
	
		local result = 1.0
	
		local i = 0
		while i<count do
			local op = myrand()%4
			local f = myrand()/1073741824.0+myrand()%100
			if op==0 then
				result = result+f
			elseif op==1 then
				result = result-f
			elseif op==2 then
				result = result*f
			elseif op==3 then
				result = result/f
			end
	
			--is result valid?
			if result>0x7fffffffffffffff or result<-0x7fffffffffffffff then
				--inf
				result = 1.0
			end
	
			if not (result>0) and not (result<0) then
				--nan
				result = 1.0
			end
	
			--next
			i = i+1
		end
	
		return tostring(result)
	end

	local result = test_float(arg.seed, arg.count)

	player:Log("OnCommand_TestFloat, result="..result)
end

