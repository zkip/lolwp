-- 统一处理官方方法

-- 目前所有物品 耐久耗尽 都会直接卸除 所以不用考虑 物品在眼石中的生效问题


--------------------------------------------------------------------------
-------------------------处理equippable.dapperness------------------------------
--------------------------------------------------------------------------
--[[ 
-- 物品栏也回san且有箭头
AddComponentPostInit("sanity", function(self)
    local old_custom_rate_fn = self.custom_rate_fn
    ---comment
    ---@param inst ent
    ---@param dt any
    ---@param ... unknown
    ---@return integer|unknown
    function self.custom_rate_fn(inst,dt,...)
        local res = old_custom_rate_fn ~= nil and old_custom_rate_fn(inst,dt,...) or 0
        for _,v in pairs(inst.eyestone_containers_stuff or {}) do
            local equippable = v and v.components.equippable
            if equippable ~= nil then
                local item_dapperness = self.get_equippable_dappernessfn ~= nil and self.get_equippable_dappernessfn(self.inst, equippable) or equippable:GetDapperness(self.inst, self.no_moisture_penalty)
                res = res + item_dapperness
            end
        end
        return res
    end
end)
]]

-- 由于都喜欢覆盖 ,所以上面的方法不能用了


-- 换了个方法,没想到吧 覆盖 never bother me anyway
AddComponentPostInit('equippable',function (self)
    local old_GetDapperness = self.GetDapperness
    ---comment
    ---@param owner ent
    ---@param ignore_wetness any
    ---@param ... unknown
    ---@return ...
    function self:GetDapperness(owner, ignore_wetness,...)
        local old_dapperness = old_GetDapperness(self,owner, ignore_wetness,...)
        -- 眼石装备单独计算
        if owner and owner.components.sanity and old_dapperness and self.inst:HasTag('lol_wp_eyestone') then
            for _,v in pairs(owner.eyestone_containers_stuff or {}) do
                local itm_old_dapperness = v and v.components.equippable and v.components.equippable.dapperness or 0
                old_dapperness = old_dapperness + itm_old_dapperness
            end
        end
        return old_dapperness
    end
end)



--------------------------------------------------------------------------
-------------------------处理shadowlevel------------------------------
--------------------------------------------------------------------------
-- 思路 将所有眼石中的物品的暗影等级叠加到眼石上面
AddComponentPostInit('shadowlevel',function (self)
    local old_GetCurrentLevel = self.GetCurrentLevel
    function self:GetCurrentLevel(...)
        ---@type ent
        local eyestone = self.inst
        local cur_level = 0
        if eyestone:HasTag('lol_wp_eyestone') and eyestone.components.container then
            local ents = eyestone.components.container:GetAllItems()
            for _,v in ipairs(ents) do
                if v.components.shadowlevel then
                    cur_level = cur_level + v.components.shadowlevel:GetCurrentLevel()
                end
            end
            return cur_level
        end
        return old_GetCurrentLevel(self,...)
    end

end)


