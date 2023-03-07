function OnCommand_RemoveFriend(player, role, arg, others)
	--player:Log("OnCommand_RemoveFriend, dest_id="..arg.dest_id)

	--local d_player = CACHE.PlayerManager:GetInstance():FindByRoleId(arg.dest_id)
	--if d_player==nil then return end

	----互删好友
	--player:GetFriends():Delete(d_player._role_id)
	--d_player:GetFriends():Delete(player._role_id)

	----通知双方
	--local cmd = NewCommand("RemoveFriend_Re")
	--cmd.dest_id = player._role_id
	--d_player:SendToClient(cmd)

	--cmd.dest_id = d_player._role_id
	--player:SendToClient(cmd)
end
