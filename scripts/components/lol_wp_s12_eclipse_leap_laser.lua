local db = TUNING.MOD_LOL_WP.ECLIPSE

local modid = 'lol_wp'

local LAUNCH_SPEED = .2
local RADIUS = .7

local function SetLightRadius(inst, radius)
    inst.Light:SetRadius(radius)
end

local function DisableLight(inst)
    inst.Light:Enable(false)
end

local DAMAGE_CANT_TAGS = { "brightmareboss", "brightmare", "playerghost", "INLIMBO", "DECOR", "FX" }
-- local DAMAGE_CANT_TAGS = { "DECOR", "FX" }
local DAMAGE_ONEOF_TAGS = { "_combat", "pickable", "NPC_workable", "CHOP_workable", "HAMMER_workable", "MINE_workable", "DIG_workable" }
local LAUNCH_MUST_TAGS = { "_inventoryitem" }
local LAUNCH_CANT_TAGS = { "locomotor", "INLIMBO" }

local function DoDamage(inst, targets, skiptoss, skipscorch, scale, scorchscale, hitscale, heavymult, mult, forcelanded)
    inst.task = nil

    local x, y, z = inst.Transform:GetWorldPosition()

    -- First, get our presentation out of the way, since it doesn't change based on the find results.
    if inst.AnimState ~= nil then
		if scale then
			inst.AnimState:SetScale(scale, math.abs(scale))
		end
        inst.AnimState:PlayAnimation("hit_"..tostring(math.random(5)))
        inst:Show()
        inst:DoTaskInTime(inst.AnimState:GetCurrentAnimationLength() + 2 * FRAMES, inst.Remove)

        inst.Light:Enable(true)
        inst:DoTaskInTime(4 * FRAMES, SetLightRadius, .5)
        inst:DoTaskInTime(5 * FRAMES, DisableLight)

        if not skipscorch and TheWorld.Map:IsPassableAtPoint(x, 0, z, false) then
			local scorch = SpawnPrefab("alterguardian_laserscorch")
			scorch.Transform:SetPosition(x, 0, z)
			if scorchscale then
				scorch.AnimState:SetScale(scorchscale, math.abs(scorchscale))
			end
        end

        local fx = SpawnPrefab("alterguardian_lasertrail")
        fx.Transform:SetPosition(x, 0, z)
        ---@diagnostic disable-next-line: undefined-field
        fx:FastForward(GetRandomMinMax(.3, .7))
    else
        inst:DoTaskInTime(2 * FRAMES, inst.Remove)
    end

	--for knockback
	local disttocaster = mult and inst.caster and inst.caster:IsValid() and math.sqrt(inst.caster:GetDistanceSqToPoint(x, y, z)) or nil

	local restoredmg, restorepdp
	if inst.caster and inst.caster:IsValid() then
		if inst.overridedmg then
			restoredmg = inst.caster.components.combat.defaultdamage
			inst.caster.components.combat:SetDefaultDamage(inst.overridedmg)
		end
		if inst.overridepdp then
			restorepdp = inst.caster.components.combat.playerdamagepercent
			inst.caster.components.combat.playerdamagepercent = inst.overridepdp
		end
		inst.caster.components.combat.ignorehitrange = true
	end

	--override the fx's combat damage as well in case it gets used, but no need to restore
	if inst.overridedmg then
		inst.components.combat:SetDefaultDamage(inst.overridedmg)
	end
	if inst.overridepdp then
		inst.components.combat.playerdamagepercent = inst.overridepdp
	end
    inst.components.combat.ignorehitrange = true

	local hitradius = RADIUS * (hitscale or 1)
    for _, v in ipairs(TheSim:FindEntities(x, 0, z, hitradius + 3, nil, DAMAGE_CANT_TAGS, DAMAGE_ONEOF_TAGS)) do
        if not targets[v] and v:IsValid() and
                not (v.components.health ~= nil and v.components.health:IsDead()) then
			local range = hitradius + v:GetPhysicsRadius(.5)
            local dsq_to_laser = v:GetDistanceSqToPoint(x, y, z)
            if dsq_to_laser < range * range then
                v:PushEvent("onalterguardianlasered")

                local isworkable = false
                if v.components.workable ~= nil then
                    local work_action = v.components.workable:GetWorkAction()
                    --V2C: nil action for NPC_workable (e.g. campfires)
                    isworkable =
                        (   work_action == nil and v:HasTag("NPC_workable") ) or
                        (   v.components.workable:CanBeWorked() and
                            (   work_action == ACTIONS.CHOP or
                                work_action == ACTIONS.HAMMER or
                                work_action == ACTIONS.MINE or
                                (   work_action == ACTIONS.DIG and
                                    v.components.spawner == nil and
                                    v.components.childspawner == nil
                                )
                            )
                        )
                end
                if isworkable then
                    targets[v] = true
                    -- 不要植物 要树
                    local should_destroy = true
                    if TUNING[string.upper('CONFIG_'..modid..'eclipse_laser_destory_everything')] == 1 then
                        local tar_prefab = v.prefab
                        if v.components.pickable or v:HasTag('statue')
                        or v:HasTag('farm_plant')
                        or v:HasTag('structure')
                        or (v:HasTag('heavy') and v.components.heavyobstaclephysics and not v.components.farmplantable) -- 排除雕塑
                        then
                        should_destroy = false
                        end
                        if should_destroy then
                            if tar_prefab then
                                if tar_prefab == 'oceantree_pillar' or tar_prefab == 'oceantree' then
                                    should_destroy = false
                                end
                            end
                        end
                    end
                    if should_destroy and v.components.hull then
                        should_destroy = false
                    end
                    if should_destroy then
                        v.components.workable:Destroy(inst.caster and inst.caster:IsValid() and inst.caster or inst)
                    end

                    -- Completely uproot trees.
                    if v:HasTag("stump") then
                        v:Remove()
                    end
                elseif v.components.pickable ~= nil
                        and v.components.pickable:CanBePicked()
                        and not v:HasTag("intense") then
                    targets[v] = true
					local success, loots = v.components.pickable:Pick(inst)
					if loots then
						for i, v in ipairs(loots) do
							skiptoss[v] = true
							targets[v] = true
							Launch(v, inst, LAUNCH_SPEED)
                        end
                    end
                elseif v.components.combat == nil and v.components.health ~= nil then
                    targets[v] = true
                -- elseif inst.components.combat:CanTarget(v) then
                elseif v.components.combat and LOLWP_S:checkAlive(v) then
                    targets[v] = true

					--for knockback
					local strengthmult = mult and ((v.components.inventory and v.components.inventory:ArmorHasTag("heavyarmor") or v:HasTag("heavybody")) and heavymult or mult) or nil

                    if inst.caster ~= nil and inst.caster:IsValid() then
                        inst.caster.components.combat:DoAttack(v)
						if strengthmult then
							v:PushEvent("knockback", { knocker = inst.caster, radius = disttocaster + hitradius, strengthmult = strengthmult, forcelanded = forcelanded })
						end
                    else
                        inst.components.combat:DoAttack(v)
						if strengthmult then
							v:PushEvent("knockback", { knocker = inst, radius = hitradius, strengthmult = strengthmult, forcelanded = forcelanded })
						end
                    end

                    ---@diagnostic disable-next-line: undefined-field
                    SpawnPrefab("alterguardian_laserhit"):SetTarget(v)

                    if not v.components.health:IsDead() then
                        if v.components.freezable ~= nil then
                            if v.components.freezable:IsFrozen() then
                                v.components.freezable:Unfreeze()
                            elseif v.components.freezable.coldness > 0 then
                                v.components.freezable:AddColdness(-2)
                            end
                        end
                        if v.components.temperature ~= nil then
                            local maxtemp = math.min(v.components.temperature:GetMax(), 10)
                            local curtemp = v.components.temperature:GetCurrent()
                            if maxtemp > curtemp then
                                v.components.temperature:DoDelta(math.min(10, maxtemp - curtemp))
                            end
                        end
                        if v.components.sanity ~= nil then
                            v.components.sanity:DoDelta(TUNING.GESTALT_ATTACK_DAMAGE_SANITY)
                        end
                    end
                end
            end
        end
    end
    inst.components.combat.ignorehitrange = false
	if inst.caster and inst.caster:IsValid() then
		inst.caster.components.combat.ignorehitrange = false
		if restorepdp then
			inst.caster.components.combat.playerdamagepercent = restorepdp
		end
		if restoredmg then
			inst.caster.components.combat:SetDefaultDamage(restoredmg)
		end
	end

    -- After lasering stuff, try tossing any leftovers around.
	for _, v in ipairs(TheSim:FindEntities(x, 0, z, hitradius + 3, LAUNCH_MUST_TAGS, LAUNCH_CANT_TAGS)) do
        if not skiptoss[v] then
			local range = hitradius + v:GetPhysicsRadius(.5)
            if v:GetDistanceSqToPoint(x, y, z) < range * range then
                if v.components.mine ~= nil then
                    targets[v] = true
                    skiptoss[v] = true
                    v.components.mine:Deactivate()
                end
                if not v.components.inventoryitem.nobounce and v.Physics ~= nil and v.Physics:IsActive() then
                    targets[v] = true
                    skiptoss[v] = true
                    Launch(v, inst, LAUNCH_SPEED)
                end
            end
        end
    end

    -- If the laser hit a boat, do boat stuff!
    -- local platform_hit = TheWorld.Map:GetPlatformAtPoint(x, 0, z)
    -- if platform_hit then
    --     local dsq_to_boat = platform_hit:GetDistanceSqToPoint(x, 0, z)
    --     if dsq_to_boat < TUNING.GOOD_LEAKSPAWN_PLATFORM_RADIUS then
    --         platform_hit:PushEvent("spawnnewboatleak", {pt = Vector3(x, 0, z), leak_size = "small_leak", playsoundfx = true})
    --     end
    --     platform_hit.components.health:DoDelta(-1 * TUNING.ALTERGUARDIAN_PHASE3_LASERDAMAGE / 10)
    -- end
