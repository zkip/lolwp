--[[
    Copyright (c) 2025 zkip zkiplan@qq.com
    MIT License
--]]

local function filter(func, array)
    local result = {}
    for i = 1, #array, 1 do
        if func(array[i], i, array) then
            table.insert(result, array[i])
        end
    end
    return result
end

local function filterby(func)
    return function (array)
        local result = {}
        for i = 1, #array, 1 do
            if func(array[i], i, array) then
                table.insert(result, array[i])
            end
        end
        return result
    end
end
local function filterby_(func)
    return function (...)
        local array = {...}
        local result = {}
        for i = 1, #array, 1 do
            if func(array[i], i, array) then
                table.insert(result, array[i])
            end
        end
        return result
    end
end

local function filterof(array)
    return function (func)
        local result = {}
        for i = 1, #array, 1 do
            if func(array[i], i, array) then
                table.insert(result, array[i])
            end
        end
        return result
    end
end
local function filterof_(func, ...)
    return filterof({...})
end


local function map(func, array)
    local result = {}
    for i = 1, #array, 1 do
        table.insert(result, func(array[i], i, array))
    end
    return result
end

local function map_(func, ...)
    return map(func, {...})
end

local function mapby(func)
    return function (array)
        local result = {}
        for i = 1, #array, 1 do
            table.insert(result, func(array[i], i, array))
        end
        return result
    end
end

local function mapby_(func)
    return function (...)
        local result = {...}
        for i = 1, #array, 1 do
            table.insert(result, func(array[i], i, array))
        end
        return result
    end
end

local function mapof(array)
    return function (func)
        local result = {}
        for i = 1, #array, 1 do
            table.insert(result, func(array[i], i, array))
        end
        return result
    end
end

local function mapof_(...)
    return mapof({...})
end

local function join(separator, array)
    return table.concat(array, separator)
end

local function join_(separator, ...)
    return join(separator, {...})
end

local function joinby(separator)
    return function (array) return table.concat(array, separator) end
end

local function joinby_(separator)
    return function (...) return table.concat({...}, separator) end
end

local function joinof(array)
    return function (separator) return table.concat(array, separator) end
end

local function joinof_(...)
    return joinof({...})
end

local function getn(ary, index)
    index = index < 0 and (#ary + index + 1) or index
    return ary[index]
end

local function reverseGet(ary, index)
    return getn(ary, -index)
end

local function flattern(array)
    local result = {}
    for i, aryOrElse in ipairs(array) do
        if type(aryOrElse) == "table" and #aryOrElse > 0 then
            for _, item in ipairs(aryOrElse) do
                table.insert(result, item)
            end
        else
            table.insert(result, aryOrElse)
        end
    end
    return result
end

local function flattern_(...)
    return flattern({...})
end

return {
    reverseGet = reverseGet,
    getn = getn,
    
    join = join,
    joinby = joinby,
    joinof = joinof,
    flattern = flattern,
    filter = filter,
    filterby = filterby,
    filterof = filterof,
    mapby = mapby,
    mapof = mapof,
    map = map,
    join_ = join_,
    joinby_ = joinby_,
    joinof_ = joinof_,
    flattern_ = flattern_,
    filter_ = filter_,
    filterby_ = filterby_,
    filterof_ = filterof_,
    mapby_ = mapby_,
    mapof_ = mapof_,
    map_ = map_,
}