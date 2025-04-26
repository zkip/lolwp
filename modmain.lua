---@diagnostic disable
---@diagnostic disable: undefined-global
GLOBAL.setmetatable(env, {
    __index = function(t, k) return GLOBAL.rawget(GLOBAL, k) end
})
modimport("scripts/apis.lua")
TUNING.BLOODAXE_HEALTH_DELTA = GetConfig("bloodaxe_health") or 3
local mod_prefix = "gallopweapon"
local script_prefix = mod_prefix .. "_"
function import(x, _env)
    local file =
        resolvefilepath_soft("scripts/" .. script_prefix .. x .. ".lua")
    if not file then
        print("error: no such file", x)
        return nil
    end
    local fn = kleiloadlua(file)
    if type(fn) == "function" then
        setfenv(fn, _env or env)
        print("loaded ", x)
        return fn()
    else
        print("error: invalid file", x)
        return nil
    end
end
function demand(x)
    local ret = package.loaded[script_prefix .. x] or import(x)
    package.loaded[script_prefix .. x] = ret
    return ret
end
PrefabFiles = {
    "gallop_breaker", "gallopweapon_fx", "gallop_whip", "gallopweapon_reticule",
    "gallop_bloodaxe_fx", "gallop_laser", "gallop_shadow_pillar", --
    "lol_weapon_buffs", "nashor_tooth", "crystal_scepter", "crystal_scepter_fx",
    "riftmaker","AlchemyChainSaw",
}
currentlang = "zh"
local r = require("register_inventoryimages")
r("images/gallopweapon_inventoryimages.xml")
Assets = {
    Asset("IMAGE", "images/gallopweapon_inventoryimages.tex"),
    Asset("ATLAS", "images/gallopweapon_inventoryimages.xml"),
    Asset("ATLAS_BUILD", "images/gallopweapon_inventoryimages.xml", 256), --
    Asset("ATLAS", "images/inventoryimages/nashor_tooth.xml"),
    Asset("ATLAS", "images/inventoryimages/crystal_scepter.xml"),
    Asset("ATLAS", "images/inventoryimages/riftmaker_weapon.xml"),
    Asset("ATLAS", "images/inventoryimages/riftmaker_amulet.xml"),

    
	Asset("ANIM", "anim/punk_alchemy_saw_sword.zip"),
	Asset("ANIM", "anim/swap_punk_alchemy_saw_sword.zip"),
	Asset("ANIM", "anim/alchemy_chainsaw_fx.zip"),
	Asset("IMAGE", "images/alchemy_chainsaw.tex"),
	Asset("ATLAS", "images/alchemy_chainsaw.xml"),
	Asset("IMAGE", "images/alchemy_chainsaw2.tex"),
	Asset("ATLAS", "images/alchemy_chainsaw2.xml"),
}
import("recipes")
local TuningHack = {}
setmetatable(TuningHack, {
    __index = function(_, k)
        if k == nil then return nil end
        if type(k) == "string" and TUNING[string.upper(k)] then
            TuningHack[k] = TUNING[string.upper(k)]
            return TuningHack[k]
        else
            return env[k]
        end
    end
})
local tuning = import("tuning", TuningHack)
table.mergeinto(TUNING, tuning, true)
local function cpy(t)
    local r = {}
    for k, v in pairs(t) do if type(v) == "table" then r[k] = cpy(v) end end
    return r
end
STRINGS.CHARACTERS.GALLOP = STRINGS.CHARACTERS.GALLOP or
                                cpy(require("speech_wilson"))

-- 优先加载我 
modimport('scripts/lol_wp_modmain.lua')



---------------------------------------
---------------------------------------
---------------------------------------
local chainsaw_1737852586 = {
    Asset("SOUNDPACKAGE","sound/chainsaw_sound.fev"),
	Asset("SOUND","sound/chainsaw_sound.fsb"),
}

for _,v in ipairs(chainsaw_1737852586) do
    table.insert(Assets,v)
end

modimport "main/chainsaw_pity_power"

AddRecipe2("alchemy_chainsaw", 
{Ingredient("wagpunkbits_kit", 1), Ingredient("wagpunk_bits", 6), Ingredient("gears", 10), Ingredient("transistor", 4), Ingredient("trinket_6", 6)},
TECH.LOST, 
{atlas = "images/alchemy_chainsaw.xml"},
{"WEAPONS",'TAB_LOL_WP'})
STRINGS.NAMES.ALCHEMY_CHAINSAW = "炼金朋克链锯剑"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.ALCHEMY_CHAINSAW = "来自底城的反击!"
STRINGS.RECIPE_DESC.ALCHEMY_CHAINSAW = "祖安会看着你血流一地，但什么也不会做。"

