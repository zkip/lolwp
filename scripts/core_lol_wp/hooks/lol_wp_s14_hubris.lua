local db = TUNING.MOD_LOL_WP.HUBRIS
-- 物品下方会显示叠加的被动层数。
local Text = require 'widgets/text'
AddClassPostConstruct("widgets/itemtile", function(self, invitem)
    self.set_lol_wp_s14_hubris = function(self, num)
        if self.item.prefab == 'lol_wp_s14_hubris' then
            if not self.lol_wp_s14_hubris_val then
                self.lol_wp_s14_hubris_val = self:AddChild(Text(NUMBERFONT, 42))
                if JapaneseOnPS4() then
                    self.lol_wp_s14_hubris_val:SetHorizontalSqueeze(0.7)
                end
                self.lol_wp_s14_hubris_val:SetPosition(5, -32 + 15, 0)
            end

            local val_to_show = num or 0
            if self.item.replica.lol_wp_s14_hubris_skill_reputation then
                val_to_show = self.item.replica.lol_wp_s14_hubris_skill_reputation:GetVal()
            end
            -- self.lol_wp_s14_hubris_val:SetColour({1,0,0,1})
            self.lol_wp_s14_hubris_val:SetString(val_to_show)

            if not self.dragging and self.item:HasTag("show_broken_ui") then
                if self.lol_wp_s14_hubris_val > 0 then
                    self.bg:Hide()
                    -- self.spoilage:Hide()
                else
                    self.bg:Show()
                    -- self:SetPerishPercent(0)
                end
            end
            -- return
        end
    end

    if self.item.prefab == 'lol_wp_s14_hubris' then
        if self.item.replica.lol_wp_s14_hubris_skill_reputation then
            self:set_lol_wp_s14_hubris(self.item.replica.lol_wp_s14_hubris_skill_reputation:GetVal())
        end
    end

    self.inst:ListenForEvent("lol_wp_s14_hubris_skill_reputation_val_change",function(invitem, data)
        self:set_lol_wp_s14_hubris(self.item.replica.lol_wp_s14_hubris_skill_reputation:GetVal())
    end, invitem)

end)


---狂妄的加成不用亲手击杀，助攻也算+1层
---@source /lol_wp_s11_darkseal_and_mejaisoulstealer.lua:115
local __jump

-- 击败蜂王掉落蓝
AddPrefabPostInit("beequeen", function(inst)
    if not TheWorld.ismastersim then
        return inst
    end
    if not inst.components.lootdropper then
        inst:AddComponent('lootdropper')
    end
    local old_lootsetupfn = inst.components.lootdropper.lootsetupfn
    inst.components.lootdropper:SetLootSetupFn(function (...)
        local res = old_lootsetupfn ~= nil and {old_lootsetupfn(...)} or {}
        inst.components.lootdropper:AddChanceLoot('lol_wp_s14_hubris_blueprint',db.BLUEPRINTDROP_CHANCE.beequeen)
        return unpack(res)
    end)
    -- inst:ListenForEvent('death',function (inst, data)
    --     LOLWP_S:declare('death')
    --     LOLWP_S:flingItem(SpawnPrefab('lol_wp_s12_eclipse_blueprint'),inst:GetPosition())
    -- end)
end)