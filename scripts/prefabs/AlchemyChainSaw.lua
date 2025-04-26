
local assets =
{
	Asset("ANIM", "anim/swap_punk_alchemy_saw_sword.zip"),
	Asset("ANIM", "anim/punk_alchemy_saw_sword.zip"),
	Asset("ANIM", "anim/alchemy_chainsaw_fx.zip"),
	Asset("IMAGE", "images/alchemy_chainsaw.tex"),
	Asset("ATLAS", "images/alchemy_chainsaw.xml"),
	Asset("IMAGE", "images/alchemy_chainsaw2.tex"),
	Asset("ATLAS", "images/alchemy_chainsaw2.xml"),
	
	Asset("ANIM", "anim/blueprint_rare.zip"),
}

local function Chainsaw_Stop(inst)
	if inst:HasTag("Start_Chainsaw") then
		inst:RemoveTag("Start_Chainsaw")
		inst.SoundEmitter:PlaySound("chainsaw_sound/sfx/chainsaw_off")
	end
	inst.components.inventoryitem.atlasname = "images/alchemy_chainsaw2.xml"
	inst.components.inventoryitem.imagename = "alchemy_chainsaw2"

	if inst.components.tool then
		inst:RemoveComponent("tool")
	end

	if inst.fx ~= nil then
		if inst.components.finiteuses:GetUses() <= 0 then
			inst.fx.AnimState:PlayAnimation("off")
		else
			if inst:HasTag("Start_Chainsaw") then
				inst.fx.AnimState:PlayAnimation("loop",true)
			else
				inst.fx.AnimState:PlayAnimation("idle")
			end
		end
	end

	if inst.Start_Chainsaw ~= nil then
		inst.Start_Chainsaw:Cancel()
		inst.Start_Chainsaw = nil
	end
end

local function Chainsaw_state(inst, owner)
	if inst.components.equippable.isequipped ~= false then
		if inst.fx == nil then
			inst.fx = SpawnPrefab("alchemy_chainsaw_fx")
			inst.fx.entity:AddFollower()
			inst.fx.Follower:FollowSymbol(owner.GUID, "swap_object", nil, nil, nil, true, nil, 0, 3)
		else
			if inst.components.finiteuses:GetUses() <= 0 then
				inst.fx.AnimState:PlayAnimation("off")
			else
				if inst:HasTag("Start_Chainsaw") then
					inst.fx.AnimState:PlayAnimation("loop",true)
				else
					inst.fx.AnimState:PlayAnimation("idle")
				end
			end
		end
	end
end

----装备
local function onequip(inst, owner) 
    owner.AnimState:Show("ARM_carry") 
    owner.AnimState:Hide("ARM_normal")
	if inst.components.finiteuses:GetUses() > 0 then
		inst:AddTag("chainsaw_ready")
	else
		inst:RemoveTag("chainsaw_ready")
	end
	inst.SoundEmitter:PlaySound("chainsaw_sound/sfx/chainsaw_hit")
	owner.AnimState:OverrideSymbol("swap_object", "swap_punk_alchemy_saw_sword", "swap_punk_alchemy_saw_sword")

	Chainsaw_Stop(inst)
	Chainsaw_state(inst, owner)

	----耐久
	if inst.components.finiteuses:GetUses() <= 0 then
		inst:RemoveTag("Start_Chainsaw")
		inst.components.weapon:SetDamage(34)
		inst:RemoveTag("chainsaw_ready")
		inst.components.finiteuses:SetUses(0)
	else
		inst.components.weapon:SetDamage(51)		
	end

	----起手判定攻击力
	inst.onattackother = function(target, data)
		if inst and inst.components.finiteuses then
			if inst.components.finiteuses:GetUses() <= 0 then
				inst.components.weapon:SetDamage(34)
				inst:RemoveTag("chainsaw_ready")
			else
				if inst:HasTag("Start_Chainsaw") then
					inst.components.weapon:SetDamage(68)
				else
					inst.components.weapon:SetDamage(51)
				end
				inst.SoundEmitter:PlaySound("chainsaw_sound/sfx/chainsaw_hit")
			end
		end
	end
	inst:ListenForEvent("onattackother", inst.onattackother, owner)
end

