-- 所有在眼石中可以变形的物品

local data = {
    'lol_wp_trinity',
    'riftmaker_amulet',
    'lol_wp_s13_infinity_edge_amulet',
}

for _,v in ipairs(data) do
    AddPrefabPostInit(v,function (inst)
        if not TheWorld.ismastersim then
            return inst
        end
        inst:AddComponent('lol_wp_amulet_transfer_in_eyestone')
    end)
end
