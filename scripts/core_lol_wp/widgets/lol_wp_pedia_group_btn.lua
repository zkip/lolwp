local Widget = require 'widgets/widget' -- 引入基类
local Image = require 'widgets/image'
local ImageButton = require 'widgets/imagebutton'

local XML_lol_wp_pedia_group_btn = 'images/lol_wp_pedia/lol_wp_pedia_group_btn.xml'

---@class widget_lol_wp_pedia_group_btn : widget_widget
---@field btn widget_lol_wp_pedia_group_btn.btn
---@field frame widget_image
local lol_wp_pedia_group_btn = Class(Widget,
---comment
---@param self widget_lol_wp_pedia_group_btn
---@param txt string
---@param color RGBA
---@param fn any
function(self,txt,color,fn)

    Widget._ctor(self, 'lol_wp_pedia_group_btn') -- 调用基类构造函数

    ---@class widget_lol_wp_pedia_group_btn.btn : widget_imagebutton
    self.btn = self:AddChild(ImageButton(XML_lol_wp_pedia_group_btn,'tab.tex','tab.tex','tab.tex'))
    self.btn.pressed = false -- 是否被选中并点击
    self.btn.focused = false
    self.btn.scale_on_focus = false
    -- self.btn.move_on_click = false

    self.frame = self:AddChild(Image(XML_lol_wp_pedia_group_btn,'tab_over.tex'))
    self.frame:SetClickable(false)
    self.frame:Hide()

    self.btn.image:SetTint(unpack(color))
    self.btn:SetText(txt)
    self.btn:SetTextSize(45)
    self.btn.text:SetPosition(0,-13,0)
    -- self.btn:SetOnClick(function()
    --     fn()
    -- end)

    self.btn:SetOnGainFocus(function()
        if not self.btn.pressed then
            self.frame:SetTexture(XML_lol_wp_pedia_group_btn,'tab_over.tex')
            self.frame:Show()
        end
    end)
    self.btn:SetOnClick(function()
        self.btn.pressed = true
        self.frame:SetTexture(XML_lol_wp_pedia_group_btn,'tab_selected.tex')
        self.frame:Show()
        fn()
    end)
    self.btn:SetOnLoseFocus(function()
        if not self.btn.pressed then
            self.frame:Hide()
        end
    end)

end)

---由于本按钮是单选,点击其他按钮后,需要执行我
function lol_wp_pedia_group_btn:OnClickOtherBtn()
    self.btn.pressed = false
    self.frame:Hide()
end

return lol_wp_pedia_group_btn