
local item_database = require("item_database")

local passive_map = item_database.passive_map

local function genPassiveRelFn(passive_name, fn)
	print("genPassiveRelFn::::::", passive_name)
	return function (inst)
		local passive_owner = inst.components.passive_owner
		local passives = passive_owner and passive_owner:GetPassives(passive_name) or { }
		print("genPassiveRelFn::::::inner:::::", passives)
		if next(passives) then
			fn(passives, inst)
		end
	end
end

-- for passive_name, prefabs in pairs(passive_map) do
-- 	local Passive = require("passives/"..passive_name)
	
-- 	-- for _, event_data in ipairs(Passive.stategraphEvents or {}) do
-- 	-- 	local fn = genPassiveRelFn(passive_name, event_data.fn)
-- 	-- 	print("stategraphEvents::::::", event_data and event_data.event_name)
-- 	-- 	AddStategraphEvent(event_data.stategraph, EventHandler(event_data.event_name, fn))
-- 	-- end
-- end

local stategraph_files = {
	"triple_atk"
}

for _, stategraph_filename in pairs(stategraph_files) do
	local stategraph_list = require("stategraphs/"..stategraph_filename)
	for _, stategraph_data in ipairs(stategraph_list or {}) do
		AddStategraphState(stategraph_data.stategraph, stategraph_data.state)
	end
end