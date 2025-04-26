-- 1 人物移动一段距离会留下一个脚印 
-- 2 留下的脚印超过4个才会消失
-- 3 但是只是脚印消失了 坐标还在 只有超过60个 才会删掉最旧的坐标
-- 4 按下秒表 人物会回溯到第四个脚印 不足四个脚印按最远的算 并且前三个脚印也会消失

local QUEUE_LEN = 60
local MAX_FOOTPRINT = 3
local FP_INTERVAL_DIST = TUNING.MOD_LOL_WP.STOPWATCH.FP_INTERVAL_DIST -- 足迹最大消逝距离

---@class components
---@field lol_wp_player_footprint_traceback component_lol_wp_player_footprint_traceback

-- local function on_val(self, value)
    -- self.inst.replica.lol_wp_player_footprint_traceback:SetVal(value)
-- end

---@class component_lol_wp_player_footprint_traceback
---@field inst ent
---@field _history table<number,nil|{pos:Vector3,shape:integer,fx:ent|nil}>
---@field _front integer # 队首始终为空
---@field _rear integer
---@field _size integer
---@field _max_fp integer
---@field _task Periodic|nil # 检测人物移动的周期任务
local lol_wp_player_footprint_traceback = Class(

---@param self component_lol_wp_player_footprint_traceback
---@param inst ent
function(self, inst)
    self.inst = inst
    -- self.val = 0

    self._history = {}
    self._front = 1
    self._rear = 1
    self._size = QUEUE_LEN
    self._max_fp = MAX_FOOTPRINT
end,
nil,
{
    -- val = on_val,
})

-- function lol_wp_player_footprint_traceback:OnSave()
--     return {
--         -- val = self.val
--     }
-- end

-- function lol_wp_player_footprint_traceback:OnLoad(data)
--     -- self.val = data.val or 0
-- end

local function FadeFP(fx,shape) -- 消逝动画
    if fx and fx:IsValid() then
        fx.AnimState:PlayAnimation('mark'..shape..'_pst')
        fx:DoTaskInTime(0.3,function()
            if fx and fx:IsValid() then
                fx:Remove()
                fx = nil
            end
        end)
    end
end

---从队尾push
---@param x number
---@param z number
function lol_wp_player_footprint_traceback:_push(x,z)
    if self:_is_full() then
        self:_pop()
        self:_push(x,z)
    else
        self._rear = (self._rear % self._size) + 1
        local shape = math.random(1,4) -- 动画包有四种足迹样式
        local element = {pos={x,z},shape=shape}
        element.fx = SpawnPrefab('lol_wp_s15_stopwatch_footprint')
        element.fx.Transform:SetPosition(x,0,z)
        element.fx.Transform:SetScale(1.1,1.1,1.1)
        element.fx.AnimState:PlayAnimation('mark'..shape..'_pre',true)
        element.fx.AnimState:PushAnimation('mark'..shape..'_loop',true)
        self._history[self._rear] = element
    end
    -- print('_push : self._front - '..self._front..' self._rear - '..self._rear)
    self:_fade_fp_when_push()
end

function lol_wp_player_footprint_traceback:_fade_fp_when_push()
    local cur_rear = self._rear
    for i = 1,(MAX_FOOTPRINT+1) do
        local _temp = (cur_rear - 1)%self._size
        cur_rear = _temp ~= 0 and _temp or self._size
    end
    local cur_element = self._history[cur_rear]
    if cur_element and cur_element.fx and cur_element.fx:IsValid() then
        cur_element.fx:Remove()
        cur_element.fx = nil
    end
end

---从队首pop
---@return { pos: Vector3, shape: integer, fx: ent|nil }|nil
function lol_wp_player_footprint_traceback:_pop()
    if not self:_is_empty() then
        -- pop前
        -- 删掉脚印动画
        local element = self._history[self._front]
        -- if element.fx and element.fx:IsValid() then
        --     element.fx:Remove()
        --     element.fx = nil
        -- end
        FadeFP(element and element.fx,element and element.shape)
        -- 释放
        self._history[self._front] = nil
        -- pop后
        self._front = (self._front % self._size) + 1
        return self._history[self._front]
    end
    return nil
end

---检查旧足迹是否达到最大消逝距离
---@param x number
---@param z number
---@return boolean
---@nodiscard
function lol_wp_player_footprint_traceback:Check(x,z)
    local max_range = FP_INTERVAL_DIST -- 足迹最大消逝距离
    local cur_fp_x,cur_fp_z = unpack(self._history[self._rear] and self._history[self._rear].pos or {})
    if cur_fp_x and cur_fp_z and LOLWP_C:calcDist(x,z,cur_fp_x,cur_fp_z) > max_range^2 then
        return true
    end
    return false
end

---comment
---@return boolean
---@nodiscard
function lol_wp_player_footprint_traceback:_is_empty()
    return self._front == self._rear
end

---comment
---@return boolean
---@nodiscard
function lol_wp_player_footprint_traceback:_is_full()
    return (self._rear % self._size) + 1 == self._front
end

