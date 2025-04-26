local ThePlayer = GLOBAL.ThePlayer
local TheInput = GLOBAL.TheInput
local SpawnPrefab = GLOBAL.SpawnPrefab

GLOBAL.setmetatable(env,{__index=function(t,k) return GLOBAL.rawget(GLOBAL,k) end})

----掉落
-- local function lootsetfn(lootdropper)
--     lootdropper:ClearRandomLoot()
-- 	lootdropper:AddRandomLoot("alchemy_chainsaw_blueprint", 1)
--     lootdropper.numrandomloot = 1
-- end

-- local function alchemy_chainsaw(inst)
-- 	if not TheWorld.ismastersim then
-- 		return inst
-- 	end
-- 	if inst.components.lootdropper then
-- 		inst.components.lootdropper:SetLootSetupFn(lootsetfn)
-- 	end
-- end

-- AddPrefabPostInit("daywalker2", function(inst)
-- 	alchemy_chainsaw(inst)
-- end)


AddPrefabPostInit("daywalker2", function(inst)
    if not TheWorld.ismastersim then
        return inst
    end
    if not inst.components.lootdropper then
        inst:AddComponent('lootdropper')
    end
    local old_lootsetupfn = inst.components.lootdropper.lootsetupfn
    inst.components.lootdropper:SetLootSetupFn(function (...)
        local res = old_lootsetupfn ~= nil and {old_lootsetupfn(...)} or {}
        inst.components.lootdropper:AddChanceLoot('alchemy_chainsaw_blueprint',1)
        return unpack(res)
    end)
    -- inst:ListenForEvent('death',function (inst, data)
    --     LOLWP_S:declare('death')
    --     LOLWP_S:flingItem(SpawnPrefab('lol_wp_s12_eclipse_blueprint'),inst:GetPosition())
    -- end)
end)

----重伤
AddComponentPostInit("health", function(self)
    local old_DoDelta = self.DoDelta
    function self:DoDelta(amount, ...)
        local owner = self.inst
		if owner and owner.components.debuffable
		and owner.components.debuffable:HasDebuff("chainsaw_buff","chainsaw_buff")
		and amount >= 0
		then
			amount = amount*.4
        end
		return old_DoDelta(self, amount, ...)
	end
end)

AddPlayerPostInit(function(inst)
	inst:ListenForEvent("working", function(inst, data)
        local owner = inst and inst.components.inventory
		local weapon = owner and owner:GetEquippedItem(EQUIPSLOTS.HANDS)

		if weapon and weapon.prefab == "alchemy_chainsaw" and weapon:HasTag("Start_Chainsaw")
		and data.target and data.target:HasTag("CHOP_workable")
		then
			--[[local workable = data.target and data.target.components.workable
            workable.workleft = 0]]
			inst:DoTaskInTime(.03,function()
				if data.target and data.target.components.workable and data.target:HasTag("CHOP_workable") then
					data.target.components.workable:WorkedBy_Internal(inst, 1)
				end
				inst.SoundEmitter:PlaySound("chainsaw_sound/sfx/chainsaw_hit")
			end)
        end
    end)
end)

----姿势
local Chainsaw_Pity_posture_M = GLOBAL.State(
	{
		name = "Chainsaw_Pity_posture",
		tags = { "nopredict", "forcedangle", "busy", "nointerrupt", "nomorph"},

		onenter = function(inst)
            if inst.components.health then
				inst.components.health:SetInvincible(true)
			end
			inst.sg:AddStateTag("noattack")
            inst.components.locomotor:Stop()

			inst.AnimState:PlayAnimation("atk_leap")
            inst.SoundEmitter:PlaySound("dontstarve/common/deathpoof")
            if target ~= nil and target:IsValid() then
                inst.sg.statemem.target = target
                inst:ForceFacePoint(target.Transform:GetWorldPosition())
            end
			inst.Physics:SetMotorVel(46, 0, 0)

		end,

		timeline =
		{
			TimeEvent(9 * FRAMES, function(inst)
				if TheWorld.ismastersim then
					inst:PerformBufferedAction()
				end
				inst.Physics:SetMotorVel(34, 0, 0)
			end),
			TimeEvent(15 * FRAMES, function(inst)
				inst.Physics:SetMotorVel(20, 0, 0)
			end),
			TimeEvent(15.2 * FRAMES, function(inst)
				inst.SoundEmitter:PlaySound("dontstarve/movement/bodyfall_dirt")
			end),
			TimeEvent(17 * FRAMES, function(inst)
				inst.Physics:SetMotorVel(12, 0, 0)
			end),
			TimeEvent(18 * FRAMES, function(inst)
				inst.Physics:Stop()
			end),
			TimeEvent(19 * FRAMES, function(inst)
				inst.sg:RemoveStateTag("busy")
				inst.sg:RemoveStateTag("nointerrupt")
				inst.sg:RemoveStateTag("noattack")
				if inst.components.health then
					inst.components.health:SetInvincible(false)
				end
			end),
		},

		events =
		{
			EventHandler("animover", function(inst)
				if inst.AnimState:AnimDone() then
					inst.sg:GoToState("idle")
				end
			end),
		},

        onexit = function(inst)
            inst.Transform:SetFourFaced()
        end,
	}
)

local Chainsaw_Pity_posture_C = GLOBAL.State(
	{
		name = "Chainsaw_Pity_posture",
		tags = { "nopredict", "forcedangle", "busy", "nointerrupt", "nomorph"},

		onenter = function(inst)
            if inst.components.health then
				inst.components.health:SetInvincible(true)
			end
			inst.sg:AddStateTag("noattack")
            inst.components.locomotor:Stop()

			inst.AnimState:PlayAnimation("atk_leap")
            inst.SoundEmitter:PlaySound("dontstarve/common/deathpoof")
            if target ~= nil and target:IsValid() then
                inst.sg.statemem.target = target
                inst:ForceFacePoint(target.Transform:GetWorldPosition())
            end
			inst.Physics:SetMotorVel(46, 0, 0)

		end,

		timeline =
		{
			TimeEvent(9 * FRAMES, function(inst)
				if TheWorld.ismastersim then
					inst:PerformBufferedAction()
				end
				inst.Physics:SetMotorVel(34, 0, 0)
			end),
			TimeEvent(15 * FRAMES, function(inst)
				inst.Physics:SetMotorVel(20, 0, 0)
			end),
			TimeEvent(15.2 * FRAMES, function(inst)
				inst.SoundEmitter:PlaySound("dontstarve/movement/bodyfall_dirt")
			end),
			TimeEvent(17 * FRAMES, function(inst)
				inst.Physics:SetMotorVel(12, 0, 0)
			end),
			TimeEvent(18 * FRAMES, function(inst)
				inst.Physics:Stop()
			end),
			TimeEvent(19 * FRAMES, function(inst)
				inst.sg:RemoveStateTag("busy")
				inst.sg:RemoveStateTag("nointerrupt")
				inst.sg:RemoveStateTag("noattack")
				if inst.components.health then
					inst.components.health:SetInvincible(false)
				end
			end),
		},

        onexit = function(inst)
            inst.Transform:SetFourFaced()
        end,
	}
)

AddStategraphState("wilson", Chainsaw_Pity_posture_M)
AddStategraphState("wilson_client", Chainsaw_Pity_posture_C)