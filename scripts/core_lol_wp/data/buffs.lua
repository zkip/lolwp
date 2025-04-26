
---@type data_buff[]
local data = {
    {
        id = 'lol_wp_potion_hp',
        onattachedfn = function(inst, target, name)
        end,
        ondetachedfn = function (inst, target, id)
        end,
        onextendedfn = function (inst, target, id)
        end,
        duration = TUNING.MOD_LOL_WP.POTION_HP.DURATION,
        buff_string = STRINGS.MOD_LOL_WP.BUFF.lol_wp_potion_hp.name,
        attached_string = STRINGS.MOD_LOL_WP.BUFF.lol_wp_potion_hp.attached,
        detached_string = STRINGS.MOD_LOL_WP.BUFF.lol_wp_potion_hp.detached,
    },
    {
        id = 'lol_wp_s16_potion_compound',
        onattachedfn = function(inst, target, name)
        end,
        ondetachedfn = function (inst, target, id)
        end,
        onextendedfn = function (inst, target, id)
        end,
        duration = TUNING.MOD_LOL_WP.POTION_COMPOUND.DURATION,
        buff_string = STRINGS.MOD_LOL_WP.BUFF.lol_wp_s16_potion_compound.name,
        attached_string = STRINGS.MOD_LOL_WP.BUFF.lol_wp_s16_potion_compound.attached,
        detached_string = STRINGS.MOD_LOL_WP.BUFF.lol_wp_s16_potion_compound.detached,
    },
    {
        id = 'lol_wp_s16_potion_corruption',
        onattachedfn = function(inst, target, name)
        end,
        ondetachedfn = function (inst, target, id)
        end,
        onextendedfn = function (inst, target, id)
        end,
        duration = TUNING.MOD_LOL_WP.POTION_CORRUPTION.DURATION,
        buff_string = STRINGS.MOD_LOL_WP.BUFF.lol_wp_s16_potion_corruption.name,
        attached_string = STRINGS.MOD_LOL_WP.BUFF.lol_wp_s16_potion_corruption.attached,
        detached_string = STRINGS.MOD_LOL_WP.BUFF.lol_wp_s16_potion_corruption.detached,
    },
    {
        id = 'lol_wp_s16_potion_corruption_after_debuff',
        onattachedfn = function(inst, target, name)
            if target.components.locomotor then
                target._lol_wp_s16_potion_corruption_after_debuff_self = inst
                target.components.locomotor:SetExternalSpeedMultiplier(inst,'lol_wp_s16_potion_corruption_after_debuff',TUNING.MOD_LOL_WP.POTION_CORRUPTION.DONE_DEBUFF_WALKSPEEDMULT)
            end
            target:AddOrRemoveTag('groggy',true)
        end,
        ondetachedfn = function (inst, target, id)
            if target.components.locomotor then
                target._lol_wp_s16_potion_corruption_after_debuff_self = nil
                target.components.locomotor:RemoveExternalSpeedMultiplier(inst,'lol_wp_s16_potion_corruption_after_debuff')
            end
            target:AddOrRemoveTag('groggy',false)
        end,
        onextendedfn = function (inst, target, id)
        end,
        duration = TUNING.MOD_LOL_WP.POTION_CORRUPTION.DONE_DEBUFF_DURATION,
        buff_string = STRINGS.MOD_LOL_WP.BUFF.lol_wp_s16_potion_corruption_after_debuff.name,
        attached_string = STRINGS.MOD_LOL_WP.BUFF.lol_wp_s16_potion_corruption_after_debuff.attached,
        detached_string = STRINGS.MOD_LOL_WP.BUFF.lol_wp_s16_potion_corruption_after_debuff.detached,
    },
}


return data