AddPrefabPostInit('alchemy_chainsaw',function (inst)
    if not TheWorld.ismastersim then
        return inst
    end
    inst:AddComponent('for_componentaction_alchemy_chainsaw')
end)

for _,v in ipairs({'wagpunkbits_kit','gears'}) do
    AddPrefabPostInit(v,function (inst)
        if not TheWorld.ismastersim then
            return inst
        end
        inst:AddComponent('for_componentaction_alchemy_chainsaw_repair')
    end)
end

----[]----[]----[]----[]----[]----[]----[]----[]----[]----[]----[]----[]----[]----
----修复
CHAINSAW_EEPAIR = AddAction("CHAINSAW_EEPAIR","修复",function(act)
return act.target:Chainsaw_Eepair(act.invobject, act.doer)
end)
CHAINSAW_EEPAIR.priority = 99
CHAINSAW_EEPAIR.mount_valid = true

AddComponentAction("USEITEM", "for_componentaction_alchemy_chainsaw_repair", function(inst, doer, target, actions, right)
if target.prefab == "alchemy_chainsaw" and (inst.prefab == "wagpunkbits_kit" or inst.prefab == "gears") then
    table.insert(actions, ACTIONS.CHAINSAW_EEPAIR)
end
end)

AddStategraphActionHandler("wilson", ActionHandler(ACTIONS.CHAINSAW_EEPAIR, "dolongaction")) 
AddStategraphActionHandler("wilson_client", ActionHandler(ACTIONS.CHAINSAW_EEPAIR, "dolongaction"))


----启动or停止
START_CHAINSAW = AddAction("START_CHAINSAW","链锯启动",function(act)
local owner = act.doer 
local invobject = act.invobject
return invobject.Chainsaw_Switch(invobject, owner)
end)
START_CHAINSAW.priority = 99
START_CHAINSAW.mount_valid = true

STOP_CHAINSAW = AddAction("STOP_CHAINSAW","链锯停止",function(act)
local owner = act.doer 
local invobject = act.invobject
return invobject.Chainsaw_Switch(invobject, owner)
end)
STOP_CHAINSAW.priority = 99
STOP_CHAINSAW.mount_valid = true

AddComponentAction("INVENTORY", "for_componentaction_alchemy_chainsaw", function(inst, doer, actions, right)
if inst.prefab == "alchemy_chainsaw" and inst:HasTag("chainsaw_ready") then
    if inst:HasTag("Start_Chainsaw") then
        table.insert(actions, ACTIONS.STOP_CHAINSAW)
    else
        table.insert(actions, ACTIONS.START_CHAINSAW)
    end
end
end)

AddStategraphActionHandler("wilson", ActionHandler(ACTIONS.START_CHAINSAW, "give")) 
AddStategraphActionHandler("wilson_client", ActionHandler(ACTIONS.START_CHAINSAW, "give"))

AddStategraphActionHandler("wilson", ActionHandler(ACTIONS.STOP_CHAINSAW, "give")) 
AddStategraphActionHandler("wilson_client", ActionHandler(ACTIONS.STOP_CHAINSAW, "give"))

AddComponentAction("EQUIPPED", "for_componentaction_alchemy_chainsaw" , function(inst, doer, target, actions, right)
if right and target ~= doer 
and (target.components.health or target.replica.health)
and (target.components.combat or target.replica.combat)
and not doer:HasTag("steeringboat") and not doer:HasTag("rotatingboat")
then
    if inst.prefab == "alchemy_chainsaw" and inst:HasTag("Start_Chainsaw") then
        table.insert(actions, ACTIONS.CHAINSAW_PITY)
    end
end

--[[if right and target ~= doer and target:HasTag("CHOP_workable") then
    if inst.prefab == "alchemy_chainsaw" and inst:HasTag("Start_Chainsaw") then
        table.insert(actions, ACTIONS.CHAINSAW_CHOP)
    end
end]]
end)


----怜悯跳劈
CHAINSAW_PITY = AddAction("CHAINSAW_PITY", "怜悯",function(act)
local owner = act.doer 
---@type ent
local target = act.target 
local invobject = act.invobject
invobject.Chainsaw_Pity(invobject, owner, target)

owner:DoTaskInTime(12 * FRAMES,function()
    if owner and target and target.components.health and target.components.health:IsDead() and LOLWP_S:checkAlive(owner) then
        owner.components.health:SetInvincible(false)
        owner.components.health:DoDelta(15)
        if owner.components.sanity ~= nil then
            owner.components.sanity:DoDelta(15, true,"debug_key")
        end
        owner.components.health:SetInvincible(true)
    end
end)



return true
end)
CHAINSAW_PITY.priority = 99
CHAINSAW_PITY.mount_valid = true
CHAINSAW_PITY.distance = 9

