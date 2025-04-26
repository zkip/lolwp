local arr = {
    'lunarplant_kit',
}

for _,v in ipairs(arr) do
    AddPrefabPostInit(v,function (inst)
        if not TheWorld.ismastersim then
            return inst
        end

        if inst.components.tradable == nil then
            inst:AddComponent("tradable")
        end
    end)
end
