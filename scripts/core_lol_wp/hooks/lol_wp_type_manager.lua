---@type table<lol_wp_type,table<PrefabID,any>>
local type_map = {
    mage = {
        lol_wp_s7_doranring = true,
        lol_wp_s11_amplifyingtome = true,
        lol_wp_s11_darkseal = true,
        lol_wp_s7_tearsofgoddess = true,
        lol_wp_s10_blastingwand = true,
        lol_wp_s8_uselessbat = true,
        nashor_tooth = true,
        crystal_scepter = true,
        lol_wp_s8_lichbane = true,
        riftmaker_weapon = true,
        lol_wp_s8_deathcap = true,
        lol_wp_s11_mejaisoulstealer = true,
    }
}


for type,items_tbl in pairs(type_map) do
    for item_prefab,_ in pairs(items_tbl) do
        AddPrefabPostInit(item_prefab,function (inst)
            if not TheWorld.ismastersim then
                return inst
            end
            inst:AddComponent('lol_wp_type')
            inst.components.lol_wp_type:SetType(type)
        end)
    end
end