----脱下
local function onunequip(inst, owner) 
	owner.AnimState:ClearOverrideSymbol("swap_object")
    owner.AnimState:Hide("ARM_carry") 
    owner.AnimState:Show("ARM_normal")
	inst:RemoveTag("chainsaw_ready")
	Chainsaw_Stop(inst)
	if inst.fx ~= nil then
		inst.fx:Remove()
		inst.fx = nil
	end
	if inst and inst.components.finiteuses then
		if inst.components.finiteuses:GetUses() <= 0 then
			inst.components.weapon:SetDamage(34)
			inst.components.finiteuses:SetUses(0)
		else
			inst.components.weapon:SetDamage(51)
		end
	end

	inst:RemoveEventCallback("onattackother", inst.onattackother, owner)
end

----攻击
local function onattack(inst, attacker, target, periodic)
	local owner = inst.components.inventoryitem and inst.components.inventoryitem.owner
	
	----命中时判定耐久
	if inst and inst.components.finiteuses then
		if inst.components.finiteuses:GetUses() <= 1 then
			inst.components.weapon:SetDamage(34)
			inst:RemoveTag("chainsaw_ready")
			if inst:HasTag("Start_Chainsaw")then
				Chainsaw_Stop(inst)
				inst:RemoveTag("Start_Chainsaw")
			end
		end
		if inst.components.finiteuses:GetUses() <= 0 then
			inst.components.finiteuses:SetUses(1)
		end
	end

	----命中时判定流血
	if inst:HasTag("Start_Chainsaw")then
		if target and not target.components.debuffable then
			target:AddComponent("debuffable")
		end
		
		if target and not target:HasTag("player") then
			target.components.debuffable:AddDebuff("chainsaw_buff","chainsaw_buff",{ doer = owner })
		end

		if target.chainsaw_bleed ~= nil and target.chainsaw_bleed < 10 then
			target.chainsaw_bleed = target.chainsaw_bleed + 1
		elseif target.chainsaw_bleed == nil then
			target.chainsaw_bleed = 1
		end

	end
end

----启动or停止
local function Chainsaw_Switch(inst, owner)
	if inst and inst.components.finiteuses and inst.components.finiteuses:GetUses() >= 2 then
		if inst:HasTag("Start_Chainsaw") then
			Chainsaw_Stop(inst)
			inst:RemoveTag("Start_Chainsaw")
			Chainsaw_state(inst, owner)
			inst.components.weapon:SetDamage(51)

		else
			inst:AddTag("Start_Chainsaw")
			Chainsaw_state(inst, owner)
			inst.components.weapon:SetDamage(68)

			if not inst.components.tool then
				inst:AddComponent("tool")
			end
			if inst.components.tool then
				inst.components.tool:SetAction(ACTIONS.CHOP, 1)
			end

			inst.components.inventoryitem.atlasname = "images/alchemy_chainsaw.xml"
			inst.components.inventoryitem.imagename = "alchemy_chainsaw"
			inst.SoundEmitter:PlaySound("chainsaw_sound/sfx/chainsaw_on")
			if inst.fx ~= nil then
				inst.fx.AnimState:PlayAnimation("loop",true)
			end
			inst:DoTaskInTime(1,function()
				inst.SoundEmitter:PlaySound("chainsaw_sound/sfx/chainsaw_true")
			end)
			if inst.Start_Chainsaw == nil then	
				inst.Start_Chainsaw = inst:DoPeriodicTask(2, function()
					inst.components.finiteuses:Use(1)
					inst.SoundEmitter:PlaySound("chainsaw_sound/sfx/chainsaw_true")

					----耐久小于零恢复
					if inst.components.finiteuses:GetUses() <= 0 then
						Chainsaw_Stop(inst)
						inst:RemoveTag("Start_Chainsaw")
						inst.components.weapon:SetDamage(34)
						inst:RemoveTag("chainsaw_ready")
						inst.components.finiteuses:SetUses(0)
					end
				end)
			end

		end

	end

	return true
end

