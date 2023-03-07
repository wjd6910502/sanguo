-- VersionTable.lua: 一种存放变量不同版本的table

-- 全局当前版本
globalVersion = 1;

local _pairs = _pairs;
local _ipairs = _ipairs;
local _table_getn = _table_getn;
local _table_sort = _table_sort;
local _table_concat = _table_concat;
local _table_insert = _table_insert;
local _table_move = _table_move;
local _table_remove = _table_remove;
local _table_unpack = _table_unpack;
local _unpack = _unpack;

local next = next;
local rawset = rawset;
local rawget = rawget;
local setmetatable = setmetatable;
local getmetatable = getmetatable;
local type = type;
local randomseed = math.randomseed;
--local randomdump = math.randomdump;
local randomdump = math.random;

local function pairsIter(t)
    local data = rawget(t, "__data");
    local k = rawget(t, "__iterk");
    local v = nil;
    k, v = next(data, k);
    rawset(t, "__iterk", k);
    if v then
        if v[1] then
            return k, v[1];
        else
            return pairsIter(t);
        end
    else
        rawset(t, "__iterk", nil);
    end
end

function pairs(t)
    if rawget(t, "__isver") then
        return pairsIter, t, nil;
    else
        return _pairs(t);
    end
end

local function ipairsIter(t, i)
    i = i + 1;
    local v = t[i];

    if v and v[1] then
        return i, v[1];
    end
end

function ipairs(t)
    if rawget(t, "__isver") then
        return ipairsIter, rawget(t, "__data"), 0;
    else
        return _ipairs(t);
    end
end

function table.getn(list)
    if rawget(list, "__isver") then
        list = rawget(list, "__data");
        local i = 1;
        while list[i] ~= nil and list[i][1] ~= nil do
            i = i + 1;
        end

        return i - 1;
    end

    return _table_getn(list);
end

function table.concat(list, ...)
    if rawget(list, "__isver") then
        list = rawget(list, "__data");
    end

    return _table_concat(list, ...);
end

function table.insert(list, ...)
    if rawget(list, "__isver") then
        list = rawget(list, "__data");
    end

    return _table_insert(list, ...);
end

function table.move(a1, f, e, t ,a2)
    if rawget(a1, "__isver") then
        a1 = rawget(a1, "__data");
    end

    if a2 ~= nil and rawget(a2, "__isver") then
        a2 = rawget(a2, "__data");
    end

    return _table_move(a1, f, e, t ,a2);
end

function table.remove (list, ...)
    if rawget(list, "__isver") then
        list = rawget(list, "__data");
    end

    return _table_remove(list, ...);
end

function table.unpack(list, ...)
    if rawget(list, "__isver") then
        list = rawget(list, "__data");
    end

    return _table_unpack(list, ...);
end

function table.sort(list, ...)
    if rawget(list, "__isver") then
        list = rawget(list, "__data");
    end

    return _table_sort(list, ...);
end

function unpack(list, ...)
    if rawget(list, "__isver") then
        list = rawget(list, "__data");
    end

    return _unpack(list, ...);
end

local function FuncNewIndex(t, k, v)
    local data = rawget(t, "__data");
    local dirtyKeys = rawget(t, "__dirtyKeys");
    if data[k] == nil then
        data[k] = {};
        dirtyKeys[k] = 1;
        rawset(t, "__changed", true);
    end

    if type(v) == "table" and not rawget(v, "__isver") then
        ConvertTableToVersioned(v);
    end
    -- 此处应用的是globalVersion作index，不过先简单用1作index
    if data[k][1] ~= v then
        data[k][1] = v;
        dirtyKeys[k] = 1;
        rawset(t, "__changed", true);
    end
end

local function FuncIndex(t, k)
    local data = rawget(t, "__data");
    if data[k] == nil then
        return rawget(t, k);
    else
        -- 此处应用的是globalVersion作index，不过先简单用1作index
        return data[k][1];
    end
end

local function FuncLen(t)
    local data = rawget(t, "__data");
    local i = 1;
    while data[i] ~= nil and data[i][1] ~= nil do
        i = i + 1;
    end

    return i - 1;
end

local function FuncComfirm(tab)
    if not rawget(tab, "__isver") then
        return;
    end

    local data = rawget(tab, "__data");
    local dirtyKeys = rawget(tab, "__dirtyKeys");
    for k, v in pairs(dirtyKeys) do
        local var = data[k];
        -- 此处应用的是globalVersion作index，不过先简单用1作index
        var.conf = var[1];
        dirtyKeys[k] = nil;
    end

    rawset(tab, "__changed", false);
end