---启动足迹生成周期任务
function lol_wp_player_footprint_traceback:StartGenFootPrint()
    self:StopGenFootPrint()
    local last_pos
    self._task = self.inst:DoPeriodicTask(0.1,function()
        local cur_pos = self.inst:GetPosition()
        if last_pos == nil or last_pos ~= cur_pos then
            local x,_,z = cur_pos:Get()
            if self:_is_empty() then
                self:_push(x,z)
            end
            if self:Check(x,z) then
                self:_push(x,z)
            end
            last_pos = cur_pos
        end
    end)
end

---停止生成足迹
function lol_wp_player_footprint_traceback:StopGenFootPrint()
    -- 停止周期任务
    if self._task ~= nil then
        self._task:Cancel()
        self._task = nil
    end
    -- 清空队列
    for k,v in pairs(self._history) do
        FadeFP(v.fx,v.shape)
        self._history[k] = nil
    end
    while not self:_is_empty() do
        self:_pop()
    end
end

---从队尾找MAX_FOOTPRINT次历史记录,尽可能远的找,中间的记录删除
---@return integer|nil # 若找到一个元素,则允许进行回溯
---@nodiscard
function lol_wp_player_footprint_traceback:SearchHistoryForTraceBack()
    ---@type nil|integer # 若找到一个元素,则允许进行回溯
    local res_rear

    -- 从队尾开始找 MAX_FOOTPRINT 次,尽可能远的找脚印
    if not self:_is_empty() then
        for search_times = 1,MAX_FOOTPRINT do
            local _temp = (self._rear - 1)%self._size
            local before_rear = _temp ~= 0 and _temp or self._size -- 队尾的上一个指针
            -- 如果  队尾的上一个指针 与 队首 重合，则说明当前队尾就是最后一个元素 ,此时应该停止搜索
            if before_rear == self._front then
                break
            else
                -- 队尾的上一个指针 与 队首 不重合，则说明队尾还不止一个元素
                -- 删除当前队尾元素
                local cur_element = self._history[self._rear]
                -- if cur_element and cur_element.fx and cur_element.fx:IsValid() then
                --     cur_element.fx:Remove()
                --     cur_element.fx = nil
                -- end
                FadeFP(cur_element and cur_element.fx,cur_element and cur_element.shape)
                self._history[self._rear] = nil
                -- 更新队尾指针
                self._rear = before_rear
            end
        end
        res_rear = self._rear
    end
    return res_rear
end

---回溯
---@return boolean
---@nodiscard
function lol_wp_player_footprint_traceback:TraceBack()
    -- 如果找到了历史记录
    local res_rear = self:SearchHistoryForTraceBack()
    if res_rear then
        -- print('TraceBack - '..res_rear)
        -- 不是很放心, 再判一次
        local should_pos_x,should_pos_z = unpack(self._history[res_rear] and self._history[res_rear].pos or {})
        if should_pos_x and should_pos_z then
            self.inst.Physics:Teleport(should_pos_x,0,should_pos_z)

            -- 移除脚印动画
            FadeFP(self._history[res_rear] and self._history[res_rear].fx,self._history[res_rear] and self._history[res_rear].shape)
            -- 删除当前队尾元素
            self._history[res_rear] = nil
            -- 更新队尾指针
            local _temp2 = (res_rear-1)%self._size
            self._rear = _temp2 ~= 0 and _temp2 or self._size

            -- 从队尾找MAX_FOOTPRINT次历史记录,尽可能远的找, 找到后恢复该脚印动画 (隐藏都隐藏 别显示了 单主逻辑也没给我理清楚 )
            -- local recovery_history
            -- local cur_rear = self._rear
            -- if not self:_is_empty() then
            --     for _ = 1,MAX_FOOTPRINT do
            --         local _temp = (cur_rear - 1)%self._size
            --         local before_rear = _temp ~= 0 and _temp or self._size
            --         if before_rear == self._front then
            --             break
            --         else
            --             cur_rear = before_rear
            --         end
            --     end
            --     recovery_history = cur_rear
            -- end
            -- print('recovery_history - ', recovery_history)
            -- if recovery_history then
            --     local recovery_history_element = self._history[recovery_history]
            --     if recovery_history_element then
            --         if recovery_history_element.fx and recovery_history_element.fx:IsValid() then
            --             recovery_history_element.fx:Remove()
            --             recovery_history_element.fx = nil
            --         end
            --         local recovery_history_element_shape = recovery_history_element.shape
            --         local recovery_history_element_x,recovery_history_element_z = unpack(recovery_history_element.pos)
            --         recovery_history_element.fx = SpawnPrefab('lol_wp_s15_stopwatch_footprint')
            --         recovery_history_element.fx.Transform:SetPosition(recovery_history_element_x,0,recovery_history_element_z)
            --         recovery_history_element.fx.Transform:SetScale(1.1,1.1,1.1)
            --         recovery_history_element.fx.AnimState:PlayAnimation('mark'..recovery_history_element_shape..'_pre',true)
            --         recovery_history_element.fx.AnimState:PushAnimation('mark'..recovery_history_element_shape..'_loop',true)
            --     end
            -- end
            return true
        end
    end
    return false
end

return lol_wp_player_footprint_traceback