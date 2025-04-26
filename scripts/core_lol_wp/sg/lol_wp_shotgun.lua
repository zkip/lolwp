AddStategraphState("wilson",     State{
    name = "lol_wp_shotgun",
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
        -- inst.AnimState:PlayAnimation("lol_wp_speargun_shoot")
        inst.AnimState:PlayAnimation("speargun")

        if target and target:IsValid() then
            inst:FacePoint(target.Transform:GetWorldPosition())
        end
    end,

    timeline=
    {
        TimeEvent(12*FRAMES, function(inst)
            inst.sg:RemoveStateTag("abouttoattack")

            -- local cloud = SpawnPrefab("cloudpuff")
            local pt = Vector3(inst.Transform:GetWorldPosition())

            local angle
            if inst.components.combat.target and inst.components.combat.target:IsValid() then
                angle = (inst:GetAngleToPoint(inst.components.combat.target.Transform:GetWorldPosition()) -90)*DEGREES
            else
                angle = (inst:GetAngleToPoint(inst.sg.statemem.target_position.x, inst.sg.statemem.target_position.y, inst.sg.statemem.target_position.z) -90)*DEGREES
            end
            inst.sg.statemem.target_position = nil

            local DIST = 1.5
            local offset = Vector3(DIST * math.cos( angle+(PI/2) ), 0, -DIST * math.sin( angle+(PI/2) ))

            local y = inst.components.rider:IsRiding() and 4.5 or 2
            -- cloud.Transform:SetPosition(pt.x + offset.x, y, pt.z + offset.z)

            inst:PerformBufferedAction()
        end),
        TimeEvent(20*FRAMES, function(inst) inst.sg:RemoveStateTag("attack") end),
    },

    events=
    {
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

local TIMEOUT = 2

AddStategraphState("wilson_client",     State{
    name = "lol_wp_shotgun",
    tags = {"attack", "notalking", "abouttoattack"},
    server_states = {"lol_wp_shotgun"},

    onenter = function(inst)
        local buffaction = inst:GetBufferedAction()
        local target = buffaction ~= nil and buffaction.target or nil
        inst.sg.statemem.target = target
        inst.sg.statemem.target_position = target and Vector3(target.Transform:GetWorldPosition())

        inst.components.locomotor:Stop()
        inst.replica.combat:StartAttack()
        -- inst.AnimState:PlayAnimation("lol_wp_speargun_shoot")
        inst.AnimState:PlayAnimation("speargun")

        if target and target:IsValid() then
            inst:FacePoint(target.Transform:GetWorldPosition())
        end

        inst:PerformPreviewBufferedAction()
        inst.sg:SetTimeout(TIMEOUT)
    end,

    ontimeout = function(inst)
        inst:ClearBufferedAction()
        inst.sg:GoToState("idle", true)
    end,

    timeline=
    {
        TimeEvent(12*FRAMES, function(inst) inst.sg:RemoveStateTag("abouttoattack") end),
        TimeEvent(20*FRAMES, function(inst) inst.sg:RemoveStateTag("attack") end),
    },

    events=
    {
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
