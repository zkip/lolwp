---@class LAN_TOOL_SUGARS
local tool = {
    EPSILON = 1e-7,
}

----------------------------------
-- GAME
----------------------------------

---获取最外层的owner
---@param invitem ent
---@return nil|ent
---@nodiscard
function tool:GetOwnerReal(invitem)
    local _player = nil
    if invitem.components and invitem.components.inventoryitem then
        local seekowner = invitem.components.inventoryitem.owner
        while seekowner ~= nil do
            if seekowner:HasTag("player") then
                _player = seekowner
                break
            elseif seekowner.components and seekowner.components.container and
            seekowner.components.inventoryitem and seekowner.components.inventoryitem.owner then
                seekowner = seekowner.components.inventoryitem.owner
            else
                break
            end
        end
    end
    return _player
end

---实体是有效并存活的
---@param ent any
---@return boolean
---@nodiscard
function tool:checkAlive(ent)
    if ent and ent:IsValid() and ent.components.health and not ent.components.health:IsDead() then
        return true
    end
    return false
end

---卸下已装备的物品
---@param equipment any 欲卸下的装备
function tool:unequipItem(equipment)
    if equipment.components.equippable ~= nil and equipment.components.equippable:IsEquipped() then
        local owner = equipment.components.inventoryitem.owner
        if owner ~= nil and owner.components.inventory ~= nil then
            local item = owner.components.inventory:Unequip(equipment.components.equippable.equipslot)
            if item ~= nil then
                owner.components.inventory:GiveItem(item, nil, owner:GetPosition())
            end
        end
    end
end

---大概率能成功添加掉落物lootdrop的方法,这个方法是勾lootsetupfn的
---@param inst ent
---@param fn function 这里写添加lootdrop掉落物的逻辑
---@deprecated
function tool:addLootDropAlwaysSuccess(inst,fn)
    if not inst.components.lootdropper then
        inst:AddComponent('lootdropper')
    end
    local old_lootsetupfn = inst.components.lootdropper.lootsetupfn
    inst.components.lootdropper:SetLootSetupFn(function (...)
        local res = old_lootsetupfn ~= nil and {old_lootsetupfn(...)} or {}
        fn(...)
        return unpack(res)
    end)
end

---成组生成物品
---@param prefa_id PrefabID
---@param num integer
---@return ent[] # 生成的物品表
---@nodiscard
function tool:spawnPrefabByStack(prefa_id,num)
    local res = {}
    local prefab = SpawnPrefab(prefa_id)
    local maxsize = prefab.components.stackable and prefab.components.stackable.maxsize
    -- 可堆叠,且堆叠数量大于1
    if maxsize and maxsize > 1 then
        local stacks = math.floor(num / maxsize)
        local left = num - maxsize * stacks
        if stacks > 0 then
            for i = 1, stacks do
                local item = SpawnPrefab(prefa_id)
                item.components.stackable:SetStackSize(maxsize)
                table.insert(res,item)
            end
        end
        if left > 0 then
            local item = SpawnPrefab(prefa_id)
            item.components.stackable:SetStackSize(left)
            table.insert(res,item)
        end
    else -- 不可堆叠
        table.insert(res,prefab)
    end
    return res
end

---抛物品
---@param loot ent 预制物
---@param pt Vector3 坐标
function tool:flingItem(loot, pt)
    if loot ~= nil then
        loot.Transform:SetPosition(pt:Get())

        local min_speed = 0
        local max_speed = 2
        local y_speed = 8
        local y_speed_variance = 4

        if loot.Physics ~= nil then
            local angle = math.random() * TWOPI
            local speed = min_speed + math.random() * (max_speed - min_speed)

            local sinangle = math.sin(angle)
            local cosangle = math.cos(angle)
            loot.Physics:SetVel(speed * cosangle, GetRandomWithVariance(y_speed, y_speed_variance), speed * -sinangle)

            local radius = loot:GetPhysicsRadius(1)
            radius = radius * math.random()
            loot.Transform:SetPosition(pt.x + cosangle * radius,pt.y + 0.5,pt.z - sinangle * radius)
        end
    end
