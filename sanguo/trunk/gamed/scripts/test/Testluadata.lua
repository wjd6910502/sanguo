function OnCommand_TestCmd(player, role, arg, others)
	player:Log("OnCommand_TestCmd, "..DumpTable(arg).." "..DumpTable(others))

	local resp = NewCommand("TestCmd_Re");
	resp.retcode = G_ERRCODE["SUCCESS"]

	-- 1: 测试容器嵌套插入 
	-- 2: 正常容器插入删除
	-- 3: 大量数据插入

	if	arg.count1 == 1 then
		
		if arg.count2 == 1 then 
			local lit = role._roledata._testhello._test10
			local list = CACHE.testhellolist()
			local s = CACHE.Str()
			s._value = "hello rock !!!!!"
			list:PushBack(s);
			s._value = "hello rock111 !!!!!!!"                                                                                                  
			list:PushBack(s);
			local key =1
			lit:Insert(key,list)
		end
	
		local t = lit:SeekToBegin()
		local tf = t:GetValue()	
		while tf~=nil do
		
			local ttf = tf:SeekToBegin()
			local ttfv = ttf:GetValue()
			while ttfv ~= nil do 
		
				print("list value ="..ttfv._value )
				ttf:Next()
				ttfv = ttf:GetValue()
				--throw()
			end
			t:Next()
			tf = t:GetValue()
		end
	
-- rock 1
	
		local lit = role._roledata._testhello._test11
		local mp = CACHE.testhellomap()
	
		local key =1;
		local s = CACHE.Str()
		s._value = "wwwwwwwwwwww"

		mp:Insert(key,s);
		lit:Insert(key,mp)

	--iter	
		local fit = lit:SeekToBegin()
		local fitv = fit:GetValue()
		while fitv ~= nil do
			local jfit = fitv:SeekToBegin()
			jfitv =jfit:GetValue()
			while jfitv ~= nil do
		
				print("map value = " .. jfitv._value)
				jfit:Next()
				jfitv = jfit:GetValue()
			end
			--throw()	
			fit:Next()
			fitv = fit:GetValue()
		end
	end
	--throw()
	if arg.count1 == 3 then
	
		local lit = role._roledata._testhello._test1
		local s = CACHE.Str()
		if arg.count2 == 1 then	
			for i = 1,1000000 do
				s._value = "just od it........... "
				lit:PushBack(s)
			end 
		end

		print("list size() ="..lit:Size() )	
		local fit = lit:SeekToBegin()
		local f = fit:GetValue()
		while f~=nil do
			print("list value ="..f._value ) 
			fit:Next()
			f = fit:GetValue()
		end
	--throw()
	end

	if arg.count1 == 2 then

-- test debug list int	
		local list = role._roledata._testhello._test2
	
		if arg.count2 == 1 then
			local t = CACHE.Int()
			t._value = 123456
			list:PushBack(t)
			t._value = 234567
			list:PushBack(t)
		end

		local fit = list:SeekToBegin()
		local f = fit:GetValue()
		while f~=nil do
			print("list value ="..f._value )
			--change
			--throw()
			f._value = 2356454
			print("list value =".. f._value )
			--throw()
			fit:Next()
			f = fit:GetValue()
		end
	
		local fit = list:SeekToBegin()
		local f = fit:GetValue()
		while f~=nil do
			print("list value ="..f._value )
			--	change
			--	f._value = 2356454
			--	print("list value =".. f._value )
			fit:Next()
			f = fit:GetValue()
		end
		
		local listt = role._roledata._testhello._test3

		if arg.count2 == 1 then
			local t = CACHE.Int64()	
			t:Add(10)
			t:Add(100)
			t:Add(1000)
			t:Add("10000")
			print("Add t = "..t:ToStr() )
	
			t:Sub(10)
			t:Sub(100)
			t:Sub(1000)
			t:Sub("10000")
			print("Sub t = ".. t:ToStr() )

			--t:Div(0)
			--print("Div t = ".. t:ToStr() )
			-- dump core
			t:Div(1)
			print("Div t ="..t:ToStr())
	
			t:Set(1)
			t:Mul(10)
			--throw()
		
			print("Mul t =" .. t:ToStr() )
	
			t:Div(2)
			print("Div t ="..t:ToStr() )
			t:Clear()
		end
		
-- test debug map Str
		local mapl = role._roledata._testhello._test4

		local fit = mapl:SeekToBegin()
		local f =fit:GetValue()

		while f~=nil do
		
			print("map str ".. f._value)
			fit:Next()
			f = fit:GetValue()
		end

		local f = mapl:Find(123)
		if f~=nil then 
		print("find map str"..f._value)


		if arg.count2 == 1 then
			local s = CACHE.Str()
			s._value = "wjd123"
			local k = 123
			mapl:Insert(k,s)
	
			local s =CACHE.Str()
			s._value = "132345"
			local k = 234
			mapl:Insert(k,s)
		end

-- test debug map int
		local map = role._roledata._testhello._test5
	
		if arg.count2 == 1 then
			local t = CACHE.Int()
			t._value = 111
			local k = 123
			map:Insert(k,t)
		end

		local fit = map:SeekToBegin()
		local f =fit:GetValue()
		while f~=nil do
		
			print("map int =".. f._value)
			fit:Next()
			f = fit:GetValue()
		end
	
-- test debug map int64
		local map = role._roledata._testhello._test6
	
		if arg.count2 == 1 then 
			local t = CACHE.Int64()
			t:Set(2147483647)
			map:Insert(123,t)
		
			t:Set(4294967395)
			map:Insert(124,t)
		
			t:Set(42949673956)
			map:Insert(125,t)
		
			t:Set(42949673957)
			map:Insert(126,t)
	
			t:Set("922337203685477580")
			map:Insert(127,t)
	
			t:Set("8")
			map:Insert(128,t)

			t:Set(4294967395671111)
			map:Insert(129,t)
	
			local t = CACHE.Int64()
			t:Set(92233720368547758)
			map:Insert(130,t)
	
			local t = CACHE.Int64()
			t:Set(922337203685477580)
			map:Insert(131,t)
	
			local t = CACHE.Int64()
			t:Set(9223372036854775807)
			map:Insert(132,t)
	
			local t = CACHE.Int64()
			t:Set(9223372036854775808)
			map:Insert(133,t)
		end

		local fit = map:SeekToBegin()
		local f = fit:GetValue()

		while f~=nil do	
			print("map Int64 ="..f:ToStr())
			fit:Next()
			f = fit:GetValue()
		end
		--throw()	
		role:SendToClient(SerializeCommand(resp))

		--test message
		-- local msgs = "90005:0"	
		-- role:TestMessage( msgs);	

		end
	end

end
