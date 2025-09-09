--[[
    Copyright (c) 2025 zkip zkiplan@qq.com
    MIT License
--]]


local function every(func, ...)
	local ary = {...}
    for i = 1, #ary, 1 do
        if not func(ary[i], i, ary) then return false end
    end
    return true
end

local function some(func, ...)
	local ary = {...}
    for i = 1, #ary, 1 do
        if func(ary[i], i, ary) then return true end
    end
    return false
end

local function notFalsy(value)
    if value then return true end
    return false
end

local function isNil(value)
    return value == nil and true or false
end

local function notNil(value)
    return value ~= nil and true or false
end

local function noEmptyAry(ary) return type(ary) == "table" and #ary > 0 end
local function isEmptyAry(ary) return type(ary) == "table" and #ary <= 0 end

local function isInteger (n) return math.floor(n) == n end

return {
    isInteger = isInteger,
    
    some = some,
    every = every,
    notFalsy = notFalsy,
    isNil = isNil,
    noEmptyAry = noEmptyAry,
    isEmptyAry = isEmptyAry,
    notNil = notNil,
}
