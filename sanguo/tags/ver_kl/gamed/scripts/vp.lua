--这个flag等于1的时候代表可以超过最大体力值，等于0的时候代表不可以超过
function VP_Addvp(role, num, flag)
	local vp = role._roledata._status._vp
	role._roledata._status._vp = vp + num
	if role._roledata._status._vp > (role._roledata._status._level + 60) then
		--现在满体力了，已经可以不让体力走了
		if flag == 0 then
			role._roledata._status._vp = role._roledata._status._level + 60
		end
		role._roledata._status._vp_refreshtime = 0
	end
	local resp = NewCommand("Role_Mon_Exp")
	resp.level = role._roledata._status._level
	resp.exp = role._roledata._status._exp:ToStr()
	resp.money = role._roledata._status._money
	resp.yuanbao = role._roledata._status._yuanbao
	resp.vp = role._roledata._status._vp
	role:SendToClient(SerializeCommand(resp))
end

function VP_Subvp(role, num)
	local vp = role._roledata._status._vp
	if vp >= num then
		role._roledata._status._vp = vp - num
		if role._roledata._status._vp_refreshtime == 0 and role._roledata._status._vp < (role._roledata._status._level + 60) then
			role._roledata._status._vp_refreshtime = API_GetTime()
		end
		local resp = NewCommand("Role_Mon_Exp")
		resp.level = role._roledata._status._level
		resp.exp = role._roledata._status._exp:ToStr()
		resp.money = role._roledata._status._money
		resp.yuanbao = role._roledata._status._yuanbao
		resp.vp = role._roledata._status._vp
		role:SendToClient(SerializeCommand(resp))
		return true
	else
		return false
	end
end
