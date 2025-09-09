-- 重伤
local grievous_wounds = Class(function(self)
end)

function grievous_wounds:WhenHealthDelta(amount)
	-- TODO: 待分离成配置项
    return amount * 0.4
end

return grievous_wounds