AddStategraphActionHandler("wilson", ActionHandler(ACTIONS.CHAINSAW_PITY)) 
AddStategraphActionHandler("wilson_client", ActionHandler(ACTIONS.CHAINSAW_PITY))


---------------------------------------
---------------------------------------
---------------------------------------




-- 九头蛇、提亚马特等相关物品
modimport("scripts/gallop_h_t.lua")
modimport("scripts/lol_heartsteel.lua")

STRINGS.NAMES.GALLOP_WHIP = "铁刺鞭"
STRINGS.RECIPE_DESC.GALLOP_WHIP = "用尖刺鞭打！"
STRINGS.ACTIONS.CASTAOE.GALLOP_BLOODAXE = "饥渴斩击"
STRINGS.NAMES.GALLOP_BLOODAXE = "渴血战斧"
STRINGS.RECIPE_DESC.GALLOP_BLOODAXE = "砍断！切开！剁碎！"
STRINGS.ACTIONS.CASTAOE.GALLOP_BREAKER = "深海冲击"
STRINGS.ACTIONS.GALLOP_BREAKER = "切换模式"
STRINGS.NAMES.GALLOP_BREAKER = "破舰者"
STRINGS.RECIPE_DESC.GALLOP_BREAKER = "这波不活了啊兄弟们！"
STRINGS.CHARACTERS.GENERIC.ANNOUNCE_BREAKER = "爆破！"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.GALLOP_BREAKER =
    "用它来砍树很有节奏感。"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.GALLOP_WHIP =
    "绑在链条上的十字镐。"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.GALLOP_BLOODAXE =
    "让鲜血！为我们神圣洗礼！"

TUNING.GALLOPBREAKMUSIC_ENABLED = GetConfig("gallopbreakermusic")
-- shadow level
-- shadow level
local levels = {
    gallophat2 = 3,
    gallop_stick3 = 2,
    gallop_cloth2 = 3,
    gallop_dreadclub = 3,
    gallop_bloodaxe = 4
}
setmetatable(levels, {__index = function(_, k) return 0 end})
utils.prefabs(table.getkeys(levels), function(inst)
    -- shadowlevel (from shadowlevel component) added to pristine state for optimization
    inst:AddTag("shadowlevel")
    if not TheWorld.ismastersim then return end
    if not inst.components.shadowlevel then
        inst:AddComponent("shadowlevel")
        inst.components.shadowlevel:SetDefaultLevel(levels[inst.prefab])
    end
end)
-- gallop breaker min absorb
local Inventory = require("components/inventory")
local ApplyDamage = Inventory.ApplyDamage
local SpDamageUtil = require("components/spdamageutil")

function Inventory:ApplyDamage(damage, attacker, weapon, spdamage)
    local ApplyDamage = ApplyDamage
    local absorbers = {}
    local damagetypemult = 1
    for k, v in pairs(self.equipslots) do
        -- check resistance
        if v.components.resistance ~= nil and
            v.components.resistance:HasResistance(attacker, weapon) and
            v.components.resistance:ShouldResistDamage() then
            v.components.resistance:ResistDamage(damage)
            return 0, nil
        elseif v.components.armor ~= nil then
            absorbers[v.components.armor] =
                v.components.armor:GetAbsorption(attacker, weapon)
        end
        if v.components.damagetyperesist ~= nil then
            damagetypemult = damagetypemult *
                                 v.components.damagetyperesist:GetResist(
                                     attacker, weapon)
        end
    end

    damage = damage * damagetypemult
    -- print("Incoming damage", damage)

    local absorbed_percent = self.gallop_breaker_absorb or 0
    local total_absorption = 0
    for armor, amt in pairs(absorbers) do
        -- print("\t", armor.inst, "absorbs", amt)
        absorbed_percent = math.max(amt, absorbed_percent)
        total_absorption = total_absorption + amt
    end

    local absorbed_damage = damage * absorbed_percent
    local leftover_damage = damage - absorbed_damage

    -- print("\tabsorbed%", absorbed_percent, "total_absorption", total_absorption, "absorbed_damage", absorbed_damage, "leftover_damage", leftover_damage)

    local armor_damage = {}
    if total_absorption > 0 then
        ProfileStatsAdd("armor_absorb", absorbed_damage)

        for armor, amt in pairs(absorbers) do
            armor_damage[armor] = absorbed_damage * amt / total_absorption +
                                      armor:GetBonusDamage(attacker, weapon)
        end
    end

    -- Apply special damage
    if spdamage ~= nil then
        for sptype, dmg in pairs(spdamage) do
            dmg = dmg * damagetypemult
            local spdefenders = {}
            local count = 0
            for eslot, equip in pairs(self.equipslots) do
                local def = SpDamageUtil.GetSpDefenseForType(equip, sptype)
                if def > 0 then
                    count = count + 1
                    spdefenders[equip] = def
                end
            end
            while dmg > 0 and count > 0 do
                local splitdmg = dmg / count
                for k, v in pairs(spdefenders) do
                    local defended
                    if v > splitdmg then
                        defended = splitdmg
                        spdefenders[k] = v - splitdmg
                    else
                        defended = v
                        spdefenders[k] = nil
                        count = count - 1
                    end
                    dmg = dmg - defended
                    local armor = k.components.armor
                    if armor ~= nil then
                        armor_damage[armor] =
                            (armor_damage[armor] or 0) + defended
                    end
                end
            end
            spdamage[sptype] = dmg > 0 and dmg or nil
        end
        if next(spdamage) == nil then spdamage = nil end
    end

    -- Apply armor durability loss
    for armor, dmg in pairs(armor_damage) do armor:TakeDamage(dmg) end

    return leftover_damage, spdamage
