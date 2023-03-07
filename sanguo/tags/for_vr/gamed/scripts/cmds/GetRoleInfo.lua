function OnCommand_GetRoleInfo(player, role, arg, others)
	player:Log("OnCommand_GetRoleInfo, "..DumpTable(arg))

	local resp = NewCommand("GetRoleInfo_Re")
	if role._roledata._base._id:ToStr()~="0" then
		resp.retcode = 0
		resp.info = ROLE_MakeRoleInfo(role)

	else
		--在这里需要进行一下判断，这个账号下面是否有角色，
		--如果有的话，那么告诉客户端几秒以后再来一次请求
		--如果没有的话，那么告诉客户端，没有角色。创建角色
		local data = others.noloadplayer._data._player_info:Find(player:GetStrAccount())
		if data ~= nil then
			others.noloadplayer:GetRoleInfo(player:GetStrAccount())
			resp.retcode = G_ERRCODE["LOAD_ROLE_DATA"]
		else
			resp.retcode = G_ERRCODE["NO_ROLE"]
		end
	end
	player:SendToClient(SerializeCommand(resp))


	if role._roledata._base._id:ToStr()~="0" then
		local msg = NewMessage("CheckClientVersion")
		player:SendMessage(role._roledata._base._id, SerializeMessage(msg))
	end
	----测试datapool的代码
	--local ed = DataPool("elementdata")
	--
	--local v = ed.role[1].soulID
	--if v~=nil then
	--	player:Log("v: "..v)
	--end
	--
	--local v2 = ed.role[2]
	--if v2~=nil then
	--	player:Log("v2.soulID: "..v2.soulID)
	--end
	--
	--local roles = ed.role
	--for r in DataPool_Array(roles) do
	--	player:Log("r.name: "..r.name)
	--	player:Log("r.prefix: "..r.prefix)
	--	player:Log("r.modelPath: "..r.modelPath)
	--	player:Log("r.soulID: "..r.soulID)
	--end
	--
	--local r2 = ed:FindBy("id", 32)
	--if r2~=nil then
	--	player:Log("r2.name: "..r2.name)
	--	player:Log("r2.prefix: "..r2.prefix)
	--	player:Log("r2.modelPath: "..r2.modelPath)
	--	player:Log("r2.soulID: "..r2.soulID)
	--end
end

