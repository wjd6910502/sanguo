function JIEYI_GetInfo(jieyityp, jieyiid)
	local jieyi_info = others.jieyi_info._data	
	

	local info = {}
	info.brotherinfo = {}
	info.bossinfo = {}
	info.level = 0
	info.exp = 0

	--已经结义的
	local fit = jieyi_info._jieyi_info:Find(jieyiid)
	if fit ~= nil then
		local v =  fit._value;
		info.id = v._id:Tostr()
		info.name = v._name
		info.level = v._level
		info.exp = v._exp
		info.typ = 1
		--info.bossinfo = {}
		info.bossinfo.id = v._boss_info._id:Tostr()
		info.bossinfo.name = v._boss_info._name 
		info.bossinfo.level = v._boss_info._level 
		info.bossinfo.photo = v._boss_info._photo 
		
		--兄弟信息
		local sit = v._brother_info:SeekToBegin()
		local s = sit:GetValue()
		while s ~= nil do
			local tmp_brother = {}
			tmp_brother.id = s._id:Tostr()
			tmp_brother.name = s._name
			tmp_brother.level = s._level
			tmp_brother.photo = s._photo
			
			info.brotherinfo[#info.brotherinfo+1] = tmp_brother
			sit:Next()
			s = sit:GetValue()
		end
		
	end	
	
	--准备结义的		
	local fit = jieyi_info._compare_jieyi_info:Find(jieyiid)
	if fit ~= nil then
	
		player:Log("OnCommand_JieYiGetInfo, "..fit._id:ToStr())
		info.id = fit._id:ToStr()
		info.name = fit._name
		info.level = fit._level
		info.exp = fit._exp
		info.typ = 2
		--info.bossinfo = {}
		info.bossinfo.id = fit._boss_info._id:ToStr()
		info.bossinfo.name = fit._boss_info._name 
		info.bossinfo.level = fit._boss_info._level 
		info.bossinfo.photo = fit._boss_info._photo 
		
		--兄弟信息
		--info.brotherInfo = {}
		local sit = fit._brother_info:SeekToBegin()
		local s = sit:GetValue()
		while s ~= nil do
			local tmp_brother = {}
			tmp_brother.id = s._id:ToStr()
			tmp_brother.name = s._name
			tmp_brother.level = s._level
			tmp_brother.photo = s._photo
			
			info.brotherinfo[#info.brotherinfo+1] = tmp_brother
			sit:Next()
			s = sit:GetValue()
		end
			
	end	
	
	return info
end

function GetbrotherIds(jieyi_info,jieyityp,jieyiid)
	
	local brotherall = {} 	
	local fit = jieyi_info._jieyi_info:Find(jieyiid)			
	if fit ~= nil and jieyityp == 1 then
		local v = fit
		local bossId = v._boss_info._id:ToStr()
		if bossId == "0" then
				--主A不存在 操作错误
			throw()
			return	
		end
		brotherall[#brotherall+1] = bossId 

		local sit = v._brother_info:SeekToBegin()
		local s = sit:GetValue()
		while s ~= nil do
			local bro_id = s._id:ToStr()
			
			brotherall[#brotherall+1] = bro_id 
				
			sit:Next()
			s = sit:GetValue()
		end

	end
	
	local fit = jieyi_info._compare_jieyi_info:Find(jieyiid)
	if fit ~= nil and jieyityp == 2  then
		local v = fit
		local bossId = v._boss_info._id:ToStr()
		if bossId == "0" then
				--主A不存在 操作错误
			throw()
			return	
		end
		brotherall[#brotherall+1] = bossId 

		local sit = v._brother_info:SeekToBegin()
		local s = sit:GetValue()
		while s ~= nil do
			local bro_id = s._id:ToStr()
			
			brotherall[#brotherall+1] = bro_id 
				
			sit:Next()
			s = sit:GetValue()
		end	
	end

	return brotherall
end


function JIEYI_Insert(jieyityp,jieyiid)

end

function JIEYI_Delete(jieyityp,jieyiid)


end

function JIEYI_UpdateTime( )
	--扔一个消息 刷新结义所有时间 也就是所有时间内的无状态结义


end
