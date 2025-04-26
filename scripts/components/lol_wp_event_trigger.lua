---@class components
---@field lol_wp_event_trigger component_lol_wp_event_trigger

local function on_event_name(self, value)
    self.inst.replica.lol_wp_event_trigger:SetEventName(value)
end

local function on_type(self, value)
    self.inst.replica.lol_wp_event_trigger:SetType(value)
end

local function on_trigger(self, value)
    self.inst.replica.lol_wp_event_trigger:Trigger(value)
end

---@class component_lol_wp_event_trigger
local lol_wp_event_trigger = Class(function(self, inst)
    self.inst = inst
    -- self.val = 0
    self.trigger = true
    self.event_name = ''
    self.type = ''
end,
nil,
{
    -- val = on_val,
    event_name = on_event_name,
    type = on_type,
    trigger = on_trigger,
})

-- function lol_wp_event_trigger:OnSave()
--     return {
--         -- val = self.val
--     }
-- end

-- function lol_wp_event_trigger:OnLoad(data)
--     -- self.val = data.val or 0
-- end

---comment
---@param event eventID
---@param type string
function lol_wp_event_trigger:Push(event,type)
    self.event_name = event
    self.type = type
    self.trigger = not self.trigger
end

return lol_wp_event_trigger