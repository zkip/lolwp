
local function findUpvalue(fn, target_name)
    local i = 1
    repeat
        local upvalue_name, upvalue_value = debug.getupvalue(fn, i)
        if upvalue_name == target_name then
            return upvalue_value
        end
        i = i + 1
    until not upvalue_name
    return nil
end

return {
	findUpvalue = findUpvalue,
}