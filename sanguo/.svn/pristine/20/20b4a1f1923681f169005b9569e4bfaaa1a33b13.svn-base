function MAFIA_MakeMafia(mafia)
	local ret = {}
	ret.id = mafia._id:ToStr()
	ret.name = mafia._name
	ret.flag = mafia._flag
	ret.announce = mafia._announce
	ret.level = mafia._level
	ret.activity = mafia._activity
	ret.boss_id = mafia._boss_id:ToStr()
	ret.boss_name = mafia._boss_name
	--_member_map
	ret.members = {}
	local it = mafia._member_map:SeekToBegin()
	local m = it:GetValue()
	while m~=nil do
		local m2 = {}
		m2.id = m._id:ToStr()
		m2.name = m._name
		m2.photo = m._photo
		m2.level = m._level
		m2.activity = m._activity
		ret.members[#ret.members+1] = m2
		it:Next()
		m = it:GetValue()
	end
	return ret
end

