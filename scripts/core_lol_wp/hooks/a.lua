--[[ 

local worm_map = {
    worm_boss_dirt = true,
    worm_boss_dirt_ground_fx = true,
    worm_boss_head = true,
    worm_boss_segment = true,

}

local anim_map = {}

AddPrefabPostInitAny(function (inst)
    if inst.AnimState then
        anim_map[inst.AnimState] = inst
    end
    if not TheWorld.ismastersim then
        return inst
    end
end)



local old_PlayAnimation = AnimState.PlayAnimation
function AnimState:PlayAnimation(...)
    local inst = anim_map[self]
    if inst and inst.prefab and worm_map[inst.prefab] then
        return
    end
    return old_PlayAnimation(self,...)
end
 ]]




--  AddPlayerPostInit(function(inst)
--     inst:DoTaskInTime(0, function()
--         TheInput:AddKeyDownHandler(KEY_H, function()
--             if inst == ThePlayer then
--                 local ents = TheSim:GetEntitiesAtScreenPoint(TheSim:GetPosition())
--                 for _,v in ipairs(ents or {}) do
--                     print(v,v.name,v.widget,v.widget.parent)
--                 end
--                 print('--------------------')
--             end
--         end)
--     end)
-- end)


-- AddClassPostConstruct('widgets/scrollablelist',function (self,items, listwidth, listheight, itemheight, itempadding, updatefn, widgetstoupdate, widgetXOffset, always_show_static, starting_offset, yInit, bar_width_scale_factor, bar_height_scale_factor, scrollbar_style, ...)
--     if scrollbar_style and type(scrollbar_style) == 'table' and scrollbar_style.unique and scrollbar_style.unique == 'lol_wp_pedia' then
--         self.scrollbar_style = scrollbar_style
--     end
-- end)

-- local old_GoToState = StateGraphInstance.GoToState
-- function StateGraphInstance:GoToState(statename, params,...)
--     print(statename)
--     return old_GoToState(self,statename, params,...)
-- end

