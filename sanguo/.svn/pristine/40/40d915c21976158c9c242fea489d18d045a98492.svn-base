function OnCommand_TestFloat_Re(player, role, arg, others)
	--player:Log("OnCommand_TestFloat_Re, "..DumpTable(arg).." "..DumpTable(others))

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

		local results = ""
		local ret = 1.0
		local ret_bak = ret

		local i = 0
		while i<count do
			ret_bak = ret
			local op = myrand()%4
			local f = myrand()/1073741824.0+myrand()%100
			if op==0 then
				ret = ret+f
			elseif op==1 then
				ret = ret-f
			elseif op==2 then
				ret = ret*f
			elseif op==3 then
				ret = ret/f
			end
			
			--is ret valid?
			if ret>0x7fffffffffffffff then
				--inf
				results = results.." "..tostring(ret_bak)
				ret = 1.0
			end
			
			if ret<-0x7fffffffffffffff then
				--inf
				results = results.." "..tostring(ret_bak)
				ret = 1.0
			end

			if not (ret>0) and not (ret<0) then
				--nan
				results = results.." "..tostring(ret_bak)
				ret = 1.0
			end

			--next
			i = i+1
		end

		--return tostring(ret)
		results = results.." "..tostring(ret)
		return results
	end

	local result = test_float(arg.seed, arg.count)

	result = string.gsub(result, "e[+]0", "e+")
	arg.result = string.gsub(arg.result, "e[+]0", "e+")

	if result==arg.result then
		player:Log("OnCommand_TestFloat_Re, ok! seed="..arg.seed..", count="..arg.count)
	else
		player:Log("OnCommand_TestFloat_Re, mismatched! seed="..arg.seed..", count="..arg.count..", result="..result..", arg.result="..arg.result)
	end
end
