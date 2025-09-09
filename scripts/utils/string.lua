--[[
    Copyright (c) 2025 zkip zkiplan@qq.com
    MIT License
--]]

local function split(str, separator)
    local result = {}

    local sep_escaped = ""

    for i = 1, string.len(separator), 1 do
        sep_escaped = sep_escaped .. "%" .. string.sub(separator, i, i)
    end

    local sep_len = string.len(sep_escaped) / 2

    local advanced_count = 0
    for part in string.gmatch(str, ".-" .. sep_escaped) do
        local part_len = string.len(part)
        table.insert(result, string.sub(part, 0, part_len - sep_len))
        advanced_count = advanced_count + part_len
    end
    table.insert(result, string.sub(str, advanced_count + 1))
    return result
end

local function trim(str)
    if not str then
        return str
    end
    local trim_str = string.gsub(str, "^%s*(.-)%s*$", "%1")
    return trim_str
end

local function tofixed(digitOrN, n)
    local digit = n and digitOrN or 2
    local n = not n and digitOrN or n
    
    return string.format("%."..digit.."f", n)
end

return {
    tofixed = tofixed,
	trim = trim,
    split = split,
}
