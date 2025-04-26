local Text = require 'widgets/text'
AddClassPostConstruct("widgets/itemtile", function(self, invitem)
    self.set_wp_ruinedking = function(self, num)
        if self.item.prefab == 'gallop_brokenking' then
            if not self.gallop_brokenking_frogblade_cd then
                self.gallop_brokenking_frogblade_cd = self:AddChild(Text(NUMBERFONT, 42))
                if JapaneseOnPS4() then
                    self.gallop_brokenking_frogblade_cd:SetHorizontalSqueeze(0.7)
                end
                self.gallop_brokenking_frogblade_cd:SetPosition(5, -32 + 15, 0)
            end

            local val_to_show = num ~= 0 and num or ' '
            -- if self.item.replica.gallop_brokenking_frogblade_cd then
            --     val_to_show = self.item.replica.gallop_brokenking_frogblade_cd:GetVal()
            -- end
            -- self.gallop_brokenking_frogblade_cd:SetColour({1,0,0,1})
            self.gallop_brokenking_frogblade_cd:SetString(tostring(val_to_show))

            if not self.dragging and self.item:HasTag("show_broken_ui") then
                if self.gallop_brokenking_frogblade_cd > 0 then
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

    if self.item.prefab == 'gallop_brokenking' then
        if self.item.replica.gallop_brokenking_frogblade_cd then
            self:set_wp_ruinedking(self.item.replica.gallop_brokenking_frogblade_cd:GetVal())
        end
    end

    self.inst:ListenForEvent("gallop_brokenking_frogblade_cd_val_change",function(invitem, data)
        self:set_wp_ruinedking(self.item.replica.gallop_brokenking_frogblade_cd:GetVal())
    end, invitem)

end)
