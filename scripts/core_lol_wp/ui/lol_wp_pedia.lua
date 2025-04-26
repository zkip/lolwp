local ImageButton = require 'widgets/imagebutton'
local lol_wp_pedia = require 'core_lol_wp/widgets/lol_wp_pedia' -- 引入我们刚刚写的类

AddClassPostConstruct('screens/playerhud',function(self) -- 找到玩家界面 
    ---@type widget_lol_wp_pedia
    self.lol_wp_pedia = self:AddChild(lol_wp_pedia())
    self.lol_wp_pedia:Hide()

    ---@type widget_imagebutton
    self.lol_wp_pedia_logo = self:AddChild(ImageButton('images/tab_lol_wp.xml', 'tab_lol_wp.tex','tab_lol_wp.tex','tab_lol_wp.tex','tab_lol_wp.tex','tab_lol_wp.tex'))
    self.lol_wp_pedia_logo:SetPosition(68,27)
    self.lol_wp_pedia_logo:SetScale(.67,.67)
    self.lol_wp_pedia_logo:SetOnClick(function()
        if self.lol_wp_pedia then
            if self.lol_wp_pedia.shown then
                self.lol_wp_pedia:Hide()
                ThePlayer.is_checking_lol_wp_pedia = false
            else
                self.lol_wp_pedia:Show()
                ThePlayer.is_checking_lol_wp_pedia = true
            end
        end
    end)
    self.lol_wp_pedia_logo.OnMouseButton = function(_self, button, down, x, y,...)
        if button == MOUSEBUTTON_RIGHT and down then
            self.lol_wp_pedia_logo:FollowMouse()
        else
            self.lol_wp_pedia_logo:StopFollowMouse()
            -- self.lol_wp_pedia_logo:SetPosition(TheInput:GetScreenPosition())
        end
    end
end)