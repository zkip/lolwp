local lfs = require("lfs")
require("class")

local unit_path, case_name = unpack(arg)

table.insert(package.loaders, 1, function (modulename)
	local func, err
	if string.match(modulename, "^%.%/") or string.match(modulename, "^unit_test") then
		func, err = loadfile(modulename..".lua")
	else
		func, err = loadfile("scripts/"..modulename..".lua")
	end
	if err then
		error(err)
	else
		return func
	end
end)

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

-- local function printExplain(any)
-- 	if any == nil then
-- 		print("nil")
-- 	end
-- 	print(tostring(any))
-- end

local function formatWithColors(...)
	local str_list = {}
	local parts = {...}
	
	
	local half_size = #parts/2
	for i = 1, half_size, 1 do
		local colorcode = parts[half_size + i]
		local str = tostring(parts[i])
		local style = 0
		if type(colorcode) == "table" then
			style = colorcode[2]
			colorcode = colorcode[1]
		end

		table.insert(str_list, string.format("%c[0;"..style..";"..colorcode.."m"..str.."%c[0m", 0x1b, 0x1b))
	end
	return table.concat(str_list, "")
end

local function printx(...)
	local x = {}
	for i, v in ipairs({...}) do
		table.insert(x, formatWithColors(unpack(v)))
	end
	print(unpack(x))
end

-- =========test tools=========
local case_result_map = { }
local current_case

function report_case_result()
	if case_result_map[current_case].result then
		printx(
			{current_case, 32},
			{">>>", 0},
			{"passed", 32}
		)
		return
	end

	local colwidth = 0
	local pad = function (str) return string.format("%-"..colwidth.."s", str) end
	for i, case_result in ipairs(case_result_map[current_case].case_results) do
		colwidth = math.max(string.len(current_case..":"..case_result.line), colwidth)
		-- print(case_result, "LL")
	end
	for i, case_result in ipairs(case_result_map[current_case].case_results) do
		if case_result.result then
			printx(
				{pad(current_case..":"..case_result.line), 32},
				{">>>", 0},
				{"passed", 32}
			)
		else
			printx(
				{pad(current_case..":"..case_result.line), 31},
				{">>>", 0},
				{"actually: "..tostring(case_result.actually), 41},
				{"expected: "..tostring(case_result.expected), 0}
			)
			
			if #case_result.detail_msgs > 0 then
				case_result.detail_msgs[1][1] = pad(case_result.detail_msgs[1][1])
				printx(
					unpack(case_result.detail_msgs)
				)
			end
		end
	end
end
function case(name, func)
	if case_name and name ~= case_name then return end

	current_case = name
	case_result_map[current_case] = { result = true, case_results = {} }
	func()
	report_case_result()
end

function let(actually)
	local detail_msgs = {}

	local function getTraceback(expected)
		return function (result)
			local info = debug.getinfo(6, "Sln")
			if not result then case_result_map[current_case].result = false end
			table.insert(case_result_map[current_case].case_results, {
				result = result,
				line = info.currentline,
				actually = actually,
				expected = expected,
				detail_msgs = detail_msgs,
			})
			detail_msgs = {}
		end
	end
	
	local actions = {
		shallowEqual = function(expected)
			for k, v in pairs(expected) do
				if not actually then return expected == actually end
				if actually[k] ~= expected[k] then
					detail_msgs = {{"", 0}, {k..":", 0}, {actually[k], 31}, {expected[k], 0} }
					return false
				end
			end
			return true
		end
	}
	return setmetatable({}, { __index = function(_, key)
		if actions[key] then
			return function (expected)
				xpcall(function () error(actions[key](expected)) end, getTraceback(expected))
			end
		end
	end})
end

local function _expect(actually, expected)
	error(actually == expected)
end

function expect(actually, expected)
	local function traceback(result)
		local info = debug.getinfo(7, "Sln")
		if not result then case_result_map[current_case].result = false end
		table.insert(case_result_map[current_case].case_results, {
			result = result,
			line = info.currentline,
			actually = actually,
			expected = expected
		})
	end

	xpcall(function () _expect(actually, expected) end, traceback)
end

local function merge_in_meta(t1, t2, ...)
	if not t2 then return t1 end

	local others = {...}
	local indexer = function (_, k)
		return t1[k] or t2[k]
	end
	local result = setmetatable({}, { __index = indexer })
	
	if #others > 0 then
		return merge_in_meta(result, unpack(others))
	end
	return result
end

local zkenv = { }

function zkuires(...)
	local modules = {}
	for i, module_data in ipairs({...}) do
		local modulepath = type(module_data) == "string" and module_data or nil
		if modulepath then
			table.insert(modules, require(modulepath))
		else
			local name, modulepath = next(module_data)
			if name then
				table.insert(modules, { [name] = require(modulepath) })
			end
		end
	end
	
	return merge_in_meta(zkenv.env, unpack(modules))
end

(function (env)
	zkenv.env = env
	zkenv.zkuires = zkuires
end)({
	pairs = pairs,
	ipairs = ipairs,
	print = print,
	math = math,
	table = table,
	type = type,
	string = string,
	tostring = tostring,
	require = require,
	unpack = unpack,
	case = case,
	expect = expect,
	let = let,
	Class = Class
})

-- require("zkuires")({
-- 	pairs = pairs,
-- 	ipairs = ipairs,
-- 	print = print,
-- 	math = math,
-- 	table = table,
-- 	type = type,
-- 	string = string,
-- 	tostring = tostring,
-- 	require = require,
-- 	unpack = unpack,
-- 	case = case,
-- 	expect = expect,
-- 	let = let,
-- })

function run_unit( unit_name )
	if unit_name then
		
	end
end

function isDir(path)
	return lfs.attributes(path).mode == "directory"
end

function isFile(path)
	return lfs.attributes(path).mode == "file"
end

function getFiles(filepath)
	local paths = {}
	for filename in lfs.dir(filepath) do
		if filename ~= "." and filename ~= ".." then
			local path = table.concat({filepath, filename}, "/")
			table.insert(paths, { path = path, name = filename })
		end
	end

	return paths
end

function getMatchedSourceFiles(filepath)
	local isWildcard = string.match(filepath, "%*$")

	if isWildcard then
		local paths = {}
		local ddd = getFiles(string.sub(filepath, 0, -3))
		for _, filep in ipairs(ddd) do
			local next_files = {}
			local fullpath = filep.path
			local filename = filep.name
			local ignored = string.match(filename, "^%_")

			if isDir(fullpath) and not ignored then
				next_files = getMatchedSourceFiles(fullpath.."/*")
			end

			if string.match(fullpath, "%.lua$") and not ignored then
				table.insert(paths, fullpath)
			end

			if #next_files > 0 then
				paths = merge(paths, next_files)
			end
		end
		return paths
	end

	if not isWildcard and isFile(filepath..".lua") then
		return {filepath..".lua"}
	end
end

function execute_units(upath)
	local d = getMatchedSourceFiles("unit_test/"..upath)
	for i, path in ipairs(d) do
		printx({path, {30, 1}}, {"===================================", 0})
		loadfile(path)()
	end
end
-- ======= execute units =========
if unit_path then
	execute_units(unit_path)
else
	execute_units("*")
end