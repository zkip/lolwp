---@alias component_lol_wp_potion_drinker_potions string
---| "lol_wp_s16_potion_compound"
---| "lol_wp_s16_potion_corruption"
---| "lol_wp_s16_potion_hp"

---@class data_lol_wp_potion_drinker
---@field unique_type integer # > 0
---@field duration integer # 每瓶药水的时间
---@field max integer # 最大时间
---@field ondrinkoncefn fun(drinker:ent,potion:ent)|nil # 喝时执行,只执行一次
---@field ondrinkepersecfn fun(drinker:ent)|nil # 持续期间 每秒执行
---@field onbuffaddfn fun(drinker:ent)|nil # 添加时执行(包括读取)
---@field onbuffdonefn fun(drinker:ent)|nil # 结束时执行
---@field test_drink nil|fun(potion:ent):boolean # 客机是否允许动作

---@type table<component_lol_wp_potion_drinker_potions,data_lol_wp_potion_drinker>
local data = {
    lol_wp_s16_potion_hp = {
        unique_type = 1,
        duration = TUNING.MOD_LOL_WP.POTION_HP.DURATION,
        max = TUNING.MOD_LOL_WP.POTION_HP.MAX,
        ondrinkoncefn = function (drinker, potion)
            if LOLWP_S:checkAlive(drinker) then
                drinker.components.health:DoDelta(TUNING.MOD_LOL_WP.POTION_HP.DRINK_HP)
                if drinker.components.sanity then
                    drinker.components.sanity:DoDelta(TUNING.MOD_LOL_WP.POTION_HP.DRINK_SAN)
                end
            end
            LOLWP_S:consumeOneItem(potion)

            local debuff = drinker.components.debuffable ~= nil and drinker.components.debuffable:GetDebuff('buff_lol_wp_potion_hp') or nil
            if debuff then
                if debuff.components.timer then
                    local left = debuff.components.timer:GetTimeLeft('buffover')
                    local extend_time = math.min(TUNING.MOD_LOL_WP.POTION_HP.MAX,left + TUNING.MOD_LOL_WP.POTION_HP.DURATION)
                    debuff.components.timer:SetTimeLeft('buffover',extend_time)
                end
            else
                drinker:AddDebuff("buff_lol_wp_potion_hp", "buff_lol_wp_potion_hp")
            end
        end,
        ondrinkepersecfn = function (drinker)
            if LOLWP_S:checkAlive(drinker) then
                drinker.components.health:DoDelta(TUNING.MOD_LOL_WP.POTION_HP.DRINK_PERSEC_HP)
            end
        end
    },
    lol_wp_s16_potion_compound = {
        unique_type = 2,
        duration = TUNING.MOD_LOL_WP.POTION_COMPOUND.DURATION,
        max = TUNING.MOD_LOL_WP.POTION_COMPOUND.MAX,
        ondrinkoncefn = function (drinker, potion)
            if LOLWP_S:checkAlive(drinker) then
                drinker.components.health:DoDelta(TUNING.MOD_LOL_WP.POTION_COMPOUND.DRINK_HP)
                if drinker.components.sanity then
                    drinker.components.sanity:DoDelta(TUNING.MOD_LOL_WP.POTION_COMPOUND.DRINK_SAN)
                end
            end
            if potion.components.finiteuses then
                local cur_percent = potion.components.finiteuses:GetPercent()
                local use_percent = TUNING.MOD_LOL_WP.POTION_COMPOUND.DRINK_CONSUME_PERCENT
                potion.components.finiteuses:SetPercent(math.max(0, cur_percent - use_percent))
            end

            local debuff = drinker.components.debuffable ~= nil and drinker.components.debuffable:GetDebuff('buff_lol_wp_s16_potion_compound') or nil
            if debuff then
                if debuff.components.timer then
                    local left = debuff.components.timer:GetTimeLeft('buffover')
                    local extend_time = math.min(TUNING.MOD_LOL_WP.POTION_COMPOUND.MAX,left + TUNING.MOD_LOL_WP.POTION_COMPOUND.DURATION)
                    debuff.components.timer:SetTimeLeft('buffover',extend_time)
                end
            else
                drinker:AddDebuff("buff_lol_wp_s16_potion_compound", "buff_lol_wp_s16_potion_compound")
            end
        end,
        ondrinkepersecfn = function (drinker)
            if LOLWP_S:checkAlive(drinker) then
                drinker.components.health:DoDelta(TUNING.MOD_LOL_WP.POTION_COMPOUND.DRINK_PERSEC_HP)
            end
        end,
        test_drink = function (potion)
            local percentused = potion.replica.inventoryitem and potion.replica.inventoryitem.classified and potion.replica.inventoryitem.classified.percentused and potion.replica.inventoryitem.classified.percentused:value() or nil
            if percentused then
                local cur_percent = percentused / 100
                if cur_percent >= .5 then
                    return true
                end
            end
            return false
        end
    },
    lol_wp_s16_potion_corruption = {
        unique_type = 3,
        duration = TUNING.MOD_LOL_WP.POTION_CORRUPTION.DURATION,
        max = TUNING.MOD_LOL_WP.POTION_CORRUPTION.MAX,
        ondrinkoncefn = function (drinker, potion)
            if LOLWP_S:checkAlive(drinker) then
                drinker.components.health:DoDelta(TUNING.MOD_LOL_WP.POTION_CORRUPTION.DRINK_HP)
                if drinker.components.sanity then
                    drinker.components.sanity:DoDelta(TUNING.MOD_LOL_WP.POTION_CORRUPTION.DRINK_SAN)
                end
            end
            if potion.components.finiteuses then
                local cur_percent = potion.components.finiteuses:GetPercent()
                local use_percent = TUNING.MOD_LOL_WP.POTION_CORRUPTION.DRINK_CONSUME_PERCENT
                potion.components.finiteuses:SetPercent(math.max(0, cur_percent - use_percent))
            end

            local debuff = drinker.components.debuffable ~= nil and drinker.components.debuffable:GetDebuff('buff_lol_wp_s16_potion_corruption') or nil
            if debuff then
                if debuff.components.timer then
                    local left = debuff.components.timer:GetTimeLeft('buffover')
                    local extend_time = math.min(TUNING.MOD_LOL_WP.POTION_CORRUPTION.MAX,left + TUNING.MOD_LOL_WP.POTION_CORRUPTION.DURATION)
                    debuff.components.timer:SetTimeLeft('buffover',extend_time)
                end
            else
                drinker:AddDebuff("buff_lol_wp_s16_potion_corruption", "buff_lol_wp_s16_potion_corruption")
            end
        end,
        ondrinkepersecfn = function (drinker)
            if LOLWP_S:checkAlive(drinker) then
                drinker.components.health:DoDelta(TUNING.MOD_LOL_WP.POTION_CORRUPTION.DRINK_PERSEC_HP)
                if drinker.components.sanity then
                    drinker.components.sanity:DoDelta(TUNING.MOD_LOL_WP.POTION_CORRUPTION.DRINK_PERSEC_SAN)
                end
            end
        end,
        onbuffaddfn = function (drinker)
            if drinker.components.lol_wp_player_dmg_adder then
                drinker.components.lol_wp_player_dmg_adder:Modifier('lol_wp_s16_potion_corruption',15,'lol_wp_s16_potion_corruption','planar')
            end
        end,
        onbuffdonefn = function (drinker)
            if drinker.components.lol_wp_player_dmg_adder then
                drinker.components.lol_wp_player_dmg_adder:RemoveModifier('lol_wp_s16_potion_corruption','lol_wp_s16_potion_corruption','planar')
            end
            drinker:AddDebuff('buff_lol_wp_s16_potion_corruption_after_debuff','buff_lol_wp_s16_potion_corruption_after_debuff')
        end,
        test_drink = function (potion)
            local percentused = potion.replica.inventoryitem and potion.replica.inventoryitem.classified and potion.replica.inventoryitem.classified.percentused and potion.replica.inventoryitem.classified.percentused:value() or nil
            if percentused then
                local cur_percent = percentused / 100
                if cur_percent >= .33 then
                    return true
                end
            end
            return false
        end
    },
}

return data