
local Text = require 'widgets/text'
AddClassPostConstruct("widgets/itemtile",
function(self, invitem)
    function self:SetLOLWPItemtileCD(val)

        local prefab = self.item.prefab .. 'lol_wp_cd_itemtile'
        if not self[prefab] then
            self[prefab] = self:AddChild(Text(NUMBERFONT, 42))
            if JapaneseOnPS4() then
                self[prefab]:SetHorizontalSqueeze(0.7)
            end
            self[prefab]:SetPosition(5, -32 + 15, 0)
        end
        local val_to_show = val ~= 0 and val or ' '
        self[prefab]:SetString(tostring(val_to_show))
        if not self.dragging and self.item:HasTag("show_broken_ui") then
            if self[prefab] > 0 then
                self.bg:Hide()
                -- self.spoilage:Hide()
            else
                self.bg:Show()
                -- self:SetPerishPercent(0)
            end
        end
    end

    if self.item.replica.lol_wp_cd_itemtile and self.item.replica.lol_wp_cd_itemtile:ShouldShown() then
        self:SetLOLWPItemtileCD(self.item.replica.lol_wp_cd_itemtile:GetCurCD())
    end

    self.inst:ListenForEvent("lol_wp_cd_itemtile_cur_cd_change",function()
        if self.item.replica.lol_wp_cd_itemtile and self.item.replica.lol_wp_cd_itemtile:ShouldShown() then
            self:SetLOLWPItemtileCD(self.item.replica.lol_wp_cd_itemtile:GetCurCD())
        end
    end, invitem)
end)