end
-- dreadclub upgrade
UPGRADETYPES.GALLOP_DREADCLUB = "gallop_dreadclub"
local function CompensateDreadClub()
    MapDict(Ents, function(guid, ent)
        local u = ent.components.upgradeable
        if u and ent.prefab == "gallop_dreadclub" then
            u.upgradetype = UPGRADETYPES.GALLOP_DREADCLUB
        end
    end)
end
local function CompensatePlayer(oldtype)
    MapDict(AllPlayers, function(i, ent)
        if ent:HasTag("gallop") then
            ent:RemoveTag(oldtype .. "_upgradeuser")
            ent:AddTag(UPGRADETYPES.GALLOP_DREADCLUB .. "_upgradeuser")
        end
    end)
end
if IsServer() then
    utils.prefab("shadowheart", function(inst)
        local upgrader = inst.components.upgrader or
                             inst:AddComponent("upgrader")
        if upgrader then
            local type = upgrader.upgradetype
            if type and type ~= UPGRADETYPES.GALLOP_DREADCLUB then
                local oldtype = UPGRADETYPES.GALLOP_DREADCLUB
                UPGRADETYPES.GALLOP_DREADCLUB = type
                CompensateDreadClub()
                CompensatePlayer(oldtype)
            else
                upgrader.upgradetype = UPGRADETYPES.GALLOP_DREADCLUB
            end
        end
    end)
end
local AddLoot = require("common_addloot").AddLoot
utils.prefab("minotaur", AddLoot({{"gallop_breaker_blueprint", 1}}))
utils.prefab("deerclops", AddLoot({{"crystal_scepter_blueprint", 1}}))
-- useitem str
local useitem_stroverridefn = ACTIONS.USEITEM.stroverridefn or function() end
ACTIONS.USEITEM.stroverridefn = useitem_stroverridefn and function(act)
    local obj = act.invobject
    if obj and obj.stroverridefn then
        local str = obj:stroverridefn(act)
        if str then return str end
    end
    return useitem_stroverridefn(act)
end
-- axe aoe
local CASTAOE_stroverridefn = ACTIONS.CASTAOE.stroverridefn or function() end
function ACTIONS.CASTAOE.stroverridefn(act, ...)
    local inv = act.invobject
    if inv and inv.stroverridefn then
        local ret = inv:stroverridefn(act)
        if ret then return ret end
    end
    return CASTAOE_stroverridefn(act, ...)
