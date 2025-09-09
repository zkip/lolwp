
local utils_passive = require("utils/passive")
local genNetVarName = utils_passive.genNetVarName
--[[
	对由 Class 创建出来的 instance, 代理它指定的成员变量, 存取的额外逻辑仅有:
		在写入 member_name 时会设置 netvar 的值
--]]
local function makeClassMemberSync(object, dataname, init_value, netvar)
    local value = init_value

	local metatable = getmetatable(object)
	-- 定义 Class 时不传 props 的模式
	local is_class_self = metatable.__index == metatable

	local __index = function(t, k)
		if k == dataname then
			return value
		end

		if is_class_self then
			return metatable[k]
		else
			return metatable.__index(t, k)
		end
	end

	local __newindex = function (t, k, v)
		if k == dataname then
			value = v
			netvar:set(v)
			return
		end

		if is_class_self then
			return rawset(object, k, v)
		else
			return metatable.__newindex(t, k, v)
		end
	end

    setmetatable(object, { __index = __index, __newindex = __newindex })
end

return makeClassMemberSync