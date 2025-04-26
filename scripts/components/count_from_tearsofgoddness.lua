---@class components
---@field count_from_tearsofgoddness component_count_from_tearsofgoddness

local function on_val(self, value)
    self.inst.replica.count_from_tearsofgoddness:SetVal(value)
end

local function on_max(self, value)
    self.inst.replica.count_from_tearsofgoddness.max:set(value)
end

---@class component_count_from_tearsofgoddness
---@field inst ent
---@field val integer # 女神之泪叠加的被动层数
---@field max integer # 最大叠加层数,0为无限
---@field upgrade_to string # 升级成
---@field fn_on_delta function|nil
---@field fn_on_load function|nil
local count_from_tearsofgoddness = Class(

---@param self component_count_from_tearsofgoddness
---@param inst ent
function(self, inst)
    self.inst = inst
    self.val = 0
    self.max = 0

    self.fn_on_delta = nil
    self.fn_on_load = nil
end,
nil,
{
    val = on_val,
    max = on_max,
})

function count_from_tearsofgoddness:OnSave()
    return {
        val = self.val
    }
end

function count_from_tearsofgoddness:OnLoad(data)
    self.val = data.val or 0

    if self.fn_on_load then
        self.fn_on_load(self.inst, self.val)
    end
end

---init
---@param max integer
---@param upgrade_to string
function count_from_tearsofgoddness:Init(max,upgrade_to)
    self.max = max
    self.upgrade_to = upgrade_to
end

---层数变化
---@param num integer
function count_from_tearsofgoddness:DoDelta(num)
    if self.max ~= 0 then
        if self.val < self.max then
            self.val = math.min(self.max, self.val + num)
            local real_delta = self.val - num
            if self.fn_on_delta then
                self.fn_on_delta(self.inst, real_delta)
            end
        end
    else
        self.val = self.val + num
        if self.fn_on_delta then
            self.fn_on_delta(self.inst, num)
        end
    end
end

---comment
---@param fn fun(this: ent,num: integer)
function count_from_tearsofgoddness:SetOnDelta(fn)
    self.fn_on_delta = fn
end

---comment
---@param fn fun(this: ent,val: integer)
function count_from_tearsofgoddness:SetOnLoad(fn)
    self.fn_on_load = fn
end

return count_from_tearsofgoddness