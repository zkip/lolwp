--[[
    Copyright (c) 2025 zkip zkiplan@qq.com
    MIT License
--]]

local function mod(a, b)
    local sign = a * b < 0
    return a % (sign and -b or b)
end

return {
	mod = mod
}