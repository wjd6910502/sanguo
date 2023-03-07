function OnMessage_CheckServerReward(player, role, arg, others)
	player:Log("OnMessage_CheckServerReward, "..DumpTable(arg).." "..DumpTable(others))

	local now = API_GetTime()
	local lifetime = now-role:GetBornTime()

	local sr_manager = others.server_reward._data
	for sr in Cache_Map(sr_manager._map) do
		local got = role._roledata._misc._server_reward_got:Find(sr._id)
		if got==nil then
			--判断有效性
			if now>sr._begin_time and now<sr._end_time then
				if role._roledata._status._level>=sr._level_min then
					if lifetime>=sr._lifetime_min then
						--do mail
						local msg = NewMessage("SendMail")
						msg.mail_id = sr._mail_id
						player:SendMessage(role._roledata._base._id, SerializeMessage(msg))
						role._roledata._misc._server_reward_got:Insert(sr._id, CACHE.Int())
					end
				end
			end
		end
	end

	--TODO: 清理_server_reward_got
end
