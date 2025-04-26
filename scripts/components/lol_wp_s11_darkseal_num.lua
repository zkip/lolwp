local db = TUNING.MOD_LOL_WP.DARKSEAL

---@class components
---@field lol_wp_s11_darkseal_num component_lol_wp_s11_darkseal_num

local function on_val(self, value)
    self.inst.replica.lol_wp_s11_darkseal_num:SetVal(value)
end


---comment
---@param player ent
local function ondeath_lol_wp_s11_darkseal(player)
    local equips,found = LOLWP_S:findEquipments(player,'lol_wp_s11_darkseal')
    if found then
        for _,equip in ipairs(equips) do
            if equip.components.lol_wp_s11_darkseal_num then
                equip.components.lol_wp_s11_darkseal_num:DoDelta(-db.SKILL_HONOR.PLAYER_DEATH_CONSUME_STACK)
            end
        end
    end
    local ineyestone = LOLWP_U:getEquipInEyeStone(player,'lol_wp_s11_darkseal')
    if ineyestone then
        if ineyestone.components.lol_wp_s11_darkseal_num then
            ineyestone.components.lol_wp_s11_darkseal_num:DoDelta(-db.SKILL_HONOR.PLAYER_DEATH_CONSUME_STACK)
        end
    end
end

---@class component_lol_wp_s11_darkseal_num
---@field inst ent
---@field val integer
local lol_wp_s11_darkseal_num = Class(function(self, inst)
    self.inst = inst
    self.val = 0
end,
nil,
{
    val = on_val,
})

function lol_wp_s11_darkseal_num:OnSave()
    return {
        val = self.val
    }
end

function lol_wp_s11_darkseal_num:OnLoad(data)
    self.val = data.val or 0
end

---comment
---@param inst ent
---@param owner ent
function lol_wp_s11_darkseal_num:WhenEquip(inst,owner)
    owner:ListenForEvent('death',ondeath_lol_wp_s11_darkseal)
end

---comment
---@param inst ent
---@param owner ent
function lol_wp_s11_darkseal_num:WhenUnequip(inst,owner)
    owner:RemoveEventCallback('death',ondeath_lol_wp_s11_darkseal)
end

---comment
---@param targ ent
function lol_wp_s11_darkseal_num:IfBoss(targ)
    return targ and targ:HasTag('epic')
end

function lol_wp_s11_darkseal_num:DoDelta(delta)
    self.val = math.max(0,self.val + delta)
end

function lol_wp_s11_darkseal_num:IsMaxStack()
    return self.val >= db.SKILL_HONOR.MAXSTACK
end

---comment
---@param targ ent
function lol_wp_s11_darkseal_num:WhenKillMob(targ)
    if self:IfBoss(targ) then
        if not self:IsMaxStack() then
            local delta = (self.val + db.SKILL_HONOR.STACK_PER_BOSSSKILL)>db.SKILL_HONOR.MAXSTACK and db.SKILL_HONOR.MAXSTACK-self.val or db.SKILL_HONOR.STACK_PER_BOSSSKILL
            self:DoDelta(delta)

            local fx = SpawnPrefab('cavehole_flick')
            fx.Transform:SetPosition(self.inst:GetPosition():Get())
        end
    end
end

---comment
---@return integer
---@nodiscard
function lol_wp_s11_darkseal_num:GetVal()
    return self.val
end

return lol_wp_s11_darkseal_num