end
-- 旺达回血
utils.prefab("wanda", function(inst)
    if inst.components.oldager then
        inst.components.oldager:AddValidHealingCause("gallop_bloodaxe")
    end
end)
utils.sim(function()
    local _1, v, _ = UPVALUE.get(EntityScript.CollectActions,
                                 "COMPONENT_ACTIONS")
    if not v then
        _1, v, _ = UPVALUE.get(EntityScript.IsActionValid, "COMPONENT_ACTIONS")
    end
    if v then
        local SCENE = v.SCENE
        if SCENE then
            local SCENE_inventoryitem_fn = SCENE.inventoryitem
            SCENE.inventoryitem = function(inst, doer, actions, right)
                if doer:HasTag("rabbitfriendly") and inst.prefab == "rabbit" and
                    doer.replica.inventory ~= nil and
                    (doer.replica.inventory:GetNumSlots() > 0 or
                        inst.replica.equippable ~= nil) and
                    (right or not inst:HasTag("heavy")) then
                    table.insert(actions, ACTIONS.PICKUP)
                end
                return SCENE_inventoryitem_fn(inst, doer, actions, right)
            end
        end
        local USEITEM = v.USEITEM
        if USEITEM then
            local USEITEM_repairer_fn = USEITEM.repairer
            if USEITEM_repairer_fn then
                USEITEM.repairer =
                    function(inst, doer, target, actions, right, ...)
                        if right then
                            if doer.replica.rider ~= nil and
                                doer.replica.rider:IsRiding() then
                                if not (target.replica.inventoryitem ~= nil and
                                    target.replica.inventoryitem:IsGrandOwner(
                                        doer)) then
                                    return
                                        USEITEM_repairer_fn(inst, doer, target,
                                                            actions, right, ...)
                                end
                            elseif doer.replica.inventory ~= nil and
                                doer.replica.inventory:IsHeavyLifting() then
                                return USEITEM_repairer_fn(inst, doer, target,
                                                           actions, right, ...)
                            end
                            if target:HasTag("repairable_any") then
                                for k, v2 in pairs(MATERIALS) do
                                    if inst:HasTag("work_" .. v2) or
                                        inst:HasTag("finiteuses_" .. v2) or
                                        inst:HasTag("health_" .. v2) or
                                        inst:HasTag("freshen_" .. v2) then
                                        table.insert(actions, ACTIONS.REPAIR)
                                    end
                                end
                            end
                        end
                        return USEITEM_repairer_fn(inst, doer, target, actions,
                                                   right, ...)
                    end
            end
        end
    end
end)
utils.sg("wilson", function(sg)
    -- cast aoe hack
    local castaoehandler = sg.actionhandlers[ACTIONS.CASTAOE]
    if castaoehandler then
        local _castaoe_actionhandler = castaoehandler.deststate
        castaoehandler.deststate = function(inst, action, ...)
            if action.invobject ~= nil and
                (action.invobject:HasTag("aoeweapon_leap") and
                    action.invobject:HasTag("gallopsuperjump")) and
                not action.invobject:HasTag("depleted") then
                return "gallop_superjump_pre"
            end
            if action.invobject ~= nil and action.invobject:HasTag("play_strum") and
                not action.invobject:HasTag("depleted") then
                return "play_strum"
            end
            if action.invobject ~= nil and
                action.invobject:HasTag("cast_like_pocketwatch") and
                not action.invobject:HasTag("depleted") then
                -- compensate for the specific sg
                -- action.invobject:PushEvent("willenternewstate",
                --                           {state = "dojostleaction"})
                return "dojostleaction"
            end
            return _castaoe_actionhandler(inst, action, ...)
        end
    end
end)
utils.sg("wilson_client", function(sg)
    -- cast aoe hack
    local castaoehandler = sg.actionhandlers[ACTIONS.CASTAOE]
    if castaoehandler then
        local _castaoe_actionhandler = castaoehandler.deststate
        castaoehandler.deststate = function(inst, action, ...)
            if action.invobject ~= nil and
                (action.invobject:HasTag("aoeweapon_leap") and
                    action.invobject:HasTag("gallopsuperjump")) and
                not action.invobject:HasTag("depleted") then
                return "gallop_superjump_pre"
            end
            if action.invobject ~= nil and action.invobject:HasTag("play_strum") and
                not action.invobject:HasTag("depleted") then
                return "play_strum"
            end
            if action.invobject ~= nil and
                action.invobject:HasTag("cast_like_pocketwatch") and
                not action.invobject:HasTag("depleted") then
                -- compensate for the specific sg
                -- action.invobject:PushEvent("willenternewstate",
                --                           {state = "dojostleaction"})
                return "dojostleaction"
            end
            return _castaoe_actionhandler(inst, action, ...)
        end
    end
end)
-- crafting menu show character recipes
local shown_recipes = {
    gallop_whip = true,
    gallop_bloodaxe = true,
    gallop_breaker = true,
    gallop_hydra = true,
    gallop_tiamat = true,
    gallop_blackcutter = true,
    gallop_brokenking = true,
    gallop_ad_destroyer = true,
    lol_heartsteel = true,
    nashor_tooth = true,
    crystal_scepter = true,
    riftmaker_weapon = true,
    lol_wp_trinity = true,
    lol_wp_sheen = true,
    lol_wp_divine = true,
    lol_wp_overlordbloodarmor = true,
    lol_wp_demonicembracehat = true,
    lol_wp_warmogarmor = true,

    lol_wp_s7_cull = true,
    lol_wp_s7_doranblade = true,
    lol_wp_s7_doranshield = true,
    lol_wp_s7_doranring = true,
    lol_wp_s7_tearsofgoddess = true,
    lol_wp_s7_obsidianblade = true,

    lol_wp_s8_deathcap = true,
    lol_wp_s8_uselessbat = true,
    lol_wp_s8_lichbane = true,

    lol_wp_s9_guider = true,
    lol_wp_s9_eyestone_low = true,
    lol_wp_s9_eyestone_high = true,

    lol_wp_s10_guinsoo = true,
    lol_wp_s10_blastingwand = true,
    lol_wp_s10_sunfireaegis = true,

    lol_wp_s11_amplifyingtome = true,
    lol_wp_s11_darkseal = true,
    lol_wp_s11_mejaisoulstealer = true,

    lol_wp_s12_eclipse = true,
    lol_wp_s12_malignance = true,
    alchemy_chainsaw = true,

    lol_wp_s13_infinity_edge = true,
    lol_wp_s13_statikk_shiv = true,
    -- lol_wp_s13_statikk_shiv_charged = true,
    lol_wp_s13_collector = true,

    lol_wp_s14_bramble_vest = true,
    lol_wp_s14_thornmail = true,
    lol_wp_s14_hubris = true,

    lol_wp_s15_crown_of_the_shattered_queen = true,
    lol_wp_s15_stopwatch = true,
    lol_wp_s15_zhonya = true,

    lol_wp_s16_potion_hp = true,
    lol_wp_s16_potion_compound = true,
    lol_wp_s16_potion_corruption = true,

    lol_wp_s17_luden = true,
    lol_wp_s17_liandry = true,
    lol_wp_s17_lostchapter = true,

    lol_wp_s18_bloodthirster = true,
    lol_wp_s18_stormrazor = true,
    lol_wp_s18_krakenslayer = true,

    lol_wp_s19_archangelstaff = true,
    lol_wp_s19_muramana = true,
    lol_wp_s19_fimbulwinter_armor = true,
}
local function IsCharacterRecipe(recipe) return shown_recipes[recipe.name or ""] end
utils.require("widgets/redux/craftingmenu_hud", function(self)
    local RebuildRecipes = self.RebuildRecipes
    function self:RebuildRecipes()
        RebuildRecipes(self)
        if self.owner ~= nil and self.owner.replica.builder ~= nil then
            for k, recipe in pairs(AllRecipes) do
                if IsRecipeValid(recipe.name) then
                    local should_hint_recipe = IsCharacterRecipe(recipe)
                    if should_hint_recipe and self.valid_recipes[recipe.name] then
                        local meta = self.valid_recipes[recipe.name].meta
                        if meta.build_state == "hide" then
                            meta.build_state = "hint"
                        end
                    end
                end
            end
        end
    end
end)
MATERIALS.FLINT = MATERIALS.FLINT or "flint"
utils.prefab("flint", function(inst)
    if not TheWorld.ismastersim then return false end
    if not inst.components.repairer then inst:AddComponent("repairer") end
    inst.components.repairer.repairmaterial = MATERIALS.FLINT
    inst.components.repairer.finiteusesrepairvalue = 1
end)

