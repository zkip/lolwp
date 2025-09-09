local LANS = require('core_lol_wp/utils/sugar')

local prefab_id = 'lol_wp_s7_tearsofgoddess'
local assest_id = prefab_id

local common_lolwp_item = require('prefabs/common_lolwp_item')
local item_database = require('item_database')
local utils_equippable = require('utils/equippable')

local assets =
{
    Asset("ANIM", "anim/"..assest_id..".zip"),
    Asset("ANIM", "anim/torso_"..assest_id..".zip"),

    Asset("ATLAS", "images/inventoryimages/"..assest_id..".xml"),
}

local function buildfn(inst, owner)
    owner.AnimState:OverrideSymbol("swap_body", "torso_"..assest_id, assest_id)
end

local function unbuildfn(inst, owner)
    owner.AnimState:ClearOverrideSymbol("swap_body")
end

local function onequip(inst, owner)
    -- if owner:HasTag('player') and owner.components.sanity and inst.components.lol_wp_s7_tearsofgoddess then
    --     local san = inst.components.lol_wp_s7_tearsofgoddess.val*TUNING.MOD_LOL_WP.TEARSOFGODDESS.SKILL_SPELLFLOW.SAN_LIMIT_PER_NUM
    --     local maxsan = owner.components.sanity.max
    --     owner.components.sanity.max = maxsan + san
    --     owner.components.sanity:DoDelta(0)
    -- end
end

local function onunequip(inst, owner)
    -- if owner:HasTag('player') and owner.components.sanity and inst.components.lol_wp_s7_tearsofgoddess then
    --     local san = inst.components.lol_wp_s7_tearsofgoddess.val*TUNING.MOD_LOL_WP.TEARSOFGODDESS.SKILL_SPELLFLOW.SAN_LIMIT_PER_NUM
    --     local maxsan = owner.components.sanity.max
    --     -- TODO: 是否存在更好的方式解决潜在的竞态条件
    --     owner.components.sanity.max = math.max(0,maxsan - san)
    --     owner.components.sanity:DoDelta(0)
    -- end
end

-- local function onsave(inst, data)
-- end
-- local function onpreload( inst,data )
-- end

local function fn()
    local inst = common_lolwp_item(item_database.tearsofgoddess, buildfn, unbuildfn, onequip, onunequip)
    -- local inst = CreateEntity()
    
    inst.entity:AddSoundEmitter()
    
    inst.AnimState:SetBank(assest_id)
    inst.AnimState:SetBuild(assest_id)
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("nosteal")
    inst:AddTag('lunar_aligned')

    MakeInventoryPhysics(inst)
    MakeInventoryFloatable(inst, "med", nil, 0.75)
    
    if not TheWorld.ismastersim then
        return inst
    end

    inst.components.equippable.dapperness = TUNING.MOD_LOL_WP.TEARSOFGODDESS.DAPPERNESS/54
    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.foleysound = "dontstarve/movement/foley/jewlery"
    inst.components.inventoryitem.imagename = assest_id
    inst.components.inventoryitem.atlasname = "images/inventoryimages/"..assest_id..".xml"

    -- inst:AddComponent('lol_wp_s7_tearsofgoddess')

    inst:AddComponent("rechargeable")
    inst.components.rechargeable:SetChargeTime(TUNING.MOD_LOL_WP.TEARSOFGODDESS.SKILL_SPELLFLOW.CD)
    return inst
end

return Prefab(prefab_id, fn, assets)
