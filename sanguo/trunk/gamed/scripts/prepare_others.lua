--DONT CHANGE ME!

function PrepareOthers4Command(others, k, v)
	if k<1 then error("PrepareOthers4Command") end

	if false then
		--never to here
	elseif k==1 then
		v = API_GetLuaTopList(v)
		others.toplist = v
	elseif k==2 then
		v = API_GetLuaMisc(v)
		others.misc = v
	elseif k==3 then
		v = API_GetLuaPveArena(v)
		others.pvearena = v
	elseif k==4 then
		v = API_GetLuaNoLoadPlayer(v)
		others.noloadplayer = v
	elseif k==5 then
		v = API_GetLuaTongQueTai(v)
		others.tongquetai = v
	elseif k==6 then
		v = API_GetLuaTopList_All_Role(v)
		others.toplist_all_role = v
	elseif k==7 then
		v = API_GetLuaMafia_Info(v)
		others.mafia_info = v
	elseif k==8 then
		v = API_GetLuaJieYi_Info(v)
		others.jieyi_info = v
	elseif k==9 then
		v = API_GetLuaYueZhan_Info(v)
		others.yuezhan_info = v
	elseif k==10 then
		v = API_GetLuaVersion_Info(v)
		others.version_info = v
	elseif k==11 then
		v = API_GetLuaChat_Info(v)
		others.chat_info = v
	elseif k==12 then
		v = API_GetLuaRoleNameCache(v)
		others.rolenamecache = v
	elseif k==13 then
		v = API_GetLuaGlobalMessage(v)
		others.global_message = v
	elseif k==14 then
		v = API_GetLuaHotPvpVideo(v)
		others.hot_pvp_video = v
	elseif k==15 then
		v = API_GetLuaServerReward(v)
		others.server_reward = v

	end
end

function PrepareOthers4Message(others, k, v)
	if k<1 then error("PrepareOthers4Message") end

	if false then
		--never to here
	elseif k==1 then
		v = API_GetLuaTopList(v)
		others.toplist = v
	elseif k==2 then
		v = API_GetLuaMisc(v)
		others.misc = v
	elseif k==3 then
		v = API_GetLuaPveArena(v)
		others.pvearena = v
	elseif k==4 then
		v = API_GetLuaNoLoadPlayer(v)
		others.noloadplayer = v
	elseif k==5 then
		v = API_GetLuaTongQueTai(v)
		others.tongquetai = v
	elseif k==6 then
		v = API_GetLuaTopList_All_Role(v)
		others.toplist_all_role = v
	elseif k==7 then
		v = API_GetLuaMafia_Info(v)
		others.mafia_info = v
	elseif k==8 then
		v = API_GetLuaJieYi_Info(v)
		others.jieyi_info = v
	elseif k==9 then
		v = API_GetLuaYueZhan_Info(v)
		others.yuezhan_info = v
	elseif k==10 then
		v = API_GetLuaVersion_Info(v)
		others.version_info = v
	elseif k==11 then
		v = API_GetLuaChat_Info(v)
		others.chat_info = v
	elseif k==12 then
		v = API_GetLuaRoleNameCache(v)
		others.rolenamecache = v
	elseif k==13 then
		v = API_GetLuaGlobalMessage(v)
		others.global_message = v
	elseif k==14 then
		v = API_GetLuaHotPvpVideo(v)
		others.hot_pvp_video = v
	elseif k==15 then
		v = API_GetLuaServerReward(v)
		others.server_reward = v

	end
end
