-- ---comment
-- ---@param inst ent
-- local function calcPos(inst)
--     local start_x,_,start_z = inst:GetPosition():Get()
--     local des_x,des_z
--     if inst.ACTION_BH_MOBIUS_SWORD_LEAP then
--         des_x = inst.ACTION_BH_MOBIUS_SWORD_LEAP.x
--         des_z = inst.ACTION_BH_MOBIUS_SWORD_LEAP.z
--     end
--     if des_x and des_z then
--         local dist = C_BH_MOBIUS:calcDist(start_x,start_z,des_x,des_z,true) 
--         local res_x,res_z = C_BH_MOBIUS:findPointOnLine(start_x,start_z,des_x,des_z,dist,1)
--         inst.Transform:SetPosition(res_x,0,res_z)
--     end
-- end

local timelines = {}

-- for i = 1,12,2 do
--     table.insert(timelines,TimeEvent(i * FRAMES, function(inst)
--         calcPos(inst)
--     end))
-- end
table.insert(timelines,TimeEvent(0*FRAMES,function(inst)
    -- inst.SoundEmitter:PlaySound("moonstorm/creatures/boss/alterguardian3/atk_beam")
end))
table.insert(timelines,TimeEvent(1*FRAMES,function(inst)
    inst.SoundEmitter:PlaySound('soundfx_lol_wp_divine/divine/wield_sword',nil,0.15)
    
end))
table.insert(timelines,TimeEvent(5*FRAMES,function(inst)
    -- inst.SoundEmitter:PlaySound('soundfx_lol_wp_divine/divine/wield_sword',nil,0.2)
    
end))
table.insert(timelines,TimeEvent(10*FRAMES,function(inst)
    inst.components.colouradder:PushColour("helmsplitter", .1, .1, 0, 0)

end))
table.insert(timelines,TimeEvent(11*FRAMES,function(inst)
    inst.components.colouradder:PushColour("helmsplitter", .2, .2, 0, 0)
    
end))
table.insert(timelines,TimeEvent(12*FRAMES,function(inst)
    inst.components.colouradder:PushColour("helmsplitter", .4, .4, 0, 0)
    
end))

table.insert(timelines,TimeEvent(13 * FRAMES, function(inst)
    inst.components.bloomer:PushBloom("helmsplitter", "shaders/anim.ksh", -2)
    inst.components.colouradder:PushColour("helmsplitter", 1, 1, 0, 0)
    inst.sg:RemoveStateTag("nointerrupt")
    ShakeAllCameras(CAMERASHAKE.VERTICAL, .5, .015, .5, inst, 20)
    inst.SoundEmitter:PlaySound("dontstarve/creatures/deerclops/laser")
    -- inst.SoundEmitter:PlaySound('soundfx_lol_wp_divine/divine/hammer_smash',nil,0.15)
    
    inst:PerformBufferedAction()
end))

table.insert(timelines,TimeEvent(14*FRAMES,function(inst)
    inst.components.colouradder:PushColour("helmsplitter", .8, .8, 0, 0)
end))
table.insert(timelines,TimeEvent(15*FRAMES,function(inst)
    inst.components.colouradder:PushColour("helmsplitter", .6, .6, 0, 0)
end))
table.insert(timelines,TimeEvent(16*FRAMES,function(inst)
    inst.components.colouradder:PushColour("helmsplitter", .4, .4, 0, 0)
end))
table.insert(timelines,TimeEvent(17*FRAMES,function(inst)
    inst.components.colouradder:PushColour("helmsplitter", .2, .2, 0, 0)
end))
table.insert(timelines,TimeEvent(18*FRAMES,function(inst)
    inst.components.colouradder:PopColour("helmsplitter")
end))
table.insert(timelines,TimeEvent(19*FRAMES,function(inst)
    inst.components.bloomer:PopBloom("helmsplitter")

    -- inst.SoundEmitter:PlaySound('moonstorm/creatures/boss/alterguardian3/atk_beam_laser',nil,0.2)
    
end))
AddStategraphState('wilson',
State{
    name = "lol_wp_s12_eclipse_leap_laser",
    tags = { "aoe", "doing", "busy", "nointerrupt", "nopredict", "nomorph" },

    ---comment
    ---@param inst ent
    ---@param data any
    onenter = function(inst, data)
        inst.AnimState:PlayAnimation('atk_leap')

        -- local buffaction = inst:GetBufferedAction()
        -- if buffaction ~= nil and buffaction.pos ~= nil then
        --     local x,y,z = buffaction:GetActionPoint():Get()
        --     inst.ACTION_BH_MOBIUS_SWORD_LEAP = {x=x,y=y,z=z}
        -- end
        inst.sg:SetTimeout(21 * FRAMES)
    end,

    onupdate = function(inst)
    end,

    timeline = timelines,

    ontimeout = function(inst)
        inst.sg:GoToState("idle", true)
    end,

    events =
    {
        EventHandler("animover", function(inst)
            if inst.AnimState:AnimDone() then
                inst.sg:GoToState("idle")
            end
        end),
    },

    onexit = function(inst)
        inst.components.bloomer:PopBloom("helmsplitter")
        inst.components.colouradder:PopColour("helmsplitter")
    end,
})


AddStategraphState('wilson_client',
State{
    name = "lol_wp_s12_eclipse_leap_laser",
    tags = { "aoe", "doing", "busy", "nointerrupt", "nopredict", "nomorph" },

    ---comment
    ---@param inst ent
    ---@param data any
    onenter = function(inst, data)
        inst.components.locomotor:Stop()
        inst.AnimState:PlayAnimation("atk_leap")
        inst:PerformPreviewBufferedAction()
    end,

    timeline =
    {
    },

    onexit = function(inst)
    end,
})