local data = require('core_lol_wp/data/player_timer')



---@class components
---@field player_timer component_player_timer

-- local function on_val(self, value)
    -- self.inst.replica.player_timer:SetVal(value)
-- end

---@class component_player_timer
---@field inst ent
---@field _timer {rechargeable:table<player_timer_rechargeable_prefab,Periodic|nil>, lol_wp_cd_itemtile:table<player_timer_lol_wp_cd_itemtile_prefab,Periodic|nil>, gallop_brokenking_frogblade_cd:table<player_timer_gallop_brokenking_frogblade_cd_prefab,Periodic|nil>}
---@field rechargeable table<player_timer_rechargeable_prefab,integer>
---@field cd_for_rechargeable table<player_timer_rechargeable_prefab,number>
---@field lol_wp_cd_itemtile table<player_timer_lol_wp_cd_itemtile_prefab,integer>
---@field cd_for_lol_wp_cd_itemtile table<player_timer_lol_wp_cd_itemtile_prefab,number>
---@field gallop_brokenking_frogblade_cd table<player_timer_gallop_brokenking_frogblade_cd_prefab,integer>
---@field cd_for_gallop_brokenking_frogblade_cd table<player_timer_gallop_brokenking_frogblade_cd_prefab,number>
local player_timer = Class(
---@param self component_player_timer
---@param inst ent
function(self, inst)
    self.inst = inst
    -- self.val = 0
    self._timer = {
        rechargeable = {},
        lol_wp_cd_itemtile = {},
        gallop_brokenking_frogblade_cd = {},
    }

    self.rechargeable = {}
    self.cd_for_rechargeable = {}
    for k,_ in pairs(data.rechargeable.members) do
        self.rechargeable[k] = 0
    end

    self.lol_wp_cd_itemtile = {}
    self.cd_for_lol_wp_cd_itemtile = {}
    for k,_ in pairs(data.lol_wp_cd_itemtile.members) do
        self.lol_wp_cd_itemtile[k] = 0
    end

    self.gallop_brokenking_frogblade_cd = {}
    self.cd_for_gallop_brokenking_frogblade_cd = {}
    for k,_ in pairs(data.gallop_brokenking_frogblade_cd.members) do
        self.gallop_brokenking_frogblade_cd[k] = 0
    end
    
end,
nil,
{
    -- val = on_val,
})

function player_timer:OnSave()
    local save = {}
    save.rechargeable = {}
    save.cd_for_rechargeable = {}
    for k,v in pairs(self.rechargeable) do
        save.rechargeable[k] = v
    end
    for k,v in pairs(self.cd_for_rechargeable) do
        save.cd_for_rechargeable[k] = v
    end

    save.lol_wp_cd_itemtile = {}
    save.cd_for_lol_wp_cd_itemtile = {}
    for k,v in pairs(self.lol_wp_cd_itemtile) do
        save.lol_wp_cd_itemtile[k] = v
    end
    for k,v in pairs(self.cd_for_lol_wp_cd_itemtile or {}) do
        save.cd_for_lol_wp_cd_itemtile[k] = v
    end

    save.gallop_brokenking_frogblade_cd = {}
    save.cd_for_gallop_brokenking_frogblade_cd = {}
    for k,v in pairs(self.gallop_brokenking_frogblade_cd) do
        save.gallop_brokenking_frogblade_cd[k] = v
    end
    for k,v in pairs(self.cd_for_gallop_brokenking_frogblade_cd or {}) do
        save.cd_for_gallop_brokenking_frogblade_cd[k] = v
    end

    return save
end

---comment
---@param save_data table
function player_timer:OnLoad(save_data)
    if save_data then
        -- self.val = data.val or 0
        for k,v in pairs(save_data.rechargeable or {}) do
            self.rechargeable[k] = v
            if v > 0 then
                self:StartTimer('rechargeable',k,v)
            end
        end
        for k,v in pairs(save_data.cd_for_rechargeable or {}) do
            self.cd_for_rechargeable[k] = v
        end
        ---------------------
        for k,v in pairs(save_data.lol_wp_cd_itemtile or {}) do
            self.lol_wp_cd_itemtile[k] = v
            if v > 0 then
                self:StartTimer('lol_wp_cd_itemtile',k,v)
            end
        end
        for k,v in pairs(save_data.cd_for_lol_wp_cd_itemtile or {}) do
            self.cd_for_lol_wp_cd_itemtile[k] = v
        end
        ---------------------
        for k,v in pairs(save_data.gallop_brokenking_frogblade_cd or {}) do
            self.gallop_brokenking_frogblade_cd[k] = v
            if v > 0 then
                self:StartTimer('gallop_brokenking_frogblade_cd',k,v)
            end
        end
        for k,v in pairs(save_data.cd_for_gallop_brokenking_frogblade_cd or {}) do
            self.cd_for_gallop_brokenking_frogblade_cd[k] = v
        end
    end

