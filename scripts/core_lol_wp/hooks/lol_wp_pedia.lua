AddComponentPostInit('playercontroller',
---comment
---@param self component_playercontroller
function(self)
    -- 能不能玩家控制角色
    local old_IsEnabled = self.IsEnabled
    function self:IsEnabled(...)
        if ThePlayer and ThePlayer.is_checking_lol_wp_pedia then
            return false
        end
        return old_IsEnabled(self,...)
    end
end)

local ThePlayer_down_esc = false
AddClassPostConstruct('screens/playerhud',
function (self, ...)
    local old_OnControl = self.OnControl
    function self:OnControl(control, down,...)
        if control == CONTROL_PAUSE then
            if down then
                if ThePlayer and ThePlayer.is_checking_lol_wp_pedia then
                    if ThePlayer.HUD.lol_wp_pedia then
                        if ThePlayer.HUD.lol_wp_pedia.shown then
                            ThePlayer.is_checking_lol_wp_pedia = false
                            ThePlayer.HUD.lol_wp_pedia:Hide()
                            ThePlayer_down_esc = true -- 按下时记录状态
                        end
                    end
                end
            else
                -- 防止弹起时 打开pause窗口
                if ThePlayer_down_esc then
                    ThePlayer_down_esc = false
                    return
                end
            end
        end
        return old_OnControl(self,control,down,...)
    end
end)