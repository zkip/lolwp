---@class components
---@field lol_wp_cd_itemtile component_lol_wp_cd_itemtile

-- local function on_val(self, value)
    -- self.inst.replica.lol_wp_cd_itemtile:SetVal(value)
-- end

---comment
---@param self replica_lol_wp_cd_itemtile
---@param value any
local function on_cur_cd(self, value)
    self.inst.replica.lol_wp_cd_itemtile:SetCurCD(value)
end

---comment
---@param self replica_lol_wp_cd_itemtile
---@param value any
local function on__show_itemtile(self, value)
    self.inst.replica.lol_wp_cd_itemtile._show_itemtile:set(value)
end

---@class component_lol_wp_cd_itemtile
---@field inst ent
---@field cd integer # 总cd
---@field cur_cd integer # 剩余cd
---@field _show_itemtile boolean # 是否显示在itemtile, 不设置则默认为显示
---@field _task Periodic|nil
---@field onstartcdfn fun(this:ent,...):... # 开始cd时调用
---@field onfinishcdfn fun(this:ent,...):... # cd转好时调用
local lol_wp_cd_itemtile = Class(
---@param self component_lol_wp_cd_itemtile
---@param inst ent
function(self, inst)
    self.inst = inst
    -- self.val = 0
    self.cd = 10
    self.cur_cd = 0

    self._show_itemtile = true
end,
nil,
{
    -- val = on_val,
    cur_cd = on_cur_cd,
    _show_itemtile = on__show_itemtile,
})

function lol_wp_cd_itemtile:OnSave()
    return {
        -- val = self.val
        cd = self.cd,
        cur_cd = self.cur_cd,
    }
end

function lol_wp_cd_itemtile:OnLoad(data)
    -- self.val = data.val or 0
    self.cd = data.cd or 10
    self.cur_cd = data.cur_cd or 0

    if self.cur_cd > 0 then
        self:_StartCD(self.cd,true)
    end
end

---初始化
---@param cd integer
function lol_wp_cd_itemtile:Init(cd)
    self.cd = cd
end

---更改默认cd
---@param cd integer
function lol_wp_cd_itemtile:ChangeCD(cd)
    self.cd = cd
end

---开始cd
---@param cd integer|nil # 不填用默认cd,填了则会更新默认cd
---@param start_without_onstartcdfn boolean # 不调用onstartcdfn
---@protected
function lol_wp_cd_itemtile:_StartCD(cd,start_without_onstartcdfn)
    -- 更新默认cd
    if cd then
        self.cd = cd
    end
    -- 停止之前的cd
    if self._task ~= nil then self._task:Cancel() self._task = nil end
    -- 开始新的cd
    if self.onstartcdfn then self.onstartcdfn(self.inst) end
    self.cur_cd = self.cd
    self._task = self.inst:DoPeriodicTask(1, function()
        self.cur_cd = math.max(0,self.cur_cd - 1)
        if self.cur_cd <= 0 then
            if self.onfinishcdfn then self.onfinishcdfn(self.inst) end
            if self._task ~= nil then self._task:Cancel() self._task = nil end
            return
        end
    end)
end

---强制开始cd
---@param cd integer|nil # 不填用默认cd,填了则会更新默认cd
function lol_wp_cd_itemtile:ForceStartCD(cd)
    self:_StartCD(cd,false)
end

---
---@return boolean
---@nodiscard
function lol_wp_cd_itemtile:IsCD()
    return self.cur_cd > 0
end

---当在cd中时修改剩余cd
---@param val integer
function lol_wp_cd_itemtile:SetCurCD(val)
    if self:IsCD() then
        self.cur_cd = val
    end
end

---设置开始cd时调用的函数
---@param fn fun(this:ent,...):...
function lol_wp_cd_itemtile:SetOnStartCD(fn)
    self.onstartcdfn = fn
end

---设置cd转好时调用的函数
---@param fn fun(this:ent,...):...
function lol_wp_cd_itemtile:SetOnFinishCD(fn)
    self.onfinishcdfn = fn
end

---是否显示在itemtile上,不设置默认显示
---@param shown boolean
function lol_wp_cd_itemtile:ShowItemTile(shown)
    self._show_itemtile = shown
end

return lol_wp_cd_itemtile