end

local function Trigger(inst, delay, targets, skiptoss, skipscorch, scale, scorchscale, hitscale, heavymult, mult, forcelanded)
    if inst.task ~= nil then
        inst.task:Cancel()
        if (delay or 0) > 0 then
			inst.task = inst:DoTaskInTime(delay, DoDamage, targets or {}, skiptoss or {}, skipscorch, scale, scorchscale, hitscale, heavymult, mult, forcelanded)
        else
			DoDamage(inst, targets or {}, skiptoss or {}, skipscorch, scale, scorchscale, hitscale, heavymult, mult, forcelanded)
        end
    end
end

-- AI: 定义了一些常量，用于计算三角形波束的角度和偏移量
local TRIBEAM_ANGLEOFF = PI/5
local TRIBEAM_COS = math.cos(TRIBEAM_ANGLEOFF)
local TRIBEAM_SIN = math.sin(TRIBEAM_ANGLEOFF)
local TRIBEAM_COSNEG = math.cos(-TRIBEAM_ANGLEOFF)
local TRIBEAM_SINNEG = math.sin(-TRIBEAM_ANGLEOFF)

-- AI: 定义了步数和步长
local NUM_STEPS = 10
local STEP = 1.0
local OFFSET = 2 - STEP

-- AI: 定义了一个函数，用于生成激光波束
---comment
---@param inst ent
---@param target_pos any
---@param wp_skin string|nil
local function SpawnBeam(inst, target_pos,wp_skin)
    -- AI: 如果目标位置为空，则返回
    if target_pos == nil then
        return
    end

    -- AI: 获取实例的世界位置
    local ix, iy, iz = inst.Transform:GetWorldPosition()

    -- AI: 计算目标步数
    local target_step_num = RoundBiasedUp(NUM_STEPS * 2/5)

    -- AI: 初始化角度变量
    local angle = nil

    -- AI: 初始化第一个激光效果点的位置变量
    local gx, gy, gz = nil, 0, nil
    local x_step = STEP
    -- AI: 如果目标位置距离实例太近，则使用最小距离
    if inst:GetDistanceSqToPoint(target_pos:Get()) < 4 then
        angle = math.atan2(iz - target_pos.z, ix - target_pos.x)

        gx, gy, gz = inst.Transform:GetWorldPosition()
        gx = gx + (2 * math.cos(angle))
        gz = gz + (2 * math.sin(angle))
    else
        angle = math.atan2(iz - target_pos.z, ix - target_pos.x)

        gx, gy, gz = target_pos:Get()
        gx = gx + (target_step_num * STEP * math.cos(angle))
        gz = gz + (target_step_num * STEP * math.sin(angle))
    end

    -- AI: 初始化目标和跳过投掷的列表
    local targets, skiptoss = {}, {}
    local x, z = nil, nil
    local trigger_time = nil

    ----------------
    -- 筛选不需要的目标
    local dont_ruin_these = TheSim:FindEntities(ix,  0, iz, 8)
    for _,v in ipairs(dont_ruin_these) do
        if TUNING[string.upper('CONFIG_'..modid..'eclipse_laser_destory_everything')] == 1 then
            if v:HasTag('structure') or v:HasTag('companion') or v:HasTag('wall') then
                targets[v] = true
            end
        end
        if v:HasTag('player') then
            targets[v] = true
        end
        if v.components.hull then
            targets[v] = true
        end
        if inst.components.combat and inst.components.combat:IsAlly(v) then
            targets[v] = true
        end
    end


    -- AI: 循环生成激光效果
    local i = 2
    while i < NUM_STEPS do
        i = i + 1
        x = gx - i * x_step * math.cos(angle)
        z = gz - i * STEP * math.sin(angle)

        local first = (i == 0)
        local prefab = (i > 0 and "alterguardian_laser") or "alterguardian_laserempty"
        local x1, z1 = x, z

        trigger_time = math.max(0, i - 1) * FRAMES

        -- AI: 在指定时间生成激光效果
        inst:DoTaskInTime(trigger_time, function(inst2)
            local fx = SpawnPrefab(prefab)
            if wp_skin then
                if wp_skin == 'lol_wp_s12_eclipse_skin_excalibur' then
                    fx.AnimState:SetAddColour(1,231/255,25/255,1)
                end
            end

            ---@diagnostic disable-next-line: inject-field
            fx.Trigger = Trigger
            ---@diagnostic disable-next-line: inject-field
            fx.caster = inst2
            fx.Transform:SetPosition(x1, 0, z1)

            ---@class ent
            ---@field is_lol_wp_s12_eclipse_skill_newmoon_strike boolean|nil # 星蚀  flag位 用于判断是否在使用 新月打击

            -- flag位 用于判断是否在使用 新月打击
            fx.caster.is_lol_wp_s12_eclipse_skill_newmoon_strike = true
            fx:Trigger(0, targets, skiptoss)
            fx.caster.is_lol_wp_s12_eclipse_skill_newmoon_strike = false
            if first then
                -- AI: 触发摄像机震动
                ShakeAllCameras(CAMERASHAKE.FULL, .7, .02, .2, target_pos or fx, 30)
            end
        end)
    end

    -- AI: 生成最终的激光效果
   --[[  inst:DoTaskInTime(i*FRAMES, function(inst2)
        local fx = SpawnPrefab("alterguardian_laser")
        fx.Transform:SetPosition(x, 0, z)
        fx:Trigger(0, targets, skiptoss)
    end)

    inst:DoTaskInTime((i+1)*FRAMES, function(inst2)
        local fx = SpawnPrefab("alterguardian_laser")
        fx.Transform:SetPosition(x, 0, z)
        fx:Trigger(0, targets, skiptoss)
    end) ]]
