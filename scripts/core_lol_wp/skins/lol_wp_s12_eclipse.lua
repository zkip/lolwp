---@diagnostic disable: undefined-global
local prefab_id = 'lol_wp_s12_eclipse'

for _,v in ipairs({
    Asset("ANIM","anim/"..prefab_id.."_skin_drx.zip"),
    Asset("ANIM","anim/swap_"..prefab_id.."_skin_drx.zip"),
    Asset("ATLAS","images/inventoryimages/"..prefab_id.."_skin_drx.xml"),

    Asset("ANIM","anim/"..prefab_id.."_skin_excalibur.zip"),
    Asset("ANIM","anim/swap_"..prefab_id.."_skin_excalibur.zip"),
    Asset("ATLAS","images/inventoryimages/"..prefab_id.."_skin_excalibur.xml"),

    Asset("ANIM","anim/"..prefab_id.."_skin_seal_muramana.zip"),
    Asset("ANIM","anim/swap_"..prefab_id.."_skin_seal_muramana.zip"),
    Asset("ATLAS","images/inventoryimages/"..prefab_id.."_skin_seal_muramana.xml"),
}) do table.insert(Assets,v) end

LOLWP_SKIN_API.MakeItemSkinDefaultImage(prefab_id, "images/inventoryimages/"..prefab_id..".xml", prefab_id)

LOLWP_SKIN_API.MakeItemSkin(prefab_id,prefab_id.."_skin_drx",{
    name = STRINGS.MOD_LOL_WP.SKIN_API.SKINS[prefab_id]['drx'],
    rarity = STRINGS.MOD_LOL_WP.SKIN_API.top,
    raritycorlor = TUNING.MOD_LOL_WP.SKIN_API.top,
    atlas = "images/inventoryimages/"..prefab_id.."_skin_drx.xml",
    image = prefab_id.."_skin_drx",
    build = prefab_id.."_skin_drx",
    bank =  prefab_id.."_skin_drx",
    anim = "idle",
    animcircle = true,
    basebuild = prefab_id,
    basebank =  prefab_id,
    baseanim = "idle",
    baseanimcircle = true,
})

LOLWP_SKIN_API.MakeItemSkin(prefab_id,prefab_id.."_skin_excalibur",{
    name = STRINGS.MOD_LOL_WP.SKIN_API.SKINS[prefab_id]['excalibur'],
    rarity = STRINGS.MOD_LOL_WP.SKIN_API.reward,
    raritycorlor = TUNING.MOD_LOL_WP.SKIN_API.reward,
    atlas = "images/inventoryimages/"..prefab_id.."_skin_excalibur.xml",
    image = prefab_id.."_skin_excalibur",
    build = prefab_id.."_skin_excalibur",
    bank =  prefab_id.."_skin_excalibur",
    anim = "idle",
    animcircle = true,
    basebuild = prefab_id,
    basebank =  prefab_id,
    baseanim = "idle",
    baseanimcircle = true,
    skinpostfn = function(tbl)
        local old_init = tbl.init_fn
        tbl.init_fn = function(i,...)
            if i.Light then
                i.Light:SetColour(1,1,0)
            end
            return old_init ~= nil and old_init(i,...) or nil
        end
        local old_clear = tbl.clear_fn
        ---comment
        ---@param i ent
        ---@param ... unknown
        tbl.clear_fn = function(i,...)
            if i.Light then
                i.Light:SetColour(unpack(TUNING.MOD_LOL_WP.ECLIPSE.LIGHT.COLOR))
            end
            return old_clear ~= nil and old_clear(i,...) or nil
        end
    end
})

LOLWP_SKIN_API.MakeItemSkin(prefab_id,prefab_id.."_skin_seal_muramana",{
    name = STRINGS.MOD_LOL_WP.SKIN_API.SKINS[prefab_id]['seal_muramana'],
    rarity = STRINGS.MOD_LOL_WP.SKIN_API.top,
    raritycorlor = TUNING.MOD_LOL_WP.SKIN_API.top,
    atlas = "images/inventoryimages/"..prefab_id.."_skin_seal_muramana.xml",
    image = prefab_id.."_skin_seal_muramana",
    build = prefab_id.."_skin_seal_muramana",
    bank =  prefab_id.."_skin_seal_muramana",
    anim = "idle",
    animcircle = true,
    basebuild = prefab_id,
    basebank =  prefab_id,
    baseanim = "idle",
    baseanimcircle = true,
})