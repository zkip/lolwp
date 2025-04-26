-- -- 冰冻触发那啥

-- AddComponentPostInit('freezable',
-- ---comment
-- ---@param self component_freezable
-- function (self)
--     local old_AddColdness = self.AddColdness
--     function self:AddColdness(coldness,freezetime,nofreeze,...)


--         return old_AddColdness ~= nil and old_AddColdness(self,coldness,freezetime,nofreeze,true,...) or nil
--     end
-- end)