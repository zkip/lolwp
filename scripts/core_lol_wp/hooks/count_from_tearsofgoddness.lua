local Text = require 'widgets/text'
AddClassPostConstruct("widgets/itemtile", function(self, invitem)
    self.set_count_from_tearsofgoddness = function(self, num)
        if self.item.replica.count_from_tearsofgoddness then
            if not self.count_from_tearsofgoddness_val then
                self.count_from_tearsofgoddness_val = self:AddChild(Text(NUMBERFONT, 42))
                if JapaneseOnPS4() then
                    self.count_from_tearsofgoddness_val:SetHorizontalSqueeze(0.7)
                end
                self.count_from_tearsofgoddness_val:SetPosition(5, -32 + 15, 0)
            end

            local val_to_show = num or 0
            val_to_show = self.item.replica.count_from_tearsofgoddness:GetVal()
            -- self.count_from_tearsofgoddness_val:SetColour({1,0,0,1})
            self.count_from_tearsofgoddness_val:SetString(val_to_show)

            if not self.dragging and self.item:HasTag("show_broken_ui") then
                if self.count_from_tearsofgoddness_val > 0 then
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

    if self.item.replica.count_from_tearsofgoddness then
        self:set_count_from_tearsofgoddness(self.item.replica.count_from_tearsofgoddness:GetVal())
    end

    self.inst:ListenForEvent("count_from_tearsofgoddness_val_change",function(invitem, data)
        self:set_count_from_tearsofgoddness(self.item.replica.count_from_tearsofgoddness:GetVal())
    end, invitem)

end)