----修复
local function Chainsaw_Eepair(inst, item, doer)
	local currentperc
	local itemnum = item and item.components.stackable and item.components.stackable.stacksize
	if inst and inst.components.finiteuses then
		if inst.components.finiteuses:GetPercent() >= 1 then 
			doer.sg:GoToState("refuseeat")
		else
			currentperc = inst.components.finiteuses:GetPercent()
			if item.prefab == "wagpunkbits_kit" then
				currentperc = currentperc + 1
			elseif item.prefab == "gears" then
				currentperc = currentperc + .2
			end
			if currentperc >= 1 then
				currentperc = 1
			end
			inst.components.finiteuses:SetPercent(currentperc)

			if itemnum > 1 then
				item.components.stackable:Get(1)
			else
				item:Remove()
			end
			doer.sg:GoToState("chop")
			inst.SoundEmitter:PlaySound("chainsaw_sound/sfx/chainsaw_hit")
			local fx = SpawnPrefab("crab_king_shine")
			fx.entity:SetParent(doer.entity)
			fx.Transform:SetPosition(0, 1.6, 0)
			if inst.components.finiteuses:GetPercent() > 0 then
				if inst.components.equippable and inst.components.equippable.isequipped ~= false then
					inst:AddTag("chainsaw_ready")
				end
				if inst:HasTag("Start_Chainsaw") then
					inst.components.weapon:SetDamage(68)
				else
					inst.components.weapon:SetDamage(51)
				end
				Chainsaw_state(inst, doer)
			end
		end
	end
	return true
end

----怜悯跳劈
---comment
---@param inst any
---@param owner ent
---@param target ent
local function Chainsaw_Pity(inst, owner, target)
	if inst.components.rechargeable:GetTimeToCharge() <= 0 and target ~= nil then
		-- if owner and owner:IsValid() and owner.components.health and not owner.components.health:IsDead() then
		if owner and owner:IsValid() and owner.components.health and not owner.components.health:IsDead() and owner.components.combat and not owner.components.combat:IsAlly(target) then

			if owner.components.health.currenthealth > 10 then
				owner.components.health:DoDelta(-10)
				if owner.sg and owner.sg:HasState("hit") and not owner.sg:HasStateTag("noouthit") and not owner.sg:HasStateTag("flight") and owner.components.health and not owner.components.health:IsDead() and not owner:HasTag("playerghost") then
					if owner.components.rider ~= nil and not owner.components.rider:IsRiding() then
						owner.sg:GoToState("Chainsaw_Pity_posture")
						inst:DoTaskInTime(11 * FRAMES, function()
							if target and target:IsValid() and target.components.health and not target.components.health:IsDead() and target.components.combat then
								local e_externaldamagemultipliers = owner and owner.components.combat.externaldamagemultipliers:Get() or 1
								local e_damagemultiplier = owner and owner.components.combat.damagemultiplier or 1
								target.components.combat:GetAttacked(owner, 136 *e_externaldamagemultipliers *e_damagemultiplier)
								----斩杀效果
								if target and target:IsValid() and target.components.health and not target.components.health:IsDead() then
									if (target.components.health:GetPercent() <= .08 and target:HasTag("epic"))
									or (target.components.health:GetPercent() <= .25 and not target:HasTag("epic"))
									then
										if not target.components.colourtweener then
											target:AddComponent("colourtweener")
										end
										target.components.colourtweener:StartTween({.9, .2, .1, 1}, 0)
										target.components.health.currenthealth = 0.1
										if target and target:IsValid() and target.components.combat and target.components.combat ~= nil and target.components.health and not target.components.health:IsDead() then
											target.components.health:DoDelta(-1, true,"debug_key",true,nil,true)
											if target.components.health:IsDead() then
												if owner and owner:IsValid() and owner.components.health and not owner.components.health:IsDead() then
													-- LOLWP_S:declare('killed')
													-- owner.components.health:SetInvincible(false)
													owner.components.health:DoDelta(15)
													if owner.components.sanity ~= nil then
														owner.components.sanity:DoDelta(15, true,"debug_key")
													end
													-- owner.components.health:SetInvincible(true)
												end
												owner:PushEvent("killed", { victim = target, attacker = owner })
											end
										end
									end
									target:PushEvent("chainsaw_pity")
								end
							end
						end)
						inst.components.rechargeable:Discharge(20)
						inst.SoundEmitter:PlaySound("chainsaw_sound/sfx/chainsaw_pity")
					end
				end
			else
				owner.components.talker:Say("生命过低无法施放技能")
				return
			end
		end
	end
	--
end

