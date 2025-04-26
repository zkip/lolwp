-- local function Gallop_Action(sg)
--     local old_attack = sg.states["attack"]
--     if old_attack ~= nil then
--         local old_onenter = old_attack.onenter
--         old_attack.onenter = function(inst)
--             local equip, isriding = nil, nil
--             if TheWorld.ismastersim then
--                 equip = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
--                 isriding = inst.components.rider:IsRiding()
--             else
--                 equip = inst.replica.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
--                 isriding = inst.replica.rider ~= nil and inst.replica.rider:IsRiding()
--             end
--             if equip ~= nil and equip:HasTag("lol_wp_s12_malignance_tri_atk") then
--                 local buffaction = inst:GetBufferedAction()
--                 local target = buffaction ~= nil and buffaction.target or nil
--                 if target and target:IsValid() and not target:HasTag('cant_be_lol_wp_s12_malignance_tri_atk') then
--                     if not isriding then
--                         inst.sg:GoToState("gallop_triple_atk")
--                         return
--                     end
--                 end
--             end
--             -- if equip ~= nil and equip:HasTag("gallop_blackcutter") then
--             --     if not isriding then 
--             --         inst.sg:GoToState("gallop_blackcutter_atk")
--             --         return
--             --     end
--             -- end
--             if old_onenter then
--                 return old_onenter(inst)
--             end
--         end
--     end

--     -- for k,v in pairs({"doswipeaction", "attack_pillow", "helmsplitter_pre"}) do
--     --     local old_action = sg.states[v]
--     --     if old_action ~= nil then
--     --         local old_onenter = old_action.onenter
--     --         old_action.onenter = function(inst)
--     --             if old_onenter then
--     --                 old_onenter(inst)
--     --             end
--     --             local weapon = inst.replica.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
--     --             if weapon and ((weapon:HasTag("gallop_chop") and weapon.gallop_chop_cd and weapon.gallop_chop_cd > 0) 
--     --                     or weapon:HasTag("gallop_blackcutter") or weapon:HasTag("gallop_ad_destroyer")) then
--     --                 if inst.components.playercontroller then
--     --                     inst.components.playercontroller:ClearActionHold()
--     --                 end
--     --             end
--     --         end
--     --     end
--     -- end

--     -- local old_caseaoe = sg.actionhandlers[ACTIONS.CASTAOE].deststate
--     -- sg.actionhandlers[ACTIONS.CASTAOE].deststate = function(inst,action)
--     --     if action.invobject then
--     --         if action.invobject:HasTag("gallop_ad_destroyer") then
--     --             return "dojostleaction"
--     --         end
--     --     end
--     --     return old_caseaoe(inst, action)
--     -- end
-- end

-- AddStategraphPostInit("wilson", Gallop_Action)
-- AddStategraphPostInit("wilson_client", Gallop_Action)




local old_stroverridefn = ACTIONS.CASTAOE.stroverridefn
ACTIONS.CASTAOE.stroverridefn = function(act, ...)
	if act.invobject ~= nil and act.invobject.prefab == 'lol_wp_s12_malignance' then
		return STRINGS.MOD_LOL_WP.ACTIONS.ACTION_LOL_WP_MALIGNACE_LEAP
	end
    if old_stroverridefn ~= nil then
        return old_stroverridefn(act, ...)
    end
    return
end