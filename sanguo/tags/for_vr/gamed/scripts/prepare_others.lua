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

	end
end
