local LOL_WP_TERRAPRISMA_NUMBER = 3

local dagger_auto_atk = true -- 飞刀是否允许自动攻击

---@class components
---@field lol_wp_trinity_data component_lol_wp_trinity_data

-- local function on_val(self, value)
    -- self.inst.replica.lol_wp_trinity_data:SetVal(value)
-- end

---@class component_lol_wp_trinity_data
local lol_wp_trinity_data = Class(function(self, inst)
    self.inst = inst
    -- self.val = 0
end,
nil,
{
    -- val = on_val,
})

-- function lol_wp_trinity_data:OnSave()
--     return {
--         -- val = self.val
--     }
-- end

-- function lol_wp_trinity_data:OnLoad(data)
--     -- self.val = data.val or 0
-- end


local function trinity_heal(inst,owner,heal_or_stop)
    if heal_or_stop then
        if inst.taskintime_lol_wp_trinity_regen == nil then
            inst.taskintime_lol_wp_trinity_regen = inst:DoPeriodicTask(TUNING.MOD_LOL_WP.TRINITY.HEAL_INTERVAL,function()
                if owner and owner:IsValid() and owner.components.health and not owner.components.health:IsDead() then
                    owner.components.health:DoDelta(TUNING.MOD_LOL_WP.TRINITY.HEAL_HP)
                end
            end)
        end
    else
        if inst.taskintime_lol_wp_trinity_regen then
            inst.taskintime_lol_wp_trinity_regen:Cancel()
            inst.taskintime_lol_wp_trinity_regen = nil
        end
    end
end


local function playeronattackother(inst,data)

    -- 玩家不维持攻击则飞刃停止持续攻击,但是要筛选掉飞刃的攻击
    local stimuli = data and data.stimuli
    if stimuli == nil or stimuli ~= 'lol_wp_trinity_terraprisma' then

        inst.lol_wp_trinity_keepatking = true
        if inst.taskintime_lol_wp_trinity_cancel_keepatk then
            inst.taskintime_lol_wp_trinity_cancel_keepatk:Cancel()
            inst.taskintime_lol_wp_trinity_cancel_keepatk = nil
        end
        -- if not dagger_auto_atk then
            inst.taskintime_lol_wp_trinity_cancel_keepatk = inst:DoTaskInTime(.5,function ()
                inst.lol_wp_trinity_keepatking = false
            end)
        -- end
        -- 启动飞刃
        local target = data and data.target
        if target and target:IsValid() and target.components.health and not target.components.health:IsDead() and target.components.combat then
            if inst.isequip_lol_wp_trinity_weapon then
                local wp = inst.isequip_lol_wp_trinity_item_weapon
                if wp then
                    for index, value in ipairs(wp.summons or {}) do
                        if value and value:IsValid() then
                            value.components.summon_controller:PlzKeepAtk()
                            value:Shoot(target)
                        end
                    end
                end
            end

            if inst.isequip_lol_wp_trinity_item_amulet then
                local amulet = inst.isequip_lol_wp_trinity_item_amulet
                if amulet then
                    for index, value in ipairs(amulet.summons or {}) do
                        if value and value:IsValid() then
                            value.components.summon_controller:PlzKeepAtk()
                            value:Shoot(target)
                        end
                    end
                end
            end

        end
    end
end

---comment
---@param inst ent
---@param owner any
local function whenequip(inst, owner)
    --避免未知原因导致的重复召唤
    if inst.summons then
        for index, value in ipairs(inst.summons) do
            if value and value:IsValid() then
                value:Remove()
            end
        end
    end

    local skin = inst:GetSkinName()
    local dagger_prefab = 'lol_wp_terraprisma'
    if skin then
        if skin == 'lol_wp_trinity_skin_moonphase' then
            dagger_prefab = 'lol_wp_terraprisma_skin_moonphase'
        elseif skin == 'lol_wp_trinity_skin_needle_cluster_burst' then
            dagger_prefab = 'lol_wp_terraprisma_skin_needle_cluster_burst'
        end
    end

    --初始化召唤物
    inst.summons={}
    for i = 1, LOL_WP_TERRAPRISMA_NUMBER, 1 do
        -- local colour_i = (i%6 == 0 and 6) or i%6
        
        inst.summons[i]=SpawnPrefab(dagger_prefab)
        if inst.lol_wp_trinity_type then
            if inst.lol_wp_trinity_type == 'weapon' then
                inst.summons[i].custom_dmg = TUNING.MOD_LOL_WP.TRINITY.DMG
                inst.summons[i].lol_wp_trinity_type = 'weapon'
            elseif inst.lol_wp_trinity_type == 'amulet' then
                inst.summons[i].custom_dmg = TUNING.MOD_LOL_WP.TRINITY.DMG_WHEN_AMULET
                inst.summons[i].lol_wp_trinity_type = 'amulet'
            end
        end

        -- if inst.lol_wp_trinity_type then
        --     if inst.lol_wp_trinity_type == 'weapon' then
        --         if LOL_WP_TERRAPRISMA_NUMBER == 3 then
        --             inst.summons[i].custom_dmg = TUNING.MOD_LOL_WP.TRINITY.DMG
        --         elseif LOL_WP_TERRAPRISMA_NUMBER == 6 then
        --             if i <= 3 then
        --                 inst.summons[i].custom_dmg = TUNING.MOD_LOL_WP.TRINITY.DMG
        --             else
        --                 inst.summons[i].custom_dmg = TUNING.MOD_LOL_WP.TRINITY.DMG_WHEN_AMULET
        --             end
        --         end
        --     elseif inst.lol_wp_trinity_type == 'amulet' then
        --         if LOL_WP_TERRAPRISMA_NUMBER == 3 then
        --             inst.summons[i].custom_dmg = TUNING.MOD_LOL_WP.TRINITY.DMG_WHEN_AMULET
        --         elseif LOL_WP_TERRAPRISMA_NUMBER == 6 then
        --             if i <= 3 then
        --                 inst.summons[i].custom_dmg = TUNING.MOD_LOL_WP.TRINITY.DMG
        --             else
        --                 inst.summons[i].custom_dmg = TUNING.MOD_LOL_WP.TRINITY.DMG_WHEN_AMULET
        --             end
        --         end
        --     end
        -- end
        --Init(player,offset,weapon,id)
        inst.summons[i].components.summon_controller:Init(owner,inst,i)
    end
    --用于ui刷新
    -- if owner._equip_terraprisma then
    --     owner._equip_terraprisma:set(true)
    -- end
    --某些情况下，装备者不是玩家，那就默认自动攻击
    if owner.terraprisma_auto==nil then
        owner.terraprisma_auto=false
    end