local function FuncRevert(tab)
    if not rawget(tab, "__isver") then
        return;
    end

    local data = rawget(tab, "__data");
    local dirtyKeys = rawget(tab, "__dirtyKeys");
    for k, v in pairs(dirtyKeys) do
        local var = data[k];
        -- 此处应用的是globalVersion作index，不过先简单用1作index
        var[1] = var.conf;
        dirtyKeys[k] = nil;
    end

    rawset(tab, "__changed", false);
end

local verMeta = {__newindex = FuncNewIndex, __index = FuncIndex, __len = FuncLen};

local verTabs = setmetatable({}, {__mode = "k"});
local permTabs = setmetatable({}, {__mode = "k"});
function ConvertTableToVersioned(tab)
    if permTabs[tab] then
        return tab;
    end

    if verTabs[tab] or rawget(tab, "__isver") then
        -- UnityLogError("Error in converting table to versioned!");
        verTabs[tab] = true;
        return tab;
    else
        verTabs[tab] = true;
    end

    local data = {};
    local dirtyKeys = {};
    for k, v in _pairs(tab) do
        if type(v) == "table" and not rawget(v, "__isver") then
            ConvertTableToVersioned(v);
        end
        -- 此处应用的是globalVersion作index，不过先简单用1作index
        data[k] = {[1] = v, conf = v};
        tab[k] = nil;
    end

    rawset(tab, "__isver", true);
    rawset(tab, "__data", data);
    rawset(tab, "__changed", false);
    rawset(tab, "__Confirm", FuncComfirm);
    rawset(tab, "__Revert", FuncRevert);
    rawset(tab, "__dirtyKeys", dirtyKeys);

    setmetatable(tab, verMeta);

    return tab;
end

function CreateVersionTable()
    local tab =
    {
        __isver = true,
        __changed = true,
        __data = {},
        __Confirm = FuncComfirm,
        __Revert = FuncRevert,
        __dirtyKeys = {},
    };

    setmetatable(tab, verMeta);

    verTabs[tab] = true;
    return tab;
end

function PermanentTable(tab)
    if rawget(tab, "__isver") then
        return tab;
    end

    if permTabs[tab] then
        return tab;
    else
        permTabs[tab] = true;
    end

    for k, v in _pairs(tab) do
        if type(v) == "table" then
            PermanentTable(v);
        end
    end

    return tab;
end

-- 覆盖拷贝表的方法
function CopyTable(source)
    if source == nil then
        return nil;
    end

    local newTab = {};
    for k, v in _pairs(source or {}) do
        if type(v) ~= "table" then
            rawset(newTab, k, v);
        else
            rawset(newTab, k, CopyTable(v));
        end
    end

    local meta = getmetatable(source);
    if meta ~= nil then
        setmetatable(newTab, CopyTable(meta));
    end

    -- 是版本表要添加到集合中
    if rawget(newTab, "__isver") then
        verTabs[newTab] = true;
    end

    return newTab;
end

-- 覆盖标记table为只读
function ReadOnly(t)
    local proxy = {};
    local mt =
    {
        __index = t,
        __newindex = function (t, k, v)
            UnityLogError("attempt to update a read-only table.\n"..debug.traceback());
        end,
        __len = function (t)
            return #(getmetatable(t).__index);
        end,
        __pairs = function (t)
            return pairs(getmetatable(t).__index);
        end,
        __ipairs = function (t)
            return ipairs(getmetatable(t).__index);
        end
    }

    setmetatable(proxy, mt);
    rawset(proxy, "__ro__", 1);
    -- 只读表一定是Permanent
    return PermanentTable(proxy);
end

-- 覆盖创建只读表
function CreateReadOnlyTab()
    return ReadOnly({});
end

local seed = randomdump();
function Confirm()
    seed = randomdump();
    for k, v in pairs(verTabs) do
        if rawget(k, "__changed") then
            k:__Confirm();
        end
    end
    print("Confirm")
end

function Revert()
    randomseed(seed);
    for k, v in pairs(verTabs) do
        if rawget(k, "__changed") then
            k:__Revert();
        end
    end
    print("Revert")
end

function PrintVerTabInfo(verTab)
    if not rawget(verTab, "__isver") then
        return;
    end

    print("{");
    for k, v in pairs(rawget(verTab, "__data")) do
        print(" "..tostring(k).."={ [1]="..tostring(v[1])..", conf="..tostring(v.conf).." }");
    end
    print("}");
end

-- local Table = CreateVersionTable();

-- Table[2] = 1;
-- Table[5] = 2;
-- Table[6] = 3;
-- Table[1] = 111;

-- print("Test pairs")
-- for k, v in pairs(Table) do
--     print(k, " ", v);
-- end

-- print("Test ipairs")
-- for i, v in ipairs(Table) do
--     print(i, " ", v);
-- end
