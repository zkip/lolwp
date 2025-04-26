---@class replica_components
---@field lol_wp_event_trigger replica_lol_wp_event_trigger

---@class replica_lol_wp_event_trigger
---@field event_name netvar
---@field type netvar
---@field trigger netvar
local lol_wp_event_trigger = Class(function(self, inst)
    self.inst = inst
    self.event_name = net_string(inst.GUID, "lol_wp_event_trigger.event_name")
    self.type = net_string(inst.GUID, "lol_wp_event_trigger.type")
    self.trigger = net_bool(inst.GUID, "lol_wp_event_trigger.trigger",'lol_wp_event_triggered')
end)

function lol_wp_event_trigger:SetEventName(event_name)
    self.event_name:set(event_name)
end

function lol_wp_event_trigger:GetEventName()
    return self.event_name:value()
end

function lol_wp_event_trigger:SetType(type)
    self.type:set(type)
end

function lol_wp_event_trigger:GetType()
    return self.type:value()
end

function lol_wp_event_trigger:Trigger(value)
    return self.trigger:set(value)
end

return lol_wp_event_trigger