end

---@param sectorAngle any
---@param rayCount any
---@param front_x any
---@param front_z any
---@param px any
---@param pz any
---@return {x:number,z:number}[]
local function calculateRayPoints(sectorAngle, rayCount, front_x, front_z, px, pz)
    -- 将角度转换为弧度
    local sectorAngleRad = math.rad(sectorAngle)
    -- 计算每个射线之间的角度间隔
    local angleStep = sectorAngleRad / (rayCount - 1)

    -- 计算人物正前方的方向向量
    local direction_x = front_x - px
    local direction_z = front_z - pz
    local direction_length = math.sqrt(direction_x * direction_x + direction_z * direction_z)
    direction_x = direction_x / direction_length
    direction_z = direction_z / direction_length

    -- 存储所有射线的终点坐标
    local rayPoints = {}

    for i = 0, rayCount - 1 do
        -- 计算当前射线的角度偏移
        local angleOffset = -sectorAngleRad / 2 + i * angleStep
        -- 计算当前射线的方向向量
        local currentRayDirection_x = direction_x * math.cos(angleOffset) - direction_z * math.sin(angleOffset)
        local currentRayDirection_z = direction_x * math.sin(angleOffset) + direction_z * math.cos(angleOffset)
        -- 计算当前射线的终点坐标
        local rayPoint_x = px + currentRayDirection_x * direction_length
        local rayPoint_z = pz + currentRayDirection_z * direction_length
        table.insert(rayPoints, {x = rayPoint_x, z = rayPoint_z})
    end

    return rayPoints
