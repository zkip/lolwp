---@diagnostic disable: undefined-global
local prefab_id = 'lol_wp_s7_cull'

for _,v in ipairs({
    Asset("ANIM","anim/"..prefab_id.."_skin_layaste.zip"),
    Asset("ANIM","anim/swap_"..prefab_id.."_skin_layaste.zip"),
    Asset("ATLAS","images/inventoryimages/"..prefab_id.."_skin_layaste.xml"),
}) do
    table.insert(Assets,v)
end

LOLWP_SKIN_API.MakeItemSkinDefaultImage(prefab_id, "images/inventoryimages/"..prefab_id..".xml", prefab_id)

LOLWP_SKIN_API.MakeItemSkin(prefab_id,prefab_id.."_skin_layaste",{
    name = STRINGS.MOD_LOL_WP.SKIN_API.SKINS[prefab_id]['layaste'],
    rarity = STRINGS.MOD_LOL_WP.SKIN_API.elegent,
    raritycorlor = TUNING.MOD_LOL_WP.SKIN_API.elegent,
    atlas = "images/inventoryimages/"..prefab_id.."_skin_layaste.xml",
    image = prefab_id.."_skin_layaste",
    build = prefab_id.."_skin_layaste",
    bank =  prefab_id.."_skin_layaste",
    anim = "idle",
    animcircle = true,
    basebuild = prefab_id,
    basebank =  prefab_id,
    baseanim = "idle",
    baseanimcircle = true
})

AddPrefabPostInit(prefab_id, function(inst)
    if not TheWorld.ismastersim then
        return inst
    end

    local TRAIL_FLAGS = { "shadowtrail" }
    local function do_trail(inst)
        if not inst.entity:IsVisible() then
            return
        end

        local x, y, z = inst.Transform:GetWorldPosition()
        if inst.sg ~= nil and inst.sg:HasStateTag("moving") then
            local theta = -inst.Transform:GetRotation() * DEGREES
            local speed = inst.components.locomotor:GetRunSpeed() * .1
            x = x + speed * math.cos(theta)
            z = z + speed * math.sin(theta)
        end
        local mounted = inst.components.rider ~= nil and inst.components.rider:IsRiding()
        local map = TheWorld.Map
        local offset = FindValidPositionByFan(
            math.random() * 2 * PI,
            (mounted and 1 or .5) + math.random() * .5,
            4,
            function(offset)
                local pt = Vector3(x + offset.x, 0, z + offset.z)
                return map:IsPassableAtPoint(pt:Get())
                    and not map:IsPointNearHole(pt)
                    and #TheSim:FindEntities(pt.x, 0, pt.z, .7, TRAIL_FLAGS) <= 0
            end
        )

        if offset ~= nil then
            SpawnPrefab("cane_ancient_fx").Transform:SetPosition(x + offset.x, 0, z + offset.z)
        end
    end

    local function lol_wp_s7_cull_onkilled(player,data)
        if player then
            local pt = player:GetPosition()
            SpawnPrefab('cavehole_flick').Transform:SetPosition(pt:Get())
        end
    end

    if inst.components.equippable then
        local old_onequipfn = inst.components.equippable.onequipfn
        inst.components.equippable.onequipfn = function(inst, owner, ...)
            local skin_build = inst:GetSkinBuild()
            if skin_build ~= nil then
                if skin_build == prefab_id.."_skin_layaste" then
                    if owner.taskperiod_lol_wp_s7_cull__skin_layaste == nil then
---@diagnostic disable-next-line: inject-field
                        owner.taskperiod_lol_wp_s7_cull__skin_layaste = owner:DoPeriodicTask(6 * FRAMES, do_trail, 2 * FRAMES)
                    end

                    -- owner:ListenForEvent('killed',lol_wp_s7_cull_onkilled)
                end
            end
            return old_onequipfn(inst, owner, ...)
        end

        local old_onunequipfn = inst.components.equippable.onunequipfn
        inst.components.equippable.onunequipfn = function(inst, owner, ...)
            if owner then
                if owner.taskperiod_lol_wp_s7_cull__skin_layaste then
                    owner.taskperiod_lol_wp_s7_cull__skin_layaste:Cancel()
---@diagnostic disable-next-line: inject-field
                    owner.taskperiod_lol_wp_s7_cull__skin_layaste = nil
                end
                -- owner:RemoveEventCallback('killed',lol_wp_s7_cull_onkilled)
            end
            return old_onunequipfn(inst, owner, ...)
        end
    end

    if inst.components.weapon then
        local old_onattack = inst.components.weapon.onattack
        inst.components.weapon.onattack = function(inst, attacker, target, ...)
            local skin_build = inst:GetSkinBuild()
            if skin_build ~= nil then
                if skin_build == prefab_id.."_skin_layaste" then
                    if target then
                        local tar_pt = target:GetPosition()
                        SpawnPrefab('shadowstrike_slash_fx').Transform:SetPosition(tar_pt:Get())
                        if target.components.health and target.components.health:IsDead() then
                            SpawnPrefab('cavehole_flick').Transform:SetPosition(tar_pt:Get())
                        end
                    end
                end
            end
            return old_onattack and old_onattack(inst, attacker, target, ...) or nil
        end
    end
end)