end

---消耗一个物品
---@param itm ent
function tool:consumeOneItem(itm)
    if itm and itm:IsValid() then
        if itm.components.stackable then
            itm.components.stackable:Get():Remove()
        else
            itm:Remove()
        end
    end
end

---通过prefabID查找装备栏的所有装备
---@param player ent # 玩家
---@param equip_prefab string # 装备prefabID
---@return ent[] equips # 所有找到的装备
---@nodiscard
---@return boolean found # 是否找到了至少一个
function tool:findEquipments(player,equip_prefab)
    local equips,found = {},false
    local equip_slots = player and player.components.inventory and player.components.inventory.equipslots
    for _, v in pairs(equip_slots or {}) do
        if v.prefab and v.prefab == equip_prefab then
            table.insert(equips,v)
            found = true
        end
    end
    return equips,found
end

---通过关键字查找装备栏的所有装备
---@param player ent # 玩家
---@param kw string|string[] # 关键字或者关键字数组
---@return ent[] equips # 所有找到的装备
---@nodiscard
---@return boolean found # 是否找到了至少一个
function tool:findEquipmentsWithKeywords(player,kw)
    local equips,found = {},false
    local equip_slots = player and player.components.inventory and player.components.inventory.equipslots
    if type(kw) == 'string' then
        for _, v in pairs(equip_slots or {}) do
            if v.prefab and string.find(v.prefab,kw) then
                table.insert(equips,v)
                found = true
            end
        end
    else
        for _, v in pairs(equip_slots or {}) do
            if v.prefab then
                for _,keyword in ipairs(kw) do
                    if string.find(v.prefab,keyword) then
                        table.insert(equips,v)
                        found = true
                        break
                    end
                end
            end
        end
    end
    return equips,found
end

---获取装备栏的所有装备,假定所有装备中的物品没有重复,返回一个键为prefabID,值为装备实体的表
---@param player ent
---@return table<string,ent> # 返回一个键为prefabID,值为装备实体的表
---@nodiscard
function tool:getAllEquipments(player)
    local equips = {}
    local equip_slots = player and player.components.inventory and player.components.inventory.equipslots
    for _, v in pairs(equip_slots or {}) do
        if v.prefab then
            equips[v.prefab] = v
        end
    end
    return equips
end

local function merge(t1, t2)
    local t = {}
    for k, v in pairs(t1) do
        t[k]=v
    end
    for k, v in pairs(t2) do
        t[k]=v
    end
    return t
end

---分别获取眼石外盒眼石内的装备
---@param inventory Component
---@return table<string, ent>, table<string, ent> # 返回 { prefab: Entity }, { prefab: Entity }
local function getEquipmentForKinds(inventory)
    local equip_slots = inventory and inventory.equipslots or {}
    local inEyestoneEquips = {}
    local outsideEyestoneEquips = {}
    
    local eyestone_slots = {}
    
    for _, v in pairs(equip_slots) do
        -- TODO: PrefabID 聚合管理
        local isEyeStone = v.prefab == 'lol_wp_s9_eyestone_low' or v.prefab == 'lol_wp_s9_eyestone_high'
        if isEyeStone then
            eyestone_slots = v.components.container and v.components.container.slots
        end
        outsideEyestoneEquips[v.prefab] = v
    end
    
    for _, v in pairs(eyestone_slots or {}) do
        inEyestoneEquips[v.prefab] = v
    end

    return outsideEyestoneEquips, inEyestoneEquips
end

---根据 Prefab 分别获取眼石外的装备和眼石内的
---@param inventory Component
---@param prefab string
---@return ent, ent # 返回一个眼石外的装备和眼石内的
function tool:findEquipment(inventory, prefab)
	local outsideEyestoneEquips, insideEyestoneEquips = getEquipmentForKinds(inventory, prefab)
    local equips = merge(outsideEyestoneEquips, insideEyestoneEquips)
    local inEyestone = insideEyestoneEquips[prefab]
    return outsideEyestoneEquips[prefab], insideEyestoneEquips[prefab]
