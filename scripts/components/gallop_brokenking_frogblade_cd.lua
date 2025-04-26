

---@class components
---@field gallop_brokenking_frogblade_cd component_gallop_brokenking_frogblade_cd

local function on_val(self, value)
    self.inst.replica.gallop_brokenking_frogblade_cd:SetVal(value)
end

---@class component_gallop_brokenking_frogblade_cd
---@field inst ent
---@field val integer
---@field cd integer
local gallop_brokenking_frogblade_cd = Class(function(self, inst)
    self.inst = inst
    self.val = 0
    self.cd = 20
end,
nil,
{
    val = on_val,
})

function gallop_brokenking_frogblade_cd:OnSave()
    return {
        val = self.val
    }
end

function gallop_brokenking_frogblade_cd:OnLoad(data)
    self.val = data.val or 0
end

---开始cd
---@param val integer # 不填则用默认CD
function gallop_brokenking_frogblade_cd:StartCD(val)
    if self.inst.taskperiod_gallop_brokenking_frogblade_cd then
        self.inst.taskperiod_gallop_brokenking_frogblade_cd:Cancel()
        self.inst.taskperiod_gallop_brokenking_frogblade_cd = nil
    end
    self.val = val or self.cd
    self.inst.taskperiod_gallop_brokenking_frogblade_cd = self.inst:DoPeriodicTask(1, function()
        if self.val <= 0 then
            if self.inst then
                if self.inst.taskperiod_gallop_brokenking_frogblade_cd then
                    self.inst.taskperiod_gallop_brokenking_frogblade_cd:Cancel()
                    self.inst.taskperiod_gallop_brokenking_frogblade_cd = nil
                end
            end
            return
        end
        self.val = self.val - 1
    end)
end

---在cd
---@return boolean
---@nodiscard
function gallop_brokenking_frogblade_cd:IsCD()
    return self.val > 0
end

---重置CD
function gallop_brokenking_frogblade_cd:ResetCD()
    self.val = 0
end

---修改默认CD
---@param val integer
---@param smart boolean
function gallop_brokenking_frogblade_cd:ChangeDefaultCD(val,smart)
    if smart then
        if self:IsCD() then
            if self.val > val then
                self.val = val
            end
        end
        self.cd = val
    else
        self.cd = val
    end
end

---cd减少至指定值
---@param val any
function gallop_brokenking_frogblade_cd:ReduceToCD(val)
    if self:IsCD() and self.val > val then
        self.val = val
    end
end



return gallop_brokenking_frogblade_cd