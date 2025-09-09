local utils_equippable = require("utils/equippable")
local resolve_combat_modifiers = require("combat_resolver")
local status_resolver = require("status_resolver")

local item_database = require("item_database")

AddPrefabPostInitAny(function (prefab)
    if not TheWorld.ismastersim then return end

    if prefab.components.inventory then
        prefab:AddComponent("lolwp_equip_provider")
    end

    -- if prefab.components.combat or prefab.components.health or prefab.components.sanity or prefab.components.lootdropper then
    -- end
    prefab:AddComponent("lolwp_passive_owner")
    prefab:AddComponent("lolwp_buff_owner")
end)

AddComponentPostInit('combat',function (self)
    if not TheWorld.ismastersim then return end

    local GetAttacked = self.GetAttacked
    function self:GetAttacked(attacker, damage, weapon, stimuli, spdamage, ...)
        local target = self.inst
        local attacker_passive_owner = attacker and attacker.components.lolwp_passive_owner
        local target_passive_owner = target.components.lolwp_passive_owner
        local attacker_buff_owner = attacker and attacker.components.lolwp_buff_owner
        local target_buff_owner = target.components.lolwp_buff_owner

        local owners = {
            attacker_passive_owner = attacker_passive_owner,
            target_passive_owner = target_passive_owner,
            attacker_buff_owner = attacker_buff_owner,
            target_buff_owner = target_buff_owner,
        }

        local combat_args = {
            attacker = attacker, target = target,
            damage = damage, weapon = weapon, stimuli = stimuli, spdamage = spdamage
        }

        -- TODO: 提供外部拓展的方式
        local resolved_combat_args = resolve_combat_modifiers(owners, combat_args)

        return GetAttacked(self, attacker,
            resolved_combat_args.damage, weapon,
            resolved_combat_args.stimuli, resolved_combat_args.spdamage, ...)
    end
end)

-- 记录战斗中和结束一些额外的信息，如参与者等，以及触发 WhenKill
AddComponentPostInit('combat',function (self)
    if not TheWorld.ismastersim then return end

    -- TODO: 考虑遗忘途径
    self.lolwp_attackers = { }
    self.lolwp_killer = nil
    local GetAttacked = self.GetAttacked
    function self:GetAttacked(attacker, damage, weapon, stimuli, spdamage, ...)
        -- 记录攻击过自己的单位
        if attacker then self.lolwp_attackers[attacker] = attacker end
        return GetAttacked(self, attacker, damage, weapon, stimuli, spdamage, ...)
    end
end)

AddComponentPostInit("health", function (health)
    if not TheWorld.ismastersim then return end
    
    local SetVal = health.SetVal

    function health:SetVal(value, cause, afflicter, ...)
        SetVal(self, value, cause, afflicter, ...)
        if self:IsDead() then
            local victim = self.inst
            local killer = afflicter
            local victim_combat = victim.components.combat
            local attackers = victim_combat and victim_combat.lolwp_attackers or { }

            if victim_combat then victim_combat.lolwp_killer = killer end

            local victim_passive_owner = victim.components.lolwp_passive_owner
            local victim_buff_owner = victim.components.lolwp_buff_owner
            for _, side_attacker in pairs(attackers) do
                local attacker_passive_owner = side_attacker and side_attacker.components.lolwp_passive_owner
                local attacker_buff_owner = side_attacker and side_attacker.components.lolwp_buff_owner

                -- 请注意 attackers 中包含了 killer
                if attacker_passive_owner then
                    attacker_passive_owner:Trigger("WhenKill", victim, killer, attackers)
                end
                if attacker_buff_owner then
                    attacker_buff_owner:Trigger("WhenKill", victim, killer, attackers)
                end
            end

            if victim_passive_owner then
                victim_passive_owner:Trigger("WhenDeath", killer, attackers)
            end
            if victim_buff_owner then
                victim_buff_owner:Trigger("WhenDeath", killer, attackers)
            end
        end
    end
end)

AddComponentPostInit("health", function(health)
    if not TheWorld.ismastersim then return end
    
    local DoDelta = health.DoDelta
    function health:DoDelta(amount, ...)
        local owner = self.inst
        
        local passive_owner = owner.components.lolwp_passive_owner
        local buff_owner = owner.components.lolwp_buff_owner

        local resolved_delta_amount = 0
        if passive_owner and buff_owner then
            local owners = { passive_owner = passive_owner, buff_owner = buff_owner }
    
            -- TODO: 提供外部拓展的方式
            resolved_delta_amount = status_resolver.health_delta(owners, amount)
        end

		return DoDelta(self, resolved_delta_amount, ...)
    end
end)

AddComponentPostInit("sanity", function(sanity)
    if not TheWorld.ismastersim then return end
    
    local custom_rate_fn = sanity.custom_rate_fn
    function sanity.custom_rate_fn(inst, dt, ...)
        local sanity_rate = custom_rate_fn ~= nil and custom_rate_fn(inst, dt, ...) or 0

        local passive_owner = inst.components.lolwp_passive_owner
        local buff_owner = inst.components.lolwp_buff_owner

        local owners = { passive_owner = passive_owner, buff_owner = buff_owner }

        -- TODO: 提供外部拓展的方式
        local resolved_sanity_rate = status_resolver.sanity_rate(owners, sanity_rate)
        
        return resolved_sanity_rate
    end
end)

AddComponentPostInit('lootdropper', function(lootdropper)
    if not TheWorld.ismastersim then return end
    
    local lootsetupfn = lootdropper.lootsetupfn

    function lootdropper:SetLootSetupFn(...)
        local results = lootsetupfn ~= nil and {lootsetupfn(self, ...)} or { }

        local victim = self.inst
        local combat = victim.components.combat
        local killer = combat and combat.lolwp_killer or nil
        local attackers = combat and combat.lolwp_attackers or { }

        for _, side_attacker in pairs(attackers) do
            local attacker_passive_owner = side_attacker and side_attacker.components.lolwp_passive_owner
            local attacker_buff_owner = side_attacker and side_attacker.components.lolwp_buff_owner

            if attacker_passive_owner then
                attacker_passive_owner:Trigger("WhenSetupLoot", killer, attackers)
            end
            if attacker_buff_owner then
                attacker_buff_owner:Trigger("WhenSetupLoot", killer, attackers)
            end
        end

        return unpack(results)
    end
end)

local PASSIVE_ITEMTILE_SETUP_NOTFOUND = { }

local passive_itemtile_setup_map = { }

local Text = require 'widgets/text'
AddClassPostConstruct("widgets/itemtile", function(itemtile, invitem)
    local controller_replica = invitem.replica.lolwp_passive_controller
    if not controller_replica then return end

    local item_data = item_database:get_by_prefab(invitem.prefab)
    for passive_name, passive_args in pairs(item_data and item_data.passives or { }) do
        local itemtile_setup = passive_itemtile_setup_map[passive_name]
        if not itemtile_setup then
            local Passive = require("passives/"..passive_name)
            itemtile_setup = Passive.WhenItemtileSetup or PASSIVE_ITEMTILE_SETUP_NOTFOUND
            passive_itemtile_setup_map[passive_name] = itemtile_setup
        end
        if itemtile_setup ~= PASSIVE_ITEMTILE_SETUP_NOTFOUND then
            itemtile_setup(itemtile, invitem)
        end
    end
end)