end

---获取所有装备（包括眼石里面的）
---@param inventory Component
---@param prefab string
---@return table<string,ent> # 返回 { prefab: Entity }
function tool:findEquipmentIncludeEyestone(inventory, prefab)
	local outsideEyestoneEquips, insideEyestoneEquips = getEquipmentForKinds(inventory, prefab)
    return merge(outsideEyestoneEquips, insideEyestoneEquips)
end

---对比物品的装备槽位是否和给定的一致
---@param inst ent
---@param prefab string
---@return boolean # 返回 { prefab: Entity }
function tool:isEquipSlot(inst, equipslot)
    if inst and inst.components.equippable then
        return inst.components.equippable.equipslot == equipslot
    end
    return false
end

---真伤
---@param dmg number
---@param victim ent
function tool:dealTrueDmg(dmg,victim)
    if victim and victim:IsValid() and victim.components.health and not victim.components.health:IsDead() then
        local maxhealth = victim.components.health.maxhealth
        local cur_per = victim.components.health:GetPercent()
        local should_hp = math.max(0,maxhealth * cur_per - dmg)
        local should_per = math.min(1,should_hp / maxhealth)
        victim.components.health:SetPercent(should_per)
    end
end

---减少 `rechargeable` 组件的cd(在cd中时)
---@param item ent
---@param reduce number # 减少多少秒, 单位: 秒
function tool:rechargeableReduceCD(item,reduce)
    if item and item:IsValid() and item.components.rechargeable and not item.components.rechargeable:IsCharged() then
        local cur_percent = item.components.rechargeable:GetPercent()
        local chargetime = item.components.rechargeable:GetChargeTime()
        local total = item.components.rechargeable.total
        local new_percent = math.min(1,cur_percent + cur_percent/chargetime)
        item.components.rechargeable:SetCharge(new_percent*total,true)
    end
end

----------------------------------
-- OTHERS
----------------------------------


---闭包: 判断字符串是否不包含指定的所有字符串
---@param ... string 需要判断的字符串长参
---@return fun(string_needcheck:string):boolean
---@nodiscard
function tool:stringNotInclude(...)
    local arg = {...}
    return function (string_needcheck)
        for i,v in ipairs(arg) do
            if string.find(string_needcheck,v) then
                return false
            end
        end
        return true
    end
end

---查找并获取某个上值
---@param fn function
---@param target_name string
---@return any
---@nodiscard
function tool:upvalueFind(fn, target_name)
    local i = 1
    repeat
        local upvalue_name, upvalue_value = debug.getupvalue(fn, i)
        if upvalue_name == target_name then
            return upvalue_value
        end
        i = i + 1
    until not upvalue_name
    return nil
end

---简易装饰器
---@param parent any # 类
---@param field string # 需要勾的字段(方法名)
---@param before_fn nil|fun(self, ...) # 在原函数前执行
---@param after_fn nil|fun(self, ...) # 在原函数后执行
function tool:hookFn(parent,field,before_fn,after_fn)
    if after_fn == nil then
        local old_fn = parent[field]
        parent[field] = function (...)
            if before_fn ~= nil then
                before_fn(...)
            end
            return old_fn(...)
        end
        return
    end
    local old_fn = parent[field]
    parent[field] = function (...)
        if before_fn ~= nil then
            before_fn(...)
        end
        local res = old_fn ~= nil and {old_fn(...)} or {}
        after_fn(...)
        return unpack(res)
    end
end

