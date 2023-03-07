--local tc = NS_TEST.g_func1(1)
--
--local to = NS_TEST.TestObject()
--to.arg = 1002
--local to1 = tc:func1(1003,to)
--print(tc.var1)
--if to1 then print(to1.arg) end


--local to = NS_TEST.TestObject()
--to.arg = 1
--
--local to2 = NS_TEST.TestObject()
--to2.arg = 2
--
--to2 = to
--to.arg = 3
--print(to2.arg)




--local tc = NS_TEST.g_func1(1)
--
--local to = NS_TEST.TestObject()
--to.arg = 1
--
--tc.var2 = to
--
--to.arg = 2
--
--print(tc.var2.arg)


--local tc = NS_TEST.g_func1(1)
--
--local to = NS_TEST.TestObject()
--to.arg = 1
--local to2 = NS_TEST.TestObject()
--to2.arg = 2
--
--tc:func1(1003,to) = to2
--
--print(to.arg, to2.arg)




