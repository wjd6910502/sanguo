function OnCommand_GetClientLocalTime_Re(player, role, arg, others)
	player:Log("OnCommand_GetClientLocalTime_Re, "..DumpTable(arg).." "..DumpTable(others))

	if arg.server_ms~=role._roledata._misc._prev_server_ms then return end
	role._roledata._misc._prev_server_ms = 0

	local uptime = API_GetUptime()
	if arg.server_ms>uptime then return end

	if role._roledata._misc._bt==0 then
		if uptime-arg.server_ms<20 then
			role._roledata._misc._bt = arg.server_ms
			role._roledata._misc._et = uptime
			role._roledata._misc._ct = arg.client_ms
			player:Log("OnCommand_GetClientLocalTime_Re, 0, bt="..role._roledata._misc._bt..", et="..role._roledata._misc._et..", ct="..role._roledata._misc._ct)
		end
	else
		local delta = arg.client_ms-role._roledata._misc._ct
		if delta>uptime-role._roledata._misc._bt+1 then
			--player:Log("OnCommand_GetClientLocalTime_Re, 1, uptime="..uptime..", bt="..role._roledata._misc._bt..", et="..role._roledata._misc._et..", ct="..role._roledata._misc._ct..", delta="..delta..", max="..(uptime-role._roledata._misc._bt+1))
			player:Log("OnCommand_GetClientLocalTime_Re, 1, server_ms="..arg.server_ms..", uptime="..uptime..", delta="..delta..", max="..(uptime-role._roledata._misc._bt+1)..", diff="..(delta-uptime+role._roledata._misc._bt-1))
		elseif delta+1<arg.server_ms-role._roledata._misc._et then
			--player:Log("OnCommand_GetClientLocalTime_Re, 2, uptime="..uptime..", bt="..role._roledata._misc._bt..", et="..role._roledata._misc._et..", ct="..role._roledata._misc._ct..", delta="..delta..", min="..(arg.server_ms-role._roledata._misc._et-1))
			player:Log("OnCommand_GetClientLocalTime_Re, 2, server_ms="..arg.server_ms..", uptime="..uptime..", delta="..delta..", min="..(arg.server_ms-role._roledata._misc._et-1)..", diff="..(arg.server_ms-role._roledata._misc._et-1-delta))
		end
	end
end
