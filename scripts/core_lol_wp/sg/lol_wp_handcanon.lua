AddStategraphState('wilson',
---@diagnostic disable-next-line: undefined-global
State{
    name = "lol_wp_handcanon",
    tags = {"attack", "notalking", "abouttoattack"},

    onenter = function(inst)
        if inst.components.rider:IsRiding() then
            inst.Transform:SetFourFaced()
        end

        local buffaction = inst:GetBufferedAction()
        local target = buffaction ~= nil and buffaction.target or nil
        inst.sg.statemem.target = target
        inst.sg.statemem.target_position = target and Vector3(target.Transform:GetWorldPosition())

        inst.components.locomotor:Stop()
        inst.components.combat:StartAttack()
        inst.AnimState:PlayAnimation("lol_fishgun_shoot")

        if target and target:IsValid() then
            inst:FacePoint(target.Transform:GetWorldPosition())
        end
    end,

    timeline=
    {
---@diagnostic disable-next-line: undefined-global
        TimeEvent(21*FRAMES, function(inst)
            inst.sg:RemoveStateTag("abouttoattack")
            inst.SoundEmitter:PlaySound("dontstarve/creatures/slurtle/explode")

            -- local cloud = SpawnPrefab("cloudpuff")
            -- local pt = Vector3(inst.Transform:GetWorldPosition())

            -- local angle
            -- if inst.components.combat.target and inst.components.combat.target:IsValid() then
            --     angle = (inst:GetAngleToPoint(inst.components.combat.target.Transform:GetWorldPosition()) -90)*DEGREES
            -- else
            --     angle = (inst:GetAngleToPoint(inst.sg.statemem.target_position.x, inst.sg.statemem.target_position.y, inst.sg.statemem.target_position.z) -90)*DEGREES
            -- end
            inst.sg.statemem.target_position = nil

            -- local DIST = 1.5
            -- local offset = Vector3(DIST * math.cos( angle+(PI/2) ), 0, -DIST * math.sin( angle+(PI/2) ))

            -- local y = inst.components.rider:IsRiding() and 4.5 or 2
            -- cloud.Transform:SetPosition(pt.x + offset.x, y, pt.z + offset.z)

            inst:PerformBufferedAction()
        end),
---@diagnostic disable-next-line: undefined-global
        TimeEvent(30*FRAMES, function(inst) inst.sg:RemoveStateTag("attack") end),
    },

    events=
    {
---@diagnostic disable-next-line: undefined-global
        EventHandler("animover", function(inst)
            inst.sg:GoToState("idle")
        end),
    },

    onexit = function(inst)
        if inst.components.rider:IsRiding() then
            inst.Transform:SetSixFaced()
        end
    end,
})


AddStategraphState('wilson_client',
---@diagnostic disable-next-line: undefined-global
State{
    name = "lol_wp_handcanon",
    tags = {"attack", "notalking", "abouttoattack"},
    server_states = {"lol_wp_handcanon"},

    onenter = function(inst)
        local buffaction = inst:GetBufferedAction()
        local target = buffaction ~= nil and buffaction.target or nil
        inst.sg.statemem.target = target
        inst.sg.statemem.target_position = target and Vector3(target.Transform:GetWorldPosition())

        inst.components.locomotor:Stop()
        inst.replica.combat:StartAttack()
        inst.AnimState:PlayAnimation("lol_fishgun_shoot")

        if target and target:IsValid() then
            inst:FacePoint(target.Transform:GetWorldPosition())
        end

        inst:PerformPreviewBufferedAction()
        inst.sg:SetTimeout(2)
    end,

    ontimeout = function(inst)
        inst:ClearBufferedAction()
        inst.sg:GoToState("idle", true)
    end,

    timeline=
    {
---@diagnostic disable-next-line: undefined-global
        TimeEvent(21*FRAMES, function(inst) 
            inst.sg:RemoveStateTag("abouttoattack") 
            -- inst.SoundEmitter:PlaySound("dontstarve_DLC003/common/items/weapon/blunderbuss_shoot")
            inst.SoundEmitter:PlaySound("dontstarve/creatures/slurtle/explode")
        end),
---@diagnostic disable-next-line: undefined-global
        TimeEvent(30*FRAMES, function(inst) inst.sg:RemoveStateTag("attack") end),
    },

    events=
    {
---@diagnostic disable-next-line: undefined-global
        EventHandler("animover", function(inst)
            inst.sg:GoToState("idle")
        end),
    },

    onexit = function(inst)
        if inst.sg:HasStateTag("abouttoattack") then
            inst.replica.combat:CancelAttack()
        end
    end,
})