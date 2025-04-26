local data = require('core_lol_wp/data/player_timer')

-------------
for prefab,v in pairs(data.rechargeable.members) do
    AddPrefabPostInit(prefab,function (inst)
        inst:AddTag(prefab)
        if not TheWorld.ismastersim then
            return inst
        end

        if inst.components.rechargeable then
            local old_Discharge = inst.components.rechargeable.Discharge
            function inst.components.rechargeable:Discharge(chargetime,...)
                if not inst.player_timer_rechargeable_do_orig_thing then
                    local owner = LOLWP_S:GetOwnerReal(inst)
                    if owner and owner.components.player_timer then
                        local allow = false
                        local only_allow_avatars = data.rechargeable.members[prefab].only_allow_avatars
                        if only_allow_avatars then
                            if only_allow_avatars[owner.prefab] then
                                allow = true
                            end
                        else
                            allow = true
                        end
                        if allow then
                            owner.components.player_timer:WhenItemCD('rechargeable',prefab,chargetime,inst)
                        end
                    end
                end
                return old_Discharge(self,chargetime,...)
            end
        end

        local flag_dropped_once_or_never_putininv = true
        inst:ListenForEvent('onputininventory',function ()
            if flag_dropped_once_or_never_putininv then
                flag_dropped_once_or_never_putininv = false
                local owner = LOLWP_S:GetOwnerReal(inst)
                if owner and owner.components.player_timer then
                    local allow = false
                    local only_allow_avatars = data.rechargeable.members[prefab].only_allow_avatars
                    if only_allow_avatars then
                        if only_allow_avatars[owner.prefab] then
                            allow = true
                        end
                    else
                        allow = true
                    end
                    if allow then
                        owner.components.player_timer:WhenGetItem('rechargeable',prefab,inst)
                    end
                end
            end
        end)
        inst:ListenForEvent('ondropped',function ()
            flag_dropped_once_or_never_putininv = true
        end)

    end)
end

--------------
for prefab,v in pairs(data.lol_wp_cd_itemtile.members) do
    AddPrefabPostInit(prefab,function (inst)
        if not TheWorld.ismastersim then
            return inst
        end
        if inst.components.lol_wp_cd_itemtile then
            local old_ForceStartCD = inst.components.lol_wp_cd_itemtile.ForceStartCD
            function inst.components.lol_wp_cd_itemtile:ForceStartCD(...)
                if not inst.player_timer_lol_wp_cd_itemtile_do_orig_thing then
                    local owner = LOLWP_S:GetOwnerReal(inst)
                    if owner and owner.components.player_timer then
                        owner.components.player_timer:WhenItemCD('lol_wp_cd_itemtile',prefab,self.cd,inst)
                    end
                end
                return old_ForceStartCD(self,...)
            end
        end

        local flag_dropped_once_or_never_putininv = true
        inst:ListenForEvent('onputininventory',function ()
            if flag_dropped_once_or_never_putininv then
                flag_dropped_once_or_never_putininv = false
                local owner = LOLWP_S:GetOwnerReal(inst)
                if owner and owner.components.player_timer then
                    owner.components.player_timer:WhenGetItem('lol_wp_cd_itemtile',prefab,inst)
                end
            end
        end)
        inst:ListenForEvent('ondropped',function ()
            flag_dropped_once_or_never_putininv = true
        end)

    end)
end

--------------
for prefab,v in pairs(data.gallop_brokenking_frogblade_cd.members) do
    AddPrefabPostInit(prefab,function (inst)
        if not TheWorld.ismastersim then
            return inst
        end
        if inst.components.gallop_brokenking_frogblade_cd then
            local old_StartCD = inst.components.gallop_brokenking_frogblade_cd.StartCD
            function inst.components.gallop_brokenking_frogblade_cd:StartCD(...)
                if not inst.player_timer_gallop_brokenking_frogblade_cd_do_orig_thing then
                    local owner = LOLWP_S:GetOwnerReal(inst)
                    if owner and owner.components.player_timer then
                        owner.components.player_timer:WhenItemCD('gallop_brokenking_frogblade_cd',prefab,self.cd,inst)
                    end
                end
                return old_StartCD(self,...)
            end
        end

        local flag_dropped_once_or_never_putininv = true
        inst:ListenForEvent('onputininventory',function ()
            if flag_dropped_once_or_never_putininv then
                flag_dropped_once_or_never_putininv = false
                local owner = LOLWP_S:GetOwnerReal(inst)
                if owner and owner.components.player_timer then
                    owner.components.player_timer:WhenGetItem('gallop_brokenking_frogblade_cd',prefab,inst)
                end
            end
        end)
        inst:ListenForEvent('ondropped',function ()
            flag_dropped_once_or_never_putininv = true
        end)
    end)
end



AddPlayerPostInit(function (inst)
    if not TheWorld.ismastersim then
        return inst
    end
    inst:AddComponent('player_timer')
end)