--[[--锯断
local function Chainsaw_Chop(inst, owner, target)
	inst:StartThread(function()
		for i = 0, 9 do
			if target and target.components.workable and target:HasTag("CHOP_workable") then
				target.components.workable:WorkedBy_Internal(owner, .8)
			end
			Sleep(.02)
		end
	end)
	inst.SoundEmitter:PlaySound("chainsaw_sound/sfx/chainsaw_hit")
end]]

----上线判定
local function Chainsaw_finiteuses(inst)
	local owner = inst.components.inventoryitem and inst.components.inventoryitem.owner
	if owner ~= nil then
		Chainsaw_state(inst, owner)
	end
	if inst and inst.components.finiteuses then
		if inst.components.finiteuses:GetUses() <= 0 then
			Chainsaw_Stop(inst)
			inst:RemoveTag("Start_Chainsaw")
			inst.components.weapon:SetDamage(34)
			inst:RemoveTag("chainsaw_ready")
		end
	end
end

--[]--[]--[]--[]--[]--[]--[]--[]--[]--[]--[]--[]--[]--[]--[]--[]--[]--[]--[]--[]--
local function fn()
	local inst = CreateEntity()
	local trans = inst.entity:AddTransform()
	local anim = inst.entity:AddAnimState()
	
    MakeInventoryPhysics(inst)
	inst.entity:AddSoundEmitter()
	inst.entity:AddTransform()
	inst.entity:AddLight()
	inst.entity:AddNetwork() 
	inst.entity:AddMiniMapEntity()
	inst.AnimState:SetBank("punk_alchemy_saw_sword")
	inst.AnimState:SetBuild("punk_alchemy_saw_sword")
	inst.AnimState:PlayAnimation("idle")

	anim:SetBloomEffectHandle( "shaders/anim.ksh" )	

    inst:AddTag("sharp")
    inst:AddTag("pointy")
	inst:AddTag("weapon")

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
        return inst
    end	

	inst:AddComponent("inspectable")
	
	inst:AddComponent("inventoryitem")	
	inst.components.inventoryitem.atlasname = "images/alchemy_chainsaw.xml"
	inst.components.inventoryitem.imagename = "alchemy_chainsaw"

	inst:AddComponent("equippable")
	inst.components.equippable:SetOnEquip(onequip)
	inst.components.equippable:SetOnUnequip(onunequip)
	inst.components.equippable.walkspeedmult = 1.1

	inst:AddComponent("weapon")    
	inst.components.weapon:SetDamage(51)
    inst.components.weapon:SetOnAttack(onattack)

	inst:AddComponent("finiteuses")
	inst.components.finiteuses:SetMaxUses(800)
	inst.components.finiteuses:SetUses(800)
	
	inst:AddTag("rechargeable")
	inst:AddComponent("rechargeable")

	----启动or停止
	inst.Chainsaw_Switch = Chainsaw_Switch
	----修复
	inst.Chainsaw_Eepair = Chainsaw_Eepair
	----怜悯
	inst.Chainsaw_Pity = Chainsaw_Pity
	----砍伐
	--inst.Chainsaw_Chop = Chainsaw_Chop
	
	----上线判定
	inst:ListenForEvent("ms_playerjoined",function()
		inst:DoTaskInTime(.2,function()
			Chainsaw_finiteuses(inst)
		end)
	end, TheWorld)

    return inst
end

----------------------------------------------------------------------流血buff
local function buff_OnTimerDone(inst,data)
	if data.name == "buffduration" then 
		inst.components.debuff:Stop()
	end
end

local function De_chainsaw_buff(inst,target)
	if inst.ShockTask then
		inst.ShockTask:Cancel()
		inst.ShockTask = nil
	end
	if target ~= nil then
		target.chainsaw_bleed = nil
	end				
	inst:Remove()
end

