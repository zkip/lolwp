local function GetUpValue(fn, name)
    for i = 1, 99 do
        local upname,upvalue = debug.getupvalue(fn,i)
        if upname and upname == name then
            return upvalue
        end
    end
end

local componentactions = GetUpValue(EntityScript.CollectActions, "COMPONENT_ACTIONS")

local old_spellcaster = componentactions.POINT.spellcaster
componentactions.POINT.spellcaster = function(inst, ...)
    if inst._can_cast then
        return inst._can_cast:value() and old_spellcaster(inst, ...) or nil
    end
    return old_spellcaster(inst, ...)
end

local item_database = require("item_database")
local passive_map = item_database.passive_map

local function genPassiveRelFn(passive_name, fn)
	return function (inst)
		local passive_owner = inst.components.lolwp_passive_owner
		local passives = passive_owner and passive_owner:GetPassives(passive_name) or { }
		if next(passives) then
			return fn(passives, inst)
		end
	end
end

-- TODO: 改用 database 调用方法
local PassiveCache = {}
local StategraphPassiveMap = {}

-- 重新分类
for passive_name, prefabs in pairs(passive_map) do
    local Passive = PassiveCache[passive_name] or require("passives/"..passive_name)
    PassiveCache[passive_name] = Passive

    for _, passive_action_data in ipairs(Passive.actions or {}) do
        local passives = StategraphPassiveMap[passive_action_data.stategraph] or {}
        table.insert(passives, { passive_name = passive_name, passive_action_data = passive_action_data })
        StategraphPassiveMap[passive_action_data.stategraph] = passives
    end
end

for stategraph, passives in pairs(StategraphPassiveMap) do
    AddStategraphPostInit(stategraph, function(sg)
        for _, data in ipairs(passives) do
            local passive_name = data.passive_name
            local action_data = data.passive_action_data
            local action = action_data.action

            local action_handler = sg.actionhandlers[action] and sg.actionhandlers[action].deststate
            local state_picker = genPassiveRelFn(passive_name, action_data.fn)
            
            sg.actionhandlers[action] = ActionHandler(action, function(inst, action, ...)
                local result = state_picker(inst, action, ...)
                if result then return result end
                return action_handler and action_handler(inst, action, ...)
            end)
        end
    end)
end

-- local COMPONENT_ACTIONS = LOLWP_S:upvalueFind(EntityScript.CollectActions,'COMPONENT_ACTIONS')
-- if COMPONENT_ACTIONS then
--     local old_fn = COMPONENT_ACTIONS[tbl.type][tbl.component]
--     COMPONENT_ACTIONS[tbl.type][tbl.component] = function(...)
--         return tbl.testfn(old_fn,...)
--     end
-- end

-- AddStategraphEvent

--- author: dst-lan
-- function registActions(data_tbl)
--     local fixed_actions, fixed_component_actions = self:_fix_tbl(data_tbl)

--     for _, act in pairs(fixed_actions) do
--         local add_action = AddAction(act.id, act.str, act.fn)
--         if act.actiondata then
--             for k, v in pairs(act.actiondata) do
--                 add_action[k] = v
--             end
--         end

--         AddStategraphActionHandler('wilson', ActionHandler(add_action, act.state))
--         AddStategraphActionHandler('wilson_client', ActionHandler(add_action,act.state))
--     end

--     for _,v in pairs(fixed_component_actions) do
--         local action_collector = function(...)
--             local actions = GLOBAL.select(v.type == 'POINT' and -3 or -2,...)
--             for _,data in pairs(v.tests) do
--                 if data and data.testfn and data.testfn(...) then
--                     data.action = string.upper(data.action)
--                     table.insert(actions, GLOBAL.ACTIONS[data.action])
--                 end
--             end
--         end
--         AddComponentAction(v.type, v.component, action_collector)
--     end
-- end

-- local component_database = require("component_database")

-- for component_name, component_data in pairs(component_database) do
--     local Component = require("components/"..component_name)
--     local actions = Component.actions or { }

--     for index, action_data in ipairs(actions) do
--         -- TODO: 注册 ComponentAction
--         local override_vanilla = action_data.override_vanilla
--         if override_vanilla and action_data.override then
--             local vanilla_data = COMPONENT_ACTIONS[action_data.type][action_data.component]
--             COMPONENT_ACTIONS[action_data.type][action_data.component] = action_data.override(vanilla_data)
--         end
--     end

--     for stategraph_name, event in pairs(Component.stategraphEvents or {}) do
--         AddStategraphEvent(stategraph_name, event)
--     end
-- end