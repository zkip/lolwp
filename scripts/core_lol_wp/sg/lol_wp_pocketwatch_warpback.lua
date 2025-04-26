AddStategraphState('wilson',
---@diagnostic disable-next-line: undefined-global
State{
    name = "lol_wp_pocketwatch_warpback_pre",
    tags = {'busy','nointerrupt'},

    ---@param inst ent
    onenter = function(inst)
        inst.components.locomotor:Stop()
        inst.AnimState:PlayAnimation("pocketwatch_warp_pre",false) -- 5 FRAMS
        inst.AnimState:PushAnimation('pocketwatch_warp',false) -- 11 FRAMS
        inst.AnimState:PushAnimation('pocketwatch_warp_pst',false) -- 12 FRAMS

        inst.components.health:SetInvincible(true)
    end,

    timeline =
    {
        ---@diagnostic disable-next-line: undefined-global
        TimeEvent(1*FRAMES, function(inst) inst.SoundEmitter:PlaySound("wanda2/characters/wanda/watch/warp") end),
        ---@diagnostic disable-next-line: undefined-global
        TimeEvent(11*FRAMES, function(inst)
			inst.sg.statemem.stafffx = SpawnPrefab("pocketwatch_warpback_fx")
			inst.sg.statemem.stafffx.entity:SetParent(inst.entity)
			inst.sg.statemem.stafffx:SetUp({ 1, 1, 1 })
        end),
        ---@diagnostic disable-next-line: undefined-global
        TimeEvent(16*FRAMES, function(inst)
            if inst.sg.statemem.stafffx ~= nil and inst.sg.statemem.stafffx:IsValid() then
				inst.sg.statemem.stafffx:Remove()
			end
            inst:PerformBufferedAction()
        end),
    },

    events =
    {
        -- ---@diagnostic disable-next-line: undefined-global
        -- EventHandler("animover", function(inst)
        --     inst.sg:GoToState("idle")
        -- end),
        ---@diagnostic disable-next-line: undefined-global
        EventHandler("animqueueover", function(inst)
            inst.sg:GoToState("idle")
        end),
    },

    onexit = function(inst)
        inst.components.health:SetInvincible(false)
    end,
})


AddStategraphState('wilson_client',
---@diagnostic disable-next-line: undefined-global
State{
    name = "lol_wp_pocketwatch_warpback_pre",
    tags = {'busy','nointerrupt'},
    server_states = {"lol_wp_pocketwatch_warpback_pre"},

    onenter = function(inst)
        inst:PerformPreviewBufferedAction()
        inst.components.locomotor:Stop()
        inst.AnimState:PlayAnimation("pocketwatch_warp_pre",false) -- 5 FRAMS
        inst.AnimState:PushAnimation('pocketwatch_warp',false) -- 11 FRAMS
        inst.AnimState:PushAnimation('pocketwatch_warp_pst',false) -- 12 FRAMS
        -- local buffaction = inst:GetBufferedAction()
        -- local target = buffaction ~= nil and buffaction.target or nil
        -- inst.sg.statemem.target = target
        -- inst.sg.statemem.target_position = target and Vector3(target.Transform:GetWorldPosition())

        -- inst.components.locomotor:Stop()
        -- inst.replica.combat:StartAttack()
        -- inst.AnimState:PlayAnimation("lol_fishgun_shoot")

        -- if target and target:IsValid() then
        --     inst:FacePoint(target.Transform:GetWorldPosition())
        -- end

        -- inst:PerformPreviewBufferedAction()
        -- inst.sg:SetTimeout()
    end,

    ontimeout = function(inst)
        inst:ClearBufferedAction()
        inst.sg:GoToState("idle", true)
    end,

    timeline =
    {
    },

    events =
    {
        ---@diagnostic disable-next-line: undefined-global
        EventHandler("animqueueover", function(inst)
            if inst.AnimState:AnimDone() then
                inst.sg:GoToState("idle")
            end
        end),
    },

    onexit = function(inst)

    end,
})