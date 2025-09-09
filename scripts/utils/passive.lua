local function genNetVarName(prefix, passive_name, dataname)
	local identity = prefix..'.'..passive_name..'.'..dataname
	local event_name = identity..'.dirty'
	return identity, event_name
end

return {
	genNetVarName = genNetVarName
}