
return {
	{
		stategraph = "wilson",
		state = State {
			name = "lolwp_triple_atk",
			tags = { "attack", "notalking", "abouttoattack", "autopredict", "lolwp_triple_atk" },

			onenter = function(inst)
				print("GGGGGGGGGGGGG triple_atk enter")
				inst.AnimState:SetDeltaTimeMultiplier(2)

				if inst.components.combat:InCooldown() then
					inst.sg:RemoveStateTag("abouttoattack")
					inst:ClearBufferedAction()
					inst.sg:GoToState("idle", true)
					return
				end

				if inst.sg.laststate == inst.sg.currentstate then
					inst.sg.statemem.chained = true
				end

				local buffaction = inst:GetBufferedAction()
				local target = buffaction ~= nil and buffaction.target or nil
				inst.components.combat:SetTarget(target)
				inst.components.combat:StartAttack()
				inst.components.locomotor:Stop()

				local cooldown = inst.components.combat.min_attack_period + .5 * FRAMES
				cooldown = math.max(cooldown, 15 * FRAMES)

				inst.AnimState:PlayAnimation("multithrust")
				inst.sg:SetTimeout(cooldown)

				if target ~= nil then
					inst.components.combat:BattleCry()
					if target:IsValid() then
						inst:FacePoint(target:GetPosition())
						inst.sg.statemem.attacktarget = target
						inst.sg.statemem.retarget = target
					end
				end
			end,

			timeline =
			{
				TimeEvent(8 * FRAMES, function(inst)
					inst.components.combat:DoAttack()
				end),
				TimeEvent(10 * FRAMES, function(inst)
					inst.components.combat:DoAttack()
				end),	
				TimeEvent(12 * FRAMES, function(inst)
					inst:PerformBufferedAction()
				end),
				TimeEvent(13 * FRAMES, function(inst)
					inst.sg:RemoveStateTag("abouttoattack")
				end),
			},

			ontimeout = function(inst)
				inst.sg:RemoveStateTag("attack")
				inst.sg:AddStateTag("idle")
			end,

			events =
			{
				EventHandler("equip", function(inst) inst.sg:GoToState("idle") end),
				EventHandler("unequip", function(inst) inst.sg:GoToState("idle") end),
				EventHandler("animqueueover", function(inst)
					print("animqueueover@@@@@@@@@@@@@", inst)
					if inst.AnimState:AnimDone() then
						print("animqueueover@@@@@@@@@@@@@ anim done")
						inst.sg:GoToState("idle")
						print("triple_atk::::::::::", inst.sg.currentstate.name)
					end
				end),
			},

			onexit = function(inst)
				print("triple_atk::::::::::", inst)
				inst.components.combat:SetTarget(nil)
				if inst.sg:HasStateTag("abouttoattack") then
					inst.components.combat:CancelAttack()
				end
				inst.AnimState:SetDeltaTimeMultiplier(1)
			end,
		}
	},
	
	{
		stategraph = "wilson_client",
		state = State {
			name = "lolwp_triple_atk",
			tags = { "attack", "notalking", "abouttoattack"},

			onenter = function(inst)
				inst.AnimState:SetDeltaTimeMultiplier(2)

				local buffaction = inst:GetBufferedAction()
				local cooldown = 0

				local combat_replica = inst.replica.combat
				local in_cooldown = combat_replica and combat_replica:InCooldown()

				if in_cooldown then
					inst.sg:RemoveStateTag("abouttoattack")
					inst:ClearBufferedAction()
					inst.sg:GoToState("idle", true)
					return
				end

				if combat_replica then
					combat_replica:StartAttack()
					cooldown = combat_replica:MinAttackPeriod() + .5 * FRAMES
				end

				if cooldown > 0 then
					cooldown = math.max(cooldown, 15 * FRAMES)
				end

				if inst.sg.laststate == inst.sg.currentstate then
					inst.sg.statemem.chained = true
				end

				inst.components.locomotor:Stop()
				inst.AnimState:PlayAnimation("multithrust")
				
				if buffaction ~= nil then
					inst:PerformPreviewBufferedAction()

					if buffaction.target ~= nil and buffaction.target:IsValid() then
						inst:FacePoint(buffaction.target:GetPosition())
						inst.sg.statemem.attacktarget = buffaction.target
						inst.sg.statemem.retarget = buffaction.target
					end
				end

				if cooldown > 0 then
					inst.sg:SetTimeout(cooldown)
				end
			end,

			timeline =
			{
				TimeEvent(12 * FRAMES, function(inst)
					inst:ClearBufferedAction()
				end),
				TimeEvent(13 * FRAMES, function(inst)
					inst.sg:RemoveStateTag("abouttoattack")
				end),
			},

			ontimeout = function(inst)
				inst.sg:RemoveStateTag("attack")
				inst.sg:AddStateTag("idle")
			end,

			events =
			{
				EventHandler("animqueueover", function(inst)
					if inst.AnimState:AnimDone() then
						inst.sg:GoToState("idle")
					end
				end),
			},

			onexit = function(inst)
				if inst.sg:HasStateTag("abouttoattack") and inst.replica.combat ~= nil then
					inst.replica.combat:CancelAttack()
				end
				inst.AnimState:SetDeltaTimeMultiplier(1)
			end,
		}
	}

}