end

---开始指定物品的cd
---@param group player_timer_group
---@param prefab string
---@param seconds integer
---@param item ent
function player_timer:WhenItemCD(group,prefab,seconds,item)
    local player = self.inst
    -- 存一次该物品的总cd
    self['cd_for_'..group][prefab] = seconds
    -- 如果组别中没有这个物品的计时器(即不在cd中)，则创建一个, 并且在cd结束后,销毁这个计时器
    if self._timer[group][prefab] == nil then
        self:StartTimer(group,prefab,seconds)
        -- 让物品正常进行cd
        -- local items = self.inst.components.inventory and self.inst.components.inventory:GetItemByName(prefab,999,true)
        -- local itm_fn = data[group].fn
        -- if itm_fn then
        --     for ent,_ in pairs(items) do
        --         if ent ~= item then -- 如果不是当前物品，则进行cd
        --             itm_fn(group,prefab,seconds,ent,self.inst,seconds)
        --         end
        --     end
        -- end

        -- 也许有箱子能放进库存,里面的东西也要cd
        player.components.inventory:FindItems(function (element)
            if element ~= item then
                if element.prefab == prefab then
                    local itm_fn = data[group].fn
                    if itm_fn then
                        itm_fn(group,prefab,seconds,element,player,seconds)
                    end
                    return false
                else
                    if element.components.container then
                        element.components.container:FindItems(function (element_in_container)
                            if element_in_container.prefab == prefab then
                                local itm_fn = data[group].fn
                                if itm_fn then
                                    itm_fn(group,prefab,seconds,element_in_container,player,seconds)
                                end
                            end
                            return false
                        end)
                        return true
                    end
                end
            end
            return false
        end)
    end
end

---当获取到物品
---@param group player_timer_group
---@param prefab string
---@param item ent
function player_timer:WhenGetItem(group,prefab,item)
    -- 如果组别中没有这个物品的计时器(即不在cd中)
    -- if timer[group][prefab] == nil then
        -- 玩家的cd在不在转,并且该物品的总cd已经被获取过(也就是转过一次cd)
        if self[group][prefab] > 0 and self['cd_for_'..group][prefab] then
            -- 让物品正常进行cd
            local itm_fn = data[group].fn
            if itm_fn then
                itm_fn(group,prefab,self['cd_for_'..group][prefab],item,self.inst,self[group][prefab])
            end
        else
            -- 如果玩家不在cd,那么立即转好物品的cd
            local fn_resetcd = data[group].fn_resetcd
            if fn_resetcd then
                fn_resetcd(group,prefab,item,self.inst)
            end
        end
    -- end
end

---开始指定物品的cd
---@param group player_timer_group
---@param prefab string 
---@param seconds integer
function player_timer:StartTimer(group,prefab,seconds)
    if self._timer[group][prefab] ~= nil then
        self._timer[group][prefab]:Cancel()
        self._timer[group][prefab] = nil
    end
    -- self[group][prefab] = seconds - 1 -- 貌似会慢一秒,所这里减1
    self[group][prefab] = seconds
    self._timer[group][prefab] = self.inst:DoPeriodicTask(1, function()
        self[group][prefab] = math.max(0,self[group][prefab] - 1)
        if self[group][prefab] <= 0 then
            if self._timer[group][prefab] ~= nil then
                self._timer[group][prefab]:Cancel()
                self._timer[group][prefab] = nil
            end
            return
        end
    end)
end

---重置cd
---@param group player_timer_group
---@param prefab string
function player_timer:ResetTimer(group,prefab)
    self[group][prefab] = 0
end



return player_timer