AddComponentPostInit('aoetargeting',
---comment
---@param self component_aoetargeting
function (self)
    function self:StartTargeting()
        if ThePlayer ~= nil and ThePlayer.components.playercontroller ~= nil then
            if self.inst.replica.inventoryitem ~= nil and self.inst.replica.inventoryitem:IsGrandOwner(ThePlayer) then
                if self.inst.components.reticule == nil then
                    self.inst:AddComponent("reticule")
                end
                for k, v in pairs(self.reticule) do
					self.inst.components.reticule[k] = v
				end
				ThePlayer.components.playercontroller:RefreshReticule(self.inst)
            end
        end
    end
end)