--

RegisterInventoryItemAtlas("images/inventoryimages/nashor_tooth.xml",
                           "nashor_tooth.tex")
RegisterInventoryItemAtlas("images/inventoryimages/crystal_scepter.xml",
                           "crystal_scepter.tex")
RegisterInventoryItemAtlas("images/inventoryimages/riftmaker_weapon.xml",
                           "riftmaker_weapon.tex")
RegisterInventoryItemAtlas("images/inventoryimages/riftmaker_amulet.xml",
                           "riftmaker_amulet.tex")

STRINGS.ACTIONS.CASTSPELL.RIFTMAKER = "虚空裂隙"
STRINGS.ACTIONS.CASTSPELL.CRYSTAL_SCEPTER = "冰封陵墓"
STRINGS.ACTIONS.CASTAOE.NASHOR_TOOTH = "艾卡西亚之咬"

modimport("scripts/lol_weapon_actions.lua")
modimport("scripts/hooks/component/repairable.lua")
modimport("scripts/hooks/prefab/worm_boss.lua")
modimport("scripts/hooks/componentaction.lua")

STRINGS.NAMES.NASHOR_TOOTH = "纳什之牙"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.NASHOR_TOOTH =
    "看来纳什男爵镶了个金牙。"
AddRecipe2("nashor_tooth", {
    Ingredient("tentaclespike", 1), Ingredient("nightsword", 1),
    Ingredient("purplegem", 1), Ingredient("houndstooth", 6),
    Ingredient("nightmarefuel", 8)
}, TECH.MAGIC_THREE, {}, {"MAGIC",'TAB_LOL_WP'})
STRINGS.RECIPE_DESC.NASHOR_TOOTH =
    "从纳什男爵口中夺来的尖利牙齿。"

