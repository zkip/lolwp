---@class components
---@field lol_wp_electric_spark_chain component_lol_wp_electric_spark_chain

-- local function on_val(self, value)
    -- self.inst.replica.lol_wp_electric_spark_chain:SetVal(value)
-- end

---@class component_lol_wp_electric_spark_chain # 电刀 闪电链
---@field inst ent
---@field launch_times integer # 弹射次数
---@field search_radius number # 弹射搜索半径
---@field on_hit_fn nil|fun(mob:ent,attacker:ent|nil) # 击中回调函数
local lol_wp_electric_spark_chain = Class(
---@param self component_lol_wp_electric_spark_chain
---@param inst ent
function(self, inst)
    self.inst = inst
    -- self.val = 0

    self.launch_times = 3
    self.search_radius = 10

    self.on_hit_fn = nil
end,
nil,
{
    -- val = on_val,
})

-- function lol_wp_electric_spark_chain:OnSave()
--     return {
--         -- val = self.val
--     }
-- end

-- function lol_wp_electric_spark_chain:OnLoad(data)
--     -- self.val = data.val or 0
-- end

---init
---@param launch_times integer # 弹射次数
---@param search_radius number # 弹射搜索半径
---@param on_hit_fn nil|fun(mob:ent,attacker:ent|nil) # 击中回调函数
function lol_wp_electric_spark_chain:Init(launch_times,search_radius,on_hit_fn)
    self.launch_times = launch_times
    self.search_radius = search_radius
    self.on_hit_fn = on_hit_fn
end

---获取最近单位
---@param x number
---@param y number
---@param z number
---@param radius number
---@param round string # 弹射轮次
---@param launcher ent # 最初是谁发射的
---@return ent|nil # 最近单位
---@return number # 距离
---@nodiscard
function lol_wp_electric_spark_chain:FindClosestTarget(x,y,z,radius,round,launcher)
    local ents = TheSim:FindEntities(x, y, z, radius, nil, {'INLIMBO','player','companion','wall',"structure"})
    local radius_sq = radius ^ 2
    local closest
    for _,v in ipairs(ents or {}) do
        if v and v:IsValid() and v.components.combat and not v.components.combat:IsAlly(launcher) and LOLWP_S:checkAlive(v) and not v:HasTag('glommer') and not v:HasTag('abigail') then
            if v.lol_wp_electric_spark_chain_hitten_map == nil or not v.lol_wp_electric_spark_chain_hitten_map[round] then
                local v_x,_,v_z = v:GetPosition():Get()
                local dist = LOLWP_C:calcDist(x,z,v_x,v_z)
                if dist < radius_sq then
                    closest = v
                    radius_sq = dist
                end
            end
        end
    end
    return closest, math.sqrt(radius_sq)
end

---弹射
---@param player ent
function lol_wp_electric_spark_chain:Launch(player)
    local round = 'lol_wp_electric_spark_chain' .. tostring(GetTime()) -- 本轮次弹射

    local wp = self.inst
    local fx_len = 10 -- 特效长度
    local interval = 0.1 -- 间隔

    local p_x,_,p_z = player:GetPosition():Get()
    local remain = self.launch_times -- 剩余次数
    -- local search_from = player

    local closest

    local taskperiod
    taskperiod = wp:DoPeriodicTask(interval,function()
        -- 若有目标
        if closest and LOLWP_S:checkAlive(closest) then
            -- 标记目标
            if closest.lol_wp_electric_spark_chain_hitten_map == nil then
                closest.lol_wp_electric_spark_chain_hitten_map = {}
            end
            closest.lol_wp_electric_spark_chain_hitten_map[round] = true
            -- 触发击中回调函数
            if self.on_hit_fn then
                self.on_hit_fn(closest,player)
            end
        end

        -- 如果没有剩余次数, 停止发射
        if remain <= 0 then
            if wp then
                if taskperiod then
                    taskperiod:Cancel()
                    taskperiod = nil
                end
            end
        end

        -- 搜索目标
        local _closest,dist = self:FindClosestTarget(p_x,0,p_z,self.search_radius,round,player)
        closest = _closest

        -- 如果有目标,则发射特效
        if closest then
            local closest_x,_,closest_z = closest:GetPosition():Get()
            local fx = SpawnPrefab("spear_wathgrithr_lightning_lunge_fx")
            fx.Transform:SetNoFaced()
            fx.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)

            local fx_scale = dist/fx_len
            fx.AnimState:SetScale(fx_scale,0.3)
            fx.Transform:SetPosition(p_x,0,p_z)

            local fixed_x,fixed_z = 2*p_x - closest_x, 2*p_z - closest_z
            fx:ForceFacePoint(fixed_x,0,fixed_z)

            -- 更新剩余次数和搜索单位
            remain = remain - 1
            -- search_from = closest
            p_x,_,p_z = closest:GetPosition():Get()
        else -- 如果没有目标，则停止发射
            if wp then
                if taskperiod then
                    taskperiod:Cancel()
                    taskperiod = nil
                end
            end
        end

    end,0)
end

return lol_wp_electric_spark_chain