--[[
    Copyright (c) 2025 zkip zkiplan@qq.com
    MIT License
--]]

-- source of http://lua-users.org/wiki/CopyTable
local function deepclone(object)
    local orig_type = type(object)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, object, nil do
            copy[deepclone(orig_key)] = deepclone(orig_value)
        end
        setmetatable(copy, deepclone(getmetatable(object)))
    else -- number, string, boolean, etc
        copy = object
    end
    return copy
end

local function merge(...)
    local table = {}
    for k, v in pairs({...}) do
        for a, b in pairs(v) do
            if type(a) == 'number' then
                table[#table + 1] = b
            else
                table[a] = b
            end
        end
    end
    return table
end

local function _accessByKeypath(table, keypath, parent, ensure_exist)
    keypath = string.gsub(keypath, "^%.", "")
    keypath = string.gsub(keypath, "%.$", "")

    local index = string.find(keypath, "%.")
    if not index then return table[keypath], parent, keypath end

    local current = string.sub(keypath, 1, index - 1)
    local remain = string.sub(keypath, index + 1)

    local value = table[current]

    if string.len(remain) > 0 then
       if type(value) == "table" then
            return _accessByKeypath(value, remain, value, ensure_exist)
       end

       if ensure_exist and value == nil then
            table[current] = { }
            return _accessByKeypath(table[current], remain, table[current], ensure_exist)
       end

       return nil, parent, current
    end

    return value, parent, current
end

local function getByKeypath(table, keypath)
    return _accessByKeypath(table, keypath, table)
end

local function access(table)
    local function set(key, value)
        local _, parent, lastkey = _accessByKeypath(table, key, table, true)
        if parent == nil then return end
        parent[lastkey] = value
    end
    local function delta(key, value, fallback_value)
        local _, parent, lastkey = _accessByKeypath(table, key, table, true)
        if parent == nil then return end
        print(key, value, fallback_value, parent[lastkey])
        parent[lastkey] = (parent[lastkey] or fallback_value) + value
    end
    local function multiple(key, value, fallback_value)
        local _, parent, lastkey = _accessByKeypath(table, key, table, true)
        if parent == nil then return end
        parent[lastkey] = (parent[lastkey] or fallback_value) * value
    end
    local function divide(key, value, fallback_value)
        local _, parent, lastkey = _accessByKeypath(table, key, table, true)
        if parent == nil then return end
        parent[lastkey] = (parent[lastkey] or fallback_value) / value
    end
    local function mutate(key, fn)
        local _, parent, lastkey = _accessByKeypath(table, key, table, true)
        if parent == nil then return end
        parent[lastkey] = fn(parent[lastkey])
    end
    local function ifset(func, key, value)
        if func(value) then set(key, value) end
    end
    local function get(key)
        return getByKeypath(table, key)
    end
    local function call(methodpath)
        local method, parent = getByKeypath(table, methodpath)
        if type(method) ~= 'function' then return end
        return method(parent)
    end
    
	return {
        call = call,
		set = set,
        mutate = mutate,
        delta = delta,
        multiple = multiple,
        divide = divide,
		ifset = ifset,
		get = get,
	}
end

local function hasSome(table)
    for k, v in pairs(table) do
        return true
    end
    return false
end

return {
    access = access,
    merge = merge,
	deepclone = deepclone,
    getByKeypath = getByKeypath,
    hasSome = hasSome,
}