end

local function whenunequip(inst,owner)
    --移除召唤物
    for index, value in ipairs(inst.summons or {}) do
        if value and value:IsValid() then
            value:Remove()
        end
    end
    --用于ui刷新
    if owner._equip_terraprisma then
        owner._equip_terraprisma:set(false)
    end
end

function lol_wp_trinity_data:onequip(inst, owner)

    if inst.lol_wp_trinity_type == 'weapon' then
        owner.isequip_lol_wp_trinity_weapon = true
        owner.isequip_lol_wp_trinity_item_weapon = inst

        local skin_build = inst:GetSkinBuild()
        if skin_build ~= nil then
            owner:PushEvent("equipskinneditem", inst:GetSkinName())
            -- owner.AnimState:OverrideItemSkinSymbol("swap_object", "swap_"..skin_build, "swap_"..skin_build, inst.GUID, "swap_"..prefab_id)
        else
            -- owner.AnimState:OverrideSymbol("swap_object", "swap_"..prefab_id, "swap_"..prefab_id)
        end

    elseif inst.lol_wp_trinity_type == 'amulet' then
        owner.isequip_lol_wp_trinity_amulet = true
        owner.isequip_lol_wp_trinity_item_amulet = inst
    end

    owner:RemoveEventCallback('onhitother',playeronattackother)
    inst:DoTaskInTime(0,function()
        owner:ListenForEvent('onhitother',playeronattackother) -- 用onhitother,不要用onattackother,因为后者会miss
    end)


    -- inst.Light:Enable(true)

    if inst.lol_wp_trinity_type and inst.lol_wp_trinity_type == 'amulet' then
        trinity_heal(inst,owner,true)
    end


    -- inst.components.lol_wp_trinity_parts:genParts()
    -- inst.components.lol_wp_trinity_parts:faceDown()
    -- inst.components.lol_wp_trinity_parts:setState('surround')

    if owner.lol_wp_trinity_equip_num == nil then
        owner.lol_wp_trinity_equip_num = 1
    else
        owner.lol_wp_trinity_equip_num = owner.lol_wp_trinity_equip_num + 1
    end

    -- LOL_WP_TERRAPRISMA_NUMBER = owner.lol_wp_trinity_equip_num == 1 and 3 or 6


    inst.lol_wp_trinity_prisma_num = LOL_WP_TERRAPRISMA_NUMBER

    inst:DoTaskInTime(0, function()
        whenequip(inst, owner)
    end)

end

function lol_wp_trinity_data:onunequip(inst, owner)
    if inst.lol_wp_trinity_type == 'weapon' then
        owner.AnimState:Hide("ARM_carry")
        owner.AnimState:Show("ARM_normal")

        local skin_build = inst:GetSkinBuild()
        if skin_build ~= nil then
            owner:PushEvent("unequipskinneditem", inst:GetSkinName())
        end
    end

    if inst.lol_wp_trinity_type == 'weapon' then
        owner.isequip_lol_wp_trinity_weapon = false
    elseif inst.lol_wp_trinity_type == 'amulet' then
        owner.isequip_lol_wp_trinity_amulet = false
    end

    -- 两件都移除才移除监听
    if not owner.isequip_lol_wp_trinity_weapon and not owner.isequip_lol_wp_trinity_amulet then
        owner:RemoveEventCallback('onhitother',playeronattackother)
    end


    if owner.lol_wp_trinity_equip_num then
        owner.lol_wp_trinity_equip_num = owner.lol_wp_trinity_equip_num - 1
    end

    -- inst.Light:Enable(false)

    if inst.lol_wp_trinity_type == 'amulet' then
        trinity_heal(inst,owner,false)
    end


    -- inst.components.lol_wp_trinity_parts:removeParts()
    whenunequip(inst,owner)
end

return lol_wp_trinity_data