STRINGS.NAMES.CRYSTAL_SCEPTER = "瑞莱的冰晶节杖"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.CRYSTAL_SCEPTER =
    "虽然不能快速冻结，但可以慢慢折磨敌人。"
AddRecipe2("crystal_scepter", {
    Ingredient("icestaff", 1), Ingredient('lol_wp_s10_blastingwand', 1,'images/inventoryimages/lol_wp_s10_blastingwand.xml'),
    Ingredient("goldnugget", 40), Ingredient("opalpreciousgem", 1),
    Ingredient("ice", 40)
}, TECH.LOST, {}, {"MAGIC", 'TAB_LOL_WP'})
STRINGS.RECIPE_DESC.CRYSTAL_SCEPTER = "最古老的寒冰魔法。"

STRINGS.NAMES.RIFTMAKER_WEAPON = "峡谷制造者"
STRINGS.NAMES.RIFTMAKER_AMULET = "裂隙制造者"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.RIFTMAKER_WEAPON =
    "我感觉到它在看着我。"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.RIFTMAKER_AMULET = STRINGS.CHARACTERS
                                                           .GENERIC.DESCRIBE
                                                           .RIFTMAKER_WEAPON
AddRecipe2("riftmaker_weapon", {
    Ingredient("telestaff", 1), Ingredient("lol_wp_s10_blastingwand", 1,'images/inventoryimages/lol_wp_s10_blastingwand.xml'),
    Ingredient("thulecite", 8), Ingredient("dreadstone", 6),
    Ingredient("horrorfuel", 4)
}, TECH.ANCIENT_FOUR, {station_tag = "altar", nounlock = true},
           {"CRAFTING_STATION", "MAGIC", 'TAB_LOL_WP'})
STRINGS.RECIPE_DESC.RIFTMAKER_WEAPON = "这是来自艾卡西亚的诅咒……"

-- @lan: 给现有的配方排序

-- 萃取 lol_wp_s7_cull
-- 黑曜石锋刃 lol_wp_s7_obsidianblade
-- 多兰之刃 lol_wp_s7_doranblade
-- 多兰之盾 lol_wp_s7_doranshield
-- 多兰之戒 lol_wp_s7_doranring
-- 女神之泪 lol_wp_s7_tearsofgoddess
-- 破舰者 gallop_breaker
-- 铁刺鞭 gallop_whip
-- 渴血战斧 gallop_bloodaxe
-- 心之钢 lol_heartsteel
-- 提亚马特 gallop_tiamat
-- 巨型九头蛇 gallop_hydra
-- 峡谷制造者 riftmaker_weapon
-- 纳什之牙 nashor_tooth
-- 瑞莱的冰晶节杖 crystal_scepter
-- 黑色切割者 gallop_blackcutter
-- 破败王者之刃 gallop_brokenking
-- 挺进破坏者 gallop_ad_destroyer
-- 三相之力 lol_wp_trinity
-- 耀光 lol_wp_sheen
-- 神圣分离者 lol_wp_divine
-- 霸王血铠 lol_wp_overlordbloodarmor
-- 恶魔之拥 lol_wp_demonicembracehat
-- 狂徒铠甲 lol_wp_warmogarmor
-- 灭世者的死亡之帽 lol_wp_s8_deathcap
-- 无用大棒 lol_wp_s8_uselessbat
-- 巫妖之祸 lol_wp_s8_lichbane
-- 引路者 lol_wp_s9_guider
-- 戒备眼石 lol_wp_s9_eyestone_low
-- 警觉眼石 lol_wp_s9_eyestone_high
-- 鬼索的狂暴之刃 lol_wp_s10_guinsoo
-- 爆裂魔杖 lol_wp_s10_blastingwand
-- 日炎圣盾 lol_wp_s10_sunfireaegis
-- 增幅典籍 lol_wp_s11_amplifyingtome
-- 黑暗封印 lol_wp_s11_darkseal
-- 梅贾的窃魂卷 lol_wp_s11_mejaisoulstealer
-- 星蚀 lol_wp_s12_eclipse
-- 焚天 lol_wp_s12_malignance
-- 炼金朋克链锯剑 alchemy_chainsaw
-- 无尽之刃 lol_wp_s13_infinity_edge
-- 斯塔缇克电刃 lol_wp_s13_statikk_shiv
-- 斯塔缇克电刀 lol_wp_s13_statikk_shiv_charged
-- 收集者 lol_wp_s13_collector
-- 棘刺背心 lol_wp_s14_bramble_vest
-- 荆棘之甲 lol_wp_s14_thornmail
-- 狂妄 lol_wp_s14_hubris
-- 破碎王后之冕 lol_wp_s15_crown_of_the_shattered_queen
-- 秒表 lol_wp_s15_stopwatch
-- 中娅沙漏 lol_wp_s15_zhonya
-- 生命药水 lol_wp_s16_potion_hp
-- 复用型药水 lol_wp_s16_potion_compound
-- 腐败药水 lol_wp_s16_potion_corruption
-- 卢登的回声 lol_wp_s17_luden
-- 兰德里的折磨 lol_wp_s17_liandry
-- 遗失的章节 lol_wp_s17_lostchapter
-- 饮血剑 lol_wp_s18_bloodthirster
-- 岚切 lol_wp_s18_stormrazor
-- 海妖杀手 lol_wp_s18_krakenslayer
-- 大天使之杖 lol_wp_s19_archangelstaff
-- 魔宗 lol_wp_s19_muramana
-- 凛冬之临 lol_wp_s19_fimbulwinter_armor