end

---@class components
---@field lol_wp_s12_eclipse_leap_laser component_lol_wp_s12_eclipse_leap_laser

-- local function on_val(self, value)
    -- self.inst.replica.lol_wp_s12_eclipse_leap_laser:SetVal(value)
-- end

---@class component_lol_wp_s12_eclipse_leap_laser
---@field inst ent
local lol_wp_s12_eclipse_leap_laser = Class(

---@param self component_lol_wp_s12_eclipse_leap_laser
---@param inst ent
function(self, inst)
    self.inst = inst
    -- self.val = 0
end,
nil,
{
    -- val = on_val,
})

-- function lol_wp_s12_eclipse_leap_laser:OnSave()
--     return {
--         -- val = self.val
--     }
-- end

-- function lol_wp_s12_eclipse_leap_laser:OnLoad(data)
--     -- self.val = data.val or 0
-- end

---comment
---@param doer ent
---@return boolean
---@nodiscard
function lol_wp_s12_eclipse_leap_laser:DoAction(doer)
    local px,_,pz = doer.Transform:GetWorldPosition()
    local front_x,front_z = LOLWP_C:calcCoordFront(doer,1,nil,px,pz)
    local all_laser_vector = calculateRayPoints(db.SKILL_NEWMOON_STRIKE.SECTOR_ANGLE,db.SKILL_NEWMOON_STRIKE.LASER_NUM,front_x,front_z,px,pz)
    local skin = self.inst:GetSkinName()
    for _,v in ipairs(all_laser_vector) do
        SpawnBeam(doer,Vector3(v.x,0,v.z),skin)
    end
    if self.inst and self.inst.components.rechargeable then
        self.inst.components.rechargeable:Discharge(db.SKILL_NEWMOON_STRIKE.CD)
    end

    if doer and doer.components.sanity then
        doer.components.sanity:DoDelta(-db.SKILL_NEWMOON_STRIKE.CONSUME_SAN)
    end

    return true
end

return lol_wp_s12_eclipse_leap_laser