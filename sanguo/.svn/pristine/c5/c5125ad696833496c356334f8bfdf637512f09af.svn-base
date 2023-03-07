
function Serialize(os, value)
	if value == nil then
		table.insert(os, ":")
		return
	end

	if type(value) == "number" then
		table.insert(os, value..":")
	elseif type(value) == "boolean" then
		table.insert(os, tostring(value)..":")
	elseif type(value) == "string" then
		--table.insert(os, enc(value)..":")
		table.insert(os, API_Base64_enc(value)..":")
	else
		error("Serialize, 1")
	end
end

function Deserialize(is, idx, typ)
	local e, _ = string.find(is, ":", idx)
	if not e then error("Deserialize, 1") end --error: ≤ª“‘':'Ω· ¯
	--if e == 1 then error("Deserialize, 2") end --error: ø’¥Æ
	local s = string.sub(is, idx, e-1)
	--print(s)
	
	if typ == "number" then
		local r = 0
		if string.len(s)~=0 then r=tonumber(s) end
		return idx+string.len(s)+1, r
	elseif typ  == "boolean" then
		if s == "true" then
			return idx+string.len(s)+1, true
		else
			return idx+string.len(s)+1, false
		end
	elseif typ == "string" then
		--return idx+string.len(s)+1, dec(s)
		return idx+string.len(s)+1, API_Base64_dec(s)
	end

	error("Deserialize, 3")
end

