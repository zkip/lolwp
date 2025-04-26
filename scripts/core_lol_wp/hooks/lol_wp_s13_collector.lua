local modid = 'lol_wp'
local db = TUNING.MOD_LOL_WP.COLLECTOR

AddPrefabPostInit('sunkenchest',function (inst)
    if not TheWorld.ismastersim then
        return inst
    end
    -- inst:ListenForEvent('workfinished',function ()
    --     print('workfinished')
    --     print(TheWorld.state.cycles)
    -- end)
    inst:ListenForEvent('worked',function ()
        -- print(inst.components.workable.workleft)
        -- print('worked')
        -- print(TheWorld.state.cycles)
        local pt = inst:GetPosition()
        local workleft = inst.components.workable and inst.components.workable.workleft
        if workleft and workleft <= 0 then
            local passed_day = TheWorld.state.cycles or 0
            local chance = math.clamp(Lerp(db.DROP_FROM_OCEANCHEST.START_CHANCE,db.DROP_FROM_OCEANCHEST.MAX_CHANCE,passed_day/db.DROP_FROM_OCEANCHEST.MAX_DAY),db.DROP_FROM_OCEANCHEST.START_CHANCE,db.DROP_FROM_OCEANCHEST.MAX_CHANCE)
            if math.random() < chance then
                LOLWP_S:flingItem(SpawnPrefab('lol_wp_s13_collector'),pt)
            end
        end
    end)
end)

if TUNING[string.upper('CONFIG_'..modid..'collector_drop_gold')] then
    -- 被动：【死与税】
    AddComponentPostInit("health",
    ---comment
    ---@param self component_health
    function(self)
        local old_SetVal = self.SetVal
        function self:SetVal(val,cause,afflicter,...)
            local res = {old_SetVal(self,val,cause,afflicter,...)}

            local victim = self.inst
            -- 当死亡
            if self:IsDead() then
                local wp = afflicter and afflicter.last_atk_weapon
                -- 是收集者击杀
                if wp and wp.prefab and wp.prefab == 'lol_wp_s13_collector' then
                    -- 筛选
                    if not victim:HasTag('wall') and not victim:HasTag('structure') then
                        local golds_num = db.SKILL_DEATH_AND_TAX.GOLDNUGGET_WHEN_KILL_NORMAL
                        if victim:HasTag('epic') then
                            golds_num = golds_num + db.SKILL_DEATH_AND_TAX.GOLDNUGGET_WHEN_KILL_BOSS
                        end
                        local victim_pt = victim:GetPosition()
                        for i=1,golds_num do
                            LOLWP_S:flingItem(SpawnPrefab('goldnugget'),victim_pt)
                        end
                    end
                end
            end

            return unpack(res)
        end
    end)
end


