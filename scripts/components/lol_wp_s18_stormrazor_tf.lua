local db = TUNING.MOD_LOL_WP.STORMRAZOR

---@class components
---@field lol_wp_s18_stormrazor_tf component_lol_wp_s18_stormrazor_tf

-- local function on_val(self, value)
    -- self.inst.replica.lol_wp_s18_stormrazor_tf:SetVal(value)
-- end

---@class component_lol_wp_s18_stormrazor_tf
---@field inst ent
local lol_wp_s18_stormrazor_tf = Class(

---@param self component_lol_wp_s18_stormrazor_tf
---@param inst ent
function(self, inst)
    self.inst = inst
    -- self.val = 0
end,
nil,
{
    -- val = on_val,
})

-- function lol_wp_s18_stormrazor_tf:OnSave()
--     return {
--         -- val = self.val
--     }
-- end

-- function lol_wp_s18_stormrazor_tf:OnLoad(data)
--     -- self.val = data.val or 0
-- end

---comment
---@param doer ent
---@return boolean
function lol_wp_s18_stormrazor_tf:DoTF(doer)
    local wp = self.inst
    -- 拔刀
    if wp.prefab == 'lol_wp_s18_stormrazor' then
        -- 数据传递
        -- 1. 耐久
        local cur_finiteuse = wp.components.finiteuses and wp.components.finiteuses:GetPercent() or nil
        -- 2. 被动：【电冲】 CD
        local cur_charge = wp.components.rechargeable and not wp.components.rechargeable:IsCharged() and wp.components.rechargeable:GetCharge()

        wp:Remove()

        local newone = SpawnPrefab('lol_wp_s18_stormrazor_nosaya')

        if doer.components.inventory then
            doer.components.inventory:GiveItem(newone)
            doer.components.inventory:Equip(newone)
        end
        if cur_finiteuse and newone.components.finiteuses then
            newone.components.finiteuses:SetPercent(cur_finiteuse)
        end
        if cur_charge and newone.components.rechargeable then
            newone.components.rechargeable:Discharge(db.SKILL_ELECTRICSLASH.CD)
            newone.components.rechargeable:SetCharge(cur_charge,true)
        end


        return true
    else
        -- 收刀
        -- 数据传递
        -- 1. 耐久
        local cur_finiteuse = wp.components.finiteuses and wp.components.finiteuses:GetPercent() or nil
        -- 2. 被动：【电冲】 CD
        local cur_charge = wp.components.rechargeable and not wp.components.rechargeable:IsCharged() and wp.components.rechargeable:GetCharge()

        -- LOLWP_S:unequipItem(wp)

        -- 懂得都懂
        doer:DoTaskInTime(0,function ()
            wp:Remove()

            local newone = SpawnPrefab('lol_wp_s18_stormrazor')

            if doer.components.inventory then
                doer.components.inventory:GiveItem(newone)
            end
            if cur_finiteuse and newone.components.finiteuses then
                newone.components.finiteuses:SetPercent(cur_finiteuse)
            end
            if cur_charge and newone.components.rechargeable then
                newone.components.rechargeable:Discharge(db.SKILL_ELECTRICSLASH.CD)
                newone.components.rechargeable:SetCharge(cur_charge,true)
            end
        end)

        return true
    end
end

return lol_wp_s18_stormrazor_tf