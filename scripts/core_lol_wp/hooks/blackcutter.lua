AddPrefabPostInit('gallop_blackcutter',function(inst)
    inst.Transform:SetScale(1,1.2,1)

    if not TheWorld.ismastersim then
        return inst
    end

end)