local function On_chainsaw_buff(inst, target, followsymbol, followoffset, data)
	if target and target:HasTag("player") then
		return
	end
	---@type ent
	local doer = data and data.doer

	----开始持续时间
	inst.components.timer:StartTimer("buffduration", 20)

	----持续流血buff
	inst.ShockTask = target:DoPeriodicTask(1,function()
		if target and target:HasTag("player") then
			return
		end

		local e_externaldamagemultipliers = doer and doer.components.combat.externaldamagemultipliers:Get() or 1
		local e_damagemultiplier = doer and doer.components.combat.damagemultiplier or 1

		if target and target:IsValid() and target.components.health and not target.components.health:IsDead() and target.components.combat ~= nil and target.chainsaw_bleed ~= nil then
			target.components.health:DoDelta(-4 *target.chainsaw_bleed *e_externaldamagemultipliers *e_damagemultiplier, nil,nil,true,nil,true)
		end
	end)

	----怜悯技能
	inst:ListenForEvent("chainsaw_pity",function()
		local e_externaldamagemultipliers = doer and doer.components.combat.externaldamagemultipliers:Get() or 1
		local e_damagemultiplier = doer and doer.components.combat.damagemultiplier or 1
		local chainsaw_buff_time = math.ceil(inst.components.timer:GetTimeLeft("buffduration")) or 1
		if target and target:IsValid() and target.components.health and not target.components.health:IsDead() and target.chainsaw_bleed ~= nil then
			target.components.health:DoDelta(-4 *target.chainsaw_bleed *e_externaldamagemultipliers *e_damagemultiplier *chainsaw_buff_time, nil,nil,true,nil,true)

			----斩杀效果
			if target and target:IsValid() and target.components.health and not target.components.health:IsDead() then
				if (target.components.health:GetPercent() <= .08 and target:HasTag("epic"))
				or (target.components.health:GetPercent() <= .25 and not target:HasTag("epic"))
				then
					if not target.components.colourtweener then
						target:AddComponent("colourtweener")
					end
					target.components.colourtweener:StartTween({.9, .2, .1, 1}, 0)
					target.components.health.currenthealth = 0.1
					if target and target:IsValid() and target.components.combat and target.components.combat ~= nil and target.components.health and not target.components.health:IsDead() then
						target.components.health:DoDelta(-1, true,"debug_key",true,nil,true)
						if target.components.health:IsDead() then
							if doer and doer:IsValid() and doer.components.health and not doer.components.health:IsDead() then
								doer.components.health:DoDelta(15)
								if doer.components.sanity ~= nil then
									doer.components.sanity:DoDelta(15, true,"debug_key")
								end
							end
							doer:PushEvent("killed", { victim = target, attacker = doer })
						end
					end
				end
			end

		end
		inst.components.timer:StopTimer("buffduration")
		inst.components.debuff:Stop()
	end, target)

	----死亡判定
	inst:ListenForEvent("death",function()
		inst.components.timer:StopTimer("buffduration")
		inst.components.debuff:Stop()
	end, target)
	
	inst:DoPeriodicTask(1 * FRAMES, function()
		if doer == nil or not doer:IsValid() then
			if inst and inst:IsValid() then
				inst.components.debuff:Stop()
				if inst.ShockTask then
					inst.ShockTask:Cancel()
					inst.ShockTask = nil
				end
				inst:Remove()
			end
		end
	end)
end

local function Ex_chainsaw_buff(inst, target, followsymbol, followoffset, data)
	inst.components.timer:StopTimer("buffduration")
	inst.components.timer:StartTimer("buffduration", 20)
end

local function chainsaw_bufffn()
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddNetwork()
	inst.entity:AddSoundEmitter()
	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end

	inst.persists = false

	inst:AddComponent("debuff")
	inst.components.debuff:SetAttachedFn(On_chainsaw_buff)
	inst.components.debuff:SetExtendedFn(Ex_chainsaw_buff)
	inst.components.debuff:SetDetachedFn(De_chainsaw_buff)
	inst.components.debuff.keepondespawn = false

	inst:AddComponent("timer")
	inst:ListenForEvent("timerdone", buff_OnTimerDone)

    return inst
end

local function fxfn()
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	inst.AnimState:SetBank("alchemy_chainsaw_fx")
	inst.AnimState:SetBuild("alchemy_chainsaw_fx")
	inst.AnimState:PlayAnimation("idle")
	inst.AnimState:SetFinalOffset(1)
	inst.AnimState:SetSortOrder(1)

	inst:AddTag("FX")
	inst:AddTag("NOCLICK")

    inst.entity:SetPristine()

    inst.persists = false

	return inst
end

----------------------------------------------------------------------
return Prefab("alchemy_chainsaw", fn, assets),
		Prefab("chainsaw_buff",chainsaw_bufffn),
		Prefab("alchemy_chainsaw_fx", fxfn, assets)