local LAN_NEW_ORDER_RECIPE = {
        'lol_wp_s7_doranblade',
        'lol_wp_s7_cull',
        'lol_wp_s7_obsidianblade',
        'gallop_whip',
        'gallop_tiamat',
        'lol_wp_sheen',
        'lol_wp_s13_statikk_shiv',
        'lol_wp_s13_statikk_shiv_charged',
        'lol_wp_s10_guinsoo',
        'gallop_blackcutter',
        'gallop_brokenking',
        'lol_wp_s19_muramana',
        'lol_wp_s18_stormrazor',
        'lol_wp_trinity',
        'lol_wp_divine',
        'lol_wp_s12_malignance',
        'lol_wp_s13_infinity_edge',
        'lol_wp_s14_hubris',
        'alchemy_chainsaw',
        'lol_wp_s13_collector',
        'gallop_bloodaxe',
        'lol_wp_s18_bloodthirster',
        'gallop_ad_destroyer',
        'lol_wp_s12_eclipse',
        'lol_wp_s18_krakenslayer',
        -- tank
        'lol_wp_s7_doranshield',
        'lol_wp_s14_bramble_vest',
        'lol_wp_s14_thornmail',
        'lol_wp_s19_fimbulwinter_armor',
        'lol_wp_s10_sunfireaegis',
        'lol_heartsteel',
        'gallop_hydra',
        'gallop_breaker',
        'lol_wp_warmogarmor',
        'lol_wp_overlordbloodarmor',
        'lol_wp_demonicembracehat',
        -- mage
        'lol_wp_s7_doranring',
        'lol_wp_s11_amplifyingtome',
        'lol_wp_s11_darkseal',
        'lol_wp_s7_tearsofgoddess',
        'lol_wp_s17_lostchapter',
        'lol_wp_s10_blastingwand',
        'lol_wp_s8_uselessbat',
        'nashor_tooth',
        'lol_wp_s15_crown_of_the_shattered_queen',
        'crystal_scepter',
        'lol_wp_s19_archangelstaff',
        'lol_wp_s15_zhonya',
        'lol_wp_s17_luden',
        'lol_wp_s8_lichbane',
        'riftmaker_weapon',
        'lol_wp_s8_deathcap',
        'lol_wp_s11_mejaisoulstealer',
        'lol_wp_s17_liandry',
        -- support
        'lol_wp_s16_potion_hp',
        'lol_wp_s16_potion_compound',
        'lol_wp_s15_stopwatch',
        'lol_wp_s16_potion_corruption',
        'lol_wp_s9_eyestone_low',
        'lol_wp_s9_eyestone_high',
        'lol_wp_s9_guider',
}


local function SortRecipe(a, b, filter_name, offset)
    local filter = CRAFTING_FILTERS[filter_name]
    if filter and filter.recipes then
        for sortvalue, product in ipairs(filter.recipes) do
            if product == a then
                table.remove(filter.recipes, sortvalue)
                break
            end
        end

        local target_position = #filter.recipes + 1
        for sortvalue, product in ipairs(filter.recipes) do
            if product == b then
                target_position = sortvalue + offset
                break
            end
        end
        table.insert(filter.recipes, target_position, a)
    end
end

local function sortAfter(a, b, filter_name) SortRecipe(a, b, filter_name, 1) end

for i = 1, #LAN_NEW_ORDER_RECIPE - 1 do
    sortAfter(LAN_NEW_ORDER_RECIPE[i + 1], LAN_NEW_ORDER_RECIPE[i], 'TAB_LOL_WP')
end
