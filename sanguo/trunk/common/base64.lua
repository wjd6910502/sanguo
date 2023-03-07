#!/usr/bin/env lua
-- Lua 5.1+ base64 v3.0 (c) 2009 by Alex Kloss <alexthkloss@web.de>
-- licensed under the terms of the LGPL2

-- character table string
local b64chars='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'

local quick_enc = {}
quick_enc["34 "] = "MzQg"
quick_enc["45 "] = "NDUg"
quick_enc["42 "] = "NDIg"
quick_enc["49 "] = "NDkg"
quick_enc["46 "] = "NDYg"
quick_enc["41 "] = "NDEg"
quick_enc["38 "] = "Mzgg"
quick_enc["57 "] = "NTcg"
quick_enc["54 "] = "NTQg"
quick_enc["300 "] = "MzAwIA=="

local quick_dec = {}
quick_dec["MzQg"] =	"34 "
quick_dec["NDUg"] =	"45 "
quick_dec["NDIg"] =	"42 "
quick_dec["NDkg"] =	"49 "
quick_dec["NDYg"] =	"46 "
quick_dec["NDEg"] =	"41 "
quick_dec["Mzgg"] =	"38 "
quick_dec["NTcg"] =	"57 "
quick_dec["NTQg"] =	"54 "
quick_dec["MzAwIA=="] =	"300 "

-- encoding
function enc(data)
	local qk = quick_enc[data]
	if qk~=nil then return qk end

		local s64 = ''  
        local str = data
    
        while #str > 0 do  
            local bytes_num = 0   
            local buf = 0   
    
            for byte_cnt=1,3 do  
                buf = (buf * 256)  
                if #str > 0 then  
                    buf = buf + string.byte(str, 1)  
                    str = string.sub(str, 2)  
                    bytes_num = bytes_num + 1   
                end  
            end  
    
            for group_cnt=1,(bytes_num+1) do  
                local b64char = math.fmod(math.floor(buf/262144), 64) + 1   
                s64 = s64 .. string.sub(b64chars, b64char, b64char)  
                buf = buf * 64  
            end  
    
            for fill_cnt=1,(3-bytes_num) do  
                s64 = s64 .. '='  
            end  
        end  
    
        return s64
end

-- decoding
function dec(str64)
	local qk = quick_dec[str64]
	if qk~=nil then return qk end

	    local temp={}  
        for i=1,64 do  
            temp[string.sub(b64chars,i,i)] = i   
        end  
        temp['=']=0  
        local str=""  
        for i=1,#str64,4 do  
            if i>#str64 then  
                break  
            end  
            local data = 0   
            local str_count=0  
            for j=0,3 do  
                local str1=string.sub(str64,i+j,i+j)  
                if not temp[str1] then  
                    return  
                end  
                if temp[str1] < 1 then  
                    data = data * 64  
                else  
                    data = data * 64 + temp[str1]-1  
                    str_count = str_count + 1   
                end  
            end  
            for j=16,0,-8 do  
                if str_count > 0 then  
                    str=str..string.char(math.floor(data/math.pow(2,j)))  
                    data=math.fmod(data,math.pow(2,j))  
                    str_count = str_count - 1   
                end  
            end  
        end  
    
        local tmp = string.byte(str, string.len(str), string.len(str))
        local last = tonumber(tmp)
        if last == 0 then
            str = string.sub(str, 1, string.len(str) - 1)
        end
        return str
end


--print(dec(enc("abc")))
--print(dec(enc("[]abc[]")))
--print(dec(enc("中国")))
--print((enc("中国")))
--print((enc("123")))
--print(dec(enc("[]中国[]")))

