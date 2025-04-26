---@class components
---@field lol_wp_potion_drinker component_lol_wp_potion_drinker

local data = require('core_lol_wp/data/lol_wp_potion')

local reverse_unique_type = {}
for k,v in pairs(data) do
    reverse_unique_type[v.unique_type] = k
end

local function on_unique_type(self,value)
    self.inst.replica.lol_wp_potion_drinker:SetType(value)
end

---@class component_lol_wp_potion_drinker
---@field inst ent
---@field duration integer # 剩余时间
---@field _task Periodic|nil # 定时器
---@field unique_type integer # 唯一类型, 从0开始, 0代表没有使用任何药水
local lol_wp_potion_drinker = Class(
---@param self component_lol_wp_potion_drinker
---@param inst ent
function(self, inst)
    self.inst = inst

    self.unique_type = 0

    self.duration = 0
    self._task = nil

    for k,v in pairs(data) do
        self[k] = false
    end


end,
nil,
{
    unique_type = on_unique_type,
})

function lol_wp_potion_drinker:OnSave()
    local save_data = {}
    save_data.unique_type = self.unique_type
    save_data.duration = self.duration

    return save_data
end

function lol_wp_potion_drinker:OnLoad(save_data)
    self.unique_type = save_data and save_data.unique_type or 0
    self.duration = save_data and save_data.duration or 0

    self:_Continue()
end

---comment
---@param potion ent
function lol_wp_potion_drinker:Drink(potion)
    if potion.components.lol_wp_potion_drinkable and potion.prefab and data[potion.prefab] then
        local ondrinkepersecfn = data[potion.prefab].ondrinkepersecfn
        local potion_duration = data[potion.prefab].duration
        local potion_max = data[potion.prefab].max

        -- 开始时执行
        local onbuffaddfn = data[potion.prefab].onbuffaddfn
        if onbuffaddfn then
            onbuffaddfn(self.inst)
        end

        -- 设置唯一类型
        self.unique_type = data[potion.prefab].unique_type

        -- 如果计时器不存在,则正常计时
        if self._task == nil then
            self.duration = potion_duration

            local heal_per = 2 -- 每?秒执行
            self._task = self.inst:DoPeriodicTask(1, function()
                self.duration = math.max(0,self.duration - 1)
                heal_per = heal_per - 1
                if self.duration <= 0 then
                    -- 结束时 unique_type 归0
                    self.unique_type = 0
                    -- buff结束时执行
                    local onbuffdonefn = data[potion.prefab].onbuffdonefn
                    if onbuffdonefn then
                        onbuffdonefn(self.inst)
                    end
                    if self._task ~= nil  then
                        self._task:Cancel()
                        self._task = nil
                    end
                else
                    -- 每?秒执行
                    if heal_per <= 0 then
                        heal_per = 2
                        if ondrinkepersecfn then
                            ondrinkepersecfn(self.inst)
                        end
                    end
                end
            end)
        else
            -- 如果计时器存在,则增加时间
            self.duration = math.min(potion_max,self.duration + potion_duration)
        end

        -- 引用回调函数
        local ondrinkoncefn = data[potion.prefab].ondrinkoncefn
        if ondrinkoncefn then
            ondrinkoncefn(self.inst,potion)
        end

        return true
    end
    return true
end

---读取时执行
function lol_wp_potion_drinker:_Continue()
    -- 如果没有在引用药水 则返回
    if self.unique_type == 0 then
        return
    end
    -- 读取药水信息
    local potion_prefab = reverse_unique_type[self.unique_type]
    if potion_prefab then
        local onbuffaddfn = data[potion_prefab].onbuffaddfn
        if onbuffaddfn then
            onbuffaddfn(self.inst)
        end
        local ondrinkepersecfn = data[potion_prefab].ondrinkepersecfn
        self._task = self.inst:DoPeriodicTask(1, function()
            self.duration = math.max(0,self.duration - 1)
            if self.duration <= 0 then
                -- 结束时 unique_type 归0
                self.unique_type = 0
                -- buff结束时执行
                local onbuffdonefn = data[potion_prefab].onbuffdonefn
                if onbuffdonefn then
                    onbuffdonefn(self.inst)
                end
                if self._task ~= nil  then
                    self._task:Cancel()
                    self._task = nil
                end
            else
                -- 每秒执行
                if ondrinkepersecfn then
                    ondrinkepersecfn(self.inst)
                end
            end
        end)
    end
end

return lol_wp_potion_drinker