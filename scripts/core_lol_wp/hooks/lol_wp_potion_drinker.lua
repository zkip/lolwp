AddPlayerPostInit(function (inst)
    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent('lol_wp_potion_drinker')
end)