---简易装饰器
---@param parent any # 类
---@param field string # 需要勾的字段(方法名)
---@param before_fn nil|fun(self, ...):... # 在原函数前执行，返回值会被处理
---@param after_fn nil|fun(self, ...):... # 在原函数后执行
function tool:hookFnHasReturn(parent, field, before_fn, after_fn)
    local old_fn = parent[field]

    if old_fn == nil then
        -- 如果原函数不存在，直接返回
        parent[field] = function(self, ...)
            if before_fn ~= nil then
                before_fn(self, ...)
            end
            if after_fn ~= nil then
                after_fn(self, ...)
            end
        end
        return
    end

    parent[field] = function(self, ...)
        local before_args = {...}
        local before_result = nil

        if before_fn ~= nil then
            before_result = {before_fn(self, unpack(before_args))}
        end

        -- 如果 before_fn 返回了值，则使用这些值作为新的参数
        local args_to_pass = before_result or before_args

        local res = {old_fn(self, unpack(args_to_pass))}

        if after_fn ~= nil then
            after_fn(self, unpack(args_to_pass))
        end

        return unpack(res)
    end
end

---比较浮点数是否相等
---@param a number
---@param b number
---@return boolean
---@nodiscard
function tool:floatEqual(a,b)
    return math.abs(a - b) < self.EPSILON
end

---转义字符串中的特殊字符
local function escape_string(s)
    return string.gsub(s, '"', "\'")
end

---将表转换为字符串(递归打印,注意深度)
---@param t table # 需要转换的表
---@param depth nil|number # 递归深度(不填则无限大)
---@param indent nil|any # 缩进(nil就行)
---@return string # 转换后的字符串
---@nodiscard
function tool:table2string(t, depth, indent)
    -- 递归打印表
    local s = "{\n"
    indent = indent or "\t"
    depth = depth or math.huge  -- 默认深度为无穷大，表示一直递归

    local key_count = 0
    for k, v in pairs(t) do
        key_count = key_count + 1
        if depth <= 0 then
            s = s .. indent .. "[...] = \"...\",\n"
            break
        end

        local new_indent = indent .. "\t"
        local _fix_k = tonumber(k)
        local fix_k
        if _fix_k ~= nil and type(_fix_k) == "number" then
            fix_k = _fix_k
        else
            fix_k = "\"" .. escape_string(tostring(k)) .. "\""
        end

        s = s .. new_indent .. "[" .. fix_k .. "] = "  

        if type(v) == "table" then
            s = s .. self:table2string(v, depth - 1, new_indent)
        else
            s = s .. "\"" .. escape_string(tostring(v)) .. "\""
        end

        if key_count < #t then  
            s = s .. ",\n"
        else
            s = s .. "\n"
        end
    end
    s = s .. indent .. "}"
    return s
end

---将结果打印(宣告)在公屏上
---@param ... string # 需要打印的字符串
function tool:declare(...)
    local s = ''
    for i = 1, select('#', ...) do s = s .. tostring(select(i, ...)) .. ' ' end
    TheNet:Announce(s)
end

---保留几位小数
---@param round number # 保留几位
---@param ... number # 数字
---@return string ... # 结果
---@nodiscard
function tool:fnum(round,...)
    local res = {}
    for i = 1, select('#', ...) do res[i] = string.format('%.'..round..'f', select(i, ...)) end
    return unpack(res)
end

---限制多行字符串每行的最大长度,并换到下一行
---@param str string
---@param line_maxlen integer
---@return string
---@nodiscard
function tool:limitMultiLineStringSingleLineMaxLen(str,line_maxlen)
    local res = ''
    local len = string.utf8len(str)
    local line_len = line_maxlen
    local i = 1

    while i <= len do
        local char = string.utf8sub(str, i, i)
        local char_len = string.utf8len(char)
        local byte = string.byte(char)

        if line_len < char_len then
            res = res .. '\n'
            line_len = line_maxlen
        end

        if char == '\n' then
            res = res .. char
            line_len = line_maxlen
        else
            if byte >= 0x80 then
                -- line_len = line_len - char_len
                line_len = line_len - 1
            else
                line_len = line_len - .5
            end
            res = res .. char
        end

        i = i